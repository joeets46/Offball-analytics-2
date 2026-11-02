-- =========================================================================
-- tm_axs -- Ticketmaster / AXS
--
-- Ticketing and access control. Named in the upstream model as
-- "Ticketmaster / AXS (Ticketing and Access Control)".
--
-- Owns 30 of the 153 in-scope MVM tables: all 15 of `ticketing`, 7 of
-- `security`, and the `event.fixture` anchor itself.
--
-- Native idiom modeled here:
--   * Integer surrogate keys via GENERATED ALWAYS AS IDENTITY -- the host
--     system assigns them, so they are never client-supplied.
--   * A separate `venue_ref` record: TM/AXS keeps its own venue copy rather
--     than reading the Archtics building, which is exactly why
--     common.entity_xref exists.
--   * Money as NUMERIC(18,4) at rest even where the target model rounds to
--     NUMERIC(18,2), because fee and tax splits need the extra scale.
--   * Scan traffic in a partitioned table: scans are the highest-volume rows
--     in the whole estate and arrive in event-time bursts.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS tm_axs;

COMMENT ON SCHEMA tm_axs IS
    'Ticketmaster / AXS -- primary ticketing, payment capture and venue access '
    'control. System of record for ticketing.* and security access control in '
    'the target model. Extract pattern: CDC log.';
