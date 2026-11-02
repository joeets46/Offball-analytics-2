-- =========================================================================
-- adobe_aep -- events, membership and journeys
--
-- The experience event table is the highest-volume object in this entire
-- project -- every page view, app open, stream start and gate entry for every
-- fan. It feeds target fan.engagement_event.
--
-- Three consequences shape the DDL:
--   * It is append-only and immutable. No updated_at, no update trigger.
--   * It is range-partitioned by event timestamp, monthly, and retention is a
--     DETACH rather than a DELETE.
--   * Its payload is XDM and stays JSONB. Promoting the deep fields to
--     columns would produce a table that is mostly null and would break every
--     time the XDM schema is extended.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Experience event. Feeds target fan.engagement_event.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.experience_event (
    -- Adobe's own event id, a hash. Not sequential, so it is supplied rather
    -- than generated.
    event_id            VARCHAR(64)  NOT NULL,
    timestamp           TIMESTAMPTZ  NOT NULL,
    event_type          VARCHAR(60)  NOT NULL,
    dataset_id          VARCHAR(40)  NOT NULL,

    -- Identity at the time of the event. Deliberately the identity, not the
    -- profile: an event is observed against a cookie or an account long before
    -- the graph resolves it to a person, and rewriting history when the graph
    -- changes is exactly what must not happen.
    identity_id         BIGINT,
    identity_namespace  VARCHAR(30)  NOT NULL,
    identity_value      VARCHAR(255) NOT NULL,

    -- Session and device context.
    session_id          VARCHAR(80),
    device_type         VARCHAR(20)
        CHECK (device_type IS NULL OR device_type IN ('desktop', 'mobile', 'tablet', 'tv', 'console', 'other')),
    os_name             VARCHAR(40),
    browser_name        VARCHAR(40),
    ip_address          INET,
    geo_country_code    common.dom_iso3_code,
    geo_region          VARCHAR(80),
    geo_city            VARCHAR(80),

    -- Commerce and media measures, promoted because they are the ones that
    -- get aggregated. Everything else stays in the payload.
    commerce_order_id   VARCHAR(80),
    commerce_currency   common.dom_iso3_code,
    commerce_revenue    NUMERIC(18,4) CHECK (commerce_revenue IS NULL OR commerce_revenue >= 0),
    media_asset_id      VARCHAR(80),
    media_seconds_watched INTEGER
        CHECK (media_seconds_watched IS NULL OR media_seconds_watched >= 0),

    -- The XDM payload.
    xdm_payload         JSONB,

    -- Ingestion metadata. received_at is the watermark, not timestamp:
    -- mobile SDKs buffer offline and backfill days later, so event time is
    -- not monotonic but arrival time is.
    received_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (event_id, timestamp),
    CONSTRAINT ck_experience_event_received_after_occurred
        CHECK (received_at >= timestamp),
    CONSTRAINT ck_experience_event_revenue_currency
        CHECK ((commerce_revenue IS NULL) = (commerce_currency IS NULL))
) PARTITION BY RANGE (timestamp);

COMMENT ON TABLE adobe_aep.experience_event IS
    'Append-only, immutable time series. Highest-volume table in the project. '
    'Carries no updated_at because nothing ever updates it.';
COMMENT ON COLUMN adobe_aep.experience_event.identity_id IS
    'The identity observed, not the resolved profile. Nullable because an '
    'event can arrive for an identity the graph has not yet seen. Resolving '
    'events to profiles at write time would rewrite history every time the '
    'identity graph changed.';
COMMENT ON COLUMN adobe_aep.experience_event.received_at IS
    'The extraction watermark. Mobile SDKs buffer offline and backfill, so '
    'event timestamp is not monotonic -- an extract keyed on timestamp loses '
    'late events permanently.';

CREATE TABLE adobe_aep.experience_event_2026_q1 PARTITION OF adobe_aep.experience_event
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE adobe_aep.experience_event_2026_q2 PARTITION OF adobe_aep.experience_event
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE adobe_aep.experience_event_2026_q3 PARTITION OF adobe_aep.experience_event
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE adobe_aep.experience_event_2026_q4 PARTITION OF adobe_aep.experience_event
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE adobe_aep.experience_event_default PARTITION OF adobe_aep.experience_event DEFAULT;

COMMENT ON TABLE adobe_aep.experience_event_default IS
    'Catch-all. Should stay empty; rows here mean partition maintenance has '
    'fallen behind, or an SDK is sending events with implausible timestamps.';

-- -------------------------------------------------------------------------
-- Segment membership. Feeds target fan.segment_assignment.
--
-- Status, not a boolean. `exiting` is the state marketing actually acts on --
-- a fan who has just dropped out of "engaged season-ticket holders" is the
-- one worth calling. Target fan.segment_assignment carries a membership flag,
-- so the exit signal is lost.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.segment_membership (
    profile_id          BIGINT       NOT NULL,
    segment_definition_id VARCHAR(40) NOT NULL,
    status              VARCHAR(10)  NOT NULL
        CHECK (status IN ('realized', 'existing', 'exiting')),
    -- Confidence applies to lookalike and modelled segments.
    confidence          NUMERIC(5,4) CHECK (confidence IS NULL OR confidence BETWEEN 0 AND 1),
    first_qualified_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_qualified_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    exited_at           TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (profile_id, segment_definition_id),
    CONSTRAINT ck_segment_membership_exit
        CHECK ((status = 'exiting') = (exited_at IS NOT NULL)),
    CONSTRAINT ck_segment_membership_qualified_order
        CHECK (last_qualified_at >= first_qualified_at)
);

COMMENT ON COLUMN adobe_aep.segment_membership.status IS
    '`realized` is newly qualified, `existing` is continuing, `exiting` has '
    'just dropped out. The exit is the actionable state and the target '
    'model''s membership boolean cannot express it.';

-- -------------------------------------------------------------------------
-- Journey, step and step event. Feed target fan.communication.
--
-- A journey is the orchestration; a step event is one person reaching one
-- step. Target fan.communication is the step event, so the journey structure
-- -- which branch a fan took, and why -- is not reconstructable downstream.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.journey (
    journey_id          VARCHAR(40)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    description         TEXT,
    journey_status      VARCHAR(20)  NOT NULL DEFAULT 'draft'
        CHECK (journey_status IN ('draft', 'live', 'paused', 'stopped', 'archived')),
    -- Unitary journeys run a person through once; recurring ones re-admit.
    journey_type        VARCHAR(20)  NOT NULL DEFAULT 'unitary'
        CHECK (journey_type IN ('unitary', 'recurring', 'read_segment')),
    entry_segment_definition_id VARCHAR(40),
    -- Business key back to the Salesforce campaign that commissioned it.
    sfdc_campaign_id    CHAR(18),
    version_number      INTEGER      NOT NULL DEFAULT 1 CHECK (version_number > 0),
    published_at        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_journey_live_published
        CHECK (journey_status <> 'live' OR published_at IS NOT NULL)
);

CREATE TABLE adobe_aep.journey_step (
    journey_step_id     VARCHAR(40)  PRIMARY KEY,
    journey_id          VARCHAR(40)  NOT NULL,
    step_name           VARCHAR(120) NOT NULL,
    step_type           VARCHAR(20)  NOT NULL
        CHECK (step_type IN ('entry', 'action', 'condition', 'wait', 'split', 'jump', 'end')),
    -- Channel applies only to action steps that send something.
    channel             VARCHAR(20)
        CHECK (channel IS NULL OR channel IN ('email', 'sms', 'push', 'in_app', 'web', 'direct_mail')),
    step_order          INTEGER      NOT NULL DEFAULT 0,
    -- Self-reference describing the graph: a step's predecessor. Branching
    -- means several steps can share one parent.
    parent_step_id      VARCHAR(40),
    branch_label        VARCHAR(80),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_journey_step_not_self_parent
        CHECK (parent_step_id IS NULL OR parent_step_id <> journey_step_id),
    -- Only an action step sends on a channel.
    CONSTRAINT ck_journey_step_channel
        CHECK (step_type = 'action' OR channel IS NULL),
    -- A branch label only means something below a split.
    CONSTRAINT ck_journey_step_branch_has_parent
        CHECK (branch_label IS NULL OR parent_step_id IS NOT NULL)
);

CREATE TABLE adobe_aep.journey_step_event (
    journey_step_event_id BIGINT     GENERATED ALWAYS AS IDENTITY,
    occurred_at         TIMESTAMPTZ  NOT NULL,
    journey_id          VARCHAR(40)  NOT NULL,
    journey_step_id     VARCHAR(40)  NOT NULL,
    profile_id          BIGINT       NOT NULL,
    -- The outcome of this person reaching this step.
    step_outcome        VARCHAR(20)  NOT NULL
        CHECK (step_outcome IN ('entered', 'sent', 'delivered', 'opened', 'clicked',
                                'bounced', 'suppressed', 'failed', 'exited', 'completed')),
    -- Suppression reason is the important one: a message not sent because
    -- consent was absent is a compliance record, not a delivery failure.
    suppression_reason  VARCHAR(30)
        CHECK (suppression_reason IS NULL OR suppression_reason IN
            ('consent_denied', 'frequency_cap', 'quiet_hours', 'hard_bounce_history',
             'global_suppression', 'duplicate', 'invalid_address')),
    channel             VARCHAR(20),
    message_id          VARCHAR(80),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (journey_step_event_id, occurred_at),
    CONSTRAINT ck_jse_suppression_reason
        CHECK ((step_outcome = 'suppressed') = (suppression_reason IS NOT NULL))
) PARTITION BY RANGE (occurred_at);

COMMENT ON COLUMN adobe_aep.journey_step_event.suppression_reason IS
    'Why a message was not sent. A consent_denied suppression is a compliance '
    'record demonstrating the opt-out was honoured -- materially different '
    'from a delivery failure, and target fan.communication merges the two.';

CREATE TABLE adobe_aep.journey_step_event_2026_h1 PARTITION OF adobe_aep.journey_step_event
    FOR VALUES FROM ('2026-01-01') TO ('2026-07-01');
CREATE TABLE adobe_aep.journey_step_event_2026_h2 PARTITION OF adobe_aep.journey_step_event
    FOR VALUES FROM ('2026-07-01') TO ('2027-01-01');
CREATE TABLE adobe_aep.journey_step_event_default
    PARTITION OF adobe_aep.journey_step_event DEFAULT;

-- -------------------------------------------------------------------------
-- Destination and activation. Where audiences are sent.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.destination (
    destination_id      VARCHAR(40)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    platform            VARCHAR(60)  NOT NULL,
    destination_type    VARCHAR(20)  NOT NULL
        CHECK (destination_type IN ('advertising', 'email', 'social', 'personalisation', 'cloud_storage', 'crm')),
    -- Governance: a destination enforces data-use labels, which is what stops
    -- health or special-category data being sent to an ad platform.
    enforced_label_codes TEXT[],
    is_enabled          BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE adobe_aep.destination_activation (
    destination_activation_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    destination_id      VARCHAR(40)  NOT NULL,
    audience_id         VARCHAR(40)  NOT NULL,
    activation_status   VARCHAR(20)  NOT NULL DEFAULT 'pending'
        CHECK (activation_status IN ('pending', 'active', 'paused', 'failed', 'blocked')),
    -- A blocked activation is a governance refusal, and the reason is the
    -- evidence that data-use policy was enforced.
    blocked_reason      VARCHAR(200),
    profiles_activated  BIGINT       CHECK (profiles_activated IS NULL OR profiles_activated >= 0),
    last_activated_at   TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (destination_id, audience_id),
    CONSTRAINT ck_activation_blocked_reason
        CHECK ((activation_status = 'blocked') = (blocked_reason IS NOT NULL))
);

-- -------------------------------------------------------------------------
-- Privacy job. GDPR and CCPA access and erasure requests.
--
-- Contributes to target compliance.data_processing_record. Note what this is
-- NOT: the DSAR intake portal, which would be a separate system and is out of
-- scope -- so target compliance.privacy_request has no source. This table is
-- only AEP's execution of a request that arrived from elsewhere.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.privacy_job (
    privacy_job_id      VARCHAR(40)  PRIMARY KEY,
    job_type            VARCHAR(20)  NOT NULL
        CHECK (job_type IN ('access', 'delete', 'opt_out_sale', 'rectify')),
    regulation          VARCHAR(20)  NOT NULL
        CHECK (regulation IN ('gdpr', 'ccpa', 'cpra', 'lgpd', 'pipeda', 'other')),
    -- The subject, by namespaced identity rather than profile: a request can
    -- arrive for an identity that resolves to several profiles, or to none.
    identity_namespace  VARCHAR(30)  NOT NULL,
    identity_value      VARCHAR(255) NOT NULL,
    job_status          VARCHAR(20)  NOT NULL DEFAULT 'submitted'
        CHECK (job_status IN ('submitted', 'processing', 'complete', 'error', 'rejected')),
    -- Statutory clock. GDPR allows one month, CCPA 45 days, and missing it is
    -- the breach.
    submitted_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    statutory_due_on    DATE         NOT NULL,
    completed_at        TIMESTAMPTZ,
    datasets_processed  INTEGER      NOT NULL DEFAULT 0 CHECK (datasets_processed >= 0),
    error_detail        TEXT,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_privacy_job_complete
        CHECK ((job_status = 'complete') = (completed_at IS NOT NULL)),
    CONSTRAINT ck_privacy_job_error_detail
        CHECK ((job_status = 'error') = (error_detail IS NOT NULL))
);

COMMENT ON TABLE adobe_aep.privacy_job IS
    'AEP''s execution of a privacy request, not its intake. The DSAR portal '
    'is not among the ten named systems, which is why target '
    'compliance.privacy_request is out of scope while this table is in it.';
