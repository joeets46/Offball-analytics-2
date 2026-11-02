-- =========================================================================
-- adobe_aep -- profile and identity
--
-- The identity resolution layer. This is the most consequential schema in the
-- project for the target model, because target fan.fan_profile is the
-- collapse of everything here into a single row with a single key.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Identity. One row per (namespace, id) pair.
--
-- Note there is no reference to a profile here. In AEP the profile is derived
-- FROM the identity graph, not the other way round: identities cluster, and a
-- cluster is a profile. Modeling it with a profile_id on the identity would
-- invert the real direction of inference.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.identity (
    identity_id         BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    namespace_code      VARCHAR(30)  NOT NULL,
    identity_value      VARCHAR(255) NOT NULL,
    first_seen_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_seen_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    -- An identity can be retired without being deleted: a recycled email, a
    -- cleared cookie.
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (namespace_code, identity_value),
    CONSTRAINT ck_identity_seen_order CHECK (last_seen_at >= first_seen_at)
);

COMMENT ON TABLE adobe_aep.identity IS
    'One row per namespaced identifier. Deliberately carries no profile '
    'reference: in AEP the profile is derived from the identity graph, so a '
    'profile_id here would invert the direction of inference.';

-- -------------------------------------------------------------------------
-- Identity graph link. Pairwise, directional, probabilistic.
--
-- The target model has nothing like this. Two identities are linked with a
-- method and a confidence, and a link can be revoked when it turns out to be
-- wrong -- a shared device, a recycled email address. Target fan.fan_profile
-- asserts one person with certainty.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.identity_graph_link (
    identity_graph_link_id BIGINT    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    identity_id_a       BIGINT       NOT NULL,
    identity_id_b       BIGINT       NOT NULL,
    link_method         VARCHAR(20)  NOT NULL
        CHECK (link_method IN ('deterministic', 'probabilistic', 'declared', 'imported')),
    confidence          NUMERIC(5,4) CHECK (confidence IS NULL OR confidence BETWEEN 0 AND 1),
    -- Links break. A revoked link is kept so the break is auditable, which
    -- matters when a merge exposed one fan's data to another.
    is_revoked          BOOLEAN      NOT NULL DEFAULT FALSE,
    revoked_at          TIMESTAMPTZ,
    revocation_reason   VARCHAR(40)
        CHECK (revocation_reason IS NULL OR revocation_reason IN
            ('shared_device', 'recycled_identifier', 'privacy_request',
             'incorrect_match', 'manual_correction')),
    established_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A link is unordered, so store it canonically (a < b) to stop the same
    -- pair existing twice in opposite directions.
    CONSTRAINT ck_graph_link_canonical_order CHECK (identity_id_a < identity_id_b),
    CONSTRAINT ck_graph_link_revocation
        CHECK (is_revoked = (revoked_at IS NOT NULL)),
    CONSTRAINT ck_graph_link_revoked_has_reason
        CHECK (is_revoked = (revocation_reason IS NOT NULL)),
    -- A probabilistic link must state its confidence; a deterministic one
    -- does not need to.
    CONSTRAINT ck_graph_link_probabilistic_confidence
        CHECK (link_method <> 'probabilistic' OR confidence IS NOT NULL),
    UNIQUE (identity_id_a, identity_id_b)
);

COMMENT ON CONSTRAINT ck_graph_link_canonical_order ON adobe_aep.identity_graph_link IS
    'Links are unordered pairs. Storing them canonically with a < b is what '
    'makes the UNIQUE constraint actually prevent duplicates.';

-- -------------------------------------------------------------------------
-- Profile. The resolved person. Feeds target fan.fan_profile.
--
-- The attributes here are merged from every contributing dataset, so a
-- profile is a view over sources that disagree -- and the merge policy, not
-- the data, decides which value wins.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.profile (
    profile_id          BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- The primary identity of the cluster, by which the profile is addressed.
    primary_identity_id BIGINT       NOT NULL,
    -- Stable XDM attributes, promoted to columns because every consumer wants
    -- them and they are present on essentially every profile.
    person_first_name   VARCHAR(80),
    person_last_name    VARCHAR(80),
    birth_date          DATE,
    gender              VARCHAR(20)
        CHECK (gender IS NULL OR gender IN ('male', 'female', 'non_specific', 'not_specified')),
    home_country_code   common.dom_iso3_code,
    home_postal_code    VARCHAR(20),
    preferred_language  common.dom_language_code,
    timezone            common.dom_iana_timezone,

    -- The rest of the XDM record. Sparse, deeply nested and schema-driven, so
    -- it stays JSONB rather than being flattened into columns that would be
    -- null for most profiles.
    xdm_attributes      JSONB,

    -- Computed audience membership counts, maintained by the platform.
    segment_count       INTEGER      NOT NULL DEFAULT 0 CHECK (segment_count >= 0),
    -- Which merge policy produced this view of the profile. Two policies give
    -- two different profiles from the same identities, and the target model
    -- records only one.
    merge_policy_id     VARCHAR(40)  NOT NULL DEFAULT 'default',

    first_seen_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_activity_at    TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_profile_birth_date_past
        CHECK (birth_date IS NULL OR birth_date < CURRENT_DATE)
);

COMMENT ON COLUMN adobe_aep.profile.xdm_attributes IS
    'The sparse remainder of the XDM record. JSONB rather than columns '
    'because the schema is customer-defined and most fields are null for most '
    'profiles -- flattening would produce a table of mostly nulls.';
COMMENT ON COLUMN adobe_aep.profile.merge_policy_id IS
    'Which merge policy produced this view. The same identities under two '
    'policies yield two different profiles; target fan.fan_profile records one.';

-- -------------------------------------------------------------------------
-- Identity map. Which identities belong to which profile.
--
-- Feeds nothing in the target model directly, and that is the point: this is
-- the table that would let the lakehouse explain why two orders from
-- different systems belong to the same fan.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.identity_map (
    profile_id          BIGINT       NOT NULL,
    identity_id         BIGINT       NOT NULL,
    is_primary          BOOLEAN      NOT NULL DEFAULT FALSE,
    added_at            TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (profile_id, identity_id)
);

-- -------------------------------------------------------------------------
-- Consent record. Per profile, per policy. Feeds target
-- fan.consent_preference.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.consent_record (
    consent_record_id   BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    profile_id          BIGINT       NOT NULL,
    consent_policy_id   VARCHAR(40)  NOT NULL,
    -- Three states, not two. "Not asked" is distinct from "declined", and
    -- conflating them is the commonest consent bug.
    consent_state       VARCHAR(10)  NOT NULL
        CHECK (consent_state IN ('allow', 'deny', 'unknown')),
    -- Provenance: which system captured it and how. A consent whose origin
    -- cannot be shown is not a defensible consent.
    captured_by_system  VARCHAR(20)  NOT NULL,
    capture_method      VARCHAR(30)  NOT NULL
        CHECK (capture_method IN
            ('web_form', 'app_prompt', 'checkout', 'box_office', 'call_center',
             'imported', 'inferred', 'preference_centre')),
    capture_evidence_ref VARCHAR(120),
    effective_from      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    effective_to        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_consent_window CHECK (effective_to IS NULL OR effective_to > effective_from),
    -- An affirmative consent must record how it was obtained.
    CONSTRAINT ck_consent_allow_has_evidence
        CHECK (consent_state <> 'allow' OR capture_evidence_ref IS NOT NULL)
);

COMMENT ON CONSTRAINT ck_consent_allow_has_evidence ON adobe_aep.consent_record IS
    'An affirmative consent has to be evidenced. Under GDPR the controller '
    'carries the burden of demonstrating consent, so a yes with no evidence '
    'reference is not a usable yes.';

-- -------------------------------------------------------------------------
-- Audience and segment definition. Feed target fan.segment.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.segment_definition (
    segment_definition_id VARCHAR(40) PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    description         TEXT,
    -- PQL, Adobe's query language. Retained verbatim: the rule IS the
    -- definition, and target fan.segment keeps only the name.
    pql_expression      TEXT         NOT NULL,
    -- Evaluation method governs latency: streaming segments qualify within
    -- seconds, batch ones overnight, edge ones in-session.
    evaluation_method   VARCHAR(20)  NOT NULL
        CHECK (evaluation_method IN ('batch', 'streaming', 'edge')),
    merge_policy_id     VARCHAR(40)  NOT NULL DEFAULT 'default',
    segment_status      VARCHAR(20)  NOT NULL DEFAULT 'draft'
        CHECK (segment_status IN ('draft', 'active', 'inactive', 'archived')),
    -- Last evaluated size, which is what a marketer sees.
    estimated_size      BIGINT       CHECK (estimated_size IS NULL OR estimated_size >= 0),
    last_evaluated_at   TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN adobe_aep.segment_definition.pql_expression IS
    'The segment rule verbatim. Target fan.segment stores a name and a '
    'description, so what the segment actually means is not recoverable '
    'downstream.';

CREATE TABLE adobe_aep.audience (
    audience_id         VARCHAR(40)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    -- An audience may be a platform segment or an externally imported list.
    audience_type       VARCHAR(20)  NOT NULL
        CHECK (audience_type IN ('segment', 'imported', 'lookalike', 'composed')),
    segment_definition_id VARCHAR(40),
    origin_system       VARCHAR(30),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A segment-backed audience must name its definition.
    CONSTRAINT ck_audience_segment_backed
        CHECK (audience_type <> 'segment' OR segment_definition_id IS NOT NULL)
);
