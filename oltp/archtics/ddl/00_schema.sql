-- =========================================================================
-- archtics -- Archtics
--
-- Venue seating and inventory management. Named in the upstream model as
-- "Archtics (Venue Seating and Inventory Management)".
--
-- Owns 14 of the 153 in-scope MVM tables: the seating side of `venue`, the
-- season-ticket side of `ticketing`, and target ticketing.ticket_inventory --
-- which maps here rather than to TM/AXS because the manifest, not the selling
-- system, is authoritative for what seats exist.
--
-- Native idiom modeled here:
--   * A strict physical hierarchy -- building, level, section, row, seat -- that
--     the target model flattens into three tables. Seat labels are not unique
--     on their own anywhere above section level, so the keys are composite
--     business keys backed by surrogate identities.
--   * The manifest/event_manifest split. A manifest is a reusable seating
--     configuration (basketball, concert end-stage, concert in-the-round); an
--     event_manifest is that configuration applied to one fixture. The target
--     venue.capacity_config collapses the two, which loses the reuse.
--   * Season tickets as a first-class structure: account, plan, seat
--     assignment, personal seat licence, renewal. TM/AXS sees only the
--     resulting orders.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS archtics;

COMMENT ON SCHEMA archtics IS
    'Archtics -- seating manifest, physical seat inventory and season-ticket '
    'administration. Authoritative for seat existence and capacity; TM/AXS '
    'mirrors availability. Extract pattern: CDC log.';
