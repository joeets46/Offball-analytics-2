-- =========================================================================
-- workday_ap -- foreign keys
--
-- Everything cascades from the model. A planning model is a self-contained
-- workspace: delete it and its dimensions, versions and cells go with it,
-- because none of them means anything outside it.
--
-- Cell values cascade from every dimension they reference, which is unusual
-- and deliberate: removing an account or a level from a planning model is
-- expected to remove the cells at those intersections. A planning tool is not
-- a ledger, and its history is not evidence.
-- =========================================================================

ALTER TABLE workday_ap.version
    ADD CONSTRAINT fk_version_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_version_parent
        FOREIGN KEY (parent_version_id) REFERENCES workday_ap.version (version_id)
        ON DELETE RESTRICT;

ALTER TABLE workday_ap.account
    ADD CONSTRAINT fk_account_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_account_parent
        FOREIGN KEY (parent_account_id) REFERENCES workday_ap.account (account_id)
        ON DELETE RESTRICT;

ALTER TABLE workday_ap.level
    ADD CONSTRAINT fk_level_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_level_parent
        FOREIGN KEY (parent_level_id) REFERENCES workday_ap.level (level_id)
        ON DELETE RESTRICT;

ALTER TABLE workday_ap.dimension
    ADD CONSTRAINT fk_dimension_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE;

ALTER TABLE workday_ap.dimension_value
    ADD CONSTRAINT fk_dimension_value_dimension
        FOREIGN KEY (dimension_id) REFERENCES workday_ap.dimension (dimension_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_dimension_value_parent
        FOREIGN KEY (parent_dimension_value_id)
        REFERENCES workday_ap.dimension_value (dimension_value_id)
        ON DELETE RESTRICT;

ALTER TABLE workday_ap.time_period
    ADD CONSTRAINT fk_time_period_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_time_period_parent
        FOREIGN KEY (parent_time_period_id) REFERENCES workday_ap.time_period (time_period_id)
        ON DELETE RESTRICT;

-- The fact table references all six of its dimensions.
ALTER TABLE workday_ap.cell_value
    ADD CONSTRAINT fk_cell_value_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cell_value_version
        FOREIGN KEY (version_id) REFERENCES workday_ap.version (version_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cell_value_account
        FOREIGN KEY (account_id) REFERENCES workday_ap.account (account_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cell_value_level
        FOREIGN KEY (level_id) REFERENCES workday_ap.level (level_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cell_value_time_period
        FOREIGN KEY (time_period_id) REFERENCES workday_ap.time_period (time_period_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cell_value_dimension_1
        FOREIGN KEY (dimension_value_1_id)
        REFERENCES workday_ap.dimension_value (dimension_value_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cell_value_dimension_2
        FOREIGN KEY (dimension_value_2_id)
        REFERENCES workday_ap.dimension_value (dimension_value_id)
        ON DELETE CASCADE;

ALTER TABLE workday_ap.plan
    ADD CONSTRAINT fk_plan_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_plan_version
        FOREIGN KEY (version_id) REFERENCES workday_ap.version (version_id)
        ON DELETE CASCADE;

ALTER TABLE workday_ap.driver
    ADD CONSTRAINT fk_driver_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_driver_target_account
        FOREIGN KEY (target_account_id) REFERENCES workday_ap.account (account_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_driver_source_account
        FOREIGN KEY (source_account_id) REFERENCES workday_ap.account (account_id)
        ON DELETE CASCADE;

ALTER TABLE workday_ap.allocation_rule
    ADD CONSTRAINT fk_allocation_model
        FOREIGN KEY (model_id) REFERENCES workday_ap.model (model_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_allocation_source_account
        FOREIGN KEY (source_account_id) REFERENCES workday_ap.account (account_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_allocation_source_level
        FOREIGN KEY (source_level_id) REFERENCES workday_ap.level (level_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_allocation_driver
        FOREIGN KEY (driver_id) REFERENCES workday_ap.driver (driver_id)
        ON DELETE RESTRICT;
