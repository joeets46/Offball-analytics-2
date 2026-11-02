-- =========================================================================
-- tm_axs -- master data
--
-- The event, the customer and the credential. These are the records that
-- transactions point at and that identity resolution has to reconcile against
-- the other nine systems.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Event. The operational event record and the primary source for the target
-- model's anchor table, event.fixture.
--
-- The target fixture carries 52 columns covering identity, schedule, result and
-- post-event reconciliation at once. Only the first two of those belong to a
-- ticketing system: the result comes from Hudl and the financial
-- reconciliation from SAP. What is here is what TM/AXS can actually assert.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.event (
    event_id            BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_code          common.dom_fixture_code NOT NULL UNIQUE,
    event_name          VARCHAR(200) NOT NULL,
    event_type_id       INTEGER      NOT NULL,
    venue_ref_id        INTEGER      NOT NULL,
    season_id           INTEGER,
    event_group_id      INTEGER,

    -- Scheduling. Stored as TIMESTAMPTZ throughout; local_timezone on the venue
    -- is what renders a local time, and event_date is the local calendar date,
    -- which is not derivable from the UTC instant alone near midnight.
    event_date          DATE         NOT NULL,
    scheduled_start_at  TIMESTAMPTZ  NOT NULL,
    scheduled_end_at    TIMESTAMPTZ,
    doors_open_at       TIMESTAMPTZ,
    actual_start_at     TIMESTAMPTZ,
    actual_end_at       TIMESTAMPTZ,

    -- Lifecycle. Legal transitions are enumerated in
    -- tm_axs.event_status_transition.
    lifecycle_status    VARCHAR(20)  NOT NULL DEFAULT 'announced'
        CHECK (lifecycle_status IN
            ('announced','confirmed','in_progress','completed','cancelled','postponed')),
    announced_at        TIMESTAMPTZ,
    confirmed_at        TIMESTAMPTZ,
    cancelled_at        TIMESTAMPTZ,

    -- Commercial flags that drive ticketing behaviour.
    event_tier          VARCHAR(20)
        CHECK (event_tier IS NULL OR event_tier IN
            ('regular_season','playoff','championship','special_event','preseason','postseason')),
    is_ppv              BOOLEAN      NOT NULL DEFAULT FALSE,
    is_neutral_site     BOOLEAN      NOT NULL DEFAULT FALSE,
    is_broadcast_eligible BOOLEAN    NOT NULL DEFAULT TRUE,
    on_sale_at          TIMESTAMPTZ,
    presale_at          TIMESTAMPTZ,

    -- Capacity and attendance. The target model declares its equivalents as INT
    -- in model.json but emits them as STRING in the deployable DDL; see
    -- docs/04-physical-model-target.md.
    announced_capacity  INTEGER      CHECK (announced_capacity IS NULL OR announced_capacity >= 0),
    actual_attendance   INTEGER      CHECK (actual_attendance IS NULL OR actual_attendance >= 0),

    -- Business keys into other systems. None can be a foreign key.
    archtics_event_code VARCHAR(30),
    sap_profit_center   VARCHAR(10),

    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    -- Optimistic locking: on-sale traffic has many concurrent writers.
    row_version         INTEGER      NOT NULL DEFAULT 1,

    CONSTRAINT ck_event_schedule_order
        CHECK (scheduled_end_at IS NULL OR scheduled_end_at > scheduled_start_at),
    CONSTRAINT ck_event_actual_order
        CHECK (actual_end_at IS NULL OR actual_start_at IS NULL OR actual_end_at >= actual_start_at),
    CONSTRAINT ck_event_doors_before_start
        CHECK (doors_open_at IS NULL OR doors_open_at <= scheduled_start_at),
    -- A cancelled event must say when, and a live one must not claim to be.
    CONSTRAINT ck_event_cancelled_has_timestamp
        CHECK ((lifecycle_status = 'cancelled') = (cancelled_at IS NOT NULL)),
    CONSTRAINT ck_event_attendance_within_capacity
        CHECK (actual_attendance IS NULL OR announced_capacity IS NULL
               OR actual_attendance <= announced_capacity)
);

COMMENT ON TABLE tm_axs.event IS
    'Operational event record. Primary source for target event.fixture, joined '
    'with archtics.event_manifest for capacity and hudl.game for result.';
COMMENT ON COLUMN tm_axs.event.event_date IS
    'Local calendar date at the venue. Retained separately from '
    'scheduled_start_at because the UTC instant alone does not determine it.';
COMMENT ON COLUMN tm_axs.event.archtics_event_code IS
    'Business key into archtics.event_manifest. Resolved through '
    'common.entity_xref on entity_type = fixture. Not a foreign key.';

-- -------------------------------------------------------------------------
-- Customer account.
--
-- One of four places the same human exists: here, sfdc_crm.contact,
-- shopify.customer and adobe_aep.profile. The target model collapses them into
-- fan.fan_profile, which is why `fan` is a canonical entity.
--
-- Identifying PII lives in the satellite table in 31_master_pii.sql so the
-- bulk of ticketing queries never touch restricted columns.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.customer_account (
    customer_account_id BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_number      common.dom_account_number NOT NULL UNIQUE,
    -- citext via the domain: operators re-enter addresses with different
    -- capitalisation, and a case-sensitive unique index lets duplicates in.
    email               common.dom_email,
    account_status      VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (account_status IN ('active','inactive','suspended','closed','merged')),
    account_type        VARCHAR(20)  NOT NULL DEFAULT 'individual'
        CHECK (account_type IN ('individual','corporate','group','reseller','internal')),
    -- Where the account came from, which matters for consent provenance.
    origin_channel_code VARCHAR(20),
    first_purchase_at   TIMESTAMPTZ,
    last_purchase_at    TIMESTAMPTZ,
    lifetime_order_count INTEGER     NOT NULL DEFAULT 0 CHECK (lifetime_order_count >= 0),
    -- Soft merge: TM/AXS marks a duplicate as merged and points at the survivor
    -- rather than deleting, so historical orders keep resolving.
    merged_into_customer_account_id BIGINT,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    row_version         INTEGER      NOT NULL DEFAULT 1,

    CONSTRAINT ck_customer_merge_target_differs
        CHECK (merged_into_customer_account_id IS NULL
               OR merged_into_customer_account_id <> customer_account_id),
    CONSTRAINT ck_customer_merged_status
        CHECK ((account_status = 'merged') = (merged_into_customer_account_id IS NOT NULL)),
    CONSTRAINT ck_customer_deleted_has_timestamp
        CHECK (is_deleted = (deleted_at IS NOT NULL)),
    CONSTRAINT ck_customer_purchase_order
        CHECK (last_purchase_at IS NULL OR first_purchase_at IS NULL
               OR last_purchase_at >= first_purchase_at)
);

COMMENT ON COLUMN tm_axs.customer_account.merged_into_customer_account_id IS
    'Self-reference to the surviving account. The upstream model tags 22 '
    'columns self_ref_fk; duplicate-merge chains are the commonest case.';

-- -------------------------------------------------------------------------
-- Tokenized payment instrument. Feeds target fan.payment_method.
--
-- No primary account number is stored. Under PCI-DSS the card lives at the
-- processor and this table holds a token plus the display fragments, which is
-- what makes it safe for the target model to carry payment attributes on a
-- fan record at all.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.payment_method (
    payment_method_id   BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_account_id BIGINT       NOT NULL,
    -- The processor token is the only card reference stored.
    processor_token     VARCHAR(80)  NOT NULL,
    processor_name      VARCHAR(40)  NOT NULL,
    instrument_type     VARCHAR(20)  NOT NULL
        CHECK (instrument_type IN ('card','wallet','bank_transfer','gift_card','account_credit')),
    card_brand          VARCHAR(20)
        CHECK (card_brand IS NULL OR card_brand IN
            ('Visa','Mastercard','Amex','Discover','UnionPay','Other')),
    card_last_four      common.dom_card_last_four,
    expiry_month        SMALLINT     CHECK (expiry_month IS NULL OR expiry_month BETWEEN 1 AND 12),
    expiry_year         SMALLINT     CHECK (expiry_year IS NULL OR expiry_year BETWEEN 2000 AND 2100),
    billing_postal_code VARCHAR(20),
    billing_country_code common.dom_iso3_code,
    is_default          BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (processor_name, processor_token),
    -- Card details only make sense on a card.
    CONSTRAINT ck_payment_method_card_fields
        CHECK (instrument_type = 'card'
               OR (card_brand IS NULL AND card_last_four IS NULL
                   AND expiry_month IS NULL AND expiry_year IS NULL))
);

COMMENT ON TABLE tm_axs.payment_method IS
    'Tokenized instruments only -- no primary account number is stored, per '
    'PCI-DSS. Shopify holds a parallel set for merchandise; target '
    'fan.payment_method is a union of the two deduplicated on token.';

-- -------------------------------------------------------------------------
-- Credential. Non-ticket access: staff, media, athletes, officials, vendors.
-- Feeds target security.credential.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.credential (
    credential_id       BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    credential_code     VARCHAR(30)  NOT NULL UNIQUE,
    credential_type     VARCHAR(20)  NOT NULL
        CHECK (credential_type IN
            ('staff','media','athlete','official','vendor','contractor','vip','law_enforcement')),
    holder_name         VARCHAR(160) NOT NULL,
    holder_organization VARCHAR(160),
    -- Business keys to the systems that own the person. Which one applies
    -- depends on credential_type, so neither can be mandatory.
    sfsf_person_id      VARCHAR(40),
    sfdc_contact_id     CHAR(18),
    -- Compared against access_zone.clearance_level at scan time.
    clearance_level     SMALLINT     NOT NULL CHECK (clearance_level BETWEEN 1 AND 5),
    photo_on_file       BOOLEAN      NOT NULL DEFAULT FALSE,
    background_check_status VARCHAR(20) NOT NULL DEFAULT 'not_required'
        CHECK (background_check_status IN ('not_required','pending','cleared','failed','expired')),
    valid_from          DATE         NOT NULL,
    valid_to            DATE         NOT NULL,
    revoked_at          TIMESTAMPTZ,
    revocation_reason   VARCHAR(200),
    display_colour      common.dom_color_code,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_credential_validity CHECK (valid_to >= valid_from),
    CONSTRAINT ck_credential_revocation_reason
        CHECK ((revoked_at IS NULL) = (revocation_reason IS NULL)),
    -- Clearance 4 and 5 reach restricted and field-of-play zones, so a cleared
    -- background check is a precondition rather than a later workflow step.
    CONSTRAINT ck_credential_clearance_requires_check
        CHECK (clearance_level < 4 OR background_check_status = 'cleared')
);

-- -------------------------------------------------------------------------
-- Per-event sellable inventory, as TM/AXS sees it.
--
-- Archtics owns the manifest; this is the selling system mirror of it. The two
-- drift during an on-sale and reconciling them is a standing operational task,
-- which is why target ticketing.ticket_inventory maps to Archtics, not here.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.ticket_inventory (
    ticket_inventory_id BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            BIGINT       NOT NULL,
    price_zone_id       INTEGER      NOT NULL,
    -- Seat coordinates as labels: the selling system receives them from the
    -- manifest and does not own the seating topology.
    section_label       VARCHAR(20)  NOT NULL,
    row_label           VARCHAR(10)  NOT NULL,
    seat_label          VARCHAR(10)  NOT NULL,
    archtics_seat_key   VARCHAR(60),
    inventory_status    VARCHAR(20)  NOT NULL DEFAULT 'available'
        CHECK (inventory_status IN
            ('available','held','reserved','sold','killed','comp','returned')),
    is_ada              BOOLEAN      NOT NULL DEFAULT FALSE,
    is_companion_seat   BOOLEAN      NOT NULL DEFAULT FALSE,
    is_obstructed_view  BOOLEAN      NOT NULL DEFAULT FALSE,
    last_status_change_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    row_version         INTEGER      NOT NULL DEFAULT 1,

    -- One physical seat sells once per event.
    UNIQUE (event_id, section_label, row_label, seat_label)
);

COMMENT ON TABLE tm_axs.ticket_inventory IS
    'The selling system mirror of the Archtics manifest. Drifts from '
    'archtics.event_manifest during an on-sale; Archtics is authoritative.';
