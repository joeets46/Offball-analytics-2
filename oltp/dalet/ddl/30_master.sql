-- =========================================================================
-- dalet -- assets, metadata vocabulary and channels
--
-- The metadata model is the thing to read carefully here. A broadcaster's
-- metadata schema changes monthly, so Dalet models fields and controlled
-- vocabularies as data. Target content.metadata_tag flattens the result,
-- which is why that mapping is a four-table join.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Folder. The hierarchical catalog. Feeds target content.category.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.folder (
    folder_id           VARCHAR(40)  PRIMARY KEY,
    parent_folder_id    VARCHAR(40),
    name                VARCHAR(160) NOT NULL,
    folder_path         TEXT         NOT NULL,
    -- Materialised path alongside the parent reference: MAM trees are deep and
    -- read far more often than they are rearranged.
    depth               SMALLINT     NOT NULL DEFAULT 0 CHECK (depth >= 0),
    is_system_folder    BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (folder_path),
    CONSTRAINT ck_folder_not_self_parent
        CHECK (parent_folder_id IS NULL OR parent_folder_id <> folder_id),
    -- A root folder has no parent, and only a root folder has depth 0.
    CONSTRAINT ck_folder_depth_consistent
        CHECK ((depth = 0) = (parent_folder_id IS NULL))
);

COMMENT ON COLUMN dalet.folder.folder_path IS
    'Materialised path, kept alongside parent_folder_id. Asset trees are deep '
    'and read constantly but rearranged rarely, so the redundancy pays.';

-- -------------------------------------------------------------------------
-- Metadata vocabulary. Controlled term lists.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.vocabulary (
    vocabulary_id       VARCHAR(40)  PRIMARY KEY,
    name                VARCHAR(120) NOT NULL,
    description         TEXT,
    is_hierarchical     BOOLEAN      NOT NULL DEFAULT FALSE,
    is_open             BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN dalet.vocabulary.is_open IS
    'An open vocabulary lets operators add terms as they tag. Useful, and the '
    'reason controlled vocabularies drift -- which is what the target '
    'content.metadata_tag inherits.';

CREATE TABLE dalet.vocabulary_term (
    vocabulary_term_id  VARCHAR(40)  PRIMARY KEY,
    vocabulary_id       VARCHAR(40)  NOT NULL,
    term                VARCHAR(160) NOT NULL,
    -- Hierarchical vocabularies: Sport > Football > Premier League.
    parent_term_id      VARCHAR(40),
    external_ref        VARCHAR(80),
    language_code       common.dom_language_code,
    is_deprecated       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (vocabulary_id, term),
    CONSTRAINT ck_term_not_self_parent
        CHECK (parent_term_id IS NULL OR parent_term_id <> vocabulary_term_id)
);

-- -------------------------------------------------------------------------
-- Metadata field. The schema, as data. Feeds target content.metadata_tag.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.metadata_field (
    metadata_field_id   VARCHAR(40)  PRIMARY KEY,
    field_name          VARCHAR(80)  NOT NULL UNIQUE,
    display_label       VARCHAR(160) NOT NULL,
    data_type           VARCHAR(20)  NOT NULL
        CHECK (data_type IN ('text', 'long_text', 'integer', 'decimal', 'date',
                             'timestamp', 'boolean', 'vocabulary', 'timecode')),
    -- A vocabulary-typed field draws its values from a controlled list.
    vocabulary_id       VARCHAR(40),
    is_multi_valued     BOOLEAN      NOT NULL DEFAULT FALSE,
    is_mandatory        BOOLEAN      NOT NULL DEFAULT FALSE,
    -- Mandatory for publication rather than for creation: an asset can be
    -- ingested incomplete but not published incomplete, which is the real
    -- editorial rule.
    is_mandatory_for_publication BOOLEAN NOT NULL DEFAULT FALSE,
    is_searchable       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- Only a vocabulary-typed field names a vocabulary.
    CONSTRAINT ck_metadata_field_vocabulary
        CHECK ((data_type = 'vocabulary') = (vocabulary_id IS NOT NULL))
);

COMMENT ON TABLE dalet.metadata_field IS
    'The metadata schema held as data. A broadcaster extends it monthly, so a '
    'MAM that needed a DDL change per field would be unusable. Target '
    'content.metadata_tag is the flattened result.';

-- -------------------------------------------------------------------------
-- Channel. A linear or OTT outlet. Feeds target broadcast.channel.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.channel (
    channel_id          VARCHAR(40)  PRIMARY KEY,
    channel_code        common.dom_channel_code NOT NULL UNIQUE,
    name                VARCHAR(160) NOT NULL,
    channel_type        VARCHAR(20)  NOT NULL
        CHECK (channel_type IN ('linear_tv', 'linear_radio', 'ott', 'fast', 'social', 'ppv')),
    territory_code      common.dom_iso3_code,
    language_code       common.dom_language_code,
    resolution          VARCHAR(10)
        CHECK (resolution IS NULL OR resolution IN ('SD', 'HD', 'FHD', '4K', '8K')),
    channel_status      VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (channel_status IN ('active', 'inactive', 'suspended', 'pending_launch', 'decommissioned')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Publication target. Where content is delivered.
-- Feeds target content.platform_channel.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.publication_target (
    publication_target_id VARCHAR(40) PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    target_type         VARCHAR(20)  NOT NULL
        CHECK (target_type IN ('ott_platform', 'social', 'cdn', 'broadcast_playout',
                               'partner_feed', 'archive', 'web')),
    platform_name       VARCHAR(80),
    channel_id          VARCHAR(40),
    -- Technical delivery spec. A target that will not accept the essence
    -- profile is the commonest cause of a failed publication.
    required_essence_profile VARCHAR(60),
    max_duration_seconds INTEGER     CHECK (max_duration_seconds IS NULL OR max_duration_seconds > 0),
    requires_captions   BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Media object. The editorial asset.
-- Feeds target content.asset and target broadcast.media_asset.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.media_object (
    media_object_id     VARCHAR(40)  PRIMARY KEY,
    folder_id           VARCHAR(40),
    title              VARCHAR(255)  NOT NULL,
    description         TEXT,
    asset_type          VARCHAR(20)  NOT NULL
        CHECK (asset_type IN ('video', 'audio', 'image', 'document', 'graphic', 'subtitle', 'package')),
    content_class       VARCHAR(30)
        CHECK (content_class IS NULL OR content_class IN
            ('live_match', 'highlights', 'interview', 'documentary', 'promo',
             'archive', 'social_clip', 'press_conference', 'behind_scenes', 'other')),
    -- Placeholder state. An object with no essence is intended, not broken:
    -- the production order creates it and the camera fills it later.
    is_placeholder      BOOLEAN      NOT NULL DEFAULT FALSE,
    lifecycle_status    VARCHAR(20)  NOT NULL DEFAULT 'placeholder'
        CHECK (lifecycle_status IN ('placeholder', 'ingesting', 'available',
                                    'in_review', 'approved', 'published', 'archived', 'purged')),
    -- Duration in timecode terms. Frame-accurate, because broadcast is.
    duration_frames     BIGINT       CHECK (duration_frames IS NULL OR duration_frames >= 0),
    frame_rate          NUMERIC(6,3) CHECK (frame_rate IS NULL OR frame_rate > 0),
    -- Editorial dates.
    content_date        DATE,
    first_published_at  TIMESTAMPTZ,
    archive_after       DATE,
    -- Business keys outward.
    tm_event_code       VARCHAR(30),
    hudl_video_id       UUID,
    created_by          VARCHAR(120),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A placeholder has no duration yet, and an available asset should.
    CONSTRAINT ck_media_object_placeholder_state
        CHECK (is_placeholder = (lifecycle_status = 'placeholder')),
    CONSTRAINT ck_media_object_frame_rate_pair
        CHECK ((duration_frames IS NULL) OR frame_rate IS NOT NULL),
    CONSTRAINT ck_media_object_published_has_date
        CHECK (lifecycle_status <> 'published' OR first_published_at IS NOT NULL)
);

COMMENT ON COLUMN dalet.media_object.is_placeholder IS
    'A media object with no essence. Normal and intended: the production '
    'order reserves the object before the camera has shot anything.';
COMMENT ON COLUMN dalet.media_object.duration_frames IS
    'Frames, not seconds. Broadcast operations are frame-accurate and a '
    'rounding to seconds loses the edit point. Target content.asset carries '
    'a duration in seconds.';

-- -------------------------------------------------------------------------
-- Essence. One physical rendition of a media object.
--
-- The target model has no equivalent, so a 4K master, a proxy and three
-- social cutdowns of the same highlights package arrive as one row -- and
-- storage, cost and delivery-readiness reporting all become impossible.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.essence (
    essence_id          VARCHAR(40)  PRIMARY KEY,
    media_object_id     VARCHAR(40)  NOT NULL,
    essence_profile     VARCHAR(60)  NOT NULL,
    essence_role        VARCHAR(20)  NOT NULL
        CHECK (essence_role IN ('master', 'proxy', 'editorial', 'distribution',
                                'thumbnail', 'audio_stem', 'subtitle')),
    storage_tier        VARCHAR(20)  NOT NULL DEFAULT 'online'
        CHECK (storage_tier IN ('online', 'nearline', 'archive', 'deep_archive', 'purged')),
    storage_uri         TEXT,
    file_size_bytes     BIGINT       CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    codec               VARCHAR(40),
    container           VARCHAR(20),
    width_px            INTEGER      CHECK (width_px IS NULL OR width_px > 0),
    height_px           INTEGER      CHECK (height_px IS NULL OR height_px > 0),
    bitrate_kbps        INTEGER      CHECK (bitrate_kbps IS NULL OR bitrate_kbps > 0),
    audio_channels      SMALLINT     CHECK (audio_channels IS NULL OR audio_channels >= 0),
    language_code       common.dom_language_code,
    -- Restore latency matters: a deep-archive essence may take hours to
    -- retrieve, which is the difference between usable and not during a live
    -- event.
    restore_hours       NUMERIC(6,2) CHECK (restore_hours IS NULL OR restore_hours >= 0),
    checksum            VARCHAR(80),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_essence_dimensions_pair
        CHECK ((width_px IS NULL) = (height_px IS NULL)),
    -- A purged essence has no file behind it.
    CONSTRAINT ck_essence_purged_no_uri
        CHECK (storage_tier <> 'purged' OR storage_uri IS NULL)
);

COMMENT ON TABLE dalet.essence IS
    'One rendition of a media object. No target table corresponds, so a 4K '
    'master and its five derived cutdowns collapse into a single asset row '
    'and storage cost reporting is not possible downstream.';

-- One master essence per object.
CREATE UNIQUE INDEX ux_essence_one_master
    ON dalet.essence (media_object_id) WHERE essence_role = 'master';

-- -------------------------------------------------------------------------
-- Metadata value. Feeds target content.asset_tag.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.metadata_value (
    metadata_value_id   BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    media_object_id     VARCHAR(40)  NOT NULL,
    metadata_field_id   VARCHAR(40)  NOT NULL,
    -- One typed column per data type rather than a single text column, so the
    -- values stay sortable and comparable. The alternative -- everything as
    -- text -- is what makes key-value metadata unqueryable.
    text_value          TEXT,
    numeric_value       NUMERIC(18,6),
    date_value          DATE,
    timestamp_value     TIMESTAMPTZ,
    boolean_value       BOOLEAN,
    vocabulary_term_id  VARCHAR(40),
    -- Ordinal for multi-valued fields.
    value_order         SMALLINT     NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (media_object_id, metadata_field_id, value_order),
    -- Exactly one typed column carries the value.
    CONSTRAINT ck_metadata_value_exactly_one
        CHECK (
            (CASE WHEN text_value        IS NOT NULL THEN 1 ELSE 0 END)
          + (CASE WHEN numeric_value     IS NOT NULL THEN 1 ELSE 0 END)
          + (CASE WHEN date_value        IS NOT NULL THEN 1 ELSE 0 END)
          + (CASE WHEN timestamp_value   IS NOT NULL THEN 1 ELSE 0 END)
          + (CASE WHEN boolean_value     IS NOT NULL THEN 1 ELSE 0 END)
          + (CASE WHEN vocabulary_term_id IS NOT NULL THEN 1 ELSE 0 END)
            = 1
        )
);

COMMENT ON CONSTRAINT ck_metadata_value_exactly_one ON dalet.metadata_value IS
    'Typed columns rather than one text column, so values stay sortable and '
    'comparable. This constraint is what keeps the shape honest -- exactly '
    'one of them is populated per row.';

-- -------------------------------------------------------------------------
-- Collection and membership. Feed target content.collection and
-- content.collection_item.
-- -------------------------------------------------------------------------
CREATE TABLE dalet.collection (
    collection_id       VARCHAR(40)  PRIMARY KEY,
    name                VARCHAR(200) NOT NULL,
    description         TEXT,
    collection_type     VARCHAR(20)  NOT NULL DEFAULT 'manual'
        CHECK (collection_type IN ('manual', 'smart', 'series', 'season_pack', 'playlist')),
    -- A smart collection is a stored query, so it has no membership rows --
    -- the same gap as a Shopify smart collection.
    query_expression    TEXT,
    language_code       common.dom_language_code,
    is_published        BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_collection_smart_query
        CHECK ((collection_type = 'smart') = (query_expression IS NOT NULL))
);

CREATE TABLE dalet.collection_member (
    collection_id       VARCHAR(40)  NOT NULL,
    media_object_id     VARCHAR(40)  NOT NULL,
    display_order       INTEGER      NOT NULL DEFAULT 0,
    added_by            VARCHAR(120),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (collection_id, media_object_id)
);

CREATE TABLE dalet.tag_assignment (
    media_object_id     VARCHAR(40)  NOT NULL,
    vocabulary_term_id  VARCHAR(40)  NOT NULL,
    -- Confidence, because tags increasingly come from automatic recognition
    -- rather than a human. The target model does not distinguish them, so an
    -- AI guess and a librarian's judgement arrive identical.
    assigned_by         VARCHAR(20)  NOT NULL DEFAULT 'human'
        CHECK (assigned_by IN ('human', 'ai_vision', 'ai_speech', 'ai_text', 'imported')),
    confidence          NUMERIC(5,4) CHECK (confidence IS NULL OR confidence BETWEEN 0 AND 1),
    is_verified         BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (media_object_id, vocabulary_term_id),
    -- An automatic tag must carry a confidence; a human one need not.
    CONSTRAINT ck_tag_ai_confidence
        CHECK (assigned_by = 'human' OR assigned_by = 'imported' OR confidence IS NOT NULL)
);

COMMENT ON COLUMN dalet.tag_assignment.assigned_by IS
    'Human or machine, and which kind of machine. Target content.asset_tag '
    'does not distinguish, so an unverified AI guess and a librarian''s '
    'judgement arrive in the lakehouse indistinguishable.';
