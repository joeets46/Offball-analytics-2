-- =========================================================================
-- workday_ap -- indexes
--
-- A cube is read by slicing it, so the indexes are dimension-leading
-- composites on the fact table. The version has to lead almost all of them:
-- no sensible query crosses versions, because mixing actuals with a scenario
-- produces a number that means nothing.
-- =========================================================================

CREATE INDEX ix_version_model          ON workday_ap.version (model_id, version_type);
CREATE INDEX ix_version_parent         ON workday_ap.version (parent_version_id)
    WHERE parent_version_id IS NOT NULL;

CREATE INDEX ix_account_model          ON workday_ap.account (model_id, account_type);
CREATE INDEX ix_account_parent         ON workday_ap.account (parent_account_id)
    WHERE parent_account_id IS NOT NULL;
-- Resolution against the SAP chart of accounts.
CREATE INDEX ix_account_sap            ON workday_ap.account (sap_saknr) WHERE sap_saknr IS NOT NULL;
-- Sign-flipped accounts, which the extract has to handle specially.
CREATE INDEX ix_account_sign_flipped   ON workday_ap.account (model_id) WHERE is_sign_flipped;

CREATE INDEX ix_level_model            ON workday_ap.level (model_id);
CREATE INDEX ix_level_parent           ON workday_ap.level (parent_level_id)
    WHERE parent_level_id IS NOT NULL;
CREATE INDEX ix_level_sap_cost_center  ON workday_ap.level (sap_kostl) WHERE sap_kostl IS NOT NULL;
CREATE INDEX ix_level_sap_profit_center ON workday_ap.level (sap_prctr) WHERE sap_prctr IS NOT NULL;
-- Leaf levels only: the ones that hold input and must not be double counted
-- with their rollups.
CREATE INDEX ix_level_input            ON workday_ap.level (model_id) WHERE NOT is_rollup_only;

CREATE INDEX ix_dimension_model        ON workday_ap.dimension (model_id);
CREATE INDEX ix_dimension_value_dimension ON workday_ap.dimension_value (dimension_id);
CREATE INDEX ix_dimension_value_parent ON workday_ap.dimension_value (parent_dimension_value_id)
    WHERE parent_dimension_value_id IS NOT NULL;
-- The business-key lookup: resolving a dimension member to a fixture, a
-- player or a sponsor in another system.
CREATE INDEX ix_dimension_value_external
    ON workday_ap.dimension_value (external_system, external_ref)
    WHERE external_ref IS NOT NULL;

CREATE INDEX ix_time_period_model      ON workday_ap.time_period (model_id, fiscal_year, period_number);
CREATE INDEX ix_time_period_parent     ON workday_ap.time_period (parent_time_period_id)
    WHERE parent_time_period_id IS NOT NULL;
-- Reconciling a plan period to a calendar date range.
CREATE INDEX ix_time_period_dates      ON workday_ap.time_period (starts_on, ends_on);
CREATE INDEX ix_time_period_open       ON workday_ap.time_period (model_id) WHERE NOT is_closed;

-- -------------------------------------------------------------------------
-- The fact table. Version leads, because no query should cross versions.
-- -------------------------------------------------------------------------
-- The primary slice: one version, one account, across time.
CREATE INDEX ix_cell_value_version_account_period
    ON workday_ap.cell_value (version_id, account_id, time_period_id);

-- The organisational slice: one version, one level, across accounts.
CREATE INDEX ix_cell_value_version_level_account
    ON workday_ap.cell_value (version_id, level_id, account_id);

-- Period close and the extract itself.
CREATE INDEX ix_cell_value_period      ON workday_ap.cell_value (time_period_id, version_id);

CREATE INDEX ix_cell_value_dimension_1 ON workday_ap.cell_value (dimension_value_1_id)
    WHERE dimension_value_1_id IS NOT NULL;
CREATE INDEX ix_cell_value_dimension_2 ON workday_ap.cell_value (dimension_value_2_id)
    WHERE dimension_value_2_id IS NOT NULL;

-- Input cells only. The extract into target finance.budget wants planned
-- figures, not formula output.
CREATE INDEX ix_cell_value_input
    ON workday_ap.cell_value (version_id, account_id, time_period_id)
    WHERE NOT is_calculated;

CREATE INDEX ix_cell_value_model       ON workday_ap.cell_value (model_id);

-- -------------------------------------------------------------------------
-- Plan metadata and the calculation layer.
-- -------------------------------------------------------------------------
CREATE INDEX ix_plan_model_year        ON workday_ap.plan (model_id, fiscal_year);
CREATE INDEX ix_plan_version           ON workday_ap.plan (version_id);
CREATE INDEX ix_plan_open              ON workday_ap.plan (submission_due_on)
    WHERE plan_status IN ('open', 'submitted', 'under_review');

CREATE INDEX ix_driver_model           ON workday_ap.driver (model_id);
CREATE INDEX ix_driver_target_account  ON workday_ap.driver (target_account_id)
    WHERE target_account_id IS NOT NULL;
CREATE INDEX ix_driver_source_account  ON workday_ap.driver (source_account_id)
    WHERE source_account_id IS NOT NULL;

CREATE INDEX ix_allocation_model       ON workday_ap.allocation_rule (model_id) WHERE is_active;
CREATE INDEX ix_allocation_source_account ON workday_ap.allocation_rule (source_account_id);
CREATE INDEX ix_allocation_source_level ON workday_ap.allocation_rule (source_level_id)
    WHERE source_level_id IS NOT NULL;
CREATE INDEX ix_allocation_driver      ON workday_ap.allocation_rule (driver_id)
    WHERE driver_id IS NOT NULL;

-- -------------------------------------------------------------------------
-- Extraction watermark.
-- -------------------------------------------------------------------------
CREATE INDEX ix_cell_value_updated_at  ON workday_ap.cell_value (updated_at);
CREATE INDEX ix_version_updated_at     ON workday_ap.version (updated_at);
CREATE INDEX ix_plan_updated_at        ON workday_ap.plan (updated_at);
CREATE INDEX ix_account_updated_at     ON workday_ap.account (updated_at);
