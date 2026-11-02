-- =========================================================================
-- tm_axs -- local value domains
--
-- The upstream model declares 684 enumerated value domains across the 153
-- in-scope tables but stores every one of them as a bare STRING. The ones that
-- belong to this system are restored here as reference tables.
--
-- Reference table rather than CHECK constraint where the list is operator-
-- configurable (sales channels, hold reasons, delivery methods change without a
-- release); CHECK constraint where the list is a protocol the code branches on
-- (scan results, payment states).
-- =========================================================================

-- -------------------------------------------------------------------------
-- Sales channel. Drives fee schedules and settlement routing, and is
-- operator-configurable, so it is a table.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.sales_channel (
    sales_channel_code  VARCHAR(20)  PRIMARY KEY,
    channel_name        VARCHAR(60)  NOT NULL,
    channel_group       VARCHAR(20)  NOT NULL
        CHECK (channel_group IN ('direct', 'partner', 'resale', 'internal')),
    charges_service_fee BOOLEAN      NOT NULL DEFAULT TRUE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

INSERT INTO tm_axs.sales_channel
    (sales_channel_code, channel_name, channel_group, charges_service_fee)
VALUES
    ('WEB',         'Primary web',            'direct',   TRUE),
    ('MOBILE_APP',  'Mobile application',     'direct',   TRUE),
    ('BOX_OFFICE',  'Venue box office',       'internal', FALSE),
    ('CALL_CENTER', 'Inbound call centre',    'direct',   TRUE),
    ('RESALE',      'Verified resale',        'resale',   TRUE),
    ('PARTNER_API', 'Partner distribution',   'partner',  TRUE),
    ('GROUP_SALES', 'Group sales desk',       'internal', FALSE),
    ('SEASON_ROLL', 'Season renewal rollover','internal', FALSE);

-- -------------------------------------------------------------------------
-- Delivery method. Determines whether a barcode is issued at purchase or
-- rotated at scan time, which matters for the access-control model.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.delivery_method (
    delivery_method_code VARCHAR(20) PRIMARY KEY,
    method_name          VARCHAR(60) NOT NULL,
    is_digital           BOOLEAN     NOT NULL,
    -- SafeTix-style rotating barcodes cannot be screenshotted or resold outside
    -- the platform; static barcodes can, which changes the fraud model.
    uses_rotating_barcode BOOLEAN    NOT NULL DEFAULT FALSE,
    is_active            BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO tm_axs.delivery_method
    (delivery_method_code, method_name, is_digital, uses_rotating_barcode)
VALUES
    ('MOBILE_ROTATING', 'Mobile rotating barcode', TRUE,  TRUE),
    ('MOBILE_STATIC',   'Mobile static barcode',   TRUE,  FALSE),
    ('PRINT_AT_HOME',   'Print at home PDF',       TRUE,  FALSE),
    ('WILL_CALL',       'Box office will call',    FALSE, FALSE),
    ('MAIL',            'Posted hard ticket',      FALSE, FALSE),
    ('SEASON_CARD',     'Season smart card',       FALSE, FALSE);

-- -------------------------------------------------------------------------
-- Hold reason. Why inventory is withheld from sale. Operator-configurable and
-- reported on heavily (held inventory is unsold revenue), so a table.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.hold_code (
    hold_code        VARCHAR(20)  PRIMARY KEY,
    hold_name        VARCHAR(60)  NOT NULL,
    hold_category    VARCHAR(20)  NOT NULL
        CHECK (hold_category IN ('contractual', 'operational', 'commercial', 'compliance')),
    -- Kills are permanently removed (sightline, camera platform); holds can be
    -- released back to sale.
    is_kill          BOOLEAN      NOT NULL DEFAULT FALSE,
    auto_release_at  TIMESTAMPTZ,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now()
);

INSERT INTO tm_axs.hold_code (hold_code, hold_name, hold_category, is_kill)
VALUES
    ('ARTIST',     'Artist / performer allocation', 'contractual', FALSE),
    ('SPONSOR',    'Sponsor contractual allocation','contractual', FALSE),
    ('LEAGUE',     'League office allocation',      'contractual', FALSE),
    ('PRESS',      'Accredited media',              'operational', FALSE),
    ('PRODUCTION', 'Production and camera',         'operational', TRUE),
    ('SIGHTLINE',  'Obstructed view -- not sellable','operational', TRUE),
    ('ADA_COMPANION','ADA companion seat',          'compliance',  FALSE),
    ('DYN_PRICE',  'Withheld for dynamic release',  'commercial',  FALSE);

-- -------------------------------------------------------------------------
-- Event lifecycle. The target model constrains fixture.lifecycle_status to
-- 'announced|confirmed|in_progress|completed|cancelled|postponed'. That list is
-- a protocol the ticketing engine branches on -- on-sale opens at `confirmed`,
-- refunds trigger at `cancelled` -- so it is a CHECK, not a table, and the
-- allowed transitions are recorded here for the application to enforce.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.event_status_transition (
    from_status  VARCHAR(20) NOT NULL,
    to_status    VARCHAR(20) NOT NULL,
    description  TEXT        NOT NULL,
    PRIMARY KEY (from_status, to_status),
    CHECK (from_status IN ('announced','confirmed','in_progress','completed','cancelled','postponed')),
    CHECK (to_status   IN ('announced','confirmed','in_progress','completed','cancelled','postponed')),
    CHECK (from_status <> to_status)
);

INSERT INTO tm_axs.event_status_transition (from_status, to_status, description)
VALUES
    ('announced',  'confirmed',   'Governing body or promoter confirms; ticketing goes on sale'),
    ('announced',  'cancelled',   'Cancelled before on-sale; no refund processing required'),
    ('confirmed',  'in_progress', 'Doors open and the event begins; broadcast feeds activate'),
    ('confirmed',  'postponed',   'Deferred to a new date; entitlements retained, scans suspended'),
    ('confirmed',  'cancelled',   'Cancelled after on-sale; triggers full refund processing'),
    ('in_progress','completed',   'Event concludes; attendance reconciliation begins'),
    ('in_progress','cancelled',   'Abandoned mid-event; triggers partial refund assessment'),
    ('postponed',  'confirmed',   'Rescheduled date confirmed; on-sale resumes'),
    ('postponed',  'cancelled',   'Postponement becomes permanent; triggers refund processing');

COMMENT ON TABLE tm_axs.event_status_transition IS
    'The legal event lifecycle transitions. The target model stores only the '
    'current lifecycle_status; this table is what makes that column auditable.';
