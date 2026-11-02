-- =========================================================================
-- adobe_aep -- indexes
--
-- The event tables need restraint rather than coverage. Every index on a
-- table taking tens of thousands of inserts a second is a write cost paid
-- continuously, so only the paths that are genuinely used get one:
-- extraction, per-profile history, and attribution on conversions.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Identity and graph.
-- -------------------------------------------------------------------------
CREATE INDEX ix_identity_value        ON adobe_aep.identity (identity_value);
CREATE INDEX ix_identity_namespace    ON adobe_aep.identity (namespace_code) WHERE is_active;
CREATE INDEX ix_identity_last_seen    ON adobe_aep.identity (last_seen_at);

CREATE INDEX ix_graph_link_a          ON adobe_aep.identity_graph_link (identity_id_a)
    WHERE NOT is_revoked;
CREATE INDEX ix_graph_link_b          ON adobe_aep.identity_graph_link (identity_id_b)
    WHERE NOT is_revoked;
-- Revoked links, which is the audit trail for a mis-merge.
CREATE INDEX ix_graph_link_revoked    ON adobe_aep.identity_graph_link (revoked_at)
    WHERE is_revoked;
-- Low-confidence probabilistic links, the review queue.
CREATE INDEX ix_graph_link_low_confidence
    ON adobe_aep.identity_graph_link (confidence)
    WHERE link_method = 'probabilistic' AND NOT is_revoked;

CREATE INDEX ix_profile_primary_identity ON adobe_aep.profile (primary_identity_id);
CREATE INDEX ix_profile_name          ON adobe_aep.profile (person_last_name, person_first_name)
    WHERE person_last_name IS NOT NULL;
CREATE INDEX ix_profile_last_activity ON adobe_aep.profile (last_activity_at);
CREATE INDEX ix_profile_merge_policy  ON adobe_aep.profile (merge_policy_id);
-- JSONB containment queries against the sparse XDM remainder.
CREATE INDEX ix_profile_xdm           ON adobe_aep.profile USING GIN (xdm_attributes)
    WHERE xdm_attributes IS NOT NULL;

CREATE INDEX ix_identity_map_identity ON adobe_aep.identity_map (identity_id);
-- One primary identity per profile.
CREATE UNIQUE INDEX ux_identity_map_one_primary
    ON adobe_aep.identity_map (profile_id) WHERE is_primary;

-- -------------------------------------------------------------------------
-- Consent. The lookup that gates every send.
-- -------------------------------------------------------------------------
CREATE INDEX ix_consent_record_policy ON adobe_aep.consent_record (consent_policy_id);
-- The live consent for a profile, which is what the journey engine checks
-- before dispatching. Latency-critical.
CREATE INDEX ix_consent_record_live
    ON adobe_aep.consent_record (profile_id, consent_policy_id)
    WHERE effective_to IS NULL;
-- One live consent per profile per policy.
CREATE UNIQUE INDEX ux_consent_record_one_live
    ON adobe_aep.consent_record (profile_id, consent_policy_id)
    WHERE effective_to IS NULL;

-- -------------------------------------------------------------------------
-- Segments and audiences.
-- -------------------------------------------------------------------------
CREATE INDEX ix_segment_definition_active
    ON adobe_aep.segment_definition (evaluation_method)
    WHERE segment_status = 'active';
CREATE INDEX ix_audience_segment
    ON adobe_aep.audience (segment_definition_id) WHERE segment_definition_id IS NOT NULL;

CREATE INDEX ix_segment_membership_definition
    ON adobe_aep.segment_membership (segment_definition_id, status);
-- The exit signal: the actionable population.
CREATE INDEX ix_segment_membership_exiting
    ON adobe_aep.segment_membership (segment_definition_id, exited_at)
    WHERE status = 'exiting';

-- -------------------------------------------------------------------------
-- Experience events. Indexes created on the partitioned parent, so every
-- partition gets a matching local index automatically.
-- -------------------------------------------------------------------------
-- The extraction path. received_at, not timestamp, because late-arriving
-- events are the whole problem.
CREATE INDEX ix_experience_event_received
    ON adobe_aep.experience_event (received_at);

-- Per-identity event history: the profile timeline.
CREATE INDEX ix_experience_event_identity
    ON adobe_aep.experience_event (identity_id, timestamp DESC)
    WHERE identity_id IS NOT NULL;

-- Unresolved events, which the identity stitching job sweeps.
CREATE INDEX ix_experience_event_unresolved
    ON adobe_aep.experience_event (identity_namespace, identity_value)
    WHERE identity_id IS NULL;

CREATE INDEX ix_experience_event_type_time
    ON adobe_aep.experience_event (event_type, timestamp);

-- Conversions only. A small fraction of rows, and the ones attribution reads.
CREATE INDEX ix_experience_event_conversions
    ON adobe_aep.experience_event (timestamp, commerce_order_id)
    WHERE commerce_order_id IS NOT NULL;

CREATE INDEX ix_experience_event_dataset
    ON adobe_aep.experience_event (dataset_id, timestamp);

-- Deliberately NOT indexed: xdm_payload. A GIN index on the payload of the
-- highest-volume table in the estate would dominate its write cost, and ad-hoc
-- payload queries belong in the lakehouse, not here.

-- -------------------------------------------------------------------------
-- Journeys.
-- -------------------------------------------------------------------------
CREATE INDEX ix_journey_entry_segment
    ON adobe_aep.journey (entry_segment_definition_id)
    WHERE entry_segment_definition_id IS NOT NULL;
CREATE INDEX ix_journey_live          ON adobe_aep.journey (published_at) WHERE journey_status = 'live';
CREATE INDEX ix_journey_sfdc_campaign
    ON adobe_aep.journey (sfdc_campaign_id) WHERE sfdc_campaign_id IS NOT NULL;

CREATE INDEX ix_journey_step_journey  ON adobe_aep.journey_step (journey_id, step_order);
CREATE INDEX ix_journey_step_parent
    ON adobe_aep.journey_step (parent_step_id) WHERE parent_step_id IS NOT NULL;

CREATE INDEX ix_jse_profile           ON adobe_aep.journey_step_event (profile_id, occurred_at DESC);
CREATE INDEX ix_jse_journey_step      ON adobe_aep.journey_step_event (journey_step_id, occurred_at);
CREATE INDEX ix_jse_journey           ON adobe_aep.journey_step_event (journey_id, occurred_at);
-- Suppressions: the compliance evidence that opt-outs were honoured.
CREATE INDEX ix_jse_suppressed
    ON adobe_aep.journey_step_event (suppression_reason, occurred_at)
    WHERE step_outcome = 'suppressed';
-- The extraction path for target fan.communication.
CREATE INDEX ix_jse_created           ON adobe_aep.journey_step_event (created_at);

-- -------------------------------------------------------------------------
-- Destinations and privacy.
-- -------------------------------------------------------------------------
CREATE INDEX ix_activation_audience   ON adobe_aep.destination_activation (audience_id);
-- Blocked activations: governance refusals worth reporting on.
CREATE INDEX ix_activation_blocked
    ON adobe_aep.destination_activation (destination_id)
    WHERE activation_status = 'blocked';

CREATE INDEX ix_privacy_job_subject
    ON adobe_aep.privacy_job (identity_namespace, identity_value);
-- The statutory clock: open requests by due date. Missing this date is the
-- breach, so it is the one queue that must never be unindexed.
CREATE INDEX ix_privacy_job_due
    ON adobe_aep.privacy_job (statutory_due_on)
    WHERE job_status IN ('submitted', 'processing');
CREATE INDEX ix_privacy_job_status    ON adobe_aep.privacy_job (job_status, submitted_at);

-- -------------------------------------------------------------------------
-- Extraction watermarks for the record-style tables.
-- -------------------------------------------------------------------------
CREATE INDEX ix_profile_updated_at    ON adobe_aep.profile (updated_at);
CREATE INDEX ix_identity_updated_at   ON adobe_aep.identity (updated_at);
CREATE INDEX ix_segment_membership_updated_at ON adobe_aep.segment_membership (updated_at);
CREATE INDEX ix_consent_record_updated_at ON adobe_aep.consent_record (updated_at);
CREATE INDEX ix_segment_definition_updated_at ON adobe_aep.segment_definition (updated_at);
CREATE INDEX ix_privacy_job_updated_at ON adobe_aep.privacy_job (updated_at);
