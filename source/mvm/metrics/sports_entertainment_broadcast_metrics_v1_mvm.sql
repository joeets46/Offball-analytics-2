-- Metric views for domain: broadcast | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_audience_rating`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Audience measurement KPIs covering viewership volume, demographic reach, ratings performance, and advertising yield. Used by broadcast strategy, ad sales, and programming executives to evaluate content performance and audience monetization."
  source: "`sports_entertainment_ecm`.`broadcast`.`audience_rating`"
  dimensions:
    - name: "broadcast_date"
      expr: broadcast_date
      comment: "Date of the broadcast event, used for time-series trending of audience metrics."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport category (e.g., football, basketball) enabling cross-sport audience comparison."
    - name: "content_genre"
      expr: content_genre
      comment: "Genre classification of the broadcast content for programming performance analysis."
    - name: "rating_type"
      expr: rating_type
      comment: "Type of audience rating measurement (e.g., overnight, consolidated) for methodology-aware analysis."
    - name: "market_name"
      expr: market_name
      comment: "Geographic market name enabling regional audience performance comparison."
    - name: "territory_code"
      expr: territory_code
      comment: "Territory or country code for international audience distribution analysis."
    - name: "demo_age_band"
      expr: demo_age_band
      comment: "Demographic age band (e.g., 18-34, 35-49) for targeted audience segment analysis."
    - name: "demo_gender"
      expr: demo_gender
      comment: "Demographic gender classification for audience composition analysis."
    - name: "reporting_period_type"
      expr: reporting_period_type
      comment: "Reporting period granularity (e.g., weekly, monthly) for consistent period-over-period comparison."
    - name: "measurement_source"
      expr: measurement_source
      comment: "Source of audience measurement data (e.g., Nielsen, Comscore) for methodology transparency."
    - name: "guarantee_met"
      expr: guarantee_met
      comment: "Boolean flag indicating whether the audience guarantee target was met, critical for ad sales accountability."
    - name: "blackout_applied"
      expr: blackout_applied
      comment: "Boolean flag indicating whether a blackout restriction was applied, affecting viewership counts."
  measures:
    - name: "total_viewers"
      expr: SUM(CAST(total_viewers AS DOUBLE))
      comment: "Total cumulative viewers across all audience rating records. Primary top-line viewership KPI used by programming and ad sales executives."
    - name: "total_live_viewers"
      expr: SUM(CAST(live_viewers AS DOUBLE))
      comment: "Total live (real-time) viewers. Indicates the strength of live broadcast appeal versus time-shifted consumption."
    - name: "total_time_shifted_viewers"
      expr: SUM(CAST(time_shifted_viewers AS DOUBLE))
      comment: "Total viewers who watched on a delayed/DVR basis. Informs content replay and catch-up rights strategy."
    - name: "peak_concurrent_viewers"
      expr: MAX(peak_concurrent_viewers)
      comment: "Maximum peak concurrent viewers across all records in the selection. Drives CDN capacity planning and premium ad slot pricing."
    - name: "avg_viewing_duration_mins"
      expr: AVG(CAST(avg_viewing_duration_mins AS DOUBLE))
      comment: "Average viewing duration in minutes per audience record. Measures content stickiness and engagement depth."
    - name: "avg_rating_pct"
      expr: AVG(CAST(rating_pct AS DOUBLE))
      comment: "Average audience rating percentage (share of universe). Core broadcast performance KPI used in programming decisions and rights valuations."
    - name: "avg_share_pct"
      expr: AVG(CAST(share_pct AS DOUBLE))
      comment: "Average audience share percentage (share of viewing universe). Measures competitive position against other programming in the same time slot."
    - name: "avg_grp_value"
      expr: AVG(CAST(grp_value AS DOUBLE))
      comment: "Average Gross Rating Points (GRP) value. Key advertising effectiveness metric used by ad sales to price and guarantee campaigns."
    - name: "total_demo_viewers"
      expr: SUM(CAST(demo_viewers_count AS DOUBLE))
      comment: "Total viewers within the targeted demographic segment. Directly drives advertising CPM rates and campaign delivery."
    - name: "total_reach"
      expr: SUM(CAST(reach AS DOUBLE))
      comment: "Total unduplicated audience reach. Measures the breadth of audience exposure for rights valuation and sponsor reporting."
    - name: "avg_cpm_rate"
      expr: AVG(CAST(cpm_rate AS DOUBLE))
      comment: "Average cost per thousand impressions (CPM). Advertising yield metric used by ad sales to benchmark pricing and negotiate deals."
    - name: "total_audience_guarantee_target"
      expr: SUM(CAST(audience_guarantee_target AS DOUBLE))
      comment: "Total contracted audience guarantee targets across all deals. Used to track aggregate ad sales commitments against delivery."
    - name: "guarantee_met_count"
      expr: SUM(CASE WHEN guarantee_met = TRUE THEN 1 ELSE 0 END)
      comment: "Count of audience rating records where the guarantee target was met. Numerator for guarantee fulfillment rate calculation."
    - name: "total_rating_records"
      expr: COUNT(1)
      comment: "Total number of audience rating measurement records. Denominator for guarantee fulfillment rate and other ratio KPIs."
    - name: "total_ama_viewers"
      expr: SUM(CAST(ama_viewers AS DOUBLE))
      comment: "Total Average Minute Audience (AMA) viewers. Industry-standard metric for comparing content performance across different durations."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_media_rights_deal`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Media rights deal financial and commercial KPIs covering deal value, rights fee economics, revenue share, and deal portfolio composition. Used by rights acquisition, finance, and executive leadership to manage the broadcast rights portfolio."
  source: "`sports_entertainment_ecm`.`broadcast`.`media_rights_deal`"
  dimensions:
    - name: "deal_status"
      expr: deal_status
      comment: "Current status of the media rights deal (e.g., active, expired, negotiating) for portfolio health monitoring."
    - name: "deal_type"
      expr: deal_type
      comment: "Type of media rights deal (e.g., exclusive, non-exclusive, sublicense) for deal structure analysis."
    - name: "territory_code"
      expr: territory_code
      comment: "Territory covered by the deal for geographic rights portfolio analysis."
    - name: "territory_scope"
      expr: territory_scope
      comment: "Scope of territorial coverage (e.g., national, regional, global) for rights footprint analysis."
    - name: "exclusivity_type"
      expr: exclusivity_type
      comment: "Exclusivity classification of the deal (e.g., exclusive, non-exclusive) affecting deal premium and competitive positioning."
    - name: "sport_name"
      expr: sport_name
      comment: "Sport covered by the rights deal for sport-level portfolio and investment analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the deal for multi-currency financial consolidation."
    - name: "payment_schedule_type"
      expr: payment_schedule_type
      comment: "Payment schedule structure (e.g., annual, quarterly) for cash flow planning."
    - name: "live_rights_included"
      expr: live_rights_included
      comment: "Boolean flag indicating whether live broadcast rights are included, a key value driver in rights deals."
    - name: "digital_streaming_rights_included"
      expr: digital_streaming_rights_included
      comment: "Boolean flag indicating whether digital/OTT streaming rights are included, reflecting digital transformation of rights portfolios."
    - name: "highlights_rights_included"
      expr: highlights_rights_included
      comment: "Boolean flag indicating whether highlights rights are included, relevant for social and digital distribution strategy."
    - name: "renewal_option_type"
      expr: renewal_option_type
      comment: "Type of renewal option in the deal for long-term rights portfolio planning."
  measures:
    - name: "total_deal_value_usd"
      expr: SUM(CAST(deal_value_usd AS DOUBLE))
      comment: "Total contracted deal value in USD across all media rights deals. Primary financial KPI for rights portfolio investment tracking."
    - name: "total_annual_rights_fee_usd"
      expr: SUM(CAST(annual_rights_fee_usd AS DOUBLE))
      comment: "Total annualized rights fee obligations in USD. Used for annual budget planning and cash flow forecasting."
    - name: "avg_deal_value_usd"
      expr: AVG(CAST(deal_value_usd AS DOUBLE))
      comment: "Average deal value in USD. Benchmarks deal size and informs negotiation strategy for new rights acquisitions."
    - name: "avg_annual_rights_fee_usd"
      expr: AVG(CAST(annual_rights_fee_usd AS DOUBLE))
      comment: "Average annual rights fee per deal. Used to compare deal economics across sports, territories, and deal types."
    - name: "avg_revenue_share_pct"
      expr: AVG(CAST(revenue_share_pct AS DOUBLE))
      comment: "Average revenue share percentage across deals. Measures the proportion of broadcast revenue returned to rights holders."
    - name: "active_deal_count"
      expr: SUM(CASE WHEN deal_status = 'active' THEN 1 ELSE 0 END)
      comment: "Count of currently active media rights deals. Indicates the size of the live rights portfolio."
    - name: "total_deal_count"
      expr: COUNT(1)
      comment: "Total number of media rights deal records. Denominator for active deal rate and portfolio composition ratios."
    - name: "deals_with_digital_streaming"
      expr: SUM(CASE WHEN digital_streaming_rights_included = TRUE THEN 1 ELSE 0 END)
      comment: "Count of deals that include digital streaming rights. Tracks digital rights penetration across the portfolio, a strategic priority."
    - name: "deals_with_live_rights"
      expr: SUM(CASE WHEN live_rights_included = TRUE THEN 1 ELSE 0 END)
      comment: "Count of deals that include live broadcast rights. Live rights are the highest-value component of any broadcast deal."
    - name: "exclusive_deal_count"
      expr: SUM(CASE WHEN exclusivity_type = 'exclusive' THEN 1 ELSE 0 END)
      comment: "Count of exclusive rights deals. Exclusivity drives premium pricing and competitive differentiation."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_streaming_subscription`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Streaming subscription KPIs covering subscriber base, revenue, churn, and plan economics. Used by digital media, finance, and executive leadership to manage the direct-to-consumer streaming business."
  source: "`sports_entertainment_ecm`.`broadcast`.`streaming_subscription`"
  dimensions:
    - name: "subscription_status"
      expr: subscription_status
      comment: "Current status of the subscription (e.g., active, cancelled, suspended) for subscriber lifecycle analysis."
    - name: "plan_tier"
      expr: plan_tier
      comment: "Subscription plan tier (e.g., basic, premium, ultimate) for revenue mix and upsell analysis."
    - name: "billing_cycle"
      expr: billing_cycle
      comment: "Billing frequency (e.g., monthly, annual) for revenue recognition and cash flow planning."
    - name: "geo_country_code"
      expr: geo_country_code
      comment: "Subscriber country code for geographic market penetration and revenue analysis."
    - name: "acquisition_channel"
      expr: acquisition_channel
      comment: "Channel through which the subscriber was acquired (e.g., organic, paid, partner) for marketing ROI analysis."
    - name: "service_type"
      expr: service_type
      comment: "Type of streaming service (e.g., live, VOD, hybrid) for product mix analysis."
    - name: "auto_renewal_flag"
      expr: auto_renewal_flag
      comment: "Boolean flag indicating auto-renewal enrollment, a leading indicator of subscriber retention."
    - name: "trial_flag"
      expr: trial_flag
      comment: "Boolean flag indicating trial subscriptions for conversion funnel analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Billing currency for multi-currency revenue consolidation."
    - name: "cancellation_reason"
      expr: cancellation_reason
      comment: "Reason provided for subscription cancellation, used to identify and address churn drivers."
    - name: "start_date"
      expr: start_date
      comment: "Subscription start date for cohort analysis and subscriber tenure tracking."
  measures:
    - name: "total_subscription_revenue"
      expr: SUM(CAST(subscription_charge AS DOUBLE))
      comment: "Total subscription revenue across all records. Primary top-line revenue KPI for the streaming business."
    - name: "avg_subscription_charge"
      expr: AVG(CAST(subscription_charge AS DOUBLE))
      comment: "Average revenue per subscription (ARPU proxy). Measures monetization efficiency and plan mix impact on revenue."
    - name: "active_subscriber_count"
      expr: SUM(CASE WHEN subscription_status = 'active' THEN 1 ELSE 0 END)
      comment: "Count of currently active subscribers. Core subscriber base KPI used in all streaming business reviews."
    - name: "total_subscription_count"
      expr: COUNT(1)
      comment: "Total subscription records including all statuses. Denominator for churn rate and other ratio KPIs."
    - name: "cancelled_subscriber_count"
      expr: SUM(CASE WHEN subscription_status = 'cancelled' THEN 1 ELSE 0 END)
      comment: "Count of cancelled subscriptions. Numerator for churn rate calculation and retention strategy evaluation."
    - name: "trial_subscriber_count"
      expr: SUM(CASE WHEN trial_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Count of trial subscriptions. Measures top-of-funnel acquisition volume and conversion pipeline."
    - name: "auto_renewal_enrolled_count"
      expr: SUM(CASE WHEN auto_renewal_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Count of subscriptions enrolled in auto-renewal. Leading indicator of subscriber retention and recurring revenue stability."
    - name: "total_promotional_revenue"
      expr: SUM(CAST(promotional_rate AS DOUBLE))
      comment: "Total promotional/discounted rate value applied across subscriptions. Measures the revenue impact of promotional pricing strategies."
    - name: "avg_promotional_rate"
      expr: AVG(CAST(promotional_rate AS DOUBLE))
      comment: "Average promotional discount rate applied. Used to evaluate the depth of discounting and its impact on ARPU."
    - name: "ppv_enabled_subscriber_count"
      expr: SUM(CASE WHEN ppv_access_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Count of subscribers with pay-per-view access enabled. Indicates the addressable audience for PPV event monetization."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Broadcast scheduling KPIs covering schedule volume, PPV programming, blackout exposure, and simulcast activity. Used by programming, operations, and rights management teams to optimize the broadcast calendar."
  source: "`sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`"
  dimensions:
    - name: "air_date"
      expr: air_date
      comment: "Scheduled air date of the broadcast for calendar-based programming analysis."
    - name: "broadcast_type"
      expr: broadcast_type
      comment: "Type of broadcast (e.g., live, replay, highlights) for programming mix analysis."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport type for cross-sport scheduling volume and resource allocation analysis."
    - name: "platform_type"
      expr: platform_type
      comment: "Distribution platform type (e.g., linear TV, OTT, cable) for multi-platform scheduling analysis."
    - name: "schedule_status"
      expr: schedule_status
      comment: "Current status of the schedule entry (e.g., confirmed, cancelled, postponed) for operational planning."
    - name: "region_code"
      expr: region_code
      comment: "Geographic region code for regional programming distribution analysis."
    - name: "language_code"
      expr: language_code
      comment: "Broadcast language code for multi-language programming strategy analysis."
    - name: "blackout_applicable"
      expr: blackout_applicable
      comment: "Boolean flag indicating whether blackout rules apply to this schedule entry, affecting distribution reach."
    - name: "ppv_event"
      expr: ppv_event
      comment: "Boolean flag indicating pay-per-view events for premium revenue programming analysis."
    - name: "simulcast_flag"
      expr: simulcast_flag
      comment: "Boolean flag indicating simultaneous multi-platform broadcast for reach amplification analysis."
    - name: "international_feed"
      expr: international_feed
      comment: "Boolean flag indicating international feed broadcasts for global distribution strategy analysis."
  measures:
    - name: "total_scheduled_broadcasts"
      expr: COUNT(1)
      comment: "Total number of scheduled broadcast entries. Baseline programming volume KPI for capacity and rights utilization planning."
    - name: "ppv_event_count"
      expr: SUM(CASE WHEN ppv_event = TRUE THEN 1 ELSE 0 END)
      comment: "Count of pay-per-view scheduled events. Measures premium event programming volume and PPV revenue opportunity pipeline."
    - name: "total_ppv_revenue_potential"
      expr: SUM(CAST(ppv_price AS DOUBLE))
      comment: "Total potential PPV revenue from scheduled PPV events at listed prices. Informs PPV revenue forecasting and event pricing strategy."
    - name: "avg_ppv_price"
      expr: AVG(CAST(ppv_price AS DOUBLE))
      comment: "Average PPV price across scheduled pay-per-view events. Benchmarks PPV pricing strategy and premium event monetization."
    - name: "simulcast_broadcast_count"
      expr: SUM(CASE WHEN simulcast_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Count of broadcasts distributed via simulcast across multiple platforms. Measures multi-platform reach amplification strategy execution."
    - name: "blackout_applicable_count"
      expr: SUM(CASE WHEN blackout_applicable = TRUE THEN 1 ELSE 0 END)
      comment: "Count of scheduled broadcasts subject to blackout restrictions. Quantifies the programming volume affected by territorial rights constraints."
    - name: "international_feed_count"
      expr: SUM(CASE WHEN international_feed = TRUE THEN 1 ELSE 0 END)
      comment: "Count of international feed broadcasts. Measures global distribution footprint and international rights utilization."
    - name: "confirmed_broadcast_count"
      expr: SUM(CASE WHEN schedule_status = 'confirmed' THEN 1 ELSE 0 END)
      comment: "Count of confirmed scheduled broadcasts. Operational readiness KPI for production and distribution planning."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_channel`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Channel portfolio KPIs covering subscriber reach, revenue economics, SLA performance, and channel capability mix. Used by distribution, finance, and technology leadership to manage the broadcast channel portfolio."
  source: "`sports_entertainment_ecm`.`broadcast`.`channel`"
  dimensions:
    - name: "channel_type"
      expr: channel_type
      comment: "Type of channel (e.g., linear, OTT, RSN) for portfolio segmentation and strategic analysis."
    - name: "channel_status"
      expr: channel_status
      comment: "Operational status of the channel (e.g., active, decommissioned) for portfolio health monitoring."
    - name: "platform_type"
      expr: platform_type
      comment: "Distribution platform type for multi-platform channel portfolio analysis."
    - name: "country_code"
      expr: country_code
      comment: "Country of channel operation for geographic distribution portfolio analysis."
    - name: "language_code"
      expr: language_code
      comment: "Primary broadcast language for multi-language channel portfolio analysis."
    - name: "signal_type"
      expr: signal_type
      comment: "Signal delivery type (e.g., satellite, cable, IP) for infrastructure and distribution cost analysis."
    - name: "resolution_tier"
      expr: resolution_tier
      comment: "Video resolution tier (e.g., SD, HD, 4K) for quality tier distribution and premium pricing analysis."
    - name: "ppv_enabled"
      expr: ppv_enabled
      comment: "Boolean flag indicating PPV capability for premium revenue channel identification."
    - name: "ad_insertion_enabled"
      expr: ad_insertion_enabled
      comment: "Boolean flag indicating dynamic ad insertion capability, a key driver of advertising revenue."
  measures:
    - name: "total_subscriber_count"
      expr: SUM(CAST(subscriber_count AS DOUBLE))
      comment: "Total subscribers across all channels. Primary reach KPI for distribution negotiations and advertising rate card pricing."
    - name: "avg_subscriber_count_per_channel"
      expr: AVG(CAST(subscriber_count AS DOUBLE))
      comment: "Average subscriber count per channel. Benchmarks channel reach and identifies under-performing distribution assets."
    - name: "total_monthly_rights_fee"
      expr: SUM(CAST(monthly_rights_fee AS DOUBLE))
      comment: "Total monthly rights fee obligations across all channels. Core cost KPI for channel portfolio financial management."
    - name: "avg_monthly_rights_fee"
      expr: AVG(CAST(monthly_rights_fee AS DOUBLE))
      comment: "Average monthly rights fee per channel. Used to benchmark channel cost efficiency and negotiate distribution agreements."
    - name: "avg_revenue_share_pct"
      expr: AVG(CAST(revenue_share_pct AS DOUBLE))
      comment: "Average revenue share percentage across channels. Measures the proportion of channel revenue shared with rights holders."
    - name: "avg_uptime_sla_pct"
      expr: AVG(CAST(uptime_sla_pct AS DOUBLE))
      comment: "Average uptime SLA percentage across channels. Operational quality KPI directly tied to distribution contract compliance and penalty risk."
    - name: "active_channel_count"
      expr: SUM(CASE WHEN channel_status = 'active' THEN 1 ELSE 0 END)
      comment: "Count of currently active channels. Measures the live distribution footprint of the broadcast portfolio."
    - name: "total_channel_count"
      expr: COUNT(1)
      comment: "Total number of channel records. Denominator for active channel rate and capability penetration ratios."
    - name: "ppv_enabled_channel_count"
      expr: SUM(CASE WHEN ppv_enabled = TRUE THEN 1 ELSE 0 END)
      comment: "Count of channels with PPV capability enabled. Measures the addressable infrastructure for premium event monetization."
    - name: "ad_insertion_enabled_channel_count"
      expr: SUM(CASE WHEN ad_insertion_enabled = TRUE THEN 1 ELSE 0 END)
      comment: "Count of channels with dynamic ad insertion enabled. Measures the advertising revenue-capable distribution footprint."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_rights_window`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Rights window KPIs covering rights fee economics, exclusivity, conflict exposure, and sublicensing activity. Used by rights management, legal, and finance teams to govern the broadcast rights window portfolio."
  source: "`sports_entertainment_ecm`.`broadcast`.`rights_window`"
  dimensions:
    - name: "window_status"
      expr: window_status
      comment: "Current status of the rights window (e.g., active, expired, pending) for portfolio lifecycle management."
    - name: "broadcast_window_type"
      expr: broadcast_window_type
      comment: "Type of broadcast window (e.g., live, replay, highlights) for rights category analysis."
    - name: "rights_category"
      expr: rights_category
      comment: "Category of rights covered (e.g., linear, digital, mobile) for rights portfolio composition analysis."
    - name: "territory_code"
      expr: territory_code
      comment: "Territory covered by the rights window for geographic rights portfolio analysis."
    - name: "territory_scope"
      expr: territory_scope
      comment: "Scope of territorial coverage for rights footprint analysis."
    - name: "exclusivity_flag"
      expr: exclusivity_flag
      comment: "Boolean flag indicating exclusive rights windows, which command premium fees and restrict competition."
    - name: "sublicensing_permitted"
      expr: sublicensing_permitted
      comment: "Boolean flag indicating whether sublicensing is permitted, enabling secondary revenue generation."
    - name: "rights_conflict_flag"
      expr: rights_conflict_flag
      comment: "Boolean flag indicating rights conflicts requiring resolution, a legal and operational risk indicator."
    - name: "blackout_applicable"
      expr: blackout_applicable
      comment: "Boolean flag indicating whether blackout rules apply to this rights window."
    - name: "content_type"
      expr: content_type
      comment: "Type of content covered by the rights window for content portfolio analysis."
    - name: "language_code"
      expr: language_code
      comment: "Language of the rights window for multi-language rights portfolio analysis."
  measures:
    - name: "total_rights_fee_amount"
      expr: SUM(CAST(rights_fee_amount AS DOUBLE))
      comment: "Total rights fee value across all windows. Primary financial KPI for rights window portfolio investment tracking."
    - name: "avg_rights_fee_amount"
      expr: AVG(CAST(rights_fee_amount AS DOUBLE))
      comment: "Average rights fee per window. Benchmarks window pricing and informs rights fee negotiation strategy."
    - name: "total_rights_fee_allocation_pct"
      expr: SUM(CAST(rights_fee_allocation_pct AS DOUBLE))
      comment: "Total rights fee allocation percentage across windows. Used to verify that fee allocations sum correctly across a deal portfolio."
    - name: "avg_revenue_share_pct"
      expr: AVG(CAST(revenue_share_pct AS DOUBLE))
      comment: "Average revenue share percentage across rights windows. Measures the proportion of broadcast revenue returned to rights holders per window."
    - name: "active_window_count"
      expr: SUM(CASE WHEN window_status = 'active' THEN 1 ELSE 0 END)
      comment: "Count of currently active rights windows. Measures the live rights portfolio size and distribution coverage."
    - name: "total_window_count"
      expr: COUNT(1)
      comment: "Total number of rights window records. Denominator for conflict rate, exclusivity rate, and other ratio KPIs."
    - name: "exclusive_window_count"
      expr: SUM(CASE WHEN exclusivity_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Count of exclusive rights windows. Exclusivity is the primary value driver in rights deals and a competitive moat indicator."
    - name: "rights_conflict_count"
      expr: SUM(CASE WHEN rights_conflict_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Count of rights windows with active conflicts. Legal and operational risk KPI requiring executive attention and resolution."
    - name: "sublicensing_permitted_count"
      expr: SUM(CASE WHEN sublicensing_permitted = TRUE THEN 1 ELSE 0 END)
      comment: "Count of rights windows where sublicensing is permitted. Measures the secondary revenue generation opportunity within the rights portfolio."
    - name: "blackout_applicable_window_count"
      expr: SUM(CASE WHEN blackout_applicable = TRUE THEN 1 ELSE 0 END)
      comment: "Count of rights windows subject to blackout restrictions. Quantifies the territorial distribution constraints across the rights portfolio."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_live_feed`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Live feed operational KPIs covering feed reliability, failover incidents, distribution capability, and technical quality. Used by broadcast operations and technology leadership to ensure live broadcast delivery excellence."
  source: "`sports_entertainment_ecm`.`broadcast`.`live_feed`"
  dimensions:
    - name: "feed_status"
      expr: feed_status
      comment: "Current operational status of the live feed (e.g., live, standby, failed) for real-time operations monitoring."
    - name: "feed_type"
      expr: feed_type
      comment: "Type of live feed (e.g., primary, backup, international) for feed portfolio analysis."
    - name: "distribution_tier"
      expr: distribution_tier
      comment: "Distribution tier of the feed (e.g., premium, standard) for quality-tier analysis."
    - name: "signal_type"
      expr: signal_type
      comment: "Signal delivery type for infrastructure and technology analysis."
    - name: "encoding_format"
      expr: encoding_format
      comment: "Video encoding format for technical standards compliance and quality analysis."
    - name: "latency_mode"
      expr: latency_mode
      comment: "Latency mode (e.g., ultra-low, low, standard) for live experience quality analysis."
    - name: "production_region"
      expr: production_region
      comment: "Geographic region of production for operational resource and infrastructure analysis."
    - name: "is_ott_enabled"
      expr: is_ott_enabled
      comment: "Boolean flag indicating OTT distribution capability for digital platform reach analysis."
    - name: "is_ppv"
      expr: is_ppv
      comment: "Boolean flag indicating pay-per-view feeds for premium event operational analysis."
    - name: "failover_activated"
      expr: failover_activated
      comment: "Boolean flag indicating whether failover was activated, a key broadcast reliability incident indicator."
    - name: "replay_enabled"
      expr: replay_enabled
      comment: "Boolean flag indicating replay availability for catch-up content strategy analysis."
  measures:
    - name: "total_live_feeds"
      expr: COUNT(1)
      comment: "Total number of live feed records. Baseline operational volume KPI for broadcast operations capacity planning."
    - name: "failover_incident_count"
      expr: SUM(CASE WHEN failover_activated = TRUE THEN 1 ELSE 0 END)
      comment: "Count of live feeds where failover was activated. Primary broadcast reliability KPI — high failover rates indicate infrastructure risk and SLA breach exposure."
    - name: "avg_frame_rate"
      expr: AVG(CAST(frame_rate AS DOUBLE))
      comment: "Average frame rate across live feeds. Technical quality KPI ensuring broadcast standards compliance and viewer experience quality."
    - name: "ott_enabled_feed_count"
      expr: SUM(CASE WHEN is_ott_enabled = TRUE THEN 1 ELSE 0 END)
      comment: "Count of live feeds with OTT distribution enabled. Measures digital streaming reach capability across the live broadcast portfolio."
    - name: "ppv_feed_count"
      expr: SUM(CASE WHEN is_ppv = TRUE THEN 1 ELSE 0 END)
      comment: "Count of pay-per-view live feeds. Measures premium event broadcast volume and PPV infrastructure utilization."
    - name: "replay_enabled_feed_count"
      expr: SUM(CASE WHEN replay_enabled = TRUE THEN 1 ELSE 0 END)
      comment: "Count of live feeds with replay enabled. Measures catch-up content availability and replay rights utilization."
    - name: "linear_tv_enabled_feed_count"
      expr: SUM(CASE WHEN is_linear_tv_enabled = TRUE THEN 1 ELSE 0 END)
      comment: "Count of live feeds enabled for linear TV distribution. Measures traditional broadcast reach alongside digital channels."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`broadcast_media_asset`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Media asset library KPIs covering asset volume, storage economics, rights expiry risk, and content quality. Used by content operations, rights management, and finance to manage the broadcast media asset portfolio."
  source: "`sports_entertainment_ecm`.`broadcast`.`media_asset`"
  dimensions:
    - name: "asset_type"
      expr: asset_type
      comment: "Type of media asset (e.g., live recording, highlight, replay) for content portfolio composition analysis."
    - name: "asset_status"
      expr: asset_status
      comment: "Current status of the media asset (e.g., active, archived, expired) for asset lifecycle management."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport type associated with the asset for sport-level content portfolio analysis."
    - name: "broadcast_date"
      expr: broadcast_date
      comment: "Original broadcast date of the asset for content age and rights window analysis."
    - name: "rights_expiry_date"
      expr: rights_expiry_date
      comment: "Date when rights to the asset expire, critical for rights compliance and content availability planning."
    - name: "archive_tier"
      expr: archive_tier
      comment: "Storage archive tier (e.g., hot, warm, cold) for storage cost optimization analysis."
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel for the asset for multi-platform content distribution analysis."
    - name: "format"
      expr: format
      comment: "File format of the media asset for technical standards and compatibility analysis."
    - name: "is_live_recording"
      expr: is_live_recording
      comment: "Boolean flag indicating live event recordings, the highest-value asset category."
    - name: "ppv_eligible"
      expr: ppv_eligible
      comment: "Boolean flag indicating PPV-eligible assets for premium content monetization analysis."
    - name: "blackout_rule_applicable"
      expr: blackout_rule_applicable
      comment: "Boolean flag indicating assets subject to blackout rules for rights compliance monitoring."
  measures:
    - name: "total_asset_count"
      expr: COUNT(1)
      comment: "Total number of media assets in the library. Baseline content portfolio size KPI for rights utilization and archive management."
    - name: "total_file_size_mb"
      expr: SUM(CAST(file_size_mb AS DOUBLE))
      comment: "Total storage footprint of media assets in megabytes. Drives storage infrastructure investment and archive cost management decisions."
    - name: "avg_file_size_mb"
      expr: AVG(CAST(file_size_mb AS DOUBLE))
      comment: "Average file size per media asset. Used to benchmark encoding efficiency and forecast storage growth."
    - name: "avg_frame_rate"
      expr: AVG(CAST(frame_rate AS DOUBLE))
      comment: "Average frame rate across media assets. Technical quality KPI for content standards compliance and viewer experience."
    - name: "live_recording_count"
      expr: SUM(CASE WHEN is_live_recording = TRUE THEN 1 ELSE 0 END)
      comment: "Count of live event recording assets. Live recordings are the highest-value content category in the broadcast library."
    - name: "ppv_eligible_asset_count"
      expr: SUM(CASE WHEN ppv_eligible = TRUE THEN 1 ELSE 0 END)
      comment: "Count of PPV-eligible media assets. Measures the premium content monetization inventory available for PPV distribution."
    - name: "blackout_restricted_asset_count"
      expr: SUM(CASE WHEN blackout_rule_applicable = TRUE THEN 1 ELSE 0 END)
      comment: "Count of assets subject to blackout restrictions. Quantifies the content distribution constraints requiring rights compliance management."
$$;