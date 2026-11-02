-- Schema for Domain: gaming | Business: Sports Entertainment | Version: v1_mvm
-- Generated on: 2026-05-09 04:52:10

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `sports_entertainment_ecm`.`gaming` COMMENT 'Sports wagering and fantasy sports domain managing betting market definitions, odds feeds, responsible gaming compliance, fantasy league structures, prop bet catalogs, and regulatory reporting for licensed gaming operations across jurisdictions.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` (
    `betting_market_id` BIGINT COMMENT 'Unique surrogate identifier for each wagering market definition in the master catalog. Primary key for the betting_market data product.',
    `broadcast_schedule_id` BIGINT COMMENT 'Foreign key linking to broadcast.broadcast_schedule. Business justification: Betting market lifecycle (open/suspend/close) is operationally tied to broadcast schedule windows. In-play markets must open at broadcast start and close at broadcast end. Integrity teams correlate ma',
    `competition_round_id` BIGINT COMMENT 'Foreign key linking to event.competition_round. Business justification: Round-level betting markets (e.g., Top scorer in Round 5, Most wins in Conference Semis) require competition_round reference for market creation, settlement scheduling, and broadcast window alignm',
    `franchise_id` BIGINT COMMENT 'Foreign key linking to league.franchise. Business justification: Team win-total, division-winner, and moneyline markets are created per franchise. A franchise_id FK enables integrity monitoring scoped to a franchise, settlement against franchise outcomes, and regul',
    `league_id` BIGINT COMMENT 'Foreign key linking to league.league. Business justification: Betting markets are categorized and regulated by league for integrity monitoring, regulatory reporting, and market segmentation. The existing league_code plain attribute is a denormalized representati',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: Futures and season-win-total betting markets must be scoped to a specific league season for settlement, regulatory period reporting, and GGR accounting. A sports-entertainment operator would always ti',
    `match_result_id` BIGINT COMMENT 'Foreign key linking to event.match_result. Business justification: Betting market settlement — the core sportsbook operation — requires resolving each market against the official confirmed match_result. Automated settlement pipelines and integrity audit trails univer',
    `parent_betting_market_id` BIGINT COMMENT 'Self-referencing FK on betting_market (parent_betting_market_id)',
    `playoff_bracket_id` BIGINT COMMENT 'Foreign key linking to league.playoff_bracket. Business justification: Futures markets for bracket outcomes (conference champion, championship winner, bracket round winners) must reference the specific playoff bracket for settlement. Playoff bracket betting is a major re',
    `fixture_id` BIGINT COMMENT 'Reference to the specific sports or entertainment event this market is associated with. Links the market definition to the event scheduling and planning domain for settlement and reporting.',
    `rights_window_id` BIGINT COMMENT 'Foreign key linking to broadcast.broadcast_rights_window. Business justification: In-play betting markets must open and close within active broadcast rights windows. Market scheduling operations require this link to enforce that live wagering is only offered during licensed broadca',
    `tournament_id` BIGINT COMMENT 'Foreign key linking to event.tournament. Business justification: Futures markets (Who wins the Champions League?, Tournament MVP) are scoped to a tournament. Settlement of futures requires tournament_id to determine the winner and trigger payouts. is_futures_ma',
    `age_verification_required` BOOLEAN COMMENT 'Indicates whether bettors must complete age verification before placing wagers on this market. True = age verification mandatory; False = standard KYC suffices. Driven by jurisdiction-specific regulatory requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this betting market definition record was first created in the system. Used for audit trail, data lineage, and regulatory compliance reporting.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which stake limits, payouts, and odds are denominated for this market (e.g., USD, GBP, EUR). Required for multi-jurisdiction operations.. Valid values are `^[A-Z]{3}$`',
    `display_order` STRING COMMENT 'Numeric ordering value controlling the sequence in which this market is presented within its market category on betting interfaces and odds feeds. Lower values appear first. Supports merchandising and fan engagement optimization.',
    `effective_from_date` DATE COMMENT 'The date from which this version of the market definition is valid and operative. Used for temporal validity tracking of market parameters across version changes.',
    `effective_until_date` DATE COMMENT 'The date until which this version of the market definition remains valid. Null for the current active version. Enables point-in-time reconstruction of market parameters for regulatory audit and dispute resolution.',
    `is_featured` BOOLEAN COMMENT 'Indicates whether this market is designated as a featured/promoted wagering product for enhanced placement in betting interfaces, marketing campaigns, and fan engagement platforms. True = featured; False = standard placement.',
    `is_futures_market` BOOLEAN COMMENT 'Indicates whether this market is a futures wagering product where the outcome is determined at a future date (e.g., season champion, award winner). True = futures market; False = event-specific market. Affects settlement timeline and liability reporting.',
    `is_live_inplay` BOOLEAN COMMENT 'Indicates whether this market is offered as a live in-play (in-game) wagering product where odds update in real time during the event. True = live in-play market; False = pre-game market. Drives real-time odds feed routing and latency SLA requirements.',
    `is_parlay_eligible` BOOLEAN COMMENT 'Indicates whether this market can be combined into a parlay or teaser multi-leg wager. True = eligible for parlay inclusion; False = must be wagered as a standalone market. Governs parlay construction rules in the betting platform.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this betting market definition record was most recently modified. Tracks changes to market parameters, status transitions, and settlement updates for audit and compliance purposes.',
    `margin_percentage` DECIMAL(18,2) COMMENT 'The operators built-in margin (overround/vig) applied to this market, expressed as a decimal percentage (e.g., 0.0500 = 5%). Represents the house edge embedded in the odds. Confidential commercial data used for profitability analysis and pricing strategy.',
    `market_category` STRING COMMENT 'High-level grouping of the market by scope: Game = single-game outcome; Season = full-season result (e.g., division winner); Tournament = multi-round competition outcome; Player = individual athlete performance; Team = team-level statistic; Entertainment = non-sport event (e.g., awards show outcome).. Valid values are `game|season|tournament|player|team|entertainment`',
    `market_close_timestamp` TIMESTAMP COMMENT 'Date and time when this wagering market was closed and no further wagers were accepted. For pre-game markets this is typically event start time; for live markets it is the point of suspension or event conclusion.',
    `market_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying this market definition across odds feeds, prop bet catalogs, and regulatory reporting systems. Used as the business key in downstream integrations.. Valid values are `^[A-Z0-9_]{3,30}$`',
    `market_name` STRING COMMENT 'Human-readable display name for the wagering market as presented to bettors and operators (e.g., NFL Week 5 Moneyline - Chiefs vs Raiders, NBA Finals Game 1 Total Points Over/Under).',
    `market_open_timestamp` TIMESTAMP COMMENT 'Date and time when this wagering market was first opened and made available for bet placement. Used for audit trails, regulatory reporting, and market lifecycle analytics.',
    `market_source_feed` STRING COMMENT 'Identifier of the external odds feed provider or internal pricing engine that originates the market definition and odds for this market (e.g., SPORTRADAR, GENIUS_SPORTS, INTERNAL_TRADING). Supports feed reconciliation and SLA monitoring.',
    `market_status` STRING COMMENT 'Current operational lifecycle state of the wagering market. Open = accepting wagers; Suspended = temporarily halted (e.g., injury news, VAR review); Closed = no longer accepting wagers; Settled = outcome determined and payouts processed; Voided = market cancelled with stakes returned; Pending = awaiting activation.. Valid values are `open|suspended|closed|settled|voided|pending`',
    `market_type_code` STRING COMMENT 'Classification of the wagering market structure. Moneyline = straight win/loss; Spread = point spread handicap; Total = over/under aggregate score; Futures = outcome of future event; Parlay = multi-leg combined bet; Teaser = adjusted spread/total parlay; Prop = proposition/player-specific bet; Live In-Play = real-time in-game market. [ENUM-REF-CANDIDATE: moneyline|spread|total|futures|parlay|teaser|prop|live_inplay — 8 candidates stripped; promote to reference product]',
    `max_liability_amount` DECIMAL(18,2) COMMENT 'Maximum total financial exposure the operator accepts across all wagers on this market before triggering automatic suspension or odds adjustment. Expressed in the operating currency. Confidential risk management parameter.',
    `max_payout_amount` DECIMAL(18,2) COMMENT 'Maximum total payout the operator will honor for a single winning wager on this market, expressed in the operating currency. Caps operator liability for high-odds outcomes.',
    `max_stake_amount` DECIMAL(18,2) COMMENT 'Maximum wager amount permitted on this market per bet placement, expressed in the operating currency. Enforced to manage operator liability exposure and comply with responsible gaming limits.',
    `min_stake_amount` DECIMAL(18,2) COMMENT 'Minimum wager amount permitted on this market per bet placement, expressed in the operating currency. Enforced at point-of-sale to comply with operator risk management and regulatory minimums.',
    `notes` STRING COMMENT 'Free-text operational notes recorded by trading or compliance staff regarding special conditions, exceptions, or context for this market (e.g., Suspended pending VAR review, TMO decision pending). Not displayed to bettors.',
    `odds_format` STRING COMMENT 'Default odds presentation format for this market. American = moneyline (+/-); Decimal = European multiplier; Fractional = UK traditional; Hong Kong/Indonesian/Malay = regional formats. Drives display logic in betting interfaces and odds feeds.. Valid values are `american|decimal|fractional|hong_kong|indonesian|malay`',
    `prop_bet_category` STRING COMMENT 'For proposition (prop) bet markets, classifies the type of proposition: Player Performance = individual athlete stat (e.g., passing yards, points scored); Team Statistic = team-level metric; Game Event = specific in-game occurrence (e.g., first score method); Entertainment = non-sport proposition; None = not a prop bet market.. Valid values are `player_performance|team_statistic|game_event|entertainment|none`',
    `regulatory_market_code` STRING COMMENT 'The market identifier assigned by the relevant gaming regulatory authority for official reporting and audit purposes. Required for regulatory filings in licensed jurisdictions. May differ from internal market_code.',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this market has been flagged for enhanced responsible gaming controls (e.g., lower stake limits, mandatory cooling-off prompts, exclusion from promotional offers). True = enhanced controls active; False = standard controls apply.',
    `season_year` STRING COMMENT 'The calendar year of the sports season to which this market belongs (e.g., 2024 for the 2024-25 NBA season). Used for futures markets and season-long wagering products.',
    `settlement_outcome` STRING COMMENT 'The official result used to settle this market (e.g., HOME_WIN, OVER, PLAYER_A, PUSH). Populated after event conclusion and official score confirmation. Null until market is settled. [ENUM-REF-CANDIDATE: HOME_WIN|AWAY_WIN|DRAW|OVER|UNDER|PUSH|VOID|CANCELLED — promote to reference product]',
    `settlement_rule_code` STRING COMMENT 'Code referencing the official settlement rule set applied to determine winning outcomes for this market (e.g., REGULATION_TIME_ONLY, INCLUDING_OT, OFFICIAL_SCORE_AT_CLOSE). Governs how and when the market is settled post-event.. Valid values are `^[A-Z0-9_]{3,40}$`',
    `settlement_rule_description` STRING COMMENT 'Plain-language description of the settlement rules for this market, including conditions for void, push, or partial settlement. Displayed to bettors and referenced in regulatory filings.',
    `settlement_timestamp` TIMESTAMP COMMENT 'Date and time when the market outcome was officially determined and winning wagers were settled. Null if market is not yet settled. Critical for financial reconciliation and regulatory reporting.',
    `sport_code` STRING COMMENT 'Standardized code identifying the sport to which this market applies (e.g., NFL, NBA, MLB, NHL, MLS, UFC, ATP). Scopes the market to the relevant league or governing body.. Valid values are `^[A-Z]{2,10}$`',
    `spread_value` DECIMAL(18,2) COMMENT 'The handicap value applied to the favored team or participant in a spread market (e.g., -3.5 means the favorite must win by more than 3.5 points). Null for non-spread market types.',
    `total_line_value` DECIMAL(18,2) COMMENT 'The aggregate score or statistical threshold set for an over/under (totals) market (e.g., 47.5 total points in an NFL game). Bettors wager on whether the actual result exceeds or falls below this value. Null for non-totals market types.',
    `version_number` STRING COMMENT 'Incremental version counter for this market definition record. Incremented each time material changes are made to market parameters (e.g., spread adjustment, limit change). Supports change history tracking and regulatory audit requirements.',
    CONSTRAINT pk_betting_market PRIMARY KEY(`betting_market_id`)
) COMMENT 'Master catalog of all wagering market definitions available across sports and entertainment events — covering moneyline, spread, totals (over/under), futures, parlays, teasers, and live in-play markets. Captures market type code, sport/league scope, settlement rules, market status (open, suspended, closed, settled), minimum/maximum stake limits, and jurisdiction availability flags. SSOT for all market definitions consumed by odds feeds, prop bet catalogs, and regulatory reporting.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` (
    `odds_feed_id` BIGINT COMMENT 'Unique surrogate identifier for each odds feed record in the Silver layer lakehouse. Primary key for the odds_feed data product.',
    `betting_market_id` BIGINT COMMENT 'Reference to the betting market for which this odds update applies. Links to the market definition product in the gaming domain.',
    `league_schedule_id` BIGINT COMMENT 'Foreign key linking to league.league_schedule. Business justification: Odds feeds are published for specific scheduled games. Linking to league_schedule enables feed suspension on postponement, scheduling-status-driven feed management, and integrity monitoring tied to th',
    `live_feed_id` BIGINT COMMENT 'Foreign key linking to broadcast.live_feed. Business justification: In-play odds feeds are synchronized with live broadcast feeds — the same live signal drives both broadcast delivery and odds data ingestion. Sports integrity monitoring requires correlating odds movem',
    `match_result_id` BIGINT COMMENT 'Foreign key linking to event.match_result. Business justification: Post-match, odds_feed records are resulted and archived against the official match_result. Settlement reconciliation and integrity monitoring (detecting pre-result odds manipulation) require this dire',
    `media_rights_deal_id` BIGINT COMMENT 'Foreign key linking to broadcast.media_rights_deal. Business justification: Official data mandate compliance: in-play odds feeds must be sourced from and validated against the governing media rights deal. Regulators in many jurisdictions require official data provenance. A ga',
    `fixture_id` BIGINT COMMENT 'Reference to the sporting event (fixture or competition) to which this odds feed record is associated.',
    `scoring_event_id` BIGINT COMMENT 'Foreign key linking to event.scoring_event. Business justification: Live in-play odds feeds are triggered and repriced by scoring events. Integrity monitoring requires correlating odds movements with specific scoring_event timestamps to detect suspicious pre-event odd',
    `selection_id` BIGINT COMMENT 'Reference to the specific selection (outcome) within the betting market for which odds are being updated (e.g., Team A to win, Over 2.5 goals).',
    `superseded_odds_feed_id` BIGINT COMMENT 'Self-referencing FK on odds_feed (superseded_odds_feed_id)',
    `american_odds` STRING COMMENT 'The odds expressed in American moneyline format. Positive values (e.g., +150) indicate profit on a $100 stake; negative values (e.g., -200) indicate the stake required to win $100. Standard format for US sports wagering markets.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this odds feed record was first persisted in the Silver layer lakehouse. Used for data lineage and audit trail.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to stake and payout amounts for this odds feed record (e.g., USD, GBP, EUR). Supports multi-currency operations across global jurisdictions.. Valid values are `^[A-Z]{3}$`',
    `decimal_odds` DECIMAL(18,2) COMMENT 'The odds expressed in decimal format (European format), representing the total payout per unit staked including the stake (e.g., 2.500000 means a $1 bet returns $2.50). Widely used in European and international markets.',
    `feed_channel` STRING COMMENT 'The technical delivery channel through which this odds update was received from the provider. Supports feed reliability monitoring and SLA compliance tracking.. Valid values are `api_push|api_pull|websocket|file_feed|manual`',
    `feed_latency_ms` STRING COMMENT 'The measured latency in milliseconds between the provider_published_timestamp and the received_timestamp for this odds update. Used for SLA monitoring, provider performance benchmarking, and real-time display quality assurance.',
    `feed_reference_code` STRING COMMENT 'Externally-known unique identifier assigned by the odds provider for this specific odds update message. Used for deduplication, reconciliation, and audit trail against the providers own records.. Valid values are `^[A-Z0-9_-]{4,64}$`',
    `feed_source_name` STRING COMMENT 'Human-readable name of the odds data provider or compiler that supplied this update (e.g., Sportradar, Kambi, Genius Sports, SBTech). Used for provider performance monitoring and SLA tracking.',
    `feed_status` STRING COMMENT 'Current lifecycle status of this odds feed record. active indicates odds are live and tradeable; suspended indicates trading is paused; settled indicates the market has been resolved; cancelled or void indicates the record is no longer valid. [ENUM-REF-CANDIDATE: active|suspended|settled|cancelled|resulted|void — promote to reference product]. Valid values are `active|suspended|settled|cancelled|resulted|void`',
    `feed_version` STRING COMMENT 'Version identifier of the odds feed protocol or API specification used by the provider for this update. Supports backward compatibility management and feed migration tracking.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    `fractional_odds_denominator` STRING COMMENT 'The denominator component of fractional odds (UK format), representing the stake unit (e.g., denominator 1 in 3/1 means $1 staked). Combined with numerator to express the full fractional odds.',
    `fractional_odds_numerator` STRING COMMENT 'The numerator component of fractional odds (UK format), representing the profit relative to the denominator stake (e.g., numerator 3 in 3/1 means $3 profit per $1 staked). Used in UK and Irish markets.',
    `handicap_value` DECIMAL(18,2) COMMENT 'The handicap or point spread value associated with this selection, where applicable (e.g., -1.5 goals, +3.5 points). Null for non-handicap markets. Essential for Asian handicap, European handicap, and point spread markets.',
    `implied_probability` DECIMAL(18,2) COMMENT 'The probability of the selection winning as implied by the current odds, expressed as a decimal between 0 and 1 (e.g., 0.400000 = 40%). Derived from decimal odds as 1/decimal_odds before margin adjustment. Used for overround analysis and pricing analytics.',
    `integrity_alert_flag` BOOLEAN COMMENT 'Indicates whether this odds update has triggered a betting integrity alert (True), such as suspicious line movement that may indicate match-fixing or insider information. Supports regulatory reporting obligations to governing bodies (FIFA, NFL, NBA, etc.).',
    `is_in_play` BOOLEAN COMMENT 'Indicates whether this odds update relates to an in-play (live) betting market where the event is already in progress (True), or a pre-match market (False). In-play markets have different regulatory requirements and risk profiles.',
    `is_resulted` BOOLEAN COMMENT 'Indicates whether the betting market has been officially resulted/settled (True) or is still open/pending (False). A resulted market has a confirmed outcome and all bets have been settled.',
    `is_suspended` BOOLEAN COMMENT 'Indicates whether the betting market was suspended at the time of this odds update (True = suspended, False = tradeable). Suspension may be triggered by significant events (e.g., red card, injury, VAR review, TMO decision) or risk management actions.',
    `jurisdiction_code` STRING COMMENT 'ISO 3166-1 alpha-2 or alpha-3 country/state code identifying the regulatory jurisdiction under which this odds feed record is governed. Critical for jurisdiction-specific compliance, licensing, and regulatory reporting (e.g., US state-level gaming regulations, GDPR for EU).. Valid values are `^[A-Z]{2,3}$`',
    `line_movement_direction` STRING COMMENT 'Indicates the direction of the odds movement relative to the previous update for this selection. up means odds lengthened (selection less favoured); down means odds shortened (selection more favoured); unchanged means no movement; open is the first price; close is the final price before event start.. Valid values are `up|down|unchanged|open|close`',
    `market_type` STRING COMMENT 'Classification of the betting market type for this odds update (e.g., match_result, over_under, handicap, first_goalscorer, prop_bet, futures, outright). Supports market-level analytics and regulatory reporting segmentation. [ENUM-REF-CANDIDATE: match_result|over_under|handicap|first_goalscorer|prop_bet|futures|outright — promote to reference product]',
    `max_stake_amount` DECIMAL(18,2) COMMENT 'The maximum single bet stake permitted on this selection at the time of this odds update, in the operating currency. Reflects risk management limits set by the trading desk. Confidential as it reveals internal risk appetite.',
    `min_stake_amount` DECIMAL(18,2) COMMENT 'The minimum single bet stake permitted on this selection at the time of this odds update, in the operating currency. Enforced at point of bet acceptance.',
    `odds_format` STRING COMMENT 'The primary odds format in which this update was received from the provider. Determines which odds value field is the authoritative source. [ENUM-REF-CANDIDATE: decimal|fractional|american|hongkong|malay|indonesian — promote to reference product]. Valid values are `decimal|fractional|american|hongkong|malay|indonesian`',
    `overround_pct` DECIMAL(18,2) COMMENT 'The bookmakers margin (vigorish/vig) expressed as a percentage, calculated as the sum of all implied probabilities for a market minus 100%. Represents the theoretical profit margin built into the odds. Used for pricing analytics and margin monitoring.',
    `previous_decimal_odds` DECIMAL(18,2) COMMENT 'The decimal odds value from the immediately preceding odds update for this selection and market. Enables line movement magnitude calculation and trend analysis without requiring a self-join.',
    `price_boost_indicator` BOOLEAN COMMENT 'Indicates whether the odds for this selection have been artificially enhanced as part of a promotional price boost offer (True) or reflect standard market pricing (False). Price boosts are a common fan engagement and DTC acquisition tool.',
    `provider_published_timestamp` TIMESTAMP COMMENT 'The date and time at which the odds provider published or generated this odds update on their end. Used to calculate feed latency (received_timestamp minus provider_published_timestamp) and for regulatory audit trails.',
    `received_timestamp` TIMESTAMP COMMENT 'The precise date and time (with millisecond precision and timezone offset) at which this odds update message was received from the provider feed. Principal business event timestamp for latency measurement and audit.',
    `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether this odds feed record must be included in regulatory filings or reports to gaming authorities in the applicable jurisdiction (True). Supports automated regulatory reporting workflows and SOX/CCPA/GDPR compliance.',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this odds feed record has been flagged for responsible gaming review (True), for example due to unusual line movement that may indicate integrity concerns, or market conditions that trigger enhanced monitoring under WADA or governing body integrity frameworks.',
    `result_outcome` STRING COMMENT 'The official result outcome for this selection once the market has been resulted. win = selection won; lose = selection lost; void = bet voided; push = stake returned (tie); half_win/half_lose = Asian handicap partial outcomes. Null until market is resulted.. Valid values are `win|lose|void|push|half_win|half_lose`',
    `sequence_number` BIGINT COMMENT 'Sequential message number assigned by the odds provider within their feed stream for this market or session. Used to detect out-of-order delivery, gaps in the feed, and to reconstruct the correct chronological order of odds updates.',
    `source_market_reference` STRING COMMENT 'The providers own internal market identifier or reference code for this betting market, as supplied in the feed message. Enables direct reconciliation with the providers system without requiring a reverse lookup.',
    `sport_code` STRING COMMENT 'Standardised short code identifying the sport associated with this odds feed record (e.g., NFL, NBA, MLB, NHL, MLS, UFC, ATP). Enables cross-sport analytics and jurisdiction-specific regulatory reporting.. Valid values are `^[A-Z]{2,10}$`',
    `suspension_reason` STRING COMMENT 'Descriptive reason for market suspension when is_suspended is True (e.g., VAR_REVIEW, INJURY_STOPPAGE, RISK_MANAGEMENT, FEED_OUTAGE, REGULATORY_HOLD). Null when market is not suspended. [ENUM-REF-CANDIDATE: VAR_REVIEW|INJURY_STOPPAGE|RISK_MANAGEMENT|FEED_OUTAGE|REGULATORY_HOLD|MANUAL — promote to reference product]',
    `total_line_value` DECIMAL(18,2) COMMENT 'The total points/goals/runs line value for over/under markets (e.g., 2.5 goals, 47.5 points). Null for non-totals markets. Used in conjunction with market_type to define the exact market being priced.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time at which this odds feed record was last modified in the Silver layer lakehouse. Supports incremental processing and change data capture.',
    CONSTRAINT pk_odds_feed PRIMARY KEY(`odds_feed_id`)
) COMMENT 'High-frequency transactional record of odds price updates received from odds compilers and third-party odds providers (e.g., Sportradar, Kambi) for each betting market. Captures market ID, selection ID, decimal/fractional/American odds format values, implied probability, line movement direction, feed source, timestamp of update, and feed status. Supports real-time odds display, line movement analytics, and audit trails for regulatory compliance.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`wager` (
    `wager_id` BIGINT COMMENT 'Unique system-generated identifier for each individual wager transaction placed across all sportsbook channels. Primary key for the wager entity.',
    `betting_market_id` BIGINT COMMENT 'Identifier of the betting market on which this wager was placed (e.g., match winner, over/under, point spread). Drives market-level settlement and odds management.',
    `bettor_account_id` BIGINT COMMENT 'Unique identifier of the registered bettor account that placed this wager. Links to the bettors registered gaming account for KYC, responsible gaming, and regulatory reporting purposes.',
    `broadcast_schedule_id` BIGINT COMMENT 'Foreign key linking to broadcast.broadcast_schedule. Business justification: In-play wagering windows are gated on broadcast schedule start/end times. Sportsbooks open/close live markets based on broadcast status, and settlement timing aligns with broadcast end. Regulators req',
    `cashout_of_wager_id` BIGINT COMMENT 'Self-referencing FK on wager (cashout_of_wager_id)',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Wagers are placed under specific licensed legal entities (company codes) for GGR tax reporting, withholding tax remittance, and regulatory compliance. Finance must attribute wager revenue to the corre',
    `facility_id` BIGINT COMMENT 'Foreign key linking to venue.facility. Business justification: Retail wagers placed at in-venue sportsbook kiosks must be attributed to the specific facility for regulatory reporting, tax remittance by jurisdiction, and venue revenue reconciliation. The existing ',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Wagers must be attributed to fiscal periods for GGR reporting, tax remittance calculations, and period-close processes. Gaming finance teams report GGR by fiscal period to regulators and internal mana',
    `game_result_id` BIGINT COMMENT 'Foreign key linking to league.game_result. Business justification: Wager settlement is triggered by the official game_result. Linking wager directly to game_result enables settlement workflow automation, integrity investigation (protest_flag, var_intervention_flag), ',
    `investigation_id` BIGINT COMMENT 'Foreign key linking to compliance.investigation. Business justification: Wagers flagged via `integrity_flag` for match-fixing or suspicious betting patterns trigger formal compliance investigations. Sports integrity officers must trace which specific wager(s) initiated an ',
    `jurisdiction_id` BIGINT COMMENT 'Identifier of the regulatory jurisdiction under which this wager was accepted (e.g., Nevada, New Jersey, United Kingdom). Determines applicable tax rates, reporting obligations, and responsible gaming rules.',
    `match_result_id` BIGINT COMMENT 'Foreign key linking to event.match_result. Business justification: Wager settlement — the primary sportsbook business process — resolves each wager against the official match_result. Regulatory reporting of settled wagers and integrity investigations both require dir',
    `odds_feed_id` BIGINT COMMENT 'Foreign key linking to gaming.odds_feed. Business justification: A wager is placed at specific odds derived from an odds feed snapshot. wager has odds_at_placement (DECIMAL) but no FK to odds_feed. Adding odds_feed_id links each wager to the specific odds record us',
    `operator_id` BIGINT COMMENT 'Identifier of the licensed sportsbook operator or brand under which this wager was accepted. Supports multi-brand or white-label sportsbook operations and operator-level regulatory reporting.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to fan.campaign. Business justification: Sportsbook operators track which promotional campaign drove a wager (free bet offers, deposit match promotions) for marketing ROI reporting and bonus liability accounting. wager.promotion_code is a de',
    `regulatory_report_id` BIGINT COMMENT 'The identifier of the regulatory filing or suspicious activity report (SAR) that this wager was included in, if applicable. Used for AML compliance tracking and regulatory audit trail. Null if no regulatory report has been filed for this wager.',
    `retail_location_id` BIGINT COMMENT 'Identifier of the physical retail sportsbook location (e.g., stadium sportsbook, casino floor) where the wager was placed. Null for digital channel wagers. Used for venue-level revenue reporting and compliance.',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: Wagers are scoped to a league season for regulatory reporting (season-level GGR, W-2G aggregation), integrity monitoring, and financial reconciliation. Season-level wager aggregation is a standard spo',
    `emergency_activation_id` BIGINT COMMENT 'Foreign key linking to security.emergency_activation. Business justification: Wager void due to emergency event cancellation: when an emergency activation cancels an event, open wagers must be voided and stakes refunded. This FK links each voided wager to the specific activatio',
    `fixture_id` BIGINT COMMENT 'Identifier of the sporting or entertainment event that this wager is associated with (e.g., NFL game, UFC bout, NBA match). Used for event-level wagering aggregation and settlement.',
    `wager_fixture_id` BIGINT COMMENT 'Identifier of the sporting or entertainment event that this wager is associated with (e.g., NFL game, UFC bout, NBA match). Used for event-level wagering aggregation and settlement.',
    `bonus_amount` DECIMAL(18,2) COMMENT 'The monetary value of any bonus or promotional credit applied to this wager. Tracked separately from real-money stake for regulatory gross gaming revenue (GGR) reporting and bonus liability accounting.',
    `cashout_amount` DECIMAL(18,2) COMMENT 'The monetary amount offered and accepted by the bettor when exercising the early cash-out option. Null if the wager was not cashed out. Represents the sportsbooks real-time liability reduction value.',
    `cashout_timestamp` TIMESTAMP COMMENT 'The date and time when the bettor exercised the early cash-out option, if applicable. Null if the wager was not cashed out early. Used for cash-out feature analytics and liability management.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this wager record was first created in the sportsbook system. Used for audit trail, data lineage, and Silver layer ingestion tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this wager (stake, payout, settlement). Supports multi-currency sportsbook operations across international jurisdictions (e.g., USD, GBP, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `device_fingerprint` STRING COMMENT 'Anonymized or hashed identifier of the device used to place the wager. Used for fraud detection, multi-accounting prevention, and geolocation compliance verification. Not a direct personal identifier but may be used to identify individuals in combination with other data.',
    `geolocation_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code where the bettor was physically located at time of wager placement. Used for international jurisdiction compliance and cross-border wagering restriction enforcement.. Valid values are `^[A-Z]{3}$`',
    `geolocation_state` STRING COMMENT 'Two-letter US state code (or equivalent jurisdiction code) where the bettor was physically located at time of wager placement, as verified by geolocation service. Critical for confirming the bettor is within a licensed wagering jurisdiction.. Valid values are `^[A-Z]{2}$`',
    `geolocation_verified` BOOLEAN COMMENT 'Indicates whether the bettors physical location was successfully verified by the geolocation service at time of wager placement. False may indicate a geolocation failure or VPN/proxy detection, requiring compliance review.',
    `integrity_flag` BOOLEAN COMMENT 'Indicates whether this wager has been flagged for sports integrity review due to suspicious betting patterns (e.g., unusual odds movement, match-fixing indicators). Flagged wagers are reported to relevant sports governing bodies (FIFA, NFL, NBA integrity units) and gaming regulators.',
    `ip_address` STRING COMMENT 'The IP address from which the wager was placed. Used for geolocation verification to confirm the bettor is within a licensed jurisdiction at time of placement. Subject to privacy regulations in EU and California jurisdictions.',
    `is_free_bet` BOOLEAN COMMENT 'Indicates whether this wager was funded by a promotional free bet credit rather than real money from the bettors account. Free bets are excluded from certain regulatory gross gaming revenue calculations.',
    `is_live_bet` BOOLEAN COMMENT 'Indicates whether this wager was placed as an in-play (live) bet after the event commenced, as opposed to a pre-game bet. Live bets carry different risk profiles and are subject to specific regulatory requirements in some jurisdictions.',
    `leg_count` STRING COMMENT 'The number of individual selections (legs) included in this wager. For straight bets this is 1; for parlays and teasers this is 2 or more. Used for parlay payout validation and risk management.',
    `odds_at_placement` DECIMAL(18,2) COMMENT 'The decimal odds offered to the bettor at the exact moment the wager was placed. Locked in at placement time and used for payout calculation. Stored in decimal format (e.g., 2.50 = evens +100 American odds) regardless of display format shown to bettor.',
    `odds_format` STRING COMMENT 'The odds display format presented to the bettor at time of placement (e.g., american for +150/-110, decimal for 2.50, fractional for 3/2). Stored for display reconciliation and international market compliance.. Valid values are `decimal|american|fractional|hong_kong|indonesian`',
    `placement_timestamp` TIMESTAMP COMMENT 'The exact date and time (with timezone) when the wager was accepted and confirmed by the sportsbook platform. This is the principal business event timestamp and is critical for in-play betting validation, regulatory reporting, and audit trails.',
    `potential_payout` DECIMAL(18,2) COMMENT 'The maximum gross payout amount the bettor would receive if the wager wins, calculated as stake_amount multiplied by odds_at_placement. Captured at placement time for liability management and bettor communication.',
    `potential_profit` DECIMAL(18,2) COMMENT 'The net profit the bettor would receive if the wager wins, calculated as potential_payout minus stake_amount. Represents the bettors net gain and is used in responsible gaming exposure monitoring.',
    `reference_number` STRING COMMENT 'Externally visible alphanumeric reference number presented to the bettor on their bet slip or receipt. Used for customer service inquiries, dispute resolution, and regulatory audit trails.. Valid values are `^[A-Z0-9]{8,20}$`',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this wager triggered a responsible gaming alert or intervention at time of placement (e.g., exceeded deposit limit, velocity threshold, or self-exclusion proximity check). Used for regulatory compliance reporting and player protection monitoring.',
    `selection_description` STRING COMMENT 'Human-readable description of the bettors selection within the betting market (e.g., Kansas City Chiefs to win, Over 48.5 total points, LeBron James to score 30+ points). Captured at time of placement for audit and display purposes.',
    `self_exclusion_override` BOOLEAN COMMENT 'Indicates whether this wager was placed despite a self-exclusion or cooling-off period being active on the bettors account. Should always be False for compliant operations; True values require immediate regulatory escalation.',
    `settlement_amount` DECIMAL(18,2) COMMENT 'The actual monetary amount paid out to the bettor upon settlement. For winning wagers this equals the gross payout; for losing wagers this is zero; for void/push wagers this equals the stake returned. Null until the wager is settled.',
    `settlement_timestamp` TIMESTAMP COMMENT 'The date and time when the wager outcome was determined and the settlement amount was applied to the bettors account. Null for pending wagers. Used for settlement cycle reporting and regulatory compliance.',
    `stake_amount` DECIMAL(18,2) COMMENT 'The monetary amount wagered by the bettor at time of placement, in the transaction currency. Represents the bettors financial exposure and is the basis for hold calculations and regulatory reporting.',
    `tax_withheld_amount` DECIMAL(18,2) COMMENT 'The amount of tax withheld from the settlement payout at source, as required by applicable jurisdiction tax laws (e.g., US federal withholding on large winnings per IRS Form W-2G thresholds). Zero if no withholding applies.',
    `ticket_terminal_code` STRING COMMENT 'Identifier of the specific betting terminal, kiosk, or point-of-sale device used to place the wager. Used for terminal-level reconciliation, fraud detection, and equipment audit trails in retail and kiosk channels.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this wager record was last modified in the sportsbook system (e.g., status change from pending to settled). Used for change data capture and audit compliance.',
    `void_reason` STRING COMMENT 'The reason code explaining why a wager was voided. Null for non-voided wagers. Used for operational reporting, bettor communication, and regulatory audit. [ENUM-REF-CANDIDATE: event_cancelled|event_postponed|market_error|odds_error|bettor_request|regulatory_order|system_error|integrity_concern — promote to reference product]',
    `wager_status` STRING COMMENT 'Current lifecycle status of the wager. pending indicates the event has not yet concluded; won/lost reflect settled outcomes; void indicates cancellation (e.g., event postponed); cashed_out reflects early cash-out by bettor; pushed indicates a tie/refund outcome.. Valid values are `pending|won|lost|void|cashed_out|pushed`',
    `wager_type` STRING COMMENT 'Classification of the wager structure. straight is a single-selection bet; parlay combines multiple selections for higher payout; teaser adjusts point spreads; prop is a proposition bet on specific in-game events; futures bets on season-long outcomes; round_robin is a series of parlays. [ENUM-REF-CANDIDATE: straight|parlay|teaser|prop|futures|round_robin|if_bet|reverse — promote to reference product]. Valid values are `straight|parlay|teaser|prop|futures|round_robin`',
    CONSTRAINT pk_wager PRIMARY KEY(`wager_id`)
) COMMENT 'Core transactional record of every individual bet placed by a registered bettor across all wagering channels — retail sportsbook, mobile app, kiosk, and online platform. Captures bettor account ID, betting market ID, selection, stake amount, odds at time of placement, potential payout, wager type (straight, parlay, teaser, prop), placement channel, placement timestamp, wager status (pending, won, lost, void, cashed out), settlement amount, and settlement timestamp. Primary transactional entity for sportsbook operations and regulatory reporting.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` (
    `bettor_account_id` BIGINT COMMENT 'Unique surrogate identifier for each registered bettor account on the sportsbook or fantasy platform. Primary key for this entity.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to fan.campaign. Business justification: Gaming operators track which marketing campaign drove bettor account registration for affiliate commission calculation and acquisition ROI reporting. bettor_account has denormalized affiliate_code and',
    `fan_profile_id` BIGINT COMMENT 'Foreign key linking to fan.fan_profile. Business justification: Unified customer identity: sports entertainment operators must link bettor accounts to fan CRM profiles for cross-channel responsible gaming enforcement (self-exclusion suppressing marketing), loyalty',
    `referred_by_bettor_account_id` BIGINT COMMENT 'Self-referencing FK on bettor_account (referred_by_bettor_account_id)',
    `season_ticket_account_id` BIGINT COMMENT 'Foreign key linking to ticketing.season_ticket_account. Business justification: STH-bettor identity linkage is a named operational process in integrated sports entertainment: responsible gaming teams cross-reference self-exclusion and deposit limits against STH accounts, and loya',
    `account_number` STRING COMMENT 'Externally-visible, human-readable account number assigned to the bettor at registration. Used in customer communications, statements, and support interactions. Serves as the BUSINESS_IDENTIFIER for this account.',
    `account_status` STRING COMMENT 'Current lifecycle state of the bettor account. Controls whether the account may place wagers, deposit funds, or access the platform. self_excluded indicates a responsible gaming restriction initiated by the bettor or operator. [ENUM-REF-CANDIDATE: active|suspended|closed|pending_verification|self_excluded|dormant — promote to reference product if additional states are required]. Valid values are `active|suspended|closed|pending_verification|self_excluded|dormant`',
    `account_tier` STRING COMMENT 'Operational tier classification of the bettor account. VIP accounts receive enhanced limits and concierge service. Professional accounts are subject to enhanced scrutiny and may have reduced maximum payouts per regulatory requirements. Restricted accounts have operator-imposed limitations.. Valid values are `standard|vip|professional|restricted`',
    `account_type` STRING COMMENT 'Classification of the gaming account by platform type: sportsbook (fixed-odds wagering), fantasy (daily/season-long fantasy sports), combined (both sportsbook and fantasy), or exchange (peer-to-peer betting exchange). Drives product entitlements and regulatory reporting scope.. Valid values are `sportsbook|fantasy|combined|exchange`',
    `affiliate_code` STRING COMMENT 'Affiliate or partner referral code applied at account registration. Used to attribute the account acquisition to a specific affiliate partner for commission calculation and partnership performance reporting.',
    `age_verified` BOOLEAN COMMENT 'Indicates whether the bettor has passed mandatory age verification confirming they meet the minimum legal gambling age for their registration jurisdiction. Accounts with False status are restricted from wagering activity.',
    `age_verified_date` DATE COMMENT 'Date on which the bettors age was successfully verified. Null if age verification has not been completed. Required for regulatory compliance reporting.',
    `balance` DECIMAL(18,2) COMMENT 'Current real-money balance available in the bettors account for wagering, expressed in the accounts base currency. Excludes bonus funds. Updated in real time following deposits, withdrawals, wager placements, and settlements.',
    `bonus_balance` DECIMAL(18,2) COMMENT 'Current promotional or bonus credit balance in the bettors account. Bonus funds are subject to wagering requirements before withdrawal and are tracked separately from real-money balance per regulatory requirements.',
    `close_date` DATE COMMENT 'Calendar date on which the bettor account was permanently closed, either by the bettors request or operator action. Null for active accounts. Required for regulatory record retention and audit trails.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the bettor account record was first created in the system, in ISO 8601 format with timezone offset. Serves as the authoritative audit creation timestamp for this record.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the bettor accounts base currency (e.g., USD, GBP, EUR). All balance and limit fields are denominated in this currency.. Valid values are `[A-Z]{3}`',
    `date_of_birth` DATE COMMENT 'Bettors date of birth as provided during registration and confirmed through KYC. Used for age verification, responsible gaming age-gating, and regulatory compliance. Classified as restricted PII.',
    `deposit_limit_daily` DECIMAL(18,2) COMMENT 'Maximum amount the bettor is permitted to deposit within a rolling 24-hour period. Set by the bettor or operator as a responsible gaming control. Null indicates no limit is set. Enforced at the platform level.',
    `deposit_limit_monthly` DECIMAL(18,2) COMMENT 'Maximum amount the bettor is permitted to deposit within a rolling 30-day period. A responsible gaming control that can be set by the bettor or mandated by the operator or regulator. Null indicates no limit is set.',
    `deposit_limit_weekly` DECIMAL(18,2) COMMENT 'Maximum amount the bettor is permitted to deposit within a rolling 7-day period. A responsible gaming control that can be set by the bettor or mandated by the operator or regulator. Null indicates no limit is set.',
    `email` STRING COMMENT 'Primary email address registered on the bettor account. Used for account communications, promotional offers, responsible gaming notifications, and two-factor authentication. Classified as restricted PII.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `full_name` STRING COMMENT 'Full legal name of the bettor as provided during registration and confirmed through KYC. Used for identity matching, regulatory reporting, and tax documentation (e.g., W-2G forms for large winnings).',
    `geolocation_verified` BOOLEAN COMMENT 'Indicates whether the bettors physical location has been verified as within a licensed jurisdiction at the time of account registration or most recent login. Required for compliance with state-level online gaming regulations that restrict wagering to in-state bettors.',
    `identity_document_expiry` DATE COMMENT 'Expiry date of the identity document submitted for KYC. Used to trigger re-verification workflows when documents approach or pass expiry, ensuring ongoing KYC compliance.',
    `identity_document_reference` STRING COMMENT 'Tokenized or masked reference to the government-issued identity document number used for KYC verification. The full document number is stored in the secure KYC vault; this field holds only the vault reference token to enable audit linkage without exposing raw PII.',
    `identity_document_type` STRING COMMENT 'Type of government-issued identity document submitted for KYC verification. Determines the applicable document validation rules and expiry tracking requirements.. Valid values are `passport|drivers_license|national_id|state_id`',
    `kyc_status` STRING COMMENT 'Current status of the Know Your Customer (KYC) identity verification process for this account. Accounts must achieve verified status before full wagering privileges are granted. expired indicates previously verified documents have lapsed and re-verification is required.. Valid values are `not_started|pending|verified|failed|expired`',
    `kyc_verified_date` DATE COMMENT 'Date on which the bettors identity was successfully verified through the KYC process. Null if KYC has not been completed. Used for compliance audit trails and re-verification scheduling.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to any field on this bettor account record. Used for change data capture, audit trails, and data freshness monitoring in the Silver layer.',
    `loss_limit_daily` DECIMAL(18,2) COMMENT 'Maximum net loss the bettor is permitted to incur within a rolling 24-hour period. A responsible gaming control that triggers account suspension when reached. Null indicates no limit is set.',
    `marketing_opt_in` BOOLEAN COMMENT 'Indicates whether the bettor has consented to receive marketing communications including promotional offers, odds boosts, and event notifications. Governs CRM outreach eligibility per GDPR and CCPA consent requirements.',
    `open_date` DATE COMMENT 'Calendar date on which the bettor account was formally opened and activated following successful KYC verification. Used for account age calculations, promotional eligibility, and regulatory reporting.',
    `phone_number` STRING COMMENT 'Primary mobile or landline phone number registered on the bettor account. Used for two-factor authentication, responsible gaming outreach, and account recovery. Classified as restricted PII.',
    `preferred_sport` STRING COMMENT 'The bettors self-declared or system-inferred primary sport of interest (e.g., NFL, NBA, MLB, NHL, MLS, UFC, FIFA). Used for personalization of odds feeds, promotional targeting, and fantasy league recommendations.',
    `promo_code_used` STRING COMMENT 'Promotional or welcome offer code entered by the bettor at account registration. Used to apply welcome bonuses, track promotional campaign effectiveness, and calculate bonus liability.',
    `registration_jurisdiction` STRING COMMENT 'ISO 3166-1 alpha-2 or alpha-3 code for the jurisdiction (state, province, or country) under which this account was registered and is licensed to operate. Determines applicable regulatory framework, tax obligations, and responsible gaming requirements.. Valid values are `[A-Z]{2,3}`',
    `registration_state_code` STRING COMMENT 'Two-letter US state or Canadian province code where the bettor account was registered. Used for state-level regulatory reporting, tax withholding, and geofencing compliance. Complements registration_jurisdiction for sub-national precision.. Valid values are `[A-Z]{2}`',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether the bettor account has been flagged by the responsible gaming monitoring system for elevated risk of problem gambling behavior. Triggers enhanced monitoring, outreach, and potential limit reviews by the responsible gaming team.',
    `responsible_gaming_flag_date` DATE COMMENT 'Date on which the responsible gaming flag was most recently set on this account. Used to track the duration of elevated monitoring and schedule periodic reviews.',
    `self_exclusion_end_date` DATE COMMENT 'Date on which the bettors self-exclusion period is scheduled to end. Null for indefinite exclusions or accounts with no exclusion. Used to trigger re-activation eligibility workflows.',
    `self_exclusion_start_date` DATE COMMENT 'Date on which the bettors self-exclusion period began. Null if no self-exclusion is active or has ever been applied. Required for regulatory compliance and re-activation eligibility calculations.',
    `self_exclusion_status` STRING COMMENT 'Indicates whether the bettor has enrolled in a self-exclusion program. voluntary means bettor-initiated exclusion; mandatory means regulator or operator-imposed exclusion; expired means a prior exclusion period has ended. Accounts with active exclusion are blocked from wagering.. Valid values are `none|voluntary|mandatory|expired`',
    `source_channel` STRING COMMENT 'Channel through which the bettor account was originally registered. Used for customer acquisition cost (CAC) attribution, affiliate commission calculations, and channel performance analytics.. Valid values are `web|mobile_app|retail|affiliate|partner`',
    `tax_id_reference` STRING COMMENT 'Tokenized reference to the bettors tax identification number (e.g., SSN or ITIN in the US) stored in the secure KYC vault. Required for IRS W-2G tax reporting on winnings exceeding regulatory thresholds. The raw TIN is never stored in this field.',
    `two_factor_auth_enabled` BOOLEAN COMMENT 'Indicates whether the bettor has enabled two-factor authentication (2FA) on their account. Relevant for security posture reporting and may be mandated by certain jurisdictions for high-value accounts.',
    `w2g_threshold_met` BOOLEAN COMMENT 'Indicates whether the bettor has met the IRS W-2G reportable winnings threshold ($600 or more at 300:1 odds or greater, or $1,200+ for certain game types) within the current tax year. Triggers tax documentation workflows.',
    `wager_limit_daily` DECIMAL(18,2) COMMENT 'Maximum total wager amount the bettor is permitted to place within a rolling 24-hour period. A responsible gaming control. Null indicates no limit is set.',
    CONSTRAINT pk_bettor_account PRIMARY KEY(`bettor_account_id`)
) COMMENT 'Gaming-domain operational account record for each registered bettor on the sportsbook or fantasy platform. Distinct from fan.fan_profile (the enterprise identity SSOT) — this entity captures gaming-specific account attributes: account number, KYC verification status, age verification status, identity document reference, account tier (standard, VIP, professional), deposit limit settings, self-exclusion status, responsible gaming flags, jurisdiction of registration, account open date, and account balance. Links to fan.fan_profile via FK in the linking step.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` (
    `prop_bet_id` BIGINT COMMENT 'Unique surrogate identifier for each proposition bet offering in the master catalog. Primary key for the prop_bet data product.',
    `betting_market_id` BIGINT COMMENT 'Foreign key linking to gaming.betting_market. Business justification: A prop bet is a specialized type of betting market offering. prop_bet is the detailed catalog of proposition bets while betting_market is the master market definition. prop_bet should reference its pa',
    `eligibility_status_id` BIGINT COMMENT 'Foreign key linking to athlete.eligibility_status. Business justification: Prop bet market validity and settlement depend on athlete eligibility status. When a governing body changes eligibility (ban, suspension, transfer restriction), sportsbooks must void or suspend relate',
    `franchise_id` BIGINT COMMENT 'Foreign key linking to league.franchise. Business justification: Team-based prop bets (team total points, first team to score, team penalty count) reference a specific franchise. A franchise_id FK replaces the denormalized team_subject_code, enabling franchise-leve',
    `game_result_id` BIGINT COMMENT 'Foreign key linking to league.game_result. Business justification: Prop bets are settled against official game results. The game_result record provides the authoritative game-level outcome context (overtime periods, forfeit, protest) that governs prop bet settlement ',
    `league_id` BIGINT COMMENT 'Reference to the governing league or competition body associated with this proposition bet (e.g., NFL, NBA, MLB, NHL, MLS, UFC). Used for jurisdiction eligibility and regulatory reporting.',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: Season-long player stat props (e.g., season rushing yards over/under) must reference the specific league season for settlement against official season statistics, regulatory period reporting, and cap-',
    `match_result_id` BIGINT COMMENT 'Foreign key linking to event.match_result. Business justification: Prop bet settlement (first scorer, total goals, margin of victory) is triggered by and validated against the official match_result. Integrity audits and regulatory filings for prop markets require dir',
    `media_rights_deal_id` BIGINT COMMENT 'Foreign key linking to broadcast.media_rights_deal. Business justification: Prop bet settlement depends on official broadcast data sourced under a specific media rights deal. Official data mandate compliance and settlement dispute resolution require tracing which rights deal ',
    `odds_feed_id` BIGINT COMMENT 'The unique identifier assigned by the external odds or data feed provider (e.g., Sportradar, Genius Sports) to this proposition bet offering. Used for reconciliation between internal catalog and upstream data providers.',
    `parent_prop_bet_id` BIGINT COMMENT 'Self-referencing FK on prop_bet (parent_prop_bet_id)',
    `participant_id` BIGINT COMMENT 'Foreign key linking to event.participant. Business justification: Prop bets on lineup-dependent outcomes (first scorer, player to be carded, starter/non-starter markets) require the specific event.participant record capturing fixture-specific role and participation_',
    `performance_stat_id` BIGINT COMMENT 'Foreign key linking to athlete.performance_stat. Business justification: Prop bet settlement (e.g., player over/under points, yards, goals) is executed against official performance_stat records. Direct FK links the settled prop to the authoritative stat record used for set',
    `athlete_profile_id` BIGINT COMMENT 'Reference to the athlete who is the subject of a player proposition bet (e.g., anytime touchdown scorer, first basket, strikeout totals). Null for game-level or novelty props.',
    `fixture_id` BIGINT COMMENT 'Reference to the sporting event or fixture to which this proposition bet is associated (e.g., NFL game, UFC bout, NBA match).',
    `scoring_event_id` BIGINT COMMENT 'Foreign key linking to event.scoring_event. Business justification: Prop bet settlement (e.g., First scorer, Player to score 2+ goals) is triggered by specific scoring events. Automated settlement processing requires a direct link from prop_bet to the scoring_even',
    `suspension_record_id` BIGINT COMMENT 'Foreign key linking to athlete.suspension_record. Business justification: Prop bets on suspended athletes must be voided per sportsbook rules and regulatory requirements. Direct FK from prop_bet to suspension_record enables automated voiding workflows and audit trails linki',
    `age_restriction_years` STRING COMMENT 'Minimum legal age in years required to place a wager on this proposition bet in the applicable jurisdiction (typically 18 or 21 depending on jurisdiction). Enforced at account verification.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this proposition bet record was first created in the master catalog, used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the operating currency of this proposition bet market (e.g., USD, GBP, EUR, CAD). Governs wager amounts, payouts, and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `fantasy_sport_type` STRING COMMENT 'Indicates whether this proposition bet is associated with a daily fantasy sports (DFS) contest, a season-long fantasy league, or is a standard sportsbook prop (not_applicable). Used for regulatory classification under UIGEA and state DFS laws.. Valid values are `daily_fantasy|season_long|not_applicable`',
    `fixture_date` DATE COMMENT 'The scheduled calendar date of the sporting event or fixture to which this proposition bet is tied. Used for scheduling, market management, and regulatory reporting.',
    `is_live_bet` BOOLEAN COMMENT 'Indicates whether this proposition bet is available for in-play (live) wagering during the event, as opposed to pre-event wagering only. True = live betting enabled.',
    `is_parlay_eligible` BOOLEAN COMMENT 'Indicates whether this proposition bet can be included as a leg in a parlay or same-game parlay (SGP) wager. Regulatory and risk management rules may restrict certain props from parlay inclusion.',
    `is_same_game_parlay_eligible` BOOLEAN COMMENT 'Indicates whether this proposition bet is eligible to be combined with other bets from the same game in a same-game parlay (SGP) product. Distinct from general parlay eligibility due to correlated outcome risk controls.',
    `jurisdiction_codes` STRING COMMENT 'Pipe-delimited list of jurisdiction codes (US state, country, or territory codes) where this proposition bet is legally available for wagering (e.g., NJ|NV|PA|CO|IL). Drives geo-restriction logic on the betting platform.',
    `line_unit` STRING COMMENT 'The unit of measurement for the proposition bet line value (e.g., touchdowns, points, yards, strikeouts, assists, rebounds, goals). Provides context for interpreting prop_line_value. [ENUM-REF-CANDIDATE: touchdowns|points|yards|strikeouts|assists|rebounds|goals|saves|aces|birdies|rounds|other — 12 candidates stripped; promote to reference product]',
    `market_close_timestamp` TIMESTAMP COMMENT 'Date and time (ISO 8601 with timezone) when the proposition bet market was closed and stopped accepting new wagers. Typically aligned with event start time or a pre-event cutoff.',
    `market_open_timestamp` TIMESTAMP COMMENT 'Date and time (ISO 8601 with timezone) when the proposition bet market was opened and began accepting wagers from bettors.',
    `market_status` STRING COMMENT 'Current lifecycle state of the proposition bet market: open (accepting wagers), suspended (temporarily halted, e.g., injury news), closed (no longer accepting wagers), settled (outcome determined and payouts processed), voided (cancelled with stakes returned), pending (awaiting activation).. Valid values are `open|suspended|closed|settled|voided|pending`',
    `max_payout_amount` DECIMAL(18,2) COMMENT 'The maximum total payout (stake plus winnings, in operating currency) that can be awarded on a single wager for this proposition bet. Used for liability capping and risk management.',
    `max_wager_amount` DECIMAL(18,2) COMMENT 'The maximum single-bet stake amount (in the operating currency) permitted on this proposition bet, as set by the risk management team. Enforced at the platform level to control liability exposure.',
    `min_wager_amount` DECIMAL(18,2) COMMENT 'The minimum single-bet stake amount (in the operating currency) required to place a wager on this proposition bet. Set by the platform operator per regulatory and commercial requirements.',
    `odds_format` STRING COMMENT 'The format in which odds are expressed for this proposition bet market, used for display and regulatory reporting purposes (decimal, american/moneyline, fractional, hong_kong, indonesian, malay).. Valid values are `decimal|american|fractional|hong_kong|indonesian|malay`',
    `odds_provider_code` STRING COMMENT 'Code identifying the external odds feed provider or trading desk that supplied the opening and current odds for this proposition bet (e.g., SPORTRADAR, GENIUS_SPORTS, INTERNAL).. Valid values are `^[A-Z0-9_]{2,20}$`',
    `over_odds` DECIMAL(18,2) COMMENT 'The current decimal odds offered for the over or yes selection on this proposition bet. Expressed in decimal format per international sportsbook standards (e.g., 1.9091 for -110 American odds).',
    `prop_category` STRING COMMENT 'High-level classification of the proposition bet type: player_prop (individual athlete performance), game_prop (game-level outcome), team_prop (team performance), novelty_prop (non-standard entertainment wagers), entertainment_prop (non-sport entertainment events), series_prop (multi-game series outcome).. Valid values are `player_prop|game_prop|novelty_prop|entertainment_prop|team_prop|series_prop`',
    `prop_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying this proposition bet offering within the gaming platform and across partner sportsbook integrations (e.g., PROP-NFL-TD-ANYTIME-001).. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `prop_description` STRING COMMENT 'Detailed narrative description of the proposition bet, including the specific outcome being wagered on, applicable rules, and any clarifying conditions for settlement.',
    `prop_line_value` DECIMAL(18,2) COMMENT 'The numeric threshold or line associated with over/under or points-based proposition bets (e.g., 1.5 touchdowns, 24.5 points, 7.5 strikeouts). Null for yes/no or binary props.',
    `prop_name` STRING COMMENT 'Human-readable display name of the proposition bet as shown to bettors on the platform (e.g., Anytime Touchdown Scorer - Patrick Mahomes, First Team to Score).',
    `prop_subcategory` STRING COMMENT 'Granular classification within the prop category (e.g., touchdown_scorer, passing_yards, first_basket, strikeout_total, margin_of_victory, first_team_to_score). [ENUM-REF-CANDIDATE: touchdown_scorer|passing_yards|first_basket|strikeout_total|margin_of_victory|first_team_to_score|rushing_yards|receiving_yards|assists|rebounds — promote to reference product]',
    `regulatory_category` STRING COMMENT 'Regulatory classification of the proposition bet for licensing, reporting, and compliance purposes as defined by applicable gaming authorities (sports_wagering, daily_fantasy, novelty, entertainment, esports).. Valid values are `sports_wagering|daily_fantasy|novelty|entertainment|esports`',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this proposition bet has been flagged for enhanced responsible gaming controls (e.g., lower stake limits, additional friction, exclusion from promotional offers) due to risk profile or regulatory mandate.',
    `settlement_criteria` STRING COMMENT 'Detailed rules and conditions used to determine the winning outcome of the proposition bet (e.g., Player must score a touchdown at any point during regulation and overtime, Official league statistics used for settlement within 72 hours of game completion).',
    `settlement_result` STRING COMMENT 'The official outcome of the proposition bet after settlement: win (winning selection), lose (losing selection), void (bet cancelled), push (tie/refund), pending (not yet settled).. Valid values are `win|lose|void|push|pending`',
    `settlement_timestamp` TIMESTAMP COMMENT 'Date and time when the proposition bet outcome was officially determined and the market was settled, triggering payout processing for winning wagers.',
    `sport_type` STRING COMMENT 'The sport associated with this proposition bet, used for categorization, regulatory reporting, and odds feed routing (e.g., football, basketball, baseball, hockey, soccer, tennis, mma, golf). [ENUM-REF-CANDIDATE: football|basketball|baseball|hockey|soccer|tennis|mma|golf|other — 9 candidates stripped; promote to reference product]',
    `under_odds` DECIMAL(18,2) COMMENT 'The current decimal odds offered for the under or no selection on this proposition bet. Expressed in decimal format per international sportsbook standards.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this proposition bet record was last modified in the master catalog, capturing odds updates, status changes, or settlement actions for audit and compliance purposes.',
    `void_reason` STRING COMMENT 'The reason code explaining why a proposition bet market was voided and stakes returned to bettors (e.g., event_cancelled, player_did_not_participate, data_error, regulatory_order, insufficient_action). Populated only when market_status = voided.. Valid values are `event_cancelled|player_did_not_participate|data_error|regulatory_order|insufficient_action|other`',
    `winning_selection` STRING COMMENT 'The specific outcome or selection that was determined to be the winner upon settlement (e.g., Yes, Over, Team A, player name). Populated after settlement.',
    CONSTRAINT pk_prop_bet PRIMARY KEY(`prop_bet_id`)
) COMMENT 'Master catalog of proposition bet offerings — player props (anytime touchdown scorer, first basket, strikeout totals), game props (first team to score, margin of victory), and novelty/entertainment props. Captures prop bet code, description, associated event/fixture, player or team subject, prop category, market open/close timestamps, settlement criteria, and jurisdiction availability. Distinct from betting_market (which covers standard market types) — prop_bet is the specific offering catalog for proposition wagering.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` (
    `fantasy_league_id` BIGINT COMMENT 'Unique surrogate identifier for each fantasy sports league instance. Primary key for the fantasy_league data product in the gaming domain.',
    `bettor_account_id` BIGINT COMMENT 'Reference to the fan or user account that serves as the league commissioner — the individual responsible for league settings, rule enforcement, and administration.',
    `calendar_id` BIGINT COMMENT 'Foreign key linking to event.event_calendar. Business justification: Fantasy league seasons must align with the real-world sports event calendar for scoring period scheduling, trade deadlines, and playoff timing. The plain season string is a denormalized representati',
    `club_id` BIGINT COMMENT 'Foreign key linking to fan.club. Business justification: Fan clubs in sports entertainment officially sponsor or organize fantasy leagues for their members (e.g., official fan club DFS league). Linking fantasy_league to club enables member-exclusive league ',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Fantasy leagues operate under specific licensed legal entities (DFS licenses are jurisdiction-specific). Finance attributes fantasy revenue and prize pool liabilities to the correct company code for c',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Fantasy league entry fees and prize pools must be recognized in the correct fiscal period for DFS revenue recognition and period-close. Finance teams attribute fantasy league revenue to fiscal periods',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to gaming.gaming_jurisdiction. Business justification: Fantasy leagues operate under jurisdiction-specific DFS regulations — whether paid leagues are permitted, age restrictions, and responsible gaming mandates vary by jurisdiction. fantasy_league has jur',
    `league_id` BIGINT COMMENT 'Foreign key linking to league.league. Business justification: Fantasy leagues mirror a specific professional league (NFL fantasy, NBA fantasy). A league_id FK enables proper league-scoped fantasy reporting, official data licensing compliance, and regulatory fili',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: Fantasy leagues run in parallel with a specific professional league season. A league_season_id FK enables trade-deadline enforcement (fantasy_league.trade_deadline_date must align with league season t',
    `predecessor_fantasy_league_id` BIGINT COMMENT 'Self-referencing FK on fantasy_league (predecessor_fantasy_league_id)',
    `age_restriction_minimum` STRING COMMENT 'Minimum participant age (in years) required to join this league, as mandated by the applicable gaming jurisdiction. Typically 18 or 21 depending on state/country regulations.',
    `auction_budget` DECIMAL(18,2) COMMENT 'The total virtual currency budget allocated to each team manager for bidding during an auction draft. Applicable only when draft_type is auction. Null for snake or auto-pick drafts.',
    `bench_slots` STRING COMMENT 'Number of non-scoring reserve player slots on each teams roster. Bench players do not contribute to weekly scoring but are held for future use.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this fantasy league record was first created in the system. Used for audit trails, data lineage, and regulatory record-keeping.',
    `draft_date` TIMESTAMP COMMENT 'Scheduled date and time at which the leagues player draft is set to begin. Used for participant notifications, platform resource scheduling, and draft room activation.',
    `draft_type` STRING COMMENT 'The method by which team managers select players at the start of the season. Snake drafts reverse pick order each round; auction drafts allocate a budget for bidding; auto-pick uses algorithmic selection; linear maintains consistent pick order; third-round reversal is a hybrid variant. [ENUM-REF-CANDIDATE: snake|auction|auto_pick|linear|third_round_reversal — promote to reference product]. Valid values are `snake|auction|auto_pick|linear|third_round_reversal`',
    `entry_fee_amount` DECIMAL(18,2) COMMENT 'Monetary amount charged to each team manager to participate in the league. Zero for free-to-play leagues. Used for prize pool calculation, revenue recognition, and regulatory reporting to gaming authorities.',
    `entry_fee_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the entry fee amount (e.g., USD, CAD, GBP). Required for multi-jurisdiction gaming operations and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `faab_budget` DECIMAL(18,2) COMMENT 'The total Free Agent Acquisition Budget (FAAB) allocated to each team at season start for bidding on waiver wire players. Applicable only when waiver_type is FAAB. Null for non-FAAB leagues.',
    `invite_code` STRING COMMENT 'Alphanumeric code required to join a private or corporate league. Distributed by the commissioner to authorized participants. Null for public leagues.. Valid values are `^[A-Z0-9]{6,12}$`',
    `is_keeper_league` BOOLEAN COMMENT 'Indicates whether the league allows managers to retain (keep) a defined number of players from one season to the next. True for keeper and dynasty formats; False for redraft leagues.',
    `is_public` BOOLEAN COMMENT 'Indicates whether the league is publicly discoverable and joinable without an invitation code. True for open public leagues; False for private, corporate, or invite-only leagues.',
    `keeper_slot_count` STRING COMMENT 'Number of players each team manager is permitted to retain (keep) from the prior seasons roster. Applicable only when is_keeper_league is True. Null for redraft leagues.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time at which this fantasy league record was most recently modified. Used for change tracking, incremental data loads in the Databricks Silver layer, and audit compliance.',
    `league_external_code` STRING COMMENT 'Externally-known identifier assigned by the originating platform (e.g., DraftKings league ID, FanDuel league code, or proprietary platform reference). Used for cross-system reconciliation.',
    `league_status` STRING COMMENT 'Current lifecycle state of the fantasy league. Forming: accepting members pre-draft; draft_pending: roster locked awaiting draft; active: in-season competition underway; completed: season concluded and prizes awarded; cancelled: league disbanded before completion; suspended: temporarily halted pending review.. Valid values are `forming|draft_pending|active|completed|cancelled|suspended`',
    `league_type` STRING COMMENT 'Classification of the league by access model. Public leagues are open to any participant; private leagues require an invitation code; corporate leagues are employer-sponsored; satellite leagues are sub-leagues of a larger contest; managed leagues are operated by the platform on behalf of sponsors.. Valid values are `public|private|corporate|satellite|managed`',
    `max_team_count` STRING COMMENT 'The maximum number of teams permitted to join the league. Once reached, the league is closed to new entrants. May differ from team_count during the forming phase.',
    `playoff_start_week` STRING COMMENT 'The competition week number (within the sports season) at which the fantasy playoff bracket begins. Determines the length of the regular season and playoff scheduling.',
    `playoff_team_count` STRING COMMENT 'Number of teams that qualify for the end-of-season playoff bracket. Determines playoff seeding logic and the number of regular-season weeks required.',
    `prize_pool_amount` DECIMAL(18,2) COMMENT 'Total monetary value of prizes to be distributed to winning teams at season end. May be guaranteed (platform-funded) or variable (based on entry fees collected). Critical for gaming regulatory reporting and revenue recognition.',
    `prize_pool_type` STRING COMMENT 'Classification of how the prize pool is funded and guaranteed. Guaranteed pools are pre-committed by the platform regardless of entry count; variable pools are derived from entry fees collected; hybrid combines both; no_prize applies to free leagues.. Valid values are `guaranteed|variable|hybrid|no_prize`',
    `prize_structure` STRING COMMENT 'Distribution model for prize pool payouts. Winner-take-all awards the full pool to first place; top_3 distributes across three places; top_half pays all teams finishing in the upper half; custom uses a commissioner-defined payout schedule.. Valid values are `winner_take_all|top_3|top_half|custom`',
    `registration_close_date` DATE COMMENT 'The last date on which new team managers may join the league. After this date, the league roster is locked and the draft is scheduled.',
    `registration_open_date` DATE COMMENT 'The date on which the league becomes open for new team manager registrations. Relevant for public leagues and marketing campaign alignment.',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this league instance has been flagged for responsible gaming review or intervention (e.g., due to high entry fees, participant spending limits, or regulatory trigger). True triggers enhanced monitoring and reporting.',
    `roster_size` STRING COMMENT 'Total number of player slots on each teams active and bench roster combined. Governs the player pool depth required and waiver wire activity.',
    `scoring_format` STRING COMMENT 'The scoring methodology applied to player statistics to calculate fantasy points. Standard awards points for touchdowns and yardage; PPR (Points Per Reception) adds per-catch bonuses; half-PPR applies a 0.5 per-reception bonus; dynasty retains players across seasons; DFS (Daily Fantasy Sports) uses single-contest scoring; keeper retains selected players; IDP (Individual Defensive Player) scores defensive players individually. [ENUM-REF-CANDIDATE: standard|PPR|half_PPR|dynasty|DFS|keeper|IDP — promote to reference product]',
    `scoring_period_type` STRING COMMENT 'The frequency at which fantasy points are tallied and matchup results are determined. Weekly is standard for NFL; daily is common for NBA and MLB; season_long accumulates points across the full season.. Valid values are `weekly|daily|season_long`',
    `season_end_date` DATE COMMENT 'The calendar date on which the fantasy leagues season concludes, including playoffs. After this date, final standings are locked and prize distribution is triggered.',
    `season_start_date` DATE COMMENT 'The calendar date on which the fantasy leagues regular season competition begins. Aligns with the real-world sport season opener and governs the first scoring period.',
    `sport` STRING COMMENT 'The professional sport governing the fantasy leagues player pool, scoring rules, and roster positions. Determines which athlete statistics feed into scoring calculations. [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|PGA|NASCAR|UFC|OTHER — promote to reference product]',
    `starter_count` STRING COMMENT 'Number of active (starting) roster slots that score points each week. Excludes bench slots. Critical for lineup optimization analytics.',
    `team_count` STRING COMMENT 'The configured number of team slots in the league. Determines bracket structure, waiver order, and playoff seeding. Typical values range from 8 to 16 for standard leagues.',
    `trade_deadline_date` DATE COMMENT 'The last calendar date on which team managers may execute player trades between teams. After this date, rosters are locked for the remainder of the season.',
    `trade_review_type` STRING COMMENT 'The process by which proposed trades are reviewed and approved or vetoed. Commissioner review gives sole authority to the commissioner; league_vote requires a majority of managers to approve; auto_approve processes trades immediately; none disables trading.. Valid values are `commissioner|league_vote|auto_approve|none`',
    `waiver_type` STRING COMMENT 'The mechanism governing how unclaimed free-agent players are acquired during the season. FAAB (Free Agent Acquisition Budget) uses a blind bidding system; rolling assigns priority by last waiver claim; reverse_standings gives priority to lower-ranked teams; none allows immediate free-agent pickups.. Valid values are `FAAB|rolling|reverse_standings|none`',
    CONSTRAINT pk_fantasy_league PRIMARY KEY(`fantasy_league_id`)
) COMMENT 'Master record for each fantasy sports league instance — public, private, and corporate leagues across NFL, NBA, MLB, NHL, and other sports. Captures league name, sport, season, scoring format (standard, PPR, half-PPR, dynasty, DFS), draft type (snake, auction, auto-pick), roster configuration, entry fee, prize pool structure, commissioner account ID, league status (forming, active, completed), and platform (DraftKings, FanDuel, proprietary). SSOT for fantasy league definitions.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` (
    `fantasy_roster_id` BIGINT COMMENT 'Unique surrogate identifier for a fantasy roster record within the gaming domain. Serves as the primary key for this transactional entity capturing a fantasy teams active roster at a point in time.',
    `competition_round_id` BIGINT COMMENT 'Foreign key linking to event.competition_round. Business justification: Fantasy rosters are locked per competition round (NFL week, NBA game week). Roster lock timestamps, waiver processing, and scoring period boundaries are defined by competition_round. roster_week is a ',
    `eligibility_status_id` BIGINT COMMENT 'Foreign key linking to athlete.eligibility_status. Business justification: Fantasy roster validity depends on athlete eligibility (suspensions, bans, transfer restrictions). Direct FK to eligibility_status enables automated enforcement of league-imposed ineligibility on fant',
    `fantasy_league_id` BIGINT COMMENT 'Reference to the fantasy league in which this roster exists. Determines the scoring rules, roster size limits, and waiver priority applicable to this record.',
    `fantasy_team_id` BIGINT COMMENT 'Reference to the fantasy team that owns this roster. Links the roster record to the managing team entity within the fantasy league platform.',
    `injury_record_id` BIGINT COMMENT 'Foreign key linking to athlete.injury_record. Business justification: Fantasy IR slot assignment and lineup lock decisions are driven by athlete injury records. Direct FK to injury_record replaces denormalized real_world_injury_status, enabling automated IR eligibility ',
    `previous_fantasy_roster_id` BIGINT COMMENT 'Self-referencing FK on fantasy_roster (previous_fantasy_roster_id)',
    `athlete_profile_id` BIGINT COMMENT 'Reference to the rostered athlete occupying this roster slot. Links to the athlete master record for performance statistics, injury status, and eligibility validation.',
    `roster_id` BIGINT COMMENT 'Foreign key linking to athlete.roster. Business justification: Fantasy roster eligibility validation requires real-world roster slot, position, and activation status. Direct FK to athlete.roster replaces denormalized athlete_real_team_code and athlete_real_positi',
    `suspension_record_id` BIGINT COMMENT 'Foreign key linking to athlete.suspension_record. Business justification: Suspended athletes are ineligible for fantasy starting lineups per platform rules. Direct FK to suspension_record enables automated suspension-based lineup enforcement and provides audit trail linking',
    `trade_transaction_id` BIGINT COMMENT 'Reference to the trade transaction record through which this athlete was acquired, applicable when acquisition_type is trade. Links to the trade history for multi-party trade auditing and commissioner review.',
    `acquisition_date` DATE COMMENT 'The calendar date on which the fantasy team officially acquired this athlete onto their roster. Used for waiver priority calculations, trade dispute resolution, and roster history auditing.',
    `acquisition_type` STRING COMMENT 'The method by which the fantasy team acquired this athlete onto their roster. Supports waiver processing audits, trade history reporting, and draft analytics.. Valid values are `drafted|waiver|trade|free_agent|keeper|supplemental_draft`',
    `auction_draft_price` DECIMAL(18,2) COMMENT 'The winning bid amount paid for this athlete during an auction-style fantasy draft, applicable when acquisition_type is drafted in auction format leagues. Used for auction value analytics and budget management reporting.',
    `commissioner_override` BOOLEAN COMMENT 'Indicates whether a league commissioner manually overrode the standard roster rules to create or modify this roster record (e.g., reversing an invalid trade, correcting a system error). Supports audit trails for commissioner actions.',
    `commissioner_override_notes` STRING COMMENT 'Free-text notes entered by the league commissioner explaining the rationale for any manual roster override. Populated only when commissioner_override is true. Supports dispute resolution and audit documentation.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this fantasy roster record was first created in the system. Serves as the audit trail creation marker for data lineage and compliance reporting.',
    `draft_pick_number` STRING COMMENT 'The overall pick number within the fantasy draft at which this athlete was selected. Null for non-draft acquisitions. Used for draft analytics, ADP (Average Draft Position) benchmarking, and draft value reporting.',
    `draft_round` STRING COMMENT 'The round number in which this athlete was selected during the fantasy draft, applicable when acquisition_type is drafted or supplemental_draft. Null for waiver, trade, and free agent acquisitions.',
    `drop_date` DATE COMMENT 'The calendar date on which this athlete was dropped from the fantasy teams roster, releasing them to the waiver wire or free agent pool. Null if the athlete is currently rostered. Supports roster history and waiver wire availability tracking.',
    `drop_reason` STRING COMMENT 'The reason code explaining why this athlete was removed from the fantasy roster. Supports waiver wire analytics, commissioner dispute resolution, and roster management pattern analysis.. Valid values are `voluntary|trade_outgoing|commissioner_action|season_end|ir_replacement`',
    `effective_from` TIMESTAMP COMMENT 'The timestamp from which this roster slot assignment became effective. Supports bi-temporal modeling for point-in-time roster reconstruction and audit compliance.',
    `effective_until` TIMESTAMP COMMENT 'The timestamp at which this roster slot assignment ceased to be effective. Null indicates the record is currently active. Supports bi-temporal modeling and historical roster queries.',
    `is_ir_eligible` BOOLEAN COMMENT 'Indicates whether this athlete currently qualifies for placement on the fantasy teams Injured Reserve (IR) slot based on their real-world injury designation (e.g., IR, PUP, Out). Enables roster management without dropping injured players.',
    `is_starting_lineup` BOOLEAN COMMENT 'Indicates whether this athlete is designated in the active starting lineup (true) or on the bench (false) for the current scoring period. Determines whether the athletes real-world performance scores points for the fantasy team.',
    `jurisdiction_code` STRING COMMENT 'The regulatory jurisdiction code (ISO 3166-1 alpha-2 or alpha-3 state/province code) in which the fantasy team manager is located. Required for gaming regulatory compliance, responsible gaming enforcement, and jurisdictional eligibility validation.. Valid values are `^[A-Z]{2,3}$`',
    `keeper_cost_round` STRING COMMENT 'The draft round cost assigned to retaining this athlete as a keeper in the subsequent seasons draft. Applicable in keeper leagues; null for non-keeper acquisitions.',
    `keeper_year` STRING COMMENT 'The season year in which this athlete was designated as a keeper, applicable in keeper or dynasty league formats where acquisition_type is keeper. Tracks multi-year keeper eligibility and cost escalation rules.',
    `league_format` STRING COMMENT 'The format type of the fantasy league governing this roster record. Determines applicable roster rules, keeper eligibility, salary cap applicability, and scoring configurations.. Valid values are `redraft|keeper|dynasty|daily_fantasy|best_ball`',
    `lineup_change_count` STRING COMMENT 'The number of times this roster slot has been modified (athlete swapped in or out) during the current scoring period prior to roster lock. Used for engagement analytics and lineup activity monitoring.',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this roster record is associated with a fantasy team manager who has an active responsible gaming restriction, self-exclusion, or spend limit in place. Triggers compliance workflows and restricts certain roster actions.',
    `roster_lock_timestamp` TIMESTAMP COMMENT 'The precise date and time at which this roster configuration was locked for the scoring period, preventing further lineup changes. Critical for dispute resolution and lineup integrity enforcement.',
    `roster_reference_code` STRING COMMENT 'Externally-known alphanumeric business identifier for this roster record, used in API responses, waiver processing confirmations, and fan-facing lineup management interfaces.. Valid values are `^FRST-[A-Z0-9]{6,12}$`',
    `roster_slot_position` STRING COMMENT 'The designated roster slot position label assigned to this athlete entry (e.g., QB, RB, WR, TE, FLEX, K, DEF, SP, RP, C, PG, SG, SF, PF, G, F, UTIL). Governs lineup eligibility and scoring rules per slot. [ENUM-REF-CANDIDATE: QB|RB|WR|TE|FLEX|K|DEF|SP|RP|C|PG|SG|SF|PF|G|F|UTIL|BN|IR — promote to reference product]',
    `roster_status` STRING COMMENT 'Current lifecycle state of this roster record. active indicates the current valid roster; locked indicates the lineup is frozen for scoring; pending indicates a transaction is in progress; cancelled indicates a voided transaction; historical indicates a past-period snapshot.. Valid values are `active|locked|pending|cancelled|historical`',
    `salary_cap_value` DECIMAL(18,2) COMMENT 'The salary cap dollar amount assigned to this athlete on the fantasy teams roster, applicable in salary cap or auction draft league formats. Contributes to the teams total salary cap utilization tracking.',
    `scoring_period_end_date` DATE COMMENT 'The end date of the fantasy scoring period to which this roster record applies. Together with scoring_period_start_date, defines the exact window for which this roster configuration is valid.',
    `scoring_period_start_date` DATE COMMENT 'The start date of the fantasy scoring period (week, day, or matchup period) to which this roster record applies. Used for period-based scoring calculations and historical roster snapshots.',
    `season_year` STRING COMMENT 'The calendar year of the sports season to which this roster record belongs (e.g., 2024). Enables multi-season roster history and year-over-year analytics.',
    `slot_type` STRING COMMENT 'Classification of the roster slot indicating whether the athlete is in an active starting lineup, on the bench, on the injured reserve (IR) list, taxi squad, or practice squad. Determines scoring eligibility for the week.. Valid values are `starter|bench|injured_reserve|taxi_squad|practice_squad`',
    `source_platform` STRING COMMENT 'The platform or channel through which the roster action (acquisition, lineup change, drop) was initiated. Supports fan engagement analytics, platform adoption reporting, and Adobe Experience Platform personalization.. Valid values are `web|mobile_ios|mobile_android|api|commissioner_tool`',
    `sport_type` STRING COMMENT 'The professional sport to which this fantasy roster belongs. Determines position eligibility rules, scoring categories, and real-world data feed integration requirements. [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|PGA|NASCAR|UFC — 8 candidates stripped; promote to reference product]',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to this fantasy roster record. Used for change tracking, incremental data pipeline processing, and audit compliance.',
    `waiver_claim_priority` STRING COMMENT 'The waiver wire priority order of the fantasy team at the time this athlete was claimed via waiver, applicable when acquisition_type is waiver. Lower values indicate higher priority. Used for waiver dispute resolution and fairness auditing.',
    `waiver_claim_timestamp` TIMESTAMP COMMENT 'The precise timestamp at which the waiver claim for this athlete was submitted by the fantasy team manager. Applicable when acquisition_type is waiver. Used for claim ordering and dispute resolution.',
    CONSTRAINT pk_fantasy_roster PRIMARY KEY(`fantasy_roster_id`)
) COMMENT 'Transactional record of a fantasy teams active roster at a point in time within a fantasy league season. Captures fantasy team ID, fantasy league ID, roster week/period, each rostered athlete slot (QB, RB, WR, FLEX, etc.), athlete ID, acquisition type (drafted, waiver, trade, free agent pickup), acquisition date, and roster lock timestamp. Supports weekly lineup management, waiver processing, and season-long roster history.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` (
    `fantasy_team_id` BIGINT COMMENT 'Unique surrogate identifier for each fantasy team record. Primary key for the fantasy_team entity. Serves as the system-of-record identifier across all downstream fantasy gaming analytics and reporting.',
    `division_id` BIGINT COMMENT 'Reference to the sub-division within the fantasy league to which this team is assigned. Applicable in leagues with divisional structures. Scopes head-to-head scheduling and divisional standings.',
    `fantasy_league_id` BIGINT COMMENT 'Foreign key linking to gaming.fantasy_league. Business justification: Fantasy teams exist within fantasy league instances (gaming domain). Currently fantasy_team only has league_id pointing to league.league (cross-domain), but lacks the in-domain FK to fantasy_league. A',
    `league_id` BIGINT COMMENT 'Reference to the fantasy league in which this team participates. Establishes the competitive context, scoring rules, and roster constraints applicable to this team.',
    `predecessor_fantasy_team_id` BIGINT COMMENT 'Self-referencing FK on fantasy_team (predecessor_fantasy_team_id)',
    `bettor_account_id` BIGINT COMMENT 'Reference to the licensed bettor/player account that owns and manages this fantasy team. Links to the registered gaming account for responsible gaming monitoring, KYC compliance, and regulatory reporting.',
    `season_id` BIGINT COMMENT 'Reference to the competitive season for which this fantasy team is registered. Scopes standings, scoring, and roster eligibility to the correct season context.',
    `auction_budget` DECIMAL(18,2) COMMENT 'The total virtual currency budget allocated to this team for auction-style drafts. Applicable only when draft_type is auction. Tracks the starting cap for athlete bidding.',
    `auction_budget_spent` DECIMAL(18,2) COMMENT 'The total virtual currency spent by this team during the auction draft. Used to calculate remaining budget and validate draft compliance. Applicable only when draft_type is auction.',
    `autopick_enabled` BOOLEAN COMMENT 'Indicates whether the platforms automated lineup optimization is enabled for this team. When true, the system sets the optimal starting lineup based on projected points if the manager does not manually set it before the deadline.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when this fantasy team record was first created in the platform. Supports audit trail requirements, data lineage, and SOX financial controls for gaming revenue attribution.',
    `draft_position` STRING COMMENT 'The pick order assigned to this team in the fantasy leagues draft. Determines the sequence in which the team selects athletes during the draft event. Lower numbers indicate earlier selection priority.',
    `draft_type` STRING COMMENT 'The format of the draft used to populate this teams initial roster. snake reverses order each round; auction uses a budget-based bidding system; linear maintains consistent order; autopick is system-automated.. Valid values are `snake|auction|linear|autopick`',
    `email_notification_enabled` BOOLEAN COMMENT 'Indicates whether the team owner has opted in to receive email notifications for league events such as waiver results, trade proposals, and scoring updates. Supports GDPR and CCPA consent management.',
    `faab_budget` DECIMAL(18,2) COMMENT 'The Free Agent Acquisition Budget (FAAB) allocated to this team for blind-bid waiver claims. Applicable in leagues using FAAB waiver systems. Tracks the starting budget for the season.',
    `faab_remaining` DECIMAL(18,2) COMMENT 'The remaining Free Agent Acquisition Budget (FAAB) balance available for future waiver claims. Decremented with each successful blind-bid claim. Applicable in FAAB waiver leagues.',
    `jurisdiction_code` STRING COMMENT 'ISO 3166-1 alpha-2 or alpha-3 code identifying the regulatory jurisdiction under which this fantasy teams gaming activity is licensed and reported. Required for multi-jurisdictional regulatory reporting to gaming control boards.. Valid values are `^[A-Z]{2,3}$`',
    `last_activity_timestamp` TIMESTAMP COMMENT 'The most recent timestamp at which the team owner performed any action (lineup change, waiver claim, trade, login). Used for inactive team detection, responsible gaming monitoring, and engagement analytics.',
    `logo_url` STRING COMMENT 'URL pointing to the teams custom logo image stored in the Digital Asset Management (DAM) system or Content Delivery Network (CDN). Used for display in league interfaces, mobile apps, and broadcast overlays.. Valid values are `^https?://.+$`',
    `losses` STRING COMMENT 'Total number of head-to-head matchup losses accumulated by this team in the current season. Used for standings calculation and playoff seeding.',
    `manager_display_name` STRING COMMENT 'The public-facing display name of the team owner/manager as shown to other league participants. Distinct from the bettors legal name; may be a username or alias per platform privacy settings.',
    `playoff_qualified` BOOLEAN COMMENT 'Indicates whether this team has clinched a playoff berth in the current season. True when the team meets the leagues qualification criteria based on record and standings.',
    `playoff_seed` STRING COMMENT 'The seeding position assigned to this team upon qualifying for the fantasy league playoffs. Null if the team has not yet qualified. Determines bracket placement and bye-week eligibility.',
    `points_against` DECIMAL(18,2) COMMENT 'Cumulative fantasy points scored by opponents against this team across all completed scoring periods. Used as a secondary tiebreaker in standings and for strength-of-schedule analytics.',
    `points_scored` DECIMAL(18,2) COMMENT 'Cumulative fantasy points scored by this team across all completed scoring periods in the current season. Season-to-date figure used for standings tiebreakers and leaderboard rankings.',
    `primary_color_hex` STRING COMMENT 'Hexadecimal color code representing the teams primary brand color. Used for UI theming, scorecard rendering, and personalized fan engagement displays.. Valid values are `^#[0-9A-Fa-f]{6}$`',
    `push_notification_enabled` BOOLEAN COMMENT 'Indicates whether the team owner has opted in to receive mobile push notifications for real-time scoring updates, injury alerts, and waiver wire activity. Supports GDPR and CCPA consent management.',
    `registration_date` DATE COMMENT 'The calendar date on which this fantasy team was officially registered and activated within the league. Used for audit trails, season eligibility verification, and regulatory reporting.',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this teams owner account has an active responsible gaming restriction, self-exclusion, or spend limit in place. When true, certain platform features may be restricted per regulatory requirements.',
    `sport_type` STRING COMMENT 'The professional sport governing body or league context for which this fantasy team is constructed. Determines eligible athlete pool, scoring categories, and applicable CBA rules. [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|ATP|UFC|FIFA|other — promote to reference product]',
    `standing_rank` STRING COMMENT 'Current ordinal rank of this team within its division or league based on wins, losses, ties, and points scored. Updated after each scoring period. Used for playoff qualification determination.',
    `team_abbreviation` STRING COMMENT 'Short alphanumeric code (2–6 characters) representing the team in compact displays such as scoreboards, mobile notifications, and broadcast overlays.. Valid values are `^[A-Z0-9]{2,6}$`',
    `team_name` STRING COMMENT 'User-defined display name for the fantasy team as shown in league standings, leaderboards, and fan engagement platforms. Subject to content moderation policies.',
    `team_slogan` STRING COMMENT 'Optional user-defined tagline or motto for the fantasy team. Displayed on team profile pages and league communications. Subject to content moderation policies.',
    `team_status` STRING COMMENT 'Current lifecycle status of the fantasy team within its league. active indicates the team is in good standing and participating; suspended indicates a responsible gaming or compliance hold; withdrawn indicates the owner has exited the league.. Valid values are `active|inactive|suspended|pending|withdrawn`',
    `ties` STRING COMMENT 'Total number of head-to-head matchup ties accumulated by this team in the current season. Relevant in leagues where tie-breaking rules apply to standings.',
    `trade_block_status` BOOLEAN COMMENT 'Indicates whether the team owner has flagged this teams athletes as available for trade negotiations. True signals that the owner is actively seeking trade offers, enabling targeted trade proposals from other managers.',
    `trades_accepted` STRING COMMENT 'Total number of trade transactions accepted by this team in the current season. Used for trade activity monitoring and collusion detection under responsible gaming compliance.',
    `trades_vetoed` STRING COMMENT 'Total number of trade proposals involving this team that were vetoed by the league commissioner or league vote. Supports collusion investigation and league integrity monitoring.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp recording the most recent modification to this fantasy team record. Used for incremental data pipeline processing, change data capture, and audit compliance.',
    `waiver_claims_used` STRING COMMENT 'Total number of waiver wire claims exercised by this team in the current season. Used to enforce per-season claim limits where applicable under league rules.',
    `waiver_priority` STRING COMMENT 'The teams current priority position in the waiver wire queue. Lower numbers indicate higher priority for claiming available athletes. Resets or adjusts based on league waiver rules after each claim.',
    `wins` STRING COMMENT 'Total number of head-to-head matchup wins accumulated by this team in the current season. Used for standings calculation and playoff seeding.',
    CONSTRAINT pk_fantasy_team PRIMARY KEY(`fantasy_team_id`)
) COMMENT 'Master record for each fantasy team registered within a fantasy league. Captures team name, owner bettor account ID, league ID, draft position, total points scored (season-to-date), wins/losses/ties record, waiver priority, trade block status, and team logo/branding. Distinct from fantasy_league (the league definition) and fantasy_roster (the weekly lineup). SSOT for fantasy team identity and season-long standings.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`wallet` (
    `wallet_id` BIGINT COMMENT 'Unique surrogate identifier for the gaming wallet ledger record. Primary key for this entity.',
    `bettor_account_id` BIGINT COMMENT 'Reference to the bettors registered gaming account that owns this wallet. Each bettor account holds exactly one active wallet per currency.',
    `consolidated_from_wallet_id` BIGINT COMMENT 'Self-referencing FK on wallet (consolidated_from_wallet_id)',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Wallet liability balances are snapshotted at period-end for balance sheet reporting and regulatory compliance. Finance reconciles aggregate wallet balances (deferred revenue/player funds liability) ag',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Gaming wallet balances (real_money_balance, bonus_credit_balance) are financial liabilities that must map to GL accounts for balance sheet reporting. This link enables accurate liability recognition a',
    `jurisdiction_id` BIGINT COMMENT 'Reference to the licensed gaming jurisdiction under which this wallet operates (e.g., Nevada, New Jersey, UK Gambling Commission). Drives regulatory reporting, tax withholding rules, and responsible gaming limits.',
    `payment_method_id` BIGINT COMMENT 'Foreign key linking to fan.payment_method. Business justification: Gaming wallet deposits are funded via fan-stored payment methods. This link enables deposit reconciliation, fraud detection (same card funding multiple wallets), and PCI compliance reporting — all sta',
    `aml_risk_rating` STRING COMMENT 'Anti-Money Laundering (AML) risk classification assigned to this wallet based on transaction patterns, deposit sources, and bettor profile. Drives enhanced due diligence (EDD) requirements and regulatory reporting thresholds.. Valid values are `low|medium|high|very_high`',
    `bonus_credit_balance` DECIMAL(18,2) COMMENT 'Current balance of promotional bonus credits awarded to the bettor (e.g., free-bet credits, deposit match bonuses, loyalty rewards). Bonus credits are subject to wagering requirements before conversion to withdrawable funds.',
    `bonus_wagering_progress_amount` DECIMAL(18,2) COMMENT 'Cumulative wagering amount applied toward satisfying the current bonus wagering requirement. When this value reaches (bonus_credit_balance × bonus_wagering_requirement_multiplier), the bonus converts to withdrawable funds.',
    `bonus_wagering_requirement_multiplier` DECIMAL(18,2) COMMENT 'The rollover multiplier applied to bonus credits before they can be converted to withdrawable real-money funds (e.g., 5x means the bettor must wager 5 times the bonus amount). Drives bonus liability calculations.',
    `close_date` DATE COMMENT 'Calendar date on which the gaming wallet was permanently closed. NULL for active wallets. Required for regulatory reporting and unclaimed property escheatment calculations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this gaming wallet record was first created in the platform ledger system. Serves as the audit trail creation marker for the Silver layer record.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code denominating all monetary balances in this wallet (e.g., USD, GBP, EUR, CAD). A bettor may hold separate wallets per currency.. Valid values are `^[A-Z]{3}$`',
    `deposit_limit_daily` DECIMAL(18,2) COMMENT 'Maximum real-money deposit amount permitted within a rolling 24-hour period for this wallet, as set by the bettor or enforced by the operator under responsible gaming obligations. NULL indicates no limit is set.',
    `deposit_limit_monthly` DECIMAL(18,2) COMMENT 'Maximum real-money deposit amount permitted within a rolling 30-day period for this wallet. Regulators in many jurisdictions mandate operators to offer and honor monthly deposit limits.',
    `deposit_limit_weekly` DECIMAL(18,2) COMMENT 'Maximum real-money deposit amount permitted within a rolling 7-day period for this wallet. Part of the responsible gaming self-exclusion and limit-setting framework.',
    `dormancy_date` DATE COMMENT 'Date on which the wallet was classified as dormant. Used to calculate escheatment timelines and trigger unclaimed property reporting to state authorities.',
    `dormancy_flag` BOOLEAN COMMENT 'Indicates whether the wallet has been classified as dormant due to inactivity beyond the operator-defined dormancy threshold (typically 12 months with no transactions). Dormant wallets may be subject to inactivity fees or unclaimed property escheatment.',
    `geolocation_compliance_flag` BOOLEAN COMMENT 'Indicates whether the bettors most recent session passed geolocation verification confirming they were physically located within a licensed jurisdiction at the time of wagering. True = compliant; False = geolocation check failed or bypassed.',
    `kyc_verified_flag` BOOLEAN COMMENT 'Indicates whether the bettors identity has been fully verified through the Know Your Customer (KYC) process. True = verified; False = pending or failed. Unverified wallets may have restricted deposit and withdrawal capabilities.',
    `last_deposit_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent real-money deposit credited to this wallet. Used for dormancy analysis, responsible gaming velocity checks, and AML monitoring.',
    `last_transaction_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent financial transaction (deposit, withdrawal, wager placement, wager settlement, bonus credit) recorded against this wallet. Used for dormancy detection and responsible gaming monitoring.',
    `last_withdrawal_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent withdrawal processed from this wallet. Used for dormancy analysis and AML monitoring.',
    `lifetime_bonus_awarded_amount` DECIMAL(18,2) COMMENT 'Cumulative total of all promotional bonus credits ever awarded to this wallet. Used for marketing ROI analysis, bonus liability reporting, and responsible gaming assessments.',
    `lifetime_deposit_amount` DECIMAL(18,2) COMMENT 'Cumulative total of all real-money deposits made into this wallet since account creation. Used for responsible gaming monitoring, AML thresholds, and regulatory reporting.',
    `lifetime_withdrawal_amount` DECIMAL(18,2) COMMENT 'Cumulative total of all real-money withdrawals processed from this wallet since account creation. Used for AML monitoring, tax reporting (e.g., IRS Form W-2G), and responsible gaming analytics.',
    `loss_limit_daily` DECIMAL(18,2) COMMENT 'Maximum net loss amount permitted within a rolling 24-hour period for this wallet. When reached, further wagering is blocked until the period resets. Supports responsible gaming mandates.',
    `open_date` DATE COMMENT 'Calendar date on which the gaming wallet was first opened and activated for the bettor account. Used for tenure analysis, regulatory reporting, and responsible gaming lifecycle tracking.',
    `operator_freeze_reason` STRING COMMENT 'Reason code for an operator-initiated wallet freeze or suspension. Required for audit trail and regulatory reporting when wallet_status is frozen or suspended. [ENUM-REF-CANDIDATE: aml_investigation|fraud_review|regulatory_order|chargeback_dispute|responsible_gaming|other — promote to reference product]. Valid values are `aml_investigation|fraud_review|regulatory_order|chargeback_dispute|responsible_gaming|other`',
    `pending_hold_amount` DECIMAL(18,2) COMMENT 'Total amount currently reserved (held) against the real-money balance for open/unsettled wagers. Funds are released back to real_money_balance upon wager settlement or cancellation.',
    `preferred_odds_format` STRING COMMENT 'Bettors preferred display format for betting odds on this wallets associated platform. Stored at wallet level to support personalized UX across jurisdictions.. Valid values are `american|decimal|fractional|hong_kong|indonesian`',
    `real_money_balance` DECIMAL(18,2) COMMENT 'Current spendable real-money balance in the wallet denominated in currency_code. Represents deposited funds net of withdrawals, settled wager losses, and fees. Excludes bonus credits and pending holds.',
    `reference_number` STRING COMMENT 'Externally visible alphanumeric reference number for the gaming wallet, used in customer communications, support tickets, and regulatory filings. Distinct from the internal surrogate key.. Valid values are `^GW-[A-Z0-9]{10,20}$`',
    `reserved_withdrawal_amount` DECIMAL(18,2) COMMENT 'Amount currently reserved for a pending withdrawal request that has been initiated but not yet processed or cleared by the payment processor. Reduces available withdrawable_balance.',
    `self_exclusion_end_date` DATE COMMENT 'Date on which the bettors self-exclusion period expires and the wallet may be reactivated, subject to a mandatory cooling-off review. NULL if self-exclusion is permanent or not active.',
    `self_exclusion_flag` BOOLEAN COMMENT 'Indicates whether the bettor has voluntarily enrolled in a self-exclusion program, prohibiting all wagering activity on this wallet. True = self-excluded; False = not self-excluded. Triggers immediate wallet suspension.',
    `session_time_limit_minutes` STRING COMMENT 'Maximum continuous gaming session duration in minutes before the bettor is prompted to take a break or is automatically logged out. Responsible gaming control set by bettor or operator.',
    `source_system_code` STRING COMMENT 'Code identifying the operational gaming platform or system of record from which this wallet record originates (e.g., SPORTSBOOK_PLATFORM, FANTASY_ENGINE). Supports data lineage and multi-platform reconciliation in the lakehouse.. Valid values are `^[A-Z0-9_]{2,30}$`',
    `tax_withholding_flag` BOOLEAN COMMENT 'Indicates whether federal or state tax withholding is currently applied to winnings paid out from this wallet (e.g., IRS backup withholding for bettors who have not provided a valid TIN). True = withholding active.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this gaming wallet record in the platform ledger. Used for change data capture (CDC), audit trails, and Silver layer incremental processing.',
    `wager_limit_daily` DECIMAL(18,2) COMMENT 'Maximum total wagering stake permitted within a rolling 24-hour period for this wallet. Enforced at bet placement to support responsible gaming compliance.',
    `wallet_status` STRING COMMENT 'Current operational lifecycle state of the gaming wallet. active = fully operational; suspended = temporarily restricted by operator or regulator; frozen = locked pending investigation or AML review; closed = permanently deactivated; pending_verification = KYC/AML checks incomplete.. Valid values are `active|suspended|frozen|closed|pending_verification`',
    `wallet_type` STRING COMMENT 'Classification of the wallet by gaming product line. Determines which bet types, markets, and regulatory rules apply. [ENUM-REF-CANDIDATE: sports_wagering|fantasy_sports|casino|poker|combined — promote to reference product if additional types emerge]. Valid values are `sports_wagering|fantasy_sports|casino|poker|combined`',
    `withdrawable_balance` DECIMAL(18,2) COMMENT 'Portion of the real-money balance that has met all wagering requirements and regulatory hold periods and is eligible for withdrawal to the bettors registered payment method. May be less than or equal to real_money_balance.',
    CONSTRAINT pk_wallet PRIMARY KEY(`wallet_id`)
) COMMENT 'Financial ledger record for each bettor accounts gaming wallet — tracking real-money balance, bonus balance, withdrawable balance, pending wager holds, and lifetime deposit/withdrawal totals. Captures wallet ID, bettor account ID, currency, current real-money balance, bonus credit balance, pending hold amount, last transaction timestamp, and wallet status. Distinct from fan.payment_method (stored payment instruments) — this is the in-platform gaming funds ledger.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` (
    `jurisdiction_id` BIGINT COMMENT 'Unique surrogate identifier for each gaming regulatory jurisdiction record. Primary key for the gaming_jurisdiction reference master.',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Gaming jurisdictions are regulated by governing bodies tracked in compliance (e.g., Nevada Gaming Control Board, UKGC). Linking enables jurisdiction-level regulatory obligation tracking, audit schedul',
    `parent_jurisdiction_id` BIGINT COMMENT 'Self-referencing FK on jurisdiction (parent_jurisdiction_id)',
    `aml_reporting_threshold` DECIMAL(18,2) COMMENT 'Monetary threshold (in jurisdiction currency) above which a single wagering transaction or cumulative patron activity must be reported to the regulatory authority under Anti-Money Laundering (AML) requirements (e.g., USD 10,000 per FinCEN CTR rules). Null if no statutory threshold applies.',
    `application_submission_date` DATE COMMENT 'Date on which Sports Entertainment submitted the initial or renewal license application to the regulatory authority. Used to track application pipeline and regulatory processing timelines.',
    `college_sports_wagering_permitted` BOOLEAN COMMENT 'Indicates whether wagering on college and university sporting events is permitted in this jurisdiction. Several jurisdictions prohibit wagering on in-state college teams or all college sports. True = college sports wagering authorized; False = prohibited.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code for the sovereign nation in which this jurisdiction resides (e.g., USA, GBR, CAN, AUS). Supports geographic segmentation and cross-border regulatory analysis.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the legal tender used in this jurisdiction for wagering, tax remittance, and financial reporting (e.g., USD, GBP, CAD, AUD, EUR).. Valid values are `^[A-Z]{3}$`',
    `data_localization_required` BOOLEAN COMMENT 'Indicates whether the jurisdiction mandates that patron data and wagering transaction records must be stored within the geographic boundaries of the jurisdiction. True = data must remain in-jurisdiction; False = no localization requirement. Impacts cloud infrastructure and data residency architecture.',
    `deposit_limit_required` BOOLEAN COMMENT 'Indicates whether the jurisdiction mandates that operators offer or enforce patron deposit limits as part of responsible gaming compliance. True = deposit limits are a regulatory requirement; False = not mandated.',
    `dfs_permitted` BOOLEAN COMMENT 'Indicates whether Daily Fantasy Sports (DFS) contests are legally permitted in this jurisdiction. True = DFS authorized; False = not authorized. Drives DFS product availability and platform configuration.',
    `geolocation_required` BOOLEAN COMMENT 'Indicates whether real-time geolocation verification is required to confirm the patron is physically located within the jurisdiction at the time of wagering. True = geolocation check mandatory; False = not required.',
    `ggr_tax_rate` DECIMAL(18,2) COMMENT 'Statutory tax rate applied to Gross Gaming Revenue (GGR) in this jurisdiction, expressed as a decimal percentage (e.g., 0.1300 = 13%). GGR is defined as total wagers accepted minus winnings paid to players. Used in financial planning, P&L modeling, and tax remittance calculations.',
    `in_play_wagering_permitted` BOOLEAN COMMENT 'Indicates whether in-play (live) wagering on ongoing sporting events is permitted in this jurisdiction. Some jurisdictions restrict wagering to pre-game markets only. True = in-play wagering authorized; False = pre-game only.',
    `integrity_fee_rate` DECIMAL(18,2) COMMENT 'Rate (expressed as a decimal percentage of handle or GGR) payable to sports leagues or governing bodies as a sports integrity fee or data royalty mandated by the jurisdiction (e.g., 0.0025 = 0.25%). Null if no integrity fee is required. Relevant for NFL, NBA, MLB, NHL, MLS league data agreements.',
    `jurisdiction_code` STRING COMMENT 'Standardized short code uniquely identifying the jurisdiction (e.g., US-NJ for New Jersey, US-NV for Nevada, GB for Great Britain, ON for Ontario). Used as the business-facing key across compliance configuration and reporting systems.. Valid values are `^[A-Z]{2,6}$`',
    `jurisdiction_name` STRING COMMENT 'Full legal name of the gaming regulatory jurisdiction (e.g., State of New Jersey, Province of Ontario, United Kingdom). Used in regulatory filings, compliance reports, and operator-facing documentation.',
    `kyc_required` BOOLEAN COMMENT 'Indicates whether Know Your Customer (KYC) identity verification is mandated by the regulatory authority before a patron may place wagers in this jurisdiction. True = KYC mandatory; False = KYC not required.',
    `launch_date` DATE COMMENT 'Date on which Sports Entertainment commenced live wagering operations in this jurisdiction following license activation. Null if operations have not yet launched (e.g., license is pending). Used for market entry tracking and revenue attribution.',
    `max_single_wager_limit` DECIMAL(18,2) COMMENT 'Maximum monetary amount (in jurisdiction currency) permitted for a single wager as mandated by the regulatory authority. Null if no statutory cap exists. Used to configure wagering platform risk controls and patron-facing bet limits.',
    `min_age_requirement` STRING COMMENT 'Minimum legal age (in years) required for a patron to participate in sports wagering or fantasy sports in this jurisdiction (e.g., 18 or 21). Enforced at account registration and KYC verification.',
    `notes` STRING COMMENT 'Free-text field for compliance team annotations regarding jurisdiction-specific regulatory nuances, pending legislative changes, special conditions attached to the license, or operational constraints not captured in structured fields.',
    `official_data_mandate` BOOLEAN COMMENT 'Indicates whether the jurisdiction requires operators to use official league-supplied data feeds for in-play wagering markets (as opposed to third-party data providers). True = official data required; False = no mandate. Impacts data vendor contracts and API integration requirements.',
    `online_wagering_permitted` BOOLEAN COMMENT 'Indicates whether online and mobile sports wagering is permitted in this jurisdiction, as distinct from retail (in-person) wagering. True = online/mobile wagering authorized; False = retail only.',
    `promotional_deduction_allowed` BOOLEAN COMMENT 'Indicates whether the jurisdiction permits deduction of promotional credits and free-play bonuses from gross gaming revenue before calculating the taxable GGR base. True = deductions permitted; False = gross revenue taxed without promotional deductions.',
    `prop_bet_permitted` BOOLEAN COMMENT 'Indicates whether proposition bets (prop bets) on individual player or game-specific outcomes are permitted in this jurisdiction. Some jurisdictions restrict prop bets on college athletes or specific leagues. True = prop bets authorized; False = restricted.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this gaming jurisdiction record was first created in the system. Supports audit trail and data lineage requirements.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this gaming jurisdiction record was most recently modified. Used for change detection, incremental data pipeline processing, and audit compliance.',
    `region_or_state` STRING COMMENT 'Name of the sub-national administrative region, state, or province within the country (e.g., New Jersey, Nevada, Ontario, England). Null for country-level jurisdictions. Supports state-level regulatory mapping.',
    `reporting_frequency` STRING COMMENT 'Frequency at which Sports Entertainment must submit regulatory compliance and financial reports to the governing authority in this jurisdiction. Drives automated report generation scheduling.. Valid values are `daily|weekly|monthly|quarterly|annually`',
    `responsible_gaming_mandates` STRING COMMENT 'Free-text description of applicable responsible gaming compliance mandates imposed by the regulatory authority in this jurisdiction, including deposit limits, loss limits, session time limits, cooling-off periods, and problem gambling helpline display requirements.',
    `retail_wagering_permitted` BOOLEAN COMMENT 'Indicates whether retail in-person sports wagering at licensed physical locations (e.g., sportsbooks at venues or casinos) is permitted in this jurisdiction. True = retail wagering authorized; False = not authorized.',
    `self_exclusion_program_name` STRING COMMENT 'Name of the mandatory responsible gaming self-exclusion program administered by the regulatory authority in this jurisdiction (e.g., New Jersey Self-Exclusion Program, GamStop UK). Operators must integrate with this program as a condition of licensure.',
    `sports_wagering_permitted` BOOLEAN COMMENT 'Indicates whether fixed-odds sports wagering is legally permitted in this jurisdiction under the current license. True = sports wagering authorized; False = not authorized. Drives product availability configuration.',
    `suspension_reason` STRING COMMENT 'Free-text description of the reason for license suspension or revocation as communicated by the regulatory authority. Populated only when license_status is suspended or revoked. Used for legal and compliance case management.',
    `tax_remittance_frequency` STRING COMMENT 'Frequency at which GGR tax payments must be remitted to the regulatory authority in this jurisdiction. Drives accounts payable scheduling and cash flow planning in SAP S/4HANA FI/CO.. Valid values are `daily|weekly|monthly|quarterly|annually`',
    CONSTRAINT pk_jurisdiction PRIMARY KEY(`jurisdiction_id`)
) COMMENT 'Reference master for all gaming regulatory jurisdictions in which Sports Entertainment holds or is pursuing a sports wagering or fantasy sports operating license. Captures jurisdiction code, jurisdiction name (state/province/country), license type (sports wagering, DFS, iGaming), regulatory body name, license number, license status (active, pending, suspended, expired), license expiry date, tax rate on gross gaming revenue (GGR), and applicable responsible gaming mandates. SSOT for jurisdiction-level compliance configuration.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` (
    `responsible_gaming_limit_id` BIGINT COMMENT 'Unique surrogate identifier for each responsible gaming limit record configured for a bettor account. Primary key for the responsible_gaming_limit data product in the Silver Layer lakehouse.',
    `bettor_account_id` BIGINT COMMENT 'Identifier of the bettor account to which this responsible gaming limit applies. Links the limit record to the individual wagering account holder.',
    `jurisdiction_id` BIGINT COMMENT 'Identifier of the licensed gaming jurisdiction under which this limit is governed and enforced. Determines applicable regulatory framework and reporting obligations.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Specific responsible gaming limit types (deposit limits, session time limits, loss limits) are mandated by named regulatory obligations. Compliance teams must demonstrate which obligation mandates eac',
    `policy_id` BIGINT COMMENT 'Foreign key linking to compliance.policy. Business justification: Responsible gaming limits (deposit limits, loss limits, session limits) are mandated by and must conform to specific compliance policies (e.g., UKGC mandatory deposit limit policy, NJDGE responsible g',
    `primary_superseded_by_limit_responsible_gaming_limit_id` BIGINT COMMENT 'Self-referencing identifier pointing to the newer responsible_gaming_limit record that replaced this one when a limit was modified or updated. Null if this is the current active limit. Enables full limit history chain reconstruction for regulatory audit.',
    `regulatory_report_id` BIGINT COMMENT 'Foreign key linking to gaming.regulatory_report. Business justification: Responsible gaming limit activations and changes must be reported to gaming regulators in many jurisdictions. responsible_gaming_limit has regulatory_notification_sent (BOOLEAN) and regulatory_notific',
    `activated_timestamp` TIMESTAMP COMMENT 'The exact date and time when this responsible gaming limit transitioned to active status and began enforcement. May differ from requested_timestamp due to mandatory regulatory cooling-off periods before limit reductions take effect.',
    `cooling_off_end_date` DATE COMMENT 'The date on which a mandatory regulatory cooling-off period ends, after which a limit increase or self-exclusion reversal may take effect. Null for limit decreases and new limits that take effect immediately.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this responsible gaming limit record was first persisted in the system of record. Used for data lineage, audit trail, and regulatory compliance reporting.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code applicable to the limit_amount field (e.g., USD, GBP, EUR). Null for non-monetary limit types such as session_time, cooling_off, and self_exclusion.. Valid values are `^[A-Z]{3}$`',
    `data_source_system` STRING COMMENT 'Identifies the operational system of record from which this responsible gaming limit record originated. Supports data lineage tracking and Silver Layer provenance in the Databricks Lakehouse.. Valid values are `salesforce_crm|operator_portal|adobe_experience_platform|api_gateway|manual_entry`',
    `effective_date` DATE COMMENT 'The calendar date on which this responsible gaming limit becomes binding and enforceable. For player-initiated reductions, regulators may require a mandatory delay (cooling-off) before the reduced limit takes effect.',
    `expiry_date` DATE COMMENT 'The calendar date on which this responsible gaming limit ceases to be enforceable. Null for permanent or open-ended limits such as lifetime self-exclusion. After this date the limit_status transitions to expired.',
    `interaction_channel` STRING COMMENT 'The platform or interface through which the bettor or operator submitted the responsible gaming limit request. Supports omnichannel analytics and regulatory channel-specific reporting requirements.. Valid values are `web|mobile_app|retail_kiosk|telephone|operator_portal|api`',
    `is_permanent` BOOLEAN COMMENT 'Indicates whether this responsible gaming limit is designated as permanent with no expiry date. True for lifetime self-exclusions and permanent bans. False for time-bound limits. Drives expiry_date nullability logic and regulatory reporting classification.',
    `limit_amount` DECIMAL(18,2) COMMENT 'The monetary ceiling or numeric threshold set by the limit. For deposit, loss, and wager limit types this is a currency amount. For session_time limits this field is null and limit_duration_minutes is used instead. For self_exclusion and cooling_off this field is null.',
    `limit_change_direction` STRING COMMENT 'Indicates whether this limit record represents an increase, decrease, new establishment, or reinstatement of a previously revoked limit. Regulators typically require immediate enforcement of limit decreases but allow a cooling-off period before increases take effect.. Valid values are `increase|decrease|new|reinstatement`',
    `limit_duration_minutes` STRING COMMENT 'Duration in minutes applicable to time-based limit types such as session_time, cooling_off, and self_exclusion. For monetary limit types (deposit, loss, wager) this field is null.',
    `limit_period` STRING COMMENT 'The rolling or fixed time window over which the limit amount or duration is measured and enforced. For example, a daily deposit limit resets every 24 hours, while a lifetime self-exclusion has no reset.. Valid values are `daily|weekly|monthly|annual|per_session|lifetime`',
    `limit_reference_number` STRING COMMENT 'Externally-known alphanumeric reference code assigned to this responsible gaming limit record, used for regulatory reporting, audit trails, and customer-facing communications.',
    `limit_source` STRING COMMENT 'Identifies the originating party that established this responsible gaming limit. Player_initiated means the bettor voluntarily set the limit. Operator_imposed means the gaming operator applied the limit based on internal responsible gaming policies. Regulator_mandated means the applicable gaming regulatory authority required the limit.. Valid values are `player_initiated|operator_imposed|regulator_mandated`',
    `limit_status` STRING COMMENT 'Current lifecycle state of the responsible gaming limit. Pending indicates the limit has been requested but not yet enforced (e.g., awaiting cooling-off period before reduction takes effect). Active means the limit is currently enforced. Suspended means temporarily paused by operator or regulator. Revoked means cancelled. Expired means the limit reached its end date.. Valid values are `pending|active|suspended|revoked|expired`',
    `limit_type` STRING COMMENT 'Classification of the responsible gaming control applied to the bettor account. Defines the nature of the restriction: deposit limits cap funds added, loss limits cap net losses, wager limits cap individual bet amounts, session_time limits cap continuous play duration, cooling_off imposes a temporary break, and self_exclusion is a voluntary or mandated ban from wagering activity.. Valid values are `deposit|loss|wager|session_time|cooling_off|self_exclusion`',
    `operator_notes` STRING COMMENT 'Free-text field for operator-entered notes or justification related to this responsible gaming limit, particularly for operator_imposed or regulator_mandated limits. Used for internal case management and regulatory audit documentation.',
    `player_acknowledgement_flag` BOOLEAN COMMENT 'Indicates whether the bettor has explicitly acknowledged and confirmed the responsible gaming limit through the platform interface. True means the player confirmed; False means acknowledgement is pending. Required for audit and GDPR consent documentation.',
    `player_acknowledgement_timestamp` TIMESTAMP COMMENT 'The date and time when the bettor explicitly acknowledged and confirmed the responsible gaming limit. Null if player_acknowledgement_flag is False. Critical for GDPR consent audit trails.',
    `previous_limit_amount` DECIMAL(18,2) COMMENT 'The monetary limit amount that was in effect immediately before the current limit was set. Enables regulators and auditors to assess whether a limit change represents an increase or decrease, which has different cooling-off period implications.',
    `regulatory_notification_sent` BOOLEAN COMMENT 'Indicates whether the required regulatory notification for this limit event has been transmitted to the applicable gaming authority. True means notification has been sent; False means notification is pending or not yet required.',
    `regulatory_notification_timestamp` TIMESTAMP COMMENT 'The date and time when the regulatory notification for this responsible gaming limit event was transmitted to the applicable gaming authority. Null if regulatory_notification_sent is False.',
    `requested_timestamp` TIMESTAMP COMMENT 'The exact date and time (ISO 8601 with timezone offset) when the bettor or operator submitted the request to establish or modify this responsible gaming limit. Serves as the principal business event timestamp for audit and regulatory reporting.',
    `review_date` DATE COMMENT 'The scheduled date on which this responsible gaming limit is due for review by the operators responsible gaming team. Applicable primarily to operator_imposed and regulator_mandated limits to ensure ongoing appropriateness.',
    `revocation_reason` STRING COMMENT 'The reason code explaining why this responsible gaming limit was revoked or cancelled. Null for limits that are active, pending, or expired. Required for regulatory audit trails when limit_status is revoked.. Valid values are `player_request|operator_decision|regulator_order|account_closure|system_correction`',
    `revocation_timestamp` TIMESTAMP COMMENT 'The date and time when this responsible gaming limit was revoked or cancelled. Null for limits that are active, pending, or expired. Supports regulatory reporting on limit lifecycle events.',
    `risk_trigger_code` STRING COMMENT 'Coded identifier of the responsible gaming risk indicator or algorithm trigger that prompted an operator_imposed or regulator_mandated limit. Examples include spend velocity alerts, session duration thresholds, or self-reported problem gambling indicators. Null for player_initiated limits. [ENUM-REF-CANDIDATE: spend_velocity|session_duration|self_reported|third_party_referral|regulatory_directive|behavioral_pattern — promote to reference product]',
    `self_exclusion_program` STRING COMMENT 'Identifies the self-exclusion program under which a self_exclusion limit type was registered. Voluntary is operator-level, national_registry and state_registry refer to government-administered exclusion databases, and operator_program refers to multi-operator industry programs.. Valid values are `voluntary|national_registry|state_registry|operator_program`',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this responsible gaming limit record was last modified. Tracks changes to limit amounts, statuses, or dates for audit and regulatory compliance purposes.',
    CONSTRAINT pk_responsible_gaming_limit PRIMARY KEY(`responsible_gaming_limit_id`)
) COMMENT 'Master record of responsible gaming controls and self-imposed limits configured by a bettor account — deposit limits (daily/weekly/monthly), loss limits, wager limits, session time limits, cooling-off periods, and self-exclusion elections. Captures limit type, limit amount or duration, effective date, expiry date, limit status, source (player-initiated vs. operator-imposed vs. regulator-mandated), and jurisdiction context. Critical for regulatory compliance with responsible gaming mandates across all licensed jurisdictions.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` (
    `self_exclusion_id` BIGINT COMMENT 'Unique surrogate identifier for each self-exclusion record in the gaming platform. Primary key for the self_exclusion data product.',
    `bettor_account_id` BIGINT COMMENT 'Identifier of the bettor account subject to the self-exclusion election. Links to the bettors registered gaming account in the CRM or gaming platform.',
    `facility_id` BIGINT COMMENT 'Foreign key linking to venue.facility. Business justification: Self-exclusion orders must be enforced at specific venue facilities hosting retail sportsbooks. Venue security and access control staff require facility-scoped exclusion records to prevent excluded pa',
    `fan_profile_id` BIGINT COMMENT 'Foreign key linking to fan.fan_profile. Business justification: Regulatory cross-platform suppression: self-excluded bettors must be suppressed from all fan marketing communications and engagement campaigns. Linking self_exclusion to fan_profile enables the fan en',
    `investigation_id` BIGINT COMMENT 'Foreign key linking to compliance.investigation. Business justification: Self-exclusion breaches — where an excluded bettor successfully places a wager — are named compliance incidents that trigger formal investigations and regulatory reporting. Compliance officers must li',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to gaming.gaming_jurisdiction. Business justification: Self-exclusion elections are jurisdiction-specific — a bettor may self-exclude in one jurisdiction but remain active in another. self_exclusion has jurisdiction_code (STRING) but no FK to gaming_juris',
    `regulatory_report_id` BIGINT COMMENT 'Foreign key linking to gaming.regulatory_report. Business justification: Self-exclusion elections must be reported to gaming regulators in most jurisdictions. self_exclusion has regulatory_notification_timestamp (TIMESTAMP) and regulatory_notification_status (STRING) but n',
    `renewed_self_exclusion_id` BIGINT COMMENT 'Self-referencing FK on self_exclusion (renewed_self_exclusion_id)',
    `streaming_subscription_id` BIGINT COMMENT 'Foreign key linking to broadcast.streaming_subscription. Business justification: Responsible gaming operations require that a self-exclusion event triggers suspension of the bettors streaming subscription for betting-eligible content. Linking self_exclusion to streaming_subscript',
    `account_suspension_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the bettors account was technically suspended in the gaming platform following the exclusion election. May differ from exclusion_election_timestamp due to processing lag.',
    `acknowledgment_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the bettor provided formal acknowledgment of the exclusion terms. Provides an audit trail for consent management and regulatory compliance.',
    `balance_disposition_status` STRING COMMENT 'Tracks the status of the pending account balance at time of exclusion. Pending indicates funds not yet processed; refunded indicates funds returned to bettor; forfeited indicates funds surrendered per regulatory rule; held_regulatory indicates funds held pending regulatory instruction; transferred indicates funds moved to a responsible gaming fund.. Valid values are `pending|refunded|forfeited|held_regulatory|transferred`',
    `bonus_clawback_flag` BOOLEAN COMMENT 'Indicates whether outstanding bonus balances or promotional credits on the bettors account were clawed back (forfeited) at the time of exclusion, per operator terms and conditions.',
    `counseling_completion_date` DATE COMMENT 'The date on which the bettor completed the required responsible gaming counseling or assessment program. Null if counseling is not required or not yet completed.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this self-exclusion record was first created in the data platform. Serves as the audit trail creation marker for the Silver layer record.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the pending balance amount (e.g., USD, GBP, EUR). Supports multi-jurisdiction operations.. Valid values are `^[A-Z]{3}$`',
    `election_channel` STRING COMMENT 'The channel through which the exclusion was initiated or submitted. Online indicates self-service via web or mobile app; in_person indicates submission at a physical venue or gaming facility; phone indicates call center submission; mail indicates written submission; regulatory_portal indicates submission via a state gaming authority portal; third_party indicates submission by a guardian or legal representative.. Valid values are `online|in_person|phone|mail|regulatory_portal|third_party`',
    `exclusion_acknowledgment_flag` BOOLEAN COMMENT 'Indicates whether the bettor formally acknowledged the terms and consequences of the self-exclusion (e.g., via digital signature, checkbox confirmation, or in-person signature). Required for voluntary self-exclusions to establish informed consent.',
    `exclusion_duration_months` STRING COMMENT 'The elected or imposed duration of the exclusion in whole months, as selected at the time of enrollment. Common regulatory options include 6, 12, 24, 60 months, or lifetime. Null for permanent exclusions.',
    `exclusion_election_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the exclusion was formally elected or imposed, representing the principal real-world business event time. Used for regulatory audit trails and compliance reporting.',
    `exclusion_end_date` DATE COMMENT 'The calendar date on which the exclusion period is scheduled to expire. Null if the exclusion is permanent. Must be evaluated in conjunction with is_permanent flag.',
    `exclusion_reference_number` STRING COMMENT 'Externally-known alphanumeric reference number assigned to this exclusion record, used for regulatory reporting, correspondence with the bettor, and cross-platform reconciliation. Format: SE-{JURISDICTION}-{SEQUENCE}.. Valid values are `^SE-[A-Z]{2,4}-[0-9]{8,12}$`',
    `exclusion_scope` STRING COMMENT 'Defines the breadth of the exclusion: single_platform restricts the bettor from one specific gaming platform; all_platforms restricts across all operator-owned platforms; statewide applies to all licensed operators in a jurisdiction; nationwide applies across all US jurisdictions; global applies internationally.. Valid values are `single_platform|all_platforms|statewide|nationwide|global`',
    `exclusion_start_date` DATE COMMENT 'The calendar date on which the exclusion becomes effective and the bettors account is suspended from all gaming activities within the defined scope.',
    `exclusion_status` STRING COMMENT 'Current lifecycle state of the self-exclusion record. Active indicates the exclusion is in force; expired indicates the exclusion period has lapsed without reinstatement; reinstated indicates the bettor has been approved to resume gaming; pending_review indicates a reinstatement request is under evaluation; revoked indicates the exclusion was cancelled by regulatory authority.. Valid values are `active|expired|reinstated|pending_review|revoked`',
    `exclusion_type` STRING COMMENT 'Categorical classification of the exclusions origin. Voluntary self-exclusion is bettor-initiated; operator exclusion is imposed by the platform; state-mandated exclusion is driven by a state gaming authority or NCPG list; court-ordered exclusion is legally mandated; guardian exclusion is filed on behalf of a minor or incapacitated person. [ENUM-REF-CANDIDATE: voluntary_self_exclusion|operator_exclusion|state_mandated_exclusion|ncpg_exclusion|court_ordered_exclusion|guardian_exclusion — promote to reference product]. Valid values are `voluntary_self_exclusion|operator_exclusion|state_mandated_exclusion|ncpg_exclusion|court_ordered_exclusion|guardian_exclusion`',
    `external_exclusion_list_code` STRING COMMENT 'The identifier assigned to this bettor by an external exclusion registry such as the NCPG national list or a state gaming authority exclusion database. Used for cross-referencing and deduplication against external lists.',
    `initiated_by` STRING COMMENT 'Identifies the party that initiated the exclusion action. Bettor indicates voluntary self-exclusion; operator indicates platform-imposed exclusion; state_authority indicates a state gaming commission mandate; court indicates a judicial order; guardian indicates a legal guardian acting on behalf of the bettor; ncpg indicates the National Council on Problem Gambling list submission.. Valid values are `bettor|operator|state_authority|court|guardian|ncpg`',
    `is_permanent` BOOLEAN COMMENT 'Indicates whether the exclusion is permanent with no scheduled end date. When True, exclusion_end_date must be null. Permanent exclusions typically require regulatory approval to lift.',
    `marketing_suppression_flag` BOOLEAN COMMENT 'Indicates whether the bettors account has been suppressed from all marketing communications (email, SMS, push notifications, direct mail) as required during the exclusion period. Must be True for all active exclusions per responsible gaming regulations.',
    `ncpg_list_match_flag` BOOLEAN COMMENT 'Indicates whether this bettors account was matched against the National Council on Problem Gambling (NCPG) national self-exclusion list during onboarding or periodic screening. True indicates a confirmed match requiring mandatory exclusion.',
    `notes` STRING COMMENT 'Free-text field for compliance officers or responsible gaming staff to record additional context, special circumstances, or case management notes related to the exclusion. Not for automated processing.',
    `open_wager_count` STRING COMMENT 'The number of open or unsettled wagers on the bettors account at the time the exclusion was applied. Used to manage wager settlement obligations and regulatory reporting.',
    `open_wager_disposition` STRING COMMENT 'Defines how open wagers are handled upon exclusion activation. void_all cancels all open bets and refunds stakes; settle_then_suspend allows existing bets to settle before account suspension; held_pending holds wagers for regulatory review; regulatory_directed follows specific authority instruction.. Valid values are `void_all|settle_then_suspend|held_pending|regulatory_directed`',
    `operator_exclusion_reason` STRING COMMENT 'Free-text or coded reason provided by the operator when imposing an operator-initiated exclusion. Examples include suspected problem gambling behavior, bonus abuse, fraud, or regulatory directive. Null for voluntary self-exclusions.',
    `pending_balance_amount` DECIMAL(18,2) COMMENT 'The bettors account balance at the time of exclusion that is pending disposition. Regulatory requirements in many jurisdictions mandate return of remaining funds to the excluded bettor. Expressed in the jurisdictions base currency.',
    `platform_code` STRING COMMENT 'Identifier of the specific gaming platform or product (e.g., sports wagering app, fantasy sports platform, online casino) from which the bettor is excluded. Relevant when exclusion_scope is single_platform.',
    `regulatory_notification_status` STRING COMMENT 'Tracks the status of the mandatory regulatory notification submission to the governing gaming authority. Pending indicates not yet submitted; submitted indicates sent but not confirmed; acknowledged indicates confirmed receipt by authority; failed indicates submission error requiring retry.. Valid values are `pending|submitted|acknowledged|failed`',
    `regulatory_notification_timestamp` TIMESTAMP COMMENT 'The date and time at which the relevant state gaming authority or NCPG was notified of the exclusion, as required by jurisdictional reporting obligations.',
    `reinstatement_approval_status` STRING COMMENT 'Current status of the bettors reinstatement request. not_requested indicates no request has been filed; pending indicates under review; approved indicates reinstatement granted; denied indicates request rejected; withdrawn indicates bettor withdrew the request.. Valid values are `not_requested|pending|approved|denied|withdrawn`',
    `reinstatement_approved_date` DATE COMMENT 'The date on which the reinstatement request was formally approved by the operator and/or regulatory authority, allowing the bettor to resume gaming activities. Null if reinstatement has not been approved.',
    `reinstatement_cooling_off_days` STRING COMMENT 'The mandatory cooling-off period in days that must elapse after a reinstatement request before the bettor can be reinstated. Defined by jurisdictional regulation or operator policy.',
    `reinstatement_request_date` DATE COMMENT 'The date on which the excluded bettor formally submitted a request to be reinstated to gaming activities. Null if no reinstatement has been requested. Triggers the reinstatement review workflow.',
    `responsible_gaming_counseling_required` BOOLEAN COMMENT 'Indicates whether the bettor is required to complete a responsible gaming counseling or assessment program as a condition of reinstatement. Driven by operator policy or regulatory mandate.',
    `source_system_code` STRING COMMENT 'Identifies the operational system of record from which this exclusion record originated (e.g., Salesforce CRM, Adobe Experience Platform, state regulatory portal, internal gaming platform). Supports data lineage and reconciliation in the Silver layer.',
    `state_exclusion_list_match_flag` BOOLEAN COMMENT 'Indicates whether this bettor was identified via a state-level exclusion list (distinct from NCPG national list). True indicates the exclusion was triggered by a state gaming authoritys exclusion registry match.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time at which this self-exclusion record was most recently modified in the data platform. Tracks reinstatement updates, status changes, and regulatory notification updates.',
    CONSTRAINT pk_self_exclusion PRIMARY KEY(`self_exclusion_id`)
) COMMENT 'Transactional record of a bettors self-exclusion election or operator-imposed exclusion from gaming activities. Captures bettor account ID, exclusion type (voluntary self-exclusion, operator exclusion, state-mandated exclusion via NCPG/state exclusion lists), exclusion scope (single platform, all platforms, statewide), exclusion start date, exclusion end date (or permanent flag), reinstatement request date, reinstatement approval status, and jurisdiction. Distinct from responsible_gaming_limit — self-exclusion is a full account suspension, not a limit adjustment.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` (
    `regulatory_report_id` BIGINT COMMENT 'Unique surrogate identifier for each regulatory report record submitted to a gaming authority. Primary key for the regulatory_report data product.',
    `amended_regulatory_report_id` BIGINT COMMENT 'Self-referencing FK on regulatory_report (amended_regulatory_report_id)',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Regulatory reports are filed by legal entities (company codes). operator_entity_name is a denormalized representation of the filing entity. Linking to finance.company_code enables entity-level regulat',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each gaming regulatory report fulfills a specific compliance obligation (e.g., monthly GGR reporting, quarterly AML SAR filing). Linking to the obligation record enables obligation status tracking, ev',
    `emergency_activation_id` BIGINT COMMENT 'Foreign key linking to security.emergency_activation. Business justification: Event suspension regulatory reporting: when an emergency activation cancels or suspends a live event, gaming operators must file regulatory reports documenting the impact on open wagers and GGR. Sport',
    `facility_id` BIGINT COMMENT 'Foreign key linking to venue.facility. Business justification: State gaming commissions require GGR and compliance reports broken down by retail sportsbook facility. Regulatory reports for retail wagering operations must reference the specific venue facility, a m',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Regulatory GGR and tax reports must align with fiscal periods for finance reconciliation. Finance teams verify that regulatory filings match internal period financials. Current model has date columns ',
    `fixture_id` BIGINT COMMENT 'Foreign key linking to event.fixture. Business justification: Many jurisdictions (e.g., US state gaming commissions) require fixture-level wagering activity reports covering volume, integrity flags, and SAR counts per event. A direct FK enables fixture-level reg',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Regulatory reports are submitted to specific governing bodies (gaming commissions, sports integrity authorities). The `regulatory_body_name` text field is a denormalization of governing_body. Complian',
    `jurisdiction_id` BIGINT COMMENT 'Reference to the licensed gaming jurisdiction under which this report is filed (e.g., Nevada Gaming Control Board, New Jersey DGE, UK Gambling Commission).',
    `league_id` BIGINT COMMENT 'Foreign key linking to league.league. Business justification: Gaming regulatory reports are often scoped to a specific professional league (e.g., NFL wagering activity report to state regulator). A league_id FK enables league-specific regulatory reporting, a nam',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Regulatory reports aggregate GGR by operator/jurisdiction. Linking to finance.profit_center enables P&L reporting by gaming profit center, supporting management reporting and financial consolidation o',
    `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Gaming regulatory reports (GGR, AML, responsible gaming) submitted to state/national regulators are formal regulatory filings tracked in compliance. Linking regulatory_report to its corresponding regu',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: Gaming regulatory reports are frequently scoped to a specific league season (annual integrity reports, season-level GGR filings, season-end responsible gaming summaries). Season-scoped regulatory repo',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Gaming regulatory reports (SAR filings, integrity disclosures) triggered by physical match-manipulation events must reference the originating security incident for regulatory traceability. Regulators ',
    `accepted_timestamp` TIMESTAMP COMMENT 'The date and time when the regulatory authority formally accepted and closed the review of this report. Marks the completion of the regulatory filing lifecycle.',
    `acknowledgement_timestamp` TIMESTAMP COMMENT 'The date and time when the regulatory authority formally acknowledged receipt of the submitted report. Distinct from submission_timestamp; marks the start of the regulatory review clock.',
    `active_player_count` STRING COMMENT 'Number of unique active registered players who placed at least one wager during the reporting period. Required for responsible gaming program and player activity regulatory disclosures.',
    `aml_flagged_transaction_count` STRING COMMENT 'Number of transactions flagged for potential Anti-Money Laundering (AML) activity during the reporting period and disclosed in this regulatory filing.',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when the authorized approver signed off on this regulatory report prior to submission. Supports SOX internal control audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this regulatory report record was first created in the system. Audit trail field supporting data lineage and compliance record-keeping.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts reported in this filing (e.g., USD, GBP, EUR). Supports multi-currency, multi-jurisdiction reporting.. Valid values are `^[A-Z]{3}$`',
    `filing_deadline_date` DATE COMMENT 'The regulatory-mandated deadline by which this report must be submitted to the governing authority. Used to monitor compliance with filing timeliness requirements and flag late submissions.',
    `ggr_amount` DECIMAL(18,2) COMMENT 'Total Gross Gaming Revenue (GGR) reported for the filing period, representing total wagers accepted minus total winnings paid out. Applicable for GGR report type filings. Expressed in the reporting currency.',
    `internal_review_notes` STRING COMMENT 'Free-text field capturing internal compliance team notes, review comments, or escalation details associated with the preparation or review of this regulatory report. Not shared externally.',
    `is_amended` BOOLEAN COMMENT 'Indicates whether this report is an amendment to a previously submitted filing. True = amended/corrected report; False = original submission. Amended reports must reference the original report number.',
    `is_late_filing` BOOLEAN COMMENT 'Indicates whether this report was submitted after the regulatory filing deadline. True = filed late; False = filed on time. Used for compliance monitoring and penalty risk assessment.',
    `kyc_verified_player_count` STRING COMMENT 'Number of players who completed Know Your Customer (KYC) identity verification during the reporting period. Required for AML/KYC compliance filings with gaming regulators.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this regulatory report record was most recently modified in the system. Supports change tracking, audit trail, and Silver layer data freshness monitoring.',
    `original_report_number` STRING COMMENT 'The report_number of the original filing that this amended report supersedes. Populated only when is_amended = True. Enables audit trail linkage between original and amended submissions.',
    `regulatory_body_reference_number` STRING COMMENT 'Acknowledgement or reference number assigned by the regulatory authority upon receipt or processing of the submitted report. Used for official correspondence and audit trail.',
    `rejection_reason` STRING COMMENT 'Textual description of the reason provided by the regulatory authority for rejecting this report. Populated only when report_status = rejected. Used to guide resubmission and remediation.',
    `report_frequency` STRING COMMENT 'The required cadence at which this type of regulatory report must be submitted to the governing authority (e.g., monthly GGR reports, annual responsible gaming program reports, ad hoc SARs).. Valid values are `daily|weekly|monthly|quarterly|annual|ad_hoc`',
    `report_number` STRING COMMENT 'Externally-known unique business identifier assigned to this report at the time of generation, used for tracking and cross-referencing with regulatory bodies (e.g., RPT-2024-NV-00123).',
    `report_status` STRING COMMENT 'Current lifecycle state of the regulatory report in its submission workflow. Tracks progression from internal drafting through regulatory authority acceptance or rejection.. Valid values are `draft|submitted|acknowledged|under_review|accepted|rejected`',
    `report_type` STRING COMMENT 'Classification of the regulatory report by its required filing category. GGR = Gross Gaming Revenue report; SAR = Suspicious Activity Report; self_exclusion_compliance = self-exclusion program adherence; responsible_gaming_program = responsible gaming program status; AML_KYC = Anti-Money Laundering / Know Your Customer compliance filing. [ENUM-REF-CANDIDATE: GGR|SAR|self_exclusion_compliance|responsible_gaming_program|AML_KYC|other — promote to reference product]. Valid values are `GGR|SAR|self_exclusion_compliance|responsible_gaming_program|AML_KYC`',
    `report_version` STRING COMMENT 'Sequential version number of this regulatory report, incremented each time an amendment or resubmission is made. Version 1 = original filing; higher values indicate amended filings.',
    `reporting_period_end_date` DATE COMMENT 'The last calendar date of the reporting period covered by this regulatory filing (e.g., end of the monthly GGR reporting window).',
    `reporting_period_start_date` DATE COMMENT 'The first calendar date of the reporting period covered by this regulatory filing (e.g., start of the monthly GGR reporting window).',
    `responsible_gaming_intervention_count` STRING COMMENT 'Number of responsible gaming interventions (e.g., deposit limit alerts, cooling-off period activations, problem gambling referrals) executed during the reporting period. Required for responsible gaming program reports.',
    `sar_count` STRING COMMENT 'Number of individual Suspicious Activity Reports (SARs) included or referenced in this regulatory filing. Applicable for SAR batch or summary filings to FINCEN or state gaming authorities.',
    `self_exclusion_breach_count` STRING COMMENT 'Number of instances where a self-excluded player was identified as having accessed or attempted to access gaming services during the reporting period. Critical compliance metric for regulatory filings.',
    `self_exclusion_count` STRING COMMENT 'Number of players enrolled in the self-exclusion program during the reporting period. Required for self-exclusion compliance reports submitted to gaming regulators.',
    `sport_category` STRING COMMENT 'The sport or event category covered by this regulatory report (e.g., NFL, NBA, MLB, NHL, MLS, UFC, FIFA, horse racing, esports). Used for sport-specific regulatory breakdowns required by some jurisdictions.',
    `submission_channel` STRING COMMENT 'The method or channel through which the regulatory report was submitted to the governing authority (e.g., online regulatory portal, secure email, API integration, physical mail).. Valid values are `portal|email|API|mail|fax`',
    `submission_timestamp` TIMESTAMP COMMENT 'The exact date and time when the regulatory report was formally submitted to the governing authority. Serves as the principal business event timestamp for this transaction.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total gaming tax liability calculated and reported for the filing period based on GGR and applicable jurisdiction tax rates. Supports financial reconciliation and tax compliance reporting.',
    `total_wagers_amount` DECIMAL(18,2) COMMENT 'Aggregate value of all wagers accepted during the reporting period, as reported to the regulatory authority. Used as a component of GGR calculation and regulatory financial disclosure.',
    `total_winnings_paid_amount` DECIMAL(18,2) COMMENT 'Aggregate value of all winnings paid out to bettors during the reporting period, as reported to the regulatory authority. Used as a component of GGR calculation.',
    CONSTRAINT pk_regulatory_report PRIMARY KEY(`regulatory_report_id`)
) COMMENT 'Master record of all regulatory reports submitted to gaming authorities across licensed jurisdictions — gross gaming revenue (GGR) reports, suspicious activity reports (SAR), self-exclusion compliance reports, responsible gaming program reports, and AML/KYC compliance filings. Captures report type, jurisdiction, reporting period, submission date, submitted by, report status (draft, submitted, acknowledged, under review, accepted), and regulatory body reference number. Supports multi-jurisdiction regulatory compliance operations.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`contest` (
    `contest_id` BIGINT COMMENT 'Unique system-generated identifier for a Daily Fantasy Sports (DFS) contest or tournament-style gaming competition. Primary key for the contest master record.',
    `bracket_id` BIGINT COMMENT 'Foreign key linking to event.bracket. Business justification: Bracket prediction contests (March Madness, playoff bracket games) are scored against the live tournament bracket. Contest settlement and leaderboard scoring require direct reference to the event brac',
    `broadcast_schedule_id` BIGINT COMMENT 'Foreign key linking to broadcast.broadcast_schedule. Business justification: DFS contest lock times are operationally tied to broadcast schedule start times — contests lock when the first game in the slate begins broadcasting. Operators use broadcast_schedule to automate conte',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Contests operate under specific DFS-licensed legal entities. Finance attributes contest prize pool liabilities and rake revenue to the correct company code for consolidated reporting, DFS tax complian',
    `competition_round_id` BIGINT COMMENT 'Foreign key linking to event.competition_round. Business justification: DFS contest slates are built around a specific competition round (e.g., NFL Week 7). Operators need competition_round_id for slate construction, lock-time scheduling, and scoring period alignment. wee',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: DFS contests incur operational costs (prize pool funding, platform costs, customer support) allocated to cost centers. This link supports operational cost allocation for DFS product P&L and budget man',
    `season_ticket_package_id` BIGINT COMMENT 'Foreign key linking to ticketing.season_ticket_package. Business justification: STH-exclusive contest eligibility: sports operators run contests restricted to holders of specific season ticket packages (e.g., premium tier STH-only prediction contests). The contest must reference ',
    `collection_id` BIGINT COMMENT 'Foreign key linking to content.collection. Business justification: DFS and bracket contests feature curated content collections (player highlight reels, slate previews) on contest lobby pages. Contest operations teams link a content collection to each contest for fan',
    `fixture_id` BIGINT COMMENT 'Foreign key linking to event.fixture. Business justification: Single-game DFS contests (e.g., SuperDraft showdown) are tied to one specific fixture. Settlement, lineup lock timing, and regulatory reporting for single-game contests require a direct fixture refere',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to the gaming regulatory jurisdiction in which this contests eligibility is being defined',
    `league_id` BIGINT COMMENT 'Foreign key linking to league.league. Business justification: DFS contests are organized by professional league (NFL, NBA, etc.). A league_id FK replaces the denormalized league_code, enabling proper league-scoped contest reporting, official data mandate complia',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: DFS contests run within a specific professional league season. A league_season_id FK enables season-level prize pool accounting, regulatory filings scoped to a season period, and trade-deadline enforc',
    `loyalty_program_id` BIGINT COMMENT 'Foreign key linking to fan.loyalty_program. Business justification: DFS contests configured to award loyalty points must reference the governing loyalty program for points calculation rules, earning caps, and program eligibility. Sports-entertainment operators running',
    `sku_catalog_id` BIGINT COMMENT 'Foreign key linking to merchandise.sku_catalog. Business justification: Gaming contest merchandise prize fulfillment: DFS and gaming contests award merchandise SKUs as prizes. Operations require linking the contest to the specific merchandise SKU for prize inventory reser',
    `ticket_inventory_id` BIGINT COMMENT 'Foreign key linking to ticketing.ticket_inventory. Business justification: Contest prize ticket allocation: sports entertainment operators configure contests where the prize pool includes specific ticket inventory (e.g., playoff seats). The contest must reference the allocat',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: DFS contests generate revenue (rake, entry fees) and costs attributed to profit centers. Linking to finance.profit_center enables contest-level P&L reporting, supporting DFS product line financial man',
    `asset_id` BIGINT COMMENT 'Foreign key linking to content.asset. Business justification: DFS contest display operations: each contest references a specific promotional content asset (banner image, preview video) for rendering on platform pages. Role prefix promotional_ distinguishes fro',
    `qualifier_contest_id` BIGINT COMMENT 'Self-referencing FK on contest (qualifier_contest_id)',
    `tournament_id` BIGINT COMMENT 'Foreign key linking to event.tournament. Business justification: Tournament-scoped DFS and bracket prediction contests (e.g., March Madness, World Cup) require a direct tournament reference for prize pool settlement, contest eligibility rules, and regulatory report',
    `age_restriction_override` STRING COMMENT 'Jurisdiction-specific minimum age requirement that overrides the platform default for this contest in this jurisdiction. Populated only when the jurisdiction mandates a higher age threshold than the platform standard (e.g., 21 instead of 18). NULL indicates no override — platform default applies.',
    `age_restriction_years` STRING COMMENT 'Minimum age in years required to enter this contest. Typically 18 or 21 depending on jurisdiction. Enforced at entry time against bettor_account age verification.',
    `cancellation_reason` STRING COMMENT 'Explanation for why the contest was cancelled (e.g., insufficient entries, weather postponement, regulatory hold). Populated only when contest_status is cancelled.',
    `completion_timestamp` TIMESTAMP COMMENT 'Date and time when all games in the slate concluded, final scores were confirmed, and the contest was officially completed. Triggers prize payout processing.',
    `contest_name` STRING COMMENT 'Human-readable display name of the contest as shown to players on the platform (e.g., Sunday Million GPP, NFL Week 12 50/50).',
    `contest_status` STRING COMMENT 'Current lifecycle state of the contest. open accepts entries; locked is past entry deadline; live is in-progress scoring; completed is final; cancelled is voided with refunds; postponed is delayed.. Valid values are `open|locked|live|completed|cancelled|postponed`',
    `contest_type` STRING COMMENT 'Classification of the contest format. GPP (Guaranteed Prize Pool) tournaments are top-heavy; 50/50 and double-up pay the top half; head-to-head is one-on-one; satellite/qualifier awards entries to larger contests. [ENUM-REF-CANDIDATE: GPP|50_50|HEAD_TO_HEAD|SATELLITE|DOUBLE_UP|QUALIFIER — promote to reference product]. Valid values are `GPP|50_50|HEAD_TO_HEAD|SATELLITE|DOUBLE_UP|QUALIFIER`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this contest record was first created in the system. Audit trail field for data lineage and compliance.',
    `effective_from_date` DATE COMMENT 'Date on which this eligibility determination became active for this contest-jurisdiction pairing. Supports audit trails and retroactive compliance review.',
    `eligibility_status` STRING COMMENT 'Current compliance determination of whether this contest is available to players located in this jurisdiction. Managed by the compliance team and updated when license status or contest parameters change.',
    `entries_filled` STRING COMMENT 'Current count of entries submitted to this contest at the time of last update. Used to monitor fill rate and determine overlay exposure for guaranteed prize pools.',
    `entry_fee_amount` DECIMAL(18,2) COMMENT 'Dollar amount charged per entry into this contest. A value of 0.00 indicates a free-to-play contest. Used for revenue recognition and responsible gaming deposit limit tracking.',
    `entry_fee_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the entry fee (e.g., USD, CAD, GBP). Required for multi-jurisdiction operations.. Valid values are `^[A-Z]{3}$`',
    `external_code` STRING COMMENT 'Externally-known identifier for this contest as assigned by the source gaming platform or operator system. Used for cross-system reconciliation.',
    `is_beginner_only` BOOLEAN COMMENT 'Indicates whether this contest is restricted to new or inexperienced players. Beginner contests are a responsible gaming and player acquisition tool that limits exposure to highly experienced players.',
    `is_featured` BOOLEAN COMMENT 'Indicates whether this contest is promoted as a featured or marquee contest on the platform lobby. Featured contests receive prominent placement and marketing support.',
    `is_free_to_play` BOOLEAN COMMENT 'Indicates whether this is a free-to-play (no entry fee) contest. Free contests may offer prizes funded by the operator for promotional or responsible gaming purposes.',
    `is_guaranteed` BOOLEAN COMMENT 'Indicates whether the prize pool is guaranteed by the operator regardless of the number of entries received. True for GPP contests; False for non-guaranteed contests that may be cancelled if underfilled.',
    `jurisdiction_codes` STRING COMMENT 'Pipe-delimited list of jurisdiction or state codes where this contest is available for entry (e.g., US-NJ|US-PA|US-CO). Used for geo-restriction enforcement at entry time.',
    `jurisdiction_exclusion_codes` STRING COMMENT 'Pipe-delimited list of jurisdiction or state codes where this contest is explicitly prohibited (e.g., US-WA|US-ID). Complements jurisdiction_codes for regulatory compliance.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this contest record was most recently modified. Used for change tracking, incremental data loads, and audit compliance.',
    `lock_timestamp` TIMESTAMP COMMENT 'Date and time after which no new entries or lineup edits are accepted. Typically set to the first games scheduled start time. Regulatory requirement to prevent late entry based on real-world information.',
    `max_entries_per_player` STRING COMMENT 'Maximum number of lineup entries a single player account may submit to this contest. Limits multi-entry advantage and supports responsible gaming controls. Typically 1 for head-to-head; higher for large GPPs.',
    `min_entries_required` STRING COMMENT 'Minimum number of entries required for the contest to run. If not met by lock time, the contest may be cancelled and entry fees refunded. Relevant for head-to-head and small-field contests.',
    `paid_places_count` STRING COMMENT 'Number of finishing positions that receive a cash prize payout. Determines the percentage of the field that cashes. Key metric for contest attractiveness and responsible gaming disclosures.',
    `platform_code` BIGINT COMMENT 'Reference to the gaming platform on which this contest is hosted (e.g., DraftKings, FanDuel, proprietary DFS platform).',
    `prize_pool_amount` DECIMAL(18,2) COMMENT 'Total prize pool value guaranteed or collected for this contest. For GPP contests this may be a guaranteed minimum; for non-guaranteed contests it is the sum of entry fees less rake. Used for financial reporting and regulatory disclosure.',
    `prize_pool_type` STRING COMMENT 'Indicates whether the prize pool is guaranteed by the operator regardless of entries filled (GPP), non-guaranteed (scales with entries), or overlay (operator subsidizes shortfall when entries are below guarantee threshold).. Valid values are `guaranteed|non_guaranteed|overlay`',
    `prize_reporting_threshold` DECIMAL(18,2) COMMENT 'Jurisdiction-specific monetary threshold above which a prize payout from this contest must be reported to the regulatory authority or tax body. This value is contest-jurisdiction specific because it may vary based on contest type (DFS vs. wagering) and jurisdiction rules. Expressed in the jurisdictions currency_code.',
    `prize_structure_type` STRING COMMENT 'Describes how prizes are distributed across finishing positions. top_heavy concentrates prizes at the top; flat pays equal amounts across a wide range; winner_take_all awards the full pool to first place; tiered uses defined payout brackets.. Valid values are `top_heavy|flat|winner_take_all|tiered`',
    `rake_percentage` DECIMAL(18,2) COMMENT 'Operators take rate expressed as a percentage of total entry fees collected. Represents the platforms revenue margin on the contest. Used for financial reporting and EBITDA analysis.',
    `registration_open_timestamp` TIMESTAMP COMMENT 'Date and time when the contest becomes available for player entry registration. Defines the entry acceptance window start.',
    `regulatory_contest_code` STRING COMMENT 'Identifier assigned by the relevant state or national gaming regulatory authority for this contest. Required for regulatory reporting and audit submissions.',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates that this contest has been flagged for responsible gaming review or has specific responsible gaming restrictions applied (e.g., entry limits, deposit requirements, player eligibility checks).',
    `restriction_type` STRING COMMENT 'Classification of the type of restriction applied to this contest in this jurisdiction. A full_block means the contest is entirely unavailable; age_gated means players must meet a jurisdiction-specific age threshold; prize_capped means the prize pool is limited by jurisdictional rules.',
    `roster_size` STRING COMMENT 'Total number of player slots in a contest entry lineup (e.g., 9 for classic NFL DFS, 6 for showdown). Defines the lineup construction rules for this contest.',
    `salary_cap_amount` DECIMAL(18,2) COMMENT 'Virtual salary cap budget allocated to each entry for player selection (e.g., $50,000). Entries must construct rosters within this cap. A core DFS contest mechanic.',
    `scoring_system_code` STRING COMMENT 'Code identifying the fantasy scoring ruleset applied to this contest (e.g., STANDARD, PPR, HALF_PPR for NFL; CLASSIC for NBA). Determines how real-world player statistics translate to fantasy points.',
    `season_year` STRING COMMENT 'The sports season year associated with this contest (e.g., 2024 for the 2024 NFL season). Used for seasonal reporting, analytics segmentation, and historical comparisons.',
    `sport_code` STRING COMMENT 'Standardized sport code identifying the sport governing this contest (e.g., NFL, NBA, MLB). Aligns with league governing body codes. [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|PGA|UFC|ATP|OTHER — promote to reference product]',
    `start_timestamp` TIMESTAMP COMMENT 'Date and time when the first game in the contest slate begins and live scoring commences. Marks the transition from locked to live status.',
    `total_entries_cap` STRING COMMENT 'Maximum total number of entries allowed across all players in this contest. Defines the contest capacity. When reached, the contest is closed to new entries.',
    CONSTRAINT pk_contest PRIMARY KEY(`contest_id`)
) COMMENT 'Master record for Daily Fantasy Sports (DFS) contests and tournament-style gaming competitions — capturing contest name, sport, slate (game set), contest type (GPP/tournament, 50/50, head-to-head, satellite), entry fee, maximum entries per player, total entries cap, prize pool amount, prize pool structure (top-heavy vs. flat), contest start time, lock time, status (open, locked, live, completed, cancelled), and platform. Distinct from fantasy_league (season-long) — contest covers single-slate DFS competitions.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` (
    `contest_entry_id` BIGINT COMMENT 'Unique surrogate identifier for each DFS contest entry record in the Silver layer. Primary key for this transactional entity.',
    `bettor_account_id` BIGINT COMMENT 'Reference to the bettor account that submitted this contest entry. Used for multi-entry tracking, responsible gaming compliance, and prize distribution.',
    `contest_id` BIGINT COMMENT 'Reference to the DFS contest this entry belongs to. Links to the fantasy contest definition including prize pool, scoring format, and entry rules.',
    `fantasy_roster_id` BIGINT COMMENT 'Reference to the specific athlete lineup submitted for this contest entry. Links to the lineup/roster detail record capturing athlete selections by position and salary cap usage.',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Contest entry fees generate revenue journal entries; prize payouts generate expense entries at the entry level. Finance audit trails and W-2G tax reporting require traceability from individual contest',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to gaming.gaming_jurisdiction. Business justification: DFS contest entries are subject to jurisdiction-specific regulations — whether DFS is permitted, age restrictions, and prize reporting requirements vary by jurisdiction. contest_entry has jurisdiction',
    `operator_id` BIGINT COMMENT 'Reference to the licensed DFS operator or platform entity under whose license this contest entry was accepted. Supports multi-operator platform architectures and regulatory license-level reporting.',
    `access_entitlement_id` BIGINT COMMENT 'Foreign key linking to ticketing.access_entitlement. Business justification: Contest prize fulfillment: when a gaming contest awards a game ticket as a prize, the contest_entry must reference the issued access_entitlement for prize tracking, compliance reporting, and gate-scan',
    `merch_order_id` BIGINT COMMENT 'Foreign key linking to merchandise.merch_order. Business justification: When a contest winner receives a physical merchandise prize, the fulfillment is processed as a merch_order. This prize fulfillment tracking link enables finance reconciliation, royalty reporting, and ',
    `rebuy_of_contest_entry_id` BIGINT COMMENT 'Self-referencing FK on contest_entry (rebuy_of_contest_entry_id)',
    `retail_location_id` BIGINT COMMENT 'Foreign key linking to merchandise.retail_location. Business justification: In sports-entertainment, fans enter contests at in-store kiosks in stadium retail locations. Linking contest_entry to retail_location enables location-based contest participation reporting, in-store e',
    `ticket_order_id` BIGINT COMMENT 'Foreign key linking to ticketing.ticket_order. Business justification: Ticket-bundled DFS contest entries (buy a ticket, get a free contest entry) are a standard promotional mechanic in sports entertainment. This FK tracks which ticket purchase triggered the free entry',
    `actual_points` DECIMAL(18,2) COMMENT 'Total actual fantasy points scored by the submitted lineup after all real-world games in the slate have concluded and scores are finalized. Principal quantitative outcome for settlement and ranking.',
    `bonus_amount_applied` DECIMAL(18,2) COMMENT 'Promotional or bonus credit amount applied toward the entry fee for this contest entry. Reduces the net cash charged to the bettor. Used for promotion reconciliation and regulatory reporting.',
    `contest_slate_date` DATE COMMENT 'The primary game-day date of the contest slate this entry is associated with. Used for scheduling, settlement timing, and regulatory reporting period alignment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contest entry record was first persisted in the data platform. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this entry (entry fee, prize, payout). Supports multi-jurisdiction DFS operations.. Valid values are `^[A-Z]{3}$`',
    `device_type` STRING COMMENT 'Category of device used to submit this contest entry. Supports platform analytics, UX optimization, and fraud pattern detection.. Valid values are `desktop|mobile|tablet|smart_tv|other`',
    `entry_fee_amount` DECIMAL(18,2) COMMENT 'Gross entry fee charged to the bettor account for this contest entry, expressed in the account currency. Represents the base monetary consideration for participation.',
    `entry_number_in_contest` STRING COMMENT 'Sequential entry number for this bettor within the same contest (e.g., 1 = first entry, 2 = second entry). Supports multi-entry tracking and regulatory caps on entries per bettor per contest.',
    `entry_reference_number` STRING COMMENT 'Externally visible alphanumeric reference code assigned to this contest entry at submission time. Used for customer support, regulatory reporting, and settlement reconciliation.. Valid values are `^CE-[A-Z0-9]{8,16}$`',
    `entry_status` STRING COMMENT 'Current lifecycle state of the contest entry. pending = submitted but not yet confirmed; active = confirmed and contest in progress; locked = lineup locked at contest start; settled = final score and rank determined; cancelled = entry withdrawn before lock; voided = invalidated post-settlement.. Valid values are `pending|active|locked|settled|cancelled|voided`',
    `entry_timestamp` TIMESTAMP COMMENT 'The precise date and time (ISO 8601 with timezone offset) when the bettor submitted this contest entry. Principal business event timestamp for regulatory audit trails and multi-entry sequencing.',
    `entry_type` STRING COMMENT 'Classification of the contest entry by participation mechanism. standard = single paid entry; multi_entry = one of multiple entries by same bettor in same contest; satellite = entry won via a satellite contest; qualifier = entry into a qualifying round; freeroll = zero entry fee promotional entry.. Valid values are `standard|multi_entry|satellite|qualifier|freeroll`',
    `final_rank` STRING COMMENT 'Final standing rank of this entry within the contest after all scores are settled. Rank 1 = highest scoring entry. Determines prize eligibility and payout tier.',
    `geolocation_state` STRING COMMENT 'Two-letter US state code of the bettors verified geolocation at the time of entry submission. Critical for jurisdiction-based DFS legality verification and regulatory reporting.. Valid values are `^[A-Z]{2}$`',
    `geolocation_verified` BOOLEAN COMMENT 'Indicates whether the bettors geolocation was successfully verified as being within a legally permitted jurisdiction at the time of entry submission. Entries with unverified geolocation may be flagged for compliance review.',
    `is_autopick` BOOLEAN COMMENT 'Indicates whether the lineup for this entry was generated automatically by the platforms autopick algorithm rather than manually selected by the bettor. Relevant for contest integrity and bettor experience analytics.',
    `is_late_swap` BOOLEAN COMMENT 'Indicates whether the bettor utilized a late swap to substitute an injured or scratched athlete in the lineup after the initial contest lock but before that athletes game started. Applicable only in contests that permit late swaps.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this contest entry record, including lineup edits, status changes, score updates, and payout processing.',
    `lineup_edit_count` STRING COMMENT 'Number of times the bettor modified the submitted lineup between initial entry and lineup lock. Supports contest integrity monitoring and late-swap tracking.',
    `lineup_lock_timestamp` TIMESTAMP COMMENT 'The date and time at which the submitted lineup was locked and no further edits were permitted. Marks the transition from active to locked entry status.',
    `net_entry_fee_amount` DECIMAL(18,2) COMMENT 'Actual cash amount charged to the bettor after applying bonus credits (entry_fee_amount minus bonus_amount_applied). Represents the real monetary outlay for regulatory and financial reporting.',
    `payout_status` STRING COMMENT 'Current status of the prize payout for this entry. pending = prize calculated but not yet disbursed; processed = funds credited to bettor account; failed = disbursement error; withheld = held for tax or compliance review; cancelled = prize voided.. Valid values are `pending|processed|failed|withheld|cancelled`',
    `payout_timestamp` TIMESTAMP COMMENT 'Date and time when the prize payout was successfully credited to the bettor account. Null if payout has not yet been processed.',
    `percentile_rank` DECIMAL(18,2) COMMENT 'This entrys final rank expressed as a percentile within the contest field (e.g., 95.00 = top 5%). Supports bettor performance analytics and DFS platform reporting.',
    `prize_amount` DECIMAL(18,2) COMMENT 'Gross prize amount won by this entry based on final rank and contest prize structure. Zero if entry did not finish in a paying position. Used for prize distribution and IRS W-2G tax reporting.',
    `prize_tier` STRING COMMENT 'Prize tier or payout band this entry qualified for based on final rank (e.g., 1st Place, Top 10, Top 20%, No Prize). Derived from the contest prize structure at settlement. [ENUM-REF-CANDIDATE: 1st_place|2nd_place|3rd_place|top_10|top_20_pct|top_50_pct|no_prize — promote to reference product]',
    `projected_points` DECIMAL(18,2) COMMENT 'Total projected fantasy points for the submitted lineup at the time of entry lock, based on pre-game statistical projections. Used for contest analytics and bettor decision support.',
    `promotion_code` STRING COMMENT 'Promotional or referral code applied at the time of entry submission. Used for marketing attribution, bonus reconciliation, and campaign performance reporting.',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this entry triggered a responsible gaming alert at the time of submission, such as exceeding deposit limits, loss limits, or self-exclusion proximity thresholds. Supports operator compliance with responsible gaming mandates.',
    `salary_cap_used` DECIMAL(18,2) COMMENT 'Total salary cap value consumed by the submitted lineup. Must not exceed the contests maximum salary cap limit. Used for lineup validation and contest integrity checks.',
    `settlement_timestamp` TIMESTAMP COMMENT 'Date and time when this contest entry was officially settled — final scores confirmed, rank assigned, and prize amount determined. Marks the transition to settled entry status.',
    `sport_type` STRING COMMENT 'Sport category for the DFS contest this entry participates in. Drives scoring rules, position eligibility, and regulatory jurisdiction mapping. [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|PGA|NASCAR|UFC|tennis|college_football|college_basketball|other — promote to reference product]',
    `tax_withheld_amount` DECIMAL(18,2) COMMENT 'Amount of federal or state income tax withheld from the prize payout per applicable tax regulations. Relevant for IRS W-2G reporting when prize exceeds statutory thresholds.',
    `void_reason` STRING COMMENT 'Textual description of the reason this entry was voided or cancelled, if applicable (e.g., Contest cancelled due to insufficient entries, Bettor self-exclusion triggered, Geolocation violation). Null for non-voided entries.',
    `w2g_reportable` BOOLEAN COMMENT 'Indicates whether this contest entrys prize winnings meet or exceed the IRS W-2G reporting threshold, requiring issuance of a W-2G tax form to the bettor and reporting to the IRS.',
    CONSTRAINT pk_contest_entry PRIMARY KEY(`contest_entry_id`)
) COMMENT 'Transactional record of a bettors entry into a DFS contest — capturing contest ID, bettor account ID, entry timestamp, entry fee paid, lineup submitted (athlete selections by position), total projected points, actual points scored, final rank, prize won, and payout status. Supports contest settlement, prize distribution, and multi-entry tracking for DFS regulatory compliance.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`payout` (
    `payout_id` BIGINT COMMENT 'Unique surrogate identifier for each gaming payout disbursement record in the silver layer lakehouse.',
    `bettor_account_id` BIGINT COMMENT 'Reference to the bettor account receiving this payout. Links to the gaming.bettor_account master record.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Payouts are disbursed by specific licensed legal entities and must be attributed to company codes for W-2G tax withholding remittance, financial statement consolidation, and regulatory reporting. Fina',
    `contest_entry_id` BIGINT COMMENT 'Reference to the specific Daily Fantasy Sports (DFS) contest entry that generated this prize payout. Null for sportsbook wager payouts. Used to link DFS prize payouts back to the originating contest entry for prize pool reconciliation.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Payouts are operational cash outflows allocated to cost centers (gaming operations, customer payouts department). This link supports cost center-level P&L for gaming operations and enables accurate op',
    `fantasy_league_id` BIGINT COMMENT 'Reference to the fantasy league associated with this payout for DFS or season-long fantasy prize distributions. Null for sportsbook wager payouts.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Payouts must be attributed to fiscal periods for W-2G tax withholding reporting, net GGR calculation, and period-end financial close. Finance teams aggregate payout totals by fiscal period for regulat',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Payouts are cash outflows (winnings paid, bonus payouts) that must post to GL accounts for financial reporting. This link supports automated journal entry creation for payout settlements and balance s',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Payout of winnings requires a journal entry (debit liability/expense, credit cash). Finance reconciles total payouts against GL postings for period-close and audit. Payout already has gl_account_id an',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to gaming.gaming_jurisdiction. Business justification: Payouts are subject to jurisdiction-specific tax withholding rules, W2G reporting thresholds, and AML requirements. payout has jurisdiction_code (STRING) but no FK to gaming_jurisdiction. Adding juris',
    `regulatory_report_id` BIGINT COMMENT 'Foreign key linking to gaming.regulatory_report. Business justification: Payouts that meet W2G reporting thresholds or CTR requirements must be included in regulatory reports. payout has w2g_reportable (BOOLEAN), w2g_form_reference (STRING), and ctr_reportable (BOOLEAN) bu',
    `reversed_payout_id` BIGINT COMMENT 'Self-referencing FK on payout (reversed_payout_id)',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: Payouts are season-scoped for W-2G tax reporting, season-level financial reconciliation, and regulatory compliance reporting. Season-level payout aggregation is required for annual tax filings and int',
    `wager_id` BIGINT COMMENT 'Reference to the originating wager that generated this payout. Null for DFS contest prize payouts or bonus conversions not tied to a single wager.',
    `aml_review_flag` BOOLEAN COMMENT 'Indicates whether this payout has been flagged for Anti-Money Laundering review due to threshold triggers (e.g., cash equivalent payouts exceeding $10,000 CTR threshold) or suspicious activity patterns. When true, payout may be held pending compliance review.',
    `approval_required` BOOLEAN COMMENT 'Indicates whether this payout requires manual review and approval before disbursement, triggered by large payout thresholds, AML flags, first-time large payout rules, or operator risk controls.',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when manual approval was granted for this payout. Null if approval_required is false or approval is pending. Used for SLA measurement of approval-to-disbursement cycle time.',
    `approved_by` STRING COMMENT 'Username or employee identifier of the compliance or operations staff member who manually approved this payout when approval_required is true. Supports audit trail for large payout approvals and SOX financial controls.',
    `bonus_amount_included` DECIMAL(18,2) COMMENT 'Portion of the gross payout amount attributable to bonus funds or promotional credits rather than real-money wagering. Used to separate real-money GGR from bonus-funded activity in regulatory reporting and financial reconciliation.',
    `completed_timestamp` TIMESTAMP COMMENT 'Timestamp when the payout was confirmed as successfully delivered to the bettor by the payment processor or banking network. Null if payout has not yet reached completed status. Used for settlement reconciliation and SLA tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording when this payout record was first created in the system of record. Supports data lineage, audit trail requirements, and SOX financial controls.',
    `ctr_reportable` BOOLEAN COMMENT 'Indicates whether this payout triggers a FinCEN Currency Transaction Report (CTR) requirement, applicable when cash-equivalent payouts to a single bettor exceed $10,000 in a single gaming day. Drives CTR filing workflow.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this payout record (gross, tax withheld, net). Supports multi-jurisdiction operations across USD, CAD, GBP, EUR, and other licensed markets.. Valid values are `^[A-Z]{3}$`',
    `failure_reason` STRING COMMENT 'Descriptive reason code or message explaining why a payout failed or was reversed. Populated only when payout_status is failed or reversed. Examples: insufficient_account_info, bank_account_closed, aml_hold, duplicate_detected, bettor_self_excluded.',
    `federal_withholding_rate` DECIMAL(18,2) COMMENT 'Federal income tax withholding rate applied to this payout, expressed as a decimal (e.g., 0.2400 for 24%). Determined by IRS backup withholding rules or regular gambling withholding rates based on payout type and bettor tax status.',
    `geolocation_state` STRING COMMENT 'Two-letter US state code (or equivalent jurisdiction code) of the bettors verified geolocation at the time the payout was triggered. Used to confirm the bettor was physically located in a licensed jurisdiction at time of payout initiation.. Valid values are `^[A-Z]{2}$`',
    `ggr_period` STRING COMMENT 'YYYY-MM formatted reporting period to which this payout is attributed for Gross Gaming Revenue (GGR) calculations and regulatory financial reporting. GGR = Total Wagers - Total Payouts within the period. Supports monthly regulatory submissions.. Valid values are `^[0-9]{4}-(0[1-9]|1[0-2])$`',
    `gross_payout_amount` DECIMAL(18,2) COMMENT 'Total payout amount before any tax withholding deductions, representing the full winning amount owed to the bettor. Used as the basis for W-2G threshold evaluation and Gross Gaming Revenue (GGR) calculations.',
    `is_free_bet_payout` BOOLEAN COMMENT 'Indicates whether this payout originated from a free bet promotion where the stake was operator-funded. When true, the stake amount is excluded from the net payout per standard free bet payout rules (profit only, stake not returned). Affects GGR and bonus cost accounting.',
    `net_payout_amount` DECIMAL(18,2) COMMENT 'Final amount disbursed to the bettor after deducting tax_withheld_amount from gross_payout_amount. This is the actual funds received by the bettor and the amount recorded in the payment processor instruction.',
    `odds_at_settlement` DECIMAL(18,2) COMMENT 'Decimal odds value at which the winning wager was settled. Used for W-2G threshold ratio verification (300:1 requirement for sports betting) and audit trail of payout calculation basis.',
    `operator_code` STRING COMMENT 'Identifier of the licensed gaming operator or skin under whose license this payout was processed. Relevant for B2B platform operators managing multiple licensed brands or white-label operations across jurisdictions.',
    `payout_method` STRING COMMENT 'Disbursement channel used to deliver funds to the bettor. Wallet credit: instant credit to in-app gaming wallet; ACH: Automated Clearing House bank transfer; Check: physical check mailed to bettor; Wire transfer: bank wire for large payouts; PayPal/Venmo: third-party digital wallet. [ENUM-REF-CANDIDATE: wallet_credit|ach|check|wire_transfer|paypal|venmo|prepaid_card — promote to reference product]. Valid values are `wallet_credit|ach|check|wire_transfer|paypal|venmo`',
    `payout_status` STRING COMMENT 'Current lifecycle state of the payout disbursement. Pending: awaiting approval; Approved: cleared for disbursement; Processing: submitted to payment processor; Completed: funds confirmed delivered; Failed: disbursement attempt unsuccessful; Reversed: payout recalled or clawed back post-disbursement.. Valid values are `pending|approved|processing|completed|failed|reversed`',
    `payout_timestamp` TIMESTAMP COMMENT 'The principal business event timestamp recording when the payout was initiated and submitted for disbursement. Distinct from completion timestamp. Used for regulatory reporting windows, GGR period attribution, and financial reconciliation cutoffs.',
    `payout_type` STRING COMMENT 'Classification of the payout by its originating business event. Wager settlement covers standard sportsbook wins; DFS contest prize covers daily fantasy sports contest payouts; fantasy league prize covers season-long league prize distributions; bonus conversion covers wagering requirement completions; promotional credit covers operator-funded promotional payouts; free bet winnings covers winnings from free bet stakes. [ENUM-REF-CANDIDATE: wager_settlement|dfs_contest_prize|fantasy_league_prize|bonus_conversion|promotional_credit|free_bet_winnings — promote to reference product]. Valid values are `wager_settlement|dfs_contest_prize|fantasy_league_prize|bonus_conversion|promotional_credit|free_bet_winnings`',
    `prize_rank` STRING COMMENT 'Finishing rank or placement position of the bettors DFS contest entry or fantasy league team that determined the prize payout amount. Null for sportsbook wager payouts. Used for prize structure validation and contest result reconciliation.',
    `processor_name` STRING COMMENT 'Name of the third-party payment processor or banking network used to execute this payout disbursement (e.g., Worldpay, FIS, PayPal, Venmo, NACHA ACH network). Supports processor performance monitoring and reconciliation routing.',
    `processor_reference` STRING COMMENT 'Transaction reference number returned by the external payment processor (ACH network, wire transfer system, check issuer, or digital wallet provider) upon submission of the payout instruction. Used for payment reconciliation and dispute resolution.',
    `reference_number` STRING COMMENT 'Externally visible alphanumeric reference number assigned to this payout transaction, used for bettor communications, customer service lookups, and reconciliation with payment processors.. Valid values are `^PAY-[A-Z0-9]{10,20}$`',
    `responsible_gaming_flag` BOOLEAN COMMENT 'Indicates whether this payout was subject to a responsible gaming intervention, such as a deposit limit, loss limit, or self-exclusion check at the time of disbursement. Supports responsible gaming compliance reporting to state gaming commissions.',
    `reversal_reason` STRING COMMENT 'Reason for reversing a previously completed payout, such as voided wager settlement, fraud investigation, duplicate payout correction, or regulatory clawback. Populated only when payout_status is reversed.',
    `source_system` STRING COMMENT 'Identifies the originating operational system that generated this payout record. Supports data lineage tracking in the silver layer and reconciliation between platform systems.. Valid values are `sportsbook|dfs_platform|fantasy_platform|retail_terminal|bonus_engine`',
    `stake_amount` DECIMAL(18,2) COMMENT 'The original wager or contest entry fee amount placed by the bettor that generated this payout. Used for W-2G threshold ratio calculation (payout must be 300x stake for sports betting W-2G trigger) and GGR computation.',
    `state_withholding_amount` DECIMAL(18,2) COMMENT 'State income tax withheld from the gross payout amount per the applicable state gaming jurisdictions withholding requirements. Separate from federal withholding. Zero if the jurisdiction does not require state withholding.',
    `tax_withheld_amount` DECIMAL(18,2) COMMENT 'Federal and/or state income tax withheld from the gross payout amount per IRS W-2G mandatory withholding rules. Triggered when gross payout meets or exceeds the W-2G reporting threshold ($600 for sports wagering at 300:1 odds or more; $5,000 for other gaming). Zero if below threshold.',
    `updated_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording the most recent modification to this payout record, including status transitions, reversal processing, or correction events. Supports change data capture in the silver layer.',
    `w2g_form_reference` STRING COMMENT 'Reference number of the IRS W-2G tax form issued to the bettor for this payout. Populated only when w2g_reportable is true. Used for tax compliance tracking, bettor tax document retrieval, and IRS filing reconciliation.',
    `w2g_reportable` BOOLEAN COMMENT 'Indicates whether this payout meets IRS W-2G reporting thresholds and must be reported to the IRS as gambling winnings. True when gross payout is $600 or more and at least 300 times the wager amount for sports betting, or $5,000 or more for other gaming types. Drives W-2G form generation.',
    CONSTRAINT pk_payout PRIMARY KEY(`payout_id`)
) COMMENT 'Transactional record of all gaming prize and winnings payouts disbursed to bettor accounts — covering wager settlements, DFS contest prizes, fantasy league prize distributions, and bonus conversions. Captures payout type, bettor account ID, wager or contest entry reference, gross payout amount, tax withholding amount (W-2G threshold compliance), net payout amount, payout method (wallet credit, check, ACH, wire), payout timestamp, and payout status. Supports financial reconciliation, tax reporting (IRS W-2G), and regulatory GGR calculations.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`operator` (
    `operator_id` BIGINT COMMENT 'Primary key for operator',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Gaming operators are licensed legal entities mapped to company codes for financial reporting, intercompany transactions, and tax registration. Finance needs operator-to-company-code attribution for co',
    `facility_id` BIGINT COMMENT 'Foreign key linking to venue.facility. Business justification: Retail sportsbook operators are physically licensed to operate at specific venue facilities. Linking operator to facility enables retail license management, revenue-share reporting, and regulatory com',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Operators are licensed and overseen by specific governing bodies (state gaming commissions, sports integrity bodies). License issuance, renewal, and enforcement are tracked against the governing body.',
    `parent_operator_id` BIGINT COMMENT 'Self-referencing FK on operator (parent_operator_id)',
    `aml_compliance_program` BOOLEAN COMMENT 'Indicates whether the operator has an active AML compliance program in place.',
    `api_integration_enabled` BOOLEAN COMMENT 'Indicates whether the operator provides API integration capabilities for third-party systems and partners.',
    `deposit_limit_enforcement` BOOLEAN COMMENT 'Indicates whether the operator enforces customer-set deposit limits as part of responsible gaming measures.',
    `effective_date` DATE COMMENT 'Date when the operator record became effective and the operator began operations or partnership.',
    `geolocation_verification_enabled` BOOLEAN COMMENT 'Indicates whether the operator uses geolocation technology to verify player location for regulatory compliance.',
    `headquarters_address` STRING COMMENT 'Physical street address of the operators corporate headquarters or principal place of business.',
    `headquarters_city` STRING COMMENT 'City where the operators corporate headquarters is located.',
    `headquarters_country_code` STRING COMMENT 'Three-letter ISO country code for the operators headquarters location.',
    `headquarters_postal_code` STRING COMMENT 'Postal or ZIP code for the operators headquarters address.',
    `headquarters_state_province` STRING COMMENT 'State or province where the operators corporate headquarters is located.',
    `jurisdiction_code` STRING COMMENT 'Regulatory jurisdiction code where the operator is licensed to conduct gaming operations (e.g., NV, NJ-DGE, UK-GC).',
    `kyc_verification_required` BOOLEAN COMMENT 'Indicates whether the operator is required to perform KYC verification on customers per regulatory requirements.',
    `license_expiration_date` DATE COMMENT 'Date when the current gaming license expires and requires renewal for continued operations.',
    `license_issue_date` DATE COMMENT 'Date when the gaming license was originally issued to the operator by the regulatory authority.',
    `license_number` STRING COMMENT 'Official gaming license number issued by the regulatory authority for this operator.',
    `license_status` STRING COMMENT 'Current regulatory license status of the operator indicating their authorization to conduct gaming operations.',
    `live_betting_supported` BOOLEAN COMMENT 'Indicates whether the operator supports in-play or live betting on sporting events.',
    `minimum_age_requirement` STRING COMMENT 'Minimum legal age required for customers to participate in gaming activities with this operator.',
    `mobile_app_available` BOOLEAN COMMENT 'Indicates whether the operator offers a dedicated mobile application for gaming activities.',
    `multi_currency_support` BOOLEAN COMMENT 'Indicates whether the operator supports transactions in multiple currencies beyond the primary operating currency.',
    `odds_feed_provider` STRING COMMENT 'Name of the third-party vendor supplying real-time odds and betting market data to the operator.',
    `operating_currency_code` STRING COMMENT 'Primary three-letter ISO currency code used for the operators gaming transactions and financial reporting.',
    `operator_code` STRING COMMENT 'Unique alphanumeric code assigned to the operator for system identification and regulatory reporting.',
    `operator_name` STRING COMMENT 'Legal business name of the gaming operator entity.',
    `operator_type` STRING COMMENT 'Classification of the gaming operator based on primary business model and gaming offerings.',
    `parent_company_name` STRING COMMENT 'Legal name of the parent corporation or holding company that owns this gaming operator.',
    `payment_processor` STRING COMMENT 'Name of the payment processing vendor handling financial transactions for the operator.',
    `platform_provider` STRING COMMENT 'Name of the technology platform provider or vendor that powers the operators gaming systems.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary business contact for operator communications and coordination.',
    `primary_contact_name` STRING COMMENT 'Full name of the primary business contact person for the operator.',
    `primary_contact_phone` STRING COMMENT 'Telephone number of the primary business contact for the operator.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this operator record was first created in the system.',
    `reporting_threshold_amount` DECIMAL(18,2) COMMENT 'Monetary threshold above which the operator must report transactions to regulatory authorities.',
    `responsible_gaming_certification_body` STRING COMMENT 'Name of the organization that issued the responsible gaming certification to the operator.',
    `responsible_gaming_certified` BOOLEAN COMMENT 'Indicates whether the operator holds current responsible gaming certification from a recognized authority.',
    `self_exclusion_program` BOOLEAN COMMENT 'Indicates whether the operator offers a self-exclusion program for responsible gaming.',
    `tax_identification_number` STRING COMMENT 'Government-issued tax identification number for the operator entity used for tax reporting and compliance.',
    `tax_withholding_rate` DECIMAL(18,2) COMMENT 'Default tax withholding rate applied to customer winnings by the operator as required by jurisdiction tax laws.',
    `termination_date` DATE COMMENT 'Date when the operator ceased operations or partnership relationship ended. Null if currently active.',
    `website_url` STRING COMMENT 'Primary website URL for the operators gaming platform or corporate site.',
    CONSTRAINT pk_operator PRIMARY KEY(`operator_id`)
) COMMENT 'Master reference table for operator. Referenced by operator_id.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`gaming`.`selection` (
    `selection_id` BIGINT COMMENT 'Primary key for selection',
    `athlete_profile_id` BIGINT COMMENT 'Foreign key linking to athlete.athlete_profile. Business justification: Sportsbooks must identify which athlete a selection references for integrity monitoring, suspension/injury-triggered market suspension, and regulatory reporting on athlete-linked wagering. selection.p',
    `betting_market_id` BIGINT COMMENT 'Reference to the betting market that contains this selection.',
    `fixture_id` BIGINT COMMENT 'Reference to the sporting event or entertainment event associated with this selection.',
    `match_result_id` BIGINT COMMENT 'Foreign key linking to event.match_result. Business justification: Selection settlement (e.g., Home Win, Over 2.5 goals) is determined by the official match_result. The settlement pipeline must link each selection to the confirmed result for automated grading, pa',
    `parent_selection_id` BIGINT COMMENT 'Self-referencing FK on selection (parent_selection_id)',
    `participant_id` BIGINT COMMENT 'Reference to the competitor (team, athlete, or participant) represented by this selection. Nullable for non-competitor selections (e.g., over/under totals).',
    `scoring_event_id` BIGINT COMMENT 'Foreign key linking to event.scoring_event. Business justification: Selections for first scorer, anytime scorer, and next goal markets are settled by referencing the specific scoring_event that determines the outcome. Automated settlement and integrity audit tra',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this selection record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for stake and payout amounts associated with this selection (e.g., USD, GBP, EUR).',
    `current_odds_american` STRING COMMENT 'Most recent odds for this selection, expressed in American moneyline format. Updated in real-time during live betting.',
    `current_odds_decimal` DECIMAL(18,2) COMMENT 'Most recent odds for this selection, expressed in decimal format. Updated in real-time during live betting.',
    `display_order` STRING COMMENT 'Numeric sequence for ordering selections within a market for consistent presentation across betting interfaces.',
    `effective_end_timestamp` TIMESTAMP COMMENT 'Timestamp when this selection is no longer available for wagering (e.g., event start time, market close time). Null for open-ended selections.',
    `effective_start_timestamp` TIMESTAMP COMMENT 'Timestamp when this selection becomes available for wagering.',
    `external_provider_code` STRING COMMENT 'Unique identifier for this selection in the external odds feed provider system for data reconciliation and integration.',
    `handicap_value` DECIMAL(18,2) COMMENT 'Numeric handicap or spread value applied to this selection (e.g., +3.5, -7.0). Null for non-handicap selections.',
    `is_favorite` BOOLEAN COMMENT 'Indicates whether this selection is the favorite (expected winner) in the market based on odds.',
    `is_featured` BOOLEAN COMMENT 'Indicates whether this selection is promoted or featured in marketing and user interfaces.',
    `is_restricted` BOOLEAN COMMENT 'Indicates whether this selection has betting restrictions applied (e.g., limited stake, excluded from promotions) for responsible gaming or regulatory compliance.',
    `jurisdiction_code` STRING COMMENT 'Regulatory jurisdiction code where this selection is offered, critical for compliance and responsible gaming reporting (e.g., NJ, UK, ONT).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this selection record was last updated in the system.',
    `max_stake_amount` DECIMAL(18,2) COMMENT 'Maximum wager amount allowed on this selection for responsible gaming and risk management. Null if no limit applies.',
    `min_stake_amount` DECIMAL(18,2) COMMENT 'Minimum wager amount required for this selection. Null if no minimum applies.',
    `odds_last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the current odds were last updated, critical for live betting and odds feed reconciliation.',
    `opening_odds_american` STRING COMMENT 'Initial odds offered for this selection when the market opened, expressed in American moneyline format (e.g., +150, -200).',
    `opening_odds_decimal` DECIMAL(18,2) COMMENT 'Initial odds offered for this selection when the market opened, expressed in decimal format (e.g., 2.50).',
    `provider_name` STRING COMMENT 'Name of the external odds feed provider supplying data for this selection (e.g., SportsRadar, Betgenius, Don Best).',
    `restriction_reason` STRING COMMENT 'Explanation for why betting restrictions are applied to this selection (e.g., regulatory requirement, integrity concern, responsible gaming measure). Null if not restricted.',
    `result` STRING COMMENT 'Final outcome of the selection after event completion and settlement (win, loss, push/tie, void, or pending settlement).',
    `selection_category` STRING COMMENT 'Broader categorization of the selection for market segmentation and reporting (moneyline, handicap, total, proposition, futures, live in-play).',
    `selection_code` STRING COMMENT 'Externally-known unique business identifier for the selection used across betting systems and odds feeds.',
    `selection_description` STRING COMMENT 'Detailed description of the selection providing additional context for bettors (e.g., specific prop bet conditions, special rules).',
    `selection_name` STRING COMMENT 'Human-readable name of the selection as displayed to bettors (e.g., team name, player name, outcome description).',
    `selection_status` STRING COMMENT 'Current lifecycle status of the selection indicating availability for wagering and settlement state.',
    `selection_type` STRING COMMENT 'Classification of the selection indicating the nature of the wagering option (team, individual player, binary outcome, proposition bet, over/under total, point spread).',
    `settlement_timestamp` TIMESTAMP COMMENT 'Timestamp when the selection was officially settled and results were finalized for payout processing.',
    `short_name` STRING COMMENT 'Abbreviated name of the selection for display in constrained UI spaces (e.g., mobile betting slips).',
    `total_value` DECIMAL(18,2) COMMENT 'Numeric total or line value for over/under selections (e.g., 45.5 points). Null for non-total selections.',
    `void_reason` STRING COMMENT 'Explanation for why the selection was voided (e.g., event cancellation, participant withdrawal, rule violation). Null if not voided.',
    CONSTRAINT pk_selection PRIMARY KEY(`selection_id`)
) COMMENT 'Master reference table for selection. Referenced by selection_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_parent_betting_market_id` FOREIGN KEY (`parent_betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_betting_market_id` FOREIGN KEY (`betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_selection_id` FOREIGN KEY (`selection_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`selection`(`selection_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_superseded_odds_feed_id` FOREIGN KEY (`superseded_odds_feed_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`odds_feed`(`odds_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_betting_market_id` FOREIGN KEY (`betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_cashout_of_wager_id` FOREIGN KEY (`cashout_of_wager_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`wager`(`wager_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_odds_feed_id` FOREIGN KEY (`odds_feed_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`odds_feed`(`odds_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_regulatory_report_id` FOREIGN KEY (`regulatory_report_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`regulatory_report`(`regulatory_report_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ADD CONSTRAINT `fk_gaming_bettor_account_referred_by_bettor_account_id` FOREIGN KEY (`referred_by_bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_betting_market_id` FOREIGN KEY (`betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_odds_feed_id` FOREIGN KEY (`odds_feed_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`odds_feed`(`odds_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_parent_prop_bet_id` FOREIGN KEY (`parent_prop_bet_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`prop_bet`(`prop_bet_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_predecessor_fantasy_league_id` FOREIGN KEY (`predecessor_fantasy_league_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_league`(`fantasy_league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_fantasy_league_id` FOREIGN KEY (`fantasy_league_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_league`(`fantasy_league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_fantasy_team_id` FOREIGN KEY (`fantasy_team_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_team`(`fantasy_team_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_previous_fantasy_roster_id` FOREIGN KEY (`previous_fantasy_roster_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_roster`(`fantasy_roster_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ADD CONSTRAINT `fk_gaming_fantasy_team_fantasy_league_id` FOREIGN KEY (`fantasy_league_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_league`(`fantasy_league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ADD CONSTRAINT `fk_gaming_fantasy_team_predecessor_fantasy_team_id` FOREIGN KEY (`predecessor_fantasy_team_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_team`(`fantasy_team_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ADD CONSTRAINT `fk_gaming_fantasy_team_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ADD CONSTRAINT `fk_gaming_wallet_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ADD CONSTRAINT `fk_gaming_wallet_consolidated_from_wallet_id` FOREIGN KEY (`consolidated_from_wallet_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`wallet`(`wallet_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ADD CONSTRAINT `fk_gaming_wallet_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ADD CONSTRAINT `fk_gaming_jurisdiction_parent_jurisdiction_id` FOREIGN KEY (`parent_jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ADD CONSTRAINT `fk_gaming_responsible_gaming_limit_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ADD CONSTRAINT `fk_gaming_responsible_gaming_limit_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ADD CONSTRAINT `fk_gaming_responsible_gaming_limit_primary_superseded_by_limit_responsible_gaming_limit_id` FOREIGN KEY (`primary_superseded_by_limit_responsible_gaming_limit_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit`(`responsible_gaming_limit_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ADD CONSTRAINT `fk_gaming_responsible_gaming_limit_regulatory_report_id` FOREIGN KEY (`regulatory_report_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`regulatory_report`(`regulatory_report_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_regulatory_report_id` FOREIGN KEY (`regulatory_report_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`regulatory_report`(`regulatory_report_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_renewed_self_exclusion_id` FOREIGN KEY (`renewed_self_exclusion_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`self_exclusion`(`self_exclusion_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_amended_regulatory_report_id` FOREIGN KEY (`amended_regulatory_report_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`regulatory_report`(`regulatory_report_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_qualifier_contest_id` FOREIGN KEY (`qualifier_contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_fantasy_roster_id` FOREIGN KEY (`fantasy_roster_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_roster`(`fantasy_roster_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_rebuy_of_contest_entry_id` FOREIGN KEY (`rebuy_of_contest_entry_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest_entry`(`contest_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_contest_entry_id` FOREIGN KEY (`contest_entry_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest_entry`(`contest_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_fantasy_league_id` FOREIGN KEY (`fantasy_league_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`fantasy_league`(`fantasy_league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_regulatory_report_id` FOREIGN KEY (`regulatory_report_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`regulatory_report`(`regulatory_report_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_reversed_payout_id` FOREIGN KEY (`reversed_payout_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`payout`(`payout_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_wager_id` FOREIGN KEY (`wager_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`wager`(`wager_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ADD CONSTRAINT `fk_gaming_operator_parent_operator_id` FOREIGN KEY (`parent_operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ADD CONSTRAINT `fk_gaming_selection_betting_market_id` FOREIGN KEY (`betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ADD CONSTRAINT `fk_gaming_selection_parent_selection_id` FOREIGN KEY (`parent_selection_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`selection`(`selection_id`);

-- ========= TAGS =========
ALTER SCHEMA `sports_entertainment_ecm`.`gaming` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `sports_entertainment_ecm`.`gaming` SET TAGS ('dbx_domain' = 'gaming');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` SET TAGS ('dbx_subdomain' = 'wagering_operations');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `betting_market_id` SET TAGS ('dbx_business_glossary_term' = 'Betting Market ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `broadcast_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Schedule Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `competition_round_id` SET TAGS ('dbx_business_glossary_term' = 'Competition Round Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'League Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `match_result_id` SET TAGS ('dbx_business_glossary_term' = 'Match Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `parent_betting_market_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `playoff_bracket_id` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Event ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `rights_window_id` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Rights Window Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `tournament_id` SET TAGS ('dbx_business_glossary_term' = 'Tournament Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `age_verification_required` SET TAGS ('dbx_business_glossary_term' = 'Age Verification Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `display_order` SET TAGS ('dbx_business_glossary_term' = 'Display Order');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Market Effective From Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `effective_until_date` SET TAGS ('dbx_business_glossary_term' = 'Market Effective Until Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `is_featured` SET TAGS ('dbx_business_glossary_term' = 'Is Featured Market Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `is_futures_market` SET TAGS ('dbx_business_glossary_term' = 'Is Futures Market Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `is_live_inplay` SET TAGS ('dbx_business_glossary_term' = 'Is Live In-Play Market Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `is_parlay_eligible` SET TAGS ('dbx_business_glossary_term' = 'Is Parlay Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `margin_percentage` SET TAGS ('dbx_business_glossary_term' = 'Operator Margin Percentage');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `margin_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_category` SET TAGS ('dbx_business_glossary_term' = 'Betting Market Category');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_category` SET TAGS ('dbx_value_regex' = 'game|season|tournament|player|team|entertainment');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_close_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Market Close Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_code` SET TAGS ('dbx_business_glossary_term' = 'Betting Market Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,30}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_name` SET TAGS ('dbx_business_glossary_term' = 'Betting Market Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_open_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Market Open Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_source_feed` SET TAGS ('dbx_business_glossary_term' = 'Market Source Odds Feed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_status` SET TAGS ('dbx_business_glossary_term' = 'Betting Market Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_status` SET TAGS ('dbx_value_regex' = 'open|suspended|closed|settled|voided|pending');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `market_type_code` SET TAGS ('dbx_business_glossary_term' = 'Betting Market Type Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `max_liability_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Liability Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `max_liability_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `max_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payout Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `max_stake_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stake Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `min_stake_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Stake Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Market Notes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `odds_format` SET TAGS ('dbx_business_glossary_term' = 'Odds Format');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `odds_format` SET TAGS ('dbx_value_regex' = 'american|decimal|fractional|hong_kong|indonesian|malay');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `prop_bet_category` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet (Prop Bet) Category');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `prop_bet_category` SET TAGS ('dbx_value_regex' = 'player_performance|team_statistic|game_event|entertainment|none');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `regulatory_market_code` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Market ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `season_year` SET TAGS ('dbx_business_glossary_term' = 'Season Year');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `settlement_outcome` SET TAGS ('dbx_business_glossary_term' = 'Settlement Outcome');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `settlement_rule_code` SET TAGS ('dbx_business_glossary_term' = 'Settlement Rule Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `settlement_rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,40}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `settlement_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Settlement Rule Description');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `settlement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Market Settlement Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `sport_code` SET TAGS ('dbx_business_glossary_term' = 'Sport Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `sport_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `spread_value` SET TAGS ('dbx_business_glossary_term' = 'Point Spread Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `total_line_value` SET TAGS ('dbx_business_glossary_term' = 'Total Line Value (Over/Under)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Market Definition Version Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` SET TAGS ('dbx_subdomain' = 'wagering_operations');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `odds_feed_id` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `betting_market_id` SET TAGS ('dbx_business_glossary_term' = 'Betting Market ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `league_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'League Schedule Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `live_feed_id` SET TAGS ('dbx_business_glossary_term' = 'Live Feed Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `match_result_id` SET TAGS ('dbx_business_glossary_term' = 'Match Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `media_rights_deal_id` SET TAGS ('dbx_business_glossary_term' = 'Media Rights Deal Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Sporting Event ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `scoring_event_id` SET TAGS ('dbx_business_glossary_term' = 'Scoring Event Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `selection_id` SET TAGS ('dbx_business_glossary_term' = 'Market Selection ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `superseded_odds_feed_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `american_odds` SET TAGS ('dbx_business_glossary_term' = 'American (Moneyline) Odds Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `decimal_odds` SET TAGS ('dbx_business_glossary_term' = 'Decimal Odds Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_channel` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Channel');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_channel` SET TAGS ('dbx_value_regex' = 'api_push|api_pull|websocket|file_feed|manual');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_latency_ms` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Latency (Milliseconds)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_reference_code` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Reference Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_reference_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{4,64}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_source_name` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Source Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_status` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_status` SET TAGS ('dbx_value_regex' = 'active|suspended|settled|cancelled|resulted|void');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_version` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Protocol Version');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `feed_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `fractional_odds_denominator` SET TAGS ('dbx_business_glossary_term' = 'Fractional Odds Denominator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `fractional_odds_numerator` SET TAGS ('dbx_business_glossary_term' = 'Fractional Odds Numerator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `handicap_value` SET TAGS ('dbx_business_glossary_term' = 'Handicap / Spread Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `implied_probability` SET TAGS ('dbx_business_glossary_term' = 'Implied Probability');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `integrity_alert_flag` SET TAGS ('dbx_business_glossary_term' = 'Betting Integrity Alert Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `is_in_play` SET TAGS ('dbx_business_glossary_term' = 'In-Play (Live Betting) Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `is_resulted` SET TAGS ('dbx_business_glossary_term' = 'Market Resulted Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `is_suspended` SET TAGS ('dbx_business_glossary_term' = 'Market Suspension Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Jurisdiction Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `line_movement_direction` SET TAGS ('dbx_business_glossary_term' = 'Line Movement Direction');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `line_movement_direction` SET TAGS ('dbx_value_regex' = 'up|down|unchanged|open|close');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `market_type` SET TAGS ('dbx_business_glossary_term' = 'Betting Market Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `max_stake_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stake Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `max_stake_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `min_stake_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Stake Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `odds_format` SET TAGS ('dbx_business_glossary_term' = 'Odds Format Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `odds_format` SET TAGS ('dbx_value_regex' = 'decimal|fractional|american|hongkong|malay|indonesian');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `overround_pct` SET TAGS ('dbx_business_glossary_term' = 'Overround Percentage');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `previous_decimal_odds` SET TAGS ('dbx_business_glossary_term' = 'Previous Decimal Odds Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `price_boost_indicator` SET TAGS ('dbx_business_glossary_term' = 'Price Boost Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `provider_published_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Provider Published Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Received Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `regulatory_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Compliance Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `result_outcome` SET TAGS ('dbx_business_glossary_term' = 'Selection Result Outcome');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `result_outcome` SET TAGS ('dbx_value_regex' = 'win|lose|void|push|half_win|half_lose');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Feed Sequence Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `source_market_reference` SET TAGS ('dbx_business_glossary_term' = 'Provider Source Market Reference');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `sport_code` SET TAGS ('dbx_business_glossary_term' = 'Sport Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `sport_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Market Suspension Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `total_line_value` SET TAGS ('dbx_business_glossary_term' = 'Total (Over/Under) Line Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` SET TAGS ('dbx_subdomain' = 'wagering_operations');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `wager_id` SET TAGS ('dbx_business_glossary_term' = 'Wager ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `betting_market_id` SET TAGS ('dbx_business_glossary_term' = 'Betting Market ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `broadcast_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Schedule Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `cashout_of_wager_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `game_result_id` SET TAGS ('dbx_business_glossary_term' = 'Game Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `investigation_id` SET TAGS ('dbx_business_glossary_term' = 'Investigation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `match_result_id` SET TAGS ('dbx_business_glossary_term' = 'Match Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `odds_feed_id` SET TAGS ('dbx_business_glossary_term' = 'Odds Feed Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `operator_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Campaign Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `regulatory_report_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `retail_location_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Location ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `emergency_activation_id` SET TAGS ('dbx_business_glossary_term' = 'Void Emergency Activation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Event ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `wager_fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Event ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `bonus_amount` SET TAGS ('dbx_business_glossary_term' = 'Bonus Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `bonus_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `bonus_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `cashout_amount` SET TAGS ('dbx_business_glossary_term' = 'Cash-Out Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `cashout_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `cashout_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `cashout_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cash-Out Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `device_fingerprint` SET TAGS ('dbx_business_glossary_term' = 'Device Fingerprint');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `device_fingerprint` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `device_fingerprint` SET TAGS ('dbx_pii_ip' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_country` SET TAGS ('dbx_business_glossary_term' = 'Geolocation Country Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_country` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_business_glossary_term' = 'Geolocation State Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_business_glossary_term' = 'Geolocation Verified Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `integrity_flag` SET TAGS ('dbx_business_glossary_term' = 'Integrity Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'IP Address');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_ip' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `is_free_bet` SET TAGS ('dbx_business_glossary_term' = 'Free Bet Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `is_live_bet` SET TAGS ('dbx_business_glossary_term' = 'Live (In-Play) Bet Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `leg_count` SET TAGS ('dbx_business_glossary_term' = 'Wager Leg Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `odds_at_placement` SET TAGS ('dbx_business_glossary_term' = 'Odds at Placement');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `odds_format` SET TAGS ('dbx_business_glossary_term' = 'Odds Format');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `odds_format` SET TAGS ('dbx_value_regex' = 'decimal|american|fractional|hong_kong|indonesian');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `placement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Placement Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `potential_payout` SET TAGS ('dbx_business_glossary_term' = 'Potential Payout');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `potential_payout` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `potential_payout` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `potential_profit` SET TAGS ('dbx_business_glossary_term' = 'Potential Profit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `potential_profit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `potential_profit` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Wager Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `selection_description` SET TAGS ('dbx_business_glossary_term' = 'Selection Description');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `self_exclusion_override` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Override Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_business_glossary_term' = 'Settlement Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `settlement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Settlement Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `stake_amount` SET TAGS ('dbx_business_glossary_term' = 'Stake Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `stake_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `stake_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Withheld Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `ticket_terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Ticket Terminal ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `void_reason` SET TAGS ('dbx_business_glossary_term' = 'Void Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `wager_status` SET TAGS ('dbx_business_glossary_term' = 'Wager Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `wager_status` SET TAGS ('dbx_value_regex' = 'pending|won|lost|void|cashed_out|pushed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `wager_type` SET TAGS ('dbx_business_glossary_term' = 'Wager Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ALTER COLUMN `wager_type` SET TAGS ('dbx_value_regex' = 'straight|parlay|teaser|prop|futures|round_robin');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` SET TAGS ('dbx_subdomain' = 'player_management');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Campaign Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `fan_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Fan Profile Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `referred_by_bettor_account_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `season_ticket_account_id` SET TAGS ('dbx_business_glossary_term' = 'Season Ticket Account Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_number` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_status` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|suspended|closed|pending_verification|self_excluded|dormant');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_tier` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account Tier');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_tier` SET TAGS ('dbx_value_regex' = 'standard|vip|professional|restricted');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'sportsbook|fantasy|combined|exchange');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `affiliate_code` SET TAGS ('dbx_business_glossary_term' = 'Affiliate Referral Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `age_verified` SET TAGS ('dbx_business_glossary_term' = 'Age Verification Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `age_verified_date` SET TAGS ('dbx_business_glossary_term' = 'Age Verification Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `balance` SET TAGS ('dbx_business_glossary_term' = 'Account Balance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `balance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `bonus_balance` SET TAGS ('dbx_business_glossary_term' = 'Bonus Balance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `bonus_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `bonus_balance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Account Close Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Account Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Account Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Date of Birth');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `deposit_limit_daily` SET TAGS ('dbx_business_glossary_term' = 'Daily Deposit Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `deposit_limit_monthly` SET TAGS ('dbx_business_glossary_term' = 'Monthly Deposit Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `deposit_limit_weekly` SET TAGS ('dbx_business_glossary_term' = 'Weekly Deposit Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Bettor Email Address');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Bettor Full Legal Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_business_glossary_term' = 'Geolocation Verification Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `identity_document_expiry` SET TAGS ('dbx_business_glossary_term' = 'Identity Document Expiry Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `identity_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Identity Document Reference');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `identity_document_reference` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `identity_document_reference` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `identity_document_type` SET TAGS ('dbx_business_glossary_term' = 'Identity Document Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `identity_document_type` SET TAGS ('dbx_value_regex' = 'passport|drivers_license|national_id|state_id');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `kyc_status` SET TAGS ('dbx_business_glossary_term' = 'Know Your Customer (KYC) Verification Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `kyc_status` SET TAGS ('dbx_value_regex' = 'not_started|pending|verified|failed|expired');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `kyc_verified_date` SET TAGS ('dbx_business_glossary_term' = 'Know Your Customer (KYC) Verification Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Account Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `loss_limit_daily` SET TAGS ('dbx_business_glossary_term' = 'Daily Loss Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `marketing_opt_in` SET TAGS ('dbx_business_glossary_term' = 'Marketing Opt-In');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Account Open Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Bettor Phone Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `preferred_sport` SET TAGS ('dbx_business_glossary_term' = 'Preferred Sport');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `promo_code_used` SET TAGS ('dbx_business_glossary_term' = 'Registration Promotional Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `registration_jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Registration Jurisdiction');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `registration_jurisdiction` SET TAGS ('dbx_value_regex' = '[A-Z]{2,3}');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `registration_state_code` SET TAGS ('dbx_business_glossary_term' = 'Registration State Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `registration_state_code` SET TAGS ('dbx_value_regex' = '[A-Z]{2}');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `responsible_gaming_flag_date` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `self_exclusion_end_date` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion End Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `self_exclusion_start_date` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Start Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `self_exclusion_status` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `self_exclusion_status` SET TAGS ('dbx_value_regex' = 'none|voluntary|mandatory|expired');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `source_channel` SET TAGS ('dbx_business_glossary_term' = 'Account Registration Source Channel');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `source_channel` SET TAGS ('dbx_value_regex' = 'web|mobile_app|retail|affiliate|partner');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `tax_id_reference` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Reference');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `tax_id_reference` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `tax_id_reference` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `two_factor_auth_enabled` SET TAGS ('dbx_business_glossary_term' = 'Two-Factor Authentication (2FA) Enabled');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `w2g_threshold_met` SET TAGS ('dbx_business_glossary_term' = 'W-2G Tax Reporting Threshold Met');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ALTER COLUMN `wager_limit_daily` SET TAGS ('dbx_business_glossary_term' = 'Daily Wager Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` SET TAGS ('dbx_subdomain' = 'wagering_operations');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_bet_id` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `betting_market_id` SET TAGS ('dbx_business_glossary_term' = 'Betting Market Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `eligibility_status_id` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Status Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `game_result_id` SET TAGS ('dbx_business_glossary_term' = 'Game Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'League Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `match_result_id` SET TAGS ('dbx_business_glossary_term' = 'Match Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `media_rights_deal_id` SET TAGS ('dbx_business_glossary_term' = 'Media Rights Deal Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `odds_feed_id` SET TAGS ('dbx_business_glossary_term' = 'Source Feed ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `parent_prop_bet_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `participant_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `performance_stat_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Stat Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `athlete_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Athlete ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Event ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `scoring_event_id` SET TAGS ('dbx_business_glossary_term' = 'Scoring Event Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `suspension_record_id` SET TAGS ('dbx_business_glossary_term' = 'Suspension Record Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `age_restriction_years` SET TAGS ('dbx_business_glossary_term' = 'Age Restriction (Years)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `fantasy_sport_type` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `fantasy_sport_type` SET TAGS ('dbx_value_regex' = 'daily_fantasy|season_long|not_applicable');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `fixture_date` SET TAGS ('dbx_business_glossary_term' = 'Fixture Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `is_live_bet` SET TAGS ('dbx_business_glossary_term' = 'Live (In-Play) Bet Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `is_parlay_eligible` SET TAGS ('dbx_business_glossary_term' = 'Parlay Eligible Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `is_same_game_parlay_eligible` SET TAGS ('dbx_business_glossary_term' = 'Same-Game Parlay (SGP) Eligible Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `jurisdiction_codes` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Availability Codes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `line_unit` SET TAGS ('dbx_business_glossary_term' = 'Line Unit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `market_close_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Market Close Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `market_open_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Market Open Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `market_status` SET TAGS ('dbx_business_glossary_term' = 'Market Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `market_status` SET TAGS ('dbx_value_regex' = 'open|suspended|closed|settled|voided|pending');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `max_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payout Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `max_wager_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Wager Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `min_wager_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Wager Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `odds_format` SET TAGS ('dbx_business_glossary_term' = 'Odds Format');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `odds_format` SET TAGS ('dbx_value_regex' = 'decimal|american|fractional|hong_kong|indonesian|malay');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `odds_provider_code` SET TAGS ('dbx_business_glossary_term' = 'Odds Provider Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `odds_provider_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `over_odds` SET TAGS ('dbx_business_glossary_term' = 'Over Odds');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_category` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet Category');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_category` SET TAGS ('dbx_value_regex' = 'player_prop|game_prop|novelty_prop|entertainment_prop|team_prop|series_prop');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_code` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_description` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet Description');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_line_value` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet Line Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_name` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `prop_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet Subcategory');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `regulatory_category` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Category');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `regulatory_category` SET TAGS ('dbx_value_regex' = 'sports_wagering|daily_fantasy|novelty|entertainment|esports');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `settlement_criteria` SET TAGS ('dbx_business_glossary_term' = 'Settlement Criteria');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `settlement_result` SET TAGS ('dbx_business_glossary_term' = 'Settlement Result');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `settlement_result` SET TAGS ('dbx_value_regex' = 'win|lose|void|push|pending');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `settlement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Settlement Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `under_odds` SET TAGS ('dbx_business_glossary_term' = 'Under Odds');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `void_reason` SET TAGS ('dbx_business_glossary_term' = 'Void Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `void_reason` SET TAGS ('dbx_value_regex' = 'event_cancelled|player_did_not_participate|data_error|regulatory_order|insufficient_action|other');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ALTER COLUMN `winning_selection` SET TAGS ('dbx_business_glossary_term' = 'Winning Selection');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` SET TAGS ('dbx_subdomain' = 'fantasy_contest');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `fantasy_league_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Commissioner Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Event Calendar Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `club_id` SET TAGS ('dbx_business_glossary_term' = 'Club Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'League Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `predecessor_fantasy_league_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `age_restriction_minimum` SET TAGS ('dbx_business_glossary_term' = 'Minimum Age Restriction');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `auction_budget` SET TAGS ('dbx_business_glossary_term' = 'Auction Draft Budget');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `bench_slots` SET TAGS ('dbx_business_glossary_term' = 'Bench Slots');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `draft_date` SET TAGS ('dbx_business_glossary_term' = 'Draft Date and Time');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `draft_type` SET TAGS ('dbx_business_glossary_term' = 'Draft Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `draft_type` SET TAGS ('dbx_value_regex' = 'snake|auction|auto_pick|linear|third_round_reversal');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `entry_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Entry Fee Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `entry_fee_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `entry_fee_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `entry_fee_currency` SET TAGS ('dbx_business_glossary_term' = 'Entry Fee Currency');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `entry_fee_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `faab_budget` SET TAGS ('dbx_business_glossary_term' = 'Free Agent Acquisition Budget (FAAB)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `invite_code` SET TAGS ('dbx_business_glossary_term' = 'League Invite Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `invite_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `is_keeper_league` SET TAGS ('dbx_business_glossary_term' = 'Is Keeper League Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `is_public` SET TAGS ('dbx_business_glossary_term' = 'Is Public League Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `keeper_slot_count` SET TAGS ('dbx_business_glossary_term' = 'Keeper Slot Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `league_external_code` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League External ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `league_status` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `league_status` SET TAGS ('dbx_value_regex' = 'forming|draft_pending|active|completed|cancelled|suspended');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `league_type` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `league_type` SET TAGS ('dbx_value_regex' = 'public|private|corporate|satellite|managed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `max_team_count` SET TAGS ('dbx_business_glossary_term' = 'Maximum Team Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `playoff_start_week` SET TAGS ('dbx_business_glossary_term' = 'Playoff Start Week');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `playoff_team_count` SET TAGS ('dbx_business_glossary_term' = 'Playoff Team Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `prize_pool_amount` SET TAGS ('dbx_business_glossary_term' = 'Prize Pool Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `prize_pool_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `prize_pool_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `prize_pool_type` SET TAGS ('dbx_business_glossary_term' = 'Prize Pool Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `prize_pool_type` SET TAGS ('dbx_value_regex' = 'guaranteed|variable|hybrid|no_prize');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `prize_structure` SET TAGS ('dbx_business_glossary_term' = 'Prize Structure');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `prize_structure` SET TAGS ('dbx_value_regex' = 'winner_take_all|top_3|top_half|custom');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `registration_close_date` SET TAGS ('dbx_business_glossary_term' = 'Registration Close Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `registration_open_date` SET TAGS ('dbx_business_glossary_term' = 'Registration Open Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `roster_size` SET TAGS ('dbx_business_glossary_term' = 'Roster Size');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `scoring_format` SET TAGS ('dbx_business_glossary_term' = 'Scoring Format');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `scoring_period_type` SET TAGS ('dbx_business_glossary_term' = 'Scoring Period Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `scoring_period_type` SET TAGS ('dbx_value_regex' = 'weekly|daily|season_long');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `season_end_date` SET TAGS ('dbx_business_glossary_term' = 'Season End Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `season_start_date` SET TAGS ('dbx_business_glossary_term' = 'Season Start Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `sport` SET TAGS ('dbx_business_glossary_term' = 'Sport');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `starter_count` SET TAGS ('dbx_business_glossary_term' = 'Starter Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `team_count` SET TAGS ('dbx_business_glossary_term' = 'Team Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `trade_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Trade Deadline Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `trade_review_type` SET TAGS ('dbx_business_glossary_term' = 'Trade Review Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `trade_review_type` SET TAGS ('dbx_value_regex' = 'commissioner|league_vote|auto_approve|none');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `waiver_type` SET TAGS ('dbx_business_glossary_term' = 'Waiver Wire Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ALTER COLUMN `waiver_type` SET TAGS ('dbx_value_regex' = 'FAAB|rolling|reverse_standings|none');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` SET TAGS ('dbx_subdomain' = 'fantasy_contest');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `fantasy_roster_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Roster ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `competition_round_id` SET TAGS ('dbx_business_glossary_term' = 'Competition Round Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `eligibility_status_id` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Status Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `fantasy_league_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `fantasy_team_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Team ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `injury_record_id` SET TAGS ('dbx_business_glossary_term' = 'Injury Record Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `previous_fantasy_roster_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `athlete_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Athlete ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `roster_id` SET TAGS ('dbx_business_glossary_term' = 'Roster Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `suspension_record_id` SET TAGS ('dbx_business_glossary_term' = 'Suspension Record Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `trade_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Transaction ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Athlete Acquisition Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `acquisition_type` SET TAGS ('dbx_business_glossary_term' = 'Athlete Acquisition Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `acquisition_type` SET TAGS ('dbx_value_regex' = 'drafted|waiver|trade|free_agent|keeper|supplemental_draft');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `auction_draft_price` SET TAGS ('dbx_business_glossary_term' = 'Auction Draft Price');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `commissioner_override` SET TAGS ('dbx_business_glossary_term' = 'Commissioner Override Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `commissioner_override_notes` SET TAGS ('dbx_business_glossary_term' = 'Commissioner Override Notes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `draft_pick_number` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `draft_round` SET TAGS ('dbx_business_glossary_term' = 'Draft Round');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `drop_date` SET TAGS ('dbx_business_glossary_term' = 'Athlete Drop Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `drop_reason` SET TAGS ('dbx_business_glossary_term' = 'Athlete Drop Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `drop_reason` SET TAGS ('dbx_value_regex' = 'voluntary|trade_outgoing|commissioner_action|season_end|ir_replacement');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Roster Effective From Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Roster Effective Until Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `is_ir_eligible` SET TAGS ('dbx_business_glossary_term' = 'Is Injured Reserve (IR) Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `is_starting_lineup` SET TAGS ('dbx_business_glossary_term' = 'Is Starting Lineup Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `keeper_cost_round` SET TAGS ('dbx_business_glossary_term' = 'Keeper Cost Round');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `keeper_year` SET TAGS ('dbx_business_glossary_term' = 'Keeper Year');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `league_format` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League Format');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `league_format` SET TAGS ('dbx_value_regex' = 'redraft|keeper|dynasty|daily_fantasy|best_ball');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `lineup_change_count` SET TAGS ('dbx_business_glossary_term' = 'Lineup Change Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `roster_lock_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Roster Lock Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `roster_reference_code` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Roster Reference Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `roster_reference_code` SET TAGS ('dbx_value_regex' = '^FRST-[A-Z0-9]{6,12}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `roster_slot_position` SET TAGS ('dbx_business_glossary_term' = 'Roster Slot Position');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `roster_status` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Roster Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `roster_status` SET TAGS ('dbx_value_regex' = 'active|locked|pending|cancelled|historical');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `salary_cap_value` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Value');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `salary_cap_value` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `salary_cap_value` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `scoring_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Scoring Period End Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `scoring_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Scoring Period Start Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `season_year` SET TAGS ('dbx_business_glossary_term' = 'Season Year');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `slot_type` SET TAGS ('dbx_business_glossary_term' = 'Roster Slot Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `slot_type` SET TAGS ('dbx_value_regex' = 'starter|bench|injured_reserve|taxi_squad|practice_squad');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `source_platform` SET TAGS ('dbx_business_glossary_term' = 'Source Platform');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `source_platform` SET TAGS ('dbx_value_regex' = 'web|mobile_ios|mobile_android|api|commissioner_tool');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `waiver_claim_priority` SET TAGS ('dbx_business_glossary_term' = 'Waiver Claim Priority');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ALTER COLUMN `waiver_claim_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Waiver Claim Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` SET TAGS ('dbx_subdomain' = 'fantasy_contest');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `fantasy_team_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Team ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `division_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Division ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `fantasy_league_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `predecessor_fantasy_team_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `auction_budget` SET TAGS ('dbx_business_glossary_term' = 'Auction Draft Budget');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `auction_budget_spent` SET TAGS ('dbx_business_glossary_term' = 'Auction Draft Budget Spent');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `autopick_enabled` SET TAGS ('dbx_business_glossary_term' = 'Autopick Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `draft_position` SET TAGS ('dbx_business_glossary_term' = 'Draft Position');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `draft_type` SET TAGS ('dbx_business_glossary_term' = 'Draft Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `draft_type` SET TAGS ('dbx_value_regex' = 'snake|auction|linear|autopick');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `email_notification_enabled` SET TAGS ('dbx_business_glossary_term' = 'Email Notification Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `email_notification_enabled` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `email_notification_enabled` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `faab_budget` SET TAGS ('dbx_business_glossary_term' = 'Free Agent Acquisition Budget (FAAB)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `faab_remaining` SET TAGS ('dbx_business_glossary_term' = 'Free Agent Acquisition Budget (FAAB) Remaining');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Gaming Jurisdiction Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `last_activity_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Activity Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `logo_url` SET TAGS ('dbx_business_glossary_term' = 'Team Logo URL');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `logo_url` SET TAGS ('dbx_value_regex' = '^https?://.+$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `losses` SET TAGS ('dbx_business_glossary_term' = 'Season Losses');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `manager_display_name` SET TAGS ('dbx_business_glossary_term' = 'Team Manager Display Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `manager_display_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `playoff_qualified` SET TAGS ('dbx_business_glossary_term' = 'Playoff Qualified Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `playoff_seed` SET TAGS ('dbx_business_glossary_term' = 'Playoff Seed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `points_against` SET TAGS ('dbx_business_glossary_term' = 'Season Points Against (Season-to-Date)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `points_scored` SET TAGS ('dbx_business_glossary_term' = 'Season Points Scored (Season-to-Date)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `primary_color_hex` SET TAGS ('dbx_business_glossary_term' = 'Team Primary Color Hex Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `primary_color_hex` SET TAGS ('dbx_value_regex' = '^#[0-9A-Fa-f]{6}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `push_notification_enabled` SET TAGS ('dbx_business_glossary_term' = 'Push Notification Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `registration_date` SET TAGS ('dbx_business_glossary_term' = 'Team Registration Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `standing_rank` SET TAGS ('dbx_business_glossary_term' = 'League Standing Rank');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `team_abbreviation` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Team Abbreviation');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `team_abbreviation` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `team_name` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Team Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `team_slogan` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Team Slogan');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `team_status` SET TAGS ('dbx_business_glossary_term' = 'Fantasy Team Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `team_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending|withdrawn');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `ties` SET TAGS ('dbx_business_glossary_term' = 'Season Ties');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `trade_block_status` SET TAGS ('dbx_business_glossary_term' = 'Trade Block Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `trades_accepted` SET TAGS ('dbx_business_glossary_term' = 'Trades Accepted Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `trades_vetoed` SET TAGS ('dbx_business_glossary_term' = 'Trades Vetoed Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `waiver_claims_used` SET TAGS ('dbx_business_glossary_term' = 'Waiver Claims Used');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `waiver_priority` SET TAGS ('dbx_business_glossary_term' = 'Waiver Wire Priority');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ALTER COLUMN `wins` SET TAGS ('dbx_business_glossary_term' = 'Season Wins');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` SET TAGS ('dbx_subdomain' = 'player_management');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `wallet_id` SET TAGS ('dbx_business_glossary_term' = 'Gaming Wallet ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `consolidated_from_wallet_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `payment_method_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Method Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `aml_risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Anti-Money Laundering (AML) Risk Rating');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `aml_risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|very_high');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `aml_risk_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bonus_credit_balance` SET TAGS ('dbx_business_glossary_term' = 'Bonus Credit Balance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bonus_credit_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bonus_credit_balance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bonus_wagering_progress_amount` SET TAGS ('dbx_business_glossary_term' = 'Bonus Wagering Progress Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bonus_wagering_progress_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bonus_wagering_progress_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `bonus_wagering_requirement_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Bonus Wagering Requirement Multiplier');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Wallet Close Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `deposit_limit_daily` SET TAGS ('dbx_business_glossary_term' = 'Daily Deposit Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `deposit_limit_monthly` SET TAGS ('dbx_business_glossary_term' = 'Monthly Deposit Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `deposit_limit_weekly` SET TAGS ('dbx_business_glossary_term' = 'Weekly Deposit Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `dormancy_date` SET TAGS ('dbx_business_glossary_term' = 'Wallet Dormancy Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `dormancy_flag` SET TAGS ('dbx_business_glossary_term' = 'Wallet Dormancy Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `geolocation_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Geolocation Compliance Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `geolocation_compliance_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `geolocation_compliance_flag` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `kyc_verified_flag` SET TAGS ('dbx_business_glossary_term' = 'Know Your Customer (KYC) Verified Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `last_deposit_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Deposit Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `last_transaction_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Transaction Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `last_withdrawal_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Withdrawal Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_bonus_awarded_amount` SET TAGS ('dbx_business_glossary_term' = 'Lifetime Bonus Awarded Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_bonus_awarded_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_bonus_awarded_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_deposit_amount` SET TAGS ('dbx_business_glossary_term' = 'Lifetime Deposit Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_deposit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_deposit_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_withdrawal_amount` SET TAGS ('dbx_business_glossary_term' = 'Lifetime Withdrawal Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_withdrawal_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `lifetime_withdrawal_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `loss_limit_daily` SET TAGS ('dbx_business_glossary_term' = 'Daily Loss Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Wallet Open Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `operator_freeze_reason` SET TAGS ('dbx_business_glossary_term' = 'Operator Freeze Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `operator_freeze_reason` SET TAGS ('dbx_value_regex' = 'aml_investigation|fraud_review|regulatory_order|chargeback_dispute|responsible_gaming|other');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `operator_freeze_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `pending_hold_amount` SET TAGS ('dbx_business_glossary_term' = 'Pending Wager Hold Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `pending_hold_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `pending_hold_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `preferred_odds_format` SET TAGS ('dbx_business_glossary_term' = 'Preferred Odds Format');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `preferred_odds_format` SET TAGS ('dbx_value_regex' = 'american|decimal|fractional|hong_kong|indonesian');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `real_money_balance` SET TAGS ('dbx_business_glossary_term' = 'Real Money Balance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `real_money_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `real_money_balance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Gaming Wallet Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `reference_number` SET TAGS ('dbx_value_regex' = '^GW-[A-Z0-9]{10,20}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `reserved_withdrawal_amount` SET TAGS ('dbx_business_glossary_term' = 'Reserved Withdrawal Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `reserved_withdrawal_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `reserved_withdrawal_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `self_exclusion_end_date` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion End Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `self_exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `session_time_limit_minutes` SET TAGS ('dbx_business_glossary_term' = 'Session Time Limit (Minutes)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,30}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `tax_withholding_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Withholding Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `wager_limit_daily` SET TAGS ('dbx_business_glossary_term' = 'Daily Wager Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `wallet_status` SET TAGS ('dbx_business_glossary_term' = 'Gaming Wallet Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `wallet_status` SET TAGS ('dbx_value_regex' = 'active|suspended|frozen|closed|pending_verification');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `wallet_type` SET TAGS ('dbx_business_glossary_term' = 'Gaming Wallet Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `wallet_type` SET TAGS ('dbx_value_regex' = 'sports_wagering|fantasy_sports|casino|poker|combined');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `withdrawable_balance` SET TAGS ('dbx_business_glossary_term' = 'Withdrawable Balance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `withdrawable_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ALTER COLUMN `withdrawable_balance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Gaming Jurisdiction ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `parent_jurisdiction_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `aml_reporting_threshold` SET TAGS ('dbx_business_glossary_term' = 'Anti-Money Laundering (AML) Reporting Threshold');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `aml_reporting_threshold` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `application_submission_date` SET TAGS ('dbx_business_glossary_term' = 'License Application Submission Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `college_sports_wagering_permitted` SET TAGS ('dbx_business_glossary_term' = 'College Sports Wagering Permitted Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `data_localization_required` SET TAGS ('dbx_business_glossary_term' = 'Data Localization Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `deposit_limit_required` SET TAGS ('dbx_business_glossary_term' = 'Deposit Limit Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `dfs_permitted` SET TAGS ('dbx_business_glossary_term' = 'Daily Fantasy Sports (DFS) Permitted Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `geolocation_required` SET TAGS ('dbx_business_glossary_term' = 'Geolocation Verification Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `geolocation_required` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `geolocation_required` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `ggr_tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Gross Gaming Revenue (GGR) Tax Rate');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `ggr_tax_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `in_play_wagering_permitted` SET TAGS ('dbx_business_glossary_term' = 'In-Play (Live) Wagering Permitted Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `integrity_fee_rate` SET TAGS ('dbx_business_glossary_term' = 'Sports Integrity Fee Rate');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `integrity_fee_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `jurisdiction_name` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `kyc_required` SET TAGS ('dbx_business_glossary_term' = 'Know Your Customer (KYC) Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Market Launch Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `max_single_wager_limit` SET TAGS ('dbx_business_glossary_term' = 'Maximum Single Wager Limit');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `max_single_wager_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `min_age_requirement` SET TAGS ('dbx_business_glossary_term' = 'Minimum Age Requirement');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Compliance Notes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `official_data_mandate` SET TAGS ('dbx_business_glossary_term' = 'Official League Data Mandate Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `online_wagering_permitted` SET TAGS ('dbx_business_glossary_term' = 'Online / Mobile Wagering Permitted Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `promotional_deduction_allowed` SET TAGS ('dbx_business_glossary_term' = 'Promotional Deduction Allowed Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `prop_bet_permitted` SET TAGS ('dbx_business_glossary_term' = 'Proposition Bet (Prop Bet) Permitted Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `region_or_state` SET TAGS ('dbx_business_glossary_term' = 'Region or State / Province');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Frequency');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|annually');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `responsible_gaming_mandates` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Mandates');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `retail_wagering_permitted` SET TAGS ('dbx_business_glossary_term' = 'Retail (In-Person) Wagering Permitted Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `self_exclusion_program_name` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Program Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `sports_wagering_permitted` SET TAGS ('dbx_business_glossary_term' = 'Sports Wagering Permitted Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'License Suspension Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `tax_remittance_frequency` SET TAGS ('dbx_business_glossary_term' = 'Tax Remittance Frequency');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ALTER COLUMN `tax_remittance_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|annually');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` SET TAGS ('dbx_subdomain' = 'player_management');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `responsible_gaming_limit_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Limit ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Obligation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `policy_id` SET TAGS ('dbx_business_glossary_term' = 'Policy Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `primary_superseded_by_limit_responsible_gaming_limit_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Limit ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `regulatory_report_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `activated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Limit Activated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `cooling_off_end_date` SET TAGS ('dbx_business_glossary_term' = 'Cooling-Off End Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|operator_portal|adobe_experience_platform|api_gateway|manual_entry');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `interaction_channel` SET TAGS ('dbx_business_glossary_term' = 'Interaction Channel');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `interaction_channel` SET TAGS ('dbx_value_regex' = 'web|mobile_app|retail_kiosk|telephone|operator_portal|api');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `is_permanent` SET TAGS ('dbx_business_glossary_term' = 'Permanent Limit Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Limit Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_change_direction` SET TAGS ('dbx_business_glossary_term' = 'Limit Change Direction');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_change_direction` SET TAGS ('dbx_value_regex' = 'increase|decrease|new|reinstatement');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Limit Duration (Minutes)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_period` SET TAGS ('dbx_business_glossary_term' = 'Limit Period');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_period` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|annual|per_session|lifetime');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Limit Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_source` SET TAGS ('dbx_business_glossary_term' = 'Limit Source');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_source` SET TAGS ('dbx_value_regex' = 'player_initiated|operator_imposed|regulator_mandated');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_status` SET TAGS ('dbx_business_glossary_term' = 'Limit Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_status` SET TAGS ('dbx_value_regex' = 'pending|active|suspended|revoked|expired');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_type` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Limit Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `limit_type` SET TAGS ('dbx_value_regex' = 'deposit|loss|wager|session_time|cooling_off|self_exclusion');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `operator_notes` SET TAGS ('dbx_business_glossary_term' = 'Operator Notes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `operator_notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `player_acknowledgement_flag` SET TAGS ('dbx_business_glossary_term' = 'Player Acknowledgement Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `player_acknowledgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Player Acknowledgement Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `previous_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Previous Limit Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `previous_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `previous_limit_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `regulatory_notification_sent` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Sent Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `regulatory_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `requested_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Limit Requested Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Limit Review Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Limit Revocation Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_value_regex' = 'player_request|operator_decision|regulator_order|account_closure|system_correction');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `revocation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Limit Revocation Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `risk_trigger_code` SET TAGS ('dbx_business_glossary_term' = 'Risk Trigger Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `self_exclusion_program` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Program');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `self_exclusion_program` SET TAGS ('dbx_value_regex' = 'voluntary|national_registry|state_registry|operator_program');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` SET TAGS ('dbx_subdomain' = 'player_management');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `self_exclusion_id` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Record ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `fan_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Fan Profile Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `investigation_id` SET TAGS ('dbx_business_glossary_term' = 'Investigation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `regulatory_report_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `renewed_self_exclusion_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `streaming_subscription_id` SET TAGS ('dbx_business_glossary_term' = 'Streaming Subscription Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `account_suspension_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Account Suspension Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `acknowledgment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Acknowledgment Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `balance_disposition_status` SET TAGS ('dbx_business_glossary_term' = 'Balance Disposition Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `balance_disposition_status` SET TAGS ('dbx_value_regex' = 'pending|refunded|forfeited|held_regulatory|transferred');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `bonus_clawback_flag` SET TAGS ('dbx_business_glossary_term' = 'Bonus Clawback Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `counseling_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Counseling Completion Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `election_channel` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Election Channel');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `election_channel` SET TAGS ('dbx_value_regex' = 'online|in_person|phone|mail|regulatory_portal|third_party');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_acknowledgment_flag` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Acknowledgment Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_duration_months` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Duration (Months)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_election_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Election Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_end_date` SET TAGS ('dbx_business_glossary_term' = 'Exclusion End Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_reference_number` SET TAGS ('dbx_value_regex' = '^SE-[A-Z]{2,4}-[0-9]{8,12}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_scope` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Scope');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_scope` SET TAGS ('dbx_value_regex' = 'single_platform|all_platforms|statewide|nationwide|global');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_start_date` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Start Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_status` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_status` SET TAGS ('dbx_value_regex' = 'active|expired|reinstated|pending_review|revoked');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_type` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `exclusion_type` SET TAGS ('dbx_value_regex' = 'voluntary_self_exclusion|operator_exclusion|state_mandated_exclusion|ncpg_exclusion|court_ordered_exclusion|guardian_exclusion');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `external_exclusion_list_code` SET TAGS ('dbx_business_glossary_term' = 'External Exclusion List ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `external_exclusion_list_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `external_exclusion_list_code` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `initiated_by` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Initiated By');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `initiated_by` SET TAGS ('dbx_value_regex' = 'bettor|operator|state_authority|court|guardian|ncpg');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `is_permanent` SET TAGS ('dbx_business_glossary_term' = 'Permanent Exclusion Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `marketing_suppression_flag` SET TAGS ('dbx_business_glossary_term' = 'Marketing Suppression Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `ncpg_list_match_flag` SET TAGS ('dbx_business_glossary_term' = 'National Council on Problem Gambling (NCPG) List Match Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Notes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `open_wager_count` SET TAGS ('dbx_business_glossary_term' = 'Open Wager Count at Exclusion');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `open_wager_disposition` SET TAGS ('dbx_business_glossary_term' = 'Open Wager Disposition');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `open_wager_disposition` SET TAGS ('dbx_value_regex' = 'void_all|settle_then_suspend|held_pending|regulatory_directed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `operator_exclusion_reason` SET TAGS ('dbx_business_glossary_term' = 'Operator Exclusion Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `operator_exclusion_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `pending_balance_amount` SET TAGS ('dbx_business_glossary_term' = 'Pending Balance Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `pending_balance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `pending_balance_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `platform_code` SET TAGS ('dbx_business_glossary_term' = 'Gaming Platform Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `regulatory_notification_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `regulatory_notification_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|acknowledged|failed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `regulatory_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `reinstatement_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Reinstatement Approval Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `reinstatement_approval_status` SET TAGS ('dbx_value_regex' = 'not_requested|pending|approved|denied|withdrawn');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `reinstatement_approved_date` SET TAGS ('dbx_business_glossary_term' = 'Reinstatement Approved Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `reinstatement_cooling_off_days` SET TAGS ('dbx_business_glossary_term' = 'Reinstatement Cooling-Off Period (Days)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `reinstatement_request_date` SET TAGS ('dbx_business_glossary_term' = 'Reinstatement Request Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `responsible_gaming_counseling_required` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Counseling Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `state_exclusion_list_match_flag` SET TAGS ('dbx_business_glossary_term' = 'State Exclusion List Match Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `regulatory_report_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `amended_regulatory_report_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `emergency_activation_id` SET TAGS ('dbx_business_glossary_term' = 'Emergency Activation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Fixture Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `regulatory_filing_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `accepted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Acceptance Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `acknowledgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Acknowledgement Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `active_player_count` SET TAGS ('dbx_business_glossary_term' = 'Active Player Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `aml_flagged_transaction_count` SET TAGS ('dbx_business_glossary_term' = 'Anti-Money Laundering (AML) Flagged Transaction Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Report Approval Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `filing_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Filing Deadline Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `ggr_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Gaming Revenue (GGR) Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `ggr_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `internal_review_notes` SET TAGS ('dbx_business_glossary_term' = 'Internal Review Notes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `internal_review_notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `is_amended` SET TAGS ('dbx_business_glossary_term' = 'Amended Report Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `is_late_filing` SET TAGS ('dbx_business_glossary_term' = 'Late Filing Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `kyc_verified_player_count` SET TAGS ('dbx_business_glossary_term' = 'Know Your Customer (KYC) Verified Player Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `original_report_number` SET TAGS ('dbx_business_glossary_term' = 'Original Report Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `regulatory_body_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Report Rejection Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_frequency` SET TAGS ('dbx_business_glossary_term' = 'Report Filing Frequency');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|annual|ad_hoc');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_number` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|acknowledged|under_review|accepted|rejected');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_type` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_type` SET TAGS ('dbx_value_regex' = 'GGR|SAR|self_exclusion_compliance|responsible_gaming_program|AML_KYC');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `report_version` SET TAGS ('dbx_business_glossary_term' = 'Report Version Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `reporting_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Reporting Period End Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `reporting_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Reporting Period Start Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `responsible_gaming_intervention_count` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Intervention Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `sar_count` SET TAGS ('dbx_business_glossary_term' = 'Suspicious Activity Report (SAR) Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `self_exclusion_breach_count` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Breach Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `self_exclusion_count` SET TAGS ('dbx_business_glossary_term' = 'Self-Exclusion Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `sport_category` SET TAGS ('dbx_business_glossary_term' = 'Sport Category');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `submission_channel` SET TAGS ('dbx_business_glossary_term' = 'Submission Channel');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `submission_channel` SET TAGS ('dbx_value_regex' = 'portal|email|API|mail|fax');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Report Submission Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Gaming Tax Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `total_wagers_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Wagers Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `total_wagers_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `total_winnings_paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Winnings Paid Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ALTER COLUMN `total_winnings_paid_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` SET TAGS ('dbx_subdomain' = 'fantasy_contest');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `contest_id` SET TAGS ('dbx_business_glossary_term' = 'Contest ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `bracket_id` SET TAGS ('dbx_business_glossary_term' = 'Bracket Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `broadcast_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Schedule Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `competition_round_id` SET TAGS ('dbx_business_glossary_term' = 'Competition Round Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `season_ticket_package_id` SET TAGS ('dbx_business_glossary_term' = 'Eligible Season Ticket Package Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `collection_id` SET TAGS ('dbx_business_glossary_term' = 'Featured Collection Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Fixture Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Contest Jurisdiction Eligibility - Gaming Jurisdiction Id');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'League Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `sku_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Prize Sku Catalog Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `ticket_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Prize Ticket Inventory Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `asset_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Asset Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `qualifier_contest_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `tournament_id` SET TAGS ('dbx_business_glossary_term' = 'Tournament Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `age_restriction_override` SET TAGS ('dbx_business_glossary_term' = 'Age Restriction Override');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `age_restriction_override` SET TAGS ('dbx_compliance' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `age_restriction_years` SET TAGS ('dbx_business_glossary_term' = 'Age Restriction Years');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contest Completion Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `contest_name` SET TAGS ('dbx_business_glossary_term' = 'Contest Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `contest_status` SET TAGS ('dbx_business_glossary_term' = 'Contest Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `contest_status` SET TAGS ('dbx_value_regex' = 'open|locked|live|completed|cancelled|postponed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `contest_type` SET TAGS ('dbx_business_glossary_term' = 'Contest Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `contest_type` SET TAGS ('dbx_value_regex' = 'GPP|50_50|HEAD_TO_HEAD|SATELLITE|DOUBLE_UP|QUALIFIER');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `eligibility_status` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `eligibility_status` SET TAGS ('dbx_compliance' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `entries_filled` SET TAGS ('dbx_business_glossary_term' = 'Entries Filled');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `entry_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Entry Fee Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `entry_fee_currency` SET TAGS ('dbx_business_glossary_term' = 'Entry Fee Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `entry_fee_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `external_code` SET TAGS ('dbx_business_glossary_term' = 'Contest External ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `is_beginner_only` SET TAGS ('dbx_business_glossary_term' = 'Is Beginner-Only Contest Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `is_featured` SET TAGS ('dbx_business_glossary_term' = 'Is Featured Contest Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `is_free_to_play` SET TAGS ('dbx_business_glossary_term' = 'Is Free-to-Play Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `is_guaranteed` SET TAGS ('dbx_business_glossary_term' = 'Is Guaranteed Prize Pool Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `jurisdiction_codes` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Availability Codes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `jurisdiction_exclusion_codes` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Exclusion Codes');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `lock_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contest Lock Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `max_entries_per_player` SET TAGS ('dbx_business_glossary_term' = 'Maximum Entries Per Player');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `min_entries_required` SET TAGS ('dbx_business_glossary_term' = 'Minimum Entries Required');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `paid_places_count` SET TAGS ('dbx_business_glossary_term' = 'Paid Places Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `platform_code` SET TAGS ('dbx_business_glossary_term' = 'Platform ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_pool_amount` SET TAGS ('dbx_business_glossary_term' = 'Prize Pool Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_pool_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_pool_type` SET TAGS ('dbx_business_glossary_term' = 'Prize Pool Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_pool_type` SET TAGS ('dbx_value_regex' = 'guaranteed|non_guaranteed|overlay');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_reporting_threshold` SET TAGS ('dbx_business_glossary_term' = 'Prize Reporting Threshold');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_reporting_threshold` SET TAGS ('dbx_compliance' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_reporting_threshold` SET TAGS ('dbx_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_structure_type` SET TAGS ('dbx_business_glossary_term' = 'Prize Structure Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `prize_structure_type` SET TAGS ('dbx_value_regex' = 'top_heavy|flat|winner_take_all|tiered');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `rake_percentage` SET TAGS ('dbx_business_glossary_term' = 'Rake Percentage');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `rake_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `registration_open_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Registration Open Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `regulatory_contest_code` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Contest ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `restriction_type` SET TAGS ('dbx_business_glossary_term' = 'Restriction Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `restriction_type` SET TAGS ('dbx_compliance' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `roster_size` SET TAGS ('dbx_business_glossary_term' = 'Roster Size');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `scoring_system_code` SET TAGS ('dbx_business_glossary_term' = 'Scoring System Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `season_year` SET TAGS ('dbx_business_glossary_term' = 'Season Year');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `sport_code` SET TAGS ('dbx_business_glossary_term' = 'Sport Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contest Start Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ALTER COLUMN `total_entries_cap` SET TAGS ('dbx_business_glossary_term' = 'Total Entries Cap');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` SET TAGS ('dbx_subdomain' = 'fantasy_contest');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `contest_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Contest Entry ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `contest_id` SET TAGS ('dbx_business_glossary_term' = 'Contest ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `fantasy_roster_id` SET TAGS ('dbx_business_glossary_term' = 'Lineup ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `operator_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `access_entitlement_id` SET TAGS ('dbx_business_glossary_term' = 'Prize Access Entitlement Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `merch_order_id` SET TAGS ('dbx_business_glossary_term' = 'Prize Merch Order Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `rebuy_of_contest_entry_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `retail_location_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Location Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `ticket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Ticket Order Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `actual_points` SET TAGS ('dbx_business_glossary_term' = 'Actual Fantasy Points Scored');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `bonus_amount_applied` SET TAGS ('dbx_business_glossary_term' = 'Bonus Amount Applied');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `bonus_amount_applied` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `bonus_amount_applied` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `contest_slate_date` SET TAGS ('dbx_business_glossary_term' = 'Contest Slate Date');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `device_type` SET TAGS ('dbx_business_glossary_term' = 'Device Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `device_type` SET TAGS ('dbx_value_regex' = 'desktop|mobile|tablet|smart_tv|other');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Entry Fee Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_fee_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_fee_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_number_in_contest` SET TAGS ('dbx_business_glossary_term' = 'Entry Number in Contest');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Entry Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_reference_number` SET TAGS ('dbx_value_regex' = '^CE-[A-Z0-9]{8,16}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_status` SET TAGS ('dbx_business_glossary_term' = 'Entry Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_status` SET TAGS ('dbx_value_regex' = 'pending|active|locked|settled|cancelled|voided');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Entry Submission Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_type` SET TAGS ('dbx_business_glossary_term' = 'Entry Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `entry_type` SET TAGS ('dbx_value_regex' = 'standard|multi_entry|satellite|qualifier|freeroll');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `final_rank` SET TAGS ('dbx_business_glossary_term' = 'Final Contest Rank');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_business_glossary_term' = 'Geolocation State Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_business_glossary_term' = 'Geolocation Verified Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `geolocation_verified` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `is_autopick` SET TAGS ('dbx_business_glossary_term' = 'Autopick Lineup Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `is_late_swap` SET TAGS ('dbx_business_glossary_term' = 'Late Swap Indicator');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `lineup_edit_count` SET TAGS ('dbx_business_glossary_term' = 'Lineup Edit Count');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `lineup_lock_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Lineup Lock Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `net_entry_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Entry Fee Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `net_entry_fee_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `net_entry_fee_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `payout_status` SET TAGS ('dbx_business_glossary_term' = 'Payout Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `payout_status` SET TAGS ('dbx_value_regex' = 'pending|processed|failed|withheld|cancelled');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `payout_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payout Processed Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `percentile_rank` SET TAGS ('dbx_business_glossary_term' = 'Percentile Rank');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `prize_amount` SET TAGS ('dbx_business_glossary_term' = 'Prize Amount Won');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `prize_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `prize_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `prize_tier` SET TAGS ('dbx_business_glossary_term' = 'Prize Tier');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `projected_points` SET TAGS ('dbx_business_glossary_term' = 'Projected Fantasy Points');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `promotion_code` SET TAGS ('dbx_business_glossary_term' = 'Promotion Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `salary_cap_used` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Used');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `salary_cap_used` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `salary_cap_used` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `settlement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Settlement Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Withheld Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `void_reason` SET TAGS ('dbx_business_glossary_term' = 'Void Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ALTER COLUMN `w2g_reportable` SET TAGS ('dbx_business_glossary_term' = 'W-2G Tax Reportable Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` SET TAGS ('dbx_subdomain' = 'fantasy_contest');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_id` SET TAGS ('dbx_business_glossary_term' = 'Payout ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `bettor_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bettor Account ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `contest_entry_id` SET TAGS ('dbx_business_glossary_term' = 'DFS Contest Entry ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `fantasy_league_id` SET TAGS ('dbx_business_glossary_term' = 'Fantasy League ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `regulatory_report_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `reversed_payout_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `wager_id` SET TAGS ('dbx_business_glossary_term' = 'Wager ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `aml_review_flag` SET TAGS ('dbx_business_glossary_term' = 'Anti-Money Laundering (AML) Review Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `approval_required` SET TAGS ('dbx_business_glossary_term' = 'Manual Approval Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payout Approval Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `bonus_amount_included` SET TAGS ('dbx_business_glossary_term' = 'Bonus Amount Included in Payout');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `bonus_amount_included` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `bonus_amount_included` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payout Completed Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `ctr_reportable` SET TAGS ('dbx_business_glossary_term' = 'Currency Transaction Report (CTR) Reportable Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `failure_reason` SET TAGS ('dbx_business_glossary_term' = 'Payout Failure Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `federal_withholding_rate` SET TAGS ('dbx_business_glossary_term' = 'Federal Tax Withholding Rate');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_business_glossary_term' = 'Geolocation State Code');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `geolocation_state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `ggr_period` SET TAGS ('dbx_business_glossary_term' = 'Gross Gaming Revenue (GGR) Reporting Period');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `ggr_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `gross_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Payout Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `gross_payout_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `gross_payout_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `is_free_bet_payout` SET TAGS ('dbx_business_glossary_term' = 'Free Bet Payout Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `net_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Payout Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `net_payout_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `net_payout_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `odds_at_settlement` SET TAGS ('dbx_business_glossary_term' = 'Odds at Settlement');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `operator_code` SET TAGS ('dbx_business_glossary_term' = 'Operator ID');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_method` SET TAGS ('dbx_business_glossary_term' = 'Payout Method');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_method` SET TAGS ('dbx_value_regex' = 'wallet_credit|ach|check|wire_transfer|paypal|venmo');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_status` SET TAGS ('dbx_business_glossary_term' = 'Payout Status');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_status` SET TAGS ('dbx_value_regex' = 'pending|approved|processing|completed|failed|reversed');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payout Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_type` SET TAGS ('dbx_business_glossary_term' = 'Payout Type');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `payout_type` SET TAGS ('dbx_value_regex' = 'wager_settlement|dfs_contest_prize|fantasy_league_prize|bonus_conversion|promotional_credit|free_bet_winnings');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `prize_rank` SET TAGS ('dbx_business_glossary_term' = 'Prize Rank');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `processor_name` SET TAGS ('dbx_business_glossary_term' = 'Payment Processor Name');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `processor_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Processor Reference');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Payout Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `reference_number` SET TAGS ('dbx_value_regex' = '^PAY-[A-Z0-9]{10,20}$');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `responsible_gaming_flag` SET TAGS ('dbx_business_glossary_term' = 'Responsible Gaming (RG) Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Payout Reversal Reason');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'sportsbook|dfs_platform|fantasy_platform|retail_terminal|bonus_engine');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `stake_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Stake Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `stake_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `stake_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `state_withholding_amount` SET TAGS ('dbx_business_glossary_term' = 'State Tax Withholding Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `state_withholding_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `state_withholding_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Withheld Amount');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `tax_withheld_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `w2g_form_reference` SET TAGS ('dbx_business_glossary_term' = 'IRS W-2G Form Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `w2g_form_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ALTER COLUMN `w2g_reportable` SET TAGS ('dbx_business_glossary_term' = 'IRS W-2G Reportable Flag');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `operator_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `parent_operator_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `geolocation_verification_enabled` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `geolocation_verification_enabled` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `headquarters_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `headquarters_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `headquarters_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `headquarters_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `headquarters_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `headquarters_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `license_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `mobile_app_available` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `mobile_app_available` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `odds_feed_provider` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `operator_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `operator_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `parent_company_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `payment_processor` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `platform_provider` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `reporting_threshold_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ALTER COLUMN `tax_withholding_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` SET TAGS ('dbx_subdomain' = 'wagering_operations');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ALTER COLUMN `selection_id` SET TAGS ('dbx_business_glossary_term' = 'Selection Identifier');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ALTER COLUMN `athlete_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Athlete Profile Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ALTER COLUMN `match_result_id` SET TAGS ('dbx_business_glossary_term' = 'Match Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ALTER COLUMN `parent_selection_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ALTER COLUMN `scoring_event_id` SET TAGS ('dbx_business_glossary_term' = 'Scoring Event Id (Foreign Key)');
