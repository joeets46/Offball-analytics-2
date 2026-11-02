-- Metric views for domain: fan | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_profile`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core fan base health and composition metrics derived from the fan profile master entity. Tracks fan acquisition, loyalty enrollment penetration, VIP and season-ticket holder rates, and communication opt-in coverage — all critical inputs for CRM strategy, segmentation investment, and fan lifetime value programs."
  source: "`sports_entertainment_ecm`.`fan`.`fan_profile`"
  dimensions:
    - name: "fan_type"
      expr: fan_type
      comment: "Classifies fans by type (e.g. casual, core, super-fan) for cohort-level analysis."
    - name: "loyalty_tier"
      expr: loyalty_tier
      comment: "Current loyalty tier of the fan, enabling tier-based performance benchmarking."
    - name: "registration_channel"
      expr: registration_channel
      comment: "Channel through which the fan registered (e.g. app, web, in-venue), used to evaluate acquisition channel effectiveness."
    - name: "country_of_residence_code"
      expr: country_of_residence_code
      comment: "Fan's country of residence for geographic market analysis and regulatory scoping."
    - name: "preferred_sport"
      expr: preferred_sport
      comment: "Fan's declared preferred sport, used for content personalisation and campaign targeting."
    - name: "gender"
      expr: gender
      comment: "Fan gender dimension for demographic audience analysis."
    - name: "account_status"
      expr: account_status
      comment: "Current status of the fan profile account (e.g. active, suspended, churned)."
    - name: "registration_year_month"
      expr: DATE_TRUNC('MONTH', registration_date)
      comment: "Month of fan registration for cohort and acquisition trend analysis."
    - name: "preferred_language_code"
      expr: preferred_language_code
      comment: "Fan's preferred language, used for localisation and communication strategy."
  measures:
    - name: "total_registered_fans"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Total number of unique registered fan profiles. Baseline KPI for fan base size and growth tracking."
    - name: "loyalty_enrolled_fans"
      expr: COUNT(DISTINCT CASE WHEN loyalty_enrollment_date IS NOT NULL THEN fan_profile_id END)
      comment: "Number of fans who have enrolled in a loyalty program. Measures loyalty program penetration across the fan base."
    - name: "loyalty_enrollment_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN loyalty_enrollment_date IS NOT NULL THEN fan_profile_id END) / NULLIF(COUNT(DISTINCT fan_profile_id), 0), 2)
      comment: "Percentage of registered fans enrolled in a loyalty program. Key indicator of loyalty program reach and fan engagement depth."
    - name: "season_ticket_holder_fans"
      expr: COUNT(DISTINCT CASE WHEN is_season_ticket_holder = TRUE THEN fan_profile_id END)
      comment: "Number of fans who are season ticket holders. Directly tied to recurring ticket revenue and high-value fan retention."
    - name: "season_ticket_holder_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_season_ticket_holder = TRUE THEN fan_profile_id END) / NULLIF(COUNT(DISTINCT fan_profile_id), 0), 2)
      comment: "Percentage of fans who hold season tickets. Tracks conversion of general fans into committed, high-value season ticket holders."
    - name: "vip_member_fans"
      expr: COUNT(DISTINCT CASE WHEN is_vip_member = TRUE THEN fan_profile_id END)
      comment: "Number of fans with VIP membership status. Tracks the premium fan segment critical for hospitality and sponsorship activation."
    - name: "email_opt_in_fans"
      expr: COUNT(DISTINCT CASE WHEN communication_opt_in_email = TRUE THEN fan_profile_id END)
      comment: "Number of fans opted into email communications. Determines the reachable audience for email marketing campaigns."
    - name: "email_opt_in_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN communication_opt_in_email = TRUE THEN fan_profile_id END) / NULLIF(COUNT(DISTINCT fan_profile_id), 0), 2)
      comment: "Percentage of fans opted into email. Governs email campaign reach and informs consent-driven marketing investment decisions."
    - name: "push_opt_in_fans"
      expr: COUNT(DISTINCT CASE WHEN communication_opt_in_push = TRUE THEN fan_profile_id END)
      comment: "Number of fans opted into push notifications. Measures mobile engagement channel reach for real-time fan activation."
    - name: "data_sharing_consent_fans"
      expr: COUNT(DISTINCT CASE WHEN data_sharing_consent = TRUE THEN fan_profile_id END)
      comment: "Number of fans who have granted data sharing consent. Critical compliance and data monetisation metric for partnership and analytics programs."
    - name: "data_sharing_consent_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN data_sharing_consent = TRUE THEN fan_profile_id END) / NULLIF(COUNT(DISTINCT fan_profile_id), 0), 2)
      comment: "Percentage of fans with active data sharing consent. Governs the addressable audience for data-driven sponsorship and personalisation programs."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_engagement_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fan engagement activity metrics measuring volume, depth, and quality of fan interactions across all channels and touchpoints. Drives decisions on content investment, channel mix, loyalty point economics, and in-venue vs. digital engagement strategy."
  source: "`sports_entertainment_ecm`.`fan`.`engagement_event`"
  dimensions:
    - name: "engagement_type"
      expr: engagement_type
      comment: "Type of engagement action (e.g. video view, purchase, social share, check-in) for activity-level analysis."
    - name: "engagement_channel"
      expr: engagement_channel
      comment: "Channel through which the engagement occurred (e.g. app, web, in-venue, broadcast) for channel mix optimisation."
    - name: "engagement_status"
      expr: engagement_status
      comment: "Status of the engagement event (e.g. completed, abandoned) to measure completion quality."
    - name: "device_type"
      expr: device_type
      comment: "Device used during the engagement event for platform investment and UX decisions."
    - name: "geo_country_code"
      expr: geo_country_code
      comment: "Country where the engagement occurred for geographic market performance analysis."
    - name: "social_platform"
      expr: social_platform
      comment: "Social media platform associated with the engagement event for social channel ROI analysis."
    - name: "engagement_date_month"
      expr: DATE_TRUNC('MONTH', engagement_date)
      comment: "Month of engagement for trend and seasonality analysis."
    - name: "is_authenticated"
      expr: is_authenticated
      comment: "Whether the fan was authenticated during the engagement, distinguishing known vs. anonymous interactions."
    - name: "referral_source"
      expr: referral_source
      comment: "Source that drove the fan to the engagement event, used for attribution and acquisition channel analysis."
    - name: "device_os"
      expr: device_os
      comment: "Operating system of the device used, informing platform-specific product investment decisions."
  measures:
    - name: "total_engagement_events"
      expr: COUNT(1)
      comment: "Total number of fan engagement events. Baseline volume metric for fan activity and platform health."
    - name: "unique_engaged_fans"
      expr: COUNT(DISTINCT primary_engagement_fixture_id)
      comment: "Proxy for unique fixture-level engagement breadth. Use alongside fan_profile joins at BI layer for full unique fan counts."
    - name: "total_engagement_value_score"
      expr: SUM(CAST(engagement_value_score AS DOUBLE))
      comment: "Sum of engagement value scores across all events. Composite KPI reflecting the total quality-weighted fan engagement output, used to prioritise channel and content investment."
    - name: "avg_engagement_value_score"
      expr: AVG(CAST(engagement_value_score AS DOUBLE))
      comment: "Average engagement value score per event. Measures the quality of individual fan interactions; declining averages signal content or experience degradation."
    - name: "avg_content_progress_pct"
      expr: AVG(CAST(content_progress_pct AS DOUBLE))
      comment: "Average percentage of content consumed per engagement event. Measures content completion depth — a key indicator of content quality and fan interest."
    - name: "authenticated_engagement_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_authenticated = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of engagement events from authenticated (known) fans. Higher rates improve personalisation capability and data asset quality."
    - name: "consent_analytics_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN consent_analytics = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of engagement events where analytics consent was granted. Governs the proportion of engagement data usable for analytics and personalisation under privacy regulations."
    - name: "consent_marketing_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN consent_marketing = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of engagement events where marketing consent was granted. Determines the addressable audience for retargeting and campaign activation from engagement data."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_loyalty_enrollment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Loyalty program enrollment health and tier economics metrics. Tracks enrollment volume, tier distribution, points accumulation, and churn signals — essential for loyalty program ROI, tier structure optimisation, and fan retention investment decisions."
  source: "`sports_entertainment_ecm`.`fan`.`loyalty_enrollment`"
  dimensions:
    - name: "current_tier"
      expr: current_tier
      comment: "Current loyalty tier of the enrolled fan (e.g. Bronze, Silver, Gold, Platinum) for tier-level performance analysis."
    - name: "enrollment_channel"
      expr: enrollment_channel
      comment: "Channel through which the fan enrolled in the loyalty program, used to evaluate enrollment channel effectiveness."
    - name: "enrollment_status"
      expr: enrollment_status
      comment: "Current status of the loyalty enrollment (e.g. active, terminated, suspended) for churn and retention analysis."
    - name: "previous_tier"
      expr: previous_tier
      comment: "Previous loyalty tier before the most recent tier change, enabling tier upgrade/downgrade flow analysis."
    - name: "preferred_reward_category"
      expr: preferred_reward_category
      comment: "Fan's preferred reward category (e.g. tickets, merchandise, experiences) for reward portfolio optimisation."
    - name: "enrollment_year_month"
      expr: DATE_TRUNC('MONTH', enrollment_date)
      comment: "Month of enrollment for cohort and acquisition trend analysis."
    - name: "auto_renewal_enabled"
      expr: auto_renewal_enabled
      comment: "Whether auto-renewal is enabled for the enrollment, a leading indicator of retention risk."
    - name: "is_primary_enrollment"
      expr: is_primary_enrollment
      comment: "Flags whether this is the fan's primary loyalty enrollment, used to deduplicate multi-program analysis."
    - name: "vip_status"
      expr: vip_status
      comment: "VIP status flag on the enrollment record for premium segment analysis."
  measures:
    - name: "total_active_enrollments"
      expr: COUNT(DISTINCT CASE WHEN enrollment_status = 'active' THEN loyalty_enrollment_id END)
      comment: "Total number of active loyalty program enrollments. Primary KPI for loyalty program scale and health."
    - name: "total_enrollments"
      expr: COUNT(DISTINCT loyalty_enrollment_id)
      comment: "Total loyalty enrollments including all statuses. Used as denominator for active rate and churn rate calculations."
    - name: "active_enrollment_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN enrollment_status = 'active' THEN loyalty_enrollment_id END) / NULLIF(COUNT(DISTINCT loyalty_enrollment_id), 0), 2)
      comment: "Percentage of loyalty enrollments that are currently active. Tracks loyalty program health and churn pressure."
    - name: "total_lifetime_points_earned"
      expr: SUM(CAST(lifetime_points_earned AS DOUBLE))
      comment: "Sum of lifetime points earned across all enrollments. Measures total loyalty currency issued — a proxy for fan engagement investment and program liability."
    - name: "avg_lifetime_points_earned"
      expr: AVG(CAST(lifetime_points_earned AS DOUBLE))
      comment: "Average lifetime points earned per enrollment. Benchmarks fan engagement depth within the loyalty program; used to identify high-value vs. low-engagement cohorts."
    - name: "total_current_points_balance"
      expr: SUM(CAST(current_points_balance AS DOUBLE))
      comment: "Total unredeemed points balance across all active enrollments. Represents outstanding loyalty liability and redemption opportunity for the business."
    - name: "avg_current_points_balance"
      expr: AVG(CAST(current_points_balance AS DOUBLE))
      comment: "Average current points balance per enrollment. Indicates whether fans are accumulating but not redeeming — a signal for redemption friction or reward relevance issues."
    - name: "total_tier_qualifying_points_ytd"
      expr: SUM(CAST(tier_qualifying_points_ytd AS DOUBLE))
      comment: "Total tier-qualifying points earned year-to-date across all enrollments. Tracks progress toward tier thresholds and forecasts tier upgrade volumes."
    - name: "auto_renewal_enabled_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN auto_renewal_enabled = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of enrollments with auto-renewal enabled. Leading indicator of retention; low rates signal renewal campaign investment need."
    - name: "terminated_enrollments"
      expr: COUNT(DISTINCT CASE WHEN enrollment_status = 'terminated' THEN loyalty_enrollment_id END)
      comment: "Number of terminated loyalty enrollments. Tracks loyalty churn volume for retention intervention prioritisation."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_loyalty_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Loyalty points economics and transaction flow metrics. Tracks points issuance, redemption, monetary value, and bonus activity — essential for loyalty program P&L, redemption rate optimisation, and fraud/reversal monitoring."
  source: "`sports_entertainment_ecm`.`fan`.`loyalty_transaction`"
  dimensions:
    - name: "transaction_type"
      expr: transaction_type
      comment: "Type of loyalty transaction (e.g. earn, redeem, adjust, expire, transfer) for transaction flow analysis."
    - name: "activity_type"
      expr: activity_type
      comment: "Specific activity that triggered the transaction (e.g. ticket purchase, merchandise, streaming) for earn-driver analysis."
    - name: "activity_channel"
      expr: activity_channel
      comment: "Channel through which the loyalty activity occurred for channel-level points economics analysis."
    - name: "transaction_status"
      expr: transaction_status
      comment: "Status of the loyalty transaction (e.g. completed, reversed, pending) for quality and integrity monitoring."
    - name: "is_bonus_transaction"
      expr: is_bonus_transaction
      comment: "Flags bonus point transactions, enabling separation of base vs. promotional points issuance."
    - name: "is_tier_qualifying"
      expr: is_tier_qualifying
      comment: "Flags whether the transaction contributes to tier qualification, used to track tier progression economics."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the monetary value associated with the transaction for multi-currency program analysis."
    - name: "processing_date_month"
      expr: DATE_TRUNC('MONTH', processing_date)
      comment: "Month of transaction processing for trend and seasonality analysis of loyalty activity."
  measures:
    - name: "total_points_issued"
      expr: SUM(CAST(CASE WHEN transaction_type IN ('earn', 'bonus', 'adjust') THEN points_amount ELSE 0 END AS DOUBLE))
      comment: "Total loyalty points issued (earned and adjusted). Measures the scale of loyalty currency creation and program engagement incentive spend."
    - name: "total_points_redeemed"
      expr: SUM(CAST(CASE WHEN transaction_type = 'redeem' THEN points_amount ELSE 0 END AS DOUBLE))
      comment: "Total loyalty points redeemed. Tracks redemption volume — a key indicator of program value perception and fan satisfaction."
    - name: "total_redemption_value"
      expr: SUM(CAST(redemption_value AS DOUBLE))
      comment: "Total monetary value of points redeemed. Quantifies the financial cost of loyalty redemptions and informs program liability management."
    - name: "total_monetary_value"
      expr: SUM(CAST(monetary_value AS DOUBLE))
      comment: "Total monetary value associated with loyalty transactions. Measures the revenue base driving loyalty point issuance."
    - name: "avg_points_per_transaction"
      expr: AVG(CAST(points_amount AS DOUBLE))
      comment: "Average points amount per loyalty transaction. Benchmarks transaction-level earning rates and detects anomalies in point issuance."
    - name: "avg_points_multiplier"
      expr: AVG(CAST(points_multiplier AS DOUBLE))
      comment: "Average points multiplier applied across transactions. Tracks promotional multiplier usage and its impact on points liability."
    - name: "bonus_transaction_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_bonus_transaction = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of transactions that are bonus transactions. Measures promotional points intensity and its contribution to total points liability."
    - name: "total_transactions"
      expr: COUNT(1)
      comment: "Total number of loyalty transactions. Baseline activity volume metric for program engagement and operational throughput."
    - name: "unique_active_enrollments_transacting"
      expr: COUNT(DISTINCT loyalty_enrollment_id)
      comment: "Number of distinct loyalty enrollments with at least one transaction in the period. Measures active program participation rate."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_membership`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fan membership portfolio metrics covering active membership counts, fee revenue, tier distribution, premium access rates, and renewal health. Directly informs membership product strategy, pricing decisions, and retention investment."
  source: "`sports_entertainment_ecm`.`fan`.`membership`"
  dimensions:
    - name: "membership_type"
      expr: membership_type
      comment: "Type of membership (e.g. season ticket, club, premium, digital) for product-level performance analysis."
    - name: "membership_tier"
      expr: membership_tier
      comment: "Tier level of the membership for premium segment analysis and tier economics benchmarking."
    - name: "membership_status"
      expr: membership_status
      comment: "Current status of the membership (e.g. active, cancelled, expired, waitlisted) for portfolio health monitoring."
    - name: "channel"
      expr: channel
      comment: "Sales channel through which the membership was acquired for channel attribution and investment decisions."
    - name: "payment_frequency"
      expr: payment_frequency
      comment: "Payment frequency (e.g. annual, monthly, quarterly) for cash flow and revenue recognition analysis."
    - name: "renewal_status"
      expr: renewal_status
      comment: "Renewal status of the membership for forward-looking retention and revenue forecasting."
    - name: "is_corporate"
      expr: is_corporate
      comment: "Flags corporate memberships for B2B vs. B2C portfolio segmentation."
    - name: "is_vip"
      expr: is_vip
      comment: "Flags VIP memberships for premium segment tracking and hospitality capacity planning."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the membership fee for multi-market revenue analysis."
    - name: "start_year_month"
      expr: DATE_TRUNC('MONTH', start_date)
      comment: "Month the membership started for cohort and acquisition trend analysis."
  measures:
    - name: "total_active_memberships"
      expr: COUNT(DISTINCT CASE WHEN membership_status = 'active' THEN membership_id END)
      comment: "Total number of active memberships. Primary KPI for membership portfolio scale and health."
    - name: "total_memberships"
      expr: COUNT(DISTINCT membership_id)
      comment: "Total memberships across all statuses. Used as denominator for active rate and cancellation rate calculations."
    - name: "total_membership_fee_revenue"
      expr: SUM(CAST(fee AS DOUBLE))
      comment: "Total gross membership fee revenue. Core revenue KPI for the membership business line."
    - name: "total_net_membership_fee_revenue"
      expr: SUM(CAST(net_fee AS DOUBLE))
      comment: "Total net membership fee revenue after discounts. Measures actual membership revenue contribution after promotional discounting."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discount value applied across memberships. Tracks promotional discount spend and its impact on net revenue."
    - name: "avg_membership_fee"
      expr: AVG(CAST(fee AS DOUBLE))
      comment: "Average membership fee per membership. Benchmarks pricing effectiveness and tracks average revenue per member over time."
    - name: "avg_merchandise_discount_pct"
      expr: AVG(CAST(merchandise_discount_pct AS DOUBLE))
      comment: "Average merchandise discount percentage granted to members. Informs merchandise margin impact of membership benefit structures."
    - name: "vip_membership_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_vip = TRUE THEN membership_id END) / NULLIF(COUNT(DISTINCT membership_id), 0), 2)
      comment: "Percentage of memberships with VIP status. Tracks premium tier penetration and hospitality capacity utilisation."
    - name: "auto_renew_enabled_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN auto_renew_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of memberships with auto-renewal enabled. Leading indicator of renewal revenue predictability and retention risk."
    - name: "cancellation_count"
      expr: COUNT(DISTINCT CASE WHEN cancellation_date IS NOT NULL THEN membership_id END)
      comment: "Number of memberships with a recorded cancellation. Tracks churn volume for retention intervention and product improvement decisions."
    - name: "priority_ticketing_enabled_count"
      expr: COUNT(DISTINCT CASE WHEN priority_ticketing_flag = TRUE THEN membership_id END)
      comment: "Number of memberships with priority ticketing access. Measures uptake of a high-value membership benefit tied to ticket revenue and fan satisfaction."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_campaign`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fan marketing campaign performance and efficiency metrics. Tracks spend, impression delivery, conversion rates, and budget utilisation — essential for marketing ROI assessment, channel investment decisions, and campaign optimisation."
  source: "`sports_entertainment_ecm`.`fan`.`campaign`"
  dimensions:
    - name: "campaign_type"
      expr: campaign_type
      comment: "Type of campaign (e.g. acquisition, retention, reactivation, upsell) for strategic portfolio analysis."
    - name: "campaign_status"
      expr: campaign_status
      comment: "Current status of the campaign (e.g. active, completed, paused, draft) for pipeline and performance monitoring."
    - name: "channel"
      expr: channel
      comment: "Marketing channel used for the campaign (e.g. email, social, paid search, in-app) for channel ROI analysis."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of the campaign for governance and compliance workflow monitoring."
    - name: "priority"
      expr: priority
      comment: "Campaign priority level for resource allocation and scheduling analysis."
    - name: "target_audience"
      expr: target_audience
      comment: "Target audience definition for the campaign, enabling audience-level performance benchmarking."
    - name: "is_automated"
      expr: is_automated
      comment: "Flags automated vs. manually executed campaigns for automation ROI analysis."
    - name: "start_year_month"
      expr: DATE_TRUNC('MONTH', start_date)
      comment: "Month the campaign started for trend and seasonality analysis of marketing activity."
  measures:
    - name: "total_actual_spend"
      expr: SUM(CAST(actual_spend_amount AS DOUBLE))
      comment: "Total actual marketing spend across campaigns. Core marketing cost KPI for budget management and ROI calculation."
    - name: "total_budget_amount"
      expr: SUM(CAST(budget_amount AS DOUBLE))
      comment: "Total budgeted marketing spend across campaigns. Used as denominator for budget utilisation rate."
    - name: "budget_utilisation_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_spend_amount AS DOUBLE)) / NULLIF(SUM(CAST(budget_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of campaign budget actually spent. Measures marketing execution efficiency and budget management discipline."
    - name: "total_actual_impressions"
      expr: SUM(CAST(actual_impressions AS DOUBLE))
      comment: "Total actual impressions delivered across campaigns. Measures campaign reach and media delivery performance."
    - name: "total_actual_conversions"
      expr: SUM(CAST(actual_conversions AS DOUBLE))
      comment: "Total actual conversions generated across campaigns. Measures campaign effectiveness in driving desired fan actions."
    - name: "overall_conversion_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_conversions AS DOUBLE)) / NULLIF(SUM(CAST(actual_impressions AS DOUBLE)), 0), 2)
      comment: "Overall conversion rate (conversions / impressions) across campaigns. Key marketing efficiency KPI linking reach to outcomes."
    - name: "cost_per_conversion"
      expr: ROUND(SUM(CAST(actual_spend_amount AS DOUBLE)) / NULLIF(SUM(CAST(actual_conversions AS DOUBLE)), 0), 2)
      comment: "Average cost per conversion across campaigns. Primary marketing ROI metric used to compare channel and campaign efficiency."
    - name: "impression_delivery_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_impressions AS DOUBLE)) / NULLIF(SUM(CAST(target_impressions AS DOUBLE)), 0), 2)
      comment: "Percentage of target impressions actually delivered. Measures media execution quality and campaign delivery against plan."
    - name: "conversion_target_attainment_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_conversions AS DOUBLE)) / NULLIF(SUM(CAST(target_conversions AS DOUBLE)), 0), 2)
      comment: "Percentage of target conversions achieved. Measures campaign effectiveness against planned conversion goals."
    - name: "total_campaigns"
      expr: COUNT(DISTINCT campaign_id)
      comment: "Total number of campaigns. Baseline volume metric for marketing activity scale and portfolio management."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_service_case`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fan service quality and resolution performance metrics. Tracks case volume, SLA compliance, escalation rates, refund exposure, and resolution efficiency — critical for fan experience management, service team capacity planning, and operational excellence."
  source: "`sports_entertainment_ecm`.`fan`.`service_case`"
  dimensions:
    - name: "case_type"
      expr: case_type
      comment: "Type of service case (e.g. billing, ticketing, access, complaint) for issue category analysis."
    - name: "case_category"
      expr: case_category
      comment: "Category of the service case for granular issue classification and root cause analysis."
    - name: "case_status"
      expr: case_status
      comment: "Current status of the service case (e.g. open, resolved, escalated, closed) for workload and resolution monitoring."
    - name: "origin_channel"
      expr: origin_channel
      comment: "Channel through which the case was raised (e.g. phone, email, chat, in-venue) for channel service cost analysis."
    - name: "priority"
      expr: priority
      comment: "Priority level of the service case for SLA management and resource allocation."
    - name: "resolution_type"
      expr: resolution_type
      comment: "How the case was resolved (e.g. refund, replacement, information, escalation) for resolution quality analysis."
    - name: "fan_sentiment"
      expr: fan_sentiment
      comment: "Recorded fan sentiment at case resolution for customer satisfaction and experience quality tracking."
    - name: "assigned_team"
      expr: assigned_team
      comment: "Team responsible for the case for workload distribution and team performance analysis."
    - name: "open_date_month"
      expr: DATE_TRUNC('MONTH', open_date)
      comment: "Month the case was opened for trend and volume analysis of service demand."
    - name: "vip_flag"
      expr: vip_flag
      comment: "Flags cases from VIP fans for premium service tier monitoring and SLA differentiation."
  measures:
    - name: "total_cases"
      expr: COUNT(DISTINCT service_case_id)
      comment: "Total number of service cases. Baseline KPI for fan service demand volume and operational workload."
    - name: "escalated_cases"
      expr: COUNT(DISTINCT CASE WHEN escalation_flag = TRUE THEN service_case_id END)
      comment: "Number of escalated service cases. Tracks service quality failures requiring management intervention."
    - name: "escalation_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN escalation_flag = TRUE THEN service_case_id END) / NULLIF(COUNT(DISTINCT service_case_id), 0), 2)
      comment: "Percentage of cases that were escalated. Key service quality KPI; high rates signal systemic issues requiring process or staffing intervention."
    - name: "sla_breach_cases"
      expr: COUNT(DISTINCT CASE WHEN sla_breach_flag = TRUE THEN service_case_id END)
      comment: "Number of cases where SLA was breached. Directly measures service delivery compliance and fan experience risk."
    - name: "sla_breach_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN sla_breach_flag = TRUE THEN service_case_id END) / NULLIF(COUNT(DISTINCT service_case_id), 0), 2)
      comment: "Percentage of cases breaching SLA targets. Primary operational KPI for service team performance and contractual compliance."
    - name: "avg_sla_target_hours"
      expr: AVG(CAST(sla_target_hours AS DOUBLE))
      comment: "Average SLA target resolution time in hours across cases. Benchmarks service commitment levels by case type and priority."
    - name: "total_refund_amount"
      expr: SUM(CAST(refund_amount AS DOUBLE))
      comment: "Total refund value issued through service cases. Measures financial exposure from service failures and fan dissatisfaction."
    - name: "avg_refund_amount"
      expr: AVG(CAST(CASE WHEN refund_amount > 0 THEN refund_amount END AS DOUBLE))
      comment: "Average refund amount per case where a refund was issued. Benchmarks refund generosity and informs refund policy calibration."
    - name: "gdpr_data_request_cases"
      expr: COUNT(DISTINCT CASE WHEN gdpr_data_request_flag = TRUE THEN service_case_id END)
      comment: "Number of cases involving GDPR data requests. Tracks regulatory compliance workload and data subject rights request volume."
    - name: "season_ticket_holder_case_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN season_ticket_holder_flag = TRUE THEN service_case_id END) / NULLIF(COUNT(DISTINCT service_case_id), 0), 2)
      comment: "Percentage of service cases raised by season ticket holders. Monitors service quality for the highest-value fan segment."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_communication`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fan communication delivery, engagement, and opt-out metrics. Tracks message delivery rates, open and click performance, conversion outcomes, and suppression/opt-out signals — essential for CRM channel effectiveness, deliverability health, and consent compliance."
  source: "`sports_entertainment_ecm`.`fan`.`communication`"
  dimensions:
    - name: "communication_type"
      expr: communication_type
      comment: "Type of communication (e.g. promotional, transactional, service, loyalty) for message category performance analysis."
    - name: "channel"
      expr: channel
      comment: "Delivery channel (e.g. email, SMS, push, in-app) for channel-level performance and investment analysis."
    - name: "delivery_status"
      expr: delivery_status
      comment: "Delivery outcome status (e.g. delivered, bounced, failed) for deliverability health monitoring."
    - name: "device_type"
      expr: device_type
      comment: "Device type on which the communication was received for platform-level engagement analysis."
    - name: "ab_test_variant"
      expr: ab_test_variant
      comment: "A/B test variant identifier for controlled experiment performance comparison."
    - name: "bounce_type"
      expr: bounce_type
      comment: "Type of bounce (e.g. hard, soft) for deliverability diagnosis and list hygiene management."
    - name: "loyalty_tier"
      expr: loyalty_tier
      comment: "Loyalty tier of the recipient at time of communication for tier-level engagement benchmarking."
    - name: "trigger_type"
      expr: trigger_type
      comment: "What triggered the communication (e.g. event-based, scheduled, behavioural) for automation effectiveness analysis."
    - name: "send_year_month"
      expr: DATE_TRUNC('MONTH', send_timestamp)
      comment: "Month the communication was sent for trend and volume analysis."
    - name: "personalization_flag"
      expr: personalization_flag
      comment: "Flags personalised communications for personalisation lift analysis vs. generic messaging."
  measures:
    - name: "total_communications_sent"
      expr: COUNT(1)
      comment: "Total number of communications sent. Baseline volume metric for CRM activity scale."
    - name: "delivered_communications"
      expr: COUNT(CASE WHEN delivery_status = 'delivered' THEN 1 END)
      comment: "Number of successfully delivered communications. Measures deliverability performance and list quality."
    - name: "delivery_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN delivery_status = 'delivered' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of sent communications successfully delivered. Primary deliverability KPI; declines signal list hygiene or sender reputation issues."
    - name: "open_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN open_timestamp IS NOT NULL THEN 1 END) / NULLIF(COUNT(CASE WHEN delivery_status = 'delivered' THEN 1 END), 0), 2)
      comment: "Percentage of delivered communications that were opened. Measures message relevance and subject line effectiveness."
    - name: "click_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN click_timestamp IS NOT NULL THEN 1 END) / NULLIF(COUNT(CASE WHEN delivery_status = 'delivered' THEN 1 END), 0), 2)
      comment: "Percentage of delivered communications that received a click. Measures content engagement and call-to-action effectiveness."
    - name: "conversion_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN conversion_flag = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN delivery_status = 'delivered' THEN 1 END), 0), 2)
      comment: "Percentage of delivered communications that resulted in a conversion. Primary CRM ROI metric linking communication to business outcomes."
    - name: "opt_out_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN opt_out_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of communications resulting in an opt-out. Tracks communication fatigue and consent erosion — a leading indicator of list degradation."
    - name: "suppression_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN suppression_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of communications suppressed before delivery. Measures compliance suppression list effectiveness and consent management quality."
    - name: "total_conversions"
      expr: COUNT(CASE WHEN conversion_flag = TRUE THEN 1 END)
      comment: "Total number of communication-driven conversions. Measures absolute CRM contribution to business outcomes."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`fan_segment_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fan segmentation coverage, quality, and activation metrics. Tracks segment assignment volume, consent compliance, activation rates, and scoring quality — essential for CRM segmentation strategy, personalisation program governance, and audience activation effectiveness."
  source: "`sports_entertainment_ecm`.`fan`.`segment_assignment`"
  dimensions:
    - name: "assignment_method"
      expr: assignment_method
      comment: "Method used to assign the fan to the segment (e.g. rule-based, ML model, manual) for segmentation approach analysis."
    - name: "assignment_status"
      expr: assignment_status
      comment: "Current status of the segment assignment (e.g. active, expired, revoked) for coverage health monitoring."
    - name: "activation_status"
      expr: activation_status
      comment: "Status of segment activation (e.g. activated, pending, failed) for downstream campaign activation monitoring."
    - name: "activation_destination"
      expr: activation_destination
      comment: "Platform or system where the segment was activated (e.g. email platform, DSP, CRM) for activation channel analysis."
    - name: "segment_category"
      expr: segment_category
      comment: "Category of the segment (e.g. behavioural, demographic, transactional) for segmentation strategy analysis."
    - name: "loyalty_tier_at_assignment"
      expr: loyalty_tier_at_assignment
      comment: "Fan's loyalty tier at the time of segment assignment for tier-level segmentation coverage analysis."
    - name: "fan_type_at_assignment"
      expr: fan_type_at_assignment
      comment: "Fan type at the time of assignment for cohort-level segmentation analysis."
    - name: "assignment_channel"
      expr: assignment_channel
      comment: "Channel context of the segment assignment for channel-specific audience analysis."
    - name: "is_primary_segment"
      expr: is_primary_segment
      comment: "Flags whether this is the fan's primary segment assignment for deduplication and primary segment analysis."
    - name: "assignment_year_month"
      expr: DATE_TRUNC('MONTH', assignment_date)
      comment: "Month of segment assignment for trend analysis of segmentation activity."
  measures:
    - name: "total_segment_assignments"
      expr: COUNT(DISTINCT segment_assignment_id)
      comment: "Total number of segment assignments. Baseline KPI for segmentation coverage and CRM audience scale."
    - name: "unique_segmented_fans"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Number of unique fans with at least one segment assignment. Measures segmentation reach across the fan base."
    - name: "active_assignments"
      expr: COUNT(DISTINCT CASE WHEN assignment_status = 'active' THEN segment_assignment_id END)
      comment: "Number of currently active segment assignments. Tracks the live addressable audience across all segments."
    - name: "activated_assignments"
      expr: COUNT(DISTINCT CASE WHEN activation_status = 'activated' THEN segment_assignment_id END)
      comment: "Number of segment assignments that have been activated to a downstream platform. Measures segmentation-to-activation conversion."
    - name: "activation_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN activation_status = 'activated' THEN segment_assignment_id END) / NULLIF(COUNT(DISTINCT segment_assignment_id), 0), 2)
      comment: "Percentage of segment assignments that have been activated. Measures how effectively audience segments are converted into active campaign audiences."
    - name: "consent_verified_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN consent_verified = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of segment assignments with verified consent. Critical compliance KPI ensuring audience activation is consent-compliant under GDPR/CCPA."
    - name: "avg_assignment_score"
      expr: AVG(CAST(assignment_score AS DOUBLE))
      comment: "Average model assignment score across segment assignments. Measures the confidence and quality of model-driven segmentation."
    - name: "avg_engagement_score_at_assignment"
      expr: AVG(CAST(engagement_score_at_assignment AS DOUBLE))
      comment: "Average fan engagement score at the time of segment assignment. Benchmarks the engagement profile of fans entering each segment."
    - name: "avg_score_percentile"
      expr: AVG(CAST(score_percentile AS DOUBLE))
      comment: "Average score percentile of fans within their assigned segments. Measures the relative quality of the segmented audience pool."
    - name: "data_suppression_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN data_suppression_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of segment assignments flagged for data suppression. Tracks compliance suppression coverage and privacy risk exposure in audience activation."
$$;