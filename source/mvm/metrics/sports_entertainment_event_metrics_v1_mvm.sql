-- Metric views for domain: event | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_fixture`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core event fixture metrics tracking scheduling, broadcast eligibility, and match outcomes across leagues, seasons, and venues. Used by operations and strategy teams to monitor fixture pipeline health and broadcast monetization."
  source: "`sports_entertainment_ecm`.`event`.`fixture`"
  dimensions:
    - name: "event_date"
      expr: event_date
      comment: "Calendar date of the fixture, used for time-series trending of fixture volume and outcomes."
    - name: "event_classification"
      expr: event_classification
      comment: "Classification of the event (e.g. regular season, playoff, friendly) for segmenting KPIs by competitive tier."
    - name: "event_tier"
      expr: event_tier
      comment: "Tier designation of the event (e.g. Tier 1, Tier 2) enabling prioritization and resource allocation analysis."
    - name: "lifecycle_status"
      expr: lifecycle_status
      comment: "Current lifecycle state of the fixture (e.g. scheduled, confirmed, cancelled, completed) for pipeline health monitoring."
    - name: "result_status"
      expr: result_status
      comment: "Outcome result status of the fixture (e.g. final, postponed, abandoned) for operational reporting."
    - name: "is_broadcast_eligible"
      expr: is_broadcast_eligible
      comment: "Flag indicating whether the fixture qualifies for broadcast, used to assess broadcast inventory."
    - name: "is_ppv"
      expr: is_ppv
      comment: "Flag indicating pay-per-view designation, used to segment revenue model analysis."
    - name: "is_neutral_site"
      expr: is_neutral_site
      comment: "Flag indicating whether the fixture is played at a neutral venue, relevant for attendance and revenue benchmarking."
    - name: "surface_type"
      expr: surface_type
      comment: "Playing surface type (e.g. grass, turf, hardwood) for performance and safety analytics."
    - name: "weather_condition"
      expr: weather_condition
      comment: "Weather condition at time of fixture, used for operational risk and attendance impact analysis."
    - name: "var_used"
      expr: var_used
      comment: "Flag indicating whether VAR (Video Assistant Referee) technology was used, for officiating quality analysis."
    - name: "extra_time_played"
      expr: extra_time_played
      comment: "Flag indicating whether extra time was played, relevant for broadcast scheduling and production cost analysis."
    - name: "penalty_shootout"
      expr: penalty_shootout
      comment: "Flag indicating whether a penalty shootout occurred, used for competitive outcome and fan engagement analysis."
    - name: "matchday_number"
      expr: matchday_number
      comment: "Matchday number within the season or competition round, enabling week-over-week performance tracking."
    - name: "source_system_code"
      expr: source_system_code
      comment: "Source system originating the fixture record, used for data lineage and reconciliation."
  measures:
    - name: "total_fixtures_scheduled"
      expr: COUNT(1)
      comment: "Total number of fixtures in the dataset. Baseline volume metric for scheduling pipeline and capacity planning."
    - name: "broadcast_eligible_fixture_count"
      expr: COUNT(CASE WHEN is_broadcast_eligible = TRUE THEN fixture_id END)
      comment: "Number of fixtures eligible for broadcast. Directly informs broadcast inventory and media rights utilization decisions."
    - name: "ppv_fixture_count"
      expr: COUNT(CASE WHEN is_ppv = TRUE THEN fixture_id END)
      comment: "Number of pay-per-view fixtures. Drives PPV revenue forecasting and pricing strategy decisions."
    - name: "cancelled_fixture_count"
      expr: COUNT(CASE WHEN lifecycle_status = 'cancelled' THEN fixture_id END)
      comment: "Number of cancelled fixtures. A rising cancellation rate signals operational risk, insurance exposure, and fan experience degradation."
    - name: "broadcast_eligibility_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_broadcast_eligible = TRUE THEN fixture_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fixtures that are broadcast eligible. Key indicator of media rights monetization potential across the fixture calendar."
    - name: "cancellation_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN lifecycle_status = 'cancelled' THEN fixture_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fixtures that were cancelled. Operational risk KPI tracked by league operations and insurance teams."
    - name: "extra_time_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN extra_time_played = TRUE THEN fixture_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fixtures that went to extra time. Impacts broadcast scheduling overruns, production costs, and fan engagement patterns."
    - name: "penalty_shootout_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN penalty_shootout = TRUE THEN fixture_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fixtures decided by penalty shootout. Competitive drama indicator used in fan engagement and broadcast highlight planning."
    - name: "var_usage_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN var_used = TRUE THEN fixture_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fixtures where VAR was used. Officiating technology adoption KPI tracked by league governance and broadcast teams."
    - name: "neutral_site_fixture_count"
      expr: COUNT(CASE WHEN is_neutral_site = TRUE THEN fixture_id END)
      comment: "Number of fixtures played at neutral venues. Relevant for venue revenue sharing, attendance benchmarking, and event hosting strategy."
    - name: "distinct_venues_used"
      expr: COUNT(DISTINCT venue_id)
      comment: "Number of distinct venues hosting fixtures. Measures geographic and venue portfolio utilization across the event calendar."
    - name: "distinct_seasons_covered"
      expr: COUNT(DISTINCT season_id)
      comment: "Number of distinct seasons represented in the fixture dataset. Used for multi-season trend analysis and calendar planning."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_match_result`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Match result metrics capturing competitive outcomes, officiating interventions, and doping control compliance. Used by league operations, broadcast, and compliance teams to evaluate match quality and integrity."
  source: "`sports_entertainment_ecm`.`event`.`match_result`"
  dimensions:
    - name: "match_date"
      expr: match_date
      comment: "Date the match was played, enabling time-series analysis of results and trends."
    - name: "match_outcome"
      expr: match_outcome
      comment: "Final outcome of the match (e.g. home win, away win, draw) for competitive balance analysis."
    - name: "result_status"
      expr: result_status
      comment: "Confirmation status of the result (e.g. confirmed, protested, under review) for data quality and integrity monitoring."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport discipline of the match, enabling cross-sport performance benchmarking."
    - name: "overtime_played"
      expr: overtime_played
      comment: "Flag indicating whether overtime was played, relevant for broadcast scheduling and competitive analysis."
    - name: "shootout_played"
      expr: shootout_played
      comment: "Flag indicating whether a shootout was played to determine the result."
    - name: "var_intervention"
      expr: var_intervention
      comment: "Flag indicating whether VAR intervened in the match, used for officiating quality and technology ROI analysis."
    - name: "doping_control_conducted"
      expr: doping_control_conducted
      comment: "Flag indicating whether doping control was conducted post-match, for compliance and regulatory reporting."
    - name: "neutral_venue"
      expr: neutral_venue
      comment: "Flag indicating whether the match was played at a neutral venue."
    - name: "pitch_condition"
      expr: pitch_condition
      comment: "Condition of the playing surface at match time, used for performance and safety analytics."
    - name: "weather_condition"
      expr: weather_condition
      comment: "Weather conditions during the match, used for operational risk and performance correlation analysis."
    - name: "result_source_system"
      expr: result_source_system
      comment: "Source system that provided the result data, used for data lineage and reconciliation."
  measures:
    - name: "total_matches_played"
      expr: COUNT(1)
      comment: "Total number of match results recorded. Baseline volume metric for competitive calendar completeness."
    - name: "overtime_match_count"
      expr: COUNT(CASE WHEN overtime_played = TRUE THEN match_result_id END)
      comment: "Number of matches that went to overtime. Impacts broadcast scheduling, production costs, and fan engagement."
    - name: "shootout_match_count"
      expr: COUNT(CASE WHEN shootout_played = TRUE THEN match_result_id END)
      comment: "Number of matches decided by shootout. High-drama outcome metric used in broadcast highlight and fan engagement planning."
    - name: "var_intervention_count_total"
      expr: COUNT(CASE WHEN var_intervention = TRUE THEN match_result_id END)
      comment: "Number of matches with at least one VAR intervention. Officiating technology utilization KPI for league governance."
    - name: "doping_control_compliance_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN doping_control_conducted = TRUE THEN match_result_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of matches where doping control was conducted. Critical compliance KPI for WADA and governing body reporting."
    - name: "var_intervention_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN var_intervention = TRUE THEN match_result_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of matches with VAR intervention. Tracks officiating technology impact and potential match flow disruption."
    - name: "overtime_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN overtime_played = TRUE THEN match_result_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of matches going to overtime. Competitive intensity indicator and broadcast scheduling risk metric."
    - name: "protested_result_count"
      expr: COUNT(CASE WHEN protest_reference IS NOT NULL THEN match_result_id END)
      comment: "Number of matches with a formal protest filed. Integrity and governance KPI monitored by league disciplinary bodies."
    - name: "distinct_fixtures_with_results"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct fixtures that have a recorded match result. Used to measure result capture completeness against scheduled fixtures."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_broadcast_window`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Broadcast window metrics covering rights fee allocation, viewership forecasting, exclusivity, and platform coverage. Used by media rights, commercial, and broadcast operations teams to optimize broadcast inventory and revenue."
  source: "`sports_entertainment_ecm`.`event`.`broadcast_window`"
  dimensions:
    - name: "broadcast_kickoff_timestamp"
      expr: DATE_TRUNC('day', broadcast_kickoff_timestamp)
      comment: "Broadcast kickoff date (day-truncated) for time-series analysis of broadcast scheduling."
    - name: "window_type"
      expr: window_type
      comment: "Type of broadcast window (e.g. live, delayed, highlights) for rights and revenue segmentation."
    - name: "window_status"
      expr: window_status
      comment: "Current status of the broadcast window (e.g. confirmed, cancelled, pending) for pipeline health monitoring."
    - name: "broadcast_format"
      expr: broadcast_format
      comment: "Format of the broadcast (e.g. HD, 4K, SD) for production quality and cost analysis."
    - name: "exclusivity_type"
      expr: exclusivity_type
      comment: "Exclusivity classification of the broadcast rights (e.g. exclusive, non-exclusive, sub-licensed) for commercial strategy."
    - name: "is_exclusive"
      expr: is_exclusive
      comment: "Flag indicating exclusive broadcast rights, used to assess premium rights value and competitive positioning."
    - name: "is_free_to_air"
      expr: is_free_to_air
      comment: "Flag indicating free-to-air broadcast, relevant for audience reach and rights fee benchmarking."
    - name: "is_ppv"
      expr: is_ppv
      comment: "Flag indicating pay-per-view broadcast, used for PPV revenue model analysis."
    - name: "digital_streaming_included"
      expr: digital_streaming_included
      comment: "Flag indicating whether digital streaming rights are included in the window, for OTT strategy analysis."
    - name: "territory_code"
      expr: territory_code
      comment: "Territory code for the broadcast window, enabling geographic rights and revenue analysis."
    - name: "territory_region"
      expr: territory_region
      comment: "Regional grouping of the broadcast territory for macro-level rights portfolio analysis."
    - name: "production_type"
      expr: production_type
      comment: "Type of production associated with the broadcast window (e.g. live OB, studio, remote) for cost benchmarking."
    - name: "coverage_status"
      expr: coverage_status
      comment: "Coverage status of the broadcast window (e.g. covered, uncovered, partial) for rights gap analysis."
    - name: "blackout_applicable"
      expr: blackout_applicable
      comment: "Flag indicating whether blackout restrictions apply, relevant for regional rights compliance."
    - name: "highlights_rights_included"
      expr: highlights_rights_included
      comment: "Flag indicating whether highlights rights are included, for content monetization strategy."
  measures:
    - name: "total_broadcast_windows"
      expr: COUNT(1)
      comment: "Total number of broadcast windows. Baseline inventory metric for media rights and scheduling teams."
    - name: "total_rights_fee_amount"
      expr: SUM(CAST(rights_fee_amount AS DOUBLE))
      comment: "Total rights fee value across all broadcast windows. Primary revenue KPI for media rights commercial teams."
    - name: "total_rights_fee_allocation"
      expr: SUM(CAST(rights_fee_allocation AS DOUBLE))
      comment: "Total allocated rights fee value across broadcast windows. Used to reconcile rights fee commitments against allocations."
    - name: "avg_rights_fee_per_window"
      expr: AVG(CAST(rights_fee_amount AS DOUBLE))
      comment: "Average rights fee per broadcast window. Benchmarking KPI for negotiating future media rights deals."
    - name: "total_expected_viewership"
      expr: SUM(CAST(expected_viewership AS DOUBLE))
      comment: "Total expected viewership across all broadcast windows. Audience reach KPI used in sponsorship valuation and rights pricing."
    - name: "avg_expected_viewership_per_window"
      expr: AVG(CAST(expected_viewership AS DOUBLE))
      comment: "Average expected viewership per broadcast window. Used to benchmark audience reach by territory, format, and exclusivity type."
    - name: "exclusive_window_count"
      expr: COUNT(CASE WHEN is_exclusive = TRUE THEN broadcast_window_id END)
      comment: "Number of exclusive broadcast windows. Measures premium rights inventory depth for commercial strategy."
    - name: "ppv_window_count"
      expr: COUNT(CASE WHEN is_ppv = TRUE THEN broadcast_window_id END)
      comment: "Number of PPV broadcast windows. Drives PPV revenue forecasting and pricing decisions."
    - name: "digital_streaming_window_count"
      expr: COUNT(CASE WHEN digital_streaming_included = TRUE THEN broadcast_window_id END)
      comment: "Number of windows with digital streaming rights included. OTT strategy and digital rights monetization KPI."
    - name: "blackout_applicable_window_count"
      expr: COUNT(CASE WHEN blackout_applicable = TRUE THEN broadcast_window_id END)
      comment: "Number of broadcast windows subject to blackout restrictions. Compliance and regional rights management KPI."
    - name: "rights_fee_allocation_utilization_rate"
      expr: ROUND(100.0 * SUM(CAST(rights_fee_allocation AS DOUBLE)) / NULLIF(SUM(CAST(rights_fee_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of rights fee amount that has been allocated. Measures commercial deal execution completeness and revenue recognition readiness."
    - name: "distinct_territories_covered"
      expr: COUNT(DISTINCT territory_code)
      comment: "Number of distinct territories with broadcast windows. Geographic rights coverage breadth metric for global distribution strategy."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_tournament`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tournament-level metrics covering prize pool investment, budget performance, compliance, and commercial activation. Used by league executives, finance, and commercial teams to evaluate tournament portfolio value and operational efficiency."
  source: "`sports_entertainment_ecm`.`event`.`tournament`"
  dimensions:
    - name: "start_date"
      expr: start_date
      comment: "Tournament start date for time-series and seasonal analysis of tournament activity."
    - name: "tournament_status"
      expr: tournament_status
      comment: "Current status of the tournament (e.g. active, completed, cancelled) for pipeline health monitoring."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport discipline of the tournament for cross-sport portfolio analysis."
    - name: "format_type"
      expr: format_type
      comment: "Tournament format (e.g. knockout, round-robin, league) for competitive structure analysis."
    - name: "gender_category"
      expr: gender_category
      comment: "Gender category of the tournament for equity and investment analysis across gender lines."
    - name: "age_category"
      expr: age_category
      comment: "Age category of the tournament (e.g. senior, U23, youth) for talent pipeline and investment analysis."
    - name: "host_country_code"
      expr: host_country_code
      comment: "Country hosting the tournament for geographic distribution and market development analysis."
    - name: "host_region"
      expr: host_region
      comment: "Regional grouping of the host country for macro-level geographic portfolio analysis."
    - name: "recurrence_type"
      expr: recurrence_type
      comment: "Recurrence pattern of the tournament (e.g. annual, biennial) for long-term calendar and investment planning."
    - name: "ticket_sales_enabled"
      expr: ticket_sales_enabled
      comment: "Flag indicating whether ticket sales are enabled for the tournament, for revenue channel analysis."
    - name: "wada_compliance_required"
      expr: wada_compliance_required
      comment: "Flag indicating WADA compliance requirement, for regulatory and anti-doping governance reporting."
    - name: "sustainability_certified"
      expr: sustainability_certified
      comment: "Flag indicating sustainability certification status, for ESG reporting and brand positioning."
    - name: "prize_pool_currency_code"
      expr: prize_pool_currency_code
      comment: "Currency of the prize pool for multi-currency financial normalization."
    - name: "qualification_method"
      expr: qualification_method
      comment: "Method used to qualify participants (e.g. ranking, wildcard, regional qualifier) for competitive integrity analysis."
  measures:
    - name: "total_tournaments"
      expr: COUNT(1)
      comment: "Total number of tournaments. Baseline portfolio volume metric for league and commercial planning."
    - name: "total_prize_pool_amount"
      expr: SUM(CAST(prize_pool_amount AS DOUBLE))
      comment: "Total prize pool value across all tournaments. Key investment and athlete incentive KPI for league executives and commercial teams."
    - name: "avg_prize_pool_per_tournament"
      expr: AVG(CAST(prize_pool_amount AS DOUBLE))
      comment: "Average prize pool per tournament. Benchmarking KPI for competitive investment levels across tournament tiers and sports."
    - name: "total_planned_budget"
      expr: SUM(CAST(planned_amount AS DOUBLE))
      comment: "Total planned budget across all tournaments. Financial planning baseline for tournament portfolio investment."
    - name: "total_actual_spend"
      expr: SUM(CAST(actuals_amount AS DOUBLE))
      comment: "Total actual spend across all tournaments. Financial performance KPI compared against planned budget."
    - name: "total_revised_budget"
      expr: SUM(CAST(revised_amount AS DOUBLE))
      comment: "Total revised budget across all tournaments. Tracks budget reforecasting activity and financial agility."
    - name: "budget_variance_amount"
      expr: SUM(actuals_amount - planned_amount)
      comment: "Total budget variance (actuals minus planned) across tournaments. Negative values indicate underspend; positive values indicate overspend. Critical financial control KPI."
    - name: "budget_utilization_rate"
      expr: ROUND(100.0 * SUM(CAST(actuals_amount AS DOUBLE)) / NULLIF(SUM(CAST(planned_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of planned budget actually spent across tournaments. Financial efficiency KPI for tournament operations and finance teams."
    - name: "wada_compliant_tournament_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN wada_compliance_required = TRUE THEN tournament_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tournaments requiring WADA compliance. Regulatory coverage KPI for anti-doping governance reporting."
    - name: "sustainability_certified_tournament_count"
      expr: COUNT(CASE WHEN sustainability_certified = TRUE THEN tournament_id END)
      comment: "Number of sustainability-certified tournaments. ESG performance KPI for brand and stakeholder reporting."
    - name: "ticket_sales_enabled_tournament_count"
      expr: COUNT(CASE WHEN ticket_sales_enabled = TRUE THEN tournament_id END)
      comment: "Number of tournaments with ticket sales enabled. Measures live attendance revenue channel activation across the tournament portfolio."
    - name: "distinct_host_countries"
      expr: COUNT(DISTINCT host_country_code)
      comment: "Number of distinct countries hosting tournaments. Geographic diversification KPI for global market development strategy."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_officiating_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Officiating assignment metrics covering fee expenditure, performance quality, compliance, and conflict management. Used by league operations, compliance, and finance teams to govern officiating standards and cost efficiency."
  source: "`sports_entertainment_ecm`.`event`.`officiating_assignment`"
  dimensions:
    - name: "assignment_date"
      expr: assignment_date
      comment: "Date of the officiating assignment for time-series analysis of officiating activity and cost."
    - name: "assignment_status"
      expr: assignment_status
      comment: "Current status of the assignment (e.g. confirmed, pending, replaced) for pipeline health monitoring."
    - name: "official_role"
      expr: official_role
      comment: "Role of the official (e.g. referee, assistant referee, TMO) for role-based cost and performance analysis."
    - name: "assignment_method"
      expr: assignment_method
      comment: "Method used to assign the official (e.g. automated, manual, rotational) for process efficiency analysis."
    - name: "governing_body_code"
      expr: governing_body_code
      comment: "Governing body code overseeing the officiating assignment for regulatory segmentation."
    - name: "fee_currency_code"
      expr: fee_currency_code
      comment: "Currency of the officiating fee for multi-currency financial analysis."
    - name: "crew_chief_flag"
      expr: crew_chief_flag
      comment: "Flag indicating whether the official is the crew chief, for leadership and accountability analysis."
    - name: "conflict_of_interest_flag"
      expr: conflict_of_interest_flag
      comment: "Flag indicating a declared conflict of interest, critical for integrity and governance monitoring."
    - name: "disciplinary_incident_flag"
      expr: disciplinary_incident_flag
      comment: "Flag indicating a disciplinary incident associated with the assignment, for officiating quality management."
    - name: "var_enabled_flag"
      expr: var_enabled_flag
      comment: "Flag indicating VAR was enabled for the assignment, for technology adoption and cost analysis."
    - name: "tmo_enabled_flag"
      expr: tmo_enabled_flag
      comment: "Flag indicating TMO (Television Match Official) was enabled, for officiating technology utilization analysis."
    - name: "travel_required_flag"
      expr: travel_required_flag
      comment: "Flag indicating travel was required for the assignment, for cost and logistics planning."
    - name: "wada_compliance_verified_flag"
      expr: wada_compliance_verified_flag
      comment: "Flag indicating WADA compliance was verified for the official, for anti-doping governance reporting."
    - name: "post_match_report_submitted_flag"
      expr: post_match_report_submitted_flag
      comment: "Flag indicating whether the post-match report was submitted, for officiating accountability monitoring."
  measures:
    - name: "total_officiating_assignments"
      expr: COUNT(1)
      comment: "Total number of officiating assignments. Baseline volume metric for officiating resource planning."
    - name: "total_officiating_fee_amount"
      expr: SUM(CAST(officiating_fee_amount AS DOUBLE))
      comment: "Total officiating fees paid across all assignments. Primary cost KPI for officiating budget management."
    - name: "total_expense_allowance_amount"
      expr: SUM(CAST(expense_allowance_amount AS DOUBLE))
      comment: "Total expense allowances paid to officials. Secondary cost KPI for total officiating cost of delivery."
    - name: "avg_officiating_fee_per_assignment"
      expr: AVG(CAST(officiating_fee_amount AS DOUBLE))
      comment: "Average officiating fee per assignment. Benchmarking KPI for fee negotiation and budget forecasting."
    - name: "avg_performance_rating"
      expr: AVG(CAST(performance_rating AS DOUBLE))
      comment: "Average performance rating of officials across assignments. Officiating quality KPI used by league operations to manage standards and identify development needs."
    - name: "conflict_of_interest_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN conflict_of_interest_flag = TRUE THEN officiating_assignment_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assignments with a declared conflict of interest. Integrity governance KPI monitored by compliance and league disciplinary bodies."
    - name: "disciplinary_incident_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN disciplinary_incident_flag = TRUE THEN officiating_assignment_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assignments involving a disciplinary incident. Officiating quality and integrity KPI for league governance."
    - name: "post_match_report_submission_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN post_match_report_submitted_flag = TRUE THEN officiating_assignment_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assignments where the post-match report was submitted. Officiating accountability and process compliance KPI."
    - name: "wada_compliance_verification_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN wada_compliance_verified_flag = TRUE THEN officiating_assignment_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of officiating assignments with verified WADA compliance. Anti-doping regulatory KPI for governing body reporting."
    - name: "distinct_officials_assigned"
      expr: COUNT(DISTINCT official_id)
      comment: "Number of distinct officials assigned across fixtures. Measures officiating pool depth and rotation diversity."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_incident`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Event incident metrics covering safety, regulatory compliance, broadcast impact, and operational response. Used by security, compliance, and operations teams to manage event risk and regulatory obligations."
  source: "`sports_entertainment_ecm`.`event`.`event_incident`"
  dimensions:
    - name: "occurred_at_date"
      expr: DATE_TRUNC('day', occurred_at)
      comment: "Date the incident occurred (day-truncated) for time-series analysis of incident frequency and trends."
    - name: "incident_type"
      expr: incident_type
      comment: "Type of incident (e.g. medical, security, weather, technical) for categorical risk analysis."
    - name: "incident_status"
      expr: incident_status
      comment: "Current status of the incident (e.g. open, resolved, escalated) for operational response monitoring."
    - name: "severity_level"
      expr: severity_level
      comment: "Severity classification of the incident (e.g. low, medium, high, critical) for risk prioritization."
    - name: "subtype"
      expr: subtype
      comment: "Sub-classification of the incident type for granular root cause analysis."
    - name: "location_zone"
      expr: location_zone
      comment: "Zone within the venue where the incident occurred, for spatial risk analysis and venue safety planning."
    - name: "match_period"
      expr: match_period
      comment: "Match period during which the incident occurred (e.g. first half, halftime, extra time) for temporal risk analysis."
    - name: "broadcast_impact"
      expr: broadcast_impact
      comment: "Flag indicating whether the incident impacted the broadcast, for broadcast operations risk management."
    - name: "regulatory_reporting_required"
      expr: regulatory_reporting_required
      comment: "Flag indicating whether regulatory reporting is required for the incident, for compliance obligation tracking."
    - name: "regulatory_report_submitted"
      expr: regulatory_report_submitted
      comment: "Flag indicating whether the regulatory report has been submitted, for compliance deadline monitoring."
    - name: "insurance_claim_required"
      expr: insurance_claim_required
      comment: "Flag indicating whether an insurance claim is required, for financial risk and claims management."
    - name: "ped_related"
      expr: ped_related
      comment: "Flag indicating whether the incident is related to performance-enhancing drugs, for anti-doping governance."
    - name: "var_tmo_review_triggered"
      expr: var_tmo_review_triggered
      comment: "Flag indicating whether a VAR/TMO review was triggered by the incident, for officiating technology analysis."
    - name: "response_team_type"
      expr: response_team_type
      comment: "Type of response team deployed (e.g. medical, security, stewarding) for resource allocation analysis."
    - name: "weather_condition"
      expr: weather_condition
      comment: "Weather condition at time of incident, for environmental risk correlation analysis."
  measures:
    - name: "total_incidents"
      expr: COUNT(1)
      comment: "Total number of event incidents recorded. Baseline safety and risk volume metric for event operations."
    - name: "regulatory_reporting_compliance_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN regulatory_report_submitted = TRUE THEN event_incident_id END) / NULLIF(COUNT(CASE WHEN regulatory_reporting_required = TRUE THEN event_incident_id END), 0), 2)
      comment: "Percentage of incidents requiring regulatory reporting where the report has been submitted. Critical compliance KPI for governing body and regulatory obligations."
    - name: "broadcast_impacted_incident_count"
      expr: COUNT(CASE WHEN broadcast_impact = TRUE THEN event_incident_id END)
      comment: "Number of incidents that impacted the broadcast. Broadcast operations risk KPI affecting media rights obligations and advertiser commitments."
    - name: "insurance_claim_incident_count"
      expr: COUNT(CASE WHEN insurance_claim_required = TRUE THEN event_incident_id END)
      comment: "Number of incidents requiring an insurance claim. Financial risk exposure KPI for event insurance and risk management teams."
    - name: "ped_related_incident_count"
      expr: COUNT(CASE WHEN ped_related = TRUE THEN event_incident_id END)
      comment: "Number of PED-related incidents. Anti-doping integrity KPI monitored by WADA, governing bodies, and league compliance teams."
    - name: "avg_precipitation_at_incident"
      expr: AVG(CAST(precipitation_mm AS DOUBLE))
      comment: "Average precipitation (mm) at time of incident. Environmental risk KPI used to correlate weather conditions with incident frequency and severity."
    - name: "avg_temperature_at_incident"
      expr: AVG(CAST(temperature_celsius AS DOUBLE))
      comment: "Average temperature (Celsius) at time of incident. Environmental safety KPI for athlete welfare and venue operations planning."
    - name: "avg_wind_speed_at_incident"
      expr: AVG(CAST(wind_speed_kmh AS DOUBLE))
      comment: "Average wind speed (km/h) at time of incident. Environmental risk KPI for outdoor event safety and broadcast equipment planning."
    - name: "var_tmo_triggered_incident_count"
      expr: COUNT(CASE WHEN var_tmo_review_triggered = TRUE THEN event_incident_id END)
      comment: "Number of incidents that triggered a VAR/TMO review. Officiating technology utilization and match integrity KPI."
    - name: "unresolved_incident_count"
      expr: COUNT(CASE WHEN incident_status != 'resolved' THEN event_incident_id END)
      comment: "Number of incidents not yet resolved. Operational backlog KPI for event safety and security response teams."
    - name: "distinct_fixtures_with_incidents"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct fixtures that experienced at least one incident. Measures event safety risk breadth across the fixture calendar."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_participant`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Participant metrics covering appearance fees, ranking points, eligibility compliance, and lineup management. Used by athlete management, commercial, and compliance teams to govern participant engagement and investment."
  source: "`sports_entertainment_ecm`.`event`.`participant`"
  dimensions:
    - name: "participation_status"
      expr: participation_status
      comment: "Current participation status (e.g. confirmed, withdrawn, replaced) for lineup and roster management."
    - name: "participant_role"
      expr: participant_role
      comment: "Role of the participant in the event (e.g. player, performer, coach) for role-based analysis."
    - name: "entity_type"
      expr: entity_type
      comment: "Type of entity participating (e.g. athlete, team, performer) for cross-entity analysis."
    - name: "entry_method"
      expr: entry_method
      comment: "Method by which the participant entered the event (e.g. qualification, wildcard, direct entry) for competitive pathway analysis."
    - name: "contract_type"
      expr: contract_type
      comment: "Contract type governing the participant's appearance (e.g. appearance fee, revenue share) for commercial model analysis."
    - name: "appearance_fee_currency"
      expr: appearance_fee_currency
      comment: "Currency of the appearance fee for multi-currency financial analysis."
    - name: "nil_agreement_active"
      expr: nil_agreement_active
      comment: "Flag indicating an active NIL (Name, Image, Likeness) agreement, for commercial rights and athlete monetization analysis."
    - name: "lineup_confirmed"
      expr: lineup_confirmed
      comment: "Flag indicating whether the participant's lineup position is confirmed, for pre-event operational readiness monitoring."
    - name: "is_captain_or_lead"
      expr: is_captain_or_lead
      comment: "Flag indicating whether the participant is the captain or lead performer, for leadership and commercial value analysis."
    - name: "broadcast_feature_flag"
      expr: broadcast_feature_flag
      comment: "Flag indicating whether the participant is featured in broadcast content, for media rights and commercial value analysis."
    - name: "home_venue_flag"
      expr: home_venue_flag
      comment: "Flag indicating whether the participant is competing at their home venue, for home advantage and attendance analysis."
    - name: "nationality_country"
      expr: nationality_country
      comment: "Nationality of the participant for geographic diversity and international market analysis."
    - name: "media_rights_clearance_status"
      expr: media_rights_clearance_status
      comment: "Media rights clearance status for the participant, for broadcast compliance and content rights management."
  measures:
    - name: "total_participants"
      expr: COUNT(1)
      comment: "Total number of participant records. Baseline volume metric for event roster and lineup management."
    - name: "total_appearance_fee_amount"
      expr: SUM(CAST(appearance_fee_amount AS DOUBLE))
      comment: "Total appearance fees committed across all participants. Primary talent cost KPI for event commercial and finance teams."
    - name: "avg_appearance_fee_per_participant"
      expr: AVG(CAST(appearance_fee_amount AS DOUBLE))
      comment: "Average appearance fee per participant. Benchmarking KPI for talent investment levels and contract negotiation strategy."
    - name: "total_ranking_points_earned"
      expr: SUM(CAST(ranking_points_earned AS DOUBLE))
      comment: "Total ranking points earned across all participants. Competitive performance KPI used in seeding, qualification, and prize allocation decisions."
    - name: "avg_ranking_points_per_participant"
      expr: AVG(CAST(ranking_points_earned AS DOUBLE))
      comment: "Average ranking points earned per participant. Competitive quality KPI for event prestige and field strength assessment."
    - name: "withdrawal_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN participation_status = 'withdrawn' THEN participant_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of participants who withdrew from the event. Operational risk KPI affecting lineup quality, fan experience, and broadcast value."
    - name: "lineup_confirmation_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN lineup_confirmed = TRUE THEN participant_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of participants with confirmed lineup positions. Pre-event operational readiness KPI for event management teams."
    - name: "nil_agreement_active_count"
      expr: COUNT(CASE WHEN nil_agreement_active = TRUE THEN participant_id END)
      comment: "Number of participants with active NIL agreements. Commercial rights monetization KPI for athlete management and sponsorship teams."
    - name: "broadcast_featured_participant_count"
      expr: COUNT(CASE WHEN broadcast_feature_flag = TRUE THEN participant_id END)
      comment: "Number of participants featured in broadcast content. Media rights and commercial value KPI for broadcast production planning."
    - name: "distinct_fixtures_with_participants"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct fixtures with participant records. Measures participant data coverage completeness across the event calendar."
    - name: "distinct_nationalities_represented"
      expr: COUNT(DISTINCT nationality_country)
      comment: "Number of distinct nationalities represented across participants. International diversity KPI for global market development and broadcast rights strategy."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_scoring_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Scoring event metrics capturing goal and point production, VAR review outcomes, and competitive dynamics. Used by broadcast, analytics, and commercial teams to evaluate match entertainment value and officiating technology impact."
  source: "`sports_entertainment_ecm`.`event`.`scoring_event`"
  dimensions:
    - name: "event_timestamp_date"
      expr: DATE_TRUNC('day', event_timestamp)
      comment: "Date of the scoring event (day-truncated) for time-series analysis of scoring activity."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport discipline of the scoring event for cross-sport scoring analysis."
    - name: "scoring_method"
      expr: scoring_method
      comment: "Method by which the score was achieved (e.g. open play, set piece, penalty) for tactical and entertainment analysis."
    - name: "period_type"
      expr: period_type
      comment: "Period type in which the scoring event occurred (e.g. regular, extra time, shootout) for temporal scoring analysis."
    - name: "period_number"
      expr: period_number
      comment: "Period number in which the scoring event occurred for granular match phase analysis."
    - name: "competition_phase"
      expr: competition_phase
      comment: "Competition phase (e.g. group stage, knockout, final) for phase-based scoring pattern analysis."
    - name: "pitch_zone"
      expr: pitch_zone
      comment: "Zone of the pitch from which the scoring event originated for spatial analytics and tactical insights."
    - name: "body_part"
      expr: body_part
      comment: "Body part used to score (e.g. right foot, left foot, header) for player performance and scouting analytics."
    - name: "play_pattern"
      expr: play_pattern
      comment: "Pattern of play leading to the scoring event (e.g. counter-attack, set piece, open play) for tactical analysis."
    - name: "is_own_goal"
      expr: is_own_goal
      comment: "Flag indicating whether the scoring event was an own goal, for accurate team attribution and competitive analysis."
    - name: "is_lead_change"
      expr: is_lead_change
      comment: "Flag indicating whether the scoring event changed the match lead, for competitive drama and fan engagement analysis."
    - name: "is_tie"
      expr: is_tie
      comment: "Flag indicating whether the scoring event resulted in a tie score, for competitive balance analysis."
    - name: "var_review_flag"
      expr: var_review_flag
      comment: "Flag indicating whether the scoring event was subject to a VAR review, for officiating technology impact analysis."
    - name: "var_review_outcome"
      expr: var_review_outcome
      comment: "Outcome of the VAR review (e.g. upheld, overturned, no action) for officiating quality and technology ROI analysis."
    - name: "event_status"
      expr: event_status
      comment: "Confirmation status of the scoring event (e.g. confirmed, under review, disallowed) for data quality monitoring."
  measures:
    - name: "total_scoring_events"
      expr: COUNT(1)
      comment: "Total number of scoring events recorded. Baseline entertainment and competitive volume metric."
    - name: "total_coordinate_x_sum"
      expr: SUM(CAST(coordinate_x AS DOUBLE))
      comment: "Sum of X-coordinates of scoring events. Used with count to derive average scoring position for spatial analytics and tactical planning."
    - name: "avg_scoring_coordinate_x"
      expr: AVG(CAST(coordinate_x AS DOUBLE))
      comment: "Average X-coordinate of scoring events on the pitch. Spatial analytics KPI for tactical analysis and broadcast graphics production."
    - name: "avg_scoring_coordinate_y"
      expr: AVG(CAST(coordinate_y AS DOUBLE))
      comment: "Average Y-coordinate of scoring events on the pitch. Spatial analytics KPI for tactical analysis and broadcast graphics production."
    - name: "var_review_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN var_review_flag = TRUE THEN scoring_event_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of scoring events subject to VAR review. Officiating technology utilization KPI and match flow impact indicator for league governance."
    - name: "var_overturned_count"
      expr: COUNT(CASE WHEN var_review_outcome = 'overturned' THEN scoring_event_id END)
      comment: "Number of scoring events overturned by VAR. Officiating accuracy and technology ROI KPI for league governance and broadcast commentary."
    - name: "own_goal_count"
      expr: COUNT(CASE WHEN is_own_goal = TRUE THEN scoring_event_id END)
      comment: "Number of own goals recorded. Competitive analysis KPI for accurate team performance attribution."
    - name: "lead_change_count"
      expr: COUNT(CASE WHEN is_lead_change = TRUE THEN scoring_event_id END)
      comment: "Number of scoring events that changed the match lead. Entertainment value KPI used in broadcast highlight selection and fan engagement analysis."
    - name: "lead_change_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_lead_change = TRUE THEN scoring_event_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of scoring events that resulted in a lead change. Competitive drama index used in broadcast value assessment and fan engagement strategy."
    - name: "distinct_fixtures_with_scoring"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct fixtures with at least one scoring event. Measures scoring data coverage completeness across the fixture calendar."
    - name: "avg_scoring_events_per_fixture"
      expr: ROUND(CAST(COUNT(1) AS DOUBLE) / NULLIF(COUNT(DISTINCT fixture_id), 0), 2)
      comment: "Average number of scoring events per fixture. Entertainment intensity KPI used to benchmark match excitement levels across competitions and seasons."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`event_venue_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Venue assignment metrics covering rental fees, revenue share, capacity management, and compliance. Used by venue operations, finance, and commercial teams to optimize venue utilization and cost efficiency."
  source: "`sports_entertainment_ecm`.`event`.`venue_assignment`"
  dimensions:
    - name: "event_date"
      expr: event_date
      comment: "Date of the venue assignment for time-series analysis of venue utilization."
    - name: "assignment_status"
      expr: assignment_status
      comment: "Current status of the venue assignment (e.g. confirmed, pending, cancelled) for pipeline health monitoring."
    - name: "designation_type"
      expr: designation_type
      comment: "Designation type of the venue assignment (e.g. primary, backup, neutral) for venue strategy analysis."
    - name: "surface_type"
      expr: surface_type
      comment: "Playing surface type at the assigned venue for performance and safety analytics."
    - name: "field_setup_type"
      expr: field_setup_type
      comment: "Field setup configuration for the event (e.g. standard, reduced capacity, concert layout) for operational planning."
    - name: "security_level"
      expr: security_level
      comment: "Security level designation for the venue assignment (e.g. standard, elevated, high) for safety and cost analysis."
    - name: "rental_fee_currency"
      expr: rental_fee_currency
      comment: "Currency of the venue rental fee for multi-currency financial analysis."
    - name: "ada_compliant"
      expr: ada_compliant
      comment: "Flag indicating ADA compliance of the venue assignment, for accessibility regulatory reporting."
    - name: "neutral_site_flag"
      expr: neutral_site_flag
      comment: "Flag indicating whether the venue is a neutral site for the event, for competitive fairness and revenue analysis."
    - name: "broadcast_infrastructure_ready"
      expr: broadcast_infrastructure_ready
      comment: "Flag indicating broadcast infrastructure readiness at the venue, for media rights delivery risk management."
    - name: "vip_hospitality_enabled"
      expr: vip_hospitality_enabled
      comment: "Flag indicating VIP hospitality is enabled at the venue, for premium revenue channel analysis."
    - name: "ga_section_enabled"
      expr: ga_section_enabled
      comment: "Flag indicating general admission sections are enabled, for attendance capacity and revenue mix analysis."
    - name: "sustainability_certification"
      expr: sustainability_certification
      comment: "Sustainability certification held by the venue assignment, for ESG reporting and brand positioning."
  measures:
    - name: "total_venue_assignments"
      expr: COUNT(1)
      comment: "Total number of venue assignments. Baseline volume metric for venue operations and scheduling."
    - name: "total_rental_fee_amount"
      expr: SUM(CAST(rental_fee_amount AS DOUBLE))
      comment: "Total venue rental fees across all assignments. Primary venue cost KPI for finance and operations teams."
    - name: "avg_rental_fee_per_assignment"
      expr: AVG(CAST(rental_fee_amount AS DOUBLE))
      comment: "Average venue rental fee per assignment. Benchmarking KPI for venue cost negotiation and budget forecasting."
    - name: "avg_revenue_share_pct"
      expr: AVG(CAST(revenue_share_pct AS DOUBLE))
      comment: "Average revenue share percentage across venue assignments. Commercial deal structure KPI for venue partnership negotiations."
    - name: "total_revenue_share_pct_sum"
      expr: SUM(CAST(revenue_share_pct AS DOUBLE))
      comment: "Sum of revenue share percentages across assignments. Used with count to derive portfolio-level revenue share exposure."
    - name: "broadcast_ready_venue_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN broadcast_infrastructure_ready = TRUE THEN venue_assignment_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of venue assignments with broadcast infrastructure ready. Media rights delivery risk KPI for broadcast operations teams."
    - name: "ada_compliant_venue_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN ada_compliant = TRUE THEN venue_assignment_id END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of venue assignments that are ADA compliant. Accessibility regulatory compliance KPI for venue operations and legal teams."
    - name: "vip_hospitality_enabled_count"
      expr: COUNT(CASE WHEN vip_hospitality_enabled = TRUE THEN venue_assignment_id END)
      comment: "Number of venue assignments with VIP hospitality enabled. Premium revenue channel activation KPI for commercial and hospitality teams."
    - name: "distinct_venues_assigned"
      expr: COUNT(DISTINCT venue_id)
      comment: "Number of distinct venues assigned across events. Venue portfolio utilization breadth metric for operations and commercial strategy."
    - name: "distinct_fixtures_assigned"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct fixtures with a venue assignment. Measures venue assignment coverage completeness across the event calendar."
$$;
