-- =========================================================================
-- hudl -- foreign keys
--
-- The analysis chain cascades hard: deleting a timeline deletes its code rows,
-- its instances and their labels, because a coded instance has no meaning
-- outside the pass that produced it. Derived metrics also cascade from the
-- game, since they are recomputable rather than authoritative.
--
-- Players and label vocabularies do not cascade: a label still in use must not
-- be removable, and a player's history outlives any one timeline.
-- =========================================================================

ALTER TABLE hudl.team
    ADD CONSTRAINT fk_team_organization
        FOREIGN KEY (organization_id) REFERENCES hudl.organization (organization_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.player
    ADD CONSTRAINT fk_player_organization
        FOREIGN KEY (organization_id) REFERENCES hudl.organization (organization_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.season
    ADD CONSTRAINT fk_season_organization
        FOREIGN KEY (organization_id) REFERENCES hudl.organization (organization_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.competition
    ADD CONSTRAINT fk_competition_season
        FOREIGN KEY (season_id) REFERENCES hudl.season (season_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.label_group
    ADD CONSTRAINT fk_label_group_organization
        FOREIGN KEY (organization_id) REFERENCES hudl.organization (organization_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.label
    ADD CONSTRAINT fk_label_group
        FOREIGN KEY (label_group_id) REFERENCES hudl.label_group (label_group_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.metric_definition
    ADD CONSTRAINT fk_metric_definition_organization
        FOREIGN KEY (organization_id) REFERENCES hudl.organization (organization_id)
        ON DELETE CASCADE;

-- -------------------------------------------------------------------------
-- Matches.
-- -------------------------------------------------------------------------
ALTER TABLE hudl.game
    ADD CONSTRAINT fk_game_competition
        FOREIGN KEY (competition_id) REFERENCES hudl.competition (competition_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_game_home_team
        FOREIGN KEY (home_team_id) REFERENCES hudl.team (team_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_game_away_team
        FOREIGN KEY (away_team_id) REFERENCES hudl.team (team_id)
        ON DELETE RESTRICT;

ALTER TABLE hudl.game_participant
    ADD CONSTRAINT fk_participant_game
        FOREIGN KEY (game_id) REFERENCES hudl.game (game_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_participant_player
        FOREIGN KEY (player_id) REFERENCES hudl.player (player_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_participant_team
        FOREIGN KEY (team_id) REFERENCES hudl.team (team_id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Video and the coding chain.
-- -------------------------------------------------------------------------
ALTER TABLE hudl.video
    ADD CONSTRAINT fk_video_game
        FOREIGN KEY (game_id) REFERENCES hudl.game (game_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.video_angle
    ADD CONSTRAINT fk_video_angle_video
        FOREIGN KEY (video_id) REFERENCES hudl.video (video_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.timeline
    ADD CONSTRAINT fk_timeline_game
        FOREIGN KEY (game_id) REFERENCES hudl.game (game_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_timeline_video
        FOREIGN KEY (video_id) REFERENCES hudl.video (video_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.code_row
    ADD CONSTRAINT fk_code_row_timeline
        FOREIGN KEY (timeline_id) REFERENCES hudl.timeline (timeline_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_code_row_player
        FOREIGN KEY (player_id) REFERENCES hudl.player (player_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_code_row_team
        FOREIGN KEY (team_id) REFERENCES hudl.team (team_id)
        ON DELETE RESTRICT;

ALTER TABLE hudl.instance
    ADD CONSTRAINT fk_instance_timeline
        FOREIGN KEY (timeline_id) REFERENCES hudl.timeline (timeline_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_instance_code_row
        FOREIGN KEY (code_row_id) REFERENCES hudl.code_row (code_row_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_instance_player
        FOREIGN KEY (player_id) REFERENCES hudl.player (player_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_instance_opponent_player
        FOREIGN KEY (opponent_player_id) REFERENCES hudl.player (player_id)
        ON DELETE RESTRICT;

-- A label in use cannot be deleted: RESTRICT on the label side, CASCADE on
-- the instance side.
ALTER TABLE hudl.instance_label
    ADD CONSTRAINT fk_instance_label_instance
        FOREIGN KEY (instance_id) REFERENCES hudl.instance (instance_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_instance_label_label
        FOREIGN KEY (label_id) REFERENCES hudl.label (label_id)
        ON DELETE RESTRICT;

ALTER TABLE hudl.playlist
    ADD CONSTRAINT fk_playlist_organization
        FOREIGN KEY (organization_id) REFERENCES hudl.organization (organization_id)
        ON DELETE CASCADE;

ALTER TABLE hudl.playlist_instance
    ADD CONSTRAINT fk_playlist_instance_playlist
        FOREIGN KEY (playlist_id) REFERENCES hudl.playlist (playlist_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_playlist_instance_instance
        FOREIGN KEY (instance_id) REFERENCES hudl.instance (instance_id)
        ON DELETE CASCADE;

-- -------------------------------------------------------------------------
-- Derived metrics and monitoring.
-- -------------------------------------------------------------------------
ALTER TABLE hudl.player_game_metric
    ADD CONSTRAINT fk_pgm_game
        FOREIGN KEY (game_id) REFERENCES hudl.game (game_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_pgm_player
        FOREIGN KEY (player_id) REFERENCES hudl.player (player_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_pgm_metric_definition
        FOREIGN KEY (metric_definition_id)
        REFERENCES hudl.metric_definition (metric_definition_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_pgm_timeline
        FOREIGN KEY (timeline_id) REFERENCES hudl.timeline (timeline_id)
        ON DELETE SET NULL;

ALTER TABLE hudl.wearable_session
    ADD CONSTRAINT fk_wearable_player
        FOREIGN KEY (player_id) REFERENCES hudl.player (player_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_wearable_game
        FOREIGN KEY (game_id) REFERENCES hudl.game (game_id)
        ON DELETE SET NULL;

ALTER TABLE hudl.injury_note
    ADD CONSTRAINT fk_injury_player
        FOREIGN KEY (player_id) REFERENCES hudl.player (player_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_injury_game
        FOREIGN KEY (game_id) REFERENCES hudl.game (game_id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_injury_instance
        FOREIGN KEY (instance_id) REFERENCES hudl.instance (instance_id)
        ON DELETE SET NULL;
