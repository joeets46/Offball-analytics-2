-- Metric views for domain: athlete | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_profile`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic athlete roster and demographic metrics providing executive visibility into active roster composition, career pipeline, NIL engagement, and physical profile distribution across sports and nationalities."
  source: "`sports_entertainment_ecm`.`athlete`.`athlete_profile`"
  dimensions:
    - name: "sport_code"
      expr: sport_code
      comment: "Sport discipline code enabling cross-sport roster and pipeline comparisons."
    - name: "career_status"
      expr: career_status
      comment: "Athlete career status (e.g. Active, Retired, Injured) for roster health segmentation."
    - name: "athlete_type"
      expr: athlete_type
      comment: "Classification of athlete type (e.g. Professional, Amateur, Draft Eligible) for pipeline analysis."
    - name: "nationality_code"
      expr: nationality_code
      comment: "Athlete nationality for international roster diversity and visa risk monitoring."
    - name: "primary_position"
      expr: primary_position
      comment: "Primary playing position for positional depth and roster gap analysis."
    - name: "eligibility_status"
      expr: eligibility_status
      comment: "Current eligibility status to identify athletes cleared vs. restricted for competition."
    - name: "injury_status"
      expr: injury_status
      comment: "Current injury designation for availability and roster planning decisions."
    - name: "nil_agreement_active"
      expr: nil_agreement_active
      comment: "Flag indicating whether the athlete has an active NIL agreement, relevant for brand and compliance oversight."
    - name: "wada_registered_testing_pool"
      expr: wada_registered_testing_pool
      comment: "Flag indicating WADA registered testing pool membership for anti-doping compliance tracking."
    - name: "draft_year"
      expr: draft_year
      comment: "Draft year cohort for generational talent pipeline analysis."
    - name: "country_of_birth_code"
      expr: country_of_birth_code
      comment: "Country of birth for talent origin and scouting geography analysis."
    - name: "pro_debut_date_year"
      expr: YEAR(pro_debut_date)
      comment: "Year of professional debut for career tenure cohort analysis."
  measures:
    - name: "total_athletes"
      expr: COUNT(DISTINCT athlete_profile_id)
      comment: "Total number of distinct athlete profiles. Baseline headcount KPI for roster sizing and league capacity planning."
    - name: "active_athletes"
      expr: COUNT(DISTINCT CASE WHEN career_status = 'Active' THEN athlete_profile_id END)
      comment: "Count of athletes with Active career status. Directly informs available playing pool and roster sufficiency decisions."
    - name: "nil_active_athlete_count"
      expr: COUNT(DISTINCT CASE WHEN nil_agreement_active = TRUE THEN athlete_profile_id END)
      comment: "Number of athletes with an active NIL agreement. Tracks NIL monetization penetration across the roster."
    - name: "nil_penetration_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN nil_agreement_active = TRUE THEN athlete_profile_id END) / NULLIF(COUNT(DISTINCT athlete_profile_id), 0), 2)
      comment: "Percentage of athletes with active NIL agreements. Measures NIL program adoption and revenue opportunity capture."
    - name: "wada_pool_athlete_count"
      expr: COUNT(DISTINCT CASE WHEN wada_registered_testing_pool = TRUE THEN athlete_profile_id END)
      comment: "Number of athletes in the WADA registered testing pool. Critical compliance KPI for anti-doping program scope."
    - name: "avg_height_cm"
      expr: ROUND(AVG(CAST(height_cm AS DOUBLE)), 2)
      comment: "Average athlete height in centimeters. Used for positional profiling and scouting benchmark analysis."
    - name: "avg_weight_kg"
      expr: ROUND(AVG(CAST(weight_kg AS DOUBLE)), 2)
      comment: "Average athlete weight in kilograms. Used for positional profiling and physical conditioning benchmarking."
    - name: "injured_athlete_count"
      expr: COUNT(DISTINCT CASE WHEN injury_status IS NOT NULL AND injury_status != 'Healthy' THEN athlete_profile_id END)
      comment: "Number of athletes currently carrying an injury designation. Directly impacts roster availability and game-day decisions."
    - name: "international_athlete_count"
      expr: COUNT(DISTINCT CASE WHEN nationality_code != country_of_birth_code THEN athlete_profile_id END)
      comment: "Count of athletes whose nationality differs from country of birth, approximating international roster diversity and visa exposure."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_contract`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Athlete contract financial and structural metrics enabling executive oversight of total contract obligations, guaranteed exposure, cap efficiency, signing activity, and contract portfolio risk."
  source: "`sports_entertainment_ecm`.`athlete`.`contract`"
  dimensions:
    - name: "contract_status"
      expr: contract_status
      comment: "Current contract status (e.g. Active, Expired, Voided) for portfolio health segmentation."
    - name: "contract_type"
      expr: contract_type
      comment: "Type of contract (e.g. Standard, Rookie, Extension) for structural analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Contract currency for multi-currency financial exposure reporting."
    - name: "roster_status"
      expr: roster_status
      comment: "Roster designation associated with the contract for active vs. reserve obligation analysis."
    - name: "free_agency_class"
      expr: free_agency_class
      comment: "Free agency classification for upcoming obligation and cap planning."
    - name: "no_trade_clause"
      expr: no_trade_clause
      comment: "Flag indicating no-trade clause presence, affecting roster flexibility decisions."
    - name: "no_cut_clause"
      expr: no_cut_clause
      comment: "Flag indicating no-cut clause presence, affecting dead cap and roster release decisions."
    - name: "performance_bonus_eligible"
      expr: performance_bonus_eligible
      comment: "Flag indicating eligibility for performance bonuses, relevant for incentive liability forecasting."
    - name: "wada_compliant"
      expr: wada_compliant
      comment: "WADA compliance flag on the contract for anti-doping contractual obligation tracking."
    - name: "nil_agreement_flag"
      expr: nil_agreement_flag
      comment: "Flag indicating whether the contract includes an NIL agreement component."
    - name: "signing_year"
      expr: YEAR(signing_date)
      comment: "Year the contract was signed for cohort and vintage analysis of contract obligations."
    - name: "start_year"
      expr: YEAR(start_date)
      comment: "Contract start year for timeline and cap year alignment."
    - name: "option_type"
      expr: option_type
      comment: "Type of contract option (e.g. Player, Team, Mutual) for flexibility and obligation risk analysis."
  measures:
    - name: "total_contracts"
      expr: COUNT(DISTINCT contract_id)
      comment: "Total number of distinct contracts. Baseline for contract portfolio sizing and workload tracking."
    - name: "total_contract_value"
      expr: SUM(CAST(total_value AS DOUBLE))
      comment: "Sum of total contract values across all contracts. Primary financial obligation KPI for executive budget oversight."
    - name: "total_guaranteed_amount"
      expr: SUM(CAST(guaranteed_amount AS DOUBLE))
      comment: "Total guaranteed money committed across all contracts. Measures irreversible financial exposure regardless of performance or roster decisions."
    - name: "total_signing_bonus"
      expr: SUM(CAST(signing_bonus AS DOUBLE))
      comment: "Total signing bonuses paid or committed. Tracks upfront cash outlay and prorated cap acceleration risk."
    - name: "total_cap_hit"
      expr: SUM(CAST(cap_hit AS DOUBLE))
      comment: "Total salary cap hit across all contracts. Core cap management KPI for league compliance and roster construction."
    - name: "total_dead_cap_amount"
      expr: SUM(CAST(dead_cap_amount AS DOUBLE))
      comment: "Total dead cap charges from released or restructured contracts. Measures the financial penalty of roster decisions and contract restructuring."
    - name: "total_performance_bonus_max"
      expr: SUM(CAST(performance_bonus_max AS DOUBLE))
      comment: "Maximum potential performance bonus liability across all eligible contracts. Informs incentive budget forecasting and worst-case cap exposure."
    - name: "avg_annual_value"
      expr: ROUND(AVG(CAST(aav AS DOUBLE)), 2)
      comment: "Average annual value (AAV) across contracts. Benchmarks contract competitiveness and market rate alignment."
    - name: "avg_cap_hit"
      expr: ROUND(AVG(CAST(cap_hit AS DOUBLE)), 2)
      comment: "Average cap hit per contract. Used to assess roster construction efficiency and cap allocation strategy."
    - name: "guaranteed_pct_of_total_value"
      expr: ROUND(100.0 * SUM(CAST(guaranteed_amount AS DOUBLE)) / NULLIF(SUM(CAST(total_value AS DOUBLE)), 0), 2)
      comment: "Guaranteed amount as a percentage of total contract value. Measures financial risk concentration and negotiation leverage outcomes."
    - name: "no_trade_clause_contract_count"
      expr: COUNT(DISTINCT CASE WHEN no_trade_clause = TRUE THEN contract_id END)
      comment: "Number of contracts with no-trade clauses. Quantifies roster flexibility constraints for trade deadline and roster management decisions."
    - name: "performance_bonus_eligible_contract_count"
      expr: COUNT(DISTINCT CASE WHEN performance_bonus_eligible = TRUE THEN contract_id END)
      comment: "Number of contracts with performance bonus eligibility. Scopes incentive liability and motivational contract structure prevalence."
    - name: "total_qualifying_offer_amount"
      expr: SUM(CAST(qualifying_offer_amount AS DOUBLE))
      comment: "Total qualifying offer amounts tendered. Tracks restricted free agency financial commitments and cap hold obligations."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_salary_cap_entry`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Granular salary cap accounting metrics enabling finance and team management to monitor cap utilization, dead cap exposure, restructuring activity, and incentive liabilities by cap year, franchise, and entry type."
  source: "`sports_entertainment_ecm`.`athlete`.`salary_cap_entry`"
  dimensions:
    - name: "cap_year"
      expr: cap_year
      comment: "Salary cap year for annual cap budget tracking and multi-year obligation planning."
    - name: "entry_type"
      expr: entry_type
      comment: "Type of cap entry (e.g. Base Salary, Signing Bonus Proration, Incentive) for cap composition analysis."
    - name: "entry_status"
      expr: entry_status
      comment: "Status of the cap entry (e.g. Active, Voided, Adjusted) for ledger accuracy monitoring."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the cap entry for multi-currency cap reporting."
    - name: "is_dead_cap"
      expr: is_dead_cap
      comment: "Flag identifying dead cap entries resulting from releases or restructures."
    - name: "is_cap_hold"
      expr: is_cap_hold
      comment: "Flag identifying cap hold entries for unsigned or restricted free agents."
    - name: "is_restructured"
      expr: is_restructured
      comment: "Flag identifying restructured contract entries for cap management activity tracking."
    - name: "void_year_flag"
      expr: void_year_flag
      comment: "Flag identifying void year entries used for cap acceleration management."
    - name: "incentive_earned_prior_year"
      expr: incentive_earned_prior_year
      comment: "Flag indicating whether a prior-year incentive was earned, triggering carryover cap adjustments."
    - name: "cap_year_start_date_month"
      expr: DATE_TRUNC('month', cap_year_start_date)
      comment: "Cap year start month for temporal cap obligation distribution analysis."
  measures:
    - name: "total_cap_hit"
      expr: SUM(CAST(cap_hit AS DOUBLE))
      comment: "Total salary cap hit across all entries. Primary cap utilization KPI for league compliance and roster construction decisions."
    - name: "total_base_salary"
      expr: SUM(CAST(base_salary AS DOUBLE))
      comment: "Total base salary obligations. Core cash compensation liability metric for payroll and budget planning."
    - name: "total_dead_cap_value"
      expr: SUM(CAST(dead_cap_value AS DOUBLE))
      comment: "Total dead cap charges. Measures the financial cost of roster decisions (cuts, trades, restructures) consuming cap space without active player contribution."
    - name: "total_signing_bonus_prorated"
      expr: SUM(CAST(signing_bonus_prorated AS DOUBLE))
      comment: "Total prorated signing bonus cap charges. Tracks the annual cap impact of signing bonus acceleration across the roster."
    - name: "total_cap_hold_amount"
      expr: SUM(CAST(cap_hold_amount AS DOUBLE))
      comment: "Total cap hold amounts for unsigned players. Quantifies cap space consumed by unsigned free agents and draft picks."
    - name: "total_likely_incentive_amount"
      expr: SUM(CAST(likely_incentive_amount AS DOUBLE))
      comment: "Total likely incentive amounts counting against the cap. Measures incentive-driven cap exposure for budget forecasting."
    - name: "total_unlikely_incentive_amount"
      expr: SUM(CAST(unlikely_incentive_amount AS DOUBLE))
      comment: "Total unlikely incentive amounts (not counted against cap until earned). Tracks contingent liability for worst-case cap scenario planning."
    - name: "total_roster_bonus"
      expr: SUM(CAST(roster_bonus AS DOUBLE))
      comment: "Total roster bonus obligations. Identifies near-term cash and cap commitments triggered by roster decisions."
    - name: "total_workout_bonus"
      expr: SUM(CAST(workout_bonus AS DOUBLE))
      comment: "Total workout bonus obligations. Tracks participation-based incentive costs for offseason program management."
    - name: "dead_cap_pct_of_total_cap_hit"
      expr: ROUND(100.0 * SUM(CAST(dead_cap_value AS DOUBLE)) / NULLIF(SUM(CAST(cap_hit AS DOUBLE)), 0), 2)
      comment: "Dead cap as a percentage of total cap hit. Measures roster decision efficiency — high dead cap percentage signals poor contract management or forced roster moves."
    - name: "restructured_entry_count"
      expr: COUNT(DISTINCT CASE WHEN is_restructured = TRUE THEN salary_cap_entry_id END)
      comment: "Number of restructured cap entries. Tracks frequency of cap restructuring activity, a leading indicator of cap space pressure."
    - name: "avg_cap_hit_per_entry"
      expr: ROUND(AVG(CAST(cap_hit AS DOUBLE)), 2)
      comment: "Average cap hit per salary cap entry. Benchmarks per-player cap allocation efficiency across the roster."
    - name: "total_prior_year_incentive_carryover"
      expr: SUM(CAST(prior_year_incentive_carryover AS DOUBLE))
      comment: "Total prior year incentive carryover adjustments. Tracks cap adjustments from prior season incentive performance, impacting current year cap space."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_injury_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Athlete injury analytics providing executive and medical staff visibility into injury frequency, severity distribution, surgical rates, WADA reportability, financial reserve exposure, and return-to-play patterns."
  source: "`sports_entertainment_ecm`.`athlete`.`injury_record`"
  dimensions:
    - name: "injury_type"
      expr: injury_type
      comment: "Classification of injury type (e.g. Muscle, Ligament, Fracture) for injury pattern and prevention analysis."
    - name: "injury_status"
      expr: injury_status
      comment: "Current status of the injury (e.g. Active, Recovered, Chronic) for roster availability tracking."
    - name: "severity_grade"
      expr: severity_grade
      comment: "Injury severity grade for risk stratification and medical resource allocation."
    - name: "body_part"
      expr: body_part
      comment: "Injured body part for anatomical injury pattern analysis and prevention program targeting."
    - name: "body_side"
      expr: body_side
      comment: "Side of the body affected for bilateral injury pattern analysis."
    - name: "injury_mechanism"
      expr: injury_mechanism
      comment: "Mechanism of injury (e.g. Contact, Non-Contact, Overuse) for root cause and prevention analysis."
    - name: "surgery_required"
      expr: surgery_required
      comment: "Flag indicating whether surgery was required, a key severity and recovery timeline indicator."
    - name: "is_recurrence"
      expr: is_recurrence
      comment: "Flag identifying recurrent injuries, a critical indicator of rehabilitation program effectiveness."
    - name: "concussion_protocol_triggered"
      expr: concussion_protocol_triggered
      comment: "Flag indicating concussion protocol activation for player safety compliance monitoring."
    - name: "is_wada_reportable"
      expr: is_wada_reportable
      comment: "Flag indicating WADA reportability for anti-doping compliance and TUE management."
    - name: "ir_designation"
      expr: ir_designation
      comment: "Injured reserve designation type for roster and cap impact classification."
    - name: "injury_date_month"
      expr: DATE_TRUNC('month', injury_date)
      comment: "Month of injury for seasonal injury trend and workload management analysis."
    - name: "icd10_code"
      expr: icd10_code
      comment: "ICD-10 diagnosis code for clinical classification and insurance reporting."
  measures:
    - name: "total_injury_incidents"
      expr: COUNT(DISTINCT injury_record_id)
      comment: "Total number of distinct injury incidents. Baseline injury frequency KPI for player safety program evaluation."
    - name: "surgical_injury_count"
      expr: COUNT(DISTINCT CASE WHEN surgery_required = TRUE THEN injury_record_id END)
      comment: "Number of injuries requiring surgery. Tracks high-severity injury burden with significant recovery time and financial implications."
    - name: "surgical_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN surgery_required = TRUE THEN injury_record_id END) / NULLIF(COUNT(DISTINCT injury_record_id), 0), 2)
      comment: "Percentage of injuries requiring surgery. Measures injury severity concentration and surgical intervention rate for medical program benchmarking."
    - name: "recurrence_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_recurrence = TRUE THEN injury_record_id END) / NULLIF(COUNT(DISTINCT injury_record_id), 0), 2)
      comment: "Percentage of injuries that are recurrences. Measures rehabilitation program effectiveness — high recurrence rates signal inadequate recovery protocols."
    - name: "concussion_protocol_count"
      expr: COUNT(DISTINCT CASE WHEN concussion_protocol_triggered = TRUE THEN injury_record_id END)
      comment: "Number of concussion protocol activations. Critical player safety and league liability KPI tracked by medical and legal leadership."
    - name: "wada_reportable_injury_count"
      expr: COUNT(DISTINCT CASE WHEN is_wada_reportable = TRUE THEN injury_record_id END)
      comment: "Number of WADA-reportable injuries. Tracks anti-doping compliance obligations arising from injury treatment (e.g. TUE requirements)."
    - name: "total_insurance_reserve_amount"
      expr: SUM(CAST(insurance_reserve_amount AS DOUBLE))
      comment: "Total insurance reserve amounts set aside for injury claims. Measures financial exposure from athlete injuries for risk management and insurance program sizing."
    - name: "avg_insurance_reserve_per_injury"
      expr: ROUND(AVG(CAST(insurance_reserve_amount AS DOUBLE)), 2)
      comment: "Average insurance reserve per injury incident. Benchmarks per-injury financial exposure for actuarial and insurance renewal decisions."
    - name: "osha_recordable_injury_count"
      expr: COUNT(DISTINCT CASE WHEN is_osha_recordable = TRUE THEN injury_record_id END)
      comment: "Number of OSHA-recordable injuries. Tracks workplace safety compliance obligations and regulatory reporting requirements."
    - name: "workers_comp_claim_count"
      expr: COUNT(DISTINCT CASE WHEN is_workers_comp_claim = TRUE THEN injury_record_id END)
      comment: "Number of injuries resulting in workers compensation claims. Measures financial and legal liability from athlete workplace injuries."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_nil_agreement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "NIL (Name, Image, Likeness) agreement portfolio metrics enabling brand partnership, compliance, and revenue leadership to monitor NIL deal value, usage rights penetration, compliance status, and renewal pipeline."
  source: "`sports_entertainment_ecm`.`athlete`.`nil_agreement`"
  dimensions:
    - name: "agreement_status"
      expr: agreement_status
      comment: "Current status of the NIL agreement (e.g. Active, Expired, Terminated) for portfolio health monitoring."
    - name: "deal_category"
      expr: deal_category
      comment: "Category of NIL deal (e.g. Endorsement, Appearance, Social Media) for revenue mix analysis."
    - name: "product_category"
      expr: product_category
      comment: "Product or brand category of the NIL deal for market segment and conflict analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the NIL agreement for multi-currency revenue reporting."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of the NIL agreement for compliance pipeline tracking."
    - name: "cba_compliance_status"
      expr: cba_compliance_status
      comment: "CBA compliance status of the NIL agreement for collective bargaining adherence monitoring."
    - name: "wada_compliance_flag"
      expr: wada_compliance_flag
      comment: "WADA compliance flag on the NIL agreement for anti-doping contractual obligation tracking."
    - name: "league_sponsor_conflict_flag"
      expr: league_sponsor_conflict_flag
      comment: "Flag indicating a conflict with a league sponsor, requiring compliance review and potential deal restructuring."
    - name: "auto_renewal_flag"
      expr: auto_renewal_flag
      comment: "Flag indicating auto-renewal terms for renewal pipeline and revenue continuity planning."
    - name: "social_media_usage_rights"
      expr: social_media_usage_rights
      comment: "Flag indicating social media usage rights granted, relevant for digital revenue and brand reach analysis."
    - name: "broadcast_usage_rights"
      expr: broadcast_usage_rights
      comment: "Flag indicating broadcast usage rights granted for media rights valuation."
    - name: "effective_date_year"
      expr: YEAR(effective_date)
      comment: "Year the NIL agreement became effective for vintage and cohort revenue analysis."
    - name: "payment_structure"
      expr: payment_structure
      comment: "Payment structure of the NIL deal (e.g. Lump Sum, Installment, Royalty) for cash flow planning."
  measures:
    - name: "total_nil_agreements"
      expr: COUNT(DISTINCT nil_agreement_id)
      comment: "Total number of distinct NIL agreements. Baseline portfolio size KPI for NIL program scale assessment."
    - name: "total_deal_value"
      expr: SUM(CAST(deal_value_amount AS DOUBLE))
      comment: "Total NIL deal value across all agreements. Primary revenue KPI for NIL program financial performance reporting."
    - name: "total_annual_value"
      expr: SUM(CAST(annual_value_amount AS DOUBLE))
      comment: "Total annualized NIL deal value. Enables run-rate revenue forecasting and year-over-year NIL program growth tracking."
    - name: "total_incentive_value"
      expr: SUM(CAST(incentive_value_amount AS DOUBLE))
      comment: "Total incentive-based NIL value. Measures performance-contingent revenue upside across the NIL portfolio."
    - name: "avg_deal_value"
      expr: ROUND(AVG(CAST(deal_value_amount AS DOUBLE)), 2)
      comment: "Average NIL deal value per agreement. Benchmarks deal quality and negotiation effectiveness across the athlete portfolio."
    - name: "total_royalty_rate_avg"
      expr: ROUND(AVG(CAST(royalty_rate AS DOUBLE)), 4)
      comment: "Average royalty rate across NIL agreements with royalty structures. Informs royalty program competitiveness and revenue yield optimization."
    - name: "league_sponsor_conflict_count"
      expr: COUNT(DISTINCT CASE WHEN league_sponsor_conflict_flag = TRUE THEN nil_agreement_id END)
      comment: "Number of NIL agreements flagged for league sponsor conflicts. Tracks compliance risk requiring legal and commercial resolution."
    - name: "league_sponsor_conflict_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN league_sponsor_conflict_flag = TRUE THEN nil_agreement_id END) / NULLIF(COUNT(DISTINCT nil_agreement_id), 0), 2)
      comment: "Percentage of NIL agreements with league sponsor conflicts. Measures compliance risk concentration in the NIL portfolio."
    - name: "wada_non_compliant_count"
      expr: COUNT(DISTINCT CASE WHEN wada_compliance_flag = FALSE THEN nil_agreement_id END)
      comment: "Number of NIL agreements not meeting WADA compliance requirements. Critical compliance KPI for anti-doping program integrity."
    - name: "social_media_rights_deal_count"
      expr: COUNT(DISTINCT CASE WHEN social_media_usage_rights = TRUE THEN nil_agreement_id END)
      comment: "Number of NIL agreements granting social media usage rights. Measures digital brand reach and social media monetization scope."
    - name: "auto_renewal_deal_count"
      expr: COUNT(DISTINCT CASE WHEN auto_renewal_flag = TRUE THEN nil_agreement_id END)
      comment: "Number of NIL agreements with auto-renewal terms. Quantifies recurring revenue pipeline and retention without renegotiation."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_suspension_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Athlete suspension and disciplinary metrics providing league compliance, legal, and executive leadership with visibility into suspension frequency, financial penalties, appeal outcomes, doping violations, and reputational risk."
  source: "`sports_entertainment_ecm`.`athlete`.`suspension_record`"
  dimensions:
    - name: "suspension_type"
      expr: suspension_type
      comment: "Type of suspension (e.g. Doping, Conduct, Game Misconduct) for disciplinary category analysis."
    - name: "suspension_status"
      expr: suspension_status
      comment: "Current status of the suspension (e.g. Active, Served, Appealed) for compliance pipeline monitoring."
    - name: "violation_category"
      expr: violation_category
      comment: "Category of the underlying violation for root cause and policy effectiveness analysis."
    - name: "appeal_status"
      expr: appeal_status
      comment: "Status of any appeal filed against the suspension for legal risk and process tracking."
    - name: "issuing_authority"
      expr: issuing_authority
      comment: "Authority that issued the suspension (e.g. League, Governing Body, WADA) for jurisdictional analysis."
    - name: "competition_scope"
      expr: competition_scope
      comment: "Scope of competition affected by the suspension (e.g. All Competitions, Domestic Only) for impact assessment."
    - name: "is_indefinite"
      expr: is_indefinite
      comment: "Flag for indefinite suspensions representing the highest severity disciplinary actions."
    - name: "is_lifetime_ban"
      expr: is_lifetime_ban
      comment: "Flag for lifetime bans — the most severe disciplinary outcome with permanent roster and contract implications."
    - name: "is_public_announcement"
      expr: is_public_announcement
      comment: "Flag indicating public announcement was made, relevant for reputational and media impact assessment."
    - name: "penalty_currency_code"
      expr: penalty_currency_code
      comment: "Currency of the financial penalty for multi-currency penalty reporting."
    - name: "effective_start_year"
      expr: YEAR(effective_start_date)
      comment: "Year the suspension became effective for trend and seasonal disciplinary pattern analysis."
    - name: "broadcast_restriction_flag"
      expr: broadcast_restriction_flag
      comment: "Flag indicating broadcast restrictions associated with the suspension, relevant for media rights and broadcast compliance."
  measures:
    - name: "total_suspensions"
      expr: COUNT(DISTINCT suspension_record_id)
      comment: "Total number of distinct suspension records. Baseline disciplinary frequency KPI for league integrity program evaluation."
    - name: "active_suspension_count"
      expr: COUNT(DISTINCT CASE WHEN suspension_status = 'Active' THEN suspension_record_id END)
      comment: "Number of currently active suspensions. Directly impacts roster availability and game-day planning decisions."
    - name: "total_financial_penalty_amount"
      expr: SUM(CAST(financial_penalty_amount AS DOUBLE))
      comment: "Total financial penalties levied across all suspensions. Measures the monetary enforcement impact of the disciplinary program."
    - name: "total_salary_withheld_amount"
      expr: SUM(CAST(salary_withheld_amount AS DOUBLE))
      comment: "Total salary withheld due to suspensions. Quantifies the direct financial consequence to athletes and the cap/payroll impact of disciplinary actions."
    - name: "appeal_filed_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN appeal_status IS NOT NULL AND appeal_status != 'None' THEN suspension_record_id END) / NULLIF(COUNT(DISTINCT suspension_record_id), 0), 2)
      comment: "Percentage of suspensions for which an appeal was filed. Measures disciplinary decision contestation rate, informing legal resource planning and policy robustness."
    - name: "lifetime_ban_count"
      expr: COUNT(DISTINCT CASE WHEN is_lifetime_ban = TRUE THEN suspension_record_id END)
      comment: "Number of lifetime bans issued. Tracks the most severe disciplinary outcomes with permanent roster and reputational consequences."
    - name: "indefinite_suspension_count"
      expr: COUNT(DISTINCT CASE WHEN is_indefinite = TRUE THEN suspension_record_id END)
      comment: "Number of indefinite suspensions. Identifies high-severity open-ended disciplinary actions requiring ongoing monitoring."
    - name: "avg_financial_penalty"
      expr: ROUND(AVG(CAST(financial_penalty_amount AS DOUBLE)), 2)
      comment: "Average financial penalty per suspension. Benchmarks penalty severity and consistency of disciplinary enforcement."
    - name: "public_announcement_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_public_announcement = TRUE THEN suspension_record_id END) / NULLIF(COUNT(DISTINCT suspension_record_id), 0), 2)
      comment: "Percentage of suspensions with public announcements. Measures reputational and media exposure from disciplinary actions."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_performance_stat`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Athlete on-field performance metrics enabling coaching staff, analytics, and executive leadership to evaluate player output, contribution efficiency, and sport-specific statistical performance across seasons and positions."
  source: "`sports_entertainment_ecm`.`athlete`.`performance_stat`"
  dimensions:
    - name: "sport_discipline"
      expr: sport_discipline
      comment: "Sport discipline for cross-sport performance benchmarking and segmentation."
    - name: "stat_type"
      expr: stat_type
      comment: "Type of performance statistic (e.g. Game, Season, Career) for granularity-appropriate analysis."
    - name: "stat_status"
      expr: stat_status
      comment: "Status of the stat record (e.g. Official, Provisional, Disputed) for data quality filtering."
    - name: "position_played"
      expr: position_played
      comment: "Position played during the stat period for positional performance benchmarking."
    - name: "is_home_game"
      expr: is_home_game
      comment: "Flag indicating home vs. away game for home/away performance split analysis."
    - name: "is_primary_input"
      expr: is_primary_input
      comment: "Flag indicating whether this is the primary stat input record for deduplication and aggregation control."
    - name: "stat_date_month"
      expr: DATE_TRUNC('month', stat_date)
      comment: "Month of the stat record for temporal performance trend analysis."
    - name: "stat_period_start_year"
      expr: YEAR(stat_period_start_date)
      comment: "Year of the stat period start for season and annual performance cohort analysis."
  measures:
    - name: "total_stat_records"
      expr: COUNT(DISTINCT performance_stat_id)
      comment: "Total number of distinct performance stat records. Baseline for data completeness and coverage monitoring."
    - name: "total_minutes_played"
      expr: SUM(CAST(minutes_played AS DOUBLE))
      comment: "Total minutes played across all stat records. Measures playing time volume, a key input for per-minute efficiency metrics and workload management."
    - name: "avg_minutes_played"
      expr: ROUND(AVG(CAST(minutes_played AS DOUBLE)), 2)
      comment: "Average minutes played per stat record. Benchmarks playing time allocation and rotation depth decisions."
    - name: "avg_war"
      expr: ROUND(AVG(CAST(war AS DOUBLE)), 4)
      comment: "Average Wins Above Replacement (WAR) across stat records. Composite value metric used by front offices to evaluate overall player contribution relative to replacement level."
    - name: "total_war"
      expr: SUM(CAST(war AS DOUBLE))
      comment: "Total WAR accumulated across stat records. Aggregated player value metric for roster construction and trade value assessment."
    - name: "avg_field_goal_percentage"
      expr: ROUND(AVG(CAST(field_goal_percentage AS DOUBLE)), 4)
      comment: "Average field goal percentage. Key shooting efficiency KPI for basketball player evaluation and offensive system analysis."
    - name: "avg_batting_average"
      expr: ROUND(AVG(CAST(batting_average AS DOUBLE)), 4)
      comment: "Average batting average across stat records. Core baseball hitting performance KPI for player evaluation and lineup construction."
    - name: "avg_on_base_percentage"
      expr: ROUND(AVG(CAST(on_base_percentage AS DOUBLE)), 4)
      comment: "Average on-base percentage. Advanced baseball offensive efficiency metric used for lineup optimization and player valuation."
    - name: "avg_slugging_percentage"
      expr: ROUND(AVG(CAST(slugging_percentage AS DOUBLE)), 4)
      comment: "Average slugging percentage. Measures extra-base hit power production for baseball player evaluation and roster construction."
    - name: "avg_era"
      expr: ROUND(AVG(CAST(era AS DOUBLE)), 4)
      comment: "Average Earned Run Average (ERA) across pitching stat records. Primary pitching performance KPI for pitcher evaluation and rotation decisions."
    - name: "avg_innings_pitched"
      expr: ROUND(AVG(CAST(innings_pitched AS DOUBLE)), 2)
      comment: "Average innings pitched per stat record. Measures pitching workload and durability for rotation management and arm health decisions."
    - name: "avg_qbr"
      expr: ROUND(AVG(CAST(qbr AS DOUBLE)), 2)
      comment: "Average Quarterback Rating (QBR) across stat records. Composite quarterback efficiency metric for player evaluation and game planning."
    - name: "avg_contribution_weight"
      expr: ROUND(AVG(CAST(contribution_weight AS DOUBLE)), 4)
      comment: "Average contribution weight assigned to stat records. Measures the relative importance weighting of player contributions for composite performance scoring."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_roster`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Roster composition and cap management metrics enabling team operations and executive leadership to monitor active roster depth, cap allocation, international slot usage, service year distribution, and roster transaction activity."
  source: "`sports_entertainment_ecm`.`athlete`.`roster`"
  dimensions:
    - name: "roster_status"
      expr: roster_status
      comment: "Current roster status (e.g. Active, Inactive, Practice Squad) for roster depth and availability analysis."
    - name: "position_code"
      expr: position_code
      comment: "Position code for positional depth chart and roster gap analysis."
    - name: "position_name"
      expr: position_name
      comment: "Position name for human-readable positional roster reporting."
    - name: "slot_type"
      expr: slot_type
      comment: "Roster slot type (e.g. Standard, International, Practice Squad) for slot utilization analysis."
    - name: "transaction_type"
      expr: transaction_type
      comment: "Type of roster transaction (e.g. Signing, Release, Trade, Loan) for transaction activity monitoring."
    - name: "nationality_code"
      expr: nationality_code
      comment: "Athlete nationality for international roster composition and visa compliance tracking."
    - name: "international_slot_flag"
      expr: international_slot_flag
      comment: "Flag indicating use of an international roster slot for league international slot limit compliance."
    - name: "wada_clearance_status"
      expr: wada_clearance_status
      comment: "WADA clearance status on the roster entry for anti-doping compliance monitoring."
    - name: "nil_agreement_flag"
      expr: nil_agreement_flag
      comment: "Flag indicating an active NIL agreement associated with the roster entry."
    - name: "is_captain"
      expr: is_captain
      comment: "Flag identifying team captains for leadership structure and team culture analysis."
    - name: "practice_squad_elevation_flag"
      expr: practice_squad_elevation_flag
      comment: "Flag indicating practice squad elevation for depth chart and emergency roster planning."
    - name: "transaction_date_month"
      expr: DATE_TRUNC('month', transaction_date)
      comment: "Month of roster transaction for transaction volume and timing trend analysis."
  measures:
    - name: "total_roster_entries"
      expr: COUNT(DISTINCT roster_id)
      comment: "Total number of distinct roster entries. Baseline roster size KPI for league compliance and team operations."
    - name: "active_roster_count"
      expr: COUNT(DISTINCT CASE WHEN roster_status = 'Active' THEN roster_id END)
      comment: "Number of active roster entries. Core availability metric for game-day roster compliance and depth assessment."
    - name: "international_slot_count"
      expr: COUNT(DISTINCT CASE WHEN international_slot_flag = TRUE THEN roster_id END)
      comment: "Number of international roster slots in use. Tracks compliance with league international player limits."
    - name: "total_salary_cap_hit"
      expr: SUM(CAST(salary_cap_hit AS DOUBLE))
      comment: "Total salary cap hit across all roster entries. Primary cap utilization KPI for roster construction and league compliance."
    - name: "avg_salary_cap_hit"
      expr: ROUND(AVG(CAST(salary_cap_hit AS DOUBLE)), 2)
      comment: "Average salary cap hit per roster entry. Benchmarks per-player cap efficiency and roster construction strategy."
    - name: "avg_service_years"
      expr: ROUND(AVG(CAST(service_years AS DOUBLE)), 2)
      comment: "Average service years across roster entries. Measures roster experience level, relevant for free agency eligibility, arbitration rights, and team development strategy."
    - name: "wada_non_cleared_count"
      expr: COUNT(DISTINCT CASE WHEN wada_clearance_status != 'Cleared' AND wada_clearance_status IS NOT NULL THEN roster_id END)
      comment: "Number of roster entries without WADA clearance. Tracks anti-doping compliance gaps that could result in game-day ineligibility."
    - name: "practice_squad_elevation_count"
      expr: COUNT(DISTINCT CASE WHEN practice_squad_elevation_flag = TRUE THEN roster_id END)
      comment: "Number of practice squad elevations. Measures depth utilization and emergency roster activation frequency."
    - name: "nil_agreement_roster_count"
      expr: COUNT(DISTINCT CASE WHEN nil_agreement_flag = TRUE THEN roster_id END)
      comment: "Number of roster entries with active NIL agreements. Tracks NIL program penetration across the active roster."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_free_agency_status`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Free agency pipeline and financial obligation metrics enabling front office and cap management leadership to monitor free agent pool composition, cap hold exposure, franchise tag usage, qualifying offer activity, and signing timelines."
  source: "`sports_entertainment_ecm`.`athlete`.`free_agency_status`"
  dimensions:
    - name: "fa_type"
      expr: fa_type
      comment: "Free agency type (e.g. Unrestricted, Restricted, Exclusive Rights) for pipeline segmentation and negotiation strategy."
    - name: "negotiation_status"
      expr: negotiation_status
      comment: "Current negotiation status for deal pipeline tracking and signing timeline management."
    - name: "compensation_tier"
      expr: compensation_tier
      comment: "Compensation tier classification for draft pick compensation and cap hold analysis."
    - name: "wada_clearance_status"
      expr: wada_clearance_status
      comment: "WADA clearance status for free agents, required before signing eligibility."
    - name: "arbitration_eligible_flag"
      expr: arbitration_eligible_flag
      comment: "Flag indicating arbitration eligibility, affecting negotiation leverage and salary determination process."
    - name: "right_of_first_refusal_flag"
      expr: right_of_first_refusal_flag
      comment: "Flag indicating right of first refusal, affecting competitive signing dynamics."
    - name: "draft_pick_compensation_flag"
      expr: draft_pick_compensation_flag
      comment: "Flag indicating draft pick compensation is attached, affecting signing team decisions."
    - name: "player_option_flag"
      expr: player_option_flag
      comment: "Flag indicating a player option was exercised to trigger free agency."
    - name: "nil_agreement_flag"
      expr: nil_agreement_flag
      comment: "Flag indicating an active NIL agreement associated with the free agency record."
    - name: "fa_open_date_year"
      expr: YEAR(fa_open_date)
      comment: "Year free agency opened for cohort and vintage free agent class analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of free agency financial amounts for multi-currency reporting."
  measures:
    - name: "total_free_agents"
      expr: COUNT(DISTINCT free_agency_status_id)
      comment: "Total number of distinct free agency records. Baseline free agent pool size KPI for roster planning and market analysis."
    - name: "total_cap_hold_amount"
      expr: SUM(CAST(cap_hold_amount AS DOUBLE))
      comment: "Total cap hold amounts for all free agents. Measures cap space consumed by unsigned free agents, directly constraining roster construction."
    - name: "total_franchise_tag_amount"
      expr: SUM(CAST(franchise_tag_amount AS DOUBLE))
      comment: "Total franchise tag amounts applied. Tracks the financial cost of franchise tag usage for cap planning and player retention strategy."
    - name: "total_qualifying_offer_amount"
      expr: SUM(CAST(qualifying_offer_amount AS DOUBLE))
      comment: "Total qualifying offer amounts tendered to restricted free agents. Measures restricted free agency financial commitments and cap hold obligations."
    - name: "total_tender_amount"
      expr: SUM(CAST(tender_amount AS DOUBLE))
      comment: "Total tender amounts for exclusive rights and restricted free agents. Tracks minimum retention cost obligations."
    - name: "total_transition_tag_amount"
      expr: SUM(CAST(transition_tag_amount AS DOUBLE))
      comment: "Total transition tag amounts applied. Measures the financial cost of transition tag usage as an alternative retention mechanism."
    - name: "avg_years_of_service"
      expr: ROUND(AVG(CAST(years_of_service AS DOUBLE)), 2)
      comment: "Average years of service for free agents. Measures experience level of the free agent pool, informing market value expectations and arbitration eligibility."
    - name: "arbitration_eligible_count"
      expr: COUNT(DISTINCT CASE WHEN arbitration_eligible_flag = TRUE THEN free_agency_status_id END)
      comment: "Number of arbitration-eligible free agents. Quantifies the pipeline of salary arbitration cases requiring legal and financial preparation."
    - name: "rofr_exercised_count"
      expr: COUNT(DISTINCT CASE WHEN rofr_exercised_flag = TRUE THEN free_agency_status_id END)
      comment: "Number of right-of-first-refusal exercises. Tracks retention actions taken to match competing offers, informing competitive market dynamics."
    - name: "cap_hold_released_count"
      expr: COUNT(DISTINCT CASE WHEN cap_hold_released_flag = TRUE THEN free_agency_status_id END)
      comment: "Number of cap holds released (renounced free agents). Measures cap space recovery actions taken to create roster flexibility."
    - name: "draft_pick_compensation_count"
      expr: COUNT(DISTINCT CASE WHEN draft_pick_compensation_flag = TRUE THEN free_agency_status_id END)
      comment: "Number of free agents with draft pick compensation attached. Quantifies the draft asset cost to signing teams, affecting competitive market dynamics."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`athlete_draft_selection`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Draft selection analytics enabling front office and scouting leadership to evaluate draft class composition, signing slot value, pre-draft grade accuracy, medical clearance rates, and pick trade activity."
  source: "`sports_entertainment_ecm`.`athlete`.`draft_selection`"
  dimensions:
    - name: "draft_year"
      expr: draft_year
      comment: "Draft year for class-level analysis and multi-year draft program evaluation."
    - name: "selection_status"
      expr: selection_status
      comment: "Status of the draft selection (e.g. Signed, Unsigned, Traded) for signing pipeline tracking."
    - name: "pick_type"
      expr: pick_type
      comment: "Type of draft pick (e.g. Original, Traded, Compensatory) for pick portfolio analysis."
    - name: "athlete_position"
      expr: athlete_position
      comment: "Position of the drafted athlete for positional need fulfillment analysis."
    - name: "athlete_nationality"
      expr: athlete_nationality
      comment: "Nationality of the drafted athlete for international scouting program evaluation."
    - name: "medical_clearance_status"
      expr: medical_clearance_status
      comment: "Medical clearance status of the draft selection for risk-adjusted draft value analysis."
    - name: "wada_clearance_status"
      expr: wada_clearance_status
      comment: "WADA clearance status for drafted athletes for anti-doping compliance tracking."
    - name: "is_traded_pick"
      expr: is_traded_pick
      comment: "Flag indicating the pick was acquired via trade for draft asset management analysis."
    - name: "is_compensatory_pick"
      expr: is_compensatory_pick
      comment: "Flag indicating a compensatory pick for free agency compensation program evaluation."
    - name: "is_conditional_pick"
      expr: is_conditional_pick
      comment: "Flag indicating a conditional pick for contingent asset tracking."
    - name: "draft_date_year"
      expr: YEAR(draft_date)
      comment: "Year of the draft event for annual draft program performance analysis."
    - name: "athlete_college"
      expr: athlete_college
      comment: "College or institution of the drafted athlete for scouting pipeline and collegiate program evaluation."
  measures:
    - name: "total_draft_selections"
      expr: COUNT(DISTINCT draft_selection_id)
      comment: "Total number of distinct draft selections. Baseline draft class size KPI for draft program scope assessment."
    - name: "total_signing_slot_value"
      expr: SUM(CAST(signing_slot_value AS DOUBLE))
      comment: "Total signing slot value across all draft selections. Measures total draft class financial commitment under the rookie wage scale."
    - name: "total_actual_signing_bonus"
      expr: SUM(CAST(actual_signing_bonus AS DOUBLE))
      comment: "Total actual signing bonuses paid to drafted athletes. Tracks realized draft class cash outlay vs. slot value for negotiation efficiency analysis."
    - name: "avg_pre_draft_grade"
      expr: ROUND(AVG(CAST(pre_draft_grade AS DOUBLE)), 2)
      comment: "Average pre-draft scouting grade across selections. Benchmarks draft class quality and scouting program calibration."
    - name: "signing_bonus_vs_slot_value_ratio"
      expr: ROUND(SUM(CAST(actual_signing_bonus AS DOUBLE)) / NULLIF(SUM(CAST(signing_slot_value AS DOUBLE)), 0), 4)
      comment: "Ratio of actual signing bonuses paid to total signing slot value. Measures negotiation efficiency — ratios below 1.0 indicate below-slot signings, above 1.0 indicate above-slot deals."
    - name: "medically_cleared_count"
      expr: COUNT(DISTINCT CASE WHEN medical_clearance_status = 'Cleared' THEN draft_selection_id END)
      comment: "Number of draft selections with full medical clearance. Tracks medical risk in the draft class for roster and insurance planning."
    - name: "medical_clearance_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN medical_clearance_status = 'Cleared' THEN draft_selection_id END) / NULLIF(COUNT(DISTINCT draft_selection_id), 0), 2)
      comment: "Percentage of draft selections with medical clearance. Measures draft class health risk concentration for scouting and medical program evaluation."
    - name: "traded_pick_count"
      expr: COUNT(DISTINCT CASE WHEN is_traded_pick = TRUE THEN draft_selection_id END)
      comment: "Number of draft selections made using traded picks. Measures draft asset acquisition activity and trade program effectiveness."
    - name: "compensatory_pick_count"
      expr: COUNT(DISTINCT CASE WHEN is_compensatory_pick = TRUE THEN draft_selection_id END)
      comment: "Number of compensatory picks received. Tracks free agency compensation program yield for roster building strategy."
    - name: "unsigned_selection_count"
      expr: COUNT(DISTINCT CASE WHEN selection_status != 'Signed' AND selection_status IS NOT NULL THEN draft_selection_id END)
      comment: "Number of draft selections not yet signed. Tracks signing pipeline risk and deadline exposure for draft class completion."
$$;