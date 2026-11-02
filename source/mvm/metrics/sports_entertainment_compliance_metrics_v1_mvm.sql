-- Metric views for domain: compliance | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_regulatory_filing`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs over regulatory filings — tracks submission compliance rates, penalty exposure, overdue filings, and amendment rates to help the Chief Compliance Officer and General Counsel steer regulatory risk posture across all governing bodies and jurisdictions."
  source: "`sports_entertainment_ecm`.`compliance`.`regulatory_filing`"
  dimensions:
    - name: "filing_status"
      expr: filing_status
      comment: "Current lifecycle status of the regulatory filing (e.g. Submitted, Pending, Overdue, Rejected) — primary grouping for compliance health dashboards."
    - name: "filing_type"
      expr: filing_type
      comment: "Type of regulatory filing (e.g. Annual Report, Incident Notification, License Renewal) — used to segment workload and risk by obligation category."
    - name: "filing_category"
      expr: filing_category
      comment: "Broad category of the filing (e.g. Anti-Doping, Data Privacy, Financial) — enables cross-domain compliance benchmarking."
    - name: "regulatory_framework"
      expr: regulatory_framework
      comment: "The regulatory framework governing the filing (e.g. GDPR, WADA, FCC) — critical for framework-level compliance reporting."
    - name: "jurisdiction"
      expr: jurisdiction
      comment: "Jurisdiction in which the filing obligation arises — supports geographic risk segmentation."
    - name: "is_amendment"
      expr: is_amendment
      comment: "Boolean flag indicating whether this filing is an amendment to a prior submission — high amendment rates signal data quality or process issues."
    - name: "is_recurring"
      expr: is_recurring
      comment: "Boolean flag indicating whether the filing obligation recurs on a schedule — helps distinguish one-off vs. ongoing compliance obligations."
    - name: "penalty_risk_flag"
      expr: penalty_risk_flag
      comment: "Boolean flag indicating the filing carries a penalty risk — used to prioritise remediation queues."
    - name: "submission_method"
      expr: submission_method
      comment: "Channel used to submit the filing (e.g. Portal, Email, Paper) — informs process automation opportunities."
    - name: "due_date_month"
      expr: DATE_TRUNC('MONTH', due_date)
      comment: "Month in which the filing is due — enables trend analysis of filing volumes and on-time rates over time."
    - name: "submission_month"
      expr: DATE_TRUNC('MONTH', CAST(submission_timestamp AS DATE))
      comment: "Month in which the filing was actually submitted — used alongside due_date_month to compute latency trends."
    - name: "confidentiality_level"
      expr: confidentiality_level
      comment: "Sensitivity classification of the filing — governs access controls and disclosure obligations."
  measures:
    - name: "total_filings"
      expr: COUNT(1)
      comment: "Total number of regulatory filings in scope — baseline volume metric for workload and capacity planning."
    - name: "on_time_submission_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN filing_status = 'Submitted' AND submission_timestamp <= CAST(due_date AS TIMESTAMP) THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of filings submitted on or before their due date — primary KPI for regulatory compliance health; a declining rate triggers immediate escalation."
    - name: "overdue_filings_count"
      expr: SUM(CASE WHEN filing_status = 'Overdue' THEN 1 ELSE 0 END)
      comment: "Count of filings currently in Overdue status — directly signals regulatory breach risk and drives remediation prioritisation."
    - name: "rejected_filings_count"
      expr: SUM(CASE WHEN filing_status = 'Rejected' THEN 1 ELSE 0 END)
      comment: "Count of filings rejected by the governing body — high rejection rates indicate submission quality issues requiring process intervention."
    - name: "total_penalty_exposure"
      expr: SUM(CAST(penalty_amount AS DOUBLE))
      comment: "Total monetary penalty amount across all filings with assessed penalties — key financial risk metric reported to CFO and General Counsel."
    - name: "avg_penalty_per_filing"
      expr: AVG(CAST(penalty_amount AS DOUBLE))
      comment: "Average penalty amount per filing — benchmarks severity of non-compliance incidents and informs penalty reserve provisioning."
    - name: "amendment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_amendment = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of filings that are amendments to prior submissions — elevated rates indicate upstream data quality or process failures."
    - name: "penalty_risk_filing_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN penalty_risk_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of filings flagged as carrying penalty risk — used by compliance leadership to size contingent liability reserves."
    - name: "distinct_governing_bodies"
      expr: COUNT(DISTINCT governing_body_id)
      comment: "Number of distinct governing bodies to which filings have been made — measures regulatory relationship breadth and compliance programme scope."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_audit_engagement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Executive-level KPIs over audit engagements — tracks audit cycle health, remediation cost exposure, overdue engagements, and attestation rates to enable the Chief Audit Executive and Board Audit Committee to steer the internal controls programme."
  source: "`sports_entertainment_ecm`.`compliance`.`audit_engagement`"
  dimensions:
    - name: "audit_type"
      expr: audit_type
      comment: "High-level type of audit (e.g. Internal, External, Regulatory) — primary segmentation for audit programme reporting."
    - name: "audit_subtype"
      expr: audit_subtype
      comment: "Detailed subtype of the audit (e.g. Financial Controls, IT General Controls, Anti-Doping) — enables granular programme analysis."
    - name: "auditor_type"
      expr: auditor_type
      comment: "Whether the audit was conducted by internal or external auditors — informs resourcing and cost allocation decisions."
    - name: "engagement_status"
      expr: engagement_status
      comment: "Current lifecycle status of the engagement (e.g. Planned, In Progress, Completed, Overdue) — primary operational health indicator."
    - name: "engagement_risk_rating"
      expr: engagement_risk_rating
      comment: "Risk rating assigned to the engagement (e.g. High, Medium, Low) — drives prioritisation of audit resources."
    - name: "overall_opinion"
      expr: overall_opinion
      comment: "Auditor's overall opinion on the audited area (e.g. Satisfactory, Needs Improvement, Unsatisfactory) — headline outcome metric for board reporting."
    - name: "cycle_frequency"
      expr: cycle_frequency
      comment: "Frequency at which this audit recurs (e.g. Annual, Bi-Annual, Ad Hoc) — used to assess coverage adequacy."
    - name: "target_business_unit"
      expr: target_business_unit
      comment: "Business unit subject to the audit — enables unit-level compliance performance benchmarking."
    - name: "data_privacy_in_scope"
      expr: data_privacy_in_scope
      comment: "Boolean flag indicating whether data privacy controls are in scope — critical for GDPR/CCPA programme tracking."
    - name: "wada_program_in_scope"
      expr: wada_program_in_scope
      comment: "Boolean flag indicating whether the WADA anti-doping programme is in scope — required for sports governing body reporting."
    - name: "scheduled_start_month"
      expr: DATE_TRUNC('MONTH', scheduled_start_date)
      comment: "Month in which the audit engagement was scheduled to start — used for capacity planning and trend analysis."
    - name: "jurisdiction"
      expr: jurisdiction
      comment: "Jurisdiction in which the audit was conducted — supports geographic risk and regulatory coverage analysis."
  measures:
    - name: "total_engagements"
      expr: COUNT(1)
      comment: "Total number of audit engagements — baseline volume metric for audit programme capacity and coverage reporting."
    - name: "completed_engagement_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN engagement_status = 'Completed' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of audit engagements that have reached Completed status — primary KPI for audit programme execution effectiveness."
    - name: "total_estimated_remediation_cost"
      expr: SUM(CAST(estimated_remediation_cost AS DOUBLE))
      comment: "Total estimated cost to remediate findings across all engagements — key financial risk metric for CFO and Audit Committee budget planning."
    - name: "avg_estimated_remediation_cost"
      expr: AVG(CAST(estimated_remediation_cost AS DOUBLE))
      comment: "Average estimated remediation cost per engagement — benchmarks remediation burden and informs budget provisioning."
    - name: "attestation_issuance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN attestation_of_compliance_issued = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of completed engagements that resulted in an attestation of compliance being issued — measures the programme's ability to certify control effectiveness."
    - name: "regulatory_submission_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN regulatory_submission_required = TRUE AND regulatory_submission_date IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN regulatory_submission_required = TRUE THEN 1 ELSE 0 END), 0), 2)
      comment: "Percentage of engagements requiring regulatory submission where a submission date has been recorded — tracks fulfilment of mandatory reporting obligations."
    - name: "management_response_compliance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN management_response_received = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of engagements where management has provided a formal response — low rates indicate governance accountability gaps."
    - name: "high_risk_engagement_count"
      expr: SUM(CASE WHEN engagement_risk_rating = 'High' THEN 1 ELSE 0 END)
      comment: "Count of engagements rated High risk — headline risk concentration metric for Audit Committee reporting."
    - name: "unsatisfactory_opinion_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN overall_opinion = 'Unsatisfactory' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of engagements receiving an Unsatisfactory overall opinion — a rising rate signals systemic control failures requiring executive intervention."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_audit_finding`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Operational and strategic KPIs over individual audit findings — tracks finding severity distribution, repeat finding rates, remediation timeliness, and escalation rates to enable the Chief Audit Executive and process owners to close control gaps efficiently."
  source: "`sports_entertainment_ecm`.`compliance`.`audit_finding`"
  dimensions:
    - name: "risk_rating"
      expr: risk_rating
      comment: "Risk severity rating of the finding (e.g. Critical, High, Medium, Low) — primary dimension for prioritising remediation effort."
    - name: "finding_category"
      expr: finding_category
      comment: "Category of the finding (e.g. Access Control, Financial Reporting, Data Privacy) — enables thematic analysis of control weaknesses."
    - name: "finding_status"
      expr: finding_status
      comment: "Current lifecycle status of the finding (e.g. Open, In Remediation, Closed, Overdue) — primary operational health indicator."
    - name: "control_domain"
      expr: control_domain
      comment: "Domain of the control that failed (e.g. IT, Financial, Operational) — supports control framework gap analysis."
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Categorised root cause of the finding (e.g. Process Gap, Training, Technology) — drives systemic remediation investment decisions."
    - name: "repeat_finding"
      expr: repeat_finding
      comment: "Boolean flag indicating whether this finding was also raised in a prior audit cycle — repeat findings signal persistent control failures."
    - name: "regulatory_framework"
      expr: regulatory_framework
      comment: "Regulatory framework associated with the finding (e.g. GDPR, SOX, WADA) — required for framework-level compliance gap reporting."
    - name: "owner_department"
      expr: owner_department
      comment: "Department responsible for remediating the finding — enables accountability tracking and departmental performance benchmarking."
    - name: "auditor_type"
      expr: auditor_type
      comment: "Whether the finding was raised by an internal or external auditor — informs source-of-truth weighting in risk assessments."
    - name: "escalation_required"
      expr: escalation_required
      comment: "Boolean flag indicating whether the finding requires escalation — used to triage executive attention."
    - name: "identified_month"
      expr: DATE_TRUNC('MONTH', identified_date)
      comment: "Month in which the finding was identified — enables trend analysis of finding discovery rates over time."
  measures:
    - name: "total_findings"
      expr: COUNT(1)
      comment: "Total number of audit findings — baseline volume metric for control environment health and audit programme output."
    - name: "critical_high_finding_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN risk_rating IN ('Critical', 'High') THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of findings rated Critical or High risk — headline control environment quality metric for Board Audit Committee reporting."
    - name: "repeat_finding_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN repeat_finding = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of findings that are repeats from prior audit cycles — a high rate signals that root causes are not being addressed, triggering escalation."
    - name: "open_findings_count"
      expr: SUM(CASE WHEN finding_status = 'Open' THEN 1 ELSE 0 END)
      comment: "Count of findings currently in Open status — measures the unresolved control gap backlog requiring management action."
    - name: "overdue_remediation_count"
      expr: SUM(CASE WHEN finding_status = 'Overdue' THEN 1 ELSE 0 END)
      comment: "Count of findings where remediation is overdue — directly signals accountability failures and potential regulatory exposure."
    - name: "escalation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN escalation_required = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of findings requiring escalation — measures severity concentration and executive attention demand."
    - name: "regulatory_notification_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN regulatory_notification_required = TRUE AND regulatory_notification_date IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN regulatory_notification_required = TRUE THEN 1 ELSE 0 END), 0), 2)
      comment: "Percentage of findings requiring regulatory notification where notification has been sent — tracks fulfilment of mandatory disclosure obligations."
    - name: "distinct_engagements_with_findings"
      expr: COUNT(DISTINCT audit_engagement_id)
      comment: "Number of distinct audit engagements that have generated at least one finding — measures breadth of control weakness across the audit portfolio."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_investigation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs over compliance investigations — tracks investigation volume, severity distribution, financial impact, resolution rates, and sanction outcomes to enable the Chief Compliance Officer and Legal team to manage conduct risk and regulatory exposure."
  source: "`sports_entertainment_ecm`.`compliance`.`investigation`"
  dimensions:
    - name: "investigation_type"
      expr: investigation_type
      comment: "Type of investigation (e.g. Match Fixing, Doping, Fraud, Harassment) — primary dimension for conduct risk categorisation."
    - name: "investigation_status"
      expr: investigation_status
      comment: "Current lifecycle status of the investigation (e.g. Open, In Progress, Closed, Escalated) — primary operational health indicator."
    - name: "severity_level"
      expr: severity_level
      comment: "Severity classification of the investigation (e.g. Critical, High, Medium, Low) — drives resource allocation and escalation decisions."
    - name: "priority_level"
      expr: priority_level
      comment: "Priority assigned to the investigation — used to triage investigator workload."
    - name: "finding_outcome"
      expr: finding_outcome
      comment: "Outcome of the investigation (e.g. Substantiated, Unsubstantiated, Inconclusive) — key metric for assessing allegation quality and investigative effectiveness."
    - name: "subject_type"
      expr: subject_type
      comment: "Type of entity under investigation (e.g. Athlete, Official, Franchise, Sponsor) — enables risk concentration analysis by entity class."
    - name: "confidentiality_level"
      expr: confidentiality_level
      comment: "Sensitivity classification of the investigation — governs access controls and disclosure obligations."
    - name: "regulatory_filing_required_flag"
      expr: regulatory_filing_required_flag
      comment: "Boolean flag indicating whether a regulatory filing is required as a result of the investigation — tracks mandatory disclosure obligations."
    - name: "appeal_filed_flag"
      expr: appeal_filed_flag
      comment: "Boolean flag indicating whether an appeal has been filed against the investigation outcome — high appeal rates may signal procedural fairness issues."
    - name: "initiated_month"
      expr: DATE_TRUNC('MONTH', initiated_date)
      comment: "Month in which the investigation was initiated — enables trend analysis of investigation intake volumes."
  measures:
    - name: "total_investigations"
      expr: COUNT(1)
      comment: "Total number of compliance investigations — baseline volume metric for conduct risk programme sizing and resource planning."
    - name: "substantiation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN finding_outcome = 'Substantiated' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of investigations resulting in a substantiated finding — measures the quality of allegation intake and the effectiveness of the compliance programme."
    - name: "open_investigation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN investigation_status = 'Open' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of investigations currently open — a rising rate signals capacity constraints or case complexity increases."
    - name: "total_estimated_financial_impact"
      expr: SUM(CAST(estimated_financial_impact AS DOUBLE))
      comment: "Total estimated financial impact across all investigations — key risk quantification metric for CFO and Board risk reporting."
    - name: "avg_estimated_financial_impact"
      expr: AVG(CAST(estimated_financial_impact AS DOUBLE))
      comment: "Average estimated financial impact per investigation — benchmarks severity of conduct incidents and informs contingent liability provisioning."
    - name: "critical_high_severity_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN severity_level IN ('Critical', 'High') THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of investigations classified as Critical or High severity — headline conduct risk concentration metric for executive reporting."
    - name: "appeal_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN appeal_filed_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of investigations where an appeal was filed — elevated rates may indicate procedural fairness concerns or disproportionate sanctions."
    - name: "regulatory_filing_fulfilment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN regulatory_filing_required_flag = TRUE AND regulatory_filing_date IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN regulatory_filing_required_flag = TRUE THEN 1 ELSE 0 END), 0), 2)
      comment: "Percentage of investigations requiring a regulatory filing where the filing date has been recorded — tracks mandatory disclosure compliance."
    - name: "distinct_franchises_investigated"
      expr: COUNT(DISTINCT franchise_id)
      comment: "Number of distinct franchises involved in investigations — measures breadth of conduct risk exposure across the league portfolio."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_doping_test`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Anti-doping programme KPIs over doping tests — tracks test volumes, adverse finding rates, therapeutic use exemption rates, whereabouts compliance, and B-sample request rates to enable the Anti-Doping Officer and governing body to manage WADA programme integrity."
  source: "`sports_entertainment_ecm`.`compliance`.`doping_test`"
  dimensions:
    - name: "test_type"
      expr: test_type
      comment: "Type of doping test (e.g. In-Competition, Out-of-Competition, Target) — primary dimension for test programme coverage analysis."
    - name: "result_status"
      expr: result_status
      comment: "Result status of the doping test (e.g. Negative, Adverse Analytical Finding, Atypical Finding) — primary outcome metric for anti-doping programme effectiveness."
    - name: "sample_type"
      expr: sample_type
      comment: "Type of biological sample collected (e.g. Urine, Blood, Dried Blood Spot) — used to analyse test methodology distribution."
    - name: "prohibited_substance_category"
      expr: prohibited_substance_category
      comment: "WADA prohibited substance category (e.g. Anabolic Agents, Stimulants, Peptide Hormones) — enables substance-level risk analysis."
    - name: "sport_discipline"
      expr: sport_discipline
      comment: "Sport or discipline in which the athlete competes — enables sport-level anti-doping programme benchmarking."
    - name: "testing_authority"
      expr: testing_authority
      comment: "Organisation that conducted the test (e.g. WADA, USADA, National Federation) — tracks testing authority distribution."
    - name: "registered_testing_pool"
      expr: registered_testing_pool
      comment: "Testing pool to which the athlete belongs (e.g. International Registered Testing Pool, National Registered Testing Pool) — used to assess coverage of high-risk athletes."
    - name: "whereabouts_compliance_status"
      expr: whereabouts_compliance_status
      comment: "Athlete's whereabouts compliance status at time of test — critical for WADA whereabouts programme monitoring."
    - name: "collection_country_code"
      expr: collection_country_code
      comment: "Country in which the sample was collected — enables geographic distribution analysis of the testing programme."
    - name: "collection_month"
      expr: DATE_TRUNC('MONTH', collection_date)
      comment: "Month of sample collection — enables trend analysis of testing volumes and adverse finding rates over time."
    - name: "sanction_status"
      expr: sanction_status
      comment: "Current sanction status resulting from the test (e.g. Sanctioned, Provisional Suspension, No Sanction) — tracks enforcement outcomes."
  measures:
    - name: "total_tests_conducted"
      expr: COUNT(1)
      comment: "Total number of doping tests conducted — baseline volume metric for anti-doping programme coverage and WADA reporting."
    - name: "adverse_analytical_finding_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN result_status = 'Adverse Analytical Finding' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tests resulting in an Adverse Analytical Finding — primary anti-doping programme integrity KPI reported to governing bodies and WADA."
    - name: "b_sample_request_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN b_sample_analysis_requested = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tests where a B-sample analysis was requested — measures the rate of contested adverse findings and associated procedural burden."
    - name: "therapeutic_use_exemption_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN therapeutic_use_exemption_granted = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tests where a Therapeutic Use Exemption was granted — monitors TUE programme utilisation and potential abuse risk."
    - name: "whereabouts_non_compliance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN whereabouts_compliance_status != 'Compliant' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tests associated with a whereabouts non-compliance status — a rising rate signals athletes approaching the three-strike threshold for an anti-doping rule violation."
    - name: "sanctioned_test_count"
      expr: SUM(CASE WHEN sanction_status = 'Sanctioned' THEN 1 ELSE 0 END)
      comment: "Count of tests that resulted in a formal sanction — measures enforcement output of the anti-doping programme."
    - name: "distinct_athletes_tested"
      expr: COUNT(DISTINCT athlete_profile_id)
      comment: "Number of distinct athletes tested — measures breadth of anti-doping programme coverage across the registered athlete population."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_doping_violation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Anti-doping enforcement KPIs over confirmed doping violations — tracks violation types, ban durations, appeal outcomes, public disclosure rates, and results disqualification rates to enable the Anti-Doping Officer and governing body to report on enforcement effectiveness."
  source: "`sports_entertainment_ecm`.`compliance`.`doping_violation`"
  dimensions:
    - name: "violation_type"
      expr: violation_type
      comment: "Type of anti-doping rule violation (e.g. Presence of Prohibited Substance, Use, Whereabouts Failure) — primary dimension for violation classification reporting."
    - name: "violation_status"
      expr: violation_status
      comment: "Current status of the violation case (e.g. Pending, Sanctioned, Appealed, Resolved) — primary lifecycle tracking dimension."
    - name: "sanction_type"
      expr: sanction_type
      comment: "Type of sanction imposed (e.g. Ineligibility, Disqualification, Warning) — used to analyse enforcement severity distribution."
    - name: "prohibited_substance_category"
      expr: prohibited_substance_category
      comment: "WADA prohibited substance category associated with the violation — enables substance-level risk analysis and programme targeting."
    - name: "sport_discipline"
      expr: sport_discipline
      comment: "Sport or discipline of the athlete — enables sport-level violation rate benchmarking."
    - name: "appeal_status"
      expr: appeal_status
      comment: "Status of any appeal filed against the violation decision — tracks CAS and governing body appeal outcomes."
    - name: "in_competition_flag"
      expr: in_competition_flag
      comment: "Boolean flag indicating whether the violation occurred in-competition — in-competition violations carry additional results disqualification consequences."
    - name: "public_disclosure_flag"
      expr: public_disclosure_flag
      comment: "Boolean flag indicating whether the violation has been publicly disclosed — WADA requires public disclosure for most violations."
    - name: "nationality_code"
      expr: nationality_code
      comment: "Nationality of the athlete involved — enables geographic distribution analysis of violations."
    - name: "decision_year"
      expr: DATE_TRUNC('YEAR', decision_date)
      comment: "Year in which the violation decision was issued — enables year-over-year trend analysis of enforcement activity."
  measures:
    - name: "total_violations"
      expr: COUNT(1)
      comment: "Total number of confirmed anti-doping rule violations — baseline enforcement volume metric for WADA and governing body annual reporting."
    - name: "results_disqualification_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN results_disqualified_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of violations resulting in results disqualification — measures the competitive integrity impact of anti-doping enforcement."
    - name: "public_disclosure_compliance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN public_disclosure_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of violations that have been publicly disclosed — WADA mandates public disclosure; a rate below 100% signals a compliance gap."
    - name: "appeal_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN b_sample_requested_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of violations where a B-sample was requested — proxy for contested violations and associated legal/procedural burden."
    - name: "therapeutic_use_exemption_violation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN therapeutic_use_exemption_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of violations involving a Therapeutic Use Exemption — monitors TUE-related enforcement complexity."
    - name: "in_competition_violation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN in_competition_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of violations that occurred in-competition — in-competition violations have the highest competitive integrity impact and trigger automatic results disqualification."
    - name: "distinct_athletes_with_violations"
      expr: COUNT(DISTINCT athlete_profile_id)
      comment: "Number of distinct athletes with confirmed violations — measures the breadth of the doping problem across the athlete population."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_privacy_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Data privacy rights KPIs over privacy requests (DSARs, erasure, consent) — tracks request volumes, on-time fulfilment rates, DPO review rates, and identity verification compliance to enable the Data Protection Officer and Privacy team to manage GDPR/CCPA obligations."
  source: "`sports_entertainment_ecm`.`compliance`.`privacy_request`"
  dimensions:
    - name: "request_type"
      expr: request_type
      comment: "Type of privacy request (e.g. Access, Erasure, Rectification, Portability, Opt-Out) — primary dimension for GDPR/CCPA rights fulfilment reporting."
    - name: "request_status"
      expr: request_status
      comment: "Current lifecycle status of the request (e.g. Pending, In Progress, Fulfilled, Rejected, Overdue) — primary operational health indicator."
    - name: "applicable_regulation"
      expr: applicable_regulation
      comment: "Regulation under which the request was made (e.g. GDPR, CCPA, LGPD) — enables regulation-level compliance reporting."
    - name: "data_subject_jurisdiction"
      expr: data_subject_jurisdiction
      comment: "Jurisdiction of the data subject — required for geographic compliance reporting and supervisory authority notifications."
    - name: "submission_channel"
      expr: submission_channel
      comment: "Channel through which the request was submitted (e.g. Web Portal, Email, Phone) — informs channel optimisation for privacy request intake."
    - name: "identity_verification_status"
      expr: identity_verification_status
      comment: "Status of identity verification for the requestor — unverified requests cannot be fulfilled, impacting compliance metrics."
    - name: "response_outcome"
      expr: response_outcome
      comment: "Outcome of the privacy request response (e.g. Fulfilled, Partially Fulfilled, Rejected) — measures fulfilment quality."
    - name: "dpo_review_required"
      expr: dpo_review_required
      comment: "Boolean flag indicating whether DPO review is required for this request — high-complexity requests requiring DPO involvement."
    - name: "legal_hold_flag"
      expr: legal_hold_flag
      comment: "Boolean flag indicating the request is subject to a legal hold — legal holds prevent erasure and must be tracked for compliance."
    - name: "submitted_month"
      expr: DATE_TRUNC('MONTH', CAST(submitted_at AS DATE))
      comment: "Month in which the privacy request was submitted — enables trend analysis of request volumes and seasonal patterns."
    - name: "consent_type"
      expr: consent_type
      comment: "Type of consent action associated with the request (e.g. Opt-In, Opt-Out, Withdrawal) — tracks consent lifecycle management."
  measures:
    - name: "total_privacy_requests"
      expr: COUNT(1)
      comment: "Total number of privacy requests received — baseline volume metric for privacy programme capacity planning and regulatory reporting."
    - name: "on_time_fulfilment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN request_status = 'Fulfilled' AND fulfillment_date <= regulatory_deadline THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN request_status = 'Fulfilled' THEN 1 ELSE 0 END), 0), 2)
      comment: "Percentage of fulfilled requests completed within the regulatory deadline — primary GDPR/CCPA compliance KPI; breaches trigger supervisory authority scrutiny."
    - name: "overdue_request_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN request_status = 'Overdue' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of privacy requests currently overdue — directly signals regulatory breach risk and potential supervisory authority complaints."
    - name: "rejection_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN request_status = 'Rejected' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of privacy requests rejected — high rejection rates may indicate overly restrictive processing or identity verification barriers."
    - name: "dpo_review_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN dpo_review_required = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of requests requiring DPO review — measures complexity concentration and DPO workload demand."
    - name: "identity_verified_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN identity_verification_status = 'Verified' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of requests where identity has been successfully verified — unverified requests cannot be fulfilled; low rates indicate intake process friction."
    - name: "legal_hold_impacted_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN legal_hold_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of privacy requests subject to a legal hold — these requests cannot be erased and require special handling to avoid compliance conflicts."
    - name: "distinct_data_subjects"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Number of distinct data subjects who have submitted privacy requests — measures the breadth of privacy rights exercise across the fan base."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_obligation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Compliance obligation portfolio KPIs — tracks obligation coverage, mandatory obligation rates, penalty exposure, review currency, and recurring obligation proportions to enable the Chief Compliance Officer to manage the regulatory obligation register and prioritise remediation investment."
  source: "`sports_entertainment_ecm`.`compliance`.`obligation`"
  dimensions:
    - name: "obligation_type"
      expr: obligation_type
      comment: "Type of compliance obligation (e.g. Reporting, Licensing, Anti-Doping, Data Privacy) — primary dimension for obligation portfolio segmentation."
    - name: "compliance_category"
      expr: compliance_category
      comment: "Compliance category of the obligation (e.g. Regulatory, Contractual, Internal Policy) — used to distinguish externally mandated from internally imposed obligations."
    - name: "obligation_status"
      expr: obligation_status
      comment: "Current status of the obligation (e.g. Active, Expired, Under Review) — primary lifecycle tracking dimension."
    - name: "risk_level"
      expr: risk_level
      comment: "Risk level associated with non-compliance with this obligation (e.g. Critical, High, Medium, Low) — drives prioritisation of compliance investment."
    - name: "regulatory_framework"
      expr: regulatory_framework
      comment: "Regulatory framework from which the obligation derives (e.g. GDPR, WADA, FCC) — enables framework-level obligation coverage analysis."
    - name: "is_mandatory"
      expr: is_mandatory
      comment: "Boolean flag indicating whether the obligation is legally mandatory — mandatory obligations carry the highest non-compliance risk."
    - name: "is_recurring"
      expr: is_recurring
      comment: "Boolean flag indicating whether the obligation recurs on a schedule — recurring obligations require ongoing monitoring and resource allocation."
    - name: "responsible_business_unit"
      expr: responsible_business_unit
      comment: "Business unit responsible for fulfilling the obligation — enables accountability tracking and workload distribution analysis."
    - name: "review_frequency"
      expr: review_frequency
      comment: "Frequency at which the obligation is reviewed (e.g. Annual, Quarterly) — used to assess review programme adequacy."
    - name: "effective_year"
      expr: DATE_TRUNC('YEAR', effective_date)
      comment: "Year in which the obligation became effective — enables cohort analysis of obligation vintage and regulatory change impact."
  measures:
    - name: "total_obligations"
      expr: COUNT(1)
      comment: "Total number of compliance obligations in the register — baseline metric for compliance programme scope and resource planning."
    - name: "mandatory_obligation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_mandatory = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of obligations that are legally mandatory — mandatory obligations carry the highest non-compliance risk and must be prioritised."
    - name: "high_critical_risk_obligation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN risk_level IN ('Critical', 'High') THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of obligations rated Critical or High risk — headline risk concentration metric for compliance programme prioritisation."
    - name: "total_max_penalty_exposure"
      expr: SUM(CAST(penalty_max_amount AS DOUBLE))
      comment: "Total maximum penalty exposure across all obligations — key financial risk metric for CFO and Board risk reporting; quantifies the cost of non-compliance."
    - name: "avg_max_penalty_per_obligation"
      expr: AVG(CAST(penalty_max_amount AS DOUBLE))
      comment: "Average maximum penalty per obligation — benchmarks penalty severity and informs risk-weighted compliance investment decisions."
    - name: "overdue_review_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN next_review_date < CURRENT_DATE() THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of obligations whose next review date has passed without a completed review — stale obligations may no longer reflect current regulatory requirements."
    - name: "recurring_obligation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_recurring = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of obligations that are recurring — recurring obligations require sustained operational capacity and cannot be treated as one-off projects."
    - name: "distinct_governing_bodies"
      expr: COUNT(DISTINCT governing_body_id)
      comment: "Number of distinct governing bodies imposing obligations — measures regulatory relationship breadth and compliance programme complexity."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_arbitration_case`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Legal and arbitration risk KPIs over arbitration cases — tracks case volumes, award and settlement amounts, outside counsel spend, appeal rates, and enforcement status to enable the General Counsel and CFO to manage legal risk exposure and litigation strategy."
  source: "`sports_entertainment_ecm`.`compliance`.`arbitration_case`"
  dimensions:
    - name: "case_type"
      expr: case_type
      comment: "Type of arbitration case (e.g. Contract Dispute, Doping Appeal, Employment, Intellectual Property) — primary dimension for legal risk categorisation."
    - name: "case_status"
      expr: case_status
      comment: "Current lifecycle status of the case (e.g. Open, Pending Hearing, Settled, Closed) — primary operational health indicator."
    - name: "case_priority"
      expr: case_priority
      comment: "Priority level assigned to the case — drives resource allocation and senior counsel attention."
    - name: "forum"
      expr: forum
      comment: "Arbitration forum in which the case is being heard (e.g. CAS, AAA, ICC) — used to analyse forum-level outcome patterns."
    - name: "jurisdiction"
      expr: jurisdiction
      comment: "Legal jurisdiction of the arbitration — enables geographic legal risk analysis."
    - name: "claimant_type"
      expr: claimant_type
      comment: "Type of claimant (e.g. Athlete, Franchise, Sponsor, Governing Body) — used to analyse the source of legal challenges."
    - name: "respondent_type"
      expr: respondent_type
      comment: "Type of respondent (e.g. League, Franchise, Athlete) — used to analyse which entities are most frequently subject to arbitration."
    - name: "enforcement_status"
      expr: enforcement_status
      comment: "Status of award enforcement (e.g. Enforced, Pending, Contested) — tracks post-award compliance."
    - name: "appeal_filed"
      expr: appeal_filed
      comment: "Boolean flag indicating whether an appeal has been filed — high appeal rates signal contested outcomes and extended legal exposure."
    - name: "filing_month"
      expr: DATE_TRUNC('MONTH', filing_date)
      comment: "Month in which the arbitration case was filed — enables trend analysis of case intake volumes."
    - name: "sport_or_league"
      expr: sport_or_league
      comment: "Sport or league associated with the case — enables sport-level legal risk benchmarking."
  measures:
    - name: "total_cases"
      expr: COUNT(1)
      comment: "Total number of arbitration cases — baseline volume metric for legal department capacity planning and risk programme sizing."
    - name: "total_award_amount"
      expr: SUM(CAST(award_amount AS DOUBLE))
      comment: "Total monetary value of arbitration awards — key financial risk metric for CFO and Board reporting; quantifies realised legal liability."
    - name: "total_settlement_amount"
      expr: SUM(CAST(settlement_amount AS DOUBLE))
      comment: "Total monetary value of case settlements — measures the cost of resolving disputes outside of full arbitration proceedings."
    - name: "total_estimated_liability"
      expr: SUM(CAST(estimated_liability_amount AS DOUBLE))
      comment: "Total estimated liability across all open cases — key contingent liability metric for financial statement provisioning."
    - name: "total_outside_counsel_spend"
      expr: SUM(CAST(outside_counsel_spend AS DOUBLE))
      comment: "Total spend on external legal counsel across all cases — measures the operational cost of the arbitration programme and informs make-vs-buy decisions for legal resources."
    - name: "avg_outside_counsel_spend_per_case"
      expr: AVG(CAST(outside_counsel_spend AS DOUBLE))
      comment: "Average outside counsel spend per arbitration case — benchmarks legal cost efficiency and identifies outlier cases for cost management."
    - name: "appeal_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN appeal_filed = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of cases where an appeal has been filed — elevated rates signal contested outcomes and extended legal exposure."
    - name: "interim_measures_grant_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN interim_measures_granted = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of cases where interim measures were granted — measures the urgency and severity of disputes requiring immediate relief."
    - name: "settlement_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN settlement_amount > 0 THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of cases resolved through settlement — a higher settlement rate may indicate effective early dispute resolution, reducing full arbitration costs."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`compliance_whereabouts_filing`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "WADA whereabouts programme KPIs over athlete whereabouts filings — tracks filing compliance rates, late submission rates, violation threshold breaches, and notification fulfilment to enable the Anti-Doping Officer to manage whereabouts programme integrity and prevent rule violations."
  source: "`sports_entertainment_ecm`.`compliance`.`whereabouts_filing`"
  dimensions:
    - name: "compliance_status"
      expr: compliance_status
      comment: "Whereabouts filing compliance status (e.g. Compliant, Non-Compliant, Missed) — primary outcome dimension for whereabouts programme monitoring."
    - name: "testing_pool_type"
      expr: testing_pool_type
      comment: "Type of registered testing pool (e.g. International, National) — athletes in higher pools face stricter whereabouts requirements."
    - name: "sport_discipline"
      expr: sport_discipline
      comment: "Sport or discipline of the athlete — enables sport-level whereabouts compliance benchmarking."
    - name: "filing_period_quarter"
      expr: filing_period_quarter
      comment: "Quarter of the filing period (e.g. Q1, Q2, Q3, Q4) — whereabouts filings are submitted quarterly; used for period-level compliance analysis."
    - name: "filing_period_year"
      expr: filing_period_year
      comment: "Year of the filing period — enables year-over-year whereabouts compliance trend analysis."
    - name: "is_late_submission"
      expr: is_late_submission
      comment: "Boolean flag indicating whether the filing was submitted after the deadline — late submissions count toward the three-strike whereabouts violation threshold."
    - name: "violation_threshold_reached"
      expr: violation_threshold_reached
      comment: "Boolean flag indicating whether the athlete has reached the violation threshold (three failures in 12 months) — threshold breaches trigger formal anti-doping rule violation proceedings."
    - name: "review_status"
      expr: review_status
      comment: "Status of the filing review (e.g. Pending Review, Reviewed, Disputed) — tracks the administrative processing of whereabouts filings."
    - name: "submission_method"
      expr: submission_method
      comment: "Method used to submit the whereabouts filing (e.g. ADAMS, Email, Paper) — ADAMS is the WADA-mandated system; non-ADAMS submissions may indicate compliance gaps."
    - name: "overnight_location_country"
      expr: overnight_location_country
      comment: "Country of the athlete's overnight location — enables geographic distribution analysis of athlete whereabouts."
    - name: "filing_deadline_month"
      expr: DATE_TRUNC('MONTH', filing_deadline)
      comment: "Month of the filing deadline — used for trend analysis of filing volumes and compliance rates over time."
  measures:
    - name: "total_whereabouts_filings"
      expr: COUNT(1)
      comment: "Total number of whereabouts filings — baseline volume metric for WADA programme coverage and administrative workload."
    - name: "whereabouts_compliance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN compliance_status = 'Compliant' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of whereabouts filings with a Compliant status — primary WADA programme integrity KPI; a declining rate signals increasing anti-doping rule violation risk."
    - name: "late_submission_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_late_submission = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of whereabouts filings submitted after the deadline — late submissions count toward the three-strike violation threshold and must be minimised."
    - name: "violation_threshold_breach_count"
      expr: SUM(CASE WHEN violation_threshold_reached = TRUE THEN 1 ELSE 0 END)
      comment: "Count of filings where the athlete has reached the violation threshold — each breach triggers formal anti-doping rule violation proceedings; a critical enforcement metric."
    - name: "violation_threshold_breach_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN violation_threshold_reached = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT athlete_profile_id), 0), 2)
      comment: "Percentage of distinct athletes who have reached the violation threshold — measures the proportion of the registered testing pool at risk of formal proceedings."
    - name: "notification_fulfilment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN notification_sent = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of whereabouts filings where the required notification was sent to the athlete — failure to notify is a procedural compliance gap that can invalidate subsequent enforcement actions."
    - name: "distinct_athletes_in_programme"
      expr: COUNT(DISTINCT athlete_profile_id)
      comment: "Number of distinct athletes in the whereabouts programme — measures programme coverage breadth and is a key WADA reporting metric."
$$;
