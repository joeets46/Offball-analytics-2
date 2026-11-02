-- =========================================================================
-- sap_s4 -- master data
--
-- Accounts, business partners, materials, assets and contracts.
--
-- SAP splits master data into a client-level view and a company-code or
-- plant-level view: SKA1/SKB1 for GL accounts, KNA1/KNB1 for customers,
-- LFA1/LFB1 for vendors, MARA/MARC/MARD for materials. The general view holds
-- what is true everywhere; the organisational view holds what differs per
-- company code or plant. Every one of those pairs collapses into a single
-- target table, which is why so many finance mappings are `join`.
-- =========================================================================

-- -------------------------------------------------------------------------
-- SKA1 / SKB1 -- GL account, chart-of-accounts and company-code views.
-- Together they feed target finance.gl_account.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.ska1 (
    mandt       CHAR(3)      NOT NULL,
    ktopl       CHAR(4)      NOT NULL,   -- chart of accounts
    saknr       CHAR(10)     NOT NULL,   -- account number
    txt50       VARCHAR(50)  NOT NULL,   -- long text
    -- P&L or balance sheet. This one character decides which statement the
    -- account appears in and whether it closes to retained earnings.
    gvtyp       CHAR(2),                 -- P&L statement account type
    xbilk       BOOLEAN      NOT NULL DEFAULT FALSE,  -- balance sheet account
    ktoks       CHAR(4)      NOT NULL,   -- account group
    xloev       BOOLEAN      NOT NULL DEFAULT FALSE,  -- deletion flag
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, ktopl, saknr),
    -- A balance sheet account has no P&L statement type, and vice versa.
    CONSTRAINT ck_ska1_statement_exclusive
        CHECK (NOT xbilk OR gvtyp IS NULL)
);

CREATE TABLE sap_s4.skb1 (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    saknr       CHAR(10)     NOT NULL,
    waers       CHAR(3)      NOT NULL,   -- account currency
    -- Open item management: required for clearing accounts, and the reason AR
    -- and AP can be aged at all.
    xopvw       BOOLEAN      NOT NULL DEFAULT FALSE,
    xkres       BOOLEAN      NOT NULL DEFAULT TRUE,   -- line item display
    mitkz       CHAR(1),                 -- reconciliation account type
    fstag       CHAR(4),                 -- field status group
    xspeb       BOOLEAN      NOT NULL DEFAULT FALSE,  -- posting block
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs, saknr)
);

COMMENT ON TABLE sap_s4.skb1 IS
    'Company-code view of a GL account. The same account can be open-item '
    'managed in one company code and not another, so target finance.gl_account '
    'is a join of SKA1 and SKB1 and is only unique per company code.';

-- -------------------------------------------------------------------------
-- KNA1 / KNB1 -- Customer. Feeds the counterparty side of AR and, through
-- common.entity_xref, target sponsorship.sponsor.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.kna1 (
    mandt       CHAR(3)      NOT NULL,
    kunnr       CHAR(10)     NOT NULL,   -- customer number
    name1       VARCHAR(35)  NOT NULL,
    name2       VARCHAR(35),
    sortl       CHAR(10),                -- search term
    ort01       VARCHAR(35),
    pstlz       VARCHAR(10),
    stras       VARCHAR(35),
    land1       CHAR(3)      NOT NULL,
    regio       CHAR(3),
    spras       CHAR(1)      NOT NULL DEFAULT 'E',
    stceg       VARCHAR(20),             -- VAT registration number
    ktokd       CHAR(4)      NOT NULL,   -- account group
    -- Business key into the CRM, which holds the commercial relationship.
    sfdc_account_id CHAR(18),
    loevm       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, kunnr)
);

CREATE TABLE sap_s4.knb1 (
    mandt       CHAR(3)      NOT NULL,
    kunnr       CHAR(10)     NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    akont       CHAR(10)     NOT NULL,   -- reconciliation account
    zterm       CHAR(4),                 -- payment terms
    zwels       VARCHAR(10),             -- payment methods
    -- Dunning state, which is the collections position.
    mahna       CHAR(4),                 -- dunning procedure
    mansp       CHAR(1),                 -- dunning block
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, kunnr, bukrs)
);

-- -------------------------------------------------------------------------
-- LFA1 / LFB1 -- Vendor. Feeds target merchandise.supplier.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.lfa1 (
    mandt       CHAR(3)      NOT NULL,
    lifnr       CHAR(10)     NOT NULL,   -- vendor number
    name1       VARCHAR(35)  NOT NULL,
    name2       VARCHAR(35),
    ort01       VARCHAR(35),
    pstlz       VARCHAR(10),
    stras       VARCHAR(35),
    land1       CHAR(3)      NOT NULL,
    regio       CHAR(3),
    stceg       VARCHAR(20),
    ktokk       CHAR(4)      NOT NULL,   -- account group
    -- Vendor classification. Licensees and rights holders are also vendors
    -- when royalties flow outward, which is why athlete.nil_agreement and
    -- merchandise.licensing_agreement both reach this table.
    vendor_role VARCHAR(20)  NOT NULL DEFAULT 'supplier'
        CHECK (vendor_role IN ('supplier', 'licensor', 'licensee', 'agent', 'athlete', 'service', 'contractor')),
    loevm       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, lifnr)
);

CREATE TABLE sap_s4.lfb1 (
    mandt       CHAR(3)      NOT NULL,
    lifnr       CHAR(10)     NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    akont       CHAR(10)     NOT NULL,
    zterm       CHAR(4),
    zwels       VARCHAR(10),
    -- Payment block, which stops a vendor being paid by the payment run.
    zahls       CHAR(1),
    reprf       BOOLEAN      NOT NULL DEFAULT FALSE,  -- invoice duplicate check
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, lifnr, bukrs)
);

-- -------------------------------------------------------------------------
-- MARA / MARC / MARD -- Material: client, plant and storage-location views.
--
-- MARA says the item exists; MARC says it is produced or sold at a plant;
-- MARD holds the stock balance at a storage location. Target
-- merchandise.sku_catalog maps to Shopify instead, because the sellable
-- catalog is a storefront concept -- but target
-- merchandise.inventory_position maps here, because stock is not.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.mara (
    mandt       CHAR(3)      NOT NULL,
    matnr       CHAR(18)     NOT NULL,   -- material number
    mtart       CHAR(4)      NOT NULL,   -- material type
    matkl       CHAR(9),                 -- material group
    meins       CHAR(3)      NOT NULL,   -- base unit of measure
    brgew       NUMERIC(13,3),           -- gross weight
    ntgew       NUMERIC(13,3),           -- net weight
    gewei       CHAR(3),                 -- weight unit
    -- Licensed merchandise carries a royalty obligation, so the flag drives
    -- the royalty accrual.
    is_licensed BOOLEAN      NOT NULL DEFAULT FALSE,
    licensor_lifnr CHAR(10),
    -- Business key into the storefront.
    shopify_variant_id BIGINT,
    lvorm       BOOLEAN      NOT NULL DEFAULT FALSE,  -- deletion flag
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, matnr),
    CONSTRAINT ck_mara_licensed_has_licensor
        CHECK (NOT is_licensed OR licensor_lifnr IS NOT NULL),
    CONSTRAINT ck_mara_weight_unit
        CHECK ((brgew IS NULL AND ntgew IS NULL) OR gewei IS NOT NULL),
    CONSTRAINT ck_mara_net_within_gross
        CHECK (ntgew IS NULL OR brgew IS NULL OR ntgew <= brgew)
);

CREATE TABLE sap_s4.marc (
    mandt       CHAR(3)      NOT NULL,
    matnr       CHAR(18)     NOT NULL,
    werks       CHAR(4)      NOT NULL,
    ekgrp       CHAR(3),                 -- purchasing group
    dispo       CHAR(3),                 -- MRP controller
    -- Reorder point and safety stock drive replenishment, which is the point
    -- of holding stock at plant level at all.
    minbe       NUMERIC(13,3) CHECK (minbe IS NULL OR minbe >= 0),  -- reorder point
    eisbe       NUMERIC(13,3) CHECK (eisbe IS NULL OR eisbe >= 0),  -- safety stock
    plifz       SMALLINT     CHECK (plifz IS NULL OR plifz >= 0),   -- planned delivery days
    lvorm       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, matnr, werks)
);

CREATE TABLE sap_s4.mard (
    mandt       CHAR(3)      NOT NULL,
    matnr       CHAR(18)     NOT NULL,
    werks       CHAR(4)      NOT NULL,
    lgort       CHAR(4)      NOT NULL,
    -- Unrestricted-use stock, plus the two buckets that are on hand but not
    -- sellable. The target inventory_position carries a single quantity, so
    -- the distinction is lost and apparent availability is overstated.
    labst       NUMERIC(13,3) NOT NULL DEFAULT 0,  -- unrestricted use
    insme       NUMERIC(13,3) NOT NULL DEFAULT 0 CHECK (insme >= 0),  -- quality inspection
    speme       NUMERIC(13,3) NOT NULL DEFAULT 0 CHECK (speme >= 0),  -- blocked
    -- Last physical count, which is how much the balance can be trusted.
    last_count_on DATE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, matnr, werks, lgort)
);

COMMENT ON COLUMN sap_s4.mard.labst IS
    'Unrestricted-use stock. Deliberately not CHECKed non-negative: SAP '
    'permits negative stock in some configurations, and a constraint here '
    'would reject rows a real extract delivers.';

-- -------------------------------------------------------------------------
-- ANLA / ANLC -- Fixed asset master and its value segment.
-- Feeds target finance.fixed_asset.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.anla (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    anln1       CHAR(12)     NOT NULL,   -- main asset number
    anln2       CHAR(4)      NOT NULL DEFAULT '0000',  -- sub-number
    txt50       VARCHAR(50)  NOT NULL,
    anlkl       CHAR(8)      NOT NULL,   -- asset class
    aktiv       DATE,                    -- capitalisation date
    deakt       DATE,                    -- deactivation date
    kostl       CHAR(10),                -- cost centre
    werks       CHAR(4),                 -- plant
    -- Venue infrastructure is the bulk of a sports organisation's asset base,
    -- so the asset-to-plant link is what connects finance to the building.
    menge       NUMERIC(13,3),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs, anln1, anln2),
    CONSTRAINT ck_anla_deactivation_after_capitalisation
        CHECK (deakt IS NULL OR aktiv IS NULL OR deakt >= aktiv)
);

CREATE TABLE sap_s4.anlc (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    anln1       CHAR(12)     NOT NULL,
    anln2       CHAR(4)      NOT NULL,
    gjahr       SMALLINT     NOT NULL CHECK (gjahr BETWEEN 1850 AND 2200),
    afabe       CHAR(2)      NOT NULL,   -- depreciation area
    kansw       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- acquisition value
    knafa       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- accumulated depreciation
    nafap       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- planned depreciation
    -- Net book value, generated so it cannot disagree with its components.
    nbv         NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (kansw - knafa) STORED,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs, anln1, anln2, gjahr, afabe)
);

COMMENT ON TABLE sap_s4.anlc IS
    'Asset values per fiscal year and depreciation area. Multiple areas mean '
    'multiple valuations of one asset; target finance.fixed_asset keeps one.';

-- -------------------------------------------------------------------------
-- VEDA -- Contract data.
--
-- The single busiest table in the mapping: eight target tables reach it --
-- athlete.contract, athlete.nil_agreement, athlete.free_agency_status,
-- content.license, merchandise.licensing_agreement, sponsorship.naming_right,
-- sponsorship.payment_schedule and finance.revenue_recognition_schedule.
-- They are all contracts, and SAP does not care what they are about.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.veda (
    mandt       CHAR(3)      NOT NULL,
    vbeln       CHAR(10)     NOT NULL,   -- contract document number
    vposn       SMALLINT     NOT NULL DEFAULT 0,  -- item (0 = header)
    vbegdat     DATE,                    -- contract start
    vendat      DATE,                    -- contract end
    vlaufz      SMALLINT     CHECK (vlaufz IS NULL OR vlaufz > 0),  -- term
    vlaufe      CHAR(1)      CHECK (vlaufe IS NULL OR vlaufe IN ('D', 'W', 'M', 'J')),
    -- Notice and renewal terms, which drive the free-agency derivation.
    vkuegru     CHAR(2),                 -- cancellation reason
    vkdat       DATE,                    -- cancellation date
    auto_renew  BOOLEAN      NOT NULL DEFAULT FALSE,
    notice_days SMALLINT     CHECK (notice_days IS NULL OR notice_days >= 0),
    -- Contract classification. This is what lets eight different target tables
    -- be extracted from one SAP table without guessing.
    contract_category VARCHAR(30) NOT NULL
        CHECK (contract_category IN
            ('athlete_playing', 'athlete_nil', 'media_rights', 'content_licence',
             'merchandise_licence', 'naming_right', 'sponsorship', 'suite_lease',
             'supplier', 'other')),
    -- Counterparty: a contract faces either a customer or a vendor.
    kunnr       CHAR(10),
    lifnr       CHAR(10),
    contract_value NUMERIC(18,2) CHECK (contract_value IS NULL OR contract_value >= 0),
    waers       CHAR(3),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, vbeln, vposn),
    CONSTRAINT ck_veda_contract_dates
        CHECK (vendat IS NULL OR vbegdat IS NULL OR vendat >= vbegdat),
    CONSTRAINT ck_veda_counterparty
        CHECK (kunnr IS NULL OR lifnr IS NULL),
    CONSTRAINT ck_veda_value_currency
        CHECK ((contract_value IS NULL) = (waers IS NULL))
);

COMMENT ON COLUMN sap_s4.veda.contract_category IS
    'Not a real SAP field. Eight target tables map to this one table, and '
    'without an explicit category the extract would have to infer the contract '
    'type from the account group or the document type -- which is how wrong '
    'rows end up in athlete.contract.';
COMMENT ON CONSTRAINT ck_veda_counterparty ON sap_s4.veda IS
    'A contract faces a customer or a vendor, never both. Revenue contracts '
    'carry KUNNR; royalty and playing contracts carry LIFNR.';
