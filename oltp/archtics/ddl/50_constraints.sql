-- =========================================================================
-- archtics -- foreign keys
--
-- The seating hierarchy cascades: removing a building removes its levels,
-- sections, rows and seats, because none of them means anything on its own.
-- Season-ticket and licence records do not cascade -- a PSL is a property
-- right and an assignment is a financial record, so both RESTRICT.
--
-- Cross-system references stay unenforced: archtics.event_manifest
-- .tm_event_code, archtics.sta_account.sfdc_account_id,
-- archtics.sta_account.tm_account_number and
-- archtics.suite_lease.sap_contract_number are all business keys resolved
-- through common.entity_xref.
-- =========================================================================

ALTER TABLE archtics.level
    ADD CONSTRAINT fk_level_building
        FOREIGN KEY (building_id) REFERENCES archtics.building (building_id)
        ON DELETE CASCADE;

ALTER TABLE archtics.section
    ADD CONSTRAINT fk_section_level
        FOREIGN KEY (level_id) REFERENCES archtics.level (level_id)
        ON DELETE CASCADE;

ALTER TABLE archtics.seat_row
    ADD CONSTRAINT fk_seat_row_section
        FOREIGN KEY (section_id) REFERENCES archtics.section (section_id)
        ON DELETE CASCADE;

ALTER TABLE archtics.seat
    ADD CONSTRAINT fk_seat_row
        FOREIGN KEY (seat_row_id) REFERENCES archtics.seat_row (seat_row_id)
        ON DELETE CASCADE;

ALTER TABLE archtics.seat_attribute_assignment
    ADD CONSTRAINT fk_seat_attr_seat
        FOREIGN KEY (seat_id) REFERENCES archtics.seat (seat_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_seat_attr_attribute
        FOREIGN KEY (seat_attribute_id) REFERENCES archtics.seat_attribute (seat_attribute_id)
        ON DELETE RESTRICT;

ALTER TABLE archtics.accessibility_feature
    ADD CONSTRAINT fk_accessibility_building
        FOREIGN KEY (building_id) REFERENCES archtics.building (building_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_accessibility_level
        FOREIGN KEY (level_id) REFERENCES archtics.level (level_id)
        ON DELETE SET NULL;

ALTER TABLE archtics.suite
    ADD CONSTRAINT fk_suite_building
        FOREIGN KEY (building_id) REFERENCES archtics.building (building_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_suite_level
        FOREIGN KEY (level_id) REFERENCES archtics.level (level_id)
        ON DELETE RESTRICT;

ALTER TABLE archtics.parking_lot
    ADD CONSTRAINT fk_parking_lot_building
        FOREIGN KEY (building_id) REFERENCES archtics.building (building_id)
        ON DELETE CASCADE;

-- -------------------------------------------------------------------------
-- Manifests.
-- -------------------------------------------------------------------------
ALTER TABLE archtics.manifest
    ADD CONSTRAINT fk_manifest_building
        FOREIGN KEY (building_id) REFERENCES archtics.building (building_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_manifest_supersedes
        FOREIGN KEY (supersedes_manifest_id) REFERENCES archtics.manifest (manifest_id)
        ON DELETE RESTRICT;

ALTER TABLE archtics.manifest_section
    ADD CONSTRAINT fk_manifest_section_manifest
        FOREIGN KEY (manifest_id) REFERENCES archtics.manifest (manifest_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_manifest_section_section
        FOREIGN KEY (section_id) REFERENCES archtics.section (section_id)
        ON DELETE RESTRICT;

-- An event manifest is a historical record once played, so RESTRICT on the
-- manifest it used: superseding a configuration must not erase what was used.
ALTER TABLE archtics.event_manifest
    ADD CONSTRAINT fk_event_manifest_building
        FOREIGN KEY (building_id) REFERENCES archtics.building (building_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_event_manifest_manifest
        FOREIGN KEY (manifest_id) REFERENCES archtics.manifest (manifest_id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Season tickets.
-- -------------------------------------------------------------------------
ALTER TABLE archtics.plan
    ADD CONSTRAINT fk_plan_building
        FOREIGN KEY (building_id) REFERENCES archtics.building (building_id)
        ON DELETE RESTRICT;

ALTER TABLE archtics.plan_seat
    ADD CONSTRAINT fk_plan_seat_plan
        FOREIGN KEY (plan_id) REFERENCES archtics.plan (plan_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_plan_seat_seat
        FOREIGN KEY (seat_id) REFERENCES archtics.seat (seat_id)
        ON DELETE CASCADE;

ALTER TABLE archtics.psl
    ADD CONSTRAINT fk_psl_seat
        FOREIGN KEY (seat_id) REFERENCES archtics.seat (seat_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_psl_holder
        FOREIGN KEY (holder_sta_account_id) REFERENCES archtics.sta_account (sta_account_id)
        ON DELETE RESTRICT;

ALTER TABLE archtics.suite_lease
    ADD CONSTRAINT fk_suite_lease_suite
        FOREIGN KEY (suite_id) REFERENCES archtics.suite (suite_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_suite_lease_account
        FOREIGN KEY (sta_account_id) REFERENCES archtics.sta_account (sta_account_id)
        ON DELETE SET NULL;

ALTER TABLE archtics.account_seat_assignment
    ADD CONSTRAINT fk_assignment_account
        FOREIGN KEY (sta_account_id) REFERENCES archtics.sta_account (sta_account_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_assignment_plan
        FOREIGN KEY (plan_id) REFERENCES archtics.plan (plan_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_assignment_seat
        FOREIGN KEY (seat_id) REFERENCES archtics.seat (seat_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_assignment_psl
        FOREIGN KEY (psl_id) REFERENCES archtics.psl (psl_id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_assignment_relocated_to
        FOREIGN KEY (relocated_to_assignment_id)
        REFERENCES archtics.account_seat_assignment (account_seat_assignment_id)
        ON DELETE SET NULL;

ALTER TABLE archtics.renewal
    ADD CONSTRAINT fk_renewal_account
        FOREIGN KEY (sta_account_id) REFERENCES archtics.sta_account (sta_account_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_renewal_plan
        FOREIGN KEY (plan_id) REFERENCES archtics.plan (plan_id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Parking.
-- -------------------------------------------------------------------------
ALTER TABLE archtics.parking_inventory
    ADD CONSTRAINT fk_parking_inventory_lot
        FOREIGN KEY (parking_lot_id) REFERENCES archtics.parking_lot (parking_lot_id)
        ON DELETE CASCADE;

ALTER TABLE archtics.parking_activation
    ADD CONSTRAINT fk_parking_activation_event_manifest
        FOREIGN KEY (event_manifest_id) REFERENCES archtics.event_manifest (event_manifest_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_parking_activation_inventory
        FOREIGN KEY (parking_inventory_id)
        REFERENCES archtics.parking_inventory (parking_inventory_id)
        ON DELETE RESTRICT;
