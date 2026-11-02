-- =========================================================================
-- hudl -- SportsCode / Hudl
--
-- Named in the upstream model as "SportsCode / Hudl (Performance Analytics
-- and Video Analysis)".
--
-- Owns 5 of the 153 in-scope MVM tables, but they are the ones no other
-- system can provide: what actually happened in the match.
-- target event.match_result, event.scoring_event, event.participant,
-- athlete.performance_stat and athlete.injury_record.
--
-- Native idiom modeled here:
--   * The coded instance. A video analyst watches a match and creates
--     "instances" on a timeline -- a shot, a turnover, a set piece -- each a
--     time range on a video, each tagged with labels from label groups. This
--     is the native unit of sports analysis and it is nothing like a
--     statistics table.
--   * Statistics are DERIVED from instances, not entered. "17 shots on
--     target" is a count of instances with a particular label combination.
--     Target athlete.performance_stat is the aggregate, so the lakehouse
--     receives the number without the evidence.
--   * UUID keys. Hudl is cloud-native with offline-capable clients: an
--     analyst codes a match on a laptop with no connectivity and syncs later,
--     so ids must be client-generatable without coordination. A sequence
--     would not survive that.
--   * Time is in milliseconds from the start of the video, not wall clock. A
--     video timeline and a match clock are different things, and the mapping
--     to real time runs through the video's own start offset.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS hudl;

COMMENT ON SCHEMA hudl IS
    'SportsCode / Hudl -- video analysis, coded instances and derived '
    'performance metrics. The only named source for match events and athlete '
    'performance. Extract pattern: API incremental on updated_at.';
