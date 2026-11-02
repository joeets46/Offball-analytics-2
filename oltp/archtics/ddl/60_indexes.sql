-- =========================================================================
-- archtics -- indexes
--
-- Two access patterns dominate: walking the seating hierarchy downward to
-- render a seat map, and answering "what does this account hold" for the
-- season-ticket desk.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Seating hierarchy. Each level is read by its parent.
-- -------------------------------------------------------------------------
CREATE INDEX ix_level_building      ON archtics.level (building_id);
CREATE INDEX ix_section_level       ON archtics.section (level_id);
CREATE INDEX ix_seat_row_section    ON archtics.seat_row (section_id);
CREATE INDEX ix_seat_row_ref        ON archtics.seat (seat_row_id);

-- The seat-map render: live seats in a row, in order.
CREATE INDEX ix_seat_active
    ON archtics.seat (seat_row_id, seat_ordinal)
    WHERE seat_status = 'active';

-- PSL seats are a small subset queried on its own.
CREATE INDEX ix_seat_psl ON archtics.seat (seat_row_id) WHERE is_psl_seat;

CREATE INDEX ix_seat_attr_attribute
    ON archtics.seat_attribute_assignment (seat_attribute_id);
-- Current attribute assignments only, which is what the seat map needs.
CREATE INDEX ix_seat_attr_current
    ON archtics.seat_attribute_assignment (seat_id)
    WHERE effective_to IS NULL;

CREATE INDEX ix_accessibility_building ON archtics.accessibility_feature (building_id);
CREATE INDEX ix_accessibility_level
    ON archtics.accessibility_feature (level_id) WHERE level_id IS NOT NULL;
-- The ADA compliance review queue.
CREATE INDEX ix_accessibility_noncompliant
    ON archtics.accessibility_feature (building_id, last_assessed_on)
    WHERE compliance_status IN ('non_compliant', 'remediation_planned', 'under_review');

CREATE INDEX ix_suite_building       ON archtics.suite (building_id);
CREATE INDEX ix_suite_level          ON archtics.suite (level_id);
CREATE INDEX ix_suite_available      ON archtics.suite (building_id, suite_type)
    WHERE suite_status = 'available';

CREATE INDEX ix_parking_lot_building ON archtics.parking_lot (building_id);

-- -------------------------------------------------------------------------
-- Manifests.
-- -------------------------------------------------------------------------
CREATE INDEX ix_manifest_building    ON archtics.manifest (building_id);
CREATE INDEX ix_manifest_supersedes
    ON archtics.manifest (supersedes_manifest_id) WHERE supersedes_manifest_id IS NOT NULL;
-- Only one manifest per code is active at a time; a partial unique index says
-- so without forbidding many superseded versions.
CREATE UNIQUE INDEX ux_manifest_one_active
    ON archtics.manifest (building_id, manifest_code)
    WHERE manifest_status = 'active';
-- The fire-certificate expiry sweep.
CREATE INDEX ix_manifest_cert_expiry
    ON archtics.manifest (fire_cert_expires_on)
    WHERE manifest_status IN ('approved', 'active') AND fire_cert_expires_on IS NOT NULL;

CREATE INDEX ix_manifest_section_section ON archtics.manifest_section (section_id);

CREATE INDEX ix_event_manifest_building_date
    ON archtics.event_manifest (building_id, event_date);
CREATE INDEX ix_event_manifest_manifest  ON archtics.event_manifest (manifest_id);
CREATE INDEX ix_event_manifest_date      ON archtics.event_manifest (event_date);
-- Attendance reconciliation: played events with no gate count yet.
CREATE INDEX ix_event_manifest_unreconciled
    ON archtics.event_manifest (event_date)
    WHERE turnstile_count IS NULL;

-- -------------------------------------------------------------------------
-- Season tickets. The account-centred view is the whole job of the desk.
-- -------------------------------------------------------------------------
CREATE INDEX ix_sta_account_email
    ON archtics.sta_account (primary_email) WHERE primary_email IS NOT NULL;
CREATE INDEX ix_sta_account_sfdc
    ON archtics.sta_account (sfdc_account_id) WHERE sfdc_account_id IS NOT NULL;
CREATE INDEX ix_sta_account_tm
    ON archtics.sta_account (tm_account_number) WHERE tm_account_number IS NOT NULL;
-- The relocation queue is ordered by priority, descending.
CREATE INDEX ix_sta_account_priority
    ON archtics.sta_account (priority_score DESC)
    WHERE account_status = 'active';

CREATE INDEX ix_plan_building_season ON archtics.plan (building_id, season_year);
CREATE INDEX ix_plan_on_sale         ON archtics.plan (on_sale_from)
    WHERE plan_status = 'on_sale';

CREATE INDEX ix_plan_seat_seat       ON archtics.plan_seat (seat_id);
CREATE INDEX ix_plan_seat_available
    ON archtics.plan_seat (plan_id) WHERE availability_status = 'available';

CREATE INDEX ix_psl_seat             ON archtics.psl (seat_id);
CREATE INDEX ix_psl_holder
    ON archtics.psl (holder_sta_account_id) WHERE holder_sta_account_id IS NOT NULL;
-- One live licence per seat.
CREATE UNIQUE INDEX ux_psl_one_active_per_seat
    ON archtics.psl (seat_id) WHERE psl_status IN ('active', 'in_transfer');

CREATE INDEX ix_suite_lease_suite    ON archtics.suite_lease (suite_id);
CREATE INDEX ix_suite_lease_account
    ON archtics.suite_lease (sta_account_id) WHERE sta_account_id IS NOT NULL;
CREATE INDEX ix_suite_lease_expiring
    ON archtics.suite_lease (ends_on) WHERE lease_status = 'active';

-- "What does this account hold this season" -- the desk's primary query.
CREATE INDEX ix_assignment_account_season
    ON archtics.account_seat_assignment (sta_account_id, season_year);
CREATE INDEX ix_assignment_plan      ON archtics.account_seat_assignment (plan_id);
CREATE INDEX ix_assignment_seat      ON archtics.account_seat_assignment (seat_id);
CREATE INDEX ix_assignment_psl
    ON archtics.account_seat_assignment (psl_id) WHERE psl_id IS NOT NULL;
CREATE INDEX ix_assignment_relocated_to
    ON archtics.account_seat_assignment (relocated_to_assignment_id)
    WHERE relocated_to_assignment_id IS NOT NULL;
-- The arrears worklist.
CREATE INDEX ix_assignment_arrears
    ON archtics.account_seat_assignment (season_year, sta_account_id)
    WHERE payment_plan_status IN ('arrears', 'defaulted');

CREATE INDEX ix_renewal_account      ON archtics.renewal (sta_account_id, to_season_year);
CREATE INDEX ix_renewal_plan         ON archtics.renewal (plan_id);
-- The renewal campaign worklist: outstanding invitations by deadline.
CREATE INDEX ix_renewal_outstanding
    ON archtics.renewal (deadline_on)
    WHERE renewal_status IN ('invited', 'reminded');

CREATE INDEX ix_parking_inventory_lot ON archtics.parking_inventory (parking_lot_id);
CREATE INDEX ix_parking_activation_inventory
    ON archtics.parking_activation (parking_inventory_id);

-- -------------------------------------------------------------------------
-- Incremental extraction watermarks.
-- -------------------------------------------------------------------------
CREATE INDEX ix_building_updated_at   ON archtics.building (updated_at);
CREATE INDEX ix_seat_updated_at       ON archtics.seat (updated_at);
CREATE INDEX ix_manifest_updated_at   ON archtics.manifest (updated_at);
CREATE INDEX ix_event_manifest_updated_at ON archtics.event_manifest (updated_at);
CREATE INDEX ix_sta_account_updated_at ON archtics.sta_account (updated_at);
CREATE INDEX ix_assignment_updated_at ON archtics.account_seat_assignment (updated_at);
CREATE INDEX ix_renewal_updated_at    ON archtics.renewal (updated_at);
CREATE INDEX ix_psl_updated_at        ON archtics.psl (updated_at);
