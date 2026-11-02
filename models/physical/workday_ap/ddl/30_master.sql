-- =========================================================================
-- workday_ap -- the cube dimensions
--
-- TIER B: representative column sets.
--
-- Everything here is a dimension. There are no business documents in a
-- planning tool -- just axes and the numbers at their intersections.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Model. A planning model is the container: a workspace with its own
-- dimensions, accounts and versions.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.model (
    model_id            VARCHAR(40)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    description         TEXT,
    base_currency       common.dom_iso3_code NOT NULL,
    -- The fiscal calendar the model plans on, which need not match SAP's.
    fiscal_year_start_month SMALLINT NOT NULL DEFAULT 1
        CHECK (fiscal_year_start_month BETWEEN 1 AND 12),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN workday_ap.model.fiscal_year_start_month IS
    'The planning calendar, which need not match the SAP fiscal year variant. '
    'When they differ, budget-versus-actual comparison requires a period '
    'remap that target finance.budget does not record.';

-- -------------------------------------------------------------------------
-- Version. The dimension that makes a planning tool a planning tool.
--
-- Actuals, Working Budget, Approved Budget, Forecast, and any number of
-- scenarios all coexist for the same account, level and period. Target
-- finance.budget carries a single amount, so the extract has to pick --
-- and loading a scenario as though it were the approved budget is a
-- materially wrong answer, not a rounding difference.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.version (
    version_id          VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    name                VARCHAR(120) NOT NULL,
    version_type        VARCHAR(20)  NOT NULL
        CHECK (version_type IN ('actual', 'budget', 'forecast', 'scenario', 'baseline')),
    -- Only one version per model is the approved plan of record.
    is_plan_of_record   BOOLEAN      NOT NULL DEFAULT FALSE,
    is_locked           BOOLEAN      NOT NULL DEFAULT FALSE,
    -- A scenario usually branches from another version.
    parent_version_id   VARCHAR(40),
    approved_by         VARCHAR(120),
    approved_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (model_id, name),
    CONSTRAINT ck_version_not_self_parent
        CHECK (parent_version_id IS NULL OR parent_version_id <> version_id),
    CONSTRAINT ck_version_approval_pair
        CHECK ((approved_by IS NULL) = (approved_at IS NULL)),
    -- The plan of record has to have been approved by someone.
    CONSTRAINT ck_version_plan_of_record_approved
        CHECK (NOT is_plan_of_record OR approved_at IS NOT NULL)
);

-- Exactly one plan of record per model, which is the version the extract
-- should take.
CREATE UNIQUE INDEX ux_version_one_plan_of_record
    ON workday_ap.version (model_id) WHERE is_plan_of_record;

COMMENT ON TABLE workday_ap.version IS
    'The version dimension. Actuals, budget, forecast and scenarios coexist '
    'for the same intersection, so an extract into target finance.budget must '
    'filter on is_plan_of_record or it will load a what-if as a commitment.';

-- -------------------------------------------------------------------------
-- Account. The chart of accounts, as a planning hierarchy.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.account (
    account_id          VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    account_code        VARCHAR(40)  NOT NULL,
    name                VARCHAR(160) NOT NULL,
    parent_account_id   VARCHAR(40),
    account_type        VARCHAR(20)  NOT NULL
        CHECK (account_type IN ('revenue', 'expense', 'asset', 'liability', 'equity', 'metric', 'assumption')),
    -- Sign convention, per account type. This is the field that prevents the
    -- commonest FP&A integration error: in many Adaptive models revenue is
    -- stored negative, and loading it without flipping the sign reverses the
    -- entire P&L.
    is_sign_flipped     BOOLEAN      NOT NULL DEFAULT FALSE,
    -- How values roll up through time: a balance carries forward, a flow sums.
    time_rollup         VARCHAR(20)  NOT NULL DEFAULT 'sum'
        CHECK (time_rollup IN ('sum', 'average', 'closing_balance', 'opening_balance', 'none')),
    -- Business key into the SAP chart of accounts.
    sap_saknr           CHAR(10),
    is_assumption       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (model_id, account_code),
    CONSTRAINT ck_account_not_self_parent
        CHECK (parent_account_id IS NULL OR parent_account_id <> account_id)
);

COMMENT ON COLUMN workday_ap.account.is_sign_flipped IS
    'Revenue is stored negative in many Adaptive models. Loading a flipped '
    'account without reversing the sign inverts the whole P&L, and nothing in '
    'target finance.budget records that the flip was needed.';
COMMENT ON COLUMN workday_ap.account.time_rollup IS
    'A balance account carries its closing value forward; a flow account sums '
    'across periods. Summing a balance account across twelve months is a '
    'classic and silent twelvefold overstatement.';

-- -------------------------------------------------------------------------
-- Level. The organisational dimension -- Adaptive calls it a level.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.level (
    level_id            VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    level_code          VARCHAR(40)  NOT NULL,
    name                VARCHAR(160) NOT NULL,
    parent_level_id     VARCHAR(40),
    -- Levels map to cost centres, profit centres or neither.
    sap_kostl           CHAR(10),
    sap_prctr           CHAR(10),
    currency_code       common.dom_iso3_code,
    is_rollup_only      BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (model_id, level_code),
    CONSTRAINT ck_level_not_self_parent
        CHECK (parent_level_id IS NULL OR parent_level_id <> level_id)
);

COMMENT ON COLUMN workday_ap.level.is_rollup_only IS
    'A rollup level holds no input of its own, only the sum of its children. '
    'An extract that loads rollup levels alongside leaves double counts.';

-- -------------------------------------------------------------------------
-- Dimension and dimension value. User-defined axes.
--
-- A sports organisation plans by fixture, by competition, by sponsor and by
-- squad, and none of those are accounts or levels. They are custom
-- dimensions, which is how target athlete.salary_cap_entry can exist in a
-- planning tool at all.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.dimension (
    dimension_id        VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    name                VARCHAR(120) NOT NULL,
    -- Whether a cell must specify a member of this dimension.
    is_required         BOOLEAN      NOT NULL DEFAULT FALSE,
    display_order       SMALLINT     NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (model_id, name)
);

CREATE TABLE workday_ap.dimension_value (
    dimension_value_id  VARCHAR(40)  PRIMARY KEY,
    dimension_id        VARCHAR(40)  NOT NULL,
    value_code          VARCHAR(60)  NOT NULL,
    name                VARCHAR(160) NOT NULL,
    parent_dimension_value_id VARCHAR(40),
    -- External reference, because a dimension member usually IS a business
    -- entity from another system: a fixture, a player, a sponsor.
    external_ref        VARCHAR(80),
    external_system     VARCHAR(20),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (dimension_id, value_code),
    CONSTRAINT ck_dimension_value_not_self_parent
        CHECK (parent_dimension_value_id IS NULL
               OR parent_dimension_value_id <> dimension_value_id),
    CONSTRAINT ck_dimension_value_external_pair
        CHECK ((external_ref IS NULL) = (external_system IS NULL))
);

COMMENT ON COLUMN workday_ap.dimension_value.external_ref IS
    'A dimension member is usually a business entity from another system -- a '
    'fixture, a player, a sponsor. This is the business key, and it is how a '
    'planning cell resolves to anything real.';

-- -------------------------------------------------------------------------
-- Time period. A dimension member, not a date.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.time_period (
    time_period_id      VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    period_code         VARCHAR(30)  NOT NULL,
    period_label        VARCHAR(60)  NOT NULL,
    period_type         VARCHAR(20)  NOT NULL
        CHECK (period_type IN ('month', 'quarter', 'half_year', 'year', 'week', 'custom')),
    fiscal_year         SMALLINT     NOT NULL CHECK (fiscal_year BETWEEN 1850 AND 2200),
    period_number       SMALLINT     CHECK (period_number IS NULL OR period_number BETWEEN 1 AND 53),
    -- Calendar boundaries, so the plan period can be reconciled to a real
    -- date range even when it does not align with a calendar quarter.
    starts_on           DATE         NOT NULL,
    ends_on             DATE         NOT NULL,
    parent_time_period_id VARCHAR(40),
    is_closed           BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (model_id, period_code),
    CONSTRAINT ck_time_period_dates CHECK (ends_on >= starts_on),
    CONSTRAINT ck_time_period_not_self_parent
        CHECK (parent_time_period_id IS NULL OR parent_time_period_id <> time_period_id)
);

COMMENT ON TABLE workday_ap.time_period IS
    'Time as a dimension member. A plan period is "FY26 Q3", which need not '
    'align with a calendar quarter -- starts_on and ends_on are what make it '
    'reconcilable to the ledger.';
