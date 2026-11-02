-- =========================================================================
-- dalet -- workflow, rights and scheduling
--
-- Jobs move media; rights govern what may be shown where and when;
-- running orders and schedule items place it on a channel.
--
-- The rights model is the part worth reading. A right is never global and
-- never permanent: it is a window, per territory, per platform, per language,
-- with exclusivity and blackout conditions. Target broadcast.rights_window
-- keeps the window but not the conditions, and target broadcast.blackout_rule
-- is derived from them -- which is why that mapping is a `derive` rather than
-- a copy.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Job and task. Feed target content.production_order, content.ingest_job and
-- broadcast.production.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.job (
    job_id              VARCHAR(40)  PRIMARY KEY,
    job_type            VARCHAR(30)  NOT NULL
        CHECK (job_type IN ('ingest', 'transcode', 'edit', 'qc', 'subtitle',
                            'publish', 'archive', 'restore', 'production', 'delete')),
    media_object_id     VARCHAR(40),
    -- Null for a production job that will create its own placeholder.
    title               VARCHAR(200) NOT NULL,
    priority            VARCHAR(20)  NOT NULL DEFAULT 'medium'
        CHECK (priority IN ('critical', 'high', 'medium', 'low')),
    job_status          VARCHAR(20)  NOT NULL DEFAULT 'queued'
        CHECK (job_status IN ('queued', 'running', 'paused', 'completed',
                              'failed', 'cancelled', 'awaiting_approval')),
    -- Live production is deadline-driven: a highlights package has to be out
    -- before the audience loses interest, so the due time is operational
    -- rather than administrative.
    due_at              TIMESTAMPTZ,
    started_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ,
    progress_percent    SMALLINT     NOT NULL DEFAULT 0
        CHECK (progress_percent BETWEEN 0 AND 100),
    assigned_to         VARCHAR(120),
    requested_by        VARCHAR(120),
    failure_detail      TEXT,
    retry_count         SMALLINT     NOT NULL DEFAULT 0 CHECK (retry_count >= 0),
    -- Business key to the fixture this production covers.
    tm_event_code       VARCHAR(30),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_job_time_order
        CHECK (completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at),
    CONSTRAINT ck_job_completed_progress
        CHECK (job_status <> 'completed' OR progress_percent = 100),
    CONSTRAINT ck_job_failed_has_detail
        CHECK ((job_status = 'failed') = (failure_detail IS NOT NULL)),
    CONSTRAINT ck_job_completed_has_timestamp
        CHECK (job_status <> 'completed' OR completed_at IS NOT NULL)
);

CREATE TABLE dalet.job_task (
    job_task_id         VARCHAR(40)  PRIMARY KEY,
    job_id              VARCHAR(40)  NOT NULL,
    task_name           VARCHAR(160) NOT NULL,
    task_order          SMALLINT     NOT NULL DEFAULT 0,
    task_status          VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (task_status IN ('pending', 'running', 'completed', 'failed', 'skipped')),
    -- A task can depend on another completing first, which is what makes a
-- job a workflow rather than a list.
    depends_on_task_id  VARCHAR(40),
    worker_node         VARCHAR(80),
    started_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ,
    duration_seconds    INTEGER      CHECK (duration_seconds IS NULL OR duration_seconds >= 0),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_job_task_not_self_dependent
        CHECK (depends_on_task_id IS NULL OR depends_on_task_id <> job_task_id),
    CONSTRAINT ck_job_task_time_order
        CHECK (completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at)
);

-- -------------------------------------------------------------------------
-- Transfer. Moving essences between storage and sites.
-- Contributes to target content.ingest_job.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.transfer (
    transfer_id         VARCHAR(40)  PRIMARY KEY,
    job_id              VARCHAR(40),
    essence_id          VARCHAR(40),
    direction           VARCHAR(10)  NOT NULL
        CHECK (direction IN ('inbound', 'outbound', 'internal')),
    source_uri          TEXT,
    destination_uri     TEXT,
    protocol            VARCHAR(20)
        CHECK (protocol IS NULL OR protocol IN ('aspera', 'ftp', 'sftp', 's3', 'http', 'smb', 'sdi')),
    bytes_total         BIGINT       CHECK (bytes_total IS NULL OR bytes_total >= 0),
    bytes_transferred   BIGINT       NOT NULL DEFAULT 0 CHECK (bytes_transferred >= 0),
    transfer_status     VARCHAR(20)  NOT NULL DEFAULT 'queued'
        CHECK (transfer_status IN ('queued', 'running', 'completed', 'failed', 'cancelled')),
    throughput_mbps     NUMERIC(10,2) CHECK (throughput_mbps IS NULL OR throughput_mbps >= 0),
    started_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_transfer_bytes_within_total
        CHECK (bytes_total IS NULL OR bytes_transferred <= bytes_total)
);

-- -------------------------------------------------------------------------
-- Editorial brief. Feeds target content.editorial_brief.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.editorial_brief (
    editorial_brief_id  VARCHAR(40)  PRIMARY KEY,
    title               VARCHAR(200) NOT NULL,
    brief_body          TEXT         NOT NULL,
    content_class       VARCHAR(30),
    -- Target platform and audience shape the edit: a 15-second vertical clip
    -- and a three-minute highlights package are different commissions.
    target_publication_target_id VARCHAR(40),
    target_duration_seconds INTEGER  CHECK (target_duration_seconds IS NULL OR target_duration_seconds > 0),
    aspect_ratio        VARCHAR(10)
        CHECK (aspect_ratio IS NULL OR aspect_ratio IN ('16:9', '9:16', '1:1', '4:5', '21:9')),
    language_code       common.dom_language_code,
    brief_status        VARCHAR(20)  NOT NULL DEFAULT 'draft'
        CHECK (brief_status IN ('draft', 'approved', 'in_production', 'delivered', 'cancelled')),
    commissioned_by     VARCHAR(120),
    due_at              TIMESTAMPTZ,
    -- The resulting job, once commissioned into production.
    job_id              VARCHAR(40),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Rights contract and window.
--
-- Feed target broadcast.rights_window, target broadcast.blackout_rule and
-- target content.license.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.rights_contract (
    rights_contract_id  VARCHAR(40)  PRIMARY KEY,
    contract_reference  VARCHAR(60)  NOT NULL UNIQUE,
    counterparty_name   VARCHAR(200) NOT NULL,
    -- Inbound rights are acquired; outbound are sold. The same table holds
    -- both, and confusing them is how a licence gets double counted.
    direction           VARCHAR(10)  NOT NULL
        CHECK (direction IN ('inbound', 'outbound')),
    contract_status     VARCHAR(20)  NOT NULL DEFAULT 'draft'
        CHECK (contract_status IN ('draft', 'executed', 'active', 'expired', 'terminated')),
    effective_from      DATE,
    effective_to        DATE,
    -- Business keys to the systems that carry the commercial terms.
    sfdc_contract_id    CHAR(18),
    sap_contract_number CHAR(10),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_rights_contract_dates
        CHECK (effective_to IS NULL OR effective_from IS NULL OR effective_to >= effective_from)
);

COMMENT ON COLUMN dalet.rights_contract.direction IS
    'Inbound rights are bought, outbound are sold. One table holds both, and '
    'an extract that ignores direction counts acquired rights as revenue.';

CREATE TABLE dalet.rights_window (
    rights_window_id    VARCHAR(40)  PRIMARY KEY,
    rights_contract_id  VARCHAR(40)  NOT NULL,
    media_object_id     VARCHAR(40),
    collection_id       VARCHAR(40),
    -- A window covers a single asset or a whole collection (a season pack),
    -- never both.
    publication_target_id VARCHAR(40),
    channel_id          VARCHAR(40),

    -- The window itself.
    window_from         TIMESTAMPTZ  NOT NULL,
    window_to           TIMESTAMPTZ,
    -- Territory and language are the two axes every rights dispute turns on.
    territory_codes     TEXT[]       NOT NULL,
    excluded_territory_codes TEXT[],
    language_codes      TEXT[],

    -- Exclusivity. An exclusive window blocks every other licensee in the
    -- same territory for the same period, which is the constraint the
    -- scheduling system has to respect.
    is_exclusive        BOOLEAN      NOT NULL DEFAULT FALSE,
    rights_type         VARCHAR(20)  NOT NULL
        CHECK (rights_type IN ('live', 'delayed', 'highlights', 'archive', 'clips', 'full_replay')),
    -- Delay in minutes for a delayed right, which is a contractual term and
    -- not a technical one.
    delay_minutes       INTEGER      CHECK (delay_minutes IS NULL OR delay_minutes >= 0),
    max_clip_seconds    INTEGER      CHECK (max_clip_seconds IS NULL OR max_clip_seconds > 0),
    -- Blackout conditions, from which target broadcast.blackout_rule is
    -- derived.
    blackout_radius_km  INTEGER      CHECK (blackout_radius_km IS NULL OR blackout_radius_km >= 0),
    blackout_until_sellout BOOLEAN   NOT NULL DEFAULT FALSE,
    requires_drm        BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_rights_window_period
        CHECK (window_to IS NULL OR window_to > window_from),
    CONSTRAINT ck_rights_window_subject
        CHECK ((media_object_id IS NOT NULL) <> (collection_id IS NOT NULL)),
    CONSTRAINT ck_rights_window_territories_present
        CHECK (array_length(territory_codes, 1) >= 1),
    -- A delayed right must say how long the delay is.
    CONSTRAINT ck_rights_window_delay
        CHECK ((rights_type = 'delayed') = (delay_minutes IS NOT NULL)),
    -- A clip right must cap the clip length.
    CONSTRAINT ck_rights_window_clip_cap
        CHECK (rights_type <> 'clips' OR max_clip_seconds IS NOT NULL)
);

COMMENT ON TABLE dalet.rights_window IS
    'The right to show something, somewhere, for a period. Target '
    'broadcast.rights_window keeps the dates; the territory arrays, '
    'exclusivity and blackout conditions are what target '
    'broadcast.blackout_rule has to be derived from.';
COMMENT ON COLUMN dalet.rights_window.blackout_until_sellout IS
    'The classic local-blackout term: no local broadcast until the venue '
    'sells out. It couples a rights rule to live ticketing inventory, which '
    'is the single clearest cross-system dependency in the whole model.';

-- -------------------------------------------------------------------------
-- Publication. A delivery of an asset to a target.
-- Feeds target content.publish_event.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.publication (
    publication_id      VARCHAR(40)  PRIMARY KEY,
    media_object_id     VARCHAR(40)  NOT NULL,
    essence_id          VARCHAR(40),
    publication_target_id VARCHAR(40) NOT NULL,
    rights_window_id    VARCHAR(40),
    -- Nullable, and that is a compliance signal: a publication with no rights
    -- window behind it is either owned content or an unlicensed publication.
    publication_status  VARCHAR(20)  NOT NULL DEFAULT 'scheduled'
        CHECK (publication_status IN ('scheduled', 'publishing', 'live',
                                      'expired', 'withdrawn', 'failed', 'blocked')),
    scheduled_at        TIMESTAMPTZ,
    published_at        TIMESTAMPTZ,
    expires_at          TIMESTAMPTZ,
    withdrawn_at        TIMESTAMPTZ,
    withdrawal_reason   VARCHAR(40)
        CHECK (withdrawal_reason IS NULL OR withdrawal_reason IN
            ('rights_expired', 'rights_dispute', 'editorial', 'technical_fault',
             'legal_request', 'takedown_notice', 'replaced')),
    external_url        TEXT,
    failure_detail      TEXT,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_publication_withdrawal
        CHECK ((withdrawn_at IS NULL) = (withdrawal_reason IS NULL)),
    CONSTRAINT ck_publication_withdrawn_status
        CHECK ((publication_status = 'withdrawn') = (withdrawn_at IS NOT NULL)),
    CONSTRAINT ck_publication_failed_detail
        CHECK ((publication_status = 'failed') = (failure_detail IS NOT NULL)),
    CONSTRAINT ck_publication_expiry_after_publish
        CHECK (expires_at IS NULL OR published_at IS NULL OR expires_at > published_at)
);

COMMENT ON COLUMN dalet.publication.rights_window_id IS
    'Nullable, and the null is meaningful: a live publication with no rights '
    'window behind it is either wholly owned content or an unlicensed '
    'publication, and only the first is acceptable.';

-- -------------------------------------------------------------------------
-- Running order and schedule item. Linear playout.
-- Feed target broadcast.broadcast_schedule and target event.broadcast_window.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.running_order (
    running_order_id    VARCHAR(40)  PRIMARY KEY,
    channel_id          VARCHAR(40)  NOT NULL,
    broadcast_date      DATE         NOT NULL,
    name                VARCHAR(160) NOT NULL,
    running_order_status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (running_order_status IN ('draft', 'approved', 'locked', 'on_air', 'completed')),
    -- Locked means playout has taken it; changes after that are as-run
    -- amendments rather than schedule edits.
    locked_at           TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (channel_id, broadcast_date, name),
    CONSTRAINT ck_running_order_locked
        CHECK (running_order_status NOT IN ('locked', 'on_air', 'completed')
               OR locked_at IS NOT NULL)
);

CREATE TABLE dalet.schedule_item (
    schedule_item_id    VARCHAR(40)  PRIMARY KEY,
    running_order_id    VARCHAR(40)  NOT NULL,
    media_object_id     VARCHAR(40),
    item_order          INTEGER      NOT NULL,
    title               VARCHAR(200) NOT NULL,
    item_type           VARCHAR(20)  NOT NULL
        CHECK (item_type IN ('programme', 'live', 'promo', 'commercial', 'filler', 'junction')),
    -- Scheduled against as-run: the gap between them is the operational
    -- reality of live broadcast, where a match overrunning shifts everything
    -- after it.
    scheduled_start_at  TIMESTAMPTZ  NOT NULL,
    scheduled_duration_seconds INTEGER NOT NULL CHECK (scheduled_duration_seconds > 0),
    actual_start_at     TIMESTAMPTZ,
    actual_duration_seconds INTEGER  CHECK (actual_duration_seconds IS NULL OR actual_duration_seconds >= 0),
    -- Business key to the fixture, for a live sports item.
    tm_event_code       VARCHAR(30),
    is_live             BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (running_order_id, item_order)
);

COMMENT ON COLUMN dalet.schedule_item.actual_duration_seconds IS
    'As-run duration. A match going to extra time shifts every subsequent '
    'item, and the scheduled-versus-actual gap is what the target '
    'broadcast.broadcast_schedule cannot show.';

-- -------------------------------------------------------------------------
-- Feed. A live signal. Feeds target broadcast.live_feed.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.feed (
    feed_id             VARCHAR(40)  PRIMARY KEY,
    feed_code           VARCHAR(30)  NOT NULL UNIQUE,
    name                VARCHAR(160) NOT NULL,
    feed_type           VARCHAR(20)  NOT NULL
        CHECK (feed_type IN ('world_feed', 'clean', 'iso_camera', 'tactical',
                             'commentary', 'backup', 'contribution')),
    channel_id          VARCHAR(40),
    media_object_id     VARCHAR(40),
    -- Technical signal parameters.
    transport           VARCHAR(20)
        CHECK (transport IS NULL OR transport IN ('sdi', 'srt', 'rist', 'zixi', 'rtmp', 'st2110', 'satellite')),
    resolution          VARCHAR(10)
        CHECK (resolution IS NULL OR resolution IN ('SD', 'HD', 'FHD', '4K', '8K')),
    bitrate_mbps        NUMERIC(8,2) CHECK (bitrate_mbps IS NULL OR bitrate_mbps > 0),
    audio_config        VARCHAR(20),
    language_code       common.dom_language_code,
    -- A clean feed carries no commentary or graphics, which is what makes it
    -- licensable to a broadcaster who adds their own.
    is_clean            BOOLEAN      NOT NULL DEFAULT FALSE,
    feed_status         VARCHAR(20)  NOT NULL DEFAULT 'standby'
        CHECK (feed_status IN ('standby', 'live', 'degraded', 'lost', 'ended')),
    live_from           TIMESTAMPTZ,
    live_to             TIMESTAMPTZ,
    -- Business key to the fixture being covered.
    tm_event_code       VARCHAR(30),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_feed_live_period
        CHECK (live_to IS NULL OR live_from IS NULL OR live_to > live_from)
);
