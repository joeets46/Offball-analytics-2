-- =========================================================================
-- archtics -- reference data and the physical seating hierarchy
--
-- The hierarchy is the whole point of this schema, so it lives together:
-- building -> level -> section -> seat_row -> seat. The target model flattens
-- all five into venue.venue, venue.seating_section and venue.seat, which is
-- why `seating_section` maps here as a join of two levels rather than one.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Seat attribute vocabulary. Restored from the upstream model's declared
-- value domains: the target venue.seat and venue.accessibility_feature carry
-- these as a spread of boolean and STRING columns.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.seat_attribute (
    seat_attribute_id   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    attribute_code      VARCHAR(20)  NOT NULL UNIQUE,
    attribute_name      VARCHAR(60)  NOT NULL,
    attribute_category  VARCHAR(20)  NOT NULL
        CHECK (attribute_category IN ('accessibility', 'sightline', 'comfort', 'restriction', 'amenity')),
    -- ADA-relevant attributes drive statutory capacity ratios, so they are
    -- flagged rather than inferred from the category.
    is_ada_relevant     BOOLEAN      NOT NULL DEFAULT FALSE,
    -- Reduces sellable capacity when present.
    reduces_capacity    BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

INSERT INTO archtics.seat_attribute
    (attribute_code, attribute_name, attribute_category, is_ada_relevant, reduces_capacity)
VALUES
    ('WHEELCHAIR',    'Wheelchair space',          'accessibility', TRUE,  FALSE),
    ('COMPANION',     'ADA companion seat',        'accessibility', TRUE,  FALSE),
    ('TRANSFER',      'Transfer seat',             'accessibility', TRUE,  FALSE),
    ('SEMI_AMBULANT', 'Semi-ambulant',             'accessibility', TRUE,  FALSE),
    ('AISLE',         'Aisle seat',                'comfort',       FALSE, FALSE),
    ('EXTRA_LEGROOM', 'Extra legroom',             'comfort',       FALSE, FALSE),
    ('OBSTRUCTED',    'Obstructed view',           'sightline',     FALSE, FALSE),
    ('PARTIAL_VIEW',  'Partial view',              'sightline',     FALSE, FALSE),
    ('BEHIND_STAGE',  'Behind stage',              'sightline',     FALSE, TRUE),
    ('CAMERA_PLATFORM','Camera platform -- killed','restriction',   FALSE, TRUE),
    ('IN_SEAT_SERVICE','In-seat food service',     'amenity',       FALSE, FALSE),
    ('CLUB_ACCESS',   'Club lounge access',        'amenity',       FALSE, FALSE);

-- -------------------------------------------------------------------------
-- Building. Authoritative for the venue as a seating structure.
--
-- The same building also exists as tm_axs.venue_ref and sap_s4.t001w. None of
-- the three shares a key with the others; `venue` is therefore a canonical
-- entity in common.canonical_entity.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.building (
    building_id         INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_code       VARCHAR(20)  NOT NULL UNIQUE,
    building_name       VARCHAR(120) NOT NULL,
    legal_name          VARCHAR(160),
    -- Naming-rights name, which changes on a sponsorship cycle while
    -- building_name stays stable for operational use.
    marketing_name      VARCHAR(160),
    building_type       VARCHAR(20)  NOT NULL
        CHECK (building_type IN ('stadium', 'arena', 'ballpark', 'amphitheatre', 'theatre', 'complex')),
    address_line_1      VARCHAR(160),
    city                VARCHAR(80)  NOT NULL,
    state_province      common.dom_state_province,
    postal_code         VARCHAR(20),
    country_code        common.dom_iso3_code NOT NULL,
    local_timezone      common.dom_iana_timezone NOT NULL,
    -- Coordinates at six decimal places. The target model's generated DDL
    -- rounds every DECIMAL to (18,2), which at two decimal places locates a
    -- venue to within about a kilometre -- see docs/04-physical-model-target.md.
    latitude            NUMERIC(9,6)
        CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    longitude           NUMERIC(9,6)
        CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180),
    year_opened         SMALLINT     CHECK (year_opened IS NULL OR year_opened BETWEEN 1800 AND 2200),
    -- Gross capacity across all configurations. Each manifest has its own.
    gross_capacity      INTEGER      CHECK (gross_capacity IS NULL OR gross_capacity >= 0),
    is_indoor           BOOLEAN      NOT NULL DEFAULT FALSE,
    has_retractable_roof BOOLEAN     NOT NULL DEFAULT FALSE,
    surface_type        VARCHAR(20)
        CHECK (surface_type IS NULL OR surface_type IN
            ('natural_grass', 'artificial_turf', 'hardwood', 'ice', 'clay', 'carpet', 'none')),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A retractable roof implies an enclosable venue.
    CONSTRAINT ck_building_roof_implies_indoor
        CHECK (NOT has_retractable_roof OR is_indoor)
);

COMMENT ON COLUMN archtics.building.surface_type IS
    'The upstream model flags its equivalent column ENUM-REF-CANDIDATE with '
    'seven stripped values. Restored here as a CHECK: single-table use.';
COMMENT ON COLUMN archtics.building.latitude IS
    'NUMERIC(9,6) -- roughly 0.1 m resolution. model.json declares DECIMAL(9,6) '
    'and the generated target DDL emits DECIMAL(18,2), losing four digits.';

-- -------------------------------------------------------------------------
-- Level. A tier of the building: lower bowl, club, upper, suites.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.level (
    level_id            INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_id         INTEGER      NOT NULL,
    level_code          VARCHAR(20)  NOT NULL,
    level_name          VARCHAR(60)  NOT NULL,
    -- Ordinal from the field upward, which is how sightline and pricing
    -- gradients are reasoned about.
    level_ordinal       SMALLINT     NOT NULL CHECK (level_ordinal >= 0),
    level_category      VARCHAR(20)  NOT NULL
        CHECK (level_category IN ('field', 'lower', 'club', 'suite', 'upper', 'standing', 'press')),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (building_id, level_code),
    UNIQUE (building_id, level_ordinal)
);

-- -------------------------------------------------------------------------
-- Section. Feeds target venue.seating_section, joined with level.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.section (
    section_id          INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    level_id            INTEGER      NOT NULL,
    section_code        VARCHAR(20)  NOT NULL,
    section_label       VARCHAR(20)  NOT NULL,
    section_type        VARCHAR(20)  NOT NULL
        CHECK (section_type IN ('reserved', 'general_admission', 'suite', 'standing', 'accessible', 'press', 'visiting')),
    -- Compass-style orientation relative to the field, used for sun, sightline
    -- and away-support allocation.
    orientation         VARCHAR(10)
        CHECK (orientation IS NULL OR orientation IN ('north', 'south', 'east', 'west', 'northeast', 'northwest', 'southeast', 'southwest')),
    section_status      VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (section_status IN ('active', 'inactive', 'under_renovation', 'decommissioned', 'seasonal')),
    -- Nominal seat count. The authoritative count is the seats that exist.
    nominal_seat_count  INTEGER      CHECK (nominal_seat_count IS NULL OR nominal_seat_count >= 0),
    is_ada_section      BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (level_id, section_code)
);

-- -------------------------------------------------------------------------
-- Row. Modeled explicitly rather than as a seat attribute, because rows are
-- what get added, removed and relabelled during a reconfiguration.
--
-- `seat_row` rather than `row`: ROW is a reserved word in PostgreSQL.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.seat_row (
    seat_row_id         INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    section_id          INTEGER      NOT NULL,
    row_label           VARCHAR(10)  NOT NULL,
    -- Rows are labelled 'A', 'AA', '12', 'EXEC' -- so sort order cannot be
    -- derived from the label and is stored.
    row_ordinal         SMALLINT     NOT NULL CHECK (row_ordinal >= 0),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (section_id, row_label)
);

COMMENT ON COLUMN archtics.seat_row.row_ordinal IS
    'Explicit sort order. Row labels are alphanumeric and inconsistent, so '
    'distance from the field is not derivable from the label.';

-- -------------------------------------------------------------------------
-- Seat. The leaf of the hierarchy and the authoritative statement that a
-- given seat exists. Feeds target venue.seat.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.seat (
    seat_id             BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seat_row_id         INTEGER      NOT NULL,
    seat_label          VARCHAR(10)  NOT NULL,
    seat_ordinal        SMALLINT     NOT NULL CHECK (seat_ordinal >= 0),
    seat_status         VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (seat_status IN ('active', 'killed', 'removed', 'temporary')),
    -- A personal seat licence attaches to the seat, not the account, and
    -- survives the holder changing.
    is_psl_seat         BOOLEAN      NOT NULL DEFAULT FALSE,
    is_obstructed       BOOLEAN      NOT NULL DEFAULT FALSE,
    display_colour      common.dom_color_code,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (seat_row_id, seat_label)
);

COMMENT ON TABLE archtics.seat IS
    'Authoritative seat inventory. tm_axs.ticket_inventory mirrors this per '
    'event and drifts during an on-sale; this table is the reconciliation base.';

-- -------------------------------------------------------------------------
-- Seat attribute assignment. The many-to-many the target model does not have.
--
-- The upstream MVM retains only 6 associative tables out of 200 by design --
-- it "minimises M:N associations and relies on direct foreign key
-- relationships for simplicity". This is one of the bridges the logical model
-- puts back.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.seat_attribute_assignment (
    seat_id             BIGINT       NOT NULL,
    seat_attribute_id   INTEGER      NOT NULL,
    -- Attributes change with a reconfiguration, so the assignment is dated.
    effective_from      DATE         NOT NULL DEFAULT CURRENT_DATE,
    effective_to        DATE,
    note                VARCHAR(200),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (seat_id, seat_attribute_id, effective_from),
    CONSTRAINT ck_seat_attr_window CHECK (effective_to IS NULL OR effective_to > effective_from)
);

COMMENT ON TABLE archtics.seat_attribute_assignment IS
    'Many-to-many bridge. The target model flattens these into booleans and '
    'STRING columns on venue.seat, losing both the history and the vocabulary.';

-- -------------------------------------------------------------------------
-- Accessibility feature. Building-level provisions rather than per-seat ones.
-- Feeds target venue.accessibility_feature.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.accessibility_feature (
    accessibility_feature_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_id         INTEGER      NOT NULL,
    level_id            INTEGER,
    feature_code        VARCHAR(20)  NOT NULL,
    feature_name        VARCHAR(80)  NOT NULL,
    feature_type        VARCHAR(30)  NOT NULL
        CHECK (feature_type IN
            ('wheelchair_space', 'companion_seating', 'accessible_restroom', 'elevator',
             'ramp', 'assistive_listening', 'audio_description', 'sensory_room',
             'accessible_parking', 'service_animal_relief', 'accessible_concession')),
    quantity            INTEGER      NOT NULL DEFAULT 1 CHECK (quantity >= 0),
    location_note       VARCHAR(200),
    -- ADA and equivalent regimes set minimum ratios against capacity; the
    -- compliance status is assessed rather than computed here.
    compliance_standard VARCHAR(30),
    compliance_status   VARCHAR(20)  NOT NULL DEFAULT 'compliant'
        CHECK (compliance_status IN ('compliant', 'non_compliant', 'remediation_planned', 'exempt', 'under_review')),
    last_assessed_on    DATE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (building_id, feature_code)
);

-- -------------------------------------------------------------------------
-- Suite. Physical premium inventory; the lease commercials sit in SAP.
-- Feeds target venue.suite.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.suite (
    suite_id            INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_id         INTEGER      NOT NULL,
    level_id            INTEGER      NOT NULL,
    suite_code          VARCHAR(20)  NOT NULL,
    suite_name          VARCHAR(80),
    suite_type          VARCHAR(20)  NOT NULL
        CHECK (suite_type IN ('private', 'shared', 'loge', 'party', 'bunker', 'field_cabana')),
    seat_capacity       SMALLINT     NOT NULL CHECK (seat_capacity > 0),
    standing_capacity   SMALLINT     NOT NULL DEFAULT 0 CHECK (standing_capacity >= 0),
    has_catering_kitchen BOOLEAN     NOT NULL DEFAULT FALSE,
    has_private_restroom BOOLEAN     NOT NULL DEFAULT FALSE,
    has_outdoor_terrace BOOLEAN      NOT NULL DEFAULT FALSE,
    included_parking_passes SMALLINT NOT NULL DEFAULT 0 CHECK (included_parking_passes >= 0),
    suite_status        VARCHAR(20)  NOT NULL DEFAULT 'available'
        CHECK (suite_status IN ('available', 'leased', 'held', 'renovation', 'decommissioned')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (building_id, suite_code)
);

-- -------------------------------------------------------------------------
-- Parking. Feeds target venue.parking_lot.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.parking_lot (
    parking_lot_id      INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_id         INTEGER      NOT NULL,
    lot_code            VARCHAR(20)  NOT NULL,
    lot_name            VARCHAR(80)  NOT NULL,
    lot_type            VARCHAR(20)  NOT NULL
        CHECK (lot_type IN ('surface', 'structure', 'valet', 'street', 'remote_shuttle', 'rideshare')),
    total_spaces        INTEGER      NOT NULL CHECK (total_spaces >= 0),
    accessible_spaces   INTEGER      NOT NULL DEFAULT 0 CHECK (accessible_spaces >= 0),
    ev_charging_spaces  INTEGER      NOT NULL DEFAULT 0 CHECK (ev_charging_spaces >= 0),
    bus_spaces          INTEGER      NOT NULL DEFAULT 0 CHECK (bus_spaces >= 0),
    walk_minutes_to_gate SMALLINT    CHECK (walk_minutes_to_gate IS NULL OR walk_minutes_to_gate >= 0),
    is_prepaid_only     BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (building_id, lot_code),
    -- Sub-categories are carved out of the total, so they cannot exceed it.
    CONSTRAINT ck_parking_subcategories_within_total
        CHECK (accessible_spaces + ev_charging_spaces + bus_spaces <= total_spaces)
);
