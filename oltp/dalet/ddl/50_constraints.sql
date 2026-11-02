-- =========================================================================
-- dalet -- foreign keys
--
-- Rights records never cascade. A rights window is the evidence that a
-- publication was permitted, so deleting the asset must not remove the proof
-- that showing it was lawful. Everything downstream of an asset -- essences,
-- metadata values, memberships -- does cascade, because none of it means
-- anything without the asset.
-- =========================================================================

ALTER TABLE dalet.folder
    ADD CONSTRAINT fk_folder_parent
        FOREIGN KEY (parent_folder_id) REFERENCES dalet.folder (folder_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.vocabulary_term
    ADD CONSTRAINT fk_vocabulary_term_vocabulary
        FOREIGN KEY (vocabulary_id) REFERENCES dalet.vocabulary (vocabulary_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_vocabulary_term_parent
        FOREIGN KEY (parent_term_id) REFERENCES dalet.vocabulary_term (vocabulary_term_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.metadata_field
    ADD CONSTRAINT fk_metadata_field_vocabulary
        FOREIGN KEY (vocabulary_id) REFERENCES dalet.vocabulary (vocabulary_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.publication_target
    ADD CONSTRAINT fk_publication_target_channel
        FOREIGN KEY (channel_id) REFERENCES dalet.channel (channel_id)
        ON DELETE SET NULL;

-- -------------------------------------------------------------------------
-- Assets.
-- -------------------------------------------------------------------------
ALTER TABLE dalet.media_object
    ADD CONSTRAINT fk_media_object_folder
        FOREIGN KEY (folder_id) REFERENCES dalet.folder (folder_id)
        ON DELETE SET NULL;

ALTER TABLE dalet.essence
    ADD CONSTRAINT fk_essence_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE CASCADE;

ALTER TABLE dalet.metadata_value
    ADD CONSTRAINT fk_metadata_value_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_metadata_value_field
        FOREIGN KEY (metadata_field_id) REFERENCES dalet.metadata_field (metadata_field_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_metadata_value_term
        FOREIGN KEY (vocabulary_term_id) REFERENCES dalet.vocabulary_term (vocabulary_term_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.collection_member
    ADD CONSTRAINT fk_collection_member_collection
        FOREIGN KEY (collection_id) REFERENCES dalet.collection (collection_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_collection_member_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE CASCADE;

-- A vocabulary term still in use cannot be removed.
ALTER TABLE dalet.tag_assignment
    ADD CONSTRAINT fk_tag_assignment_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_tag_assignment_term
        FOREIGN KEY (vocabulary_term_id) REFERENCES dalet.vocabulary_term (vocabulary_term_id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Workflow.
-- -------------------------------------------------------------------------
ALTER TABLE dalet.job
    ADD CONSTRAINT fk_job_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE SET NULL;

ALTER TABLE dalet.job_task
    ADD CONSTRAINT fk_job_task_job
        FOREIGN KEY (job_id) REFERENCES dalet.job (job_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_job_task_depends_on
        FOREIGN KEY (depends_on_task_id) REFERENCES dalet.job_task (job_task_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.transfer
    ADD CONSTRAINT fk_transfer_job
        FOREIGN KEY (job_id) REFERENCES dalet.job (job_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_transfer_essence
        FOREIGN KEY (essence_id) REFERENCES dalet.essence (essence_id)
        ON DELETE CASCADE;

ALTER TABLE dalet.editorial_brief
    ADD CONSTRAINT fk_editorial_brief_target
        FOREIGN KEY (target_publication_target_id)
        REFERENCES dalet.publication_target (publication_target_id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_editorial_brief_job
        FOREIGN KEY (job_id) REFERENCES dalet.job (job_id)
        ON DELETE SET NULL;

-- -------------------------------------------------------------------------
-- Rights. RESTRICT throughout: these records are compliance evidence.
-- -------------------------------------------------------------------------
ALTER TABLE dalet.rights_window
    ADD CONSTRAINT fk_rights_window_contract
        FOREIGN KEY (rights_contract_id) REFERENCES dalet.rights_contract (rights_contract_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_rights_window_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_rights_window_collection
        FOREIGN KEY (collection_id) REFERENCES dalet.collection (collection_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_rights_window_publication_target
        FOREIGN KEY (publication_target_id)
        REFERENCES dalet.publication_target (publication_target_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_rights_window_channel
        FOREIGN KEY (channel_id) REFERENCES dalet.channel (channel_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.publication
    ADD CONSTRAINT fk_publication_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_publication_essence
        FOREIGN KEY (essence_id) REFERENCES dalet.essence (essence_id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_publication_target
        FOREIGN KEY (publication_target_id)
        REFERENCES dalet.publication_target (publication_target_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_publication_rights_window
        FOREIGN KEY (rights_window_id) REFERENCES dalet.rights_window (rights_window_id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Scheduling.
-- -------------------------------------------------------------------------
ALTER TABLE dalet.running_order
    ADD CONSTRAINT fk_running_order_channel
        FOREIGN KEY (channel_id) REFERENCES dalet.channel (channel_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.schedule_item
    ADD CONSTRAINT fk_schedule_item_running_order
        FOREIGN KEY (running_order_id) REFERENCES dalet.running_order (running_order_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_schedule_item_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE RESTRICT;

ALTER TABLE dalet.feed
    ADD CONSTRAINT fk_feed_channel
        FOREIGN KEY (channel_id) REFERENCES dalet.channel (channel_id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_feed_media_object
        FOREIGN KEY (media_object_id) REFERENCES dalet.media_object (media_object_id)
        ON DELETE SET NULL;
