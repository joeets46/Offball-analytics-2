-- Metric views for domain: content | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`content_asset`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core content asset KPIs measuring the volume, size, quality, and rights posture of the digital asset library. Used by Content Operations and Rights Management to steer ingestion strategy, storage investment, and rights compliance."
  source: "`sports_entertainment_ecm`.`content`.`asset`"
  dimensions:
    - name: "asset_type"
      expr: asset_type
      comment: "Classifies the asset (e.g. video, image, audio, document) for segmenting volume and size metrics by content type."
    - name: "lifecycle_status"
      expr: lifecycle_status
      comment: "Current lifecycle stage of the asset (e.g. active, archived, deleted) enabling operational health monitoring."
    - name: "rights_type"
      expr: rights_type
      comment: "Rights classification (e.g. owned, licensed, UGC) critical for rights compliance and monetisation eligibility analysis."
    - name: "drm_status"
      expr: drm_status
      comment: "DRM protection status of the asset, used to identify unprotected premium content at risk."
    - name: "sport_discipline"
      expr: sport_discipline
      comment: "Sport or discipline associated with the asset, enabling performance analysis by sport vertical."
    - name: "content_rating"
      expr: content_rating
      comment: "Audience content rating (e.g. G, PG, R) for compliance and audience-targeting segmentation."
    - name: "ingest_source"
      expr: ingest_source
      comment: "Origin system or channel from which the asset was ingested, used to evaluate source quality and volume."
    - name: "is_live_clip"
      expr: is_live_clip
      comment: "Indicates whether the asset is a live-event clip, distinguishing live from VOD content in volume analysis."
    - name: "is_ppv_restricted"
      expr: is_ppv_restricted
      comment: "Flags pay-per-view restricted assets, enabling monetisation and access-control reporting."
    - name: "is_ugc"
      expr: is_ugc
      comment: "Identifies user-generated content assets, which carry different rights and moderation obligations."
    - name: "language_code"
      expr: language_code
      comment: "Language of the asset, used for localisation coverage and international distribution analysis."
    - name: "published_date"
      expr: DATE_TRUNC('day', published_timestamp)
      comment: "Day the asset was published, enabling trend analysis of content publication velocity."
    - name: "published_month"
      expr: DATE_TRUNC('month', published_timestamp)
      comment: "Month the asset was published, used for monthly content output reporting."
  measures:
    - name: "total_assets"
      expr: COUNT(1)
      comment: "Total number of assets in the library. Baseline volume KPI used to track content library growth over time."
    - name: "total_file_size_gb"
      expr: ROUND(SUM(CAST(file_size_bytes AS DOUBLE)) / 1073741824.0, 2)
      comment: "Total storage footprint of all assets in gigabytes. Directly drives infrastructure cost decisions and storage tier planning."
    - name: "avg_file_size_mb"
      expr: ROUND(AVG(CAST(file_size_bytes AS DOUBLE)) / 1048576.0, 2)
      comment: "Average asset file size in megabytes. Used to benchmark encoding efficiency and detect outlier assets inflating storage costs."
    - name: "avg_frame_rate"
      expr: ROUND(AVG(CAST(frame_rate AS DOUBLE)), 2)
      comment: "Average frame rate across assets. Indicates technical quality standard of the content library and informs encoding policy."
    - name: "ppv_restricted_asset_count"
      expr: COUNT(CASE WHEN is_ppv_restricted = TRUE THEN 1 END)
      comment: "Number of assets gated behind pay-per-view. Tracks the monetisable premium content inventory available for PPV distribution."
    - name: "ugc_asset_count"
      expr: COUNT(CASE WHEN is_ugc = TRUE THEN 1 END)
      comment: "Number of user-generated content assets. UGC volume informs moderation resource planning and rights risk exposure."
    - name: "live_clip_asset_count"
      expr: COUNT(CASE WHEN is_live_clip = TRUE THEN 1 END)
      comment: "Number of live-event clip assets. Measures real-time content capture throughput from live events."
    - name: "drm_protected_asset_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN drm_status = 'protected' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assets with active DRM protection. A rights compliance KPI — low values signal premium content at piracy risk."
    - name: "active_asset_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN lifecycle_status = 'active' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assets in active lifecycle status. Measures library health and the proportion of content available for distribution."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`content_ingest_job`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Content ingestion pipeline KPIs covering throughput, quality control pass rates, failure rates, and file volume. Used by Content Operations and Engineering to monitor pipeline reliability and content intake efficiency."
  source: "`sports_entertainment_ecm`.`content`.`ingest_job`"
  dimensions:
    - name: "job_status"
      expr: job_status
      comment: "Current status of the ingest job (e.g. completed, failed, in-progress) for pipeline health segmentation."
    - name: "qc_status"
      expr: qc_status
      comment: "Quality control outcome of the ingest job, used to measure content quality gate pass rates."
    - name: "content_type"
      expr: content_type
      comment: "Type of content being ingested (e.g. live, VOD, highlights) for throughput analysis by content category."
    - name: "ingest_channel"
      expr: ingest_channel
      comment: "Channel or method through which content was ingested (e.g. satellite, IP, upload) for source performance benchmarking."
    - name: "source_type"
      expr: source_type
      comment: "Origin type of the ingest source, enabling analysis of reliability by source category."
    - name: "storage_tier"
      expr: storage_tier
      comment: "Storage tier assigned to ingested content (e.g. hot, warm, cold) for cost and access-pattern analysis."
    - name: "ingest_priority"
      expr: ingest_priority
      comment: "Priority level assigned to the ingest job, used to evaluate SLA adherence for high-priority content."
    - name: "drm_clearance_status"
      expr: drm_clearance_status
      comment: "DRM clearance outcome for the ingested content, critical for rights compliance monitoring."
    - name: "is_ugc"
      expr: is_ugc
      comment: "Flags user-generated content ingest jobs, which require additional moderation and rights scrutiny."
    - name: "content_date"
      expr: DATE_TRUNC('day', content_date)
      comment: "Date of the content being ingested, enabling time-series analysis of ingest volume by content date."
    - name: "ingest_month"
      expr: DATE_TRUNC('month', ingest_timestamp)
      comment: "Month the ingest job was initiated, used for monthly pipeline throughput trending."
  measures:
    - name: "total_ingest_jobs"
      expr: COUNT(1)
      comment: "Total number of ingest jobs executed. Baseline throughput KPI for the content ingestion pipeline."
    - name: "qc_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN qc_status = 'passed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of ingest jobs that passed quality control. A primary pipeline quality KPI — declining values trigger engineering investigation."
    - name: "job_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN job_status = 'failed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of ingest jobs that failed. Directly measures pipeline reliability; high values indicate systemic ingestion issues."
    - name: "avg_qc_score"
      expr: ROUND(AVG(CAST(qc_score AS DOUBLE)), 2)
      comment: "Average quality control score across all ingest jobs. Tracks overall content quality entering the library over time."
    - name: "total_ingested_file_size_gb"
      expr: ROUND(SUM(CAST(total_file_size_mb AS DOUBLE)) / 1024.0, 2)
      comment: "Total volume of content ingested in gigabytes. Drives storage capacity planning and bandwidth cost forecasting."
    - name: "avg_ingest_duration_seconds"
      expr: ROUND(AVG(CAST(ingest_duration_seconds AS DOUBLE)), 2)
      comment: "Average time taken to complete an ingest job in seconds. Measures pipeline throughput efficiency and SLA compliance."
    - name: "avg_content_duration_seconds"
      expr: ROUND(AVG(CAST(duration_seconds AS DOUBLE)), 2)
      comment: "Average duration of ingested content in seconds. Informs encoding resource allocation and storage tier decisions."
    - name: "drm_clearance_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN drm_clearance_status = 'failed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of ingest jobs where DRM clearance failed. A rights compliance risk KPI — high values block content from distribution."
    - name: "broadcast_rights_eligible_count"
      expr: COUNT(CASE WHEN broadcast_rights_flag = TRUE THEN 1 END)
      comment: "Number of ingest jobs flagged as broadcast-rights eligible. Measures the volume of content cleared for broadcast distribution."
    - name: "ott_rights_eligible_count"
      expr: COUNT(CASE WHEN ott_rights_flag = TRUE THEN 1 END)
      comment: "Number of ingest jobs flagged as OTT-rights eligible. Tracks content available for streaming platform distribution."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`content_publish_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Content distribution and publishing KPIs measuring publication velocity, distribution success rates, PPV volume, geo-restriction coverage, and takedown activity. Used by Distribution, Rights, and Revenue teams to steer publishing operations."
  source: "`sports_entertainment_ecm`.`content`.`publish_event`"
  dimensions:
    - name: "distribution_status"
      expr: distribution_status
      comment: "Outcome of the distribution attempt (e.g. published, failed, pending) for pipeline health segmentation."
    - name: "content_type"
      expr: content_type
      comment: "Type of content published (e.g. live, VOD, highlights) for distribution analysis by content category."
    - name: "content_rating"
      expr: content_rating
      comment: "Audience rating of published content, used for compliance and audience-targeting analysis."
    - name: "is_live_content"
      expr: is_live_content
      comment: "Distinguishes live from on-demand publish events, enabling separate SLA tracking for live distribution."
    - name: "is_ppv"
      expr: is_ppv
      comment: "Flags pay-per-view publish events, used to track premium monetisation distribution volume."
    - name: "geo_restriction_applied"
      expr: geo_restriction_applied
      comment: "Indicates whether geo-restrictions were enforced on the publish event, critical for rights territory compliance."
    - name: "drm_scheme"
      expr: drm_scheme
      comment: "DRM scheme applied to the published content (e.g. Widevine, FairPlay), used for platform compatibility analysis."
    - name: "moderation_status"
      expr: moderation_status
      comment: "Content moderation outcome at time of publish, used to track compliance with content standards."
    - name: "ugc_source_flag"
      expr: ugc_source_flag
      comment: "Identifies publish events originating from user-generated content, which carry elevated rights and moderation risk."
    - name: "publish_month"
      expr: DATE_TRUNC('month', publish_timestamp)
      comment: "Month of publication, used for monthly distribution volume trending and capacity planning."
    - name: "publish_day"
      expr: DATE_TRUNC('day', publish_timestamp)
      comment: "Day of publication, enabling daily distribution throughput monitoring and SLA tracking."
  measures:
    - name: "total_publish_events"
      expr: COUNT(1)
      comment: "Total number of content publish events. Baseline distribution throughput KPI for the publishing pipeline."
    - name: "distribution_success_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN distribution_status = 'published' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of publish events that successfully reached distribution. Primary publishing pipeline reliability KPI."
    - name: "distribution_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN distribution_status = 'failed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of publish events that failed distribution. Triggers engineering and operations intervention when elevated."
    - name: "ppv_publish_count"
      expr: COUNT(CASE WHEN is_ppv = TRUE THEN 1 END)
      comment: "Number of pay-per-view publish events. Tracks premium monetisation distribution volume for revenue forecasting."
    - name: "live_content_publish_count"
      expr: COUNT(CASE WHEN is_live_content = TRUE THEN 1 END)
      comment: "Number of live content publish events. Measures real-time distribution throughput and live SLA performance."
    - name: "geo_restricted_publish_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN geo_restriction_applied = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of publish events with geo-restrictions applied. Measures rights territory compliance coverage across all distributions."
    - name: "takedown_event_count"
      expr: COUNT(CASE WHEN takedown_timestamp IS NOT NULL THEN 1 END)
      comment: "Number of publish events that resulted in a content takedown. A rights and compliance risk KPI — high values indicate systemic rights clearance failures."
    - name: "total_published_file_size_gb"
      expr: ROUND(SUM(CAST(asset_file_size_mb AS DOUBLE)) / 1024.0, 2)
      comment: "Total file size of all published content in gigabytes. Drives CDN bandwidth cost forecasting and capacity planning."
    - name: "distinct_assets_published"
      expr: COUNT(DISTINCT asset_id)
      comment: "Number of unique assets that have been published. Measures the breadth of the active content catalogue available to audiences."
    - name: "distinct_channels_used"
      expr: COUNT(DISTINCT platform_channel_id)
      comment: "Number of distinct platform channels used for distribution. Measures distribution reach and channel diversification."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`content_license`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Content licensing financial and compliance KPIs covering fee revenue, royalty rates, exclusivity, and rights territory coverage. Used by Rights Management, Legal, and Finance to steer licensing strategy and compliance posture."
  source: "`sports_entertainment_ecm`.`content`.`license`"
  dimensions:
    - name: "license_status"
      expr: license_status
      comment: "Current status of the license (e.g. active, expired, terminated) for portfolio health segmentation."
    - name: "deal_type"
      expr: deal_type
      comment: "Type of licensing deal (e.g. flat fee, revenue share, royalty) for financial structure analysis."
    - name: "usage_type"
      expr: usage_type
      comment: "Permitted usage type under the license (e.g. broadcast, streaming, print) for rights scope analysis."
    - name: "rights_territory"
      expr: rights_territory
      comment: "Geographic territory covered by the license, used for rights territory coverage and gap analysis."
    - name: "exclusivity_flag"
      expr: exclusivity_flag
      comment: "Indicates whether the license grants exclusive rights, used to track premium exclusivity commitments."
    - name: "auto_renewal_flag"
      expr: auto_renewal_flag
      comment: "Flags licenses set for automatic renewal, enabling proactive contract management and revenue forecasting."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the license fee, used for multi-currency financial reporting and FX exposure analysis."
    - name: "compliance_status"
      expr: compliance_status
      comment: "Compliance review status of the license, used to identify licenses at regulatory or contractual risk."
    - name: "sport_code"
      expr: sport_code
      comment: "Sport associated with the license, enabling licensing revenue and volume analysis by sport vertical."
    - name: "effective_start_date"
      expr: DATE_TRUNC('month', effective_start_date)
      comment: "Month the license became effective, used for cohort analysis of licensing deal vintages."
    - name: "expiry_month"
      expr: DATE_TRUNC('month', expiry_date)
      comment: "Month the license expires, used for renewal pipeline forecasting and revenue cliff analysis."
  measures:
    - name: "total_licenses"
      expr: COUNT(1)
      comment: "Total number of content licenses in the portfolio. Baseline KPI for rights portfolio scale and coverage."
    - name: "total_license_fee_amount"
      expr: ROUND(SUM(CAST(fee_amount AS DOUBLE)), 2)
      comment: "Total licensing fee revenue across all licenses. Primary financial KPI for the content rights monetisation function."
    - name: "avg_license_fee_amount"
      expr: ROUND(AVG(CAST(fee_amount AS DOUBLE)), 2)
      comment: "Average licensing fee per license. Benchmarks deal value and informs pricing strategy for new license negotiations."
    - name: "total_flat_fee_amount"
      expr: ROUND(SUM(CAST(flat_fee_amount AS DOUBLE)), 2)
      comment: "Total flat-fee licensing revenue. Separates fixed-fee income from variable revenue-share income for financial planning."
    - name: "avg_royalty_rate_pct"
      expr: ROUND(AVG(CAST(royalty_rate AS DOUBLE)), 4)
      comment: "Average royalty rate across royalty-bearing licenses. Informs royalty obligation forecasting and deal benchmarking."
    - name: "avg_revenue_share_pct"
      expr: ROUND(AVG(CAST(revenue_share_pct AS DOUBLE)), 4)
      comment: "Average revenue share percentage across revenue-share licenses. Used to model variable income under different distribution scenarios."
    - name: "avg_cpm_rate"
      expr: ROUND(AVG(CAST(cpm_rate AS DOUBLE)), 4)
      comment: "Average CPM rate across advertising-linked licenses. Benchmarks ad-supported content monetisation efficiency."
    - name: "exclusive_license_count"
      expr: COUNT(CASE WHEN exclusivity_flag = TRUE THEN 1 END)
      comment: "Number of exclusive licenses in the portfolio. Tracks premium exclusivity commitments that restrict multi-platform distribution."
    - name: "expiring_within_90_days_count"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Number of licenses expiring within the next 90 days. A renewal pipeline urgency KPI — high values trigger proactive contract renegotiation."
    - name: "non_compliant_license_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN compliance_status != 'compliant' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of licenses with a non-compliant status. A legal and regulatory risk KPI — elevated values require immediate remediation."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`content_production_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Content production pipeline KPIs covering cost, throughput, delivery timeliness, rights clearance, and editorial approval rates. Used by Production, Finance, and Editorial leadership to manage production efficiency and budget performance."
  source: "`sports_entertainment_ecm`.`content`.`production_order`"
  dimensions:
    - name: "order_status"
      expr: order_status
      comment: "Current status of the production order (e.g. in-progress, completed, cancelled) for pipeline health monitoring."
    - name: "order_type"
      expr: order_type
      comment: "Type of production order (e.g. original, edit, repurpose) for cost and throughput analysis by production category."
    - name: "production_stage"
      expr: production_stage
      comment: "Current stage in the production workflow (e.g. pre-production, post-production, delivery) for bottleneck identification."
    - name: "editorial_approval_status"
      expr: editorial_approval_status
      comment: "Editorial approval outcome, used to track content quality gate pass rates through the editorial process."
    - name: "rights_clearance_status"
      expr: rights_clearance_status
      comment: "Rights clearance status for the production, used to identify content blocked from distribution due to rights issues."
    - name: "priority"
      expr: priority
      comment: "Production priority level, used to evaluate resource allocation and SLA adherence for high-priority content."
    - name: "is_sponsored_content"
      expr: is_sponsored_content
      comment: "Flags sponsored content productions, enabling separate cost and revenue tracking for branded content."
    - name: "language_code"
      expr: language_code
      comment: "Language of the production output, used for localisation coverage and international content investment analysis."
    - name: "territory_code"
      expr: territory_code
      comment: "Geographic territory for the production, enabling regional content investment analysis."
    - name: "scheduled_publish_month"
      expr: DATE_TRUNC('month', scheduled_publish_date)
      comment: "Month the production is scheduled for publication, used for content pipeline capacity planning."
    - name: "start_month"
      expr: DATE_TRUNC('month', start_date)
      comment: "Month production started, used for cohort analysis of production cycle times and cost trends."
  measures:
    - name: "total_production_orders"
      expr: COUNT(1)
      comment: "Total number of production orders. Baseline throughput KPI for the content production pipeline."
    - name: "total_production_cost"
      expr: ROUND(SUM(CAST(production_cost AS DOUBLE)), 2)
      comment: "Total production cost across all orders. Primary financial KPI for content production investment and budget management."
    - name: "avg_production_cost"
      expr: ROUND(AVG(CAST(production_cost AS DOUBLE)), 2)
      comment: "Average production cost per order. Benchmarks production efficiency and informs budget allocation for future productions."
    - name: "total_hours_allocated"
      expr: ROUND(SUM(CAST(hours_allocated AS DOUBLE)), 2)
      comment: "Total production hours allocated across all orders. Measures workforce capacity utilisation in the production function."
    - name: "avg_hours_per_order"
      expr: ROUND(AVG(CAST(hours_allocated AS DOUBLE)), 2)
      comment: "Average hours allocated per production order. Used to benchmark production complexity and resource planning efficiency."
    - name: "avg_billing_rate"
      expr: ROUND(AVG(CAST(billing_rate AS DOUBLE)), 2)
      comment: "Average billing rate per production order. Informs pricing strategy for externally billed productions and cost recovery analysis."
    - name: "rights_clearance_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN rights_clearance_status = 'failed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of production orders with failed rights clearance. A rights risk KPI — high values indicate systemic clearance process failures blocking content delivery."
    - name: "editorial_approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN editorial_approval_status = 'approved' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of production orders that received editorial approval. Measures content quality gate effectiveness and editorial throughput."
    - name: "on_time_delivery_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_delivery_date <= deadline THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_delivery_date IS NOT NULL AND deadline IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of production orders delivered on or before deadline. A primary operational SLA KPI for the production function."
    - name: "sponsored_content_order_count"
      expr: COUNT(CASE WHEN is_sponsored_content = TRUE THEN 1 END)
      comment: "Number of sponsored content production orders. Tracks branded content production volume, which is directly linked to sponsorship revenue."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`content_editorial_brief`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Editorial pipeline KPIs measuring brief throughput, approval rates, embargo compliance, exclusivity volume, and publication timeliness. Used by Editorial leadership to manage content pipeline health and commissioning strategy."
  source: "`sports_entertainment_ecm`.`content`.`editorial_brief`"
  dimensions:
    - name: "brief_status"
      expr: brief_status
      comment: "Current status of the editorial brief (e.g. draft, commissioned, published, cancelled) for pipeline stage analysis."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval outcome of the editorial brief, used to track editorial quality gate pass rates."
    - name: "content_type"
      expr: content_type
      comment: "Type of editorial content (e.g. article, video, social post) for volume and throughput analysis by format."
    - name: "content_priority"
      expr: content_priority
      comment: "Priority level of the editorial brief, used to evaluate resource allocation and SLA adherence for high-priority content."
    - name: "sport_discipline"
      expr: sport_discipline
      comment: "Sport or discipline the brief covers, enabling editorial investment analysis by sport vertical."
    - name: "language_code"
      expr: language_code
      comment: "Language of the editorial content, used for localisation coverage and international editorial investment analysis."
    - name: "exclusivity_flag"
      expr: exclusivity_flag
      comment: "Flags exclusive editorial briefs, used to track premium exclusive content commissioning volume."
    - name: "branded_content_flag"
      expr: branded_content_flag
      comment: "Identifies branded/sponsored editorial briefs, enabling separate tracking of commercial content commissioning."
    - name: "ugc_sourced_flag"
      expr: ugc_sourced_flag
      comment: "Flags briefs sourced from user-generated content, which carry different rights and moderation obligations."
    - name: "commissioned_month"
      expr: DATE_TRUNC('month', commissioned_timestamp)
      comment: "Month the brief was commissioned, used for monthly editorial commissioning volume trending."
    - name: "published_month"
      expr: DATE_TRUNC('month', published_timestamp)
      comment: "Month the brief content was published, used for editorial output velocity analysis."
  measures:
    - name: "total_editorial_briefs"
      expr: COUNT(1)
      comment: "Total number of editorial briefs commissioned. Baseline KPI for editorial pipeline volume and commissioning activity."
    - name: "approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN approval_status = 'approved' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of editorial briefs that received approval. Measures editorial quality gate effectiveness and commissioning success rate."
    - name: "cancellation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN brief_status = 'cancelled' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of editorial briefs that were cancelled. High cancellation rates signal commissioning inefficiency or resource misalignment."
    - name: "published_brief_count"
      expr: COUNT(CASE WHEN published_timestamp IS NOT NULL THEN 1 END)
      comment: "Number of editorial briefs that reached publication. Measures actual editorial output versus commissioning volume."
    - name: "publication_to_commissioning_ratio"
      expr: ROUND(COUNT(CASE WHEN published_timestamp IS NOT NULL THEN 1 END) * 1.0 / NULLIF(COUNT(1), 0), 4)
      comment: "Ratio of published briefs to total commissioned briefs. Measures editorial pipeline conversion efficiency — a low ratio indicates high waste in the commissioning process."
    - name: "embargoed_brief_count"
      expr: COUNT(CASE WHEN embargo_timestamp IS NOT NULL THEN 1 END)
      comment: "Number of briefs with an active embargo. Tracks the volume of time-sensitive content requiring embargo management and compliance."
    - name: "exclusive_brief_count"
      expr: COUNT(CASE WHEN exclusivity_flag = TRUE THEN 1 END)
      comment: "Number of exclusive editorial briefs. Tracks premium exclusive content commissioning volume, which drives competitive differentiation."
    - name: "branded_content_brief_count"
      expr: COUNT(CASE WHEN branded_content_flag = TRUE THEN 1 END)
      comment: "Number of branded/sponsored editorial briefs. Directly linked to sponsorship revenue — tracks commercial content pipeline volume."
    - name: "on_time_publication_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN published_timestamp <= publication_deadline THEN 1 END) / NULLIF(COUNT(CASE WHEN published_timestamp IS NOT NULL AND publication_deadline IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of published briefs delivered on or before the publication deadline. A primary editorial SLA KPI — low values indicate pipeline bottlenecks."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`content_collection`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Content collection curation and monetisation KPIs measuring collection volume, PPV pricing, curation method mix, and publication status. Used by Content Strategy and Revenue teams to evaluate curated content portfolio performance."
  source: "`sports_entertainment_ecm`.`content`.`collection`"
  dimensions:
    - name: "collection_type"
      expr: collection_type
      comment: "Type of content collection (e.g. playlist, series, highlight reel) for portfolio segmentation and strategy analysis."
    - name: "publish_status"
      expr: publish_status
      comment: "Publication status of the collection (e.g. published, draft, archived) for active catalogue health monitoring."
    - name: "moderation_status"
      expr: moderation_status
      comment: "Content moderation outcome for the collection, used to track compliance with content standards at the collection level."
    - name: "curation_method"
      expr: curation_method
      comment: "Method used to curate the collection (e.g. editorial, algorithmic, fan-voted) for curation strategy effectiveness analysis."
    - name: "is_featured"
      expr: is_featured
      comment: "Flags featured collections, used to track premium editorial placement and its impact on content performance."
    - name: "is_ppv"
      expr: is_ppv
      comment: "Identifies pay-per-view collections, used to track premium monetisation inventory at the collection level."
    - name: "is_ugc"
      expr: is_ugc
      comment: "Flags user-generated content collections, which carry different rights and moderation obligations."
    - name: "language_code"
      expr: language_code
      comment: "Language of the collection, used for localisation coverage and international content strategy analysis."
    - name: "primary_content_format"
      expr: primary_content_format
      comment: "Primary content format of the collection (e.g. video, audio, mixed) for format strategy analysis."
    - name: "published_month"
      expr: DATE_TRUNC('month', published_timestamp)
      comment: "Month the collection was published, used for monthly content catalogue growth trending."
  measures:
    - name: "total_collections"
      expr: COUNT(1)
      comment: "Total number of content collections. Baseline KPI for curated content catalogue scale."
    - name: "published_collection_count"
      expr: COUNT(CASE WHEN publish_status = 'published' THEN 1 END)
      comment: "Number of actively published collections. Measures the live curated content catalogue available to audiences."
    - name: "ppv_collection_count"
      expr: COUNT(CASE WHEN is_ppv = TRUE THEN 1 END)
      comment: "Number of pay-per-view collections. Tracks premium monetisation inventory at the collection level for revenue planning."
    - name: "avg_ppv_price"
      expr: ROUND(AVG(CASE WHEN is_ppv = TRUE THEN CAST(ppv_price AS DOUBLE) END), 2)
      comment: "Average PPV price across pay-per-view collections. Benchmarks PPV pricing strategy and informs premium content pricing decisions."
    - name: "total_ppv_price_value"
      expr: ROUND(SUM(CASE WHEN is_ppv = TRUE THEN CAST(ppv_price AS DOUBLE) ELSE 0 END), 2)
      comment: "Total face value of PPV collection prices. Represents the maximum addressable PPV revenue from the current collection catalogue."
    - name: "featured_collection_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_featured = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of collections that are featured. Measures editorial curation intensity and premium placement coverage."
    - name: "ugc_collection_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_ugc = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of collections sourced from user-generated content. Tracks UGC contribution to the curated catalogue and associated rights risk exposure."
$$;