-- =========================================================================
-- hudl -- indexes
--
-- The dominant query is "give me every instance matching this label
-- combination for this player across these matches", which is the
-- instance-to-label join run at scale. That join and the extraction paths are
-- what the indexes here serve.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Organisation, people, vocabulary.
-- -------------------------------------------------------------------------
CREATE INDEX ix_team_organization     ON hudl.team (organization_id) WHERE is_active;
CREATE INDEX ix_team_sap              ON hudl.team (sap_prctr) WHERE sap_prctr IS NOT NULL;

CREATE INDEX ix_player_organization   ON hudl.player (organization_id) WHERE is_active;
CREATE INDEX ix_player_name           ON hudl.player (display_name);
-- Resolution against the SuccessFactors person record.
CREATE INDEX ix_player_external_ref
    ON hudl.player (external_person_ref) WHERE external_person_ref IS NOT NULL;

CREATE INDEX ix_season_organization   ON hudl.season (organization_id, starts_on DESC);
CREATE INDEX ix_competition_season    ON hudl.competition (season_id);

CREATE INDEX ix_label_group_organization ON hudl.label_group (organization_id);
CREATE INDEX ix_label_group_ref       ON hudl.label (label_group_id, display_order);
CREATE INDEX ix_label_short_code      ON hudl.label (short_code) WHERE short_code IS NOT NULL;

CREATE INDEX ix_metric_definition_organization ON hudl.metric_definition (organization_id);
CREATE INDEX ix_metric_definition_filter
    ON hudl.metric_definition USING GIN (instance_filter) WHERE instance_filter IS NOT NULL;

-- -------------------------------------------------------------------------
-- Matches.
-- -------------------------------------------------------------------------
CREATE INDEX ix_game_competition      ON hudl.game (competition_id, kickoff_at DESC);
CREATE INDEX ix_game_kickoff          ON hudl.game (kickoff_at DESC);
CREATE INDEX ix_game_home_team        ON hudl.game (home_team_id, kickoff_at DESC)
    WHERE home_team_id IS NOT NULL;
CREATE INDEX ix_game_away_team        ON hudl.game (away_team_id, kickoff_at DESC)
    WHERE away_team_id IS NOT NULL;
-- Resolution against the ticketing event.
CREATE INDEX ix_game_tm_event         ON hudl.game (tm_event_code) WHERE tm_event_code IS NOT NULL;
-- The coding backlog: matches played but not yet analysed.
CREATE INDEX ix_game_coding_backlog
    ON hudl.game (kickoff_at) WHERE coding_status IN ('not_started', 'in_progress');

CREATE INDEX ix_participant_player    ON hudl.game_participant (player_id, game_id);
CREATE INDEX ix_participant_team      ON hudl.game_participant (team_id, game_id);
CREATE INDEX ix_participant_game      ON hudl.game_participant (game_id);

-- -------------------------------------------------------------------------
-- Video and timelines.
-- -------------------------------------------------------------------------
CREATE INDEX ix_video_game            ON hudl.video (game_id);
CREATE INDEX ix_video_dalet
    ON hudl.video (dalet_media_object_id) WHERE dalet_media_object_id IS NOT NULL;
CREATE INDEX ix_video_angle_video     ON hudl.video_angle (video_id);

CREATE INDEX ix_timeline_game         ON hudl.timeline (game_id);
CREATE INDEX ix_timeline_video        ON hudl.timeline (video_id);

CREATE INDEX ix_code_row_timeline     ON hudl.code_row (timeline_id, display_order);
CREATE INDEX ix_code_row_player       ON hudl.code_row (player_id) WHERE player_id IS NOT NULL;
CREATE INDEX ix_code_row_team         ON hudl.code_row (team_id) WHERE team_id IS NOT NULL;

-- -------------------------------------------------------------------------
-- Instances. The hot path.
-- -------------------------------------------------------------------------
CREATE INDEX ix_instance_timeline     ON hudl.instance (timeline_id, start_ms);
CREATE INDEX ix_instance_code_row     ON hudl.instance (code_row_id, start_ms);
CREATE INDEX ix_instance_player       ON hudl.instance (player_id, timeline_id)
    WHERE player_id IS NOT NULL;
CREATE INDEX ix_instance_opponent     ON hudl.instance (opponent_player_id)
    WHERE opponent_player_id IS NOT NULL;
-- Match-clock lookup: "what happened in the 87th minute".
CREATE INDEX ix_instance_match_clock
    ON hudl.instance (timeline_id, match_period, match_minute)
    WHERE match_minute IS NOT NULL;
-- Spatial: instances in a pitch region, for zone analysis.
CREATE INDEX ix_instance_pitch_position
    ON hudl.instance (timeline_id, pitch_x, pitch_y) WHERE pitch_x IS NOT NULL;

-- The label join, from both directions. This is the query the whole schema
-- exists to serve, so both orderings are indexed deliberately -- the reverse
-- direction ("every instance with label X") is as common as the forward one.
CREATE INDEX ix_instance_label_label  ON hudl.instance_label (label_id, instance_id);

CREATE INDEX ix_playlist_organization ON hudl.playlist (organization_id);
CREATE INDEX ix_playlist_shared       ON hudl.playlist (organization_id, purpose) WHERE is_shared;
CREATE INDEX ix_playlist_instance_instance ON hudl.playlist_instance (instance_id);

-- -------------------------------------------------------------------------
-- Derived metrics and monitoring.
-- -------------------------------------------------------------------------
CREATE INDEX ix_pgm_player_metric     ON hudl.player_game_metric (player_id, metric_definition_id);
CREATE INDEX ix_pgm_game              ON hudl.player_game_metric (game_id);
CREATE INDEX ix_pgm_metric_definition ON hudl.player_game_metric (metric_definition_id);
CREATE INDEX ix_pgm_timeline          ON hudl.player_game_metric (timeline_id)
    WHERE timeline_id IS NOT NULL;
-- Only published figures are extracted; unpublished ones are work in progress.
CREATE INDEX ix_pgm_published         ON hudl.player_game_metric (computed_at) WHERE is_published;

CREATE INDEX ix_wearable_player_time  ON hudl.wearable_session (player_id, started_at DESC);
CREATE INDEX ix_wearable_game         ON hudl.wearable_session (game_id) WHERE game_id IS NOT NULL;
-- Training load, which is the bulk of the data and the input to injury-risk
-- work.
CREATE INDEX ix_wearable_training
    ON hudl.wearable_session (player_id, started_at DESC) WHERE session_type = 'training';

CREATE INDEX ix_injury_player         ON hudl.injury_note (player_id, reported_on DESC);
CREATE INDEX ix_injury_game           ON hudl.injury_note (game_id) WHERE game_id IS NOT NULL;
CREATE INDEX ix_injury_instance       ON hudl.injury_note (instance_id) WHERE instance_id IS NOT NULL;
-- Current unavailability: the team-sheet question.
CREATE INDEX ix_injury_unavailable
    ON hudl.injury_note (player_id, expected_return_on)
    WHERE availability_status IN ('unavailable', 'limited', 'return_to_play');

-- -------------------------------------------------------------------------
-- Extraction watermarks.
-- -------------------------------------------------------------------------
CREATE INDEX ix_game_updated_at       ON hudl.game (updated_at);
CREATE INDEX ix_instance_updated_at   ON hudl.instance (updated_at);
CREATE INDEX ix_pgm_updated_at        ON hudl.player_game_metric (updated_at);
CREATE INDEX ix_player_updated_at     ON hudl.player (updated_at);
CREATE INDEX ix_injury_updated_at     ON hudl.injury_note (updated_at);
CREATE INDEX ix_wearable_updated_at   ON hudl.wearable_session (updated_at);
CREATE INDEX ix_participant_updated_at ON hudl.game_participant (updated_at);
