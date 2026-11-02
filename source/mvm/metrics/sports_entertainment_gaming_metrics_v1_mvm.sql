-- Metric views for domain: gaming | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_wager`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core sportsbook wagering KPIs covering handle volume, liability exposure, margin performance, and responsible-gaming risk signals. Primary steering dashboard for sportsbook operators and finance leadership."
  source: "`sports_entertainment_ecm`.`gaming`.`wager`"
  dimensions:
    - name: "wager_type"
      expr: wager_type
      comment: "Type of wager (straight, parlay, teaser, futures, etc.) for product-mix analysis."
    - name: "wager_status"
      expr: wager_status
      comment: "Current settlement status of the wager (open, settled, voided, cashed-out) for pipeline monitoring."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency in which the wager was placed, enabling multi-currency reporting."
    - name: "is_live_bet"
      expr: is_live_bet
      comment: "Flags in-play (live) wagers vs pre-match wagers for product-line segmentation."
    - name: "is_free_bet"
      expr: is_free_bet
      comment: "Distinguishes promotional free-bet handle from real-money handle for margin-adjusted reporting."
    - name: "geolocation_state"
      expr: geolocation_state
      comment: "US state from which the wager was placed, critical for jurisdiction-level regulatory and tax reporting."
    - name: "odds_format"
      expr: odds_format
      comment: "Odds format used at placement (American, Decimal, Fractional) for market-preference analysis."
    - name: "placement_date"
      expr: DATE_TRUNC('DAY', placement_timestamp)
      comment: "Calendar day the wager was placed, enabling daily handle trend analysis."
    - name: "placement_month"
      expr: DATE_TRUNC('MONTH', placement_timestamp)
      comment: "Calendar month of wager placement for monthly revenue and handle reporting."
    - name: "settlement_date"
      expr: DATE_TRUNC('DAY', settlement_timestamp)
      comment: "Calendar day the wager was settled, used for GGR period attribution."
    - name: "responsible_gaming_flag"
      expr: responsible_gaming_flag
      comment: "Indicates wagers flagged under responsible-gaming controls, used for compliance monitoring."
    - name: "integrity_flag"
      expr: integrity_flag
      comment: "Flags wagers under integrity investigation, used for fraud and match-fixing risk dashboards."
  measures:
    - name: "total_handle"
      expr: SUM(CAST(stake_amount AS DOUBLE))
      comment: "Total wagering handle (gross stakes accepted). Primary top-line revenue driver for sportsbook operations."
    - name: "total_real_money_handle"
      expr: SUM(CASE WHEN is_free_bet = FALSE THEN CAST(stake_amount AS DOUBLE) ELSE 0.0 END)
      comment: "Real-money handle excluding promotional free-bet stakes. Reflects true cash-at-risk exposure."
    - name: "total_bonus_amount"
      expr: SUM(CAST(bonus_amount AS DOUBLE))
      comment: "Total promotional bonus credits wagered. Used to measure promotional cost and bonus liability."
    - name: "total_settlement_amount"
      expr: SUM(CAST(settlement_amount AS DOUBLE))
      comment: "Total amount paid out to bettors on settled wagers. Used to compute gross gaming revenue."
    - name: "total_potential_payout"
      expr: SUM(CAST(potential_payout AS DOUBLE))
      comment: "Sum of maximum potential payouts on open wagers. Represents current liability exposure on the book."
    - name: "total_cashout_amount"
      expr: SUM(CAST(cashout_amount AS DOUBLE))
      comment: "Total value of early cashout settlements. Measures cashout product utilization and associated margin impact."
    - name: "total_tax_withheld"
      expr: SUM(CAST(tax_withheld_amount AS DOUBLE))
      comment: "Total tax withheld at source on winning wagers. Required for regulatory tax remittance reporting."
    - name: "wager_count"
      expr: COUNT(1)
      comment: "Total number of wagers placed. Baseline volume metric for throughput and capacity planning."
    - name: "unique_bettors"
      expr: COUNT(DISTINCT bettor_account_id)
      comment: "Count of distinct active bettors. Key engagement and market-penetration KPI."
    - name: "avg_stake_per_wager"
      expr: AVG(CAST(stake_amount AS DOUBLE))
      comment: "Average stake size per wager. Indicates bettor spending intensity and product tier mix."
    - name: "avg_potential_payout"
      expr: AVG(CAST(potential_payout AS DOUBLE))
      comment: "Average potential payout per wager. Proxy for average odds taken and risk appetite of the bettor base."
    - name: "live_bet_handle"
      expr: SUM(CASE WHEN is_live_bet = TRUE THEN CAST(stake_amount AS DOUBLE) ELSE 0.0 END)
      comment: "Handle attributable to in-play (live) wagering. Measures growth of the live-betting product line."
    - name: "integrity_flagged_handle"
      expr: SUM(CASE WHEN integrity_flag = TRUE THEN CAST(stake_amount AS DOUBLE) ELSE 0.0 END)
      comment: "Total handle on wagers flagged for integrity review. Quantifies financial exposure under investigation."
    - name: "responsible_gaming_flagged_wager_count"
      expr: COUNT(CASE WHEN responsible_gaming_flag = TRUE THEN 1 END)
      comment: "Number of wagers flagged under responsible-gaming controls. Compliance KPI for regulatory reporting."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_payout`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Payout and gross gaming revenue (GGR) metrics covering prize disbursements, tax withholding, W-2G reporting obligations, and payout efficiency. Used by finance, compliance, and operations leadership."
  source: "`sports_entertainment_ecm`.`gaming`.`payout`"
  dimensions:
    - name: "payout_type"
      expr: payout_type
      comment: "Category of payout (wager win, contest prize, bonus, etc.) for revenue-line attribution."
    - name: "payout_status"
      expr: payout_status
      comment: "Current status of the payout (pending, completed, failed, reversed) for operational pipeline monitoring."
    - name: "payout_method"
      expr: payout_method
      comment: "Disbursement channel (ACH, check, PayPal, casino cage, etc.) for payment-operations analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the payout for multi-currency financial reporting."
    - name: "geolocation_state"
      expr: geolocation_state
      comment: "State where the payout was triggered, used for state-level tax and regulatory reporting."
    - name: "w2g_reportable"
      expr: w2g_reportable
      comment: "Flags payouts that meet IRS W-2G reporting thresholds. Critical for tax compliance."
    - name: "is_free_bet_payout"
      expr: is_free_bet_payout
      comment: "Distinguishes payouts originating from free-bet promotions vs real-money wagers."
    - name: "aml_review_flag"
      expr: aml_review_flag
      comment: "Flags payouts under AML review. Used for compliance risk dashboards."
    - name: "payout_month"
      expr: DATE_TRUNC('MONTH', payout_timestamp)
      comment: "Calendar month of payout completion for monthly GGR and cash-flow reporting."
    - name: "ggr_period"
      expr: ggr_period
      comment: "Operator-defined GGR accounting period for period-over-period revenue comparison."
    - name: "operator_code"
      expr: operator_code
      comment: "Operator identifier for multi-operator platform revenue attribution."
  measures:
    - name: "total_gross_payout"
      expr: SUM(CAST(gross_payout_amount AS DOUBLE))
      comment: "Total gross amount paid out to bettors before tax withholding. Primary payout liability metric."
    - name: "total_net_payout"
      expr: SUM(CAST(net_payout_amount AS DOUBLE))
      comment: "Total net payout after tax withholding. Represents actual cash disbursed to bettors."
    - name: "total_tax_withheld"
      expr: SUM(CAST(tax_withheld_amount AS DOUBLE))
      comment: "Total federal and state taxes withheld on payouts. Required for IRS and state tax remittance."
    - name: "total_state_withholding"
      expr: SUM(CAST(state_withholding_amount AS DOUBLE))
      comment: "State-level tax withholding total. Used for state-by-state tax compliance reporting."
    - name: "total_bonus_included_in_payout"
      expr: SUM(CAST(bonus_amount_included AS DOUBLE))
      comment: "Bonus credits included in payouts. Measures promotional cost embedded in prize disbursements."
    - name: "total_stake_returned"
      expr: SUM(CAST(stake_amount AS DOUBLE))
      comment: "Total original stake amounts associated with settled payouts. Used to compute hold percentage."
    - name: "payout_count"
      expr: COUNT(1)
      comment: "Total number of payout transactions. Baseline volume metric for payment operations."
    - name: "w2g_reportable_payout_count"
      expr: COUNT(CASE WHEN w2g_reportable = TRUE THEN 1 END)
      comment: "Number of payouts meeting IRS W-2G reporting threshold. Drives tax form issuance workload."
    - name: "aml_flagged_payout_count"
      expr: COUNT(CASE WHEN aml_review_flag = TRUE THEN 1 END)
      comment: "Number of payouts flagged for AML review. Key compliance risk indicator."
    - name: "avg_gross_payout"
      expr: AVG(CAST(gross_payout_amount AS DOUBLE))
      comment: "Average gross payout per transaction. Indicates prize-size distribution and bettor win patterns."
    - name: "unique_payout_recipients"
      expr: COUNT(DISTINCT bettor_account_id)
      comment: "Count of distinct bettors receiving payouts. Measures breadth of prize distribution."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_bettor_account`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Bettor account lifecycle, acquisition, compliance, and responsible-gaming KPIs. Used by marketing, compliance, and customer operations to manage the active player base."
  source: "`sports_entertainment_ecm`.`gaming`.`bettor_account`"
  dimensions:
    - name: "account_status"
      expr: account_status
      comment: "Current account status (active, suspended, closed, self-excluded) for lifecycle segmentation."
    - name: "account_tier"
      expr: account_tier
      comment: "VIP or loyalty tier of the bettor account for high-value player segmentation."
    - name: "account_type"
      expr: account_type
      comment: "Account classification (retail, online, affiliate) for channel-mix analysis."
    - name: "kyc_status"
      expr: kyc_status
      comment: "Know-Your-Customer verification status. Critical for regulatory compliance monitoring."
    - name: "registration_jurisdiction"
      expr: registration_jurisdiction
      comment: "Jurisdiction where the account was registered for regulatory and tax attribution."
    - name: "registration_state_code"
      expr: registration_state_code
      comment: "US state of registration for state-level regulatory reporting."
    - name: "source_channel"
      expr: source_channel
      comment: "Acquisition channel (organic, affiliate, paid, referral) for marketing ROI analysis."
    - name: "self_exclusion_status"
      expr: self_exclusion_status
      comment: "Self-exclusion enrollment status for responsible-gaming compliance dashboards."
    - name: "preferred_sport"
      expr: preferred_sport
      comment: "Bettor's declared preferred sport for product personalization and content targeting."
    - name: "open_date"
      expr: DATE_TRUNC('MONTH', open_date)
      comment: "Month of account opening for cohort-based acquisition and retention analysis."
    - name: "responsible_gaming_flag"
      expr: responsible_gaming_flag
      comment: "Accounts flagged under responsible-gaming programs for compliance monitoring."
    - name: "age_verified"
      expr: age_verified
      comment: "Age verification completion status. Regulatory requirement in all licensed jurisdictions."
  measures:
    - name: "total_accounts"
      expr: COUNT(1)
      comment: "Total registered bettor accounts. Baseline market-size and growth metric."
    - name: "active_accounts"
      expr: COUNT(CASE WHEN account_status = 'active' THEN 1 END)
      comment: "Number of currently active bettor accounts. Primary engagement and retention KPI."
    - name: "kyc_verified_accounts"
      expr: COUNT(CASE WHEN kyc_status = 'verified' THEN 1 END)
      comment: "Accounts with completed KYC verification. Regulatory compliance coverage metric."
    - name: "self_excluded_accounts"
      expr: COUNT(CASE WHEN self_exclusion_status = 'active' THEN 1 END)
      comment: "Accounts currently under active self-exclusion. Key responsible-gaming compliance KPI."
    - name: "responsible_gaming_flagged_accounts"
      expr: COUNT(CASE WHEN responsible_gaming_flag = TRUE THEN 1 END)
      comment: "Accounts flagged under responsible-gaming intervention programs. Compliance risk indicator."
    - name: "total_account_balance"
      expr: SUM(CAST(balance AS DOUBLE))
      comment: "Aggregate real-money balance held across all bettor accounts. Represents total player fund liability."
    - name: "total_bonus_balance"
      expr: SUM(CAST(bonus_balance AS DOUBLE))
      comment: "Total bonus credit balance outstanding. Measures promotional liability on the balance sheet."
    - name: "avg_account_balance"
      expr: AVG(CAST(balance AS DOUBLE))
      comment: "Average real-money balance per bettor account. Indicates player funding depth and engagement level."
    - name: "avg_daily_deposit_limit"
      expr: AVG(CAST(deposit_limit_daily AS DOUBLE))
      comment: "Average daily deposit limit set across accounts. Measures responsible-gaming limit adoption."
    - name: "two_factor_auth_enabled_accounts"
      expr: COUNT(CASE WHEN two_factor_auth_enabled = TRUE THEN 1 END)
      comment: "Accounts with 2FA enabled. Security posture and fraud-prevention coverage metric."
    - name: "w2g_threshold_met_accounts"
      expr: COUNT(CASE WHEN w2g_threshold_met = TRUE THEN 1 END)
      comment: "Accounts that have met the IRS W-2G reporting threshold. Drives tax compliance workload planning."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_contest_entry`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Daily fantasy sports (DFS) contest entry performance, prize economics, and responsible-gaming metrics. Used by DFS product, finance, and compliance teams to manage contest health and player outcomes."
  source: "`sports_entertainment_ecm`.`gaming`.`contest_entry`"
  dimensions:
    - name: "entry_status"
      expr: entry_status
      comment: "Current status of the contest entry (active, settled, voided, cancelled) for pipeline monitoring."
    - name: "entry_type"
      expr: entry_type
      comment: "Type of entry (standard, rebuy, bonus, etc.) for product-mix analysis."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport associated with the contest entry for sport-level performance analysis."
    - name: "payout_status"
      expr: payout_status
      comment: "Prize payout status for the entry. Used to track settlement pipeline and outstanding prize liability."
    - name: "prize_tier"
      expr: prize_tier
      comment: "Prize tier achieved by the entry. Used to analyze prize distribution and top-heavy payout structures."
    - name: "geolocation_state"
      expr: geolocation_state
      comment: "State from which the entry was submitted. Required for jurisdiction-level regulatory reporting."
    - name: "device_type"
      expr: device_type
      comment: "Device used to submit the entry (mobile, desktop, tablet) for product channel analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the entry fee and prize for multi-currency financial reporting."
    - name: "contest_slate_date"
      expr: DATE_TRUNC('DAY', contest_slate_date)
      comment: "Slate date of the contest for daily volume and revenue trend analysis."
    - name: "entry_month"
      expr: DATE_TRUNC('MONTH', entry_timestamp)
      comment: "Month of entry submission for monthly DFS revenue reporting."
    - name: "w2g_reportable"
      expr: w2g_reportable
      comment: "Flags entries with W-2G reportable prize amounts for tax compliance tracking."
    - name: "responsible_gaming_flag"
      expr: responsible_gaming_flag
      comment: "Entries flagged under responsible-gaming controls for compliance monitoring."
    - name: "is_autopick"
      expr: is_autopick
      comment: "Indicates auto-drafted lineups vs manually constructed lineups for product engagement analysis."
  measures:
    - name: "total_entry_fees_collected"
      expr: SUM(CAST(entry_fee_amount AS DOUBLE))
      comment: "Total gross entry fees collected across all contest entries. Primary DFS revenue driver."
    - name: "total_net_entry_fees"
      expr: SUM(CAST(net_entry_fee_amount AS DOUBLE))
      comment: "Total net entry fees after bonus credits applied. Represents true cash revenue from DFS entries."
    - name: "total_prize_awarded"
      expr: SUM(CAST(prize_amount AS DOUBLE))
      comment: "Total prize amounts awarded to contest entries. Used to compute DFS rake and prize-pool efficiency."
    - name: "total_bonus_applied"
      expr: SUM(CAST(bonus_amount_applied AS DOUBLE))
      comment: "Total bonus credits applied toward entry fees. Measures promotional subsidy cost in DFS."
    - name: "total_tax_withheld"
      expr: SUM(CAST(tax_withheld_amount AS DOUBLE))
      comment: "Total taxes withheld on DFS prize payouts. Required for regulatory tax remittance."
    - name: "total_salary_cap_used"
      expr: SUM(CAST(salary_cap_used AS DOUBLE))
      comment: "Total salary cap consumed across all lineups. Proxy for roster construction depth and player diversity."
    - name: "entry_count"
      expr: COUNT(1)
      comment: "Total number of contest entries submitted. Baseline DFS volume and engagement metric."
    - name: "unique_entrants"
      expr: COUNT(DISTINCT bettor_account_id)
      comment: "Count of distinct players entering contests. Measures DFS active player base breadth."
    - name: "avg_entry_fee"
      expr: AVG(CAST(entry_fee_amount AS DOUBLE))
      comment: "Average entry fee per contest entry. Indicates contest buy-in tier mix and player spending level."
    - name: "avg_prize_per_entry"
      expr: AVG(CAST(prize_amount AS DOUBLE))
      comment: "Average prize amount per entry. Used to evaluate prize-pool distribution fairness and attractiveness."
    - name: "avg_actual_points"
      expr: AVG(CAST(actual_points AS DOUBLE))
      comment: "Average fantasy points scored per entry. Measures scoring competitiveness and lineup quality."
    - name: "w2g_reportable_entry_count"
      expr: COUNT(CASE WHEN w2g_reportable = TRUE THEN 1 END)
      comment: "Number of entries with W-2G reportable prizes. Drives IRS tax form issuance volume."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_betting_market`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Betting market configuration, liability, and margin KPIs. Used by trading, risk, and product teams to manage market offerings, exposure limits, and pricing efficiency."
  source: "`sports_entertainment_ecm`.`gaming`.`betting_market`"
  dimensions:
    - name: "market_status"
      expr: market_status
      comment: "Current status of the betting market (open, suspended, settled, closed) for trading desk monitoring."
    - name: "market_type_code"
      expr: market_type_code
      comment: "Type of betting market (moneyline, spread, total, futures, prop) for product-line analysis."
    - name: "market_category"
      expr: market_category
      comment: "High-level market category for portfolio-level risk and revenue reporting."
    - name: "sport_code"
      expr: sport_code
      comment: "Sport associated with the market for sport-level trading performance analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the market for multi-currency exposure reporting."
    - name: "is_live_inplay"
      expr: is_live_inplay
      comment: "Distinguishes in-play markets from pre-match markets for live-betting product analysis."
    - name: "is_futures_market"
      expr: is_futures_market
      comment: "Identifies futures markets for long-duration liability tracking."
    - name: "is_featured"
      expr: is_featured
      comment: "Featured market flag for promotional placement and conversion analysis."
    - name: "is_parlay_eligible"
      expr: is_parlay_eligible
      comment: "Parlay eligibility flag for multi-leg wager product analysis."
    - name: "settlement_outcome"
      expr: settlement_outcome
      comment: "Final settlement result of the market (win, lose, void, push) for outcome distribution analysis."
    - name: "odds_format"
      expr: odds_format
      comment: "Odds format offered on the market for regional product preference analysis."
    - name: "market_open_date"
      expr: DATE_TRUNC('DAY', market_open_timestamp)
      comment: "Day the market opened for market-creation volume trend analysis."
    - name: "season_year"
      expr: season_year
      comment: "Season year of the market for seasonal performance comparison."
    - name: "responsible_gaming_flag"
      expr: responsible_gaming_flag
      comment: "Markets flagged under responsible-gaming restrictions for compliance review."
  measures:
    - name: "market_count"
      expr: COUNT(1)
      comment: "Total number of betting markets created. Measures product breadth and trading desk output."
    - name: "total_max_liability"
      expr: SUM(CAST(max_liability_amount AS DOUBLE))
      comment: "Aggregate maximum liability exposure across all markets. Primary risk management KPI for the trading book."
    - name: "total_max_payout"
      expr: SUM(CAST(max_payout_amount AS DOUBLE))
      comment: "Sum of maximum payout caps across markets. Measures worst-case payout exposure."
    - name: "avg_margin_percentage"
      expr: AVG(CAST(margin_percentage AS DOUBLE))
      comment: "Average overround/margin percentage across markets. Key pricing efficiency and profitability KPI."
    - name: "avg_spread_value"
      expr: AVG(CAST(spread_value AS DOUBLE))
      comment: "Average spread value across spread markets. Used by trading to monitor line competitiveness."
    - name: "avg_total_line_value"
      expr: AVG(CAST(total_line_value AS DOUBLE))
      comment: "Average total (over/under) line value across totals markets. Monitors line-setting accuracy."
    - name: "avg_max_stake"
      expr: AVG(CAST(max_stake_amount AS DOUBLE))
      comment: "Average maximum stake limit per market. Reflects risk appetite and liability management posture."
    - name: "live_inplay_market_count"
      expr: COUNT(CASE WHEN is_live_inplay = TRUE THEN 1 END)
      comment: "Number of live in-play markets offered. Measures live-betting product depth."
    - name: "futures_market_count"
      expr: COUNT(CASE WHEN is_futures_market = TRUE THEN 1 END)
      comment: "Number of futures markets open. Tracks long-duration liability concentration."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_responsible_gaming_limit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Responsible gaming limit adoption, change patterns, and compliance coverage metrics. Used by compliance, legal, and player-protection teams to demonstrate regulatory adherence and monitor at-risk player interventions."
  source: "`sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit`"
  dimensions:
    - name: "limit_type"
      expr: limit_type
      comment: "Type of responsible-gaming limit (deposit, loss, wager, session-time, etc.) for program coverage analysis."
    - name: "limit_period"
      expr: limit_period
      comment: "Period of the limit (daily, weekly, monthly) for limit-structure analysis."
    - name: "limit_status"
      expr: limit_status
      comment: "Current status of the limit (active, expired, revoked) for active-coverage monitoring."
    - name: "limit_source"
      expr: limit_source
      comment: "Source of the limit (player-initiated, operator-imposed, regulator-mandated) for compliance attribution."
    - name: "limit_change_direction"
      expr: limit_change_direction
      comment: "Direction of limit change (increase, decrease, new) to detect players loosening protections."
    - name: "interaction_channel"
      expr: interaction_channel
      comment: "Channel through which the limit was set (app, web, phone, retail) for UX and compliance analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the limit amount for multi-jurisdiction reporting."
    - name: "is_permanent"
      expr: is_permanent
      comment: "Flags permanent (irrevocable) limits vs temporary limits for compliance severity classification."
    - name: "regulatory_notification_sent"
      expr: regulatory_notification_sent
      comment: "Whether the regulator was notified of the limit change. Required for compliance audit trails."
    - name: "effective_month"
      expr: DATE_TRUNC('MONTH', effective_date)
      comment: "Month the limit became effective for trend analysis of responsible-gaming program adoption."
  measures:
    - name: "total_active_limits"
      expr: COUNT(CASE WHEN limit_status = 'active' THEN 1 END)
      comment: "Number of currently active responsible-gaming limits. Primary coverage KPI for compliance reporting."
    - name: "total_limits_set"
      expr: COUNT(1)
      comment: "Total responsible-gaming limits ever set. Measures cumulative program adoption."
    - name: "unique_players_with_limits"
      expr: COUNT(DISTINCT bettor_account_id)
      comment: "Number of distinct players with at least one responsible-gaming limit. Measures program reach."
    - name: "total_limit_amount"
      expr: SUM(CAST(limit_amount AS DOUBLE))
      comment: "Sum of all active limit amounts. Measures aggregate financial protection ceiling across the player base."
    - name: "avg_limit_amount"
      expr: AVG(CAST(limit_amount AS DOUBLE))
      comment: "Average limit amount per record. Indicates typical protection level set by or for players."
    - name: "limit_increase_count"
      expr: COUNT(CASE WHEN limit_change_direction = 'increase' THEN 1 END)
      comment: "Number of limit increases (players loosening protections). Regulatory red-flag metric requiring monitoring."
    - name: "permanent_limit_count"
      expr: COUNT(CASE WHEN is_permanent = TRUE THEN 1 END)
      comment: "Number of permanent irrevocable limits. Indicates severity of responsible-gaming interventions."
    - name: "regulatory_notification_pending_count"
      expr: COUNT(CASE WHEN regulatory_notification_sent = FALSE THEN 1 END)
      comment: "Limits where regulatory notification has not yet been sent. Compliance backlog and breach-risk indicator."
    - name: "avg_previous_limit_amount"
      expr: AVG(CAST(previous_limit_amount AS DOUBLE))
      comment: "Average previous limit amount before the most recent change. Used to quantify magnitude of limit adjustments."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_self_exclusion`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Self-exclusion program enrollment, breach, and reinstatement KPIs. Used by compliance, legal, and player-protection teams to demonstrate regulatory adherence and manage at-risk player populations."
  source: "`sports_entertainment_ecm`.`gaming`.`self_exclusion`"
  dimensions:
    - name: "exclusion_status"
      expr: exclusion_status
      comment: "Current status of the self-exclusion (active, expired, reinstated, breached) for program monitoring."
    - name: "exclusion_type"
      expr: exclusion_type
      comment: "Type of self-exclusion (voluntary, operator-imposed, state-list) for program-source analysis."
    - name: "exclusion_scope"
      expr: exclusion_scope
      comment: "Scope of exclusion (single operator, state-wide, national) for regulatory coverage analysis."
    - name: "election_channel"
      expr: election_channel
      comment: "Channel through which exclusion was elected (app, web, retail, phone) for UX and compliance analysis."
    - name: "initiated_by"
      expr: initiated_by
      comment: "Who initiated the exclusion (player, operator, regulator) for compliance attribution."
    - name: "is_permanent"
      expr: is_permanent
      comment: "Flags permanent self-exclusions for severity classification and irrevocable-status tracking."
    - name: "ncpg_list_match_flag"
      expr: ncpg_list_match_flag
      comment: "Indicates match against the National Council on Problem Gambling exclusion list."
    - name: "state_exclusion_list_match_flag"
      expr: state_exclusion_list_match_flag
      comment: "Indicates match against a state self-exclusion registry. Critical for regulatory compliance."
    - name: "reinstatement_approval_status"
      expr: reinstatement_approval_status
      comment: "Status of reinstatement requests for managing re-entry into the platform."
    - name: "exclusion_start_month"
      expr: DATE_TRUNC('MONTH', exclusion_start_date)
      comment: "Month self-exclusion began for trend analysis of enrollment rates."
    - name: "regulatory_notification_status"
      expr: regulatory_notification_status
      comment: "Status of regulatory notification for the exclusion. Required for compliance audit."
  measures:
    - name: "total_self_exclusions"
      expr: COUNT(1)
      comment: "Total self-exclusion enrollments. Primary responsible-gaming program volume metric."
    - name: "active_self_exclusions"
      expr: COUNT(CASE WHEN exclusion_status = 'active' THEN 1 END)
      comment: "Currently active self-exclusions. Measures live excluded player population for compliance reporting."
    - name: "permanent_self_exclusions"
      expr: COUNT(CASE WHEN is_permanent = TRUE THEN 1 END)
      comment: "Number of permanent self-exclusions. Indicates most severe responsible-gaming interventions."
    - name: "state_list_matched_exclusions"
      expr: COUNT(CASE WHEN state_exclusion_list_match_flag = TRUE THEN 1 END)
      comment: "Exclusions matched against state exclusion registries. Regulatory compliance coverage metric."
    - name: "ncpg_list_matched_exclusions"
      expr: COUNT(CASE WHEN ncpg_list_match_flag = TRUE THEN 1 END)
      comment: "Exclusions matched against the NCPG national problem gambling list. Problem-gambling severity indicator."
    - name: "total_pending_balance_at_exclusion"
      expr: SUM(CAST(pending_balance_amount AS DOUBLE))
      comment: "Total player balances pending disposition at time of self-exclusion. Measures financial liability from exclusions."
    - name: "avg_pending_balance_at_exclusion"
      expr: AVG(CAST(pending_balance_amount AS DOUBLE))
      comment: "Average pending balance per self-excluded account. Indicates typical financial exposure per exclusion event."
    - name: "reinstatement_requests"
      expr: COUNT(CASE WHEN reinstatement_request_date IS NOT NULL THEN 1 END)
      comment: "Number of reinstatement requests submitted. Measures re-entry demand and cooling-off period compliance."
    - name: "unique_excluded_players"
      expr: COUNT(DISTINCT bettor_account_id)
      comment: "Count of distinct players with self-exclusion records. Measures breadth of the excluded population."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_regulatory_report`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Regulatory filing compliance, GGR tax reporting, and AML/SAR submission KPIs. Used by compliance, legal, and finance leadership to manage regulatory obligations and filing timeliness."
  source: "`sports_entertainment_ecm`.`gaming`.`regulatory_report`"
  dimensions:
    - name: "report_type"
      expr: report_type
      comment: "Type of regulatory report (GGR, AML, SAR, self-exclusion, etc.) for obligation-category analysis."
    - name: "report_status"
      expr: report_status
      comment: "Current filing status (draft, submitted, accepted, rejected, amended) for pipeline monitoring."
    - name: "report_frequency"
      expr: report_frequency
      comment: "Reporting cadence (daily, monthly, quarterly, annual) for scheduling and workload planning."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of reported financial amounts for multi-jurisdiction financial reporting."
    - name: "is_amended"
      expr: is_amended
      comment: "Flags amended reports. High amendment rates indicate data quality or process issues."
    - name: "is_late_filing"
      expr: is_late_filing
      comment: "Flags reports filed after the regulatory deadline. Key compliance risk indicator."
    - name: "sport_category"
      expr: sport_category
      comment: "Sport category covered by the report for sport-level regulatory attribution."
    - name: "submission_channel"
      expr: submission_channel
      comment: "Channel used to submit the report (portal, API, email) for process efficiency analysis."
    - name: "reporting_period_month"
      expr: DATE_TRUNC('MONTH', reporting_period_start_date)
      comment: "Reporting period start month for period-over-period compliance trend analysis."
  measures:
    - name: "total_reports_filed"
      expr: COUNT(1)
      comment: "Total regulatory reports filed. Baseline compliance activity volume metric."
    - name: "late_filing_count"
      expr: COUNT(CASE WHEN is_late_filing = TRUE THEN 1 END)
      comment: "Number of reports filed after the regulatory deadline. Primary compliance risk KPI."
    - name: "amended_report_count"
      expr: COUNT(CASE WHEN is_amended = TRUE THEN 1 END)
      comment: "Number of amended filings. Elevated amendment rates signal data quality or process failures."
    - name: "total_reported_ggr"
      expr: SUM(CAST(ggr_amount AS DOUBLE))
      comment: "Total Gross Gaming Revenue reported to regulators. Primary tax base and regulatory revenue metric."
    - name: "total_reported_tax"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amounts reported and remitted. Required for regulatory tax compliance verification."
    - name: "total_reported_wagers"
      expr: SUM(CAST(total_wagers_amount AS DOUBLE))
      comment: "Total wagering handle reported to regulators. Used to verify operator-reported vs actual handle."
    - name: "total_reported_winnings_paid"
      expr: SUM(CAST(total_winnings_paid_amount AS DOUBLE))
      comment: "Total winnings paid as reported to regulators. Used to reconcile GGR calculations."
    - name: "total_aml_flagged_transactions"
      expr: SUM(CAST(aml_flagged_transaction_count AS DOUBLE))
      comment: "Total AML-flagged transactions reported across all filings. Measures AML risk exposure volume."
    - name: "total_sar_count"
      expr: SUM(CAST(sar_count AS DOUBLE))
      comment: "Total Suspicious Activity Reports filed. Key AML compliance output metric."
    - name: "total_self_exclusion_breaches"
      expr: SUM(CAST(self_exclusion_breach_count AS DOUBLE))
      comment: "Total self-exclusion breaches reported. Critical responsible-gaming compliance failure indicator."
    - name: "avg_ggr_per_report"
      expr: AVG(CAST(ggr_amount AS DOUBLE))
      comment: "Average GGR per regulatory report period. Used for period-over-period revenue benchmarking."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_wallet`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Player wallet balance, deposit/withdrawal lifecycle, and AML risk KPIs. Used by finance, treasury, and compliance teams to manage player fund liability, dormancy, and financial risk."
  source: "`sports_entertainment_ecm`.`gaming`.`wallet`"
  dimensions:
    - name: "wallet_status"
      expr: wallet_status
      comment: "Current wallet status (active, frozen, closed, dormant) for fund liability management."
    - name: "wallet_type"
      expr: wallet_type
      comment: "Type of wallet (real-money, bonus, tournament) for balance-type segmentation."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the wallet for multi-currency treasury reporting."
    - name: "aml_risk_rating"
      expr: aml_risk_rating
      comment: "AML risk classification of the wallet (low, medium, high) for compliance risk segmentation."
    - name: "kyc_verified_flag"
      expr: kyc_verified_flag
      comment: "KYC verification status of the wallet. Regulatory requirement for fund access."
    - name: "self_exclusion_flag"
      expr: self_exclusion_flag
      comment: "Flags wallets belonging to self-excluded players. Used to enforce fund-hold obligations."
    - name: "dormancy_flag"
      expr: dormancy_flag
      comment: "Flags dormant wallets for unclaimed-funds regulatory reporting and escheatment."
    - name: "tax_withholding_flag"
      expr: tax_withholding_flag
      comment: "Indicates wallets subject to tax withholding for tax compliance segmentation."
    - name: "geolocation_compliance_flag"
      expr: geolocation_compliance_flag
      comment: "Geolocation compliance status of the wallet for jurisdiction-enforcement monitoring."
    - name: "open_month"
      expr: DATE_TRUNC('MONTH', open_date)
      comment: "Month the wallet was opened for cohort-based balance and activity analysis."
  measures:
    - name: "total_real_money_balance"
      expr: SUM(CAST(real_money_balance AS DOUBLE))
      comment: "Total real-money balance held across all wallets. Primary player fund liability metric for treasury."
    - name: "total_bonus_credit_balance"
      expr: SUM(CAST(bonus_credit_balance AS DOUBLE))
      comment: "Total bonus credit balance outstanding. Measures promotional liability on the balance sheet."
    - name: "total_withdrawable_balance"
      expr: SUM(CAST(withdrawable_balance AS DOUBLE))
      comment: "Total funds available for withdrawal. Measures immediate cash-out liability."
    - name: "total_pending_hold"
      expr: SUM(CAST(pending_hold_amount AS DOUBLE))
      comment: "Total funds on hold pending settlement or compliance review. Measures operational float."
    - name: "total_lifetime_deposits"
      expr: SUM(CAST(lifetime_deposit_amount AS DOUBLE))
      comment: "Cumulative lifetime deposits across all wallets. Measures total player funding inflow."
    - name: "total_lifetime_withdrawals"
      expr: SUM(CAST(lifetime_withdrawal_amount AS DOUBLE))
      comment: "Cumulative lifetime withdrawals across all wallets. Measures total player cash-out outflow."
    - name: "total_lifetime_bonus_awarded"
      expr: SUM(CAST(lifetime_bonus_awarded_amount AS DOUBLE))
      comment: "Total bonus credits ever awarded across all wallets. Measures cumulative promotional investment."
    - name: "avg_real_money_balance"
      expr: AVG(CAST(real_money_balance AS DOUBLE))
      comment: "Average real-money balance per wallet. Indicates player funding depth and engagement level."
    - name: "dormant_wallet_count"
      expr: COUNT(CASE WHEN dormancy_flag = TRUE THEN 1 END)
      comment: "Number of dormant wallets. Drives unclaimed-funds escheatment obligations and regulatory reporting."
    - name: "self_excluded_wallet_balance"
      expr: SUM(CASE WHEN self_exclusion_flag = TRUE THEN CAST(real_money_balance AS DOUBLE) ELSE 0.0 END)
      comment: "Total real-money balance held in self-excluded wallets. Measures fund-hold liability from exclusions."
    - name: "high_aml_risk_wallet_count"
      expr: COUNT(CASE WHEN aml_risk_rating = 'high' THEN 1 END)
      comment: "Number of wallets classified as high AML risk. Key financial crime compliance KPI."
    - name: "wallet_count"
      expr: COUNT(1)
      comment: "Total number of wallets. Baseline metric for player fund account population."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_odds_feed`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Odds feed quality, integrity, and pricing KPIs. Used by trading, technology, and integrity teams to monitor feed latency, suspension rates, integrity alerts, and implied probability accuracy."
  source: "`sports_entertainment_ecm`.`gaming`.`odds_feed`"
  dimensions:
    - name: "feed_status"
      expr: feed_status
      comment: "Current status of the odds feed record (active, suspended, resulted, superseded) for feed health monitoring."
    - name: "feed_source_name"
      expr: feed_source_name
      comment: "Name of the odds data provider for vendor performance benchmarking."
    - name: "market_type"
      expr: market_type
      comment: "Type of market covered by the odds feed for product-line pricing analysis."
    - name: "sport_code"
      expr: sport_code
      comment: "Sport associated with the odds feed for sport-level pricing and integrity analysis."
    - name: "odds_format"
      expr: odds_format
      comment: "Format of odds published (American, Decimal, Fractional) for regional market analysis."
    - name: "is_in_play"
      expr: is_in_play
      comment: "Distinguishes in-play odds updates from pre-match odds for live-betting feed analysis."
    - name: "is_suspended"
      expr: is_suspended
      comment: "Flags suspended odds records. High suspension rates indicate feed quality or integrity issues."
    - name: "integrity_alert_flag"
      expr: integrity_alert_flag
      comment: "Flags odds records triggering integrity alerts. Used for match-fixing and suspicious movement detection."
    - name: "line_movement_direction"
      expr: line_movement_direction
      comment: "Direction of odds movement (shortening, drifting, stable) for sharp-money and steam-move analysis."
    - name: "jurisdiction_code"
      expr: jurisdiction_code
      comment: "Jurisdiction for which the odds were published for regulatory compliance analysis."
    - name: "feed_date"
      expr: DATE_TRUNC('DAY', received_timestamp)
      comment: "Day the odds feed record was received for daily feed volume and quality trend analysis."
  measures:
    - name: "total_odds_updates"
      expr: COUNT(1)
      comment: "Total odds feed updates received. Baseline feed throughput and activity metric."
    - name: "integrity_alert_count"
      expr: COUNT(CASE WHEN integrity_alert_flag = TRUE THEN 1 END)
      comment: "Number of odds updates triggering integrity alerts. Primary match-integrity risk KPI."
    - name: "suspended_odds_count"
      expr: COUNT(CASE WHEN is_suspended = TRUE THEN 1 END)
      comment: "Number of suspended odds records. High rates indicate feed instability or integrity concerns."
    - name: "avg_implied_probability"
      expr: AVG(CAST(implied_probability AS DOUBLE))
      comment: "Average implied probability across odds records. Used to assess overround and pricing efficiency."
    - name: "avg_overround_pct"
      expr: AVG(CAST(overround_pct AS DOUBLE))
      comment: "Average overround (book margin) percentage. Key pricing profitability and competitiveness KPI."
    - name: "avg_decimal_odds"
      expr: AVG(CAST(decimal_odds AS DOUBLE))
      comment: "Average decimal odds across all feed records. Indicates average price level offered to bettors."
    - name: "avg_odds_movement"
      expr: AVG(CAST(decimal_odds AS DOUBLE) - CAST(previous_decimal_odds AS DOUBLE))
      comment: "Average magnitude of odds movement per update. Measures market volatility and line-movement intensity."
    - name: "unique_markets_priced"
      expr: COUNT(DISTINCT betting_market_id)
      comment: "Number of distinct betting markets receiving odds updates. Measures pricing coverage breadth."
    - name: "price_boost_count"
      expr: COUNT(CASE WHEN price_boost_indicator = TRUE THEN 1 END)
      comment: "Number of price-boosted odds records. Measures promotional pricing activity and associated margin cost."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`gaming_fantasy_team`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fantasy team performance, engagement, and competitive standing KPIs. Used by DFS product and league operations teams to monitor team activity, scoring, and playoff qualification rates."
  source: "`sports_entertainment_ecm`.`gaming`.`fantasy_team`"
  dimensions:
    - name: "team_status"
      expr: team_status
      comment: "Current status of the fantasy team (active, inactive, abandoned) for engagement segmentation."
    - name: "sport_type"
      expr: sport_type
      comment: "Sport associated with the fantasy team for sport-level product analysis."
    - name: "draft_type"
      expr: draft_type
      comment: "Draft format used (snake, auction, autopick) for product-preference analysis."
    - name: "playoff_qualified"
      expr: playoff_qualified
      comment: "Whether the team qualified for playoffs. Used to measure competitive engagement depth."
    - name: "autopick_enabled"
      expr: autopick_enabled
      comment: "Flags teams using autopick for engagement quality segmentation."
    - name: "jurisdiction_code"
      expr: jurisdiction_code
      comment: "Jurisdiction of the fantasy team for regulatory compliance reporting."
    - name: "registration_month"
      expr: DATE_TRUNC('MONTH', registration_date)
      comment: "Month of team registration for cohort-based acquisition and retention analysis."
    - name: "responsible_gaming_flag"
      expr: responsible_gaming_flag
      comment: "Teams flagged under responsible-gaming controls for compliance monitoring."
  measures:
    - name: "total_teams"
      expr: COUNT(1)
      comment: "Total fantasy teams registered. Baseline DFS league participation metric."
    - name: "playoff_qualified_teams"
      expr: COUNT(CASE WHEN playoff_qualified = TRUE THEN 1 END)
      comment: "Number of teams that qualified for playoffs. Measures competitive engagement and league health."
    - name: "total_points_scored"
      expr: SUM(CAST(points_scored AS DOUBLE))
      comment: "Total fantasy points scored across all teams. Measures overall scoring volume and league activity."
    - name: "avg_points_scored"
      expr: AVG(CAST(points_scored AS DOUBLE))
      comment: "Average fantasy points scored per team. Benchmarks competitive scoring level across the league."
    - name: "total_auction_budget_spent"
      expr: SUM(CAST(auction_budget_spent AS DOUBLE))
      comment: "Total auction budget spent across all teams. Measures player valuation activity in auction leagues."
    - name: "avg_faab_remaining"
      expr: AVG(CAST(faab_remaining AS DOUBLE))
      comment: "Average free-agent acquisition budget remaining. Indicates mid-season roster management activity."
    - name: "total_trades_accepted"
      expr: SUM(CAST(trades_accepted AS DOUBLE))
      comment: "Total trades accepted across all teams. Measures trade market activity and league engagement depth."
    - name: "unique_managers"
      expr: COUNT(DISTINCT bettor_account_id)
      comment: "Count of distinct fantasy team managers. Measures unique player participation in fantasy leagues."
$$;
