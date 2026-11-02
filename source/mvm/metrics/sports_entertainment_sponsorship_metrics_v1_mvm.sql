-- Metric views for domain: sponsorship | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_deal`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for sponsorship deal portfolio — contract value, audience commitments, deal pipeline stage, and renewal health. Used by VP of Partnerships and CFO to steer deal origination, renewal, and revenue forecasting."
  source: "`sports_entertainment_ecm`.`sponsorship`.`deal`"
  dimensions:
    - name: "deal_type"
      expr: deal_type
      comment: "Classification of the sponsorship deal (e.g. title, presenting, associate, naming rights) for portfolio segmentation."
    - name: "deal_stage"
      expr: stage
      comment: "Current pipeline stage of the deal (e.g. prospecting, negotiation, executed, expired) for funnel analysis."
    - name: "exclusivity_category"
      expr: exclusivity_category
      comment: "Industry or product category for which exclusivity is granted, enabling category conflict management."
    - name: "territory"
      expr: territory
      comment: "Geographic territory covered by the deal for regional revenue analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency in which the deal is denominated for multi-currency reporting."
    - name: "payment_schedule_type"
      expr: payment_schedule_type
      comment: "Payment cadence type (e.g. annual, quarterly, milestone-based) for cash flow planning."
    - name: "renewal_option_flag"
      expr: renewal_option_flag
      comment: "Indicates whether the deal includes a renewal option, used to forecast future pipeline."
    - name: "digital_partnership_type"
      expr: digital_partnership_type
      comment: "Type of digital partnership component (e.g. social, streaming, OTT) for digital revenue segmentation."
    - name: "campaign_flight_start_date"
      expr: DATE_TRUNC('month', campaign_flight_start_date)
      comment: "Month the campaign flight begins, used for cohort and seasonal trend analysis."
    - name: "campaign_flight_end_date"
      expr: DATE_TRUNC('month', campaign_flight_end_date)
      comment: "Month the campaign flight ends, used for revenue recognition timing."
  measures:
    - name: "total_contract_value"
      expr: SUM(CAST(total_contract_value AS DOUBLE))
      comment: "Total committed contract value across all sponsorship deals. Primary revenue pipeline KPI for CFO and VP Partnerships."
    - name: "total_annual_contract_value"
      expr: SUM(CAST(annual_contract_value AS DOUBLE))
      comment: "Sum of annualized contract values, used for year-over-year revenue comparison and budget planning."
    - name: "avg_deal_contract_value"
      expr: AVG(CAST(total_contract_value AS DOUBLE))
      comment: "Average total contract value per deal, indicating deal quality and sponsor investment level."
    - name: "total_impression_commitment"
      expr: SUM(CAST(impression_commitment AS DOUBLE))
      comment: "Total contracted impression volume across all deals, used to assess audience delivery obligations."
    - name: "total_audience_commitment"
      expr: SUM(CAST(audience_commitment_size AS DOUBLE))
      comment: "Aggregate audience size committed across deals, a key delivery obligation metric for operations."
    - name: "total_grp_commitment"
      expr: SUM(CAST(grp_commitment AS DOUBLE))
      comment: "Total Gross Rating Points committed across deals, used by broadcast and media teams to validate delivery capacity."
    - name: "avg_cpm_rate"
      expr: AVG(CAST(cpm_rate AS DOUBLE))
      comment: "Average CPM rate across deals, benchmarking pricing efficiency against market rates."
    - name: "deal_count"
      expr: COUNT(DISTINCT deal_id)
      comment: "Number of distinct sponsorship deals, used to track portfolio size and pipeline volume."
    - name: "renewal_eligible_deal_count"
      expr: COUNT(DISTINCT CASE WHEN renewal_option_flag = TRUE THEN deal_id END)
      comment: "Number of deals with a renewal option, indicating future pipeline potential and retention opportunity."
    - name: "avg_arpu_impact_estimate"
      expr: AVG(CAST(arpu_impact_estimate AS DOUBLE))
      comment: "Average estimated ARPU impact per deal, linking sponsorship investment to fan monetization outcomes."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_activation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Operational KPIs for sponsorship activation delivery — impression fulfillment, GRP delivery, contracted vs. delivered value, and activation quality. Used by activation managers and account teams to monitor in-flight delivery and identify shortfalls."
  source: "`sports_entertainment_ecm`.`sponsorship`.`activation`"
  dimensions:
    - name: "activation_type"
      expr: activation_type
      comment: "Type of activation (e.g. in-venue signage, broadcast mention, digital overlay) for channel-level performance analysis."
    - name: "sponsorship_activation_category"
      expr: sponsorship_activation_category
      comment: "Business category of the activation (e.g. jersey, naming rights, broadcast) for portfolio segmentation."
    - name: "fulfillment_status"
      expr: fulfillment_status
      comment: "Current fulfillment status of the activation (e.g. pending, delivered, shortfall) for operational triage."
    - name: "visibility_tier"
      expr: visibility_tier
      comment: "Tier of visibility assigned to the activation (e.g. premium, standard) for value-tier analysis."
    - name: "placement_location"
      expr: placement_location
      comment: "Physical or digital placement location of the activation for inventory utilization reporting."
    - name: "sponsor_approval_status"
      expr: sponsor_approval_status
      comment: "Approval status from the sponsor for the activation creative or placement."
    - name: "virtual_overlay"
      expr: virtual_overlay
      comment: "Indicates whether the activation uses virtual overlay technology, relevant for digital inventory valuation."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency in which the activation value is denominated."
    - name: "effective_start_date"
      expr: DATE_TRUNC('month', effective_start_date)
      comment: "Month the activation becomes effective, used for seasonal delivery trend analysis."
    - name: "actual_delivery_date"
      expr: DATE_TRUNC('month', actual_delivery_date)
      comment: "Month of actual delivery, used to track delivery timing vs. schedule."
  measures:
    - name: "total_contracted_value"
      expr: SUM(CAST(contracted_value AS DOUBLE))
      comment: "Total contracted sponsorship value across activations. Core revenue obligation metric for finance and account management."
    - name: "total_impressions_contracted"
      expr: SUM(CAST(impressions_contracted AS DOUBLE))
      comment: "Total impressions contracted across all activations, representing the audience delivery obligation."
    - name: "total_impressions_delivered"
      expr: SUM(CAST(impressions_delivered AS DOUBLE))
      comment: "Total impressions actually delivered, used to measure fulfillment against contracted obligations."
    - name: "impression_delivery_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(impressions_delivered AS DOUBLE)) / NULLIF(SUM(CAST(impressions_contracted AS DOUBLE)), 0), 2)
      comment: "Percentage of contracted impressions delivered. Key fulfillment KPI — values below 100% trigger makegood obligations."
    - name: "total_grp_contracted"
      expr: SUM(CAST(grp_contracted AS DOUBLE))
      comment: "Total Gross Rating Points contracted across activations, representing broadcast audience delivery obligations."
    - name: "total_grp_delivered"
      expr: SUM(CAST(grp_delivered AS DOUBLE))
      comment: "Total GRPs actually delivered, used to assess broadcast fulfillment performance."
    - name: "grp_delivery_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(grp_delivered AS DOUBLE)) / NULLIF(SUM(CAST(grp_contracted AS DOUBLE)), 0), 2)
      comment: "Percentage of contracted GRPs delivered. Broadcast fulfillment KPI used by media operations and account teams."
    - name: "activation_count"
      expr: COUNT(DISTINCT activation_id)
      comment: "Number of distinct activations, used to track activation volume and operational workload."
    - name: "avg_contracted_value_per_activation"
      expr: AVG(CAST(contracted_value AS DOUBLE))
      comment: "Average contracted value per activation, indicating activation-level deal quality and pricing."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_activation_fulfillment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fulfillment quality and financial realization KPIs for sponsorship activations — CPM realization, GRP achievement, shortfall tracking, and makegood exposure. Used by operations, finance, and account management to manage delivery risk and revenue recognition."
  source: "`sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment`"
  dimensions:
    - name: "fulfillment_status"
      expr: fulfillment_status
      comment: "Status of the fulfillment record (e.g. complete, partial, shortfall) for operational triage."
    - name: "fulfillment_channel"
      expr: fulfillment_channel
      comment: "Channel through which the activation was fulfilled (e.g. broadcast, digital, in-venue) for channel performance analysis."
    - name: "activation_type"
      expr: activation_type
      comment: "Type of activation fulfilled, enabling cross-channel delivery comparison."
    - name: "placement_location"
      expr: placement_location
      comment: "Location where the activation was placed, used for inventory utilization and placement effectiveness analysis."
    - name: "makegood_required"
      expr: makegood_required
      comment: "Flags fulfillment records requiring a makegood, used to quantify delivery liability exposure."
    - name: "brand_safety_compliant"
      expr: brand_safety_compliant
      comment: "Indicates whether the fulfillment met brand safety standards, critical for sponsor relationship management."
    - name: "audience_demographic_target"
      expr: audience_demographic_target
      comment: "Target demographic for the fulfilled activation, used for audience delivery analysis by segment."
    - name: "fulfillment_date"
      expr: DATE_TRUNC('month', fulfillment_date)
      comment: "Month of fulfillment, used for revenue recognition timing and delivery trend analysis."
    - name: "proof_type"
      expr: proof_type
      comment: "Type of proof of performance submitted (e.g. screenshot, log, third-party verification) for audit quality assessment."
  measures:
    - name: "total_fulfillment_value_usd"
      expr: SUM(CAST(fulfillment_value_usd AS DOUBLE))
      comment: "Total USD value of fulfilled activations. Primary revenue realization metric for finance and revenue recognition."
    - name: "total_impressions_delivered"
      expr: SUM(CAST(impressions_delivered AS DOUBLE))
      comment: "Total impressions delivered across all fulfillment records, measuring actual audience reach achieved."
    - name: "total_impressions_contracted"
      expr: SUM(CAST(impressions_contracted AS DOUBLE))
      comment: "Total impressions contracted, used as the denominator for fulfillment rate calculations."
    - name: "fulfillment_impression_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(impressions_delivered AS DOUBLE)) / NULLIF(SUM(CAST(impressions_contracted AS DOUBLE)), 0), 2)
      comment: "Percentage of contracted impressions fulfilled. Core delivery KPI — shortfalls below threshold trigger makegood obligations."
    - name: "total_shortfall_impressions"
      expr: SUM(CAST(shortfall_impressions AS DOUBLE))
      comment: "Total impression shortfall across fulfillment records. Quantifies makegood liability and delivery risk exposure."
    - name: "total_grp_achieved"
      expr: SUM(CAST(grp_achieved AS DOUBLE))
      comment: "Total GRPs achieved across fulfillment records, used to validate broadcast audience delivery."
    - name: "grp_achievement_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(grp_achieved AS DOUBLE)) / NULLIF(SUM(CAST(grp_contracted AS DOUBLE)), 0), 2)
      comment: "Percentage of contracted GRPs achieved. Broadcast delivery KPI used by media operations and account teams."
    - name: "avg_cpm_realized"
      expr: AVG(CAST(cpm_realized AS DOUBLE))
      comment: "Average realized CPM across fulfillment records, benchmarking actual pricing efficiency vs. contracted rates."
    - name: "cpm_realization_rate_pct"
      expr: ROUND(100.0 * AVG(CAST(cpm_realized AS DOUBLE)) / NULLIF(AVG(CAST(cpm_contracted AS DOUBLE)), 0), 2)
      comment: "Ratio of realized CPM to contracted CPM. Pricing efficiency KPI — values below 100% indicate under-delivery on rate."
    - name: "avg_fulfillment_quality_rating"
      expr: AVG(CAST(fulfillment_quality_rating AS DOUBLE))
      comment: "Average quality rating of fulfillment records, used to monitor execution standards and sponsor satisfaction."
    - name: "makegood_required_count"
      expr: COUNT(DISTINCT CASE WHEN makegood_required = TRUE THEN activation_fulfillment_id END)
      comment: "Number of fulfillment records requiring a makegood, quantifying delivery liability and operational remediation workload."
    - name: "total_audience_reach"
      expr: SUM(CAST(audience_reach AS DOUBLE))
      comment: "Total audience reach delivered across all fulfillment records, a key sponsor ROI metric."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_performance_metric`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sponsor ROI and KPI attainment metrics — impression delivery, brand recall, NPS lift, social engagement, and variance against contracted targets. Used by account management, analytics, and C-suite to evaluate sponsorship effectiveness and renewal decisions."
  source: "`sports_entertainment_ecm`.`sponsorship`.`performance_metric`"
  dimensions:
    - name: "metric_type"
      expr: metric_type
      comment: "Type of performance metric (e.g. impressions, GRP, brand recall, NPS) for KPI category analysis."
    - name: "metric_category"
      expr: metric_category
      comment: "Business category of the metric (e.g. broadcast, digital, in-venue) for channel-level performance segmentation."
    - name: "activation_channel"
      expr: activation_channel
      comment: "Channel through which the activation was delivered, enabling cross-channel ROI comparison."
    - name: "fulfillment_status"
      expr: fulfillment_status
      comment: "Fulfillment status of the measured activation, used to filter analysis to delivered vs. pending activations."
    - name: "measurement_status"
      expr: measurement_status
      comment: "Status of the measurement (e.g. verified, pending, disputed) for data quality filtering."
    - name: "is_contracted_kpi"
      expr: is_contracted_kpi
      comment: "Indicates whether this metric is a contracted KPI obligation, enabling compliance vs. value-add metric separation."
    - name: "make_good_required"
      expr: make_good_required
      comment: "Flags metrics where a makegood is required due to underperformance, used to quantify remediation exposure."
    - name: "reporting_period_type"
      expr: reporting_period_type
      comment: "Granularity of the reporting period (e.g. event, monthly, seasonal) for time-series analysis."
    - name: "measurement_period_start"
      expr: DATE_TRUNC('month', measurement_period_start)
      comment: "Month the measurement period begins, used for trend and seasonal performance analysis."
    - name: "data_source"
      expr: data_source
      comment: "Source of the performance data (e.g. Nielsen, internal, third-party) for data provenance and credibility assessment."
  measures:
    - name: "total_impressions"
      expr: SUM(CAST(impressions AS DOUBLE))
      comment: "Total impressions delivered across all performance metric records. Primary audience reach KPI for sponsor ROI reporting."
    - name: "total_actual_value"
      expr: SUM(CAST(actual_value AS DOUBLE))
      comment: "Sum of actual KPI values delivered, used to aggregate performance across metric types for portfolio-level reporting."
    - name: "total_contracted_target_value"
      expr: SUM(CAST(contracted_target_value AS DOUBLE))
      comment: "Sum of contracted target values, used as the benchmark denominator for attainment rate calculations."
    - name: "kpi_attainment_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_value AS DOUBLE)) / NULLIF(SUM(CAST(contracted_target_value AS DOUBLE)), 0), 2)
      comment: "Percentage of contracted KPI target achieved. Core sponsor ROI metric — values below 100% trigger makegood or renewal risk."
    - name: "total_grp_delivered"
      expr: SUM(CAST(grp_delivered AS DOUBLE))
      comment: "Total GRPs delivered across performance records, validating broadcast audience delivery against commitments."
    - name: "avg_brand_recall_score"
      expr: AVG(CAST(brand_recall_score AS DOUBLE))
      comment: "Average brand recall score across activations, a leading indicator of sponsorship effectiveness and renewal probability."
    - name: "avg_nps_lift"
      expr: AVG(CAST(nps_lift AS DOUBLE))
      comment: "Average NPS lift attributable to sponsorship activations, linking sponsorship investment to fan sentiment outcomes."
    - name: "avg_social_engagement_rate"
      expr: AVG(CAST(social_engagement_rate AS DOUBLE))
      comment: "Average social media engagement rate across activations, measuring digital sponsorship effectiveness."
    - name: "avg_cpm_realized"
      expr: AVG(CAST(cpm_realized AS DOUBLE))
      comment: "Average realized CPM across performance records, benchmarking actual media value delivery."
    - name: "total_reach_000s"
      expr: SUM(CAST(reach_000s AS DOUBLE))
      comment: "Total audience reach in thousands across all performance records, a key sponsor audience delivery metric."
    - name: "avg_variance_pct"
      expr: AVG(CAST(variance_pct AS DOUBLE))
      comment: "Average percentage variance between actual and contracted KPI values. Negative values indicate systemic under-delivery risk."
    - name: "makegood_required_count"
      expr: COUNT(DISTINCT CASE WHEN make_good_required = TRUE THEN performance_metric_id END)
      comment: "Number of performance metrics requiring a makegood, quantifying delivery liability and account remediation workload."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_payment_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sponsorship revenue collection and cash flow KPIs — scheduled vs. received amounts, overdue exposure, late fees, and payment status. Used by finance, AR, and executive leadership to manage cash flow, collections risk, and revenue recognition."
  source: "`sports_entertainment_ecm`.`sponsorship`.`payment_schedule`"
  dimensions:
    - name: "payment_status"
      expr: payment_status
      comment: "Current status of the payment (e.g. scheduled, received, overdue, disputed) for AR aging and collections analysis."
    - name: "payment_type"
      expr: payment_type
      comment: "Type of payment (e.g. cash, VIK, milestone) for revenue mix analysis."
    - name: "payment_method"
      expr: payment_method
      comment: "Method of payment (e.g. wire, ACH, check) for treasury and reconciliation reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the payment for multi-currency cash flow reporting."
    - name: "dunning_level"
      expr: dunning_level
      comment: "Dunning escalation level for overdue payments, used to prioritize collections actions."
    - name: "milestone_name"
      expr: milestone_name
      comment: "Name of the payment milestone (e.g. signing, activation launch, season end) for milestone-based revenue tracking."
    - name: "due_date"
      expr: DATE_TRUNC('month', due_date)
      comment: "Month the payment is due, used for cash flow forecasting and AR aging analysis."
    - name: "received_date"
      expr: DATE_TRUNC('month', received_date)
      comment: "Month the payment was received, used for actual cash collection trend analysis."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Payment terms code (e.g. Net 30, Net 60) for terms compliance and cash conversion analysis."
  measures:
    - name: "total_scheduled_amount"
      expr: SUM(CAST(scheduled_amount AS DOUBLE))
      comment: "Total amount scheduled for payment across all records. Primary revenue obligation metric for finance and cash flow planning."
    - name: "total_received_amount"
      expr: SUM(CAST(received_amount AS DOUBLE))
      comment: "Total amount actually received from sponsors. Core cash collection KPI for AR and treasury."
    - name: "collection_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(received_amount AS DOUBLE)) / NULLIF(SUM(CAST(scheduled_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of scheduled payments collected. Key AR efficiency KPI — values below target indicate collections risk."
    - name: "total_outstanding_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net outstanding payment amount, used for AR aging and collections prioritization."
    - name: "total_late_fee_amount"
      expr: SUM(CAST(late_fee_amount AS DOUBLE))
      comment: "Total late fees accrued across overdue payments, indicating collections performance and sponsor payment behavior."
    - name: "total_withholding_tax_amount"
      expr: SUM(CAST(withholding_tax_amount AS DOUBLE))
      comment: "Total withholding tax deducted from payments, required for tax compliance and net revenue reporting."
    - name: "total_adjustment_amount"
      expr: SUM(CAST(adjustment_amount AS DOUBLE))
      comment: "Total payment adjustments (credits, debits) applied, used for revenue reconciliation and dispute resolution."
    - name: "overdue_payment_count"
      expr: COUNT(DISTINCT CASE WHEN payment_status = 'overdue' THEN payment_schedule_id END)
      comment: "Number of overdue payment records, used to prioritize collections actions and assess sponsor credit risk."
    - name: "avg_early_payment_discount_pct"
      expr: AVG(CAST(early_payment_discount_pct AS DOUBLE))
      comment: "Average early payment discount offered, used to evaluate the cost of accelerating cash collection."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_deal_term`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Deal term financial and contractual KPIs — cash fees, VIK value, performance bonuses, CPM rates, and escalation exposure. Used by legal, finance, and partnership teams to manage contract economics and renewal terms."
  source: "`sports_entertainment_ecm`.`sponsorship`.`deal_term`"
  dimensions:
    - name: "term_type"
      expr: term_type
      comment: "Type of deal term (e.g. cash, VIK, broadcast, digital) for contract economics segmentation."
    - name: "term_status"
      expr: term_status
      comment: "Current status of the deal term (e.g. active, expired, disputed) for portfolio health monitoring."
    - name: "exclusivity_category"
      expr: exclusivity_category
      comment: "Category for which exclusivity is granted under this term, used for conflict management."
    - name: "exclusivity_flag"
      expr: exclusivity_flag
      comment: "Indicates whether this term includes an exclusivity provision, used to quantify exclusivity premium exposure."
    - name: "payment_schedule_type"
      expr: payment_schedule_type
      comment: "Payment cadence for this term (e.g. annual, quarterly) for cash flow planning."
    - name: "renewal_option_flag"
      expr: renewal_option_flag
      comment: "Indicates whether this term includes a renewal option, used to forecast future contract pipeline."
    - name: "nil_athlete_rights_flag"
      expr: nil_athlete_rights_flag
      comment: "Indicates whether NIL athlete rights are included in this term, relevant for athlete partnership valuation."
    - name: "ip_rights_granted_flag"
      expr: ip_rights_granted_flag
      comment: "Indicates whether IP rights are granted under this term, used for IP licensing revenue tracking."
    - name: "effective_start_date"
      expr: DATE_TRUNC('month', effective_start_date)
      comment: "Month the deal term becomes effective, used for cohort and vintage analysis."
    - name: "broadcast_integration_type"
      expr: broadcast_integration_type
      comment: "Type of broadcast integration included in the term (e.g. title card, verbal mention, lower third) for media value analysis."
  measures:
    - name: "total_contract_fee"
      expr: SUM(CAST(total_contract_fee AS DOUBLE))
      comment: "Total contract fee across all deal terms. Primary revenue commitment metric for finance and partnership leadership."
    - name: "total_cash_fee_amount"
      expr: SUM(CAST(cash_fee_amount AS DOUBLE))
      comment: "Total cash component of deal terms, used to separate cash revenue from value-in-kind for financial reporting."
    - name: "total_vik_amount"
      expr: SUM(CAST(vik_amount AS DOUBLE))
      comment: "Total value-in-kind (VIK) across deal terms, used to quantify non-cash sponsorship contributions."
    - name: "cash_to_vik_ratio"
      expr: ROUND(SUM(CAST(cash_fee_amount AS DOUBLE)) / NULLIF(SUM(CAST(vik_amount AS DOUBLE)), 0), 4)
      comment: "Ratio of cash fees to VIK value, indicating the cash quality of the sponsorship portfolio."
    - name: "total_performance_bonus_amount"
      expr: SUM(CAST(performance_bonus_amount AS DOUBLE))
      comment: "Total performance bonus exposure across deal terms, used to forecast upside revenue from KPI over-delivery."
    - name: "avg_cpm_rate"
      expr: AVG(CAST(cpm_rate AS DOUBLE))
      comment: "Average CPM rate across deal terms, used to benchmark pricing against market rates."
    - name: "avg_escalation_rate_pct"
      expr: AVG(CAST(escalation_rate_pct AS DOUBLE))
      comment: "Average annual escalation rate across deal terms, used to project future contract value growth."
    - name: "avg_late_payment_penalty_rate_pct"
      expr: AVG(CAST(late_payment_penalty_rate_pct AS DOUBLE))
      comment: "Average late payment penalty rate across terms, used to assess collections risk and penalty exposure."
    - name: "total_grp_delivery_commitment"
      expr: SUM(CAST(grp_delivery_commitment AS DOUBLE))
      comment: "Total GRP delivery commitment across deal terms, used to validate broadcast capacity against contractual obligations."
    - name: "deal_term_count"
      expr: COUNT(DISTINCT deal_term_id)
      comment: "Number of distinct deal terms, used to track contractual complexity and operational workload."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_naming_right`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Naming rights portfolio KPIs — annual fees, total contract value, escalation rates, ROI targets, and compliance flags. Used by venue operations, legal, and executive leadership to manage high-value long-term naming rights agreements."
  source: "`sports_entertainment_ecm`.`sponsorship`.`naming_right`"
  dimensions:
    - name: "agreement_status"
      expr: agreement_status
      comment: "Current status of the naming rights agreement (e.g. active, expired, negotiating) for portfolio health monitoring."
    - name: "agreement_type"
      expr: agreement_type
      comment: "Type of naming rights agreement (e.g. venue, field, court, practice facility) for asset-class segmentation."
    - name: "named_asset_type"
      expr: named_asset_type
      comment: "Type of asset being named (e.g. stadium, arena, training center) for portfolio composition analysis."
    - name: "exclusivity_category"
      expr: exclusivity_category
      comment: "Industry category for which exclusivity is granted under the naming rights agreement."
    - name: "payment_schedule_type"
      expr: payment_schedule_type
      comment: "Payment cadence for the naming rights fee (e.g. annual, quarterly) for cash flow planning."
    - name: "renewal_option_flag"
      expr: renewal_option_flag
      comment: "Indicates whether the agreement includes a renewal option, used to forecast future naming rights pipeline."
    - name: "sox_reportable_flag"
      expr: sox_reportable_flag
      comment: "Indicates whether the agreement is SOX-reportable, used for financial controls and audit compliance."
    - name: "gdpr_compliant_flag"
      expr: gdpr_compliant_flag
      comment: "Indicates GDPR compliance status of the agreement, relevant for data-sharing provisions."
    - name: "effective_start_date"
      expr: DATE_TRUNC('year', effective_start_date)
      comment: "Year the naming rights agreement becomes effective, used for vintage and cohort analysis."
    - name: "fee_currency_code"
      expr: fee_currency_code
      comment: "Currency in which the naming rights fee is denominated for multi-currency portfolio reporting."
  measures:
    - name: "total_contract_value"
      expr: SUM(CAST(total_fee_amount AS DOUBLE))
      comment: "Total naming rights contract value across all agreements. Highest-value sponsorship asset KPI for executive reporting."
    - name: "total_annual_fee_amount"
      expr: SUM(CAST(annual_fee_amount AS DOUBLE))
      comment: "Total annualized naming rights fees, used for year-over-year revenue comparison and budget planning."
    - name: "avg_annual_fee_amount"
      expr: AVG(CAST(annual_fee_amount AS DOUBLE))
      comment: "Average annual naming rights fee per agreement, benchmarking deal quality against market comparables."
    - name: "total_activation_budget"
      expr: SUM(CAST(activation_budget_amount AS DOUBLE))
      comment: "Total activation budget committed under naming rights agreements, used to plan activation spend and ROI."
    - name: "avg_fee_escalation_rate"
      expr: AVG(CAST(fee_escalation_rate AS DOUBLE))
      comment: "Average annual fee escalation rate across naming rights agreements, used to project future revenue growth."
    - name: "avg_roi_target_pct"
      expr: AVG(CAST(roi_target_pct AS DOUBLE))
      comment: "Average ROI target percentage across naming rights agreements, used to benchmark sponsor return expectations."
    - name: "total_termination_fee_exposure"
      expr: SUM(CAST(termination_fee_amount AS DOUBLE))
      comment: "Total termination fee exposure across naming rights agreements, quantifying financial risk from early termination."
    - name: "total_grp_commitment"
      expr: SUM(CAST(grp_commitment AS DOUBLE))
      comment: "Total GRP commitment under naming rights agreements, used to validate broadcast delivery obligations."
    - name: "naming_right_count"
      expr: COUNT(DISTINCT naming_right_id)
      comment: "Number of distinct naming rights agreements, used to track portfolio size and asset coverage."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_inventory_allocation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sponsorship inventory allocation efficiency KPIs — allocated vs. delivered impressions, allocation value, utilization rates, and makegood exposure. Used by inventory management, sales, and operations to optimize inventory yield and delivery."
  source: "`sports_entertainment_ecm`.`sponsorship`.`inventory_allocation`"
  dimensions:
    - name: "allocation_status"
      expr: allocation_status
      comment: "Current status of the inventory allocation (e.g. confirmed, pending, cancelled, delivered) for pipeline management."
    - name: "inventory_type"
      expr: inventory_type
      comment: "Type of inventory allocated (e.g. broadcast, digital, in-venue) for channel-level yield analysis."
    - name: "channel"
      expr: channel
      comment: "Distribution channel for the allocated inventory, used for channel mix and revenue attribution."
    - name: "exclusivity_category"
      expr: exclusivity_category
      comment: "Exclusivity category of the allocated inventory, used for conflict management and premium pricing analysis."
    - name: "exclusivity_flag"
      expr: exclusivity_flag
      comment: "Indicates whether the allocation carries exclusivity, used to quantify exclusivity premium in inventory pricing."
    - name: "priority_tier"
      expr: priority_tier
      comment: "Priority tier of the allocation (e.g. premium, standard, remnant) for yield management analysis."
    - name: "make_good_flag"
      expr: make_good_flag
      comment: "Indicates whether this allocation is a makegood, used to track remediation inventory separately from primary allocations."
    - name: "geographic_market"
      expr: geographic_market
      comment: "Geographic market for the allocation, used for regional inventory utilization and revenue analysis."
    - name: "delivery_start_date"
      expr: DATE_TRUNC('month', delivery_start_date)
      comment: "Month delivery begins, used for inventory utilization trend and seasonal analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the allocation value for multi-currency inventory reporting."
  measures:
    - name: "total_allocated_value"
      expr: SUM(CAST(allocated_value AS DOUBLE))
      comment: "Total value of allocated sponsorship inventory. Primary inventory revenue pipeline KPI for sales and finance."
    - name: "total_rate_card_value"
      expr: SUM(CAST(rate_card_value AS DOUBLE))
      comment: "Total rate card value of allocated inventory, used to calculate discount-to-rate-card and yield efficiency."
    - name: "allocation_yield_pct"
      expr: ROUND(100.0 * SUM(CAST(allocated_value AS DOUBLE)) / NULLIF(SUM(CAST(rate_card_value AS DOUBLE)), 0), 2)
      comment: "Percentage of rate card value realized through allocations. Inventory pricing efficiency KPI for revenue management."
    - name: "total_impression_target"
      expr: SUM(CAST(impression_target AS DOUBLE))
      comment: "Total impression target across all allocations, representing the audience delivery obligation for allocated inventory."
    - name: "total_actual_impressions_delivered"
      expr: SUM(CAST(actual_impressions_delivered AS DOUBLE))
      comment: "Total impressions actually delivered against allocations, used to measure inventory fulfillment performance."
    - name: "impression_fulfillment_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_impressions_delivered AS DOUBLE)) / NULLIF(SUM(CAST(impression_target AS DOUBLE)), 0), 2)
      comment: "Percentage of targeted impressions delivered across allocations. Core inventory delivery KPI for operations."
    - name: "avg_cpm_rate"
      expr: AVG(CAST(cpm_rate AS DOUBLE))
      comment: "Average CPM rate across inventory allocations, benchmarking pricing against market and rate card."
    - name: "makegood_allocation_count"
      expr: COUNT(DISTINCT CASE WHEN make_good_flag = TRUE THEN inventory_allocation_id END)
      comment: "Number of makegood allocations, quantifying remediation inventory consumption and delivery liability."
    - name: "total_grp_target"
      expr: SUM(CAST(grp_target AS DOUBLE))
      comment: "Total GRP target across inventory allocations, used to validate broadcast capacity planning."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_sponsor`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sponsor portfolio and relationship health KPIs — annual investment, renewal probability, VIK value, and account tier distribution. Used by partnership sales, CRM, and executive leadership to manage sponsor relationships and revenue growth."
  source: "`sports_entertainment_ecm`.`sponsorship`.`sponsor`"
  dimensions:
    - name: "account_tier"
      expr: account_tier
      comment: "Tier classification of the sponsor account (e.g. platinum, gold, silver) for portfolio segmentation and prioritization."
    - name: "industry_category"
      expr: industry_category
      comment: "Industry category of the sponsor (e.g. automotive, financial services, beverage) for category mix analysis."
    - name: "relationship_status"
      expr: relationship_status
      comment: "Current relationship status (e.g. active, at-risk, churned, prospecting) for retention and pipeline management."
    - name: "exclusivity_category"
      expr: exclusivity_category
      comment: "Category for which the sponsor holds exclusivity, used for conflict management and premium pricing."
    - name: "headquarters_country"
      expr: headquarters_country
      comment: "Country of sponsor headquarters for geographic revenue distribution analysis."
    - name: "activation_region"
      expr: activation_region
      comment: "Region where the sponsor activates, used for regional revenue and market penetration analysis."
    - name: "category_exclusivity_flag"
      expr: category_exclusivity_flag
      comment: "Indicates whether the sponsor holds category exclusivity, used to quantify exclusivity premium in the portfolio."
    - name: "naming_rights_flag"
      expr: naming_rights_flag
      comment: "Indicates whether the sponsor holds naming rights, used to identify highest-value sponsor relationships."
    - name: "nil_partnership_flag"
      expr: nil_partnership_flag
      comment: "Indicates whether the sponsor has NIL athlete partnerships, relevant for athlete-linked sponsorship valuation."
    - name: "relationship_start_date"
      expr: DATE_TRUNC('year', relationship_start_date)
      comment: "Year the sponsor relationship began, used for cohort analysis and tenure-based retention modeling."
  measures:
    - name: "total_annual_investment_usd"
      expr: SUM(CAST(annual_investment_usd AS DOUBLE))
      comment: "Total annual sponsorship investment across all sponsors. Primary revenue KPI for partnership sales and CFO reporting."
    - name: "avg_annual_investment_usd"
      expr: AVG(CAST(annual_investment_usd AS DOUBLE))
      comment: "Average annual investment per sponsor, used to benchmark account quality and identify upsell opportunities."
    - name: "total_value_in_kind_usd"
      expr: SUM(CAST(value_in_kind_usd AS DOUBLE))
      comment: "Total value-in-kind contributions from sponsors, used to quantify non-cash sponsorship value in the portfolio."
    - name: "avg_renewal_probability"
      expr: AVG(CAST(renewal_probability AS DOUBLE))
      comment: "Average renewal probability across sponsors, used to forecast future revenue retention and pipeline risk."
    - name: "sponsor_count"
      expr: COUNT(DISTINCT sponsor_id)
      comment: "Number of distinct sponsors in the portfolio, used to track portfolio size and market penetration."
    - name: "at_risk_sponsor_count"
      expr: COUNT(DISTINCT CASE WHEN relationship_status = 'at-risk' THEN sponsor_id END)
      comment: "Number of sponsors flagged as at-risk, used to prioritize retention actions and quantify revenue churn exposure."
    - name: "exclusivity_sponsor_count"
      expr: COUNT(DISTINCT CASE WHEN category_exclusivity_flag = TRUE THEN sponsor_id END)
      comment: "Number of sponsors holding category exclusivity, used to assess exclusivity premium concentration and conflict risk."
    - name: "cash_to_vik_investment_ratio"
      expr: ROUND(SUM(CAST(annual_investment_usd AS DOUBLE)) / NULLIF(SUM(CAST(value_in_kind_usd AS DOUBLE)), 0), 4)
      comment: "Ratio of cash investment to VIK value across the sponsor portfolio, indicating cash quality of the revenue base."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`sponsorship_ad_inventory`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Ad inventory valuation and availability KPIs — assessed value, list price, CPM benchmarks, estimated impressions, and GRP ratings. Used by inventory management, revenue operations, and sales to price, package, and optimize sponsorship inventory."
  source: "`sports_entertainment_ecm`.`sponsorship`.`ad_inventory`"
  dimensions:
    - name: "asset_type"
      expr: asset_type
      comment: "Type of ad inventory asset (e.g. broadcast spot, digital banner, in-venue signage) for inventory mix analysis."
    - name: "availability_status"
      expr: availability_status
      comment: "Current availability status of the inventory unit (e.g. available, sold, reserved) for sell-through analysis."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of the inventory asset for compliance and readiness tracking."
    - name: "sponsor_category"
      expr: sponsor_category
      comment: "Sponsor industry category eligible for this inventory, used for category conflict management and targeted sales."
    - name: "exclusivity_category"
      expr: exclusivity_category
      comment: "Exclusivity category associated with the inventory, used for premium pricing and conflict management."
    - name: "is_digital"
      expr: is_digital
      comment: "Indicates whether the inventory is digital, used to segment digital vs. physical inventory performance."
    - name: "is_broadcast_integrated"
      expr: is_broadcast_integrated
      comment: "Indicates whether the inventory includes broadcast integration, used for media value premium analysis."
    - name: "is_naming_rights"
      expr: is_naming_rights
      comment: "Indicates whether the inventory is a naming rights asset, used to isolate highest-value inventory."
    - name: "valuation_methodology"
      expr: valuation_methodology
      comment: "Methodology used to value the inventory (e.g. comparable, CPM-based, proprietary) for valuation quality assessment."
    - name: "valuation_date"
      expr: DATE_TRUNC('year', valuation_date)
      comment: "Year of the most recent valuation, used to identify stale valuations requiring refresh."
  measures:
    - name: "total_assessed_value"
      expr: SUM(CAST(assessed_value_per_unit AS DOUBLE))
      comment: "Total assessed value of ad inventory units. Primary inventory portfolio valuation KPI for revenue operations."
    - name: "total_list_price_value"
      expr: SUM(CAST(list_price_per_unit AS DOUBLE))
      comment: "Total list price value of ad inventory, used as the ceiling for yield and discount analysis."
    - name: "avg_cpm_benchmark"
      expr: AVG(CAST(cpm_benchmark AS DOUBLE))
      comment: "Average CPM benchmark across inventory units, used to price new inventory and validate existing rates."
    - name: "total_estimated_impressions"
      expr: SUM(CAST(estimated_impressions AS DOUBLE))
      comment: "Total estimated impressions across all inventory units, representing the total audience delivery capacity of the portfolio."
    - name: "avg_grp_rating"
      expr: AVG(CAST(grp_rating AS DOUBLE))
      comment: "Average GRP rating across inventory units, used to benchmark broadcast inventory quality and pricing."
    - name: "inventory_unit_count"
      expr: COUNT(DISTINCT ad_inventory_id)
      comment: "Number of distinct ad inventory units, used to track portfolio size and capacity planning."
    - name: "value_to_list_price_ratio"
      expr: ROUND(SUM(CAST(assessed_value_per_unit AS DOUBLE)) / NULLIF(SUM(CAST(list_price_per_unit AS DOUBLE)), 0), 4)
      comment: "Ratio of assessed value to list price across inventory, indicating pricing accuracy and market alignment."
$$;