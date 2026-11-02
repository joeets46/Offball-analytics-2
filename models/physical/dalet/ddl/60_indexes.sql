-- =========================================================================
-- dalet -- indexes
--
-- Two heavy access patterns: searching assets by metadata (the librarian's
-- job) and answering "may we show this, here, now" from the rights windows
-- (the compliance question, asked before every publication).
--
-- The territory arrays are GIN-indexed because the rights question is always
-- a containment test -- is GBR in this window's territories.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Catalog and vocabulary.
-- -------------------------------------------------------------------------
CREATE INDEX ix_folder_parent          ON dalet.folder (parent_folder_id)
    WHERE parent_folder_id IS NOT NULL;
-- Prefix search down the materialised path.
CREATE INDEX ix_folder_path            ON dalet.folder (folder_path text_pattern_ops);

CREATE INDEX ix_vocabulary_term_vocabulary ON dalet.vocabulary_term (vocabulary_id)
    WHERE NOT is_deprecated;
CREATE INDEX ix_vocabulary_term_parent ON dalet.vocabulary_term (parent_term_id)
    WHERE parent_term_id IS NOT NULL;
CREATE INDEX ix_vocabulary_term_text   ON dalet.vocabulary_term (term);

CREATE INDEX ix_metadata_field_vocabulary ON dalet.metadata_field (vocabulary_id)
    WHERE vocabulary_id IS NOT NULL;
-- The publication gate: which fields must be present before an asset can go out.
CREATE INDEX ix_metadata_field_publication_mandatory
    ON dalet.metadata_field (field_name) WHERE is_mandatory_for_publication;

CREATE INDEX ix_publication_target_channel ON dalet.publication_target (channel_id)
    WHERE channel_id IS NOT NULL;

-- -------------------------------------------------------------------------
-- Assets.
-- -------------------------------------------------------------------------
CREATE INDEX ix_media_object_folder    ON dalet.media_object (folder_id)
    WHERE folder_id IS NOT NULL;
CREATE INDEX ix_media_object_status    ON dalet.media_object (lifecycle_status, updated_at);
CREATE INDEX ix_media_object_class     ON dalet.media_object (content_class, content_date DESC)
    WHERE content_class IS NOT NULL;
CREATE INDEX ix_media_object_title     ON dalet.media_object (title);
-- Unfilled placeholders: the production worklist.
CREATE INDEX ix_media_object_placeholders
    ON dalet.media_object (created_at) WHERE is_placeholder;
-- Archive sweep.
CREATE INDEX ix_media_object_archive_due
    ON dalet.media_object (archive_after)
    WHERE archive_after IS NOT NULL AND lifecycle_status <> 'archived';
-- Resolution outward.
CREATE INDEX ix_media_object_tm_event  ON dalet.media_object (tm_event_code)
    WHERE tm_event_code IS NOT NULL;
CREATE INDEX ix_media_object_hudl      ON dalet.media_object (hudl_video_id)
    WHERE hudl_video_id IS NOT NULL;

CREATE INDEX ix_essence_media_object   ON dalet.essence (media_object_id, essence_role);
CREATE INDEX ix_essence_profile        ON dalet.essence (essence_profile);
-- Storage cost and tiering reporting, which is the thing the target model
-- cannot do at all.
CREATE INDEX ix_essence_storage_tier   ON dalet.essence (storage_tier, file_size_bytes DESC);
-- Deep-archive essences, whose restore latency decides whether they are
-- usable during a live event.
CREATE INDEX ix_essence_deep_archive
    ON dalet.essence (media_object_id) WHERE storage_tier IN ('archive', 'deep_archive');

-- Metadata search: the librarian's path, from both directions.
CREATE INDEX ix_metadata_value_media_object ON dalet.metadata_value (media_object_id);
CREATE INDEX ix_metadata_value_field_text
    ON dalet.metadata_value (metadata_field_id, text_value) WHERE text_value IS NOT NULL;
CREATE INDEX ix_metadata_value_field_term
    ON dalet.metadata_value (metadata_field_id, vocabulary_term_id)
    WHERE vocabulary_term_id IS NOT NULL;
CREATE INDEX ix_metadata_value_field_date
    ON dalet.metadata_value (metadata_field_id, date_value) WHERE date_value IS NOT NULL;

CREATE INDEX ix_collection_member_media_object ON dalet.collection_member (media_object_id);
CREATE INDEX ix_tag_assignment_term    ON dalet.tag_assignment (vocabulary_term_id);
-- Unverified machine tags, the review queue.
CREATE INDEX ix_tag_assignment_unverified
    ON dalet.tag_assignment (media_object_id)
    WHERE NOT is_verified AND assigned_by <> 'human';

-- -------------------------------------------------------------------------
-- Workflow.
-- -------------------------------------------------------------------------
CREATE INDEX ix_job_media_object       ON dalet.job (media_object_id)
    WHERE media_object_id IS NOT NULL;
CREATE INDEX ix_job_type_status        ON dalet.job (job_type, job_status);
-- The operator's queue: active work by priority then deadline.
CREATE INDEX ix_job_active_queue
    ON dalet.job (priority, due_at)
    WHERE job_status IN ('queued', 'running', 'paused', 'awaiting_approval');
-- Overdue work.
CREATE INDEX ix_job_overdue
    ON dalet.job (due_at)
    WHERE due_at IS NOT NULL AND job_status NOT IN ('completed', 'cancelled');
CREATE INDEX ix_job_tm_event           ON dalet.job (tm_event_code) WHERE tm_event_code IS NOT NULL;

CREATE INDEX ix_job_task_job           ON dalet.job_task (job_id, task_order);
CREATE INDEX ix_job_task_depends_on    ON dalet.job_task (depends_on_task_id)
    WHERE depends_on_task_id IS NOT NULL;

CREATE INDEX ix_transfer_job           ON dalet.transfer (job_id) WHERE job_id IS NOT NULL;
CREATE INDEX ix_transfer_essence       ON dalet.transfer (essence_id) WHERE essence_id IS NOT NULL;
CREATE INDEX ix_transfer_active        ON dalet.transfer (started_at)
    WHERE transfer_status IN ('queued', 'running');

CREATE INDEX ix_editorial_brief_target
    ON dalet.editorial_brief (target_publication_target_id)
    WHERE target_publication_target_id IS NOT NULL;
CREATE INDEX ix_editorial_brief_job    ON dalet.editorial_brief (job_id) WHERE job_id IS NOT NULL;
CREATE INDEX ix_editorial_brief_open   ON dalet.editorial_brief (due_at)
    WHERE brief_status IN ('approved', 'in_production');

-- -------------------------------------------------------------------------
-- Rights. The compliance question, asked before every publication.
-- -------------------------------------------------------------------------
CREATE INDEX ix_rights_contract_direction
    ON dalet.rights_contract (direction, contract_status);
CREATE INDEX ix_rights_contract_sfdc
    ON dalet.rights_contract (sfdc_contract_id) WHERE sfdc_contract_id IS NOT NULL;
CREATE INDEX ix_rights_contract_sap
    ON dalet.rights_contract (sap_contract_number) WHERE sap_contract_number IS NOT NULL;
CREATE INDEX ix_rights_contract_expiring
    ON dalet.rights_contract (effective_to) WHERE contract_status = 'active';

CREATE INDEX ix_rights_window_contract ON dalet.rights_window (rights_contract_id);
CREATE INDEX ix_rights_window_media_object
    ON dalet.rights_window (media_object_id) WHERE media_object_id IS NOT NULL;
CREATE INDEX ix_rights_window_collection
    ON dalet.rights_window (collection_id) WHERE collection_id IS NOT NULL;
CREATE INDEX ix_rights_window_target
    ON dalet.rights_window (publication_target_id) WHERE publication_target_id IS NOT NULL;
CREATE INDEX ix_rights_window_channel
    ON dalet.rights_window (channel_id) WHERE channel_id IS NOT NULL;
-- The window period, for "is this right live now".
CREATE INDEX ix_rights_window_period   ON dalet.rights_window (window_from, window_to);
-- Territory containment: "is GBR covered by this window". GIN on the array,
-- because this is the actual shape of the rights question.
CREATE INDEX ix_rights_window_territories
    ON dalet.rights_window USING GIN (territory_codes);
CREATE INDEX ix_rights_window_excluded_territories
    ON dalet.rights_window USING GIN (excluded_territory_codes)
    WHERE excluded_territory_codes IS NOT NULL;
-- Exclusive windows, which block every other licensee and so are checked on
-- every new sale.
CREATE INDEX ix_rights_window_exclusive
    ON dalet.rights_window (window_from, window_to) WHERE is_exclusive;
-- Blackout-until-sellout windows: the rights rule that depends on live
-- ticketing inventory.
CREATE INDEX ix_rights_window_sellout_blackout
    ON dalet.rights_window (media_object_id) WHERE blackout_until_sellout;

CREATE INDEX ix_publication_media_object ON dalet.publication (media_object_id);
CREATE INDEX ix_publication_essence    ON dalet.publication (essence_id) WHERE essence_id IS NOT NULL;
CREATE INDEX ix_publication_target_ref ON dalet.publication (publication_target_id);
CREATE INDEX ix_publication_rights_window
    ON dalet.publication (rights_window_id) WHERE rights_window_id IS NOT NULL;
-- Live publications with no rights window: the compliance exception report.
CREATE INDEX ix_publication_unlicensed
    ON dalet.publication (published_at)
    WHERE publication_status = 'live' AND rights_window_id IS NULL;
-- Expiry sweep: live publications whose rights are about to lapse.
CREATE INDEX ix_publication_expiring
    ON dalet.publication (expires_at)
    WHERE publication_status = 'live' AND expires_at IS NOT NULL;

-- -------------------------------------------------------------------------
-- Scheduling.
-- -------------------------------------------------------------------------
CREATE INDEX ix_running_order_channel_date
    ON dalet.running_order (channel_id, broadcast_date DESC);
CREATE INDEX ix_schedule_item_running_order
    ON dalet.schedule_item (running_order_id, item_order);
CREATE INDEX ix_schedule_item_media_object
    ON dalet.schedule_item (media_object_id) WHERE media_object_id IS NOT NULL;
CREATE INDEX ix_schedule_item_scheduled_start
    ON dalet.schedule_item (scheduled_start_at);
CREATE INDEX ix_schedule_item_live     ON dalet.schedule_item (scheduled_start_at) WHERE is_live;
CREATE INDEX ix_schedule_item_tm_event
    ON dalet.schedule_item (tm_event_code) WHERE tm_event_code IS NOT NULL;

CREATE INDEX ix_feed_channel           ON dalet.feed (channel_id) WHERE channel_id IS NOT NULL;
CREATE INDEX ix_feed_media_object      ON dalet.feed (media_object_id) WHERE media_object_id IS NOT NULL;
CREATE INDEX ix_feed_tm_event          ON dalet.feed (tm_event_code) WHERE tm_event_code IS NOT NULL;
-- Signals currently on air or in trouble, which is an operations dashboard.
CREATE INDEX ix_feed_live              ON dalet.feed (live_from)
    WHERE feed_status IN ('live', 'degraded', 'lost');

-- -------------------------------------------------------------------------
-- Extraction watermarks.
-- -------------------------------------------------------------------------
CREATE INDEX ix_media_object_updated_at ON dalet.media_object (updated_at);
CREATE INDEX ix_essence_updated_at     ON dalet.essence (updated_at);
CREATE INDEX ix_metadata_value_updated_at ON dalet.metadata_value (updated_at);
CREATE INDEX ix_job_updated_at         ON dalet.job (updated_at);
CREATE INDEX ix_rights_window_updated_at ON dalet.rights_window (updated_at);
CREATE INDEX ix_publication_updated_at ON dalet.publication (updated_at);
CREATE INDEX ix_schedule_item_updated_at ON dalet.schedule_item (updated_at);
CREATE INDEX ix_collection_updated_at  ON dalet.collection (updated_at);
CREATE INDEX ix_feed_updated_at        ON dalet.feed (updated_at);
