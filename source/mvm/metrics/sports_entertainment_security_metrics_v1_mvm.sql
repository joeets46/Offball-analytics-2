-- Metric views for domain: security | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`security_access_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Operational KPIs for venue access control events — tracks scan outcomes, denial rates, biometric verification, watchlist matches, and override activity to support real-time and post-event security posture reviews."
  source: "`sports_entertainment_ecm`.`security`.`access_event`"
  dimensions:
    - name: "access_direction"
      expr: access_direction
      comment: "Entry or exit direction of the access scan — used to analyse ingress/egress flow patterns."
    - name: "scan_result"
      expr: scan_result
      comment: "Outcome of the access scan (e.g. GRANTED, DENIED, OVERRIDE) — primary dimension for access control analysis."
    - name: "credential_type"
      expr: credential_type
      comment: "Type of credential presented at the reader (e.g. RFID, barcode, biometric) — used to benchmark credential performance."
    - name: "credential_holder_category"
      expr: credential_holder_category
      comment: "Category of the credential holder (e.g. ATHLETE, MEDIA, STAFF, FAN) — enables segmented access analysis."
    - name: "event_phase"
      expr: event_phase
      comment: "Phase of the event during which the scan occurred (e.g. PRE-EVENT, IN-GAME, POST-EVENT) — supports temporal security analysis."
    - name: "zone_tier"
      expr: zone_level
      comment: "Security tier of the zone being accessed — used to assess high-security zone access patterns."
    - name: "network_zone"
      expr: network_zone
      comment: "Network zone associated with the reader device — supports infrastructure-level security segmentation."
    - name: "denial_reason_code"
      expr: denial_reason_code
      comment: "Coded reason for access denial — critical for diagnosing credential and policy failures."
    - name: "scan_date"
      expr: DATE_TRUNC('day', scan_timestamp)
      comment: "Calendar date of the scan event — enables daily trend analysis of access activity."
    - name: "scan_month"
      expr: DATE_TRUNC('month', scan_timestamp)
      comment: "Calendar month of the scan event — supports monthly security reporting."
  measures:
    - name: "total_access_scans"
      expr: COUNT(1)
      comment: "Total number of access scan events recorded — baseline volume metric for gate throughput and staffing decisions."
    - name: "total_denied_scans"
      expr: COUNT(CASE WHEN scan_result = 'DENIED' THEN 1 END)
      comment: "Total number of access denial events — elevated denial rates signal credential issues or policy enforcement gaps."
    - name: "access_denial_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN scan_result = 'DENIED' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of scans resulting in denial — key security quality indicator; high rates trigger credential or policy review."
    - name: "total_officer_overrides"
      expr: COUNT(CASE WHEN officer_override_flag = TRUE THEN 1 END)
      comment: "Total number of officer-overridden access events — high override counts indicate credential system weaknesses or policy non-compliance."
    - name: "officer_override_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN officer_override_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of scans requiring officer override — a leading indicator of credential system reliability and officer workload."
    - name: "total_watchlist_matches"
      expr: COUNT(CASE WHEN watchlist_match_flag = TRUE THEN 1 END)
      comment: "Total number of scans that triggered a watchlist match — directly informs threat response and law enforcement escalation decisions."
    - name: "watchlist_match_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN watchlist_match_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of scans resulting in a watchlist match — used by security leadership to assess threat exposure at events."
    - name: "total_biometric_verified_scans"
      expr: COUNT(CASE WHEN biometric_verified_flag = TRUE THEN 1 END)
      comment: "Total scans where biometric verification was confirmed — measures adoption and effectiveness of biometric access controls."
    - name: "biometric_verification_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN biometric_verified_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of scans with successful biometric verification — tracks biometric system coverage and reliability."
    - name: "total_duplicate_scans"
      expr: COUNT(CASE WHEN duplicate_scan_flag = TRUE THEN 1 END)
      comment: "Total number of duplicate scan attempts — high counts indicate anti-passback violations or credential sharing."
    - name: "total_emergency_evacuation_scans"
      expr: COUNT(CASE WHEN emergency_evacuation_flag = TRUE THEN 1 END)
      comment: "Total access events flagged during emergency evacuation — used to validate evacuation compliance and zone clearance."
    - name: "total_law_enforcement_notified_events"
      expr: COUNT(CASE WHEN law_enforcement_notified_flag = TRUE THEN 1 END)
      comment: "Total access events that triggered law enforcement notification — a critical risk and compliance metric for venue security."
    - name: "distinct_credentials_scanned"
      expr: COUNT(DISTINCT credential_id)
      comment: "Number of unique credentials used across all access events — measures credential utilisation breadth per event or period."
    - name: "distinct_zones_accessed"
      expr: COUNT(DISTINCT access_zone_id)
      comment: "Number of distinct access zones activated — indicates operational footprint and zone coverage during an event."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`security_incident`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic and operational KPIs for security incidents at venues and events — tracks incident volume, severity, response effectiveness, law enforcement escalation, and ban issuance to support executive risk management and operational security decisions."
  source: "`sports_entertainment_ecm`.`security`.`security_incident`"
  dimensions:
    - name: "incident_type"
      expr: incident_type
      comment: "Classification of the security incident (e.g. ASSAULT, PROHIBITED_ITEM, TRESPASS) — primary dimension for incident pattern analysis."
    - name: "severity_tier"
      expr: severity_tier
      comment: "Severity classification of the incident (e.g. LOW, MEDIUM, HIGH, CRITICAL) — used to prioritise response resources and executive reporting."
    - name: "incident_status"
      expr: incident_status
      comment: "Current status of the incident (e.g. OPEN, CLOSED, UNDER_INVESTIGATION) — tracks resolution pipeline."
    - name: "disposition"
      expr: disposition
      comment: "Final disposition of the incident (e.g. ARRESTED, EJECTED, WARNING_ISSUED) — measures enforcement outcomes."
    - name: "involved_party_type"
      expr: involved_party_type
      comment: "Type of party involved in the incident (e.g. FAN, ATHLETE, STAFF, MEDIA) — enables segmented risk profiling."
    - name: "crowd_density_level"
      expr: crowd_density_level
      comment: "Crowd density at the time of the incident — used to correlate incident rates with crowd conditions."
    - name: "incident_date"
      expr: DATE_TRUNC('day', occurred_at)
      comment: "Calendar date the incident occurred — enables daily incident trend analysis."
    - name: "incident_month"
      expr: DATE_TRUNC('month', occurred_at)
      comment: "Calendar month the incident occurred — supports monthly and seasonal security reporting."
    - name: "zone_code"
      expr: zone_code
      comment: "Venue zone where the incident occurred — used to identify high-risk zones requiring additional security resources."
    - name: "prohibited_item_type"
      expr: prohibited_item_type
      comment: "Category of prohibited item involved in the incident — informs screening protocol updates and confiscation trends."
  measures:
    - name: "total_incidents"
      expr: COUNT(1)
      comment: "Total number of security incidents recorded — baseline volume metric for security operations planning and executive risk dashboards."
    - name: "total_open_incidents"
      expr: COUNT(CASE WHEN incident_status = 'OPEN' THEN 1 END)
      comment: "Number of currently open (unresolved) incidents — a real-time operational metric for security command centre workload management."
    - name: "total_critical_incidents"
      expr: COUNT(CASE WHEN severity_tier = 'CRITICAL' THEN 1 END)
      comment: "Number of critical-severity incidents — directly triggers executive escalation and emergency response review."
    - name: "critical_incident_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN severity_tier = 'CRITICAL' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of incidents classified as critical — a key risk indicator for venue safety performance benchmarking."
    - name: "total_law_enforcement_escalations"
      expr: COUNT(CASE WHEN law_enforcement_notified = TRUE THEN 1 END)
      comment: "Total incidents escalated to law enforcement — measures the volume of incidents requiring external authority involvement."
    - name: "law_enforcement_escalation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN law_enforcement_notified = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of incidents escalated to law enforcement — a strategic risk metric used in league governing body and regulatory reporting."
    - name: "total_bans_issued"
      expr: COUNT(CASE WHEN ban_issued = TRUE THEN 1 END)
      comment: "Total number of venue bans issued as incident outcomes — measures enforcement deterrence effectiveness."
    - name: "ban_issuance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN ban_issued = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of incidents resulting in a ban — tracks enforcement policy consistency and deterrence posture."
    - name: "total_emergency_response_activations"
      expr: COUNT(CASE WHEN emergency_response_plan_activated = TRUE THEN 1 END)
      comment: "Total incidents that triggered emergency response plan activation — a critical metric for emergency preparedness assessment."
    - name: "total_insurance_claims_filed"
      expr: COUNT(CASE WHEN insurance_claim_filed = TRUE THEN 1 END)
      comment: "Total incidents resulting in an insurance claim — directly informs risk management, insurance premium negotiations, and liability exposure."
    - name: "total_medical_referrals"
      expr: COUNT(CASE WHEN medical_referral_required = TRUE THEN 1 END)
      comment: "Total incidents requiring medical referral — measures fan and staff safety outcomes and informs medical staffing decisions."
    - name: "total_evacuations_triggered"
      expr: COUNT(CASE WHEN evacuation_triggered = TRUE THEN 1 END)
      comment: "Total incidents that triggered venue evacuation — a high-stakes safety metric reviewed at executive and regulatory levels."
    - name: "distinct_venues_with_incidents"
      expr: COUNT(DISTINCT venue_id)
      comment: "Number of distinct venues that recorded at least one security incident — used to benchmark venue-level security performance."
    - name: "distinct_fixtures_with_incidents"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct fixtures that recorded at least one security incident — supports event-level risk profiling."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`security_screening_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Throughput and quality KPIs for venue screening operations — tracks prohibited item detection rates, escalation rates, equipment alarm performance, and screening method effectiveness to support security staffing and protocol decisions."
  source: "`sports_entertainment_ecm`.`security`.`screening_event`"
  dimensions:
    - name: "screening_outcome"
      expr: screening_outcome
      comment: "Result of the screening event (e.g. CLEARED, DENIED_ENTRY, ESCALATED) — primary dimension for screening effectiveness analysis."
    - name: "screening_method"
      expr: screening_method
      comment: "Method used for screening (e.g. WALK_THROUGH_METAL_DETECTOR, WAND, MANUAL_PAT_DOWN) — used to compare method effectiveness and throughput."
    - name: "screened_person_type"
      expr: screened_person_type
      comment: "Type of person screened (e.g. FAN, ATHLETE, STAFF, MEDIA) — enables segmented screening analysis."
    - name: "prohibited_item_category"
      expr: prohibited_item_category
      comment: "Category of prohibited item detected (e.g. WEAPON, ALCOHOL, PYROTECHNIC) — informs screening protocol updates."
    - name: "crowd_density_level"
      expr: crowd_density_level
      comment: "Crowd density at the time of screening — used to correlate throughput and detection rates with crowd conditions."
    - name: "escalation_type"
      expr: escalation_type
      comment: "Type of escalation triggered during screening — used to categorise and manage escalation workflows."
    - name: "gate_number"
      expr: gate_number
      comment: "Gate at which screening occurred — enables gate-level performance benchmarking."
    - name: "screening_date"
      expr: DATE_TRUNC('day', screening_timestamp)
      comment: "Calendar date of the screening event — enables daily trend analysis."
    - name: "screening_month"
      expr: DATE_TRUNC('month', screening_timestamp)
      comment: "Calendar month of the screening event — supports monthly operational reporting."
  measures:
    - name: "total_screenings"
      expr: COUNT(1)
      comment: "Total number of screening events conducted — baseline throughput metric for security staffing and gate capacity planning."
    - name: "total_prohibited_item_detections"
      expr: COUNT(CASE WHEN prohibited_item_flag = TRUE THEN 1 END)
      comment: "Total number of screenings where a prohibited item was detected — measures screening effectiveness and threat interception."
    - name: "prohibited_item_detection_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN prohibited_item_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of screenings resulting in prohibited item detection — a key security quality KPI for protocol benchmarking."
    - name: "total_items_confiscated"
      expr: COUNT(CASE WHEN item_confiscated_flag = TRUE THEN 1 END)
      comment: "Total number of screenings resulting in item confiscation — measures enforcement action rate and screening protocol effectiveness."
    - name: "confiscation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN item_confiscated_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of screenings resulting in confiscation — tracks enforcement consistency and prohibited item prevalence."
    - name: "total_equipment_alarms"
      expr: COUNT(CASE WHEN equipment_alarm_triggered_flag = TRUE THEN 1 END)
      comment: "Total number of screenings that triggered an equipment alarm — used to assess equipment sensitivity and false positive rates."
    - name: "equipment_alarm_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN equipment_alarm_triggered_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of screenings triggering an equipment alarm — high rates may indicate equipment calibration issues or elevated threat levels."
    - name: "total_escalations"
      expr: COUNT(CASE WHEN escalation_flag = TRUE THEN 1 END)
      comment: "Total number of screenings escalated to a higher security tier — measures the volume of complex screening situations requiring supervisor intervention."
    - name: "escalation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN escalation_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of screenings requiring escalation — a key operational efficiency and security quality metric."
    - name: "total_law_enforcement_notifications"
      expr: COUNT(CASE WHEN law_enforcement_notified_flag = TRUE THEN 1 END)
      comment: "Total screenings that resulted in law enforcement notification — measures the rate of serious security threats identified at screening."
    - name: "total_entry_denials"
      expr: COUNT(CASE WHEN screening_outcome = 'DENIED_ENTRY' THEN 1 END)
      comment: "Total number of individuals denied entry at screening — tracks enforcement of venue access policies."
    - name: "entry_denial_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN screening_outcome = 'DENIED_ENTRY' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of screenings resulting in entry denial — used to benchmark policy enforcement consistency across gates and events."
    - name: "distinct_checkpoints_active"
      expr: COUNT(DISTINCT screening_checkpoint_id)
      comment: "Number of distinct screening checkpoints active during the period — measures operational coverage and checkpoint utilisation."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`security_credential`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Credential lifecycle and compliance KPIs — tracks active credential counts, revocation rates, background check compliance, biometric linkage, and multi-event credential usage to support accreditation governance and security risk management."
  source: "`sports_entertainment_ecm`.`security`.`credential`"
  dimensions:
    - name: "credential_type"
      expr: credential_type
      comment: "Type of credential (e.g. MEDIA, ATHLETE, STAFF, VIP) — primary dimension for credential portfolio analysis."
    - name: "credential_status"
      expr: credential_status
      comment: "Current status of the credential (e.g. ACTIVE, REVOKED, EXPIRED, SUSPENDED) — used to monitor credential lifecycle health."
    - name: "access_tier"
      expr: access_tier
      comment: "Access tier granted by the credential (e.g. FIELD, LOCKER_ROOM, PRESS_BOX) — used to analyse high-privilege credential distribution."
    - name: "background_check_status"
      expr: background_check_status
      comment: "Status of the background check associated with the credential (e.g. PASSED, PENDING, FAILED) — critical for compliance and risk management."
    - name: "holder_role"
      expr: holder_role
      comment: "Role of the credential holder (e.g. COACH, JOURNALIST, SECURITY_OFFICER) — enables role-based credential analysis."
    - name: "issuing_authority"
      expr: issuing_authority
      comment: "Authority that issued the credential — used to track accreditation source distribution and compliance."
    - name: "issued_year_month"
      expr: DATE_TRUNC('month', issued_date)
      comment: "Month the credential was issued — supports issuance trend analysis and seasonal accreditation planning."
    - name: "holder_organization"
      expr: holder_organization
      comment: "Organisation the credential holder represents — enables organisation-level credential portfolio management."
  measures:
    - name: "total_credentials"
      expr: COUNT(1)
      comment: "Total number of credentials in the system — baseline metric for accreditation portfolio size and governance oversight."
    - name: "total_active_credentials"
      expr: COUNT(CASE WHEN credential_status = 'ACTIVE' THEN 1 END)
      comment: "Total number of currently active credentials — used to manage live accreditation exposure and access risk."
    - name: "total_revoked_credentials"
      expr: COUNT(CASE WHEN credential_status = 'REVOKED' THEN 1 END)
      comment: "Total number of revoked credentials — elevated revocation counts signal security incidents or compliance failures."
    - name: "credential_revocation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN credential_status = 'REVOKED' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of credentials that have been revoked — a key security governance metric for accreditation quality control."
    - name: "total_background_check_failures"
      expr: COUNT(CASE WHEN background_check_status = 'FAILED' THEN 1 END)
      comment: "Total credentials with a failed background check — directly informs security risk exposure and accreditation policy compliance."
    - name: "background_check_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN background_check_status = 'FAILED' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of credentials with a failed background check — a critical compliance KPI for league governing body reporting."
    - name: "total_biometric_linked_credentials"
      expr: COUNT(CASE WHEN biometric_linked = TRUE THEN 1 END)
      comment: "Total credentials with biometric linkage — measures adoption of biometric security controls across the credential portfolio."
    - name: "biometric_linkage_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN biometric_linked = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of credentials linked to biometric data — tracks progress toward biometric security coverage targets."
    - name: "total_multi_event_credentials"
      expr: COUNT(CASE WHEN multi_event_flag = TRUE THEN 1 END)
      comment: "Total credentials valid across multiple events — used to manage long-duration access risk and multi-event accreditation governance."
    - name: "total_escort_required_credentials"
      expr: COUNT(CASE WHEN escort_required = TRUE THEN 1 END)
      comment: "Total credentials requiring escort — informs security staffing requirements for escorted access management."
    - name: "total_vehicle_access_credentials"
      expr: COUNT(CASE WHEN vehicle_access_flag = TRUE THEN 1 END)
      comment: "Total credentials with vehicle access privileges — used to manage vehicle access risk and perimeter security planning."
    - name: "distinct_issuing_authorities"
      expr: COUNT(DISTINCT issuing_authority)
      comment: "Number of distinct issuing authorities in the credential portfolio — measures accreditation source diversity and governance complexity."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`security_ejection_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fan and participant ejection KPIs — tracks ejection volumes, ban recommendations, arrest rates, repeat offender patterns, and appeal activity to support venue safety policy enforcement and league compliance reporting."
  source: "`sports_entertainment_ecm`.`security`.`ejection_record`"
  dimensions:
    - name: "ejected_party_type"
      expr: ejected_party_type
      comment: "Type of party ejected (e.g. FAN, ATHLETE, STAFF) — primary dimension for ejection pattern analysis."
    - name: "ejection_reason_code"
      expr: ejection_reason_code
      comment: "Coded reason for the ejection (e.g. INTOXICATION, FIGHTING, PROHIBITED_ITEM) — used to identify the most common ejection triggers."
    - name: "ejection_status"
      expr: ejection_status
      comment: "Current status of the ejection record (e.g. CONFIRMED, APPEALED, OVERTURNED) — tracks enforcement outcome pipeline."
    - name: "ban_type"
      expr: ban_type
      comment: "Type of ban associated with the ejection (e.g. SINGLE_EVENT, SEASON, LIFETIME) — used to assess deterrence severity distribution."
    - name: "venue_zone_type"
      expr: venue_zone_type
      comment: "Type of venue zone where the ejection occurred — identifies high-risk zones for targeted security resource deployment."
    - name: "crowd_density_level"
      expr: crowd_density_level
      comment: "Crowd density at the time of ejection — used to correlate ejection rates with crowd conditions."
    - name: "ejection_date"
      expr: DATE_TRUNC('day', ejection_timestamp)
      comment: "Calendar date of the ejection — enables daily and event-level ejection trend analysis."
    - name: "ejection_month"
      expr: DATE_TRUNC('month', ejection_timestamp)
      comment: "Calendar month of the ejection — supports monthly and seasonal ejection reporting."
  measures:
    - name: "total_ejections"
      expr: COUNT(1)
      comment: "Total number of ejection records — baseline metric for venue safety enforcement volume and event risk profiling."
    - name: "total_arrests_made"
      expr: COUNT(CASE WHEN arrest_made_flag = TRUE THEN 1 END)
      comment: "Total ejections resulting in arrest — a critical safety and legal risk metric reviewed by venue management and league compliance."
    - name: "arrest_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN arrest_made_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of ejections resulting in arrest — measures the severity of ejection incidents and law enforcement engagement rate."
    - name: "total_ban_recommendations"
      expr: COUNT(CASE WHEN ban_recommendation_flag = TRUE THEN 1 END)
      comment: "Total ejections with a ban recommendation — measures the volume of cases escalated to formal ban review."
    - name: "ban_recommendation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN ban_recommendation_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of ejections resulting in a ban recommendation — tracks enforcement escalation consistency and deterrence policy application."
    - name: "total_repeat_offenders"
      expr: COUNT(CASE WHEN repeat_offender_flag = TRUE THEN 1 END)
      comment: "Total ejections involving repeat offenders — a key metric for ban policy effectiveness and recidivism management."
    - name: "repeat_offender_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN repeat_offender_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of ejections involving repeat offenders — measures the effectiveness of existing ban and deterrence policies."
    - name: "total_appeals_filed"
      expr: COUNT(CASE WHEN appeal_filed_flag = TRUE THEN 1 END)
      comment: "Total ejections where an appeal was filed — measures the volume of contested enforcement decisions and associated administrative burden."
    - name: "appeal_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN appeal_filed_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of ejections resulting in an appeal — high appeal rates may indicate inconsistent enforcement or policy clarity issues."
    - name: "total_law_enforcement_handoffs"
      expr: COUNT(CASE WHEN law_enforcement_handoff_flag = TRUE THEN 1 END)
      comment: "Total ejections handed off to law enforcement — measures the volume of incidents exceeding venue security authority."
    - name: "total_medical_assistance_required"
      expr: COUNT(CASE WHEN medical_assistance_required_flag = TRUE THEN 1 END)
      comment: "Total ejections requiring medical assistance — a fan safety metric that informs medical staffing and incident response planning."
    - name: "distinct_fixtures_with_ejections"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct fixtures recording at least one ejection — used to identify high-risk events for enhanced security deployment."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`security_emergency_activation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Emergency response KPIs — tracks activation frequency, false alarm rates, evacuation outcomes, fatality and injury counts, regulatory reporting compliance, and response duration to support executive safety governance and post-incident reviews."
  source: "`sports_entertainment_ecm`.`security`.`emergency_activation`"
  dimensions:
    - name: "activation_status"
      expr: activation_status
      comment: "Current status of the emergency activation (e.g. ACTIVE, RESOLVED, CANCELLED) — used to monitor live and historical emergency events."
    - name: "plan_type"
      expr: plan_type
      comment: "Type of emergency response plan activated (e.g. EVACUATION, LOCKDOWN, SHELTER_IN_PLACE) — primary dimension for emergency type analysis."
    - name: "threat_category"
      expr: threat_category
      comment: "Category of threat that triggered the activation (e.g. FIRE, SECURITY_THREAT, MEDICAL_MASS_CASUALTY) — used to analyse threat type distribution."
    - name: "incident_severity_level"
      expr: incident_severity_level
      comment: "Severity level of the emergency incident — used to prioritise post-incident review and resource allocation."
    - name: "activation_source"
      expr: activation_source
      comment: "Source that triggered the activation (e.g. SECURITY_OFFICER, AUTOMATED_SYSTEM, LAW_ENFORCEMENT) — informs detection system effectiveness."
    - name: "evacuation_type"
      expr: evacuation_type
      comment: "Type of evacuation executed (e.g. FULL, PARTIAL, SHELTER_IN_PLACE) — used to analyse evacuation protocol distribution."
    - name: "activation_month"
      expr: DATE_TRUNC('month', activation_timestamp)
      comment: "Calendar month of the emergency activation — supports monthly and annual emergency frequency reporting."
    - name: "activation_year"
      expr: DATE_TRUNC('year', activation_timestamp)
      comment: "Calendar year of the emergency activation — supports annual safety performance benchmarking."
  measures:
    - name: "total_emergency_activations"
      expr: COUNT(1)
      comment: "Total number of emergency plan activations — baseline metric for emergency frequency and safety risk exposure."
    - name: "total_real_activations"
      expr: COUNT(CASE WHEN drill_exercise = FALSE AND false_alarm = FALSE THEN 1 END)
      comment: "Total genuine (non-drill, non-false-alarm) emergency activations — the most critical safety metric for executive and regulatory reporting."
    - name: "total_false_alarms"
      expr: COUNT(CASE WHEN false_alarm = TRUE THEN 1 END)
      comment: "Total activations identified as false alarms — high false alarm rates erode public trust and waste emergency response resources."
    - name: "false_alarm_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN false_alarm = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of activations that were false alarms — a key system reliability metric for emergency detection infrastructure."
    - name: "total_evacuations_initiated"
      expr: COUNT(CASE WHEN evacuation_initiated = TRUE THEN 1 END)
      comment: "Total activations that resulted in venue evacuation — a high-stakes safety metric reviewed at board and regulatory levels."
    - name: "total_lockdowns_initiated"
      expr: COUNT(CASE WHEN lockdown_initiated = TRUE THEN 1 END)
      comment: "Total activations that resulted in venue lockdown — measures the frequency of the most severe security response actions."
    - name: "total_events_cancelled"
      expr: COUNT(CASE WHEN event_cancelled = TRUE THEN 1 END)
      comment: "Total activations resulting in event cancellation — directly informs revenue impact assessment and insurance claim analysis."
    - name: "total_regulatory_reports_filed"
      expr: COUNT(CASE WHEN regulatory_report_filed = TRUE THEN 1 END)
      comment: "Total activations requiring regulatory report filing — measures compliance with mandatory incident reporting obligations."
    - name: "regulatory_reporting_compliance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN regulatory_report_filed = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN drill_exercise = FALSE AND false_alarm = FALSE THEN 1 END), 0), 2)
      comment: "Percentage of real emergency activations for which a regulatory report was filed — a critical compliance KPI for governing body and regulatory audits."
    - name: "total_insurance_claims_filed"
      expr: COUNT(CASE WHEN insurance_claim_filed = TRUE THEN 1 END)
      comment: "Total emergency activations resulting in an insurance claim — directly informs risk management and insurance cost forecasting."
    - name: "total_broadcast_interruptions"
      expr: COUNT(CASE WHEN broadcast_interrupted = TRUE THEN 1 END)
      comment: "Total activations that interrupted broadcast — measures the commercial and reputational impact of emergency events on media operations."
    - name: "total_drill_exercises"
      expr: COUNT(CASE WHEN drill_exercise = TRUE THEN 1 END)
      comment: "Total planned drill exercises conducted — measures compliance with emergency preparedness training requirements."
    - name: "distinct_venues_with_activations"
      expr: COUNT(DISTINCT venue_id)
      comment: "Number of distinct venues that experienced an emergency activation — used to identify venues with elevated safety risk profiles."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`security_credential_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Credential assignment lifecycle KPIs — tracks assignment volumes, pickup and return compliance, revocation rates, multi-zone access distribution, and vehicle access grants to support accreditation operations and event-day security management."
  source: "`sports_entertainment_ecm`.`security`.`credential_assignment`"
  dimensions:
    - name: "assignment_status"
      expr: assignment_status
      comment: "Current status of the credential assignment (e.g. ACTIVE, REVOKED, RETURNED, EXPIRED) — primary dimension for assignment lifecycle analysis."
    - name: "credential_type"
      expr: credential_type
      comment: "Type of credential assigned (e.g. MEDIA, ATHLETE, STAFF) — used to analyse assignment distribution by credential category."
    - name: "holder_type"
      expr: holder_type
      comment: "Type of credential holder (e.g. FAN, ATHLETE, OFFICIAL, SPONSOR) — enables segmented assignment analysis."
    - name: "access_level"
      expr: access_level
      comment: "Access level granted by the assignment — used to monitor high-privilege access distribution."
    - name: "credential_scope"
      expr: credential_scope
      comment: "Scope of the credential assignment (e.g. SINGLE_EVENT, SEASON, TOURNAMENT) — used to analyse assignment duration and risk exposure."
    - name: "background_check_status"
      expr: background_check_status
      comment: "Background check status at time of assignment — critical for compliance monitoring."
    - name: "holder_organization"
      expr: holder_organization
      comment: "Organisation of the credential holder — enables organisation-level assignment portfolio management."
    - name: "assignment_date"
      expr: DATE_TRUNC('day', assignment_date)
      comment: "Calendar date of the credential assignment — enables daily assignment volume trend analysis."
  measures:
    - name: "total_assignments"
      expr: COUNT(1)
      comment: "Total number of credential assignments — baseline metric for accreditation operations volume and event-day access management."
    - name: "total_active_assignments"
      expr: COUNT(CASE WHEN assignment_status = 'ACTIVE' THEN 1 END)
      comment: "Total currently active credential assignments — measures live access exposure across the organisation."
    - name: "total_revoked_assignments"
      expr: COUNT(CASE WHEN assignment_status = 'REVOKED' THEN 1 END)
      comment: "Total revoked credential assignments — elevated revocation counts signal security incidents or compliance failures."
    - name: "assignment_revocation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN assignment_status = 'REVOKED' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assignments that were revoked — a key security governance metric for accreditation quality control."
    - name: "total_pickup_confirmed"
      expr: COUNT(CASE WHEN pickup_confirmed = TRUE THEN 1 END)
      comment: "Total assignments where credential pickup was confirmed — measures accreditation collection compliance."
    - name: "pickup_confirmation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN pickup_confirmed = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assignments with confirmed pickup — low rates indicate uncollected credentials that represent untracked access risk."
    - name: "total_return_confirmed"
      expr: COUNT(CASE WHEN return_confirmed = TRUE THEN 1 END)
      comment: "Total assignments where credential return was confirmed — measures credential recovery compliance and reduces residual access risk."
    - name: "return_confirmation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN return_confirmed = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assignments with confirmed credential return — unreturned credentials represent ongoing security exposure."
    - name: "total_multi_zone_access_assignments"
      expr: COUNT(CASE WHEN multi_zone_access = TRUE THEN 1 END)
      comment: "Total assignments granting multi-zone access — used to monitor high-privilege access distribution and least-privilege policy compliance."
    - name: "multi_zone_access_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN multi_zone_access = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of assignments with multi-zone access — high rates may indicate over-provisioning of access privileges."
    - name: "total_vehicle_access_assignments"
      expr: COUNT(CASE WHEN vehicle_access = TRUE THEN 1 END)
      comment: "Total assignments granting vehicle access — used to manage vehicle access risk and perimeter security planning."
    - name: "total_escort_required_assignments"
      expr: COUNT(CASE WHEN escort_required = TRUE THEN 1 END)
      comment: "Total assignments requiring escort — directly informs security staffing requirements for escorted access management."
    - name: "distinct_venues_assigned"
      expr: COUNT(DISTINCT venue_id)
      comment: "Number of distinct venues covered by credential assignments — measures the geographic and operational scope of accreditation activity."
$$;
