-- =========================================================================
-- workday_ap -- the fact table and plan metadata
--
-- One fact table addressed by six dimensions. This is the whole substance of
-- a planning tool, and it is the only place in the entire source model where
-- the natural shape is already dimensional rather than relational -- which
-- makes it the easiest extract in the project and the one with the most
-- opportunity to be silently wrong.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Cell value. The fact.
--
-- Feeds target finance.budget and target athlete.salary_cap_entry.
--
-- The grain is (version, account, level, time period, and up to two custom
-- dimension members). Sparse: a model with 2,000 accounts, 300 levels, 60
-- periods and 5 versions has 1.8 billion possible intersections and perhaps
-- two million populated ones, so this is emphatically not a dense cube.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.cell_value (
    cell_value_id       BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    version_id          VARCHAR(40)  NOT NULL,
    account_id          VARCHAR(40)  NOT NULL,
    level_id            VARCHAR(40)  NOT NULL,
    time_period_id      VARCHAR(40)  NOT NULL,
    -- Up to two custom dimension members per cell. A real Adaptive model
    -- allows more; two is the Tier B simplification and it is enough to carry
    -- the fixture and squad dimensions the sports use needs.
    dimension_value_1_id VARCHAR(40),
    dimension_value_2_id VARCHAR(40),

    -- The number. NUMERIC(20,6) because a planning cell holds both currency
    -- amounts and driver rates -- headcount, occupancy percentage, price per
    -- seat -- and rounding drivers to two places breaks the calculation.
    amount              NUMERIC(20,6) NOT NULL,
    currency_code       common.dom_iso3_code,

    -- Input versus calculated. A calculated cell is the output of a formula
    -- and must not be loaded as though someone had planned it.
    is_calculated       BOOLEAN      NOT NULL DEFAULT FALSE,
    formula_ref         VARCHAR(120),

    -- Audit of who planned what, which is the governance trail for a budget.
    last_edited_by      VARCHAR(120),
    last_edited_at      TIMESTAMPTZ,
    note                TEXT,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- One value per intersection. This constraint IS the cube.
    --
    -- NULLS NOT DISTINCT matters here. By default PostgreSQL treats NULLs as
    -- distinct, which would let the same intersection be inserted repeatedly
    -- whenever the custom dimensions are unused. These semantics are the
    -- correct ones: a cell with no custom dimension member is one specific
    -- cell, not an unknown one.
    CONSTRAINT ux_cell_value_intersection
        UNIQUE NULLS NOT DISTINCT
        (version_id, account_id, level_id, time_period_id,
         dimension_value_1_id, dimension_value_2_id),
    CONSTRAINT ck_cell_value_formula_pair
        CHECK (is_calculated = (formula_ref IS NOT NULL)),
    -- A calculated cell has no human editor.
    CONSTRAINT ck_cell_value_calculated_no_editor
        CHECK (NOT is_calculated OR last_edited_by IS NULL),
    CONSTRAINT ck_cell_value_edit_pair
        CHECK ((last_edited_by IS NULL) = (last_edited_at IS NULL))
);

COMMENT ON TABLE workday_ap.cell_value IS
    'The planning fact. Sparse: a model with 2,000 accounts, 300 levels, 60 '
    'periods and 5 versions has ~1.8 billion possible intersections and maybe '
    'two million populated. The UNIQUE constraint on the dimension tuple is '
    'what makes it a cube.';
COMMENT ON COLUMN workday_ap.cell_value.amount IS
    'NUMERIC(20,6) because a cell holds currency amounts and driver rates '
    'alike -- headcount, occupancy percentage, price per seat. Rounding '
    'drivers to two places breaks the calculation they feed.';
COMMENT ON COLUMN workday_ap.cell_value.is_calculated IS
    'A calculated cell is formula output, not a plan. Loading it into target '
    'finance.budget as a planned figure double counts against its inputs.';

-- -------------------------------------------------------------------------
-- Plan. A named planning exercise -- the annual budget round, a reforecast.
-- Provides the metadata target finance.budget needs beyond the numbers.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.plan (
    plan_id             VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    version_id          VARCHAR(40)  NOT NULL,
    name                VARCHAR(160) NOT NULL,
    plan_type           VARCHAR(20)  NOT NULL
        CHECK (plan_type IN ('annual_budget', 'reforecast', 'long_range', 'capex', 'headcount', 'salary_cap')),
    fiscal_year         SMALLINT     NOT NULL CHECK (fiscal_year BETWEEN 1850 AND 2200),
    plan_status         VARCHAR(20)  NOT NULL DEFAULT 'open'
        CHECK (plan_status IN ('draft', 'open', 'submitted', 'under_review', 'approved', 'closed')),
    submission_due_on   DATE,
    submitted_at        TIMESTAMPTZ,
    approved_at         TIMESTAMPTZ,
    approved_by         VARCHAR(120),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_plan_approval_pair
        CHECK ((approved_at IS NULL) = (approved_by IS NULL)),
    CONSTRAINT ck_plan_approved_requires_submission
        CHECK (approved_at IS NULL OR submitted_at IS NOT NULL),
    CONSTRAINT ck_plan_approved_status
        CHECK (plan_status <> 'approved' OR approved_at IS NOT NULL)
);

-- -------------------------------------------------------------------------
-- Driver and allocation rule. The calculation layer.
--
-- Neither has a target counterpart. A budget figure arrives in the lakehouse
-- as a number, with no record of the driver that produced it -- so
-- "why is next season's matchday revenue up 12%" is not answerable
-- downstream, only upstream.
-- -------------------------------------------------------------------------
CREATE TABLE workday_ap.driver (
    driver_id           VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    name                VARCHAR(160) NOT NULL,
    driver_type         VARCHAR(30)  NOT NULL
        CHECK (driver_type IN ('volume', 'rate', 'percentage', 'headcount', 'growth', 'seasonality')),
    -- The account this driver feeds, and the account it is driven by.
    target_account_id   VARCHAR(40),
    source_account_id   VARCHAR(40),
    -- Sports-specific drivers: attendance, average ticket yield, number of
    -- home fixtures, broadcast rights instalments.
    driver_basis        VARCHAR(40),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE workday_ap.driver IS
    'The calculation behind a planned number. No target table corresponds, so '
    'a budget arrives in the lakehouse as a figure with no explanation -- the '
    'question "why is this up 12%" is answerable here and nowhere downstream.';

CREATE TABLE workday_ap.allocation_rule (
    allocation_rule_id  VARCHAR(40)  PRIMARY KEY,
    model_id            VARCHAR(40)  NOT NULL,
    name                VARCHAR(160) NOT NULL,
    source_account_id   VARCHAR(40)  NOT NULL,
    source_level_id     VARCHAR(40),
    -- How the pool is split: evenly, by a driver, or by fixed percentages.
    allocation_method   VARCHAR(20)  NOT NULL
        CHECK (allocation_method IN ('even', 'driver_based', 'fixed_percentage', 'headcount', 'revenue_share')),
    driver_id           VARCHAR(40),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A driver-based allocation must name its driver.
    CONSTRAINT ck_allocation_driver
        CHECK ((allocation_method = 'driver_based') = (driver_id IS NOT NULL))
);
