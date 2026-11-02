-- Metric views for domain: league | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_franchise`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for franchise valuation, salary cap management, and roster compliance. Enables league executives to monitor franchise financial health, competitive integrity, and CBA adherence across all member franchises."
  source: "`sports_entertainment_ecm`.`league`.`franchise`"
  dimensions:
    - name: "franchise_status"
      expr: franchise_status
      comment: "Operational status of the franchise (e.g., active, suspended, relocated) — primary filter for active-roster analysis."
    - name: "market_city"
      expr: market_city
      comment: "City where the franchise operates its home market — used for geographic revenue and fan-base analysis."
    - name: "market_country_code"
      expr: market_country_code
      comment: "ISO country code of the franchise market — supports international expansion and broadcast rights segmentation."
    - name: "revenue_sharing_tier"
      expr: revenue_sharing_tier
      comment: "Revenue sharing tier assigned to the franchise — drives league-wide revenue distribution analysis."
    - name: "roster_compliance_status"
      expr: roster_compliance_status
      comment: "Current CBA/league roster compliance status — flags franchises at risk of disciplinary action."
    - name: "is_expansion_franchise"
      expr: is_expansion_franchise
      comment: "Indicates whether the franchise is an expansion team — used to segment legacy vs. new-market performance."
    - name: "salary_cap_currency_code"
      expr: salary_cap_currency_code
      comment: "Currency in which the salary cap allotment is denominated — required for multi-currency financial reporting."
    - name: "disciplinary_sanction_status"
      expr: disciplinary_sanction_status
      comment: "Current disciplinary sanction status of the franchise — used by compliance and league integrity teams."
  measures:
    - name: "total_franchise_valuation"
      expr: SUM(CAST(valuation_estimate AS DOUBLE))
      comment: "Sum of estimated franchise valuations across the league. Tracks total league asset value and informs expansion fee benchmarking and ownership transfer negotiations."
    - name: "avg_franchise_valuation"
      expr: AVG(CAST(valuation_estimate AS DOUBLE))
      comment: "Average estimated franchise valuation. Benchmarks individual franchise performance against league average; a key metric for investor relations and league growth strategy."
    - name: "total_salary_cap_allotment"
      expr: SUM(CAST(salary_cap_allotment AS DOUBLE))
      comment: "Total salary cap allotment committed across all franchises. Measures league-wide payroll exposure and CBA compliance headroom."
    - name: "avg_salary_cap_allotment"
      expr: AVG(CAST(salary_cap_allotment AS DOUBLE))
      comment: "Average salary cap allotment per franchise. Identifies franchises significantly above or below the league mean, signaling competitive balance risks."
    - name: "total_expansion_fees_collected"
      expr: SUM(CAST(expansion_fee_paid AS DOUBLE))
      comment: "Total expansion fees paid by expansion franchises. Directly measures league revenue from market expansion and validates expansion strategy ROI."
    - name: "franchise_count"
      expr: COUNT(DISTINCT franchise_id)
      comment: "Total number of distinct franchises. Baseline headcount for per-franchise normalization and league growth tracking."
    - name: "franchises_with_salary_cap_violations"
      expr: COUNT(DISTINCT CASE WHEN roster_compliance_status = 'NON_COMPLIANT' THEN franchise_id END)
      comment: "Number of franchises currently flagged as non-compliant with roster/salary cap rules. A critical compliance KPI that triggers league intervention and potential sanctions."
    - name: "franchises_under_competitive_integrity_flag"
      expr: COUNT(DISTINCT CASE WHEN competitive_integrity_flag = TRUE THEN franchise_id END)
      comment: "Number of franchises currently under a competitive integrity flag. Monitors league integrity risk concentration and informs governance escalation decisions."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_salary_cap`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Comprehensive salary cap financial metrics enabling league finance and compliance teams to monitor cap utilization, luxury tax exposure, dead cap burden, and CBA adherence across franchises and seasons."
  source: "`sports_entertainment_ecm`.`league`.`salary_cap`"
  dimensions:
    - name: "cap_year"
      expr: cap_year
      comment: "The salary cap year — primary time dimension for year-over-year cap trend analysis."
    - name: "cap_type"
      expr: cap_type
      comment: "Type of salary cap (hard cap, soft cap, luxury tax cap) — determines applicable financial rules and penalties."
    - name: "compliance_status"
      expr: compliance_status
      comment: "Current CBA compliance status of the cap record — flags franchises in violation for regulatory action."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency in which cap amounts are denominated — required for multi-currency league financial consolidation."
    - name: "cba_version"
      expr: cba_version
      comment: "Version of the Collective Bargaining Agreement governing this cap record — tracks CBA evolution impact on financials."
    - name: "record_type"
      expr: record_type
      comment: "Type of salary cap record (e.g., snapshot, adjustment, final) — used to filter to authoritative cap positions."
    - name: "luxury_tax_repeater_flag"
      expr: luxury_tax_repeater_flag
      comment: "Indicates whether the franchise is a luxury tax repeater, subject to elevated tax rates — critical for financial penalty forecasting."
    - name: "draft_pick_penalty_flag"
      expr: draft_pick_penalty_flag
      comment: "Indicates whether a draft pick penalty has been assessed — used by competitive balance and compliance teams."
  measures:
    - name: "total_active_payroll"
      expr: SUM(CAST(active_payroll_amount AS DOUBLE))
      comment: "Total active payroll across all franchises. Core financial KPI measuring league-wide player compensation commitment and CBA payroll floor/ceiling compliance."
    - name: "avg_active_payroll_per_franchise"
      expr: AVG(CAST(active_payroll_amount AS DOUBLE))
      comment: "Average active payroll per franchise record. Benchmarks individual franchise payroll against league average to identify outliers and competitive balance issues."
    - name: "total_cap_space_remaining"
      expr: SUM(CAST(cap_space_remaining AS DOUBLE))
      comment: "Total remaining salary cap space across all franchises. Measures league-wide roster-building capacity and informs trade deadline and free agency activity forecasts."
    - name: "total_luxury_tax_liability"
      expr: SUM(CAST(luxury_tax_liability AS DOUBLE))
      comment: "Total luxury tax liability owed by franchises exceeding the tax threshold. Directly measures league revenue from luxury tax redistribution — a key revenue and competitive balance KPI."
    - name: "total_dead_cap_amount"
      expr: SUM(CAST(dead_cap_amount AS DOUBLE))
      comment: "Total dead cap (cap charges for players no longer on roster) across franchises. Measures the financial drag from roster decisions and contract restructurings — informs GM performance evaluation."
    - name: "avg_dead_cap_per_franchise"
      expr: AVG(CAST(dead_cap_amount AS DOUBLE))
      comment: "Average dead cap burden per franchise. Identifies franchises with disproportionate dead cap exposure, signaling poor contract management or forced roster moves."
    - name: "total_hard_cap_amount"
      expr: SUM(CAST(hard_cap_amount AS DOUBLE))
      comment: "Total hard cap ceiling across all applicable franchise records. Establishes the absolute upper bound of league payroll exposure for financial planning."
    - name: "total_penalty_amount"
      expr: SUM(CAST(penalty_amount AS DOUBLE))
      comment: "Total financial penalties assessed for salary cap violations. Tracks league enforcement revenue and compliance effectiveness — triggers governance review when elevated."
    - name: "franchises_over_luxury_tax_threshold"
      expr: COUNT(DISTINCT CASE WHEN luxury_tax_liability > 0 THEN franchise_id END)
      comment: "Number of franchises currently liable for luxury tax. Measures competitive concentration — a high count signals a league dominated by high-spending franchises, informing CBA renegotiation."
    - name: "avg_cap_space_remaining"
      expr: AVG(CAST(cap_space_remaining AS DOUBLE))
      comment: "Average remaining cap space per franchise. Indicates league-wide roster flexibility heading into trade windows and free agency periods."
    - name: "total_mid_level_exception_amount"
      expr: SUM(CAST(mid_level_exception_amount AS DOUBLE))
      comment: "Total mid-level exception amounts utilized across franchises. Tracks usage of CBA roster-building tools and their aggregate impact on league payroll."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_game_result`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Game outcome and operational quality metrics for league operations, broadcast, and competitive integrity teams. Covers officiating interventions, weather impacts, attendance, and game integrity flags."
  source: "`sports_entertainment_ecm`.`league`.`game_result`"
  dimensions:
    - name: "game_date"
      expr: game_date
      comment: "Date the game was played — primary time dimension for scheduling and performance trend analysis."
    - name: "competition_phase"
      expr: competition_phase
      comment: "Phase of competition (regular season, playoffs, championship) — segments performance metrics by competitive context."
    - name: "result_status"
      expr: result_status
      comment: "Official status of the game result (certified, protested, forfeited) — filters to authoritative results for standings calculations."
    - name: "result_type"
      expr: result_type
      comment: "Type of game result (regulation, overtime, forfeit) — used to analyze game duration and competitive balance."
    - name: "is_neutral_site"
      expr: is_neutral_site
      comment: "Indicates whether the game was played at a neutral site — used to isolate home-field advantage analysis."
    - name: "weather_condition"
      expr: weather_condition
      comment: "Weather condition at game time — used to analyze weather impact on attendance, scoring, and game operations."
    - name: "source_system_code"
      expr: source_system_code
      comment: "Source system that originated the game result record — used for data lineage and reconciliation."
    - name: "is_draw"
      expr: is_draw
      comment: "Indicates whether the game ended in a draw — used for sport-specific competitive balance analysis."
  measures:
    - name: "total_games_played"
      expr: COUNT(DISTINCT game_result_id)
      comment: "Total number of official game results recorded. Baseline volume metric for schedule completion tracking and broadcast rights utilization."
    - name: "games_with_var_intervention"
      expr: COUNT(DISTINCT CASE WHEN var_intervention_flag = TRUE THEN game_result_id END)
      comment: "Number of games where VAR (Video Assistant Referee) intervened. Measures officiating technology utilization and its prevalence — informs officiating quality and fan experience reviews."
    - name: "var_intervention_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN var_intervention_flag = TRUE THEN game_result_id END) / NULLIF(COUNT(DISTINCT game_result_id), 0), 2)
      comment: "Percentage of games with VAR intervention. A key officiating quality KPI — high rates may indicate officiating inconsistency or rule complexity issues requiring governance review."
    - name: "games_with_tmo_intervention"
      expr: COUNT(DISTINCT CASE WHEN tmo_intervention_flag = TRUE THEN game_result_id END)
      comment: "Number of games with TMO (Television Match Official) intervention. Tracks officiating technology usage and its impact on game flow and broadcast scheduling."
    - name: "games_with_competitive_integrity_flag"
      expr: COUNT(DISTINCT CASE WHEN competitive_integrity_flag = TRUE THEN game_result_id END)
      comment: "Number of games flagged for competitive integrity concerns. A critical league governance KPI — elevated counts trigger mandatory investigation and potential sanctions."
    - name: "games_with_disciplinary_action"
      expr: COUNT(DISTINCT CASE WHEN disciplinary_action_flag = TRUE THEN game_result_id END)
      comment: "Number of games resulting in disciplinary actions. Measures in-game conduct quality and referee authority effectiveness — informs player conduct programs."
    - name: "games_protested"
      expr: COUNT(DISTINCT CASE WHEN protest_flag = TRUE THEN game_result_id END)
      comment: "Number of games under formal protest. Tracks officiating dispute volume — a governance and legal risk KPI for league operations."
    - name: "avg_temperature_celsius"
      expr: AVG(CAST(temperature_celsius AS DOUBLE))
      comment: "Average game-time temperature in Celsius. Used to analyze weather impact on game operations, player safety protocols, and venue selection decisions."
    - name: "avg_wind_speed_kmh"
      expr: AVG(CAST(wind_speed_kmh AS DOUBLE))
      comment: "Average wind speed at game time in km/h. Supports weather-impact analysis on game outcomes and informs outdoor venue operational planning."
    - name: "overtime_game_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN result_type = 'OVERTIME' THEN game_result_id END) / NULLIF(COUNT(DISTINCT game_result_id), 0), 2)
      comment: "Percentage of games going to overtime. Measures competitive balance and game excitement — a key metric for broadcast scheduling and fan engagement strategy."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_disciplinary_action`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "League disciplinary and compliance metrics tracking financial penalties, suspension patterns, appeal outcomes, and integrity violations. Enables compliance officers and league executives to monitor conduct standards and enforcement effectiveness."
  source: "`sports_entertainment_ecm`.`league`.`disciplinary_action`"
  dimensions:
    - name: "infraction_category"
      expr: infraction_category
      comment: "High-level category of the infraction (e.g., on-field conduct, doping, financial) — primary dimension for compliance trend analysis."
    - name: "infraction_type"
      expr: infraction_type
      comment: "Specific type of infraction — enables granular conduct pattern analysis and targeted intervention programs."
    - name: "action_status"
      expr: action_status
      comment: "Current status of the disciplinary action (pending, upheld, overturned) — used to track enforcement pipeline and resolution rates."
    - name: "appeal_status"
      expr: appeal_status
      comment: "Status of any appeal filed against the disciplinary action — measures appeal success rates and governance process effectiveness."
    - name: "subject_entity_type"
      expr: subject_entity_type
      comment: "Type of entity subject to the action (player, coach, franchise, official) — segments enforcement activity by stakeholder group."
    - name: "is_game_integrity_related"
      expr: is_game_integrity_related
      comment: "Flags actions related to game integrity violations — highest-priority compliance dimension for league governance."
    - name: "is_ped_related"
      expr: is_ped_related
      comment: "Flags actions related to performance-enhancing drug violations — critical for WADA compliance reporting and anti-doping program evaluation."
    - name: "repeat_offender"
      expr: repeat_offender
      comment: "Indicates whether the subject is a repeat offender — used to assess deterrence effectiveness and escalation policy impact."
    - name: "incident_date"
      expr: incident_date
      comment: "Date the incident occurred — primary time dimension for disciplinary trend and seasonality analysis."
  measures:
    - name: "total_fines_levied"
      expr: SUM(CAST(fine_amount AS DOUBLE))
      comment: "Total financial penalties levied across all disciplinary actions. Measures enforcement financial impact and serves as a deterrence effectiveness KPI."
    - name: "total_fines_collected"
      expr: SUM(CAST(fine_paid_amount AS DOUBLE))
      comment: "Total fines actually collected. Measures enforcement collection effectiveness — gap between levied and collected amounts signals compliance risk."
    - name: "fine_collection_rate"
      expr: ROUND(100.0 * SUM(CAST(fine_paid_amount AS DOUBLE)) / NULLIF(SUM(CAST(fine_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of levied fines that have been collected. A key enforcement effectiveness KPI — low rates indicate collection process failures or successful appeals."
    - name: "total_disciplinary_actions"
      expr: COUNT(DISTINCT disciplinary_action_id)
      comment: "Total number of disciplinary actions issued. Baseline volume metric for conduct trend monitoring and year-over-year enforcement comparison."
    - name: "actions_with_suspension"
      expr: COUNT(DISTINCT CASE WHEN suspension_games IS NOT NULL THEN disciplinary_action_id END)
      comment: "Number of disciplinary actions resulting in game suspensions. Measures severity of enforcement and competitive impact of conduct violations."
    - name: "appeals_filed_count"
      expr: COUNT(DISTINCT CASE WHEN appeal_filed_date IS NOT NULL THEN disciplinary_action_id END)
      comment: "Number of disciplinary actions where an appeal was filed. Measures subject dissatisfaction with rulings and governance process burden."
    - name: "appeal_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN appeal_filed_date IS NOT NULL THEN disciplinary_action_id END) / NULLIF(COUNT(DISTINCT disciplinary_action_id), 0), 2)
      comment: "Percentage of disciplinary actions that were appealed. High appeal rates signal inconsistent enforcement or overly aggressive penalty structures — informs CBA renegotiation."
    - name: "game_integrity_violations_count"
      expr: COUNT(DISTINCT CASE WHEN is_game_integrity_related = TRUE THEN disciplinary_action_id END)
      comment: "Number of disciplinary actions related to game integrity violations. The most critical compliance KPI — any elevation triggers mandatory executive and governing body review."
    - name: "ped_violations_count"
      expr: COUNT(DISTINCT CASE WHEN is_ped_related = TRUE THEN disciplinary_action_id END)
      comment: "Number of PED-related disciplinary actions. Tracks anti-doping program effectiveness and WADA compliance obligations — directly impacts league reputation and broadcast contracts."
    - name: "repeat_offender_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN repeat_offender = TRUE THEN disciplinary_action_id END) / NULLIF(COUNT(DISTINCT disciplinary_action_id), 0), 2)
      comment: "Percentage of disciplinary actions involving repeat offenders. Measures deterrence program effectiveness — high rates indicate penalty structures are insufficient to change behavior."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_standing`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Competitive standings metrics enabling league operations, broadcast, and fan engagement teams to monitor franchise performance, playoff positioning, and competitive balance across conferences and divisions."
  source: "`sports_entertainment_ecm`.`league`.`standing`"
  dimensions:
    - name: "snapshot_date"
      expr: snapshot_date
      comment: "Date of the standings snapshot — primary time dimension for standings trend and race-to-playoffs analysis."
    - name: "standings_type"
      expr: standings_type
      comment: "Type of standings record (league, conference, division, wild card) — segments competitive analysis by scope."
    - name: "standing_status"
      expr: standing_status
      comment: "Current status of the standing record (active, final, provisional) — filters to authoritative standings for reporting."
    - name: "clinch_indicator"
      expr: clinch_indicator
      comment: "Indicates playoff clinch status (clinched division, clinched wild card, eliminated) — key fan engagement and broadcast scheduling dimension."
    - name: "current_streak_type"
      expr: current_streak_type
      comment: "Type of current win/loss streak — used for momentum analysis and broadcast narrative generation."
  measures:
    - name: "avg_win_percentage"
      expr: AVG(CAST(win_pct AS DOUBLE))
      comment: "Average win percentage across franchises in the standings snapshot. Measures competitive balance — a tight distribution indicates a balanced league, informing scheduling and playoff format decisions."
    - name: "avg_games_behind_leader"
      expr: AVG(CAST(games_behind AS DOUBLE))
      comment: "Average games behind the division/conference leader. Measures competitive spread and race tightness — a key metric for broadcast excitement and playoff race marketing."
    - name: "avg_strength_of_schedule"
      expr: AVG(CAST(strength_of_schedule AS DOUBLE))
      comment: "Average strength of schedule across franchises. Used by league schedulers and analysts to assess fairness of schedule construction and playoff seeding validity."
    - name: "franchises_clinched_playoff"
      expr: COUNT(DISTINCT CASE WHEN clinch_indicator IS NOT NULL AND clinch_indicator != 'ELIMINATED' THEN franchise_id END)
      comment: "Number of franchises that have clinched a playoff berth. Tracks playoff field completion — drives broadcast scheduling, ticket sales activation, and fan engagement campaigns."
    - name: "franchises_eliminated"
      expr: COUNT(DISTINCT CASE WHEN clinch_indicator = 'ELIMINATED' THEN franchise_id END)
      comment: "Number of franchises mathematically eliminated from playoff contention. Measures late-season competitive relevance — informs broadcast rights utilization and attendance forecasting."
    - name: "total_standings_records"
      expr: COUNT(DISTINCT standing_id)
      comment: "Total number of standings records. Baseline count for standings data completeness validation and snapshot coverage auditing."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_trade_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Trade and transaction metrics for league operations, compliance, and competitive balance teams. Tracks transaction volume, financial consideration, salary cap impacts, and CBA compliance across all roster moves."
  source: "`sports_entertainment_ecm`.`league`.`trade_transaction`"
  dimensions:
    - name: "transaction_type"
      expr: transaction_type
      comment: "Type of roster transaction (trade, waiver claim, free agent signing, release) — primary dimension for transaction mix analysis."
    - name: "transaction_status"
      expr: transaction_status
      comment: "Current status of the transaction (pending, approved, voided, rejected) — filters to completed transactions for financial reporting."
    - name: "cba_compliance_status"
      expr: cba_compliance_status
      comment: "CBA compliance status of the transaction — flags non-compliant transactions for league review and potential sanctions."
    - name: "transaction_date"
      expr: transaction_date
      comment: "Date the transaction was executed — primary time dimension for transaction volume and deadline-period activity analysis."
    - name: "cash_consideration_currency_code"
      expr: cash_consideration_currency_code
      comment: "Currency of cash consideration in the transaction — required for multi-currency financial consolidation."
    - name: "competitive_integrity_review_flag"
      expr: competitive_integrity_review_flag
      comment: "Flags transactions requiring competitive integrity review — used by league governance to monitor collusion risk."
    - name: "trade_deadline_exception_flag"
      expr: trade_deadline_exception_flag
      comment: "Indicates whether the transaction was executed under a trade deadline exception — tracks CBA exception utilization."
    - name: "transaction_window_compliant"
      expr: transaction_window_compliant
      comment: "Indicates whether the transaction was executed within an approved transaction window — compliance dimension for CBA enforcement."
  measures:
    - name: "total_transactions"
      expr: COUNT(DISTINCT trade_transaction_id)
      comment: "Total number of roster transactions executed. Baseline activity metric for league transaction volume monitoring and CBA transaction limit compliance."
    - name: "total_cash_consideration"
      expr: SUM(CAST(cash_consideration_amount AS DOUBLE))
      comment: "Total cash consideration exchanged in transactions. Measures financial value flowing through the transaction market — informs CBA cash consideration cap monitoring."
    - name: "total_salary_cap_impact_acquiring"
      expr: SUM(CAST(salary_cap_impact_acquiring AS DOUBLE))
      comment: "Total salary cap impact on acquiring franchises across all transactions. Measures aggregate cap space consumed by incoming assets — critical for league-wide cap health monitoring."
    - name: "total_salary_cap_impact_trading"
      expr: SUM(CAST(salary_cap_impact_trading AS DOUBLE))
      comment: "Total salary cap impact on trading (outgoing) franchises. Measures cap relief generated through trades — used to assess franchise roster management strategies."
    - name: "total_salary_obligation_transferred"
      expr: SUM(CAST(salary_obligation_transferred_amount AS DOUBLE))
      comment: "Total salary obligation transferred between franchises in transactions. Tracks financial liability redistribution across the league — a key CBA financial monitoring metric."
    - name: "total_waiver_claim_fees"
      expr: SUM(CAST(waiver_claim_fee_amount AS DOUBLE))
      comment: "Total waiver claim fees collected. Measures league revenue from waiver wire activity and tracks waiver market utilization."
    - name: "non_compliant_transaction_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN cba_compliance_status = 'NON_COMPLIANT' THEN trade_transaction_id END) / NULLIF(COUNT(DISTINCT trade_transaction_id), 0), 2)
      comment: "Percentage of transactions flagged as CBA non-compliant. A critical governance KPI — elevated rates signal systemic CBA violations requiring immediate league intervention."
    - name: "transactions_requiring_integrity_review"
      expr: COUNT(DISTINCT CASE WHEN competitive_integrity_review_flag = TRUE THEN trade_transaction_id END)
      comment: "Number of transactions flagged for competitive integrity review. Monitors collusion risk and governance workload — high volumes may indicate market manipulation patterns."
    - name: "voided_transaction_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN transaction_status = 'VOIDED' THEN trade_transaction_id END) / NULLIF(COUNT(DISTINCT trade_transaction_id), 0), 2)
      comment: "Percentage of transactions that were voided. Measures transaction quality and process failure rate — high void rates indicate CBA compliance gaps or due diligence failures."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_draft`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Draft event operational and strategic metrics for league management, broadcast, and fan engagement teams. Tracks draft execution quality, attendance, pick completion, and compliance across annual and supplemental drafts."
  source: "`sports_entertainment_ecm`.`league`.`draft`"
  dimensions:
    - name: "draft_status"
      expr: draft_status
      comment: "Current status of the draft event (scheduled, in-progress, completed, cancelled) — primary filter for operational reporting."
    - name: "draft_date"
      expr: draft_date
      comment: "Date the draft was held — primary time dimension for year-over-year draft comparison."
    - name: "host_city"
      expr: host_city
      comment: "City where the draft was hosted — used for venue selection ROI and fan attendance analysis."
    - name: "host_country_code"
      expr: host_country_code
      comment: "Country where the draft was hosted — supports international expansion and broadcast rights analysis."
    - name: "format"
      expr: format
      comment: "Draft format (in-person, virtual, hybrid) — used to analyze format impact on attendance, broadcast ratings, and pick clock compliance."
    - name: "supplemental_draft"
      expr: supplemental_draft
      comment: "Indicates whether this is a supplemental draft — segments main draft metrics from supplemental activity."
    - name: "fan_attendance_allowed"
      expr: fan_attendance_allowed
      comment: "Indicates whether fans were permitted to attend — used to analyze fan engagement and gate revenue potential."
    - name: "ott_streaming_enabled"
      expr: ott_streaming_enabled
      comment: "Indicates whether OTT streaming was enabled for the draft — tracks digital broadcast utilization and audience reach."
  measures:
    - name: "total_drafts"
      expr: COUNT(DISTINCT draft_id)
      comment: "Total number of draft events. Baseline count for draft program scope and year-over-year comparison."
    - name: "drafts_with_integrity_review"
      expr: COUNT(DISTINCT CASE WHEN integrity_review_required = TRUE THEN draft_id END)
      comment: "Number of drafts requiring integrity review. Tracks governance workload and flags drafts with potential competitive integrity concerns."
    - name: "drafts_with_lottery"
      expr: COUNT(DISTINCT CASE WHEN lottery_conducted = TRUE THEN draft_id END)
      comment: "Number of drafts where a lottery was conducted. Measures lottery program utilization — a key competitive balance mechanism tracked by league governance."
    - name: "drafts_with_ott_streaming"
      expr: COUNT(DISTINCT CASE WHEN ott_streaming_enabled = TRUE THEN draft_id END)
      comment: "Number of drafts with OTT streaming enabled. Tracks digital broadcast adoption — informs media rights strategy and fan engagement platform investment decisions."
    - name: "drafts_with_compensatory_picks"
      expr: COUNT(DISTINCT CASE WHEN compensatory_picks_authorized = TRUE THEN draft_id END)
      comment: "Number of drafts authorizing compensatory picks. Measures CBA compensatory pick mechanism utilization — informs competitive balance policy effectiveness."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_draft_pick`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Draft pick asset valuation and transaction metrics for league operations, franchise management, and competitive balance analysis. Tracks pick values, trade activity, conditional picks, and CBA compliance."
  source: "`sports_entertainment_ecm`.`league`.`draft_pick`"
  dimensions:
    - name: "pick_status"
      expr: pick_status
      comment: "Current status of the draft pick (available, traded, exercised, forfeited) — primary filter for active pick inventory analysis."
    - name: "pick_type"
      expr: pick_type
      comment: "Type of draft pick (first round, second round, compensatory) — segments pick value and trade analysis by tier."
    - name: "draft_year"
      expr: draft_year
      comment: "Year the pick is scheduled to be exercised — primary time dimension for future pick asset planning."
    - name: "round_number"
      expr: round_number
      comment: "Round number of the draft pick — key dimension for pick value stratification and trade analysis."
    - name: "draft_position_tier"
      expr: draft_position_tier
      comment: "Tier classification of the pick's projected draft position — used for asset valuation and trade negotiation analysis."
    - name: "is_compensatory_pick"
      expr: is_compensatory_pick
      comment: "Indicates whether the pick is a compensatory pick awarded under CBA rules — segments standard vs. compensatory pick analysis."
    - name: "is_conditional"
      expr: is_conditional
      comment: "Indicates whether the pick has conditions attached — used to track contingent asset exposure in franchise portfolios."
    - name: "cba_compliance_status"
      expr: cba_compliance_status
      comment: "CBA compliance status of the pick — flags picks at risk of forfeiture due to violations."
    - name: "protection_level"
      expr: protection_level
      comment: "Protection level on the pick (e.g., top-5 protected, lottery protected) — critical for accurate asset valuation."
  measures:
    - name: "total_pick_valuation"
      expr: SUM(CAST(pick_valuation_score AS DOUBLE))
      comment: "Total aggregate pick valuation score across all draft picks. Measures total draft asset value in the league — used for trade value benchmarking and franchise asset portfolio analysis."
    - name: "avg_pick_valuation_score"
      expr: AVG(CAST(pick_valuation_score AS DOUBLE))
      comment: "Average pick valuation score. Benchmarks individual pick values against the league average — informs trade negotiation and franchise asset management decisions."
    - name: "total_salary_cap_slot_value"
      expr: SUM(CAST(salary_cap_slot_value AS DOUBLE))
      comment: "Total salary cap slot value committed to draft picks. Measures the aggregate cap impact of draft selections — critical for franchise cap planning and CBA rookie scale compliance."
    - name: "avg_salary_cap_slot_value"
      expr: AVG(CAST(salary_cap_slot_value AS DOUBLE))
      comment: "Average salary cap slot value per draft pick. Benchmarks rookie contract costs and informs draft strategy relative to cap constraints."
    - name: "total_picks"
      expr: COUNT(DISTINCT draft_pick_id)
      comment: "Total number of draft picks in the system. Baseline inventory count for draft asset tracking and CBA pick allocation compliance."
    - name: "traded_picks_count"
      expr: COUNT(DISTINCT CASE WHEN pick_status = 'TRADED' THEN draft_pick_id END)
      comment: "Number of draft picks that have been traded. Measures draft pick market activity — high volumes indicate active franchise rebuilding strategies."
    - name: "pick_trade_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN pick_status = 'TRADED' THEN draft_pick_id END) / NULLIF(COUNT(DISTINCT draft_pick_id), 0), 2)
      comment: "Percentage of draft picks that have been traded. Measures draft pick market liquidity and franchise willingness to trade future assets — a competitive balance indicator."
    - name: "conditional_picks_count"
      expr: COUNT(DISTINCT CASE WHEN is_conditional = TRUE THEN draft_pick_id END)
      comment: "Number of conditional draft picks outstanding. Tracks contingent asset exposure across the league — high counts increase financial and competitive planning uncertainty."
    - name: "forfeited_picks_count"
      expr: COUNT(DISTINCT CASE WHEN pick_status = 'FORFEITED' THEN draft_pick_id END)
      comment: "Number of draft picks forfeited due to violations. Measures enforcement severity and competitive penalty impact — directly affects franchise competitive positioning."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_official`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Officiating workforce quality and compliance metrics for league operations and integrity teams. Tracks performance ratings, certification levels, playoff eligibility, and disciplinary flags across the officiating pool."
  source: "`sports_entertainment_ecm`.`league`.`official`"
  dimensions:
    - name: "official_status"
      expr: official_status
      comment: "Current employment/certification status of the official (active, suspended, retired) — primary filter for active officiating pool analysis."
    - name: "role_type"
      expr: role_type
      comment: "Role type of the official (referee, linesman, VAR operator, TMO) — segments performance analysis by officiating function."
    - name: "certification_tier"
      expr: certification_tier
      comment: "Certification tier of the official — used to analyze performance by qualification level and inform promotion/demotion decisions."
    - name: "geographic_region"
      expr: geographic_region
      comment: "Geographic region of the official — used for assignment logistics and regional officiating quality analysis."
    - name: "home_country_code"
      expr: home_country_code
      comment: "Home country of the official — supports international assignment eligibility and diversity reporting."
    - name: "playoff_eligible"
      expr: playoff_eligible
      comment: "Indicates whether the official is eligible for playoff assignments — segments elite officiating pool for postseason planning."
    - name: "var_certified"
      expr: var_certified
      comment: "Indicates whether the official holds VAR certification — tracks technology-enabled officiating capacity."
    - name: "tmo_certified"
      expr: tmo_certified
      comment: "Indicates whether the official holds TMO certification — tracks TMO-capable officiating pool size."
    - name: "integrity_clearance_status"
      expr: integrity_clearance_status
      comment: "Current integrity clearance status of the official — critical compliance dimension for assignment eligibility."
  measures:
    - name: "avg_performance_rating"
      expr: AVG(CAST(performance_rating AS DOUBLE))
      comment: "Average performance rating across all officials. Primary officiating quality KPI — used to benchmark individual officials, identify underperformers, and inform assignment decisions."
    - name: "total_active_officials"
      expr: COUNT(DISTINCT CASE WHEN official_status = 'ACTIVE' THEN official_id END)
      comment: "Total number of active officials. Measures officiating workforce capacity — insufficient active officials relative to scheduled games triggers emergency assignment protocols."
    - name: "playoff_eligible_officials_count"
      expr: COUNT(DISTINCT CASE WHEN playoff_eligible = TRUE THEN official_id END)
      comment: "Number of officials eligible for playoff assignments. Measures postseason officiating pool depth — a critical operational readiness metric for playoff scheduling."
    - name: "var_certified_officials_count"
      expr: COUNT(DISTINCT CASE WHEN var_certified = TRUE THEN official_id END)
      comment: "Number of VAR-certified officials. Tracks technology-enabled officiating capacity — insufficient VAR-certified officials constrains VAR deployment and game integrity capabilities."
    - name: "tmo_certified_officials_count"
      expr: COUNT(DISTINCT CASE WHEN tmo_certified = TRUE THEN official_id END)
      comment: "Number of TMO-certified officials. Measures TMO deployment capacity — directly impacts the league's ability to fulfill TMO-enabled game commitments."
    - name: "officials_with_disciplinary_flag"
      expr: COUNT(DISTINCT CASE WHEN disciplinary_flag = TRUE THEN official_id END)
      comment: "Number of officials currently under a disciplinary flag. Tracks officiating conduct risk — flagged officials may be ineligible for high-profile assignments, impacting scheduling."
    - name: "officials_without_integrity_clearance"
      expr: COUNT(DISTINCT CASE WHEN integrity_clearance_status != 'CLEARED' THEN official_id END)
      comment: "Number of officials without full integrity clearance. A critical compliance KPI — uncleared officials cannot be assigned to games, directly impacting scheduling capacity."
    - name: "playoff_eligibility_rate"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN playoff_eligible = TRUE THEN official_id END) / NULLIF(COUNT(DISTINCT official_id), 0), 2)
      comment: "Percentage of officials eligible for playoff assignments. Measures elite officiating pool depth relative to total workforce — informs officiating development program investment."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`league_season`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Season-level strategic and financial metrics for league executives and operations teams. Tracks salary cap levels, luxury tax thresholds, and season structural attributes to support annual planning and CBA compliance."
  source: "`sports_entertainment_ecm`.`league`.`season`"
  dimensions:
    - name: "season_status"
      expr: season_status
      comment: "Current status of the season (upcoming, active, completed, cancelled) — primary filter for in-season vs. historical analysis."
    - name: "season_type"
      expr: season_type
      comment: "Type of season (regular, shortened, expansion) — segments financial and operational metrics by season context."
    - name: "season_code"
      expr: season_code
      comment: "Unique season code — used as a business-friendly time dimension for cross-season trend analysis."
    - name: "playoff_format"
      expr: playoff_format
      comment: "Playoff format used in the season — used to analyze format impact on fan engagement and broadcast revenue."
    - name: "shortened_season_flag"
      expr: shortened_season_flag
      comment: "Indicates whether the season was shortened (e.g., due to labor disputes or external events) — critical context for financial and performance metric normalization."
    - name: "expansion_season_flag"
      expr: expansion_season_flag
      comment: "Indicates whether the season includes expansion teams — used to segment baseline metrics from expansion-impacted seasons."
    - name: "salary_cap_currency"
      expr: salary_cap_currency
      comment: "Currency of the season salary cap — required for multi-currency financial reporting and CBA compliance."
  measures:
    - name: "total_seasons"
      expr: COUNT(DISTINCT season_id)
      comment: "Total number of seasons in the system. Baseline count for historical trend analysis and league longevity reporting."
    - name: "avg_season_salary_cap"
      expr: AVG(CAST(salary_cap_amount AS DOUBLE))
      comment: "Average salary cap amount across seasons. Tracks CBA-driven cap growth over time — a key financial planning metric for franchise budgeting and player contract negotiations."
    - name: "max_season_salary_cap"
      expr: MAX(CAST(salary_cap_amount AS DOUBLE))
      comment: "Maximum salary cap amount across seasons. Identifies the peak cap level — used as a benchmark for current-season cap positioning and CBA negotiation anchoring."
    - name: "avg_luxury_tax_threshold"
      expr: AVG(CAST(luxury_tax_threshold AS DOUBLE))
      comment: "Average luxury tax threshold across seasons. Tracks the evolution of the luxury tax trigger level — informs franchise financial planning and CBA renegotiation strategy."
    - name: "seasons_with_shortened_flag"
      expr: COUNT(DISTINCT CASE WHEN shortened_season_flag = TRUE THEN season_id END)
      comment: "Number of shortened seasons in league history. Measures operational disruption frequency — informs force majeure planning and broadcast contract contingency provisions."
$$;