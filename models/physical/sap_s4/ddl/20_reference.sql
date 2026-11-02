-- =========================================================================
-- sap_s4 -- organisational structure and configuration
--
-- In SAP these are "customising" tables: T-prefixed configuration maintained
-- by transport rather than by users. They are the backbone the whole ledger
-- hangs off, and they are also -- awkwardly -- the only named source for the
-- league structure, because no league system is among the ten.
-- =========================================================================

-- -------------------------------------------------------------------------
-- T001 -- Company code. The legal entity and the unit of external reporting.
--
-- Feeds target finance.company_code, and also target league.league and
-- league.franchise. That second use is a documented compromise: a franchise
-- genuinely is a legal entity so the fit is fair, but a league is a
-- competition, not a company code. See docs/08-scope-boundary.md.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.t001 (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    butxt       VARCHAR(25)  NOT NULL,   -- company name
    ort01       VARCHAR(25),             -- city
    land1       CHAR(3)      NOT NULL,   -- country key
    waers       CHAR(3)      NOT NULL,   -- local currency
    spras       CHAR(1)      NOT NULL DEFAULT 'E',
    ktopl       CHAR(4)      NOT NULL,   -- chart of accounts
    periv       CHAR(2)      NOT NULL,   -- fiscal year variant
    -- Business-area and segment reporting flags, which determine whether a
    -- posting may omit a profit centre.
    xgsbe       BOOLEAN      NOT NULL DEFAULT FALSE,
    -- Entity classification, used here to separate the competition structure
    -- from the operating companies.
    entity_role VARCHAR(20)  NOT NULL DEFAULT 'operating'
        CHECK (entity_role IN ('operating', 'league', 'franchise', 'holding', 'venue_opco')),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs)
);

COMMENT ON COLUMN sap_s4.t001.mandt IS
    'Client. Leading key column of every table in this schema. A production '
    'system also holds test and training clients, so an extract that does not '
    'filter on MANDT returns duplicate business rows.';
COMMENT ON COLUMN sap_s4.t001.entity_role IS
    'Not a real SAP field. Added so the league/franchise/operating-company '
    'distinction is explicit rather than inferred from naming, since this '
    'table is doing double duty as the league structure.';

-- -------------------------------------------------------------------------
-- T001W -- Plant / site. The physical operating location.
-- Feeds target venue.facility and target merchandise.retail_location.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.t001w (
    mandt       CHAR(3)      NOT NULL,
    werks       CHAR(4)      NOT NULL,   -- plant
    name1       VARCHAR(30)  NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    ort01       VARCHAR(25),
    land1       CHAR(3)      NOT NULL,
    regio       CHAR(3),                 -- region / state
    pstlz       VARCHAR(10),
    stras       VARCHAR(30),
    -- Site type, which distinguishes a stadium from a retail store from a
    -- distribution centre -- all of which are plants to SAP.
    site_type   VARCHAR(20)  NOT NULL DEFAULT 'venue'
        CHECK (site_type IN ('venue', 'retail_store', 'warehouse', 'office', 'training_facility', 'popup')),
    -- Business key into the seating system. Unenforceable across databases.
    archtics_building_code VARCHAR(20),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, werks)
);

-- -------------------------------------------------------------------------
-- T001L -- Storage location. Where stock physically sits within a plant.
-- Feeds the location dimension of target merchandise.inventory_position.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.t001l (
    mandt       CHAR(3)      NOT NULL,
    werks       CHAR(4)      NOT NULL,
    lgort       CHAR(4)      NOT NULL,   -- storage location
    lgobe       VARCHAR(16)  NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, werks, lgort)
);

-- -------------------------------------------------------------------------
-- T009 / T009B -- Fiscal year variant and its period definitions.
--
-- Feeds target finance.fiscal_period and -- the compromise again -- target
-- league.season. A sports season and a fiscal year are genuinely different
-- things that happen to both be annual, and mapping one to the other is the
-- weakest join in the whole model. It is recorded as medium confidence.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.t009 (
    mandt       CHAR(3)      NOT NULL,
    periv       CHAR(2)      NOT NULL,   -- fiscal year variant
    xkale       BOOLEAN      NOT NULL DEFAULT FALSE,  -- calendar year flag
    anzbp       SMALLINT     NOT NULL CHECK (anzbp BETWEEN 1 AND 16),  -- posting periods
    anzsp       SMALLINT     NOT NULL DEFAULT 0 CHECK (anzsp BETWEEN 0 AND 4),  -- special periods
    description VARCHAR(60),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, periv)
);

CREATE TABLE sap_s4.t009b (
    mandt       CHAR(3)      NOT NULL,
    periv       CHAR(2)      NOT NULL,
    bdatj       SMALLINT     NOT NULL CHECK (bdatj BETWEEN 1850 AND 2200),  -- fiscal year
    poper       SMALLINT     NOT NULL CHECK (poper BETWEEN 1 AND 16),       -- period
    bumon       SMALLINT     NOT NULL CHECK (bumon BETWEEN 1 AND 12),       -- calendar month
    butag       SMALLINT     NOT NULL CHECK (butag BETWEEN 1 AND 31),       -- day limit
    -- Period open/closed state, which is what blocks a posting at month end.
    period_status VARCHAR(10) NOT NULL DEFAULT 'open'
        CHECK (period_status IN ('open', 'closed', 'adjustment')),
    period_start_on DATE     NOT NULL,
    period_end_on   DATE     NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, periv, bdatj, poper),
    CONSTRAINT ck_t009b_period_dates CHECK (period_end_on >= period_start_on)
);

-- -------------------------------------------------------------------------
-- T881 -- Ledger. S/4HANA runs parallel ledgers: a leading ledger on group
-- accounting principles and extension ledgers for local GAAP.
-- Feeds target finance.ledger.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.t881 (
    mandt       CHAR(3)      NOT NULL,
    rldnr       CHAR(2)      NOT NULL,   -- ledger
    name        VARCHAR(30)  NOT NULL,
    xleading    BOOLEAN      NOT NULL DEFAULT FALSE,
    accounting_principle VARCHAR(10) NOT NULL
        CHECK (accounting_principle IN ('IFRS', 'US_GAAP', 'LOCAL', 'TAX', 'MGMT')),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, rldnr)
);

COMMENT ON TABLE sap_s4.t881 IS
    'Parallel ledgers. The target finance.journal_entry has no ledger '
    'dimension beyond a single column, so an IFRS and a local-GAAP view of the '
    'same document arrive as two rows that look like a duplicate.';

-- -------------------------------------------------------------------------
-- CSKS -- Cost centre. Feeds target finance.cost_center.
--
-- Cost centres are time-dependent in SAP: the key includes a validity window,
-- so the same centre has several rows over its life. The target model keeps
-- one row, so a reorganisation silently rewrites history.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.csks (
    mandt       CHAR(3)      NOT NULL,
    kokrs       common.dom_controlling_area NOT NULL,  -- controlling area
    kostl       CHAR(10)     NOT NULL,   -- cost centre
    datbi       DATE         NOT NULL,   -- valid to  (part of the key in SAP)
    datab       DATE         NOT NULL,   -- valid from
    ktext       VARCHAR(40)  NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    prctr       CHAR(10),                -- profit centre
    verak       VARCHAR(20),             -- person responsible
    kosar       CHAR(1)      NOT NULL DEFAULT 'E'      -- cost centre category
        CHECK (kosar IN ('E', 'F', 'H', 'L', 'M', 'P', 'S', 'V', 'W')),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, kokrs, kostl, datbi),
    CONSTRAINT ck_csks_validity CHECK (datbi >= datab)
);

COMMENT ON COLUMN sap_s4.csks.datbi IS
    'Valid-to date, and part of the primary key -- SAP keys time-dependent '
    'master data this way. The target finance.cost_center keeps one row per '
    'cost centre, so the extract must pick the window in force.';

-- -------------------------------------------------------------------------
-- CEPC -- Profit centre. Feeds target finance.profit_center and, again by
-- compromise, target league.conference, league.division and league.team.
-- Also time-dependent.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.cepc (
    mandt       CHAR(3)      NOT NULL,
    prctr       CHAR(10)     NOT NULL,
    datbi       DATE         NOT NULL,
    kokrs       common.dom_controlling_area NOT NULL,
    datab       DATE         NOT NULL,
    ktext       VARCHAR(40)  NOT NULL,
    bukrs       CHAR(4),
    -- Hierarchy node, which is how conferences and divisions are represented.
    hier_node   CHAR(12),
    -- Classification making the competition structure explicit rather than
    -- inferred, for the same reason as t001.entity_role.
    structure_level VARCHAR(20)
        CHECK (structure_level IS NULL OR structure_level IN
            ('conference', 'division', 'team', 'business_unit', 'venue', 'other')),
    segment     CHAR(10),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, prctr, datbi),
    CONSTRAINT ck_cepc_validity CHECK (datbi >= datab)
);

COMMENT ON COLUMN sap_s4.cepc.structure_level IS
    'Not a real SAP field. Four target tables -- league.conference, '
    'league.division, league.team and finance.profit_center -- all map to this '
    'one table, and this column is what tells them apart.';

-- -------------------------------------------------------------------------
-- A004 / KONP -- Pricing condition records and their values.
--
-- SAP pricing is a two-table structure: an access table keyed on the
-- combination that was looked up, and a condition table holding the rate. The
-- target merchandise.price_list flattens them.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.a004 (
    mandt       CHAR(3)      NOT NULL,
    kappl       CHAR(2)      NOT NULL DEFAULT 'V',  -- application (V = sales)
    kschl       CHAR(4)      NOT NULL,   -- condition type
    vkorg       CHAR(4)      NOT NULL,   -- sales organisation
    vtweg       CHAR(2)      NOT NULL,   -- distribution channel
    matnr       CHAR(18)     NOT NULL,   -- material
    datbi       DATE         NOT NULL,
    datab       DATE         NOT NULL,
    knumh       CHAR(10)     NOT NULL,   -- condition record number
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, kappl, kschl, vkorg, vtweg, matnr, datbi),
    CONSTRAINT ck_a004_validity CHECK (datbi >= datab)
);

CREATE TABLE sap_s4.konp (
    mandt       CHAR(3)      NOT NULL,
    knumh       CHAR(10)     NOT NULL,
    kopos       SMALLINT     NOT NULL,   -- condition item
    kschl       CHAR(4)      NOT NULL,
    kbetr       NUMERIC(18,4) NOT NULL,  -- rate
    konwa       CHAR(5)      NOT NULL,   -- rate unit (currency or %)
    kpein       INTEGER      NOT NULL DEFAULT 1 CHECK (kpein > 0),  -- pricing unit
    kmein       CHAR(3),                 -- unit of measure
    loevm_ko    BOOLEAN      NOT NULL DEFAULT FALSE,  -- deletion flag
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, knumh, kopos)
);

COMMENT ON COLUMN sap_s4.konp.loevm_ko IS
    'SAP deletion flag. Rows are marked, not removed -- so an extract that '
    'ignores it will load prices that are no longer in force.';
