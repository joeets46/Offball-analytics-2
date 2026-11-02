-- =========================================================================
-- adobe_aep -- foreign keys
--
-- One deliberate omission worth stating plainly:
-- experience_event.identity_id has NO foreign key, even though
-- adobe_aep.identity exists.
--
-- Two reasons. First, events arrive before identities are registered -- an
-- unknown cookie is a legitimate event source, and enforcing the key would
-- reject the event or force a synchronous write to the identity table on the
-- hottest path in the system. Second, the volume: a foreign key check per row
-- on a table taking tens of thousands of inserts a second is not viable, and
-- no real event platform does it.
--
-- The event therefore keeps the namespace and value it observed, and
-- resolution happens later and asynchronously. That is not a shortcut -- it
-- is how event collection has to work.
-- =========================================================================

ALTER TABLE adobe_aep.identity
    ADD CONSTRAINT fk_identity_namespace
        FOREIGN KEY (namespace_code)
        REFERENCES adobe_aep.identity_namespace (namespace_code)
        ON DELETE RESTRICT;

ALTER TABLE adobe_aep.identity_graph_link
    ADD CONSTRAINT fk_graph_link_identity_a
        FOREIGN KEY (identity_id_a) REFERENCES adobe_aep.identity (identity_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_graph_link_identity_b
        FOREIGN KEY (identity_id_b) REFERENCES adobe_aep.identity (identity_id)
        ON DELETE CASCADE;

ALTER TABLE adobe_aep.profile
    ADD CONSTRAINT fk_profile_primary_identity
        FOREIGN KEY (primary_identity_id) REFERENCES adobe_aep.identity (identity_id)
        ON DELETE RESTRICT;

ALTER TABLE adobe_aep.identity_map
    ADD CONSTRAINT fk_identity_map_profile
        FOREIGN KEY (profile_id) REFERENCES adobe_aep.profile (profile_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_identity_map_identity
        FOREIGN KEY (identity_id) REFERENCES adobe_aep.identity (identity_id)
        ON DELETE CASCADE;

ALTER TABLE adobe_aep.consent_record
    ADD CONSTRAINT fk_consent_record_profile
        FOREIGN KEY (profile_id) REFERENCES adobe_aep.profile (profile_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_consent_record_policy
        FOREIGN KEY (consent_policy_id)
        REFERENCES adobe_aep.consent_policy (consent_policy_id)
        ON DELETE RESTRICT;

ALTER TABLE adobe_aep.audience
    ADD CONSTRAINT fk_audience_segment_definition
        FOREIGN KEY (segment_definition_id)
        REFERENCES adobe_aep.segment_definition (segment_definition_id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Events. The partitioned event tables reference the configuration they
-- depend on, but NOT the identity -- see the header note.
-- -------------------------------------------------------------------------
ALTER TABLE adobe_aep.experience_event
    ADD CONSTRAINT fk_experience_event_type
        FOREIGN KEY (event_type) REFERENCES adobe_aep.event_type_ref (event_type)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_experience_event_dataset
        FOREIGN KEY (dataset_id) REFERENCES adobe_aep.dataset (dataset_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_experience_event_namespace
        FOREIGN KEY (identity_namespace)
        REFERENCES adobe_aep.identity_namespace (namespace_code)
        ON DELETE RESTRICT;

ALTER TABLE adobe_aep.segment_membership
    ADD CONSTRAINT fk_segment_membership_profile
        FOREIGN KEY (profile_id) REFERENCES adobe_aep.profile (profile_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_segment_membership_definition
        FOREIGN KEY (segment_definition_id)
        REFERENCES adobe_aep.segment_definition (segment_definition_id)
        ON DELETE CASCADE;

ALTER TABLE adobe_aep.journey
    ADD CONSTRAINT fk_journey_entry_segment
        FOREIGN KEY (entry_segment_definition_id)
        REFERENCES adobe_aep.segment_definition (segment_definition_id)
        ON DELETE RESTRICT;

ALTER TABLE adobe_aep.journey_step
    ADD CONSTRAINT fk_journey_step_journey
        FOREIGN KEY (journey_id) REFERENCES adobe_aep.journey (journey_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_journey_step_parent
        FOREIGN KEY (parent_step_id) REFERENCES adobe_aep.journey_step (journey_step_id)
        ON DELETE RESTRICT;

ALTER TABLE adobe_aep.journey_step_event
    ADD CONSTRAINT fk_jse_journey
        FOREIGN KEY (journey_id) REFERENCES adobe_aep.journey (journey_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_jse_step
        FOREIGN KEY (journey_step_id) REFERENCES adobe_aep.journey_step (journey_step_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_jse_profile
        FOREIGN KEY (profile_id) REFERENCES adobe_aep.profile (profile_id)
        ON DELETE RESTRICT;

ALTER TABLE adobe_aep.destination_activation
    ADD CONSTRAINT fk_activation_destination
        FOREIGN KEY (destination_id) REFERENCES adobe_aep.destination (destination_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_activation_audience
        FOREIGN KEY (audience_id) REFERENCES adobe_aep.audience (audience_id)
        ON DELETE CASCADE;

ALTER TABLE adobe_aep.privacy_job
    ADD CONSTRAINT fk_privacy_job_namespace
        FOREIGN KEY (identity_namespace)
        REFERENCES adobe_aep.identity_namespace (namespace_code)
        ON DELETE RESTRICT;
