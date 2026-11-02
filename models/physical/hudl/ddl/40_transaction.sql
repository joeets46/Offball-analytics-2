-- =========================================================================
-- hudl -- matches, video, instances and derived metrics
--
-- The chain that produces every match statistic in the target model:
--
--   game -> video -> timeline -> instance -> instance_label
--                                     |
--                                     +-> player_game_metric (derived)
--
-- Target event.scoring_event is an instance with a scoring label. Target
-- athlete.performance_stat is a player_game_metric. Both arrive in the
-- lakehouse detached from the video and the labels that justify them.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Game. Feeds target event.match_result.
--
-- The same fixture exists as tm_axs.event (a sellable event) and
-- archtics.event_manifest (a seating configuration). This is the third, and
-- it is the only one that knows the score.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.game (
    game_id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    competition_id      UUID         NOT NULL,
    home_team_id        UUID,
    away_team_id        UUID,
    -- Both nullable: a training session or an individual analysis has no
    -- opposition, and those are coded in the same system.
    kickoff_at          TIMESTAMPTZ  NOT NULL,
    venue_name          VARCHAR(160),
    -- Business key into the ticketing system's event.
    tm_event_code       VARCHAR(30),

    home_score          SMALLINT     CHECK (home_score IS NULL OR home_score >= 0),
    away_score          SMALLINT     CHECK (away_score IS NULL OR away_score >= 0),
    -- Result status, which is distinct from whether the match was played.
    result_status       VARCHAR(20)
        CHECK (result_status IS NULL OR result_status IN
            ('home_win', 'away_win', 'draw', 'void', 'awarded', 'abandoned')),
    went_to_extra_time  BOOLEAN      NOT NULL DEFAULT FALSE,
    decided_by_penalties BOOLEAN     NOT NULL DEFAULT FALSE,
    home_penalty_score  SMALLINT     CHECK (home_penalty_score IS NULL OR home_penalty_score >= 0),
    away_penalty_score  SMALLINT     CHECK (away_penalty_score IS NULL OR away_penalty_score >= 0),

    coding_status        VARCHAR(20) NOT NULL DEFAULT 'not_started'
        CHECK (coding_status IN ('not_started', 'in_progress', 'coded', 'reviewed', 'published')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A team cannot play itself.
    CONSTRAINT ck_game_teams_differ
        CHECK (home_team_id IS NULL OR away_team_id IS NULL OR home_team_id <> away_team_id),
    -- A score for one side implies a score for the other.
    CONSTRAINT ck_game_score_pair
        CHECK ((home_score IS NULL) = (away_score IS NULL)),
    -- Penalty scores only exist if it went to penalties, and a shootout
    -- cannot be drawn.
    CONSTRAINT ck_game_penalty_fields
        CHECK (decided_by_penalties
               = (home_penalty_score IS NOT NULL AND away_penalty_score IS NOT NULL)),
    CONSTRAINT ck_game_penalties_decisive
        CHECK (NOT decided_by_penalties OR home_penalty_score <> away_penalty_score),
    -- Penalties imply extra time was played first in every code that has both.
    CONSTRAINT ck_game_penalties_after_extra_time
        CHECK (NOT decided_by_penalties OR went_to_extra_time)
);

COMMENT ON CONSTRAINT ck_game_penalties_decisive ON hudl.game IS
    'A shootout exists to produce a winner, so equal penalty scores are '
    'always a data error rather than a drawn shootout.';

-- -------------------------------------------------------------------------
-- Game participant. Feeds target event.participant.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.game_participant (
    game_participant_id UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id             UUID         NOT NULL,
    player_id           UUID         NOT NULL,
    team_id             UUID         NOT NULL,
    shirt_number        SMALLINT     CHECK (shirt_number IS NULL OR shirt_number BETWEEN 0 AND 999),
    position_played     VARCHAR(40),
    is_starter          BOOLEAN      NOT NULL DEFAULT FALSE,
    is_captain          BOOLEAN      NOT NULL DEFAULT FALSE,
    -- Minutes on the pitch, which is the denominator for every per-90 metric.
    minute_on           SMALLINT     CHECK (minute_on IS NULL OR minute_on >= 0),
    minute_off          SMALLINT     CHECK (minute_off IS NULL OR minute_off >= 0),
    minutes_played      SMALLINT     CHECK (minutes_played IS NULL OR minutes_played >= 0),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (game_id, player_id),
    CONSTRAINT ck_participant_substitution_order
        CHECK (minute_off IS NULL OR minute_on IS NULL OR minute_off >= minute_on),
    -- A starter comes on at the beginning by definition.
    CONSTRAINT ck_participant_starter_minute
        CHECK (NOT is_starter OR minute_on IS NULL OR minute_on = 0)
);

-- One captain per team per game.
CREATE UNIQUE INDEX ux_game_participant_one_captain
    ON hudl.game_participant (game_id, team_id) WHERE is_captain;

-- -------------------------------------------------------------------------
-- Video and angle. The medium the analysis is attached to.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.video (
    video_id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id             UUID         NOT NULL,
    title               VARCHAR(200) NOT NULL,
    -- Duration and the offset between video time and match time. Instances
    -- are positioned in video milliseconds, so without this offset they
    -- cannot be placed on the match clock.
    duration_ms         BIGINT       NOT NULL CHECK (duration_ms > 0),
    match_start_offset_ms BIGINT     NOT NULL DEFAULT 0 CHECK (match_start_offset_ms >= 0),
    frame_rate          NUMERIC(6,3) CHECK (frame_rate IS NULL OR frame_rate > 0),
    resolution          VARCHAR(10)
        CHECK (resolution IS NULL OR resolution IN ('SD', 'HD', 'FHD', '4K', '8K')),
    storage_uri         TEXT,
    -- Business key into the broadcast asset system, when the video is a
    -- broadcast feed rather than a tactical camera.
    dalet_media_object_id VARCHAR(40),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_video_offset_within_duration
        CHECK (match_start_offset_ms < duration_ms)
);

COMMENT ON COLUMN hudl.video.match_start_offset_ms IS
    'Milliseconds of video before the match begins. Instances are timed in '
    'video milliseconds, so this offset is what converts an instance position '
    'into a match minute. Without it the target scoring_event minute is wrong.';

CREATE TABLE hudl.video_angle (
    video_angle_id      UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id            UUID         NOT NULL,
    angle_name          VARCHAR(80)  NOT NULL
        CHECK (angle_name IN ('broadcast', 'tactical', 'high_behind', 'endzone',
                              'sideline', 'drone', 'player_cam', 'other')),
    storage_uri         TEXT,
    -- Angles are not synchronised by default; each carries its own offset.
    sync_offset_ms      INTEGER      NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (video_id, angle_name)
);

-- -------------------------------------------------------------------------
-- Timeline and code row. The analyst's workspace structure.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.timeline (
    timeline_id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id             UUID         NOT NULL,
    video_id            UUID         NOT NULL,
    name                VARCHAR(120) NOT NULL,
    -- Several analysts code the same match for different purposes -- one for
    -- opposition analysis, one for set pieces -- so a game has several
    -- timelines and they disagree. Target event.scoring_event has no timeline
    -- dimension, so two timelines produce duplicate scoring events.
    created_by          VARCHAR(120),
    purpose             VARCHAR(40),
    is_primary          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE hudl.timeline IS
    'A coding pass over a video. One game has several -- different analysts, '
    'different purposes -- and they legitimately disagree. The extract into '
    'target event.scoring_event must pick the primary timeline or it double '
    'counts every goal.';

-- Exactly one primary timeline per game, which is what the extract reads.
CREATE UNIQUE INDEX ux_timeline_one_primary
    ON hudl.timeline (game_id) WHERE is_primary;

CREATE TABLE hudl.code_row (
    code_row_id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    timeline_id         UUID         NOT NULL,
    name                VARCHAR(120) NOT NULL,
    -- A code row is usually a player or a phase of play.
    row_type            VARCHAR(20)  NOT NULL DEFAULT 'event'
        CHECK (row_type IN ('player', 'team', 'phase', 'event', 'period')),
    player_id           UUID,
    team_id             UUID,
    display_order       SMALLINT     NOT NULL DEFAULT 0,
    display_colour      common.dom_color_code,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A player row names a player; a team row names a team.
    CONSTRAINT ck_code_row_player
        CHECK (row_type <> 'player' OR player_id IS NOT NULL),
    CONSTRAINT ck_code_row_team
        CHECK (row_type <> 'team' OR team_id IS NOT NULL)
);

-- -------------------------------------------------------------------------
-- Instance. The atomic unit of analysis. Feeds target event.scoring_event.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.instance (
    instance_id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    timeline_id         UUID         NOT NULL,
    code_row_id         UUID         NOT NULL,
    -- Position on the video, in milliseconds. A lead and lag around the
    -- moment of interest is how analysts review it in context.
    start_ms            BIGINT       NOT NULL CHECK (start_ms >= 0),
    end_ms              BIGINT       NOT NULL CHECK (end_ms >= 0),
    -- Match clock, derived on write from the video offset. Stored rather than
    -- computed because the offset can be corrected later and historical
    -- instances must keep the minute they were published with.
    match_period        SMALLINT     CHECK (match_period IS NULL OR match_period BETWEEN 1 AND 6),
    match_minute        SMALLINT     CHECK (match_minute IS NULL OR match_minute >= 0),
    match_second        SMALLINT     CHECK (match_second IS NULL OR match_second BETWEEN 0 AND 59),

    -- Spatial position, as pitch coordinates normalised 0..100 on each axis so
    -- they are comparable across venues with different pitch dimensions.
    pitch_x             NUMERIC(5,2) CHECK (pitch_x IS NULL OR pitch_x BETWEEN 0 AND 100),
    pitch_y             NUMERIC(5,2) CHECK (pitch_y IS NULL OR pitch_y BETWEEN 0 AND 100),
    end_pitch_x         NUMERIC(5,2) CHECK (end_pitch_x IS NULL OR end_pitch_x BETWEEN 0 AND 100),
    end_pitch_y         NUMERIC(5,2) CHECK (end_pitch_y IS NULL OR end_pitch_y BETWEEN 0 AND 100),

    -- Who and against whom.
    player_id           UUID,
    opponent_player_id  UUID,
    notes               TEXT,
    created_by          VARCHAR(120),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_instance_time_order CHECK (end_ms >= start_ms),
    CONSTRAINT ck_instance_players_differ
        CHECK (opponent_player_id IS NULL OR player_id IS NULL
               OR opponent_player_id <> player_id),
    -- Pitch coordinates come in pairs.
    CONSTRAINT ck_instance_pitch_pair CHECK ((pitch_x IS NULL) = (pitch_y IS NULL)),
    CONSTRAINT ck_instance_end_pitch_pair
        CHECK ((end_pitch_x IS NULL) = (end_pitch_y IS NULL))
);

COMMENT ON COLUMN hudl.instance.pitch_x IS
    'Normalised 0..100 rather than metres, so positions are comparable across '
    'venues with different pitch dimensions. Target event.scoring_event has '
    'no spatial columns at all.';
COMMENT ON COLUMN hudl.instance.match_minute IS
    'Derived from the video offset at write time and then frozen. If the '
    'offset is later corrected, already-published instances keep the minute '
    'they were reported with, which is what downstream consumers cited.';

-- -------------------------------------------------------------------------
-- Instance label. The many-to-many that makes instances queryable.
--
-- This is the single most important table in the schema and it has no
-- counterpart anywhere in the 200-table target model.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.instance_label (
    instance_id         UUID         NOT NULL,
    label_id            UUID         NOT NULL,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (instance_id, label_id)
);

COMMENT ON TABLE hudl.instance_label IS
    'What an instance means. "Shot, right foot, inside box, on target, goal" '
    'is five rows here. No target table corresponds, so the semantics of '
    'every coded event are lost on the way into the lakehouse -- only those '
    'labels the mapping explicitly promotes to columns survive.';

-- -------------------------------------------------------------------------
-- Playlist. A curated sequence of instances, for review or presentation.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.playlist (
    playlist_id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id     UUID         NOT NULL,
    name                VARCHAR(160) NOT NULL,
    description         TEXT,
    purpose             VARCHAR(30)
        CHECK (purpose IS NULL OR purpose IN
            ('opposition_analysis', 'player_feedback', 'set_pieces', 'recruitment',
             'officiating_review', 'highlights', 'medical')),
    created_by          VARCHAR(120),
    is_shared           BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE hudl.playlist_instance (
    playlist_id         UUID         NOT NULL,
    instance_id         UUID         NOT NULL,
    display_order       INTEGER      NOT NULL DEFAULT 0,
    annotation          TEXT,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (playlist_id, instance_id)
);

-- -------------------------------------------------------------------------
-- Player game metric. The derived statistic.
-- Feeds target athlete.performance_stat.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.player_game_metric (
    player_game_metric_id UUID       PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id             UUID         NOT NULL,
    player_id           UUID         NOT NULL,
    metric_definition_id UUID        NOT NULL,
    -- NUMERIC(18,6): metrics range from integer counts to expected-goals
    -- values at four decimal places, and the target model rounds everything
    -- to two.
    metric_value        NUMERIC(18,6) NOT NULL,
    -- Per-90 normalisation, the standard comparison basis.
    per_90_value        NUMERIC(18,6),
    -- Which timeline produced it, so a figure can be traced to its coding
    -- pass and recomputed.
    timeline_id         UUID,
    computed_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),
    is_published        BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (game_id, player_id, metric_definition_id)
);

COMMENT ON COLUMN hudl.player_game_metric.timeline_id IS
    'The coding pass this figure was computed from. Target '
    'athlete.performance_stat drops it, so a disputed statistic cannot be '
    'traced back to the instances behind it.';

-- -------------------------------------------------------------------------
-- Wearable session. GPS and heart-rate load monitoring.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.wearable_session (
    wearable_session_id UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id           UUID         NOT NULL,
    game_id             UUID,
    -- Null game means a training session, which is where most load
    -- accumulates and which the target model does not represent at all.
    session_type        VARCHAR(20)  NOT NULL
        CHECK (session_type IN ('match', 'training', 'rehabilitation', 'testing')),
    started_at          TIMESTAMPTZ  NOT NULL,
    ended_at            TIMESTAMPTZ,
    device_serial       VARCHAR(60),
    -- Load measures. These are the inputs to injury-risk work, which is why
    -- the precision matters.
    total_distance_m    NUMERIC(10,2) CHECK (total_distance_m IS NULL OR total_distance_m >= 0),
    high_speed_distance_m NUMERIC(10,2)
        CHECK (high_speed_distance_m IS NULL OR high_speed_distance_m >= 0),
    sprint_count        SMALLINT     CHECK (sprint_count IS NULL OR sprint_count >= 0),
    max_speed_kmh       NUMERIC(5,2) CHECK (max_speed_kmh IS NULL OR max_speed_kmh >= 0),
    accelerations       SMALLINT     CHECK (accelerations IS NULL OR accelerations >= 0),
    decelerations       SMALLINT     CHECK (decelerations IS NULL OR decelerations >= 0),
    player_load         NUMERIC(10,2) CHECK (player_load IS NULL OR player_load >= 0),
    avg_heart_rate      SMALLINT     CHECK (avg_heart_rate IS NULL OR avg_heart_rate BETWEEN 30 AND 250),
    max_heart_rate      SMALLINT     CHECK (max_heart_rate IS NULL OR max_heart_rate BETWEEN 30 AND 250),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_wearable_session_times
        CHECK (ended_at IS NULL OR ended_at > started_at),
    CONSTRAINT ck_wearable_hsd_within_total
        CHECK (high_speed_distance_m IS NULL OR total_distance_m IS NULL
               OR high_speed_distance_m <= total_distance_m),
    CONSTRAINT ck_wearable_heart_rate_order
        CHECK (max_heart_rate IS NULL OR avg_heart_rate IS NULL
               OR max_heart_rate >= avg_heart_rate),
    -- A match session must name the match.
    CONSTRAINT ck_wearable_match_has_game
        CHECK (session_type <> 'match' OR game_id IS NOT NULL)
);

COMMENT ON TABLE hudl.wearable_session IS
    'Load monitoring, including training. Target athlete.injury_record is '
    'per-injury, so the training load that preceded an injury -- the point of '
    'collecting it -- is not represented downstream.';

-- -------------------------------------------------------------------------
-- Injury note. Availability, not diagnosis.
-- Feeds target athlete.injury_record.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.injury_note (
    injury_note_id      UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id           UUID         NOT NULL,
    game_id             UUID,
    -- The analysis platform records availability and mechanism, NOT clinical
    -- detail. Diagnosis, treatment and medical history belong in an EMR,
    -- which is not among the ten named systems -- so what the target
    -- athlete.injury_record can actually be populated with is this and only
    -- this.
    reported_on         DATE         NOT NULL,
    body_area           VARCHAR(40)
        CHECK (body_area IS NULL OR body_area IN
            ('head', 'neck', 'shoulder', 'arm', 'hand', 'trunk', 'back',
             'hip', 'groin', 'thigh', 'knee', 'calf', 'ankle', 'foot', 'other')),
    laterality          VARCHAR(10)
        CHECK (laterality IS NULL OR laterality IN ('left', 'right', 'bilateral', 'central')),
    mechanism           VARCHAR(20)
        CHECK (mechanism IS NULL OR mechanism IN ('contact', 'non_contact', 'overuse', 'illness', 'unknown')),
    occurred_during     VARCHAR(20)
        CHECK (occurred_during IS NULL OR occurred_during IN ('match', 'training', 'outside', 'unknown')),
    availability_status VARCHAR(20)  NOT NULL
        CHECK (availability_status IN ('available', 'limited', 'unavailable', 'return_to_play')),
    expected_return_on  DATE,
    actual_return_on    DATE,
    days_unavailable    SMALLINT     CHECK (days_unavailable IS NULL OR days_unavailable >= 0),
    -- Linked instance: the moment of injury on the video, when it was coded.
    instance_id         UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_injury_return_order
        CHECK (actual_return_on IS NULL OR actual_return_on >= reported_on),
    CONSTRAINT ck_injury_laterality_needs_area
        CHECK (laterality IS NULL OR body_area IS NOT NULL)
);

COMMENT ON TABLE hudl.injury_note IS
    'Availability and mechanism, deliberately not diagnosis. No EMR is among '
    'the ten named systems, so this is the ceiling on what target '
    'athlete.injury_record can honestly contain -- which is why that mapping '
    'carries medium confidence.';
