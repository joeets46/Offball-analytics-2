-- =========================================================================
-- archtics -- table comments
-- =========================================================================

COMMENT ON TABLE archtics.seat_attribute IS
    'Seat attribute vocabulary. The target model flattens these into booleans and STRING columns on venue.seat, losing both the history and the controlled list.';
COMMENT ON TABLE archtics.level IS
    'A tier of the building -- lower bowl, club, suite, upper. Joined with section to feed target venue.seating_section.';
COMMENT ON TABLE archtics.section IS
    'Seating sections with orientation and status. Feeds target venue.seating_section.';
COMMENT ON TABLE archtics.manifest_section IS
    'Which sections a manifest uses and for what. One of only six associative tables the upstream MVM retains; feeds target venue.config_section_allocation.';
COMMENT ON TABLE archtics.accessibility_feature IS
    'Building-level accessibility provisions with their compliance status. ADA and equivalent regimes set minimum ratios against capacity.';
COMMENT ON TABLE archtics.suite IS
    'Physical premium inventory. Feeds target venue.suite; the lease commercials sit in SAP.';
COMMENT ON TABLE archtics.suite_lease IS
    'Suite occupancy rights. The money sits in the referenced SAP contract; this is the right to be in the room.';
COMMENT ON TABLE archtics.parking_lot IS
    'Parking facilities with sub-category allocations. Feeds target venue.parking_lot.';
COMMENT ON TABLE archtics.parking_inventory IS
    'Standing allocation of a lot into sellable buckets -- general, season, suite, staff, accessible.';
COMMENT ON TABLE archtics.parking_activation IS
    'A parking allocation opened for one event. Feeds target venue.parking_activation.';
COMMENT ON TABLE archtics.plan IS
    'Season-ticket products -- full season, half season, game packs. Feeds target ticketing.season_ticket_package.';
COMMENT ON TABLE archtics.plan_seat IS
    'Which seats a plan may be sold against, with per-seat price overrides.';
COMMENT ON TABLE archtics.account_seat_assignment IS
    'Which account holds which seat on which plan for which season. The central fact of season-ticket administration, and a genuine four-way relationship the target model flattens onto one row.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE archtics.building IS
    'The venue as a seating structure, and authoritative for it. Coordinates are kept at six decimal places; the target model rounds every decimal to two, which locates a venue to within about a kilometre.';
COMMENT ON TABLE archtics.seat_row IS
    'Rows within a section. Modeled explicitly because rows are what get added, removed and relabelled in a reconfiguration, and their sort order is not derivable from the label.';
COMMENT ON TABLE archtics.manifest IS
    'A named, reusable seating configuration. Capacity is a stated, fire-authority-approved figure rather than a count of rows, and an approved manifest must carry a valid certificate.';
COMMENT ON TABLE archtics.event_manifest IS
    'A manifest applied to one fixture. The turnstile count here is what the target fixture.actual_attendance receives, and it differs from seats sold by the no-shows.';
COMMENT ON TABLE archtics.sta_account IS
    'Season-ticket accounts. The highest-value fans in the model and the hardest to resolve, because the account is often held by a company or a family rather than the person who attends.';
COMMENT ON TABLE archtics.renewal IS
    'The annual renewal decision, tracked separately from the resulting assignment because the campaign is managed and reported on in its own right. Seat count can change on renewal, which is the churn signal that matters.';
