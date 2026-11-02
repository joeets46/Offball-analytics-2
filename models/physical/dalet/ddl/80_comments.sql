-- =========================================================================
-- dalet -- table comments
-- =========================================================================

COMMENT ON TABLE dalet.vocabulary_term IS
    'Controlled vocabulary terms, optionally hierarchical -- Sport > Football > Premier League.';
COMMENT ON TABLE dalet.channel IS
    'Linear and OTT outlets. Feeds target broadcast.channel.';
COMMENT ON TABLE dalet.publication_target IS
    'Delivery destinations with their technical spec. A target that will not accept the essence profile is the commonest cause of a failed publication.';
COMMENT ON TABLE dalet.metadata_value IS
    'Metadata values against a field, in typed columns rather than one text column so values stay sortable. Feeds target content.asset_tag.';
COMMENT ON TABLE dalet.collection IS
    'Asset collections -- series, season packs, playlists. A smart collection is a stored query and so has no membership rows.';
COMMENT ON TABLE dalet.collection_member IS
    'Collection membership. Feeds target content.collection_item.';
COMMENT ON TABLE dalet.job IS
    'Workflow jobs: ingest, transcode, edit, QC, publish, archive. Feeds target content.production_order, content.ingest_job and broadcast.production.';
COMMENT ON TABLE dalet.job_task IS
    'Job steps with dependencies, which is what makes a job a workflow rather than a list.';
COMMENT ON TABLE dalet.transfer IS
    'Essence movement between storage and sites. Contributes to target content.ingest_job.';
COMMENT ON TABLE dalet.editorial_brief IS
    'Content commissions with target platform, duration and aspect ratio. A 15-second vertical clip and a three-minute package are different commissions.';
COMMENT ON TABLE dalet.running_order IS
    'A channel playout schedule for one day. Locked means playout has taken it, after which changes are as-run amendments rather than edits.';
COMMENT ON TABLE dalet.feed IS
    'Live signals. Feeds target broadcast.live_feed; a clean feed carries no commentary or graphics, which is what makes it licensable onward.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE dalet.folder IS
    'The hierarchical asset catalog. Feeds target content.category; the materialised path is kept alongside the parent reference because these trees are deep and read constantly.';
COMMENT ON TABLE dalet.vocabulary IS
    'Controlled term lists. An open vocabulary lets operators add terms as they tag, which is useful and is also why controlled vocabularies drift.';
COMMENT ON TABLE dalet.media_object IS
    'The editorial asset, and the source of both target content.asset and broadcast.media_asset. A placeholder with no essence is a normal, intended state rather than a broken row.';
COMMENT ON TABLE dalet.tag_assignment IS
    'Tags on an asset, human or machine. The target model does not distinguish them, so an unverified AI guess and a librarian judgement arrive indistinguishable.';
COMMENT ON TABLE dalet.rights_contract IS
    'Rights agreements, inbound and outbound in one table. An extract that ignores the direction counts acquired rights as revenue.';
COMMENT ON TABLE dalet.publication IS
    'A delivery of an asset to a target. A live publication with no rights window behind it is either wholly owned content or an unlicensed publication, and only the first is acceptable.';
COMMENT ON TABLE dalet.schedule_item IS
    'Items in a playout running order. The scheduled-versus-as-run gap is the operational reality of live sport, where a match going to extra time shifts everything after it.';
