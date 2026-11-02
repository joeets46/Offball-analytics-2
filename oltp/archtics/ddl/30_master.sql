-- =========================================================================
-- archtics -- master data
--
-- The manifest structures and the season-ticket book.
--
-- The manifest/event_manifest split is the important shape here. A manifest is
-- a reusable seating configuration; an event_manifest is one applied to one
-- fixture. The target venue.capacity_config collapses both into a single row
-- per configuration, so the reuse -- one "Concert End Stage" manifest serving
-- forty events -- disappears on the way into the lakehouse.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Manifest. A named, reusable seating configuration for a building.
-- Feeds target venue.capacity_config.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.manifest (
    manifest_id         INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_id         INTEGER      NOT NULL,
    manifest_code       common.dom_fixture_code NOT NULL,
    manifest_name       VARCHAR(80)  NOT NULL,
    configuration_type  VARCHAR(30)  NOT NULL
        CHECK (configuration_type IN
            ('full_bowl', 'end_stage', 'in_the_round', 'half_house', 'theatre',
             'field_sport', 'court_sport', 'ice', 'custom')),
    -- Capacity is stored rather than computed: it is a contractual and
    -- regulatory figure signed off by the fire authority, not simply the count
    -- of rows in manifest_section.
    total_capacity      INTEGER      NOT NULL CHECK (total_capacity >= 0),
    sellable_capacity   INTEGER      NOT NULL CHECK (sellable_capacity >= 0),
    ada_capacity        INTEGER      NOT NULL DEFAULT 0 CHECK (ada_capacity >= 0),
    standing_capacity   INTEGER      NOT NULL DEFAULT 0 CHECK (standing_capacity >= 0),
    -- Fire-authority sign-off. A manifest cannot be used on an event without
    -- it, which the application enforces at event_manifest creation.
    fire_cert_reference VARCHAR(40),
    fire_cert_expires_on DATE,
    manifest_status     VARCHAR(20)  NOT NULL DEFAULT 'draft'
        CHECK (manifest_status IN ('draft', 'approved', 'active', 'superseded', 'retired')),
    version_number      INTEGER      NOT NULL DEFAULT 1 CHECK (version_number > 0),
    -- Supersession chain, so a historical event keeps pointing at the manifest
    -- as it was when the event was played.
    supersedes_manifest_id INTEGER,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (building_id, manifest_code, version_number),
    CONSTRAINT ck_manifest_sellable_within_total
        CHECK (sellable_capacity <= total_capacity),
    CONSTRAINT ck_manifest_not_self_superseding
        CHECK (supersedes_manifest_id IS NULL OR supersedes_manifest_id <> manifest_id),
    -- An approved or active manifest must carry a valid fire certificate.
    CONSTRAINT ck_manifest_approved_needs_cert
        CHECK (manifest_status NOT IN ('approved', 'active')
               OR (fire_cert_reference IS NOT NULL AND fire_cert_expires_on IS NOT NULL))
);

COMMENT ON COLUMN archtics.manifest.total_capacity IS
    'Stated capacity, not a count of manifest_section rows. It is signed off by '
    'the fire authority and is the figure reported to the league.';

-- -------------------------------------------------------------------------
-- Manifest section allocation. Which sections a manifest uses and for what.
-- Feeds target venue.config_section_allocation -- one of only six associative
-- tables the upstream MVM retains.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.manifest_section (
    manifest_id         INTEGER      NOT NULL,
    section_id          INTEGER      NOT NULL,
    allocation_type     VARCHAR(20)  NOT NULL
        CHECK (allocation_type IN
            ('sellable', 'killed', 'production', 'visiting_support', 'press',
             'accessible', 'standing', 'suite_only')),
    allocated_seat_count INTEGER     NOT NULL CHECK (allocated_seat_count >= 0),
    -- A manifest may relabel a section for a given configuration: section 101
    -- becomes "Floor C" for an end-stage concert.
    override_label      VARCHAR(20),
    price_zone_hint     VARCHAR(20),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (manifest_id, section_id)
);

-- -------------------------------------------------------------------------
-- Event manifest. A manifest applied to one fixture.
--
-- This is what makes archtics authoritative for target
-- ticketing.ticket_inventory: the per-event seat availability derives from
-- here, and TM/AXS mirrors it.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.event_manifest (
    event_manifest_id   BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- The business key into the selling system. Archtics does not hold the
    -- TM/AXS event id, so this is the operator-entered code.
    tm_event_code       VARCHAR(30)  NOT NULL,
    building_id         INTEGER      NOT NULL,
    manifest_id         INTEGER      NOT NULL,
    event_date          DATE         NOT NULL,
    event_name          VARCHAR(200) NOT NULL,
    -- Event-specific adjustments to the manifest capacity: weather closures,
    -- a reduced-capacity directive, an unexpected kill.
    adjusted_capacity   INTEGER      CHECK (adjusted_capacity IS NULL OR adjusted_capacity >= 0),
    adjustment_reason   VARCHAR(200),
    seats_sold          INTEGER      NOT NULL DEFAULT 0 CHECK (seats_sold >= 0),
    seats_held          INTEGER      NOT NULL DEFAULT 0 CHECK (seats_held >= 0),
    seats_killed        INTEGER      NOT NULL DEFAULT 0 CHECK (seats_killed >= 0),
    -- Reconciled attendance, which is the gate count, not the sold count.
    turnstile_count     INTEGER      CHECK (turnstile_count IS NULL OR turnstile_count >= 0),
    manifest_locked_at  TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    row_version         INTEGER      NOT NULL DEFAULT 1,

    UNIQUE (tm_event_code),
    CONSTRAINT ck_event_manifest_adjustment_reason
        CHECK ((adjusted_capacity IS NULL) = (adjustment_reason IS NULL))
);

COMMENT ON COLUMN archtics.event_manifest.tm_event_code IS
    'Business key into tm_axs.event.event_code. Not a foreign key -- different '
    'database. The pair is resolved through common.entity_xref.';
COMMENT ON COLUMN archtics.event_manifest.turnstile_count IS
    'Gate count, which is what the target fixture.actual_attendance receives. '
    'Differs from seats_sold by no-shows, and the gap is the point.';

-- -------------------------------------------------------------------------
-- Season-ticket account. Feeds target ticketing.season_ticket_account and
-- target fan.membership.
--
-- A fifth place the same human exists. Season-ticket holders are the highest-
-- value fans in the model and the hardest to resolve, because the account is
-- often held by a company or a family rather than the person who attends.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.sta_account (
    sta_account_id      BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_number      common.dom_account_number NOT NULL UNIQUE,
    account_name        VARCHAR(160) NOT NULL,
    account_type        VARCHAR(20)  NOT NULL
        CHECK (account_type IN ('individual', 'corporate', 'family', 'group', 'broker', 'internal')),
    primary_email       common.dom_email,
    primary_phone       VARCHAR(32),
    -- Tenure drives relocation priority, which is the single most contested
    -- piece of logic in season-ticket administration.
    tenure_start_season SMALLINT     CHECK (tenure_start_season IS NULL OR tenure_start_season BETWEEN 1850 AND 2200),
    consecutive_seasons SMALLINT     NOT NULL DEFAULT 0 CHECK (consecutive_seasons >= 0),
    priority_score      NUMERIC(10,4) NOT NULL DEFAULT 0 CHECK (priority_score >= 0),
    account_status      VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (account_status IN ('active', 'lapsed', 'suspended', 'cancelled', 'waitlist')),
    -- Business keys outward. The CRM record is the commercial relationship;
    -- the TM/AXS account is where single-game purchases land.
    sfdc_account_id     CHAR(18),
    tm_account_number   VARCHAR(10),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN archtics.sta_account.priority_score IS
    'Relocation and renewal priority. Derived from tenure, spend and account '
    'standing by rules that live in the application, not here.';

-- -------------------------------------------------------------------------
-- Plan. A season-ticket product: full season, half season, a ten-game pack.
-- Feeds target ticketing.season_ticket_package.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.plan (
    plan_id             INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_id         INTEGER      NOT NULL,
    plan_code           VARCHAR(20)  NOT NULL,
    plan_name           VARCHAR(80)  NOT NULL,
    season_year         SMALLINT     NOT NULL CHECK (season_year BETWEEN 1850 AND 2200),
    plan_type           VARCHAR(20)  NOT NULL
        CHECK (plan_type IN ('full_season', 'half_season', 'quarter_season', 'game_pack', 'flex', 'suite', 'mini_plan')),
    included_event_count SMALLINT    NOT NULL CHECK (included_event_count > 0),
    -- Plans are sold against a list price and discounted per account; the
    -- realised price lives on the assignment.
    list_price_per_seat NUMERIC(18,4) NOT NULL CHECK (list_price_per_seat >= 0),
    currency_code       common.dom_iso3_code NOT NULL,
    payment_frequency   VARCHAR(20)  NOT NULL DEFAULT 'annual'
        CHECK (payment_frequency IN ('annual', 'semi_annual', 'quarterly', 'monthly', 'one_time')),
    includes_playoffs   BOOLEAN      NOT NULL DEFAULT FALSE,
    includes_parking    BOOLEAN      NOT NULL DEFAULT FALSE,
    on_sale_from        DATE,
    renewal_deadline    DATE,
    plan_status         VARCHAR(20)  NOT NULL DEFAULT 'draft'
        CHECK (plan_status IN ('draft', 'on_sale', 'sold_out', 'closed', 'cancelled')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (building_id, plan_code, season_year)
);

-- -------------------------------------------------------------------------
-- Plan seat inventory. Which seats a plan may be sold against.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.plan_seat (
    plan_id             INTEGER      NOT NULL,
    seat_id             BIGINT       NOT NULL,
    -- Price may be overridden per seat within a plan: the same plan costs more
    -- centre-court than in a corner.
    seat_price          NUMERIC(18,4) CHECK (seat_price IS NULL OR seat_price >= 0),
    availability_status VARCHAR(20)  NOT NULL DEFAULT 'available'
        CHECK (availability_status IN ('available', 'assigned', 'held', 'unavailable')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (plan_id, seat_id)
);

-- -------------------------------------------------------------------------
-- Personal seat licence. A property right in a seat, separable from any
-- season ticket and tradeable on its own.
--
-- The target model has no equivalent: ticketing.season_ticket_account carries
-- a few PSL columns inline. A PSL outliving the account that holds it is
-- exactly the kind of fact a denormalized model cannot represent.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.psl (
    psl_id              BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    psl_number          VARCHAR(30)  NOT NULL UNIQUE,
    seat_id             BIGINT       NOT NULL,
    -- Null while the licence is unsold or between holders.
    holder_sta_account_id BIGINT,
    original_price      NUMERIC(18,4) NOT NULL CHECK (original_price >= 0),
    currency_code       common.dom_iso3_code NOT NULL,
    issued_on           DATE         NOT NULL,
    term_years          SMALLINT     CHECK (term_years IS NULL OR term_years > 0),
    expires_on          DATE,
    -- A PSL obliges the holder to buy the season ticket; lapsing forfeits it.
    psl_status          VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (psl_status IN ('unsold', 'active', 'in_transfer', 'forfeited', 'expired', 'bought_back')),
    is_transferable     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- One live licence per seat.
    CONSTRAINT ck_psl_expiry_after_issue
        CHECK (expires_on IS NULL OR expires_on > issued_on),
    CONSTRAINT ck_psl_active_has_holder
        CHECK (psl_status <> 'active' OR holder_sta_account_id IS NOT NULL)
);

COMMENT ON TABLE archtics.psl IS
    'Personal seat licence -- a property right in a seat, independent of any '
    'season ticket. No target table corresponds; a few columns on '
    'ticketing.season_ticket_account are all that survives.';

-- -------------------------------------------------------------------------
-- Suite lease. The commercial side sits in SAP; this is the occupancy right.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.suite_lease (
    suite_lease_id      BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    suite_id            INTEGER      NOT NULL,
    sta_account_id      BIGINT,
    lease_reference     VARCHAR(30)  NOT NULL UNIQUE,
    lessee_name         VARCHAR(160) NOT NULL,
    lease_type          VARCHAR(20)  NOT NULL
        CHECK (lease_type IN ('multi_year', 'annual', 'single_event', 'shared', 'rental')),
    starts_on           DATE         NOT NULL,
    ends_on             DATE         NOT NULL,
    annual_fee          NUMERIC(18,4) CHECK (annual_fee IS NULL OR annual_fee >= 0),
    currency_code       common.dom_iso3_code,
    included_tickets    SMALLINT     NOT NULL DEFAULT 0 CHECK (included_tickets >= 0),
    -- Business key into the SAP contract that carries the money.
    sap_contract_number VARCHAR(10),
    lease_status        VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (lease_status IN ('pending', 'active', 'expired', 'terminated', 'renewed')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_suite_lease_dates CHECK (ends_on > starts_on),
    CONSTRAINT ck_suite_lease_fee_currency
        CHECK ((annual_fee IS NULL) = (currency_code IS NULL))
);
