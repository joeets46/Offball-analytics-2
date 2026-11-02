-- =========================================================================
-- tm_axs -- reference data
--
-- Configuration the operator maintains and transactions reference: event
-- classification, the system's own venue copy, price structures and gates.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Event type. Feeds target event.type.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.event_type (
    event_type_id    INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_type_code  VARCHAR(20)  NOT NULL UNIQUE,
    event_type_name  VARCHAR(60)  NOT NULL,
    -- The target model's event.fixture handles matches, concerts, PPV, drafts
    -- and award shows in one table with nullable columns. The category here is
    -- what the logical model turns into an event subtype.
    category         VARCHAR(20)  NOT NULL
        CHECK (category IN ('competition', 'concert', 'ppv', 'ceremony', 'exhibition', 'other')),
    -- Competitions have a result; concerts do not.
    has_competitive_result BOOLEAN NOT NULL DEFAULT FALSE,
    default_duration_minutes INTEGER
        CHECK (default_duration_minutes IS NULL OR default_duration_minutes > 0),
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Venue, as TM/AXS holds it.
--
-- This is deliberately a separate record from archtics.building and
-- sap_s4.t001w. All three describe the same physical building and none of them
-- shares a key with the others -- the single clearest illustration of why the
-- target model's uniform venue_id is a product of integration rather than
-- something any source system hands over.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.venue_ref (
    venue_ref_id      INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    venue_code        VARCHAR(20)  NOT NULL UNIQUE,
    venue_name        VARCHAR(120) NOT NULL,
    city              VARCHAR(80)  NOT NULL,
    state_province    common.dom_state_province,
    country_code      common.dom_iso3_code NOT NULL,
    postal_code       VARCHAR(20),
    local_timezone    common.dom_iana_timezone NOT NULL,
    -- TM/AXS tracks a sellable capacity that may differ from the Archtics
    -- manifest total, because holds and kills are applied differently.
    sellable_capacity INTEGER      CHECK (sellable_capacity IS NULL OR sellable_capacity >= 0),
    -- The operator-entered link to the seating system. Nullable and
    -- unenforceable: it is a business key into another database.
    archtics_building_code VARCHAR(20),
    is_active         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN tm_axs.venue_ref.archtics_building_code IS
    'Business key into archtics.building. Not a foreign key -- different '
    'database. Resolved through common.entity_xref on entity_type = ''venue''.';

-- -------------------------------------------------------------------------
-- Season. A selling period, not a competition structure.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.season (
    season_id       INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    season_code     VARCHAR(20)  NOT NULL UNIQUE,
    season_name     VARCHAR(80)  NOT NULL,
    season_year     INTEGER      NOT NULL CHECK (season_year BETWEEN 1850 AND 2200),
    starts_on       DATE         NOT NULL,
    ends_on         DATE         NOT NULL,
    on_sale_opens_at TIMESTAMPTZ,
    renewal_deadline DATE,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT ck_season_dates CHECK (ends_on >= starts_on)
);

-- -------------------------------------------------------------------------
-- Event group. A self-referencing hierarchy used for series, tournaments and
-- rounds.
--
-- The target model splits this one structure into four separate tables --
-- event.tournament, event.bracket, event.competition_round and part of
-- event.calendar. TM/AXS has only the grouping, which is why those three
-- mappings carry confidence `low` in mapping/table_level_mapping.csv. The
-- upstream model tags 22 columns `self_ref_fk`; this is one of them.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.event_group (
    event_group_id    INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_group_code  VARCHAR(30)  NOT NULL UNIQUE,
    event_group_name  VARCHAR(120) NOT NULL,
    group_level       VARCHAR(20)  NOT NULL
        CHECK (group_level IN ('series', 'tournament', 'phase', 'round', 'matchday')),
    parent_event_group_id INTEGER,
    season_id         INTEGER,
    sort_order        INTEGER      NOT NULL DEFAULT 0,
    is_active         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    -- A group cannot be its own parent. Deeper cycles need application or
    -- trigger enforcement; this catches the common mistake.
    CONSTRAINT ck_event_group_not_self_parent
        CHECK (parent_event_group_id IS NULL OR parent_event_group_id <> event_group_id)
);

-- -------------------------------------------------------------------------
-- Price structures. Feeds target ticketing.price_tier and ticketing.price_zone.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.price_zone (
    price_zone_id    INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    venue_ref_id     INTEGER      NOT NULL,
    price_zone_code  VARCHAR(20)  NOT NULL,
    price_zone_name  VARCHAR(60)  NOT NULL,
    -- Rank orders zones by desirability, which is what dynamic pricing walks.
    zone_rank        INTEGER      NOT NULL CHECK (zone_rank > 0),
    display_colour   common.dom_color_code,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (venue_ref_id, price_zone_code)
);

CREATE TABLE tm_axs.price_scale (
    price_scale_id   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id         BIGINT       NOT NULL,
    price_scale_code VARCHAR(20)  NOT NULL,
    price_scale_name VARCHAR(60)  NOT NULL,
    currency_code    common.dom_iso3_code NOT NULL,
    -- Dynamic pricing rescales during the on-sale; the scale is versioned so
    -- past orders can be explained.
    version_number   INTEGER      NOT NULL DEFAULT 1 CHECK (version_number > 0),
    effective_from   TIMESTAMPTZ  NOT NULL,
    effective_to     TIMESTAMPTZ,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (event_id, price_scale_code, version_number),
    CONSTRAINT ck_price_scale_window CHECK (effective_to IS NULL OR effective_to > effective_from)
);

CREATE TABLE tm_axs.price_level (
    price_level_id   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    price_scale_id   INTEGER      NOT NULL,
    price_zone_id    INTEGER      NOT NULL,
    price_level_code VARCHAR(20)  NOT NULL,
    -- Face value is what prints on the ticket and what the league reports;
    -- fees are additive and settle to different parties.
    face_value       NUMERIC(18,4) NOT NULL CHECK (face_value >= 0),
    service_fee      NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (service_fee >= 0),
    facility_fee     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (facility_fee >= 0),
    tax_amount       NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (tax_amount >= 0),
    -- Generated so the application can never disagree with itself on totals.
    total_price      NUMERIC(18,4) NOT NULL
        GENERATED ALWAYS AS (face_value + service_fee + facility_fee + tax_amount) STORED,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (price_scale_id, price_zone_id, price_level_code)
);

COMMENT ON COLUMN tm_axs.price_level.total_price IS
    'Generated column. The target model stores a single ticket price; this is '
    'the figure it receives, with the component split retained here.';

-- -------------------------------------------------------------------------
-- Promotional codes.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.promo_code (
    promo_code_id    INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    promo_code       CITEXT       NOT NULL UNIQUE,
    description      VARCHAR(200) NOT NULL,
    discount_type    VARCHAR(20)  NOT NULL
        CHECK (discount_type IN ('percent', 'fixed_amount', 'fee_waiver', 'bogo')),
    discount_value   NUMERIC(18,4) NOT NULL CHECK (discount_value >= 0),
    -- A percentage discount above 100 is always an error.
    CONSTRAINT ck_promo_percent_bound
        CHECK (discount_type <> 'percent' OR discount_value <= 100),
    max_redemptions  INTEGER      CHECK (max_redemptions IS NULL OR max_redemptions > 0),
    redemption_count INTEGER      NOT NULL DEFAULT 0 CHECK (redemption_count >= 0),
    valid_from       TIMESTAMPTZ  NOT NULL,
    valid_to         TIMESTAMPTZ,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT ck_promo_window CHECK (valid_to IS NULL OR valid_to > valid_from),
    CONSTRAINT ck_promo_not_overredeemed
        CHECK (max_redemptions IS NULL OR redemption_count <= max_redemptions)
);

-- -------------------------------------------------------------------------
-- Access topology: zones, gates and screening points.
--
-- Feeds target security.access_zone, security.screening_checkpoint and the
-- gate side of ticketing.gate_scan.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.access_zone (
    access_zone_id   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    venue_ref_id     INTEGER      NOT NULL,
    access_zone_code VARCHAR(20)  NOT NULL,
    access_zone_name VARCHAR(60)  NOT NULL,
    -- Clearance ranks nest: a zone requires at least this level on the
    -- presented credential.
    clearance_level  SMALLINT     NOT NULL CHECK (clearance_level BETWEEN 1 AND 5),
    zone_category    VARCHAR(20)  NOT NULL
        CHECK (zone_category IN ('public', 'premium', 'operational', 'restricted', 'field_of_play')),
    display_colour   common.dom_color_code,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (venue_ref_id, access_zone_code)
);

CREATE TABLE tm_axs.access_point (
    access_point_id  INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    venue_ref_id     INTEGER      NOT NULL,
    access_zone_id   INTEGER      NOT NULL,
    access_point_code VARCHAR(20) NOT NULL,
    access_point_name VARCHAR(60) NOT NULL,
    point_type       VARCHAR(20)  NOT NULL
        CHECK (point_type IN ('turnstile', 'door', 'gate', 'elevator', 'checkpoint', 'mobile_reader')),
    direction        VARCHAR(10)  NOT NULL DEFAULT 'entry'
        CHECK (direction IN ('entry', 'exit', 'both')),
    -- Throughput drives queue modelling and doors-open planning.
    throughput_per_hour INTEGER   CHECK (throughput_per_hour IS NULL OR throughput_per_hour > 0),
    is_ada_accessible BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (venue_ref_id, access_point_code)
);

CREATE TABLE tm_axs.screening_checkpoint (
    screening_checkpoint_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    access_point_id  INTEGER      NOT NULL,
    checkpoint_code  VARCHAR(20)  NOT NULL UNIQUE,
    checkpoint_name  VARCHAR(60)  NOT NULL,
    screening_type   VARCHAR(20)  NOT NULL
        CHECK (screening_type IN ('walk_through_md', 'hand_wand', 'bag_search', 'x_ray', 'visual', 'canine')),
    lane_count       SMALLINT     NOT NULL DEFAULT 1 CHECK (lane_count > 0),
    staff_required   SMALLINT     NOT NULL DEFAULT 1 CHECK (staff_required >= 0),
    config_version   common.dom_version,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now()
);
