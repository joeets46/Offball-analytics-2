-- Metric views for domain: venue | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic venue portfolio metrics covering operational status, ADA compliance posture, naming rights exposure, and venue mix — used by VP of Venue Operations and CFO to steer capital allocation and compliance investment across the venue estate."
  source: "`sports_entertainment_ecm`.`venue`.`venue`"
  dimensions:
    - name: "venue_type"
      expr: venue_type
      comment: "Type of venue (e.g., arena, stadium, amphitheater) for portfolio segmentation."
    - name: "operational_status"
      expr: operational_status
      comment: "Current operational status of the venue (e.g., active, closed, under renovation)."
    - name: "primary_sport_category"
      expr: primary_sport_category
      comment: "Primary sport or entertainment category hosted at the venue."
    - name: "ownership_structure"
      expr: ownership_structure
      comment: "Ownership model (e.g., owned, leased, public-private partnership)."
    - name: "country_code"
      expr: country_code
      comment: "Country where the venue is located, enabling geographic performance analysis."
    - name: "roof_type"
      expr: roof_type
      comment: "Roof configuration (e.g., open, retractable, fixed dome) affecting event scheduling risk."
    - name: "ada_compliant"
      expr: ada_compliant
      comment: "Whether the venue is ADA compliant — critical for regulatory risk segmentation."
    - name: "iso_20121_certified"
      expr: iso_20121_certified
      comment: "Whether the venue holds ISO 20121 sustainable event management certification."
    - name: "naming_rights_holder"
      expr: naming_rights_holder
      comment: "Current naming rights sponsor — used for sponsorship revenue tracking."
  measures:
    - name: "total_venues"
      expr: COUNT(1)
      comment: "Total number of venues in the portfolio. Baseline KPI for estate sizing and capacity planning."
    - name: "active_venues"
      expr: COUNT(CASE WHEN operational_status = 'active' THEN 1 END)
      comment: "Count of venues currently in active operational status. Drives resource allocation decisions."
    - name: "ada_compliant_venues"
      expr: COUNT(CASE WHEN ada_compliant = TRUE THEN 1 END)
      comment: "Number of venues confirmed ADA compliant. Tracks regulatory exposure across the estate."
    - name: "ada_compliance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN ada_compliant = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of venues that are ADA compliant. A compliance rate below 100% signals legal and reputational risk requiring executive action."
    - name: "iso_certified_venues"
      expr: COUNT(CASE WHEN iso_20121_certified = TRUE THEN 1 END)
      comment: "Number of venues with active ISO 20121 sustainability certification. Tracks ESG commitment across the portfolio."
    - name: "venues_with_naming_rights"
      expr: COUNT(CASE WHEN naming_rights_holder IS NOT NULL AND naming_rights_holder <> '' THEN 1 END)
      comment: "Count of venues with an active naming rights holder. Indicates sponsorship revenue exposure and renewal pipeline size."
    - name: "avg_latitude"
      expr: AVG(CAST(latitude AS DOUBLE))
      comment: "Average geographic latitude of the venue portfolio — used for geographic clustering and market coverage analysis."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_facility`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Facility-level operational and infrastructure metrics for VP of Facilities and COO — covering operational readiness, broadcast capability, and infrastructure mix across all physical facilities."
  source: "`sports_entertainment_ecm`.`venue`.`facility`"
  dimensions:
    - name: "operational_status"
      expr: operational_status
      comment: "Current operational status of the facility (active, closed, under renovation)."
    - name: "venue_type"
      expr: venue_type
      comment: "Type of facility (arena, stadium, practice facility, etc.)."
    - name: "primary_sport_category"
      expr: primary_sport_category
      comment: "Primary sport or entertainment category for the facility."
    - name: "ownership_structure"
      expr: ownership_structure
      comment: "Ownership model of the facility — informs capital vs. operating expense classification."
    - name: "broadcast_production_level"
      expr: broadcast_production_level
      comment: "Broadcast production capability tier — drives media rights and production cost decisions."
    - name: "roof_type"
      expr: roof_type
      comment: "Roof type of the facility — affects weather risk and event scheduling flexibility."
    - name: "playing_surface_type"
      expr: playing_surface_type
      comment: "Type of playing surface (natural grass, artificial turf, hardwood, etc.)."
    - name: "country_code"
      expr: country_code
      comment: "Country of the facility for geographic segmentation."
  measures:
    - name: "total_facilities"
      expr: COUNT(1)
      comment: "Total number of facilities in the portfolio. Baseline for estate management."
    - name: "active_facilities"
      expr: COUNT(CASE WHEN operational_status = 'active' THEN 1 END)
      comment: "Count of facilities currently active and available for events."
    - name: "active_facility_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN operational_status = 'active' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of facilities in active operational status. Low rates signal underutilization or deferred maintenance issues."
    - name: "avg_geo_latitude"
      expr: AVG(CAST(latitude AS DOUBLE))
      comment: "Average latitude of facilities — supports geographic market coverage analysis."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_event_day_ops`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Event day operational performance metrics for VP of Operations and Safety Officers — tracking checklist completion, incident rates, ADA readiness, and emergency system verification across all event days."
  source: "`sports_entertainment_ecm`.`venue`.`event_day_ops`"
  dimensions:
    - name: "ops_status"
      expr: ops_status
      comment: "Overall operational status for the event day (e.g., completed, in-progress, cancelled)."
    - name: "event_date"
      expr: event_date
      comment: "Date of the event — enables time-series trending of operational performance."
    - name: "weather_condition"
      expr: weather_condition
      comment: "Weather condition on event day — used to correlate operational issues with weather risk."
    - name: "ada_access_confirmed"
      expr: ada_access_confirmed
      comment: "Whether ADA access was confirmed ready for the event — compliance dimension."
    - name: "emergency_system_verified"
      expr: emergency_system_verified
      comment: "Whether emergency systems were verified before gates opened — safety readiness flag."
    - name: "fire_system_verified"
      expr: fire_system_verified
      comment: "Whether fire safety systems were verified on event day."
    - name: "damage_assessment_required"
      expr: damage_assessment_required
      comment: "Whether a post-event damage assessment was required — signals facility risk events."
  measures:
    - name: "total_event_days"
      expr: COUNT(1)
      comment: "Total number of event day operations records. Baseline for operational volume."
    - name: "avg_checklist_completion_pct"
      expr: AVG(CAST(checklist_completion_pct AS DOUBLE))
      comment: "Average pre-event checklist completion percentage across all event days. Below-target rates indicate operational readiness risk and require management intervention."
    - name: "events_with_full_checklist"
      expr: COUNT(CASE WHEN checklist_completion_pct = 100.0 THEN 1 END)
      comment: "Number of event days where the operational checklist was 100% completed. Tracks operational excellence rate."
    - name: "checklist_completion_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN checklist_completion_pct = 100.0 THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of event days achieving full checklist completion. A key operational quality KPI for venue management."
    - name: "avg_temperature_celsius"
      expr: AVG(CAST(temperature_celsius AS DOUBLE))
      comment: "Average event day temperature in Celsius — used to correlate weather conditions with attendance and operational outcomes."
    - name: "events_with_emergency_system_verified"
      expr: COUNT(CASE WHEN emergency_system_verified = TRUE THEN 1 END)
      comment: "Count of event days where emergency systems were verified. Tracks safety compliance rate across events."
    - name: "emergency_system_verification_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN emergency_system_verified = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of event days with emergency systems verified. Any rate below 100% is a critical safety and liability risk requiring immediate executive attention."
    - name: "events_requiring_damage_assessment"
      expr: COUNT(CASE WHEN damage_assessment_required = TRUE THEN 1 END)
      comment: "Number of event days that required a post-event damage assessment. Tracks facility wear and insurance exposure."
    - name: "damage_assessment_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN damage_assessment_required = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of events requiring damage assessment — a rising rate signals deteriorating facility condition or crowd management issues."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_safety_incident`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Safety incident analytics for Chief Safety Officer, Risk Management, and Legal — tracking incident severity, OSHA recordability, liability exposure, and corrective action status to drive safety investment and regulatory compliance."
  source: "`sports_entertainment_ecm`.`venue`.`safety_incident`"
  dimensions:
    - name: "incident_type"
      expr: incident_type
      comment: "Category of safety incident (e.g., slip/fall, medical, structural, crowd crush)."
    - name: "severity_level"
      expr: severity_level
      comment: "Severity classification of the incident — drives triage and escalation decisions."
    - name: "incident_status"
      expr: incident_status
      comment: "Current status of the incident (open, under investigation, closed)."
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "High-level root cause category — used to identify systemic safety issues."
    - name: "affected_party_type"
      expr: affected_party_type
      comment: "Type of party affected (fan, staff, athlete, contractor) — informs liability and insurance routing."
    - name: "is_osha_recordable"
      expr: is_osha_recordable
      comment: "Whether the incident is OSHA recordable — directly impacts regulatory reporting obligations."
    - name: "is_fatality"
      expr: is_fatality
      comment: "Whether the incident resulted in a fatality — highest severity flag for executive and legal escalation."
    - name: "corrective_action_status"
      expr: corrective_action_status
      comment: "Status of corrective actions (pending, in-progress, completed) — tracks remediation velocity."
    - name: "venue_zone"
      expr: venue_zone
      comment: "Zone within the venue where the incident occurred — identifies high-risk areas."
    - name: "crowd_density_level"
      expr: crowd_density_level
      comment: "Crowd density at time of incident — used to correlate density with incident rates."
  measures:
    - name: "total_safety_incidents"
      expr: COUNT(1)
      comment: "Total number of safety incidents recorded. Baseline KPI for safety performance trending."
    - name: "osha_recordable_incidents"
      expr: COUNT(CASE WHEN is_osha_recordable = TRUE THEN 1 END)
      comment: "Count of OSHA recordable incidents. Directly impacts regulatory filings and potential penalties."
    - name: "osha_recordable_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_osha_recordable = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of incidents that are OSHA recordable. A rising rate triggers regulatory scrutiny and insurance premium increases."
    - name: "fatality_incidents"
      expr: COUNT(CASE WHEN is_fatality = TRUE THEN 1 END)
      comment: "Count of incidents resulting in fatalities. Any non-zero value requires immediate C-suite and legal escalation."
    - name: "hospitalization_required_incidents"
      expr: COUNT(CASE WHEN is_hospitalization_required = TRUE THEN 1 END)
      comment: "Count of incidents requiring hospitalization. Tracks serious injury rate and insurance claim exposure."
    - name: "total_estimated_liability_usd"
      expr: SUM(CAST(estimated_liability_usd AS DOUBLE))
      comment: "Total estimated financial liability from safety incidents in USD. A primary input to insurance reserve and risk management decisions."
    - name: "avg_estimated_liability_usd"
      expr: AVG(CAST(estimated_liability_usd AS DOUBLE))
      comment: "Average estimated liability per safety incident in USD. Tracks severity trend and informs per-event insurance coverage levels."
    - name: "open_incidents"
      expr: COUNT(CASE WHEN incident_status = 'open' THEN 1 END)
      comment: "Count of safety incidents currently open and unresolved. A backlog KPI for safety operations management."
    - name: "incidents_with_pending_corrective_action"
      expr: COUNT(CASE WHEN corrective_action_status = 'pending' THEN 1 END)
      comment: "Number of incidents with corrective actions not yet initiated. Tracks remediation lag and compliance risk."
    - name: "regulatory_notification_required_incidents"
      expr: COUNT(CASE WHEN regulatory_notification_required = TRUE THEN 1 END)
      comment: "Count of incidents requiring regulatory notification. Tracks regulatory reporting obligations and deadline risk."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_safety_inspection`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Safety inspection performance metrics for Compliance Officers and Facility Directors — tracking inspection outcomes, critical findings, certificate status, and follow-up rates to manage regulatory risk and facility safety standards."
  source: "`sports_entertainment_ecm`.`venue`.`safety_inspection`"
  dimensions:
    - name: "inspection_type"
      expr: inspection_type
      comment: "Type of safety inspection (routine, triggered, regulatory, pre-event)."
    - name: "inspection_status"
      expr: inspection_status
      comment: "Current status of the inspection (scheduled, in-progress, completed, failed)."
    - name: "outcome"
      expr: outcome
      comment: "Inspection outcome (pass, fail, conditional pass) — primary compliance result."
    - name: "risk_rating"
      expr: risk_rating
      comment: "Risk rating assigned at inspection (low, medium, high, critical) — drives remediation prioritization."
    - name: "inspection_trigger"
      expr: inspection_trigger
      comment: "What triggered the inspection (scheduled, incident, complaint, regulatory demand)."
    - name: "corrective_actions_required"
      expr: corrective_actions_required
      comment: "Whether corrective actions were required as a result of the inspection."
    - name: "certificate_issued"
      expr: certificate_issued
      comment: "Whether a compliance certificate was issued following the inspection."
    - name: "follow_up_required"
      expr: follow_up_required
      comment: "Whether a follow-up inspection was required — indicates unresolved findings."
    - name: "inspection_date"
      expr: inspection_date
      comment: "Date of the inspection — enables time-series trending of inspection activity."
  measures:
    - name: "total_inspections"
      expr: COUNT(1)
      comment: "Total number of safety inspections conducted. Baseline for inspection program volume."
    - name: "passed_inspections"
      expr: COUNT(CASE WHEN outcome = 'pass' THEN 1 END)
      comment: "Number of inspections with a passing outcome. Tracks overall facility safety compliance."
    - name: "inspection_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN outcome = 'pass' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of inspections that passed. A declining pass rate is a leading indicator of facility safety deterioration requiring capital investment."
    - name: "inspections_with_corrective_actions"
      expr: COUNT(CASE WHEN corrective_actions_required = TRUE THEN 1 END)
      comment: "Number of inspections that generated corrective action requirements. Tracks remediation workload."
    - name: "corrective_action_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN corrective_actions_required = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of inspections requiring corrective actions. A high rate signals systemic facility maintenance deficiencies."
    - name: "certificates_issued"
      expr: COUNT(CASE WHEN certificate_issued = TRUE THEN 1 END)
      comment: "Number of compliance certificates issued following inspections. Tracks regulatory certification coverage."
    - name: "certificate_issuance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN certificate_issued = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of inspections resulting in certificate issuance. Low rates indicate compliance gaps requiring executive attention."
    - name: "inspections_requiring_follow_up"
      expr: COUNT(CASE WHEN follow_up_required = TRUE THEN 1 END)
      comment: "Number of inspections requiring follow-up. Tracks unresolved compliance findings backlog."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_maintenance_work_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Maintenance work order financial and operational metrics for VP of Facilities and CFO — tracking cost performance, labor efficiency, safety-critical work, and ADA compliance remediation across all venue maintenance activity."
  source: "`sports_entertainment_ecm`.`venue`.`maintenance_work_order`"
  dimensions:
    - name: "work_order_type"
      expr: work_order_type
      comment: "Type of work order (preventive, corrective, emergency, compliance) — drives cost and risk segmentation."
    - name: "work_order_status"
      expr: work_order_status
      comment: "Current status of the work order (open, in-progress, completed, cancelled)."
    - name: "priority_level"
      expr: priority_level
      comment: "Priority level of the work order (critical, high, medium, low) — used for resource allocation decisions."
    - name: "asset_system_category"
      expr: asset_system_category
      comment: "Category of the asset system being maintained (HVAC, electrical, structural, etc.)."
    - name: "is_safety_critical"
      expr: is_safety_critical
      comment: "Whether the work order is safety-critical — highest priority flag for scheduling and resource allocation."
    - name: "is_ada_compliance_related"
      expr: is_ada_compliance_related
      comment: "Whether the work order is related to ADA compliance remediation — tracks regulatory obligation fulfillment."
    - name: "requires_shutdown"
      expr: requires_shutdown
      comment: "Whether the work requires a facility or system shutdown — impacts event scheduling and revenue."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of cost figures — required for multi-currency portfolio analysis."
    - name: "requested_date"
      expr: requested_date
      comment: "Date the work order was requested — enables aging analysis and backlog trending."
  measures:
    - name: "total_work_orders"
      expr: COUNT(1)
      comment: "Total number of maintenance work orders. Baseline for maintenance volume and backlog management."
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_cost AS DOUBLE))
      comment: "Total actual maintenance spend across all work orders. Primary input to facilities budget variance analysis."
    - name: "total_estimated_cost"
      expr: SUM(CAST(estimated_cost AS DOUBLE))
      comment: "Total estimated cost of all work orders. Used for budget forecasting and approval workflows."
    - name: "avg_actual_cost_per_work_order"
      expr: AVG(CAST(actual_cost AS DOUBLE))
      comment: "Average actual cost per work order. Benchmarks maintenance efficiency and identifies cost outliers."
    - name: "total_actual_labor_hours"
      expr: SUM(CAST(actual_labor_hours AS DOUBLE))
      comment: "Total actual labor hours consumed by maintenance work orders. Drives workforce planning and contractor spend decisions."
    - name: "avg_actual_labor_hours"
      expr: AVG(CAST(actual_labor_hours AS DOUBLE))
      comment: "Average labor hours per work order. Benchmarks labor efficiency and identifies scope creep."
    - name: "total_external_service_cost"
      expr: SUM(CAST(external_service_cost AS DOUBLE))
      comment: "Total spend on external service providers for maintenance. Tracks outsourcing cost and make-vs-buy decisions."
    - name: "total_parts_cost"
      expr: SUM(CAST(parts_cost AS DOUBLE))
      comment: "Total parts and materials cost across all work orders. Informs procurement strategy and inventory investment."
    - name: "safety_critical_work_orders"
      expr: COUNT(CASE WHEN is_safety_critical = TRUE THEN 1 END)
      comment: "Count of safety-critical work orders. A high backlog of open safety-critical orders is a direct liability and regulatory risk."
    - name: "ada_compliance_work_orders"
      expr: COUNT(CASE WHEN is_ada_compliance_related = TRUE THEN 1 END)
      comment: "Count of work orders related to ADA compliance remediation. Tracks progress against accessibility obligations."
    - name: "cost_overrun_work_orders"
      expr: COUNT(CASE WHEN actual_cost > estimated_cost THEN 1 END)
      comment: "Number of work orders where actual cost exceeded the estimate. Tracks budget discipline and estimation accuracy."
    - name: "cost_overrun_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_cost > estimated_cost THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of work orders with cost overruns. A rising rate signals poor scoping, contractor management issues, or aging infrastructure."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_suite`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Premium suite revenue and contract metrics for VP of Premium Sales and CFO — tracking license fee revenue, contract pipeline, ADA accessibility, and suite portfolio utilization to drive premium hospitality revenue growth."
  source: "`sports_entertainment_ecm`.`venue`.`suite`"
  dimensions:
    - name: "suite_type"
      expr: suite_type
      comment: "Type of suite (e.g., standard, premium, founder, loge box) — drives pricing and sales strategy segmentation."
    - name: "suite_level"
      expr: suite_level
      comment: "Level within the venue where the suite is located — affects pricing and demand."
    - name: "contract_status"
      expr: contract_status
      comment: "Current contract status (active, expired, pending renewal, terminated) — pipeline management dimension."
    - name: "license_term_type"
      expr: license_term_type
      comment: "Term type of the license agreement (multi-year, annual, event-by-event)."
    - name: "pipeline_stage"
      expr: pipeline_stage
      comment: "Sales pipeline stage for suites not yet under contract — drives revenue forecasting."
    - name: "is_ada_accessible"
      expr: is_ada_accessible
      comment: "Whether the suite is ADA accessible — compliance and inclusivity dimension."
    - name: "has_renewal_option"
      expr: has_renewal_option
      comment: "Whether the suite license includes a renewal option — affects retention strategy."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of license fee amounts — required for multi-market revenue consolidation."
  measures:
    - name: "total_suites"
      expr: COUNT(1)
      comment: "Total number of suites in the portfolio. Baseline for premium inventory management."
    - name: "active_contracted_suites"
      expr: COUNT(CASE WHEN contract_status = 'active' THEN 1 END)
      comment: "Number of suites with active license contracts. Primary measure of premium inventory utilization."
    - name: "suite_contract_utilization_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN contract_status = 'active' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of suites under active contract. A key premium revenue efficiency KPI — low rates signal unsold inventory requiring sales intervention."
    - name: "total_annual_license_fee_revenue"
      expr: SUM(CAST(annual_license_fee AS DOUBLE))
      comment: "Total annual license fee revenue across all suites. Primary premium hospitality revenue KPI for CFO and VP of Premium Sales."
    - name: "avg_annual_license_fee"
      expr: AVG(CAST(annual_license_fee AS DOUBLE))
      comment: "Average annual license fee per suite. Benchmarks pricing strategy and identifies below-market contracts."
    - name: "total_license_fee_portfolio_value"
      expr: SUM(CAST(total_license_fee AS DOUBLE))
      comment: "Total contracted license fee value across all suite agreements. Represents the full premium revenue backlog."
    - name: "total_catering_credit_value"
      expr: SUM(CAST(catering_credit_amount AS DOUBLE))
      comment: "Total catering credit commitments included in suite contracts. Tracks F&B revenue offset obligations."
    - name: "avg_suite_square_footage"
      expr: AVG(CAST(square_footage AS DOUBLE))
      comment: "Average square footage per suite. Used for pricing benchmarking and renovation ROI analysis."
    - name: "suites_with_renewal_option"
      expr: COUNT(CASE WHEN has_renewal_option = TRUE THEN 1 END)
      comment: "Number of suites with a renewal option in their contract. Tracks retention pipeline and revenue visibility."
    - name: "ada_accessible_suites"
      expr: COUNT(CASE WHEN is_ada_accessible = TRUE THEN 1 END)
      comment: "Number of ADA accessible suites. Tracks compliance with accessibility requirements in premium inventory."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_concession_stand`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Concession stand operational and revenue metrics for VP of Food & Beverage and CFO — tracking health compliance, revenue share exposure, operational readiness, and stand portfolio mix to optimize F&B revenue and regulatory compliance."
  source: "`sports_entertainment_ecm`.`venue`.`concession_stand`"
  dimensions:
    - name: "stand_type"
      expr: stand_type
      comment: "Type of concession stand (permanent, portable, kiosk, bar) — drives revenue and staffing strategy."
    - name: "operational_status"
      expr: operational_status
      comment: "Current operational status of the stand (active, closed, under renovation)."
    - name: "operator_type"
      expr: operator_type
      comment: "Type of operator (in-house, third-party concessionaire, franchise) — informs revenue share and margin analysis."
    - name: "product_category"
      expr: product_category
      comment: "Primary product category sold (food, beverage, alcohol, merchandise)."
    - name: "health_inspection_status"
      expr: health_inspection_status
      comment: "Current health inspection status (pass, fail, conditional) — regulatory compliance dimension."
    - name: "ada_accessible"
      expr: ada_accessible
      comment: "Whether the stand is ADA accessible — compliance and fan experience dimension."
    - name: "alcohol_license_flag"
      expr: alcohol_license_flag
      comment: "Whether the stand holds an alcohol license — drives revenue mix and regulatory exposure."
    - name: "cashless_only_flag"
      expr: cashless_only_flag
      comment: "Whether the stand operates cashless only — tracks modernization and transaction efficiency."
    - name: "concourse_level"
      expr: concourse_level
      comment: "Concourse level where the stand is located — enables spatial revenue analysis."
  measures:
    - name: "total_concession_stands"
      expr: COUNT(1)
      comment: "Total number of concession stands in the portfolio. Baseline for F&B infrastructure planning."
    - name: "active_concession_stands"
      expr: COUNT(CASE WHEN operational_status = 'active' THEN 1 END)
      comment: "Number of concession stands currently active. Tracks operational F&B capacity."
    - name: "active_stand_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN operational_status = 'active' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of concession stands in active operation. Low rates signal revenue leakage from closed inventory."
    - name: "avg_revenue_share_pct"
      expr: AVG(CAST(revenue_share_pct AS DOUBLE))
      comment: "Average revenue share percentage across concession stand contracts. Benchmarks concessionaire deal terms and informs renegotiation strategy."
    - name: "avg_health_inspection_score"
      expr: AVG(CAST(health_inspection_score AS DOUBLE))
      comment: "Average health inspection score across all stands. A declining score is a leading indicator of regulatory risk and potential closures."
    - name: "stands_failing_health_inspection"
      expr: COUNT(CASE WHEN health_inspection_status = 'fail' THEN 1 END)
      comment: "Number of stands currently failing health inspection. Any non-zero value requires immediate operational intervention to avoid regulatory closure."
    - name: "health_inspection_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN health_inspection_status = 'pass' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of concession stands passing health inspection. A primary food safety compliance KPI."
    - name: "total_stand_square_footage"
      expr: SUM(CAST(square_footage AS DOUBLE))
      comment: "Total square footage of all concession stands. Used for space utilization and revenue-per-sqft analysis."
    - name: "avg_stand_square_footage"
      expr: AVG(CAST(square_footage AS DOUBLE))
      comment: "Average square footage per concession stand. Benchmarks stand sizing against throughput and revenue performance."
    - name: "alcohol_licensed_stands"
      expr: COUNT(CASE WHEN alcohol_license_flag = TRUE THEN 1 END)
      comment: "Number of stands with active alcohol licenses. Tracks high-margin beverage revenue capacity."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_seating_section`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Seating section inventory and quality metrics for VP of Ticketing and Venue Operations — tracking premium amenity coverage, ADA seat inventory, sightline quality, and section availability to optimize ticket pricing and fan experience."
  source: "`sports_entertainment_ecm`.`venue`.`seating_section`"
  dimensions:
    - name: "section_type"
      expr: section_type
      comment: "Type of seating section (lower bowl, upper deck, club, field level, suite level)."
    - name: "section_status"
      expr: section_status
      comment: "Current status of the section (active, inactive, under renovation, killed)."
    - name: "concourse_level"
      expr: concourse_level
      comment: "Concourse level of the section — used for spatial and pricing analysis."
    - name: "premium_amenity_flag"
      expr: premium_amenity_flag
      comment: "Whether the section has premium amenities — drives premium pricing and upsell strategy."
    - name: "season_ticket_eligible"
      expr: season_ticket_eligible
      comment: "Whether the section is eligible for season ticket packages — impacts season ticket revenue planning."
    - name: "accessible_route_available"
      expr: accessible_route_available
      comment: "Whether an accessible route is available to the section — ADA compliance dimension."
    - name: "is_covered"
      expr: is_covered
      comment: "Whether the section is covered/sheltered — affects weather risk and premium pricing."
    - name: "alcohol_service_permitted"
      expr: alcohol_service_permitted
      comment: "Whether alcohol service is permitted in the section — impacts F&B revenue allocation."
    - name: "obstructed_view"
      expr: obstructed_view
      comment: "Whether the section has obstructed sightlines — affects pricing, fan satisfaction, and kill-seat decisions."
  measures:
    - name: "total_seating_sections"
      expr: COUNT(1)
      comment: "Total number of seating sections. Baseline for venue inventory management."
    - name: "active_sections"
      expr: COUNT(CASE WHEN section_status = 'active' THEN 1 END)
      comment: "Number of sections currently active and available for ticketing."
    - name: "active_section_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN section_status = 'active' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of seating sections in active status. Low rates indicate inventory being withheld from sale, impacting revenue."
    - name: "avg_sightline_rating"
      expr: AVG(CAST(sightline_rating AS DOUBLE))
      comment: "Average sightline quality rating across all sections. A key fan experience KPI that correlates with ticket demand and pricing power."
    - name: "premium_amenity_sections"
      expr: COUNT(CASE WHEN premium_amenity_flag = TRUE THEN 1 END)
      comment: "Number of sections with premium amenities. Tracks premium inventory available for upsell and higher-yield pricing."
    - name: "premium_section_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN premium_amenity_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of sections with premium amenities. Benchmarks venue premium inventory mix against peer venues."
    - name: "sections_with_accessible_route"
      expr: COUNT(CASE WHEN accessible_route_available = TRUE THEN 1 END)
      comment: "Number of sections with accessible routes available. Tracks ADA accessibility coverage across the seating bowl."
    - name: "accessible_route_coverage_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN accessible_route_available = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of sections with accessible routes. A compliance KPI — gaps require capital investment to remediate ADA obligations."
    - name: "obstructed_view_sections"
      expr: COUNT(CASE WHEN obstructed_view = TRUE THEN 1 END)
      comment: "Number of sections with obstructed views. Tracks inventory quality issues that suppress ticket yield and fan satisfaction."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_staff_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Event staffing plan financial and operational metrics for VP of Operations and CFO — tracking headcount fulfillment, cost performance, safety-critical staffing, and ADA role coverage to optimize labor spend and event readiness."
  source: "`sports_entertainment_ecm`.`venue`.`staff_plan`"
  dimensions:
    - name: "plan_status"
      expr: plan_status
      comment: "Current status of the staff plan (draft, approved, active, completed, cancelled)."
    - name: "role_category"
      expr: role_category
      comment: "Category of staff role (security, operations, medical, guest services, production)."
    - name: "employment_type"
      expr: employment_type
      comment: "Employment type (full-time, part-time, contractor, agency) — drives cost and compliance analysis."
    - name: "event_type_category"
      expr: event_type_category
      comment: "Category of event being staffed (game day, concert, corporate, playoff) — enables event-type cost benchmarking."
    - name: "fulfillment_source"
      expr: fulfillment_source
      comment: "Source of staff fulfillment (in-house, agency, union, volunteer) — informs make-vs-buy decisions."
    - name: "is_osha_safety_critical"
      expr: is_osha_safety_critical
      comment: "Whether the role is OSHA safety-critical — highest priority for fulfillment and compliance."
    - name: "is_ada_role"
      expr: is_ada_role
      comment: "Whether the role is designated for ADA accessibility support — tracks compliance staffing coverage."
    - name: "cba_applicable"
      expr: cba_applicable
      comment: "Whether a collective bargaining agreement applies — affects labor cost and scheduling flexibility."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of cost figures — required for multi-market labor cost consolidation."
  measures:
    - name: "total_staff_plans"
      expr: COUNT(1)
      comment: "Total number of staff plans. Baseline for staffing program volume."
    - name: "total_estimated_labor_cost_usd"
      expr: SUM(CAST(estimated_cost_usd AS DOUBLE))
      comment: "Total estimated labor cost across all staff plans in USD. Primary input to event budget forecasting."
    - name: "total_actual_labor_cost_usd"
      expr: SUM(CAST(actual_cost_usd AS DOUBLE))
      comment: "Total actual labor cost incurred across all staff plans in USD. Drives budget variance analysis and cost control decisions."
    - name: "avg_actual_labor_cost_per_plan"
      expr: AVG(CAST(actual_cost_usd AS DOUBLE))
      comment: "Average actual labor cost per staff plan. Benchmarks per-event staffing efficiency."
    - name: "avg_pay_rate_usd"
      expr: AVG(CAST(pay_rate_usd AS DOUBLE))
      comment: "Average pay rate per staff plan record in USD. Tracks labor cost inflation and benchmarks against market rates."
    - name: "avg_shift_duration_hours"
      expr: AVG(CAST(shift_duration_hours AS DOUBLE))
      comment: "Average shift duration in hours. Informs overtime risk management and scheduling optimization."
    - name: "labor_cost_overrun_plans"
      expr: COUNT(CASE WHEN actual_cost_usd > estimated_cost_usd THEN 1 END)
      comment: "Number of staff plans where actual cost exceeded estimate. Tracks budget discipline in labor management."
    - name: "labor_cost_overrun_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_cost_usd > estimated_cost_usd THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of staff plans with labor cost overruns. A rising rate signals poor estimation, scope creep, or overtime abuse."
    - name: "osha_safety_critical_plans"
      expr: COUNT(CASE WHEN is_osha_safety_critical = TRUE THEN 1 END)
      comment: "Number of staff plans covering OSHA safety-critical roles. Tracks safety staffing coverage across events."
    - name: "ada_role_plans"
      expr: COUNT(CASE WHEN is_ada_role = TRUE THEN 1 END)
      comment: "Number of staff plans for ADA accessibility roles. Tracks compliance with accessibility staffing requirements."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_accessibility_feature`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Accessibility feature compliance and cost metrics for ADA Compliance Officers and CFO — tracking certification status, maintenance investment, operational availability, and inspection currency across all venue accessibility infrastructure."
  source: "`sports_entertainment_ecm`.`venue`.`accessibility_feature`"
  dimensions:
    - name: "feature_type"
      expr: feature_type
      comment: "Type of accessibility feature (ramp, elevator, hearing loop, accessible restroom, etc.)."
    - name: "feature_category"
      expr: feature_category
      comment: "Category of accessibility feature — enables portfolio-level compliance gap analysis."
    - name: "operational_status"
      expr: operational_status
      comment: "Current operational status of the feature (active, out-of-service, under maintenance)."
    - name: "compliance_status"
      expr: compliance_status
      comment: "Compliance status of the feature (compliant, non-compliant, under review)."
    - name: "compliance_standard"
      expr: compliance_standard
      comment: "Applicable compliance standard (ADA, local building code, ISO, etc.)."
    - name: "is_ada_certified"
      expr: is_ada_certified
      comment: "Whether the feature holds ADA certification — primary compliance flag."
    - name: "is_event_day_available"
      expr: is_event_day_available
      comment: "Whether the feature is available on event days — operational readiness dimension."
    - name: "accessible_route_connected"
      expr: accessible_route_connected
      comment: "Whether the feature is connected to an accessible route — network completeness dimension."
    - name: "venue_level"
      expr: venue_level
      comment: "Venue level where the feature is located — spatial compliance coverage analysis."
  measures:
    - name: "total_accessibility_features"
      expr: COUNT(1)
      comment: "Total number of accessibility features in the venue portfolio. Baseline for ADA infrastructure inventory."
    - name: "ada_certified_features"
      expr: COUNT(CASE WHEN is_ada_certified = TRUE THEN 1 END)
      comment: "Number of accessibility features with active ADA certification. Tracks compliance coverage."
    - name: "ada_certification_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_ada_certified = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of accessibility features that are ADA certified. Any rate below 100% represents legal and regulatory exposure requiring remediation investment."
    - name: "total_annual_maintenance_cost"
      expr: SUM(CAST(annual_maintenance_cost AS DOUBLE))
      comment: "Total annual maintenance cost for all accessibility features. Informs ADA compliance budget planning."
    - name: "avg_annual_maintenance_cost"
      expr: AVG(CAST(annual_maintenance_cost AS DOUBLE))
      comment: "Average annual maintenance cost per accessibility feature. Benchmarks maintenance efficiency and identifies high-cost outliers."
    - name: "total_installation_cost"
      expr: SUM(CAST(installation_cost AS DOUBLE))
      comment: "Total capital investment in accessibility feature installation. Tracks ADA compliance capital expenditure."
    - name: "features_event_day_available"
      expr: COUNT(CASE WHEN is_event_day_available = TRUE THEN 1 END)
      comment: "Number of accessibility features available on event days. Tracks operational readiness for fan-facing ADA compliance."
    - name: "event_day_availability_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_event_day_available = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of accessibility features available on event days. Low rates signal ADA service gaps that create legal exposure and fan experience failures."
    - name: "non_compliant_features"
      expr: COUNT(CASE WHEN compliance_status = 'non-compliant' THEN 1 END)
      comment: "Number of accessibility features currently in non-compliant status. Tracks open ADA remediation obligations requiring capital investment."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`venue_capacity_config`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Venue capacity configuration metrics for VP of Ticketing, Operations, and League Relations — tracking sellable capacity efficiency, setup/teardown time, ADA compliance verification, and configuration readiness across all venue capacity setups."
  source: "`sports_entertainment_ecm`.`venue`.`capacity_config`"
  dimensions:
    - name: "config_status"
      expr: config_status
      comment: "Current status of the capacity configuration (active, draft, archived, pending approval)."
    - name: "seating_mode"
      expr: seating_mode
      comment: "Seating mode for the configuration (reserved, general admission, mixed) — drives ticketing strategy."
    - name: "stage_configuration"
      expr: stage_configuration
      comment: "Stage or floor configuration type — affects sellable capacity and event type eligibility."
    - name: "bowl_orientation"
      expr: bowl_orientation
      comment: "Bowl orientation for the configuration — relevant for sightline and capacity planning."
    - name: "ada_compliance_verified"
      expr: ada_compliance_verified
      comment: "Whether ADA compliance has been verified for this configuration — regulatory readiness flag."
    - name: "fire_code_approved"
      expr: fire_code_approved
      comment: "Whether the configuration has fire code approval — required for event day operations."
    - name: "league_approved"
      expr: league_approved
      comment: "Whether the configuration has league approval — required for sanctioned league events."
    - name: "effective_start_date"
      expr: effective_start_date
      comment: "Date from which the configuration is effective — enables temporal capacity analysis."
  measures:
    - name: "total_capacity_configs"
      expr: COUNT(1)
      comment: "Total number of capacity configurations. Baseline for configuration portfolio management."
    - name: "active_configs"
      expr: COUNT(CASE WHEN config_status = 'active' THEN 1 END)
      comment: "Number of currently active capacity configurations. Tracks operational configuration readiness."
    - name: "avg_reduced_capacity_pct"
      expr: AVG(CAST(reduced_capacity_pct AS DOUBLE))
      comment: "Average capacity reduction percentage across configurations. Tracks how much sellable inventory is being withheld — directly impacts ticket revenue potential."
    - name: "avg_setup_duration_hours"
      expr: AVG(CAST(setup_duration_hours AS DOUBLE))
      comment: "Average setup duration in hours per configuration. Drives event scheduling lead time and venue turnaround efficiency."
    - name: "avg_teardown_duration_hours"
      expr: AVG(CAST(teardown_duration_hours AS DOUBLE))
      comment: "Average teardown duration in hours per configuration. Impacts back-to-back event scheduling feasibility."
    - name: "configs_with_ada_verified"
      expr: COUNT(CASE WHEN ada_compliance_verified = TRUE THEN 1 END)
      comment: "Number of configurations with ADA compliance verified. Tracks regulatory readiness of the configuration portfolio."
    - name: "ada_verification_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN ada_compliance_verified = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of capacity configurations with ADA compliance verified. Configurations without verification cannot be used for public events without legal risk."
    - name: "configs_with_fire_code_approval"
      expr: COUNT(CASE WHEN fire_code_approved = TRUE THEN 1 END)
      comment: "Number of configurations with fire code approval. A prerequisite for event day operations — gaps represent event cancellation risk."
    - name: "league_approved_configs"
      expr: COUNT(CASE WHEN league_approved = TRUE THEN 1 END)
      comment: "Number of configurations approved by the relevant league. Required for sanctioned league events — tracks compliance with league venue standards."
$$;