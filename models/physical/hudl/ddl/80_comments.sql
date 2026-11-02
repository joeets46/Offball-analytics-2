-- =========================================================================
-- hudl -- table comments
-- =========================================================================

COMMENT ON TABLE hudl.team IS
    'A team as the analysis system knows it. A different record from the SAP profit centre doing duty as league.team, which is what common.entity_xref reconciles.';
COMMENT ON TABLE hudl.season IS
    'Analysis seasons.';
COMMENT ON TABLE hudl.competition IS
    'Competitions within a season, including training and friendlies, which are coded in the same system.';
COMMENT ON TABLE hudl.label IS
    'Coding labels within a group. The vocabulary that makes instances queryable, and entirely absent from the target model.';
COMMENT ON TABLE hudl.game IS
    'A match. The same fixture exists as tm_axs.event and archtics.event_manifest; this is the only one of the three that knows the score.';
COMMENT ON TABLE hudl.game_participant IS
    'Who played, and for how long. Feeds target event.participant; minutes played is the denominator for every per-90 metric.';
COMMENT ON TABLE hudl.video_angle IS
    'Camera angles on a video. Not synchronised by default, so each carries its own offset.';
COMMENT ON TABLE hudl.code_row IS
    'A row in the analyst coding window, usually a player or a phase of play.';
COMMENT ON TABLE hudl.playlist IS
    'A curated sequence of instances, for opposition analysis, player feedback or recruitment.';
COMMENT ON TABLE hudl.playlist_instance IS
    'Playlist contents, ordered, with per-clip annotation.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE hudl.organization IS
    'The club or federation account.';
COMMENT ON TABLE hudl.player IS
    'The athlete as performer. Deliberately holds no address or contact data: an analysis platform does not need it, and SuccessFactors is the identity record.';
COMMENT ON TABLE hudl.video IS
    'Match video. The match-start offset is what converts an instance position in video milliseconds into a match minute, without which the target scoring minute is wrong.';
COMMENT ON TABLE hudl.label_group IS
    'Groups of coding labels. Exclusive groups allow one label per instance, inclusive groups several, and that distinction is what makes a label set queryable.';
COMMENT ON TABLE hudl.instance IS
    'A coded moment on a timeline -- the atomic unit of sports analysis and the source of target event.scoring_event. Pitch coordinates are normalised 0..100 so positions compare across venues.';
COMMENT ON TABLE hudl.player_game_metric IS
    'The derived statistic. Carries the timeline it was computed from, so a disputed number can be traced back to the instances behind it.';
