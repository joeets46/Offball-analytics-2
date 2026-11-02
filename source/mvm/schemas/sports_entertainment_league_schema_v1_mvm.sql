-- Schema for Domain: league | Business: Sports Entertainment | Version: v1_mvm
-- Generated on: 2026-05-09 04:52:10

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `sports_entertainment_ecm`.`league` COMMENT 'Competition governance domain managing league structure, division hierarchies, team franchises, season calendars, standings, officiating (VAR/TMO), rule enforcement, disciplinary actions, and competitive integrity. Owns league identity, franchise agreements, draft rules, salary cap compliance, CBA compliance, and regulatory oversight across professional sports organizations (NFL, NBA, MLB, NHL, MLS, FIFA, IOC).';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`league` (
    `league_id` BIGINT COMMENT 'Unique surrogate identifier for each professional sports league or governing body record. Primary key for the league master data product and the enterprise-wide SSOT for league identity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: The league entity is a legal organization with its own company code for statutory reporting, tax-exempt status management (tax_exempt_status field on league), and consolidated financial reporting. Fou',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Every professional sports league operates under a primary regulatory/governing body (e.g., state athletic commissions, FCC for broadcast, anti-doping authorities). Linking league to its primary govern',
    `acronym` STRING COMMENT 'Widely recognized abbreviation or acronym for the league (e.g., NFL, NBA, MLB, NHL, MLS, FIFA). Used in fan-facing platforms, broadcast graphics, merchandise labeling, and digital content.. Valid values are `^[A-Z]{2,10}$`',
    `age_category` STRING COMMENT 'Age classification of the leagues competition tier (e.g., senior, under_23, under_21, under_18, youth, masters). Governs player eligibility rules, NIL agreement applicability, and draft eligibility criteria.. Valid values are `senior|under_23|under_21|under_18|youth|masters`',
    `anti_doping_body` STRING COMMENT 'Name of the anti-doping authority responsible for testing and enforcement within this league (e.g., WADA, USADA, UKAD). Determines PED (Performance Enhancing Drug) testing protocols and suspension adjudication processes.',
    `cba_expiry_date` DATE COMMENT 'Date on which the current Collective Bargaining Agreement between the league and its players association expires. Critical for labor relations planning, salary cap projections, and franchise agreement renewals.',
    `championship_name` STRING COMMENT 'Official name of the leagues championship event or trophy (e.g., Super Bowl, NBA Finals, World Series, Stanley Cup Finals, MLS Cup). Used in broadcast rights agreements, sponsorship contracts, merchandise licensing, and fan engagement campaigns.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the leagues primary country of operation (e.g., USA, GBR, DEU). Drives regulatory jurisdiction, GDPR/CCPA applicability, tax treatment, and broadcast rights territory mapping.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this league record was first created in the enterprise data platform (Silver Layer). Supports data lineage, audit trail, and GDPR data subject request processing.',
    `draft_enabled` BOOLEAN COMMENT 'Indicates whether this league conducts an annual player draft for team roster building. Drives draft scheduling, eligibility tracking, and scouting report workflows.',
    `draft_round_count` STRING COMMENT 'Total number of rounds in the leagues annual player draft. Null if draft_enabled is false. Used for draft scheduling, pick tracking, and athlete eligibility management.',
    `expansion_team_count` STRING COMMENT 'Number of expansion franchises currently approved but not yet fully operational within the league. Used for franchise agreement tracking, revenue sharing projections, and stadium development planning.',
    `founding_year` STRING COMMENT 'The calendar year in which the league or governing body was officially established or chartered. Used for historical analytics, anniversary campaigns, and brand heritage reporting.',
    `games_per_team_per_season` STRING COMMENT 'Standard number of regular season games each team plays per season (e.g., 17 for NFL, 82 for NBA, 162 for MLB, 82 for NHL, 34 for MLS). Drives fixture scheduling, broadcast slot allocation, and ticket inventory planning.',
    `gender_category` STRING COMMENT 'Gender classification of the leagues competition (e.g., mens, womens, mixed, open). Required for regulatory compliance, Title IX reporting, IOC charter alignment, and fan engagement segmentation.. Valid values are `mens|womens|mixed|open`',
    `headquarters_city` STRING COMMENT 'City where the leagues principal administrative offices are located (e.g., New York, London, Zurich). Used for regulatory correspondence, legal jurisdiction determination, and operational logistics.',
    `headquarters_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the leagues principal administrative offices are registered. Determines primary legal jurisdiction, tax domicile, and applicable data privacy regulations (GDPR, CCPA).. Valid values are `^[A-Z]{3}$`',
    `ip_owner_entity` STRING COMMENT 'Legal entity name that holds the IP (Intellectual Property) rights for the leagues brand, marks, and content (e.g., NFL Properties LLC, NBA Properties Inc.). Critical for DRM (Digital Rights Management) enforcement, licensing agreements, and SOX IP asset reporting.',
    `league_code` STRING COMMENT 'Externally-known short alphanumeric code uniquely identifying the league (e.g., NFL, NBA, MLB, NHL, MLS, FIFA, IOC). Used as the business-facing identifier across systems, broadcasts, and partner integrations.. Valid values are `^[A-Z0-9]{2,10}$`',
    `league_status` STRING COMMENT 'Current operational lifecycle status of the league. active indicates the league is currently operating seasons; inactive indicates temporary cessation; suspended indicates regulatory or disciplinary hold; dissolved indicates permanent closure; founding indicates pre-launch setup phase.. Valid values are `active|inactive|suspended|dissolved|founding`',
    `league_type` STRING COMMENT 'Classification of the league by competitive tier and professional status. Determines CBA applicability, salary cap rules, NIL eligibility, and broadcast rights tier.. Valid values are `professional|semi_professional|amateur|governing_body|developmental`',
    `num_conferences` STRING COMMENT 'Total number of conferences within the league hierarchy. Relevant for playoff bracket construction, revenue distribution, and broadcast rights packaging.',
    `num_divisions` STRING COMMENT 'Total number of competitive divisions within the league structure. Drives standings calculations, playoff qualification rules, and scheduling algorithms.',
    `num_teams` STRING COMMENT 'Total number of franchised or member teams currently active in the league. Used for scheduling, revenue sharing calculations, playoff seeding, and expansion planning.',
    `official_name` STRING COMMENT 'Full legal and official name of the league or governing body as registered with the relevant governing authority (e.g., National Football League, Fédération Internationale de Football Association). Used in legal documents, broadcast agreements, and regulatory filings.',
    `officiating_body` STRING COMMENT 'Name of the organization or department responsible for recruiting, training, assigning, and evaluating match officials within this league (e.g., NFL Officiating Department, NBA Referee Operations, FIFA Referees Committee).',
    `ott_platform_name` STRING COMMENT 'Name of the leagues owned or primary OTT (Over-The-Top Streaming) DTC (Direct-To-Consumer) streaming platform (e.g., NFL+, NBA League Pass, MLB.TV). Drives digital content distribution, ARPU tracking, and fan engagement analytics.',
    `playoff_format` STRING COMMENT 'Description of the playoff or championship round structure (e.g., Best-of-7 series, Single elimination bracket, 16-team bracket). Used for event scheduling, broadcast planning, and fan engagement content. [ENUM-REF-CANDIDATE: best_of_7|best_of_5|single_elimination|double_elimination|round_robin_final|two_leg_aggregate — promote to reference product]',
    `revenue_sharing_model` STRING COMMENT 'Model used to distribute league-level revenues (broadcast rights, sponsorship, merchandise licensing) among member franchises. Drives financial planning, EBITDA reporting, and franchise valuation analytics.. Valid values are `equal_share|performance_based|hybrid|none`',
    `salary_cap_amount` DECIMAL(18,2) COMMENT 'Current season salary cap ceiling amount in USD applicable to all teams in the league. Null if salary_cap_enabled is false. Used for CBA compliance monitoring, athlete contract validation, and financial planning.',
    `salary_cap_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the salary cap amount (e.g., USD, EUR, GBP). Required for multi-currency leagues such as FIFA-affiliated competitions.. Valid values are `^[A-Z]{3}$`',
    `salary_cap_enabled` BOOLEAN COMMENT 'Indicates whether this league enforces a salary cap on team payrolls. Drives salary cap compliance tracking, CBA enforcement, and athlete contract validation within the athlete.salary_cap_entry domain.',
    `season_end_month` STRING COMMENT 'Calendar month (1–12) in which the leagues regular season (excluding playoffs) typically concludes. Used for broadcast rights window planning, venue scheduling, and off-season operations.',
    `season_format` STRING COMMENT 'Structural format of the competitive season (e.g., regular_season_playoff for NFL/NBA/MLB/NHL, round_robin for FIFA group stages, knockout for single-elimination tournaments). Governs fixture scheduling, standings logic, and championship determination.. Valid values are `regular_season_playoff|round_robin|knockout|league_cup|mixed`',
    `season_start_month` STRING COMMENT 'Calendar month (1–12) in which the leagues regular season typically begins. Used for fixture calendar generation, broadcast scheduling, venue operations planning, and merchandise launch timing.',
    `social_media_handle` STRING COMMENT 'Primary social media handle or username for the leagues official account (e.g., @NFL, @NBA). Used for fan engagement tracking, UGC (User Generated Content) moderation, and digital marketing attribution.',
    `sport_type` STRING COMMENT 'The primary sport governed by this league (e.g., American Football, Basketball, Baseball, Ice Hockey, Soccer, Tennis, Mixed Martial Arts). Drives domain-specific rules, analytics models, and content classification. [ENUM-REF-CANDIDATE: american_football|basketball|baseball|ice_hockey|soccer|tennis|mixed_martial_arts|golf|rugby|cricket|cycling|athletics — promote to reference product]',
    `tax_exempt_status` BOOLEAN COMMENT 'Indicates whether the league operates as a tax-exempt organization under applicable tax law (e.g., 501(c)(6) in the USA). Impacts financial reporting, SAP FI/CO configuration, and SOX compliance controls.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this league record in the enterprise data platform. Used for change data capture, incremental ETL processing, and audit trail compliance.',
    `var_enabled` BOOLEAN COMMENT 'Indicates whether Video Assistant Referee (VAR) or equivalent video review technology (e.g., TMO in rugby) is officially sanctioned and deployed in this leagues competitions. Drives officiating assignment workflows and broadcast production requirements.',
    `website_url` STRING COMMENT 'Official public-facing website URL for the league or governing body (e.g., https://www.nfl.com). Used for digital asset management, fan engagement platform linking, and partner integration directories.. Valid values are `^https?://[^s/$.?#].[^s]*$`',
    CONSTRAINT pk_league PRIMARY KEY(`league_id`)
) COMMENT 'Master record for each professional sports league or governing body (NFL, NBA, MLB, NHL, MLS, FIFA, IOC, etc.). Captures league identity, founding year, sport type, governing body affiliation, headquarters, official name, acronym, active status, and league-level configuration such as number of teams, playoff format, and championship structure. This is the SSOT for league identity across the enterprise.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`conference` (
    `conference_id` BIGINT COMMENT 'Unique surrogate identifier for the conference record within the Sports Entertainment lakehouse. Primary key for the conference entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Conferences operate as distinct cost centers in major leagues (e.g., AFC/NFC, Eastern/Western). Conference-level officiating costs, administrative expenses, and playoff operations are tracked against ',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Conferences operate under specific governing body rules (WADA compliance, CBA applicability, competition regulations). Conference-level compliance reporting requires structured FK; conference has gove',
    `league_id` BIGINT COMMENT 'Reference to the parent league that owns and governs this conference (e.g., NFL, NBA, MLB, NHL, MLS, FIFA). Establishes the organizational hierarchy from league down to conference.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Conferences generate revenue through broadcast allocation, playoff revenue sharing, and licensing. Conference-level profit centers enable P&L reporting by conference — distinct from the existing leagu',
    `abbreviation` STRING COMMENT 'Short uppercase alphanumeric code used to identify the conference in standings tables, broadcast graphics, ticketing systems, and digital platforms (e.g., AFC, NFC, AL, NL, EC, WC).. Valid values are `^[A-Z]{2,10}$`',
    `ada_compliance_required` BOOLEAN COMMENT 'Indicates whether venues and events under this conferences jurisdiction are required to comply with ADA (Americans with Disabilities Act) accessibility standards. Relevant for US-based conferences and venue operations management.',
    `broadcast_tier` STRING COMMENT 'Classification of the broadcast rights tier applicable to this conferences games and events. Determines whether media rights are distributed nationally, regionally via RSN (Regional Sports Network), internationally, locally, or exclusively via OTT (Over-The-Top Streaming) platforms.. Valid values are `national|regional|international|local|ott_exclusive`',
    `cba_applicable` BOOLEAN COMMENT 'Indicates whether a Collective Bargaining Agreement (CBA) governs player and team operations within this conference. True if CBA rules apply to salary cap, roster limits, and player rights. Critical for CBA compliance reporting.',
    `conference_code` STRING COMMENT 'Externally-known alphanumeric business identifier for the conference used in system integrations, API payloads, and data exchange with broadcast partners, ticketing platforms (Ticketmaster/AXS, Archtics), and Salesforce CRM.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `conference_description` STRING COMMENT 'Free-text narrative description of the conference, including its history, competitive structure, notable championships, and organizational purpose. Used in fan engagement platforms, broadcast content, and digital asset management.',
    `conference_name` STRING COMMENT 'Official full name of the conference as recognized by the governing league body (e.g., American Football Conference, Eastern Conference, American League, Western Conference).',
    `conference_status` STRING COMMENT 'Current lifecycle status of the conference. Active indicates the conference is currently operating within a live season. Inactive indicates off-season or dormant. Suspended indicates operations are paused due to regulatory or governance action. Dissolved indicates the conference no longer exists.. Valid values are `active|inactive|suspended|dissolved|pending`',
    `conference_type` STRING COMMENT 'Classification of the organizational subdivision type. Distinguishes between a conference (NFL AFC/NFC), association (NBA Eastern/Western), league division (MLB American/National League), group, or pool used in tournament structures.. Valid values are `conference|association|league_division|group|pool`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code representing the primary country of operation for this conference (e.g., USA, CAN, GBR). Supports international regulatory compliance (GDPR, CCPA) and global broadcast rights distribution.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this conference record was first created in the Sports Entertainment lakehouse Silver layer. Supports data lineage, audit trail requirements, and SOX financial controls for governance entities.',
    `division_count` STRING COMMENT 'Number of divisions contained within this conference for the current or most recent active season. Used for standings structure validation, playoff seeding logic, and league governance reporting.',
    `effective_end_date` DATE COMMENT 'The specific calendar date on which this conference was officially dissolved, merged, or deactivated. Null for currently active conferences. Supports bi-temporal data modeling and historical governance reporting.',
    `effective_start_date` DATE COMMENT 'The specific calendar date on which this conference became officially recognized and operationally active under league governance. Supports temporal validity tracking and historical standings reconstruction.',
    `founded_date` DATE COMMENT 'The official date on which the conference was formally established and recognized by its governing league body. Supports historical analytics, anniversary campaigns, and governance documentation.',
    `games_per_team` STRING COMMENT 'The standard number of regular season games each team within this conference is scheduled to play per season. Used for fixture calendar generation, broadcast rights valuation, and revenue forecasting in Workday Adaptive Planning.',
    `geographic_alignment` STRING COMMENT 'Describes the geographic or regional basis for the conference grouping (e.g., East, West, North, South, Central, National, American, International). Used for standings aggregation, broadcast territory mapping (RSN alignment), and fan engagement segmentation.',
    `headquarters_city` STRING COMMENT 'City where the conference administrative headquarters is located. Used for regulatory jurisdiction determination, tax reporting (SAP S/4HANA FI), and governance correspondence.',
    `headquarters_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code for the country where the conference administrative headquarters is registered. Determines applicable regulatory frameworks (GDPR for EU, CCPA for California, SOX for US public entities).. Valid values are `^[A-Z]{3}$`',
    `is_international` BOOLEAN COMMENT 'Indicates whether this conference operates across multiple countries or is classified as an international competition body (e.g., FIFA international competitions, IOC-governed events). Drives international broadcast rights, GDPR compliance scope, and multi-currency financial reporting.',
    `iso_20121_certified` BOOLEAN COMMENT 'Indicates whether this conference has achieved or requires ISO 20121 Event Sustainability Management System certification for its events and operations. Supports ESG reporting and sustainability governance.',
    `notes` STRING COMMENT 'Internal operational notes or governance annotations related to this conference record. May include restructuring history, merger details, or pending rule changes. For internal use by league operations and data governance teams.',
    `official_website_url` STRING COMMENT 'The official public-facing website URL for the conference. Used in fan engagement platforms, digital content distribution, and CRM (Customer Relationship Management) communications via Salesforce CRM.. Valid values are `^https?://[^s/$.?#].[^s]*$`',
    `playoff_berth_count` STRING COMMENT 'Number of playoff berths allocated to this conference per season under current league rules. Drives playoff seeding logic, standings aggregation, and broadcast scheduling for postseason events.',
    `playoff_format` STRING COMMENT 'The playoff competition format used by this conference to determine its representative(s) for the league championship. Drives bracket generation logic in event planning systems and broadcast scheduling.. Valid values are `single_elimination|double_elimination|round_robin|seeded_bracket|wild_card`',
    `primary_timezone` STRING COMMENT 'IANA time zone identifier representing the primary operational time zone for scheduling conference games and events (e.g., America/New_York, America/Los_Angeles, Europe/London). Used in event scheduling, broadcast production, and fan engagement platforms.',
    `region_name` STRING COMMENT 'Descriptive geographic region name for the conferences operational territory (e.g., North America, Europe, Asia-Pacific). Used for international broadcast rights distribution, OTT platform segmentation, and global fan engagement analytics.',
    `salary_cap_applicable` BOOLEAN COMMENT 'Indicates whether a salary cap rule applies to teams competing within this conference. Drives salary cap compliance validation in athlete contract and roster management workflows.',
    `schedule_format` STRING COMMENT 'The game scheduling format used within this conference (e.g., balanced where all teams play each other equally, unbalanced with division-weighted scheduling, interleague with cross-conference games). Drives fixture calendar generation.. Valid values are `balanced|unbalanced|interleague|round_robin|hybrid`',
    `season_end_year` STRING COMMENT 'The calendar year in which this conference ceased active operations. Null if the conference is currently active. Used for historical reporting, dissolved conference analytics, and governance audit trails.',
    `season_start_year` STRING COMMENT 'The calendar year in which this conference first became active and began competitive operations. Used to calculate conference tenure, historical analytics, and franchise agreement timelines.',
    `social_media_handle` STRING COMMENT 'Primary social media handle or username for the conferences official social media presence (e.g., @AFC on Twitter/X). Used in fan engagement analytics via Adobe Experience Platform and digital content distribution strategies.',
    `sport_type` STRING COMMENT 'The sport discipline governed by this conference (e.g., American Football, Basketball, Baseball, Ice Hockey, Soccer). Supports cross-sport analytics and reporting within the Sports Entertainment enterprise. [ENUM-REF-CANDIDATE: american_football|basketball|baseball|ice_hockey|soccer|tennis|mixed_martial_arts|golf|rugby|cricket — promote to reference product]',
    `team_count` STRING COMMENT 'Total number of franchise teams currently assigned to this conference. Supports salary cap compliance calculations, CBA compliance reporting, and playoff bracket generation.',
    `tiebreaker_rules_version` STRING COMMENT 'Version identifier of the official tiebreaker rules document governing standings tie resolution within this conference. Ensures standings calculations and playoff seeding logic reference the correct ruleset for a given season.',
    `tmo_enabled` BOOLEAN COMMENT 'Indicates whether Television Match Official (TMO) review technology is officially enabled for officiating decisions within this conference. Relevant for rugby and other sports using TMO protocols.',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this conference record was most recently modified in the Sports Entertainment lakehouse Silver layer. Supports change data capture, audit trail requirements, and data quality monitoring.',
    `var_enabled` BOOLEAN COMMENT 'Indicates whether Video Assistant Referee (VAR) technology is officially enabled and mandated for officiating within this conference. Relevant for FIFA-governed competitions and MLS. Supports officiating assignment and broadcast production planning.',
    `wada_compliance_required` BOOLEAN COMMENT 'Indicates whether athletes competing in this conference are subject to World Anti-Doping Agency (WADA) anti-doping regulations and Performance Enhancing Drug (PED) testing protocols.',
    CONSTRAINT pk_conference PRIMARY KEY(`conference_id`)
) COMMENT 'Organizational subdivision of a league representing a conference or association grouping (e.g., AFC/NFC in NFL, Eastern/Western Conference in NBA, American/National League in MLB). Tracks conference name, abbreviation, parent league, geographic alignment, number of divisions, and active season range. Supports standings aggregation and playoff seeding logic.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`division` (
    `division_id` BIGINT COMMENT 'Unique surrogate identifier for the division record within the Sports Entertainment lakehouse. Primary key for the league.division data product.',
    `conference_id` BIGINT COMMENT 'Reference to the parent conference within the league (e.g., NFC, AFC, Eastern Conference, American League) under which this division is organized. Drives scheduling rules and playoff seeding.',
    `league_id` BIGINT COMMENT 'Reference to the parent professional league (e.g., NFL, NBA, MLB, NHL, MLS, FIFA) that governs this division. Used to resolve the full organizational hierarchy: league → conference → division.',
    `abbreviation` STRING COMMENT 'Short alphanumeric code representing the division for use in scoreboards, data feeds, broadcast overlays, and API responses (e.g., NFCE, ALC, ATL). Must be unique within the parent league.. Valid values are `^[A-Z0-9]{2,10}$`',
    `ada_compliance_required` BOOLEAN COMMENT 'Indicates whether venues hosting this divisions events must comply with Americans with Disabilities Act (ADA) accessibility standards. Relevant for US-based divisions and drives venue operations compliance checks.',
    `broadcast_tier` STRING COMMENT 'Classification of the broadcast rights tier applicable to this divisions games. Determines whether games are distributed via national network, Regional Sports Network (RSN), local market, international syndication, or exclusively via Over-The-Top (OTT) streaming. Informs content rights window configuration in Dalet Galaxy.. Valid values are `national|regional|local|international|ott_only`',
    `cba_agreement_code` STRING COMMENT 'Reference code for the Collective Bargaining Agreement (CBA) governing labor relations, player contracts, salary structures, and working conditions for teams within this division. Links to the applicable CBA document version. Classified confidential as it contains sensitive labor negotiation references.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code representing the primary country of operation for this division (e.g., USA, CAN, GBR). Relevant for international leagues (FIFA, IOC) and cross-border regulatory compliance (GDPR, CCPA).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this division record was first created in the Sports Entertainment lakehouse Silver layer. Supports data lineage, audit trail requirements, and SOX financial controls for league governance data.',
    `current_team_count` STRING COMMENT 'Actual number of active member franchises/teams currently assigned to this division in the current season. Drives scheduling algorithms and standings table generation.',
    `division_code` STRING COMMENT 'Externally-known alphanumeric business identifier for the division used in system integrations, data exchange with broadcast partners, ticketing systems (Ticketmaster/AXS, Archtics), and ERP (SAP S/4HANA SD) configurations. Distinct from the display abbreviation.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `division_name` STRING COMMENT 'Official full name of the division as designated by the governing league body (e.g., NFC East, AL Central, Atlantic Division, Pacific Division). Used in standings displays, broadcast graphics, and official publications.',
    `division_status` STRING COMMENT 'Current operational lifecycle status of the division. active indicates the division is currently competing; inactive indicates off-season or temporarily dormant; suspended indicates governance-imposed suspension; dissolved indicates the division has been permanently disbanded; pending indicates formation approved but not yet operational.. Valid values are `active|inactive|suspended|dissolved|pending`',
    `division_type` STRING COMMENT 'Classification of the divisions organizational basis — whether it is structured by geographic region, competitive skill level, age group, or gender category. Informs scheduling logic and playoff qualification criteria.. Valid values are `geographic|skill_level|age_group|gender|other`',
    `draft_order_method` STRING COMMENT 'The method used to determine the order in which teams within this division select players in the league draft (e.g., inverse_standings where the worst team picks first, lottery for randomized selection, hybrid combining both). Governs athlete.draft_selection records.. Valid values are `inverse_standings|lottery|hybrid|waiver|none`',
    `effective_from_date` DATE COMMENT 'The date from which the current division configuration (membership, rules, salary cap) became effective. Supports slowly changing dimension (SCD) tracking for historical standings and compliance audits.',
    `effective_until_date` DATE COMMENT 'The date on which the current division configuration ceases to be effective (nullable for open-ended configurations). Supports SCD Type 2 historical tracking for league restructuring events and CBA renegotiations.',
    `external_league_ref_code` STRING COMMENT 'The division identifier as assigned by the governing bodys external data feed or official API (e.g., NFLs official data partner code, FIFAs competition ID, Stats Perform division code). Used for data reconciliation with third-party broadcast and analytics data providers.',
    `founded_date` DATE COMMENT 'The official date on which this division was established or formally recognized by the governing league body. Used for historical analytics, anniversary marketing campaigns, and league governance records.',
    `games_per_team_regular_season` STRING COMMENT 'The number of regular season games each team within this division is scheduled to play per season (e.g., 17 for NFL, 82 for NBA, 162 for MLB, 82 for NHL). Drives fixture calendar generation and broadcast scheduling.',
    `gdpr_applicable` BOOLEAN COMMENT 'Indicates whether fan data collected in connection with this divisions events and broadcasts is subject to GDPR (General Data Protection Regulation) requirements. Relevant for divisions operating in EU markets. Drives data privacy controls in Adobe Experience Platform and Salesforce CRM.',
    `geographic_region` STRING COMMENT 'Descriptive geographic territory associated with the division (e.g., East, West, Central, North, South, Pacific, Atlantic). Used for scheduling optimization, travel cost management, and fan market segmentation in Adobe Experience Platform.',
    `intra_division_games` STRING COMMENT 'Number of games each team plays against other teams within the same division per regular season. Used in fixture scheduling algorithms to enforce divisional rivalry game requirements and scheduling balance rules.',
    `max_team_count` STRING COMMENT 'Maximum number of member franchises/teams permitted within this division as defined by the leagues franchise agreement and CBA (Collective Bargaining Agreement). Used for expansion planning and franchise governance.',
    `nil_policy_applicable` BOOLEAN COMMENT 'Indicates whether Name, Image, and Likeness (NIL) agreement policies apply to athletes competing within this division. When True, athlete.nil_agreement records are subject to divisional NIL governance rules.',
    `notes` STRING COMMENT 'Free-text field for league operations staff to record supplementary governance notes, historical context, restructuring rationale, or administrative remarks about this division. Not used in automated processing.',
    `officiating_standard` STRING COMMENT 'The officiating technology and review standard applied to matches within this division. Indicates whether Video Assistant Referee (VAR) or Television Match Official (TMO) review protocols are active, or whether standard officiating applies. Drives officiating_assignment configurations in the event domain.. Valid values are `var_enabled|tmo_enabled|standard|enhanced|none`',
    `playoff_qualification_spots` STRING COMMENT 'Number of teams from this division that qualify for post-season playoff competition. Governs divisional standings cutoff logic and tiebreaker rule application. Critical for competitive integrity and fan engagement communications.',
    `primary_color_hex` STRING COMMENT 'Hexadecimal color code representing the primary brand color associated with this division (e.g., #013369 for NFL). Used in broadcast graphics, digital platform UI theming, and merchandise design specifications.. Valid values are `^#[0-9A-Fa-f]{6}$`',
    `revenue_sharing_applicable` BOOLEAN COMMENT 'Indicates whether league-wide revenue sharing provisions apply to franchises within this division. When True, finance.profit_center and finance.intercompany_settlement records must account for divisional revenue distribution per the CBA and franchise agreement terms.',
    `salary_cap_amount` DECIMAL(18,2) COMMENT 'The maximum total player salary expenditure permitted for teams within this division for the current season, expressed in the leagues operating currency (USD). Governed by the CBA and enforced by the league office. Classified confidential as it is a sensitive financial governance figure.',
    `salary_cap_applicable` BOOLEAN COMMENT 'Indicates whether a salary cap constraint governed by the CBA (Collective Bargaining Agreement) applies to teams within this division. When True, athlete.salary_cap_entry records are enforced at the division level for compliance reporting.',
    `salary_cap_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the salary cap amount (e.g., USD, CAD, EUR). Required for international leagues (FIFA, MLS) operating across multiple currency jurisdictions.. Valid values are `^[A-Z]{3}$`',
    `season_end_month` STRING COMMENT 'Calendar month (1–12) in which the divisions regular season typically concludes. Used for post-season planning, broadcast rights windows, and financial period alignment in SAP S/4HANA FI/CO.',
    `season_format` STRING COMMENT 'The competitive format used within the division for regular season play (e.g., round_robin where all teams play each other, single_elimination, hybrid combining round-robin and knockout stages). Drives fixture generation in the event scheduling system.. Valid values are `round_robin|single_elimination|double_elimination|hybrid|other`',
    `season_start_month` STRING COMMENT 'Calendar month (1–12) in which the divisions regular season typically begins. Used for season calendar planning, broadcast rights scheduling, and Workday Adaptive Planning financial forecasting cycles.',
    `sport_type` STRING COMMENT 'The sport discipline governed by this division (e.g., football, basketball, baseball, hockey, soccer). Drives sport-specific rule sets, officiating assignments (VAR/TMO), and performance analytics configurations in SportsCode/Hudl. [ENUM-REF-CANDIDATE: football|basketball|baseball|hockey|soccer|tennis|mixed_martial_arts|other — promote to reference product]',
    `tiebreaker_rule_set` STRING COMMENT 'Identifier or descriptive label for the official tiebreaker rules applied when two or more teams are equal in divisional standings (e.g., NFL_2024_TIEBREAKER, NBA_CONF_TIEBREAKER_V3). References the leagues official competition rules document. Drives automated standings calculation logic.',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this division record was most recently modified in the Sports Entertainment lakehouse Silver layer. Supports incremental data processing, change data capture, and audit trail requirements.',
    `wada_compliance_required` BOOLEAN COMMENT 'Indicates whether athletes competing in this division are subject to World Anti-Doping Agency (WADA) anti-doping testing protocols and Performance Enhancing Drug (PED) regulations. When True, athlete.suspension_record and eligibility_status records must reference WADA compliance outcomes.',
    CONSTRAINT pk_division PRIMARY KEY(`division_id`)
) COMMENT 'Sub-grouping within a conference representing a competitive division (e.g., NFC East, AL Central, Atlantic Division). Stores division name, abbreviation, parent conference, parent league, geographic region, number of member teams, and active status. Drives divisional standings, scheduling rules, and playoff qualification criteria.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`franchise` (
    `franchise_id` BIGINT COMMENT 'Unique surrogate identifier for the franchise record in the league domain. Primary key for the franchise master data product.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Each franchise is a separate legal entity with its own company code for statutory reporting, tax filing, and intercompany settlement with the league. This is a fundamental financial structure link req',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Franchise operational costs (team travel, staff, facilities) are charged to franchise cost centers. Budget variance reporting and opex allocation for franchise operations require this link. Standard s',
    `division_id` BIGINT COMMENT 'Reference to the current division or conference within the league to which this franchise is assigned for competitive scheduling and standings purposes.',
    `venue_id` BIGINT COMMENT 'Reference to the primary home venue where this franchise plays its home games, used for scheduling, ticketing, and venue operations.',
    `league_id` BIGINT COMMENT 'Reference to the league (e.g., NFL, NBA, MLB, NHL, MLS, FIFA) under whose governance this franchise holds its membership license.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Each franchise is a distinct profit center for P&L reporting, revenue sharing calculations, and franchise valuation. Sports finance teams run franchise-level P&L reports requiring this link. A domain ',
    `abbreviation` STRING COMMENT 'Official short-form abbreviation for the franchise used in scoreboards, standings, broadcast graphics, and data feeds (e.g., KC, LAL, NYY). Typically 2–5 uppercase letters.. Valid values are `^[A-Z]{2,5}$`',
    `active_roster_count` STRING COMMENT 'Number of players currently on the franchises active roster as of the most recent official roster filing snapshot. Must comply with league-mandated roster size limits under the CBA.',
    `agreement_effective_date` DATE COMMENT 'The date from which the current franchise agreement terms become legally binding and operationally effective.',
    `agreement_execution_date` DATE COMMENT 'The date on which the current version of the franchise agreement was formally executed and signed by both the franchise ownership and the league governing body.',
    `agreement_expiry_date` DATE COMMENT 'The date on which the current franchise agreement expires and must be renewed or renegotiated. Null for perpetual agreements.',
    `agreement_version` STRING COMMENT 'Version identifier of the current franchise agreement governing this franchises league membership (e.g., v3.2, 2022-Amendment-1). Tracks which contractual terms are in force.',
    `amendment_history_notes` STRING COMMENT 'Free-text notes summarizing the history of amendments made to the franchise agreement since its original execution, including amendment dates and key changes. Full amendment documents are stored in the DAM.',
    `competitive_integrity_flag` BOOLEAN COMMENT 'Indicates whether the franchise is currently under a competitive integrity review or investigation by the league (True = under review). Used for governance and disciplinary tracking.',
    `disciplinary_sanction_status` STRING COMMENT 'Current disciplinary sanction status of the franchise as imposed by the league governing body. Tracks active penalties affecting franchise operations, draft eligibility, or competitive standing. [ENUM-REF-CANDIDATE: none|warning_issued|fined|draft_pick_forfeited|suspended|under_investigation — promote to reference product]. Valid values are `none|warning_issued|fined|draft_pick_forfeited|suspended|under_investigation`',
    `draft_pick_order_priority` STRING COMMENT 'The franchises current draft selection order priority for the upcoming league draft, as determined by the prior seasons standings and any applicable draft pick trades. Lower number = earlier selection.',
    `expansion_fee_paid` DECIMAL(18,2) COMMENT 'The one-time expansion fee paid by the ownership group upon admission of this franchise to the league. Applicable only to expansion franchises; null for original member franchises.',
    `founding_year` STRING COMMENT 'The calendar year in which the franchise was originally established or granted its league membership. Used to distinguish original franchises from expansion teams.',
    `franchise_status` STRING COMMENT 'Current operational lifecycle status of the franchise within the league. active = currently competing; suspended = temporarily barred from competition; defunct = no longer operating; expansion_pending = approved but not yet competing; relocated = moved to a new market.. Valid values are `active|suspended|defunct|expansion_pending|relocated`',
    `injured_reserve_count` STRING COMMENT 'Number of players currently designated on the Injured Reserve (IR) list in the most recent official roster filing snapshot. Tracks roster compliance and cap implications of IR designations.',
    `is_cba_participant` BOOLEAN COMMENT 'Indicates whether this franchise is an active participant in the current Collective Bargaining Agreement (CBA). Relevant for salary cap compliance, player relations, and labor dispute governance.',
    `is_expansion_franchise` BOOLEAN COMMENT 'Indicates whether this franchise was admitted to the league as an expansion team (True) as opposed to being an original founding member franchise (False). Affects expansion fee tracking and revenue sharing tiers.',
    `legal_name` STRING COMMENT 'Full legal registered name of the franchise entity as filed with the league and applicable regulatory bodies (e.g., Kansas City Chiefs Football Club, LLC).',
    `market_city` STRING COMMENT 'The primary city or metropolitan area in which the franchise is based and markets itself (e.g., Kansas City, Los Angeles, New York). Used for territorial rights enforcement and market analysis.',
    `market_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the franchises primary market (e.g., USA, CAN, GBR). Required for international leagues and cross-border regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `official_website_url` STRING COMMENT 'The official public-facing website URL for the franchise, used for fan engagement, digital platform integration, and content distribution.. Valid values are `^https?://[^s/$.?#].[^s]*$`',
    `ownership_transfer_rules_summary` STRING COMMENT 'Summary of the key ownership transfer rules applicable to this franchise under the league agreement, including approval thresholds, right-of-first-refusal provisions, and prohibited ownership structures.',
    `practice_squad_count` STRING COMMENT 'Number of players currently on the franchises practice squad as of the most recent official roster filing snapshot. Practice squad limits are defined by the applicable CBA.',
    `primary_jersey_color` STRING COMMENT 'The primary jersey color associated with the franchises home uniform, used for broadcast graphics, merchandise production, and brand identity management.',
    `record_created_timestamp` TIMESTAMP COMMENT 'The timestamp when this franchise master record was first created in the system, used for data lineage, audit trail, and governance compliance.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this franchise master record was most recently modified, used for change tracking, data lineage, and audit compliance.',
    `relocation_restriction_expiry_date` DATE COMMENT 'The date on which the relocation restriction clause in the franchise agreement expires, after which the franchise may apply to relocate subject to league approval. Null if no restriction or restriction is permanent.',
    `relocation_restriction_flag` BOOLEAN COMMENT 'Indicates whether the franchise agreement contains an active relocation restriction clause (True) preventing the franchise from moving to a new market without league approval during the restriction period.',
    `revenue_sharing_tier` STRING COMMENT 'Classification tier that determines this franchises revenue sharing obligations and entitlements under the leagues revenue distribution model (e.g., national media rights, gate receipts). Tier definitions vary by league.. Valid values are `tier_1|tier_2|tier_3|tier_4`',
    `roster_compliance_status` STRING COMMENT 'Current compliance status of the franchises official roster filing against league rules and CBA requirements. compliant = all roster limits met; non_compliant = violation identified; under_review = league audit in progress; waiver_granted = exception approved.. Valid values are `compliant|non_compliant|under_review|waiver_granted`',
    `roster_snapshot_date` DATE COMMENT 'The date on which the most recent official roster filing snapshot was captured and submitted to the league for compliance verification.',
    `salary_cap_allotment` DECIMAL(18,2) COMMENT 'The maximum total player salary expenditure permitted for this franchise in the current league season under the applicable CBA salary cap rules. Expressed in USD.',
    `salary_cap_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the salary cap allotment (e.g., USD, CAD, EUR). Required for international leagues operating in multiple currencies.. Valid values are `^[A-Z]{3}$`',
    `social_media_handle` STRING COMMENT 'The primary social media handle or username for the franchises official account (e.g., @Chiefs on X/Twitter), used for fan engagement tracking and digital content distribution.',
    `team_nickname` STRING COMMENT 'The publicly recognized team nickname or mascot name (e.g., Chiefs, Lakers, Yankees). Used in fan-facing communications, broadcasting, and merchandise.',
    `territorial_rights_description` STRING COMMENT 'Narrative description of the exclusive geographic territory granted to this franchise under its league membership agreement, defining the protected market area within which no other franchise may operate.',
    `valuation_estimate` DECIMAL(18,2) COMMENT 'Most recent estimated market valuation of the franchise in USD, as reported by the league or a recognized financial publication (e.g., Forbes). Used for ownership transfer approvals, expansion fee benchmarking, and financial reporting.',
    CONSTRAINT pk_franchise PRIMARY KEY(`franchise_id`)
) COMMENT 'Master record for each team franchise holding a league membership license, including the governing franchise agreement terms. Captures franchise legal name, market city/metro area, team nickname, abbreviation, founding year, ownership entity reference, home venue reference, current league and division membership, historical relocation records, expansion/original franchise flag, franchise valuation estimate, active/suspended/defunct status, and CBA participation flag. Also stores franchise agreement terms: territorial rights, revenue sharing obligations, relocation restrictions, expansion fees, ownership transfer rules, agreement version, execution date, governing CBA reference, and amendment history. Tracks official roster filing snapshots (active roster count, IR, practice squad, compliance status) at points in time. SSOT for franchise identity, membership governance, and roster compliance.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`season` (
    `season_id` BIGINT COMMENT 'Primary key for season',
    `venue_id` BIGINT COMMENT 'Reference to the pre-designated venue for the championship event when a neutral site is used. Populated only when neutral_site_championship_flag is true. Drives venue operations, ADA compliance, and OSHA safety planning.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Sports seasons map to fiscal periods for salary cap year accounting, broadcast revenue recognition (ASC 606/IFRS 15), and financial close reporting. Finance teams align season boundaries to fiscal per',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Each season operates under a specific governing bodys rules and oversight (WADA compliance, CBA rules, competition regulations). Season-level regulatory compliance reporting and governing body annual',
    `league_id` BIGINT COMMENT 'Reference to the league entity that owns and governs this season (e.g., NFL, NBA, MLB, NHL, MLS, FIFA competition). Anchors the season to its governing body.',
    `bye_teams` STRING COMMENT 'Number of top-seeded franchises that receive a first-round bye (automatic advancement to the second round without playing). Zero if no byes are granted. Impacts bracket scheduling and revenue from first-round games.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this season record was first created in the system. Supports audit trail, data lineage, and governance compliance requirements.',
    `draft_date` DATE COMMENT 'The scheduled date of the player draft associated with this season. Used for roster planning, scouting timelines, and broadcast scheduling of the draft event.',
    `draft_year` STRING COMMENT 'The calendar year of the player draft associated with this season. Links the season to its corresponding draft class for eligibility, salary slot, and roster planning purposes.',
    `end_date` DATE COMMENT 'Official last date of the season including all postseason play. Anchors contract expirations, salary cap year close, and broadcast rights termination.',
    `expansion_season_flag` BOOLEAN COMMENT 'Indicates whether this season includes one or more expansion franchises entering the league for the first time. When true, expansion draft rules, schedule adjustments, and revenue sharing modifications apply.',
    `free_agency_start_date` DATE COMMENT 'The date on which the free agency signing period opens for this season, allowing franchises to negotiate and sign unrestricted free agents. Anchors contract activity, salary cap management, and roster building timelines.',
    `games_per_team` STRING COMMENT 'Total number of regular season games scheduled per franchise/team as mandated by the league schedule. Used for standings calculations (win percentage), broadcast rights game counts, and revenue projections.',
    `home_advantage_rule` STRING COMMENT 'Description of the rule governing which franchise hosts games in a playoff series (e.g., Higher seed hosts games 1, 2, 5, 7, Higher seed hosts all games). Impacts venue scheduling, ticket revenue allocation, and broadcast logistics.',
    `luxury_tax_threshold` DECIMAL(18,2) COMMENT 'The payroll threshold above which a franchise incurs luxury tax penalties for this season, as defined in the CBA. Expressed in the salary cap currency. Used for franchise financial compliance monitoring.',
    `neutral_site_championship_flag` BOOLEAN COMMENT 'Indicates whether the championship game/series is played at a pre-selected neutral venue rather than the higher seeds home venue (e.g., Super Bowl, FIFA World Cup Final). Impacts venue booking, ticket allocation, and broadcast production planning.',
    `notes` STRING COMMENT 'Free-text field for league administrators to record significant contextual notes about the season (e.g., rule changes, format modifications, special circumstances). Used for governance documentation and historical reference.',
    `officiating_system` STRING COMMENT 'The video review and officiating technology system in use for this season: VAR (Video Assistant Referee) for soccer/football, TMO (Television Match Official) for rugby, challenge_system for MLB/NFL, or standard for traditional officiating without video review. Governs officiating assignment and incident review workflows.. Valid values are `VAR|TMO|standard|challenge_system|none`',
    `playoff_format` STRING COMMENT 'The bracket format used for the postseason: single_elimination (one loss ends participation), best_of_series (series of games, e.g., best-of-7), double_elimination, round_robin, or hybrid. Governs bracket structure, scheduling, and broadcast rights for postseason.. Valid values are `single_elimination|best_of_series|double_elimination|round_robin|hybrid`',
    `playoff_rounds` STRING COMMENT 'Total number of rounds in the postseason bracket from first round through championship (e.g., 4 rounds for NBA: First Round, Semifinals, Conference Finals, Finals). Drives bracket position assignments and series scheduling.',
    `playoff_teams` STRING COMMENT 'Total number of franchises/teams that qualify for the postseason bracket (e.g., 12 for NFL, 16 for NBA, 16 for NHL). Determines seeding slots, bracket size, and bye eligibility.',
    `postseason_end_date` DATE COMMENT 'Official last date of the postseason including the championship event. Marks the close of the competitive season for all governance and compliance purposes.',
    `postseason_start_date` DATE COMMENT 'Official start date of the postseason/playoff bracket. Triggers playoff ticketing, broadcast rights escalation, and championship merchandise activation.',
    `regular_season_end_date` DATE COMMENT 'Official last date of the regular season schedule before postseason begins. Used to finalize standings, seeding, and playoff bracket assignments.',
    `regular_season_start_date` DATE COMMENT 'Official start date of the regular season competitive schedule, distinct from preseason. Used to trigger standings calculations, fantasy sports activations, and broadcast rights windows.',
    `roster_freeze_date` DATE COMMENT 'The date by which all franchise rosters must be finalized and submitted to the league for the season. Triggers eligibility locks for regular season and postseason participation.',
    `salary_cap_amount` DECIMAL(18,2) COMMENT 'The maximum total player salary expenditure permitted per franchise for this season as set by the CBA. Expressed in USD. Anchors all salary cap compliance checks, contract valuations, and trade deadline calculations.',
    `salary_cap_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the salary cap amount (e.g., USD, CAD). Required for multi-national leagues such as NHL and MLS where franchises operate in different currency jurisdictions.. Valid values are `^[A-Z]{3}$`',
    `salary_cap_year_flag` BOOLEAN COMMENT 'Indicates whether this season constitutes a salary cap year for compliance and roster management purposes. When true, salary cap rules, luxury tax thresholds, and CBA roster limits apply to all franchises for this season.',
    `season_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying the season across systems (e.g., NFL-2024-REG, NBA-2024-25). Used as the business key in scheduling, ticketing, and broadcast rights systems.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `season_name` STRING COMMENT 'Human-readable display name for the season (e.g., 2024-25 NBA Regular Season, 2024 NFL Season). Used in fan-facing platforms, broadcast graphics, and reporting dashboards.',
    `season_status` STRING COMMENT 'Current lifecycle state of the season: upcoming (scheduled but not started), active (currently in progress), suspended (temporarily halted, e.g., due to labor dispute or force majeure), completed (all games concluded), or cancelled (season voided). Drives downstream scheduling, ticketing, and broadcast activation.. Valid values are `upcoming|active|suspended|completed|cancelled`',
    `season_type` STRING COMMENT 'Classification of the season phase: preseason (training/exhibition games), regular (standard competitive schedule), postseason (playoff/championship bracket), allstar (mid-season showcase event), or exhibition (non-competitive friendly). Drives scheduling, standings, and broadcast rights logic.. Valid values are `preseason|regular|postseason|allstar|exhibition`',
    `seeding_methodology` STRING COMMENT 'Description of the method used to assign playoff seeding positions to qualifying franchises (e.g., Conference record then division winner priority, Overall league record, Win percentage with tiebreaker rules). Governs bracket position assignments and home-court/field advantage.',
    `series_games_format` STRING COMMENT 'The number of games in each playoff series (e.g., best_of_7 for NBA/NHL Finals, best_of_5 for early rounds, single_game for NFL playoff rounds). Drives game scheduling, broadcast rights windows, and venue booking.. Valid values are `best_of_3|best_of_5|best_of_7|single_game|best_of_2`',
    `shortened_season_flag` BOOLEAN COMMENT 'Indicates whether this season was shortened from the standard games_per_team count due to labor disputes, pandemic, or other force majeure events. When true, prorated salary cap and adjusted standings rules apply.',
    `start_date` DATE COMMENT 'Official first date of the season as declared by the league governing body. Anchors all scheduling, ticket on-sale windows, and broadcast rights activation.',
    `theme` STRING COMMENT 'Official marketing theme or campaign name for the season as defined by the league (e.g., NBA 75th Anniversary Season, NFL 100). Used in fan engagement, merchandise, and content production campaigns.',
    `trade_deadline_date` DATE COMMENT 'The last date on which franchises may execute player trades during the regular season. After this date, rosters are locked for playoff eligibility. Critical for roster management, salary cap compliance, and fan engagement.',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this season record was last modified. Supports change tracking, audit trail, and Silver layer incremental processing in the Databricks Lakehouse.',
    `wada_compliance_flag` BOOLEAN COMMENT 'Indicates whether this season is subject to WADA (World Anti-Doping Agency) anti-doping testing protocols and reporting requirements. When true, all PED (Performance Enhancing Drug) testing, suspension, and reporting obligations apply.',
    `year` STRING COMMENT 'The primary calendar year associated with the season (e.g., 2024). For multi-year seasons (e.g., NBA 2024-25), this represents the start year. Used as the anchor year for salary cap, CBA compliance, and draft calculations.',
    CONSTRAINT pk_season PRIMARY KEY(`season_id`)
) COMMENT 'Defines a competitive season calendar and postseason structure for a league. Captures season year, season type (regular, preseason, postseason), official start and end dates, number of scheduled games per team, salary cap year flag, CBA governing version, and season status (upcoming, active, completed). Includes playoff/postseason bracket definition: bracket format (single elimination, best-of-series), number of rounds, seeding methodology, bye rules, home-court/field advantage rules, bracket position assignments per franchise, advancement status, and series results through each round to championship. Anchors all scheduling, standings, draft, and compliance calculations.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`league_schedule` (
    `league_schedule_id` BIGINT COMMENT 'Unique surrogate identifier for the official league game schedule record. Primary key for the schedule data product in the league competition governance domain.',
    `league_id` BIGINT COMMENT 'Reference to the professional league (e.g., NFL, NBA, MLB, NHL, MLS, FIFA) that owns and published this schedule record. Drives league-specific scheduling rules and CBA compliance.',
    `playoff_bracket_id` BIGINT COMMENT 'Foreign key linking to league.playoff_bracket. Business justification: Playoff games in the schedule belong to a specific playoff bracket. Adding playoff_bracket_id to schedule links playoff game schedule entries to their governing bracket structure, enabling bracket pro',
    `franchise_id` BIGINT COMMENT 'Reference to the franchise designated as the home team for this scheduled game. Determines venue assignment, gate revenue allocation, and home/away scheduling balance tracking.',
    `rescheduled_from_league_schedule_id` BIGINT COMMENT 'Self-referencing identifier pointing to the original schedule record from which this game was rescheduled. Enables rescheduling lineage tracking, broadcast rights re-assignment audit, and ticketing system (Ticketmaster/AXS) rebooking reconciliation. Null for games that have never been rescheduled.',
    `season_id` BIGINT COMMENT 'Reference to the competitive season (e.g., 2024-2025 NFL Season) to which this scheduled game belongs. Used for standings calculations and season-level reporting.',
    `venue_id` BIGINT COMMENT 'Reference to the facility where the game is scheduled to be played. Links to venue operations for capacity planning, ADA compliance, and OSHA safety requirements. May differ from home franchises primary venue for neutral-site or relocated games.',
    `attendance_capacity` STRING COMMENT 'The maximum approved attendance capacity for this specific game at the assigned venue, which may differ from the venues total capacity due to configuration, ADA requirements, or safety restrictions. Used by Archtics for seating inventory management and Ticketmaster/AXS for ticket allocation.',
    `broadcast_network` STRING COMMENT 'Name of the primary broadcast network or platform assigned to air this game (e.g., ESPN, NBC, Fox, CBS, TNT, Amazon Prime Video, Apple TV+, DAZN). Used for media rights compliance, CPM (Cost Per Mille) reporting, and RSN (Regional Sports Network) distribution tracking.',
    `competitive_integrity_flag` BOOLEAN COMMENT 'Indicates whether this game has been flagged for competitive integrity review by the league governance office (e.g., suspected tanking, unusual betting patterns, officiating review). Triggers escalation to CAS (Court of Arbitration for Sport) or league disciplinary processes.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the country in which the game is played (e.g., USA, GBR, MEX, CAN). Required for international broadcast rights geo-restriction, GDPR applicability determination, and FIFA/IOC international match governance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and timestamp when this schedule record was first created in the system. Audit trail field for data lineage, SOX financial controls compliance, and Silver layer lakehouse record management.',
    `game_number` STRING COMMENT 'Externally-known official league-assigned game identifier (e.g., NFL-2024-001234). Used across ticketing systems (Ticketmaster/AXS), broadcast scheduling (Dalet Galaxy), and fan engagement platforms (Adobe Experience Platform) as the cross-system reference key.. Valid values are `^[A-Z]{2,5}-[0-9]{4}-[0-9]{4,6}$`',
    `game_type` STRING COMMENT 'Classification of the game within the competitive calendar. Determines standings eligibility, salary cap transaction window compliance, broadcast rights tier, and ticket pricing strategy. [ENUM-REF-CANDIDATE: regular_season|playoff|exhibition|neutral_site|all_star|championship|play_in|wild_card — promote to reference product]. Valid values are `regular_season|playoff|exhibition|neutral_site|all_star|championship`',
    `gate_revenue_split_pct` DECIMAL(18,2) COMMENT 'The contractually agreed percentage of gate revenue allocated to the visiting (away) franchise for this game, as defined in the leagues revenue sharing agreement. Confidential financial term used by SAP S/4HANA (SD/FI modules) for revenue recognition and intercompany settlement.',
    `international_broadcast_flag` BOOLEAN COMMENT 'Indicates whether this game has international broadcast rights activated beyond the domestic market. Triggers GDPR-compliant geo-restriction logic for OTT/DTC streaming platforms and international media rights window management in Dalet Galaxy.',
    `is_home_away_reversed` BOOLEAN COMMENT 'Indicates whether the standard home/away designation has been reversed for this game (e.g., a team plays a home game at the opponents venue due to facility unavailability or international series). Used for scheduling balance audits and CBA home game count compliance.',
    `is_neutral_site` BOOLEAN COMMENT 'Indicates whether the game is played at a neutral venue not affiliated with either franchise (e.g., Super Bowl, NBA Finals, FIFA World Cup Final, international series games). Affects home/away revenue allocation, venue selection logic, and scheduling balance calculations.',
    `matchday_label` STRING COMMENT 'Human-readable label for the scheduling period as published by the league (e.g., Matchday 12, Week 7, Round of 16, Wild Card Weekend, Opening Day). Used in fan-facing communications, broadcast graphics, and digital content distribution.',
    `original_scheduled_date` DATE COMMENT 'The initially published league calendar date for this game before any postponement or rescheduling. Retained for audit trail, rescheduling impact analysis, and CBA transaction window compliance verification. Null if the game has never been rescheduled.',
    `original_start_time` TIMESTAMP COMMENT 'The initially published start timestamp for this game before any time change or rescheduling. Retained alongside original_scheduled_date for complete rescheduling audit trail and broadcast rights window compliance tracking.',
    `postponement_reason` STRING COMMENT 'Categorized reason for a game postponement or cancellation. Required for league governance reporting, insurance claims, broadcast rights force majeure provisions, and ISO 20121 event sustainability documentation. Null when scheduling_status is confirmed. [ENUM-REF-CANDIDATE: weather|facility_issue|public_safety|broadcast_conflict|force_majeure|covid_protocol|labor_dispute|bereavement|other — promote to reference product]',
    `ppv_flag` BOOLEAN COMMENT 'Indicates whether this game is designated as a Pay-Per-View (PPV) broadcast event, requiring separate consumer purchase beyond standard subscription. Affects OTT/DTC revenue recognition, broadcast rights activation, and FCC PPV reporting requirements.',
    `published_timestamp` TIMESTAMP COMMENT 'The date and timestamp when this schedule record was officially published by the league to external stakeholders (teams, broadcasters, ticketing partners, fans). Represents the business event time of schedule release, distinct from internal record creation.',
    `round_number` STRING COMMENT 'The round or matchday number within the season or tournament phase (e.g., FIFA Matchday 12, MLB Series Game 3, NBA Playoff Round 2). Used for bracket progression, standings, and competition governance. Null for week-based league formats.',
    `salary_cap_window_flag` BOOLEAN COMMENT 'Indicates whether this game date falls within a salary cap compliance reporting window as defined by the applicable CBA. Used by league finance and compliance teams to trigger cap audit checkpoints aligned to the competitive calendar.',
    `scheduled_date` DATE COMMENT 'The official league-published calendar date on which the game is scheduled to be played (yyyy-MM-dd). Used as the primary planning date for event operations, venue staffing, and broadcast scheduling. Represents the current confirmed date (may differ from original_scheduled_date if rescheduled).',
    `scheduled_start_time` TIMESTAMP COMMENT 'The precise date and timestamp (yyyy-MM-ddTHH:mm:ss.SSSXXX) at which the game is scheduled to begin, including timezone offset. Used for broadcast slot coordination, gate opening logistics, and fan notification via Adobe Experience Platform.',
    `scheduling_status` STRING COMMENT 'Current lifecycle state of the scheduled game. Drives downstream event operations, broadcast slot management, ticketing refund workflows (Ticketmaster/AXS), and standings calculation eligibility. Confirmed = league-approved and published; Postponed = delayed with new date TBD; Cancelled = permanently removed; Rescheduled = new date assigned; Pending = awaiting league confirmation; Suspended = mid-game stoppage requiring resumption.. Valid values are `confirmed|postponed|cancelled|rescheduled|pending|suspended`',
    `season_phase` STRING COMMENT 'The phase of the competitive season in which this game falls. Drives CBA transaction window rules (e.g., trade deadlines, roster eligibility), salary cap compliance windows, and broadcast rights tier activation.. Valid values are `preseason|regular_season|postseason|offseason`',
    `series_game_number` STRING COMMENT 'The sequential game number within a playoff or regular-season series between the same two franchises (e.g., Game 3 of 7 in an NBA Playoff series, Game 2 of 3 in an MLB series). Null for non-series single-game matchups.',
    `series_game_total` STRING COMMENT 'The maximum number of games in the series to which this game belongs (e.g., best-of-7 = 7, best-of-5 = 5, two-game series = 2). Used alongside series_game_number for bracket progression logic and playoff scheduling management.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this schedule record originated (e.g., TICKETMASTER, AXS, SAP_SD, ARCHTICS, LEAGUE_API). Required for data lineage tracking in the Databricks Silver layer and cross-system reconciliation.. Valid values are `TICKETMASTER|AXS|SAP_SD|ARCHTICS|MANUAL|LEAGUE_API`',
    `ticket_on_sale_date` DATE COMMENT 'The date on which tickets for this game become available for public purchase via Ticketmaster/AXS and DTC (Direct-To-Consumer) channels. Drives fan engagement campaign scheduling in Adobe Experience Platform and Salesforce CRM outreach workflows.',
    `timezone` STRING COMMENT 'IANA timezone identifier for the venue location where the game is played (e.g., America/New_York, Europe/London, Asia/Tokyo). Required for accurate broadcast scheduling, fan notification timing, and international rights window management.. Valid values are `^[A-Za-z]+/[A-Za-z_]+$`',
    `transaction_window_compliant` BOOLEAN COMMENT 'Indicates whether this game falls within a CBA-defined transaction window (e.g., trade deadline, waiver period, roster freeze). Critical for league compliance officers to validate that no prohibited roster moves occurred in the window surrounding this game.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and timestamp when this schedule record was most recently modified. Used for change data capture (CDC) in the Databricks Silver layer, downstream broadcast and ticketing system synchronization, and audit trail compliance.',
    `var_enabled` BOOLEAN COMMENT 'Indicates whether Video Assistant Referee (VAR) or equivalent video review technology (e.g., TMO in rugby, instant replay in NFL/NBA/MLB) is activated for this game. Drives broadcast production requirements (OB truck setup) and officiating crew composition.',
    `weather_condition` STRING COMMENT 'Categorized weather condition at game time for outdoor or open-air venues. Used for operational planning, OSHA safety compliance, postponement risk assessment, and post-event reporting. Indoor applies to fully enclosed venues regardless of external conditions. [ENUM-REF-CANDIDATE: clear|cloudy|rain|snow|fog|extreme_heat|wind_advisory|indoor — 8 candidates stripped; promote to reference product]',
    `week_number` STRING COMMENT 'The sequential week number within the season calendar (e.g., NFL Week 1 through Week 18). Used for standings calculations, bye week tracking, and scheduling balance analysis. Applicable primarily to weekly-format leagues (NFL, NHL, NBA). Null for round-based or matchday-based competitions.',
    CONSTRAINT pk_league_schedule PRIMARY KEY(`league_schedule_id`)
) COMMENT 'Official league-published game schedule record linking two franchises to a specific date, time, venue, and season week/round/matchday. Includes home/away designation, broadcast window assignment, game type (regular season, playoff, neutral site, exhibition), scheduling status (confirmed, postponed, cancelled, rescheduled), original vs. revised date tracking, and transaction window compliance flag. Serves as the planning backbone for event operations, broadcast scheduling, and standings calculations.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`standing` (
    `standing_id` BIGINT COMMENT 'Unique surrogate identifier for a competitive standing snapshot record within the league data domain.',
    `conference_id` BIGINT COMMENT 'Reference to the conference (e.g., AFC, NFC, Eastern, Western) within which the franchise competes for this standing snapshot.',
    `division_id` BIGINT COMMENT 'Reference to the division within which the franchise competes and is ranked for this standing snapshot.',
    `franchise_id` BIGINT COMMENT 'Reference to the team franchise whose competitive standing is captured in this record.',
    `league_id` BIGINT COMMENT 'Reference to the professional league (e.g., NFL, NBA, MLB, NHL, MLS, FIFA) under whose governance this standing is recorded.',
    `playoff_bracket_id` BIGINT COMMENT 'Foreign key linking to league.playoff_bracket. Business justification: Standings determine playoff seeding and bracket placement. Adding playoff_bracket_id to standing links a franchises standing snapshot to the playoff bracket it feeds into, enabling seed-to-bracket ma',
    `season_id` BIGINT COMMENT 'Reference to the competitive season (e.g., 2024-25 NBA season) for which this standing snapshot applies.',
    `away_losses` STRING COMMENT 'Total number of losses recorded in away (road) games as of the snapshot date.',
    `away_ties` STRING COMMENT 'Total number of ties or draws recorded in away (road) games. Applicable in MLS, FIFA, and NFL regular season formats.',
    `away_wins` STRING COMMENT 'Total number of wins recorded in away (road) games as of the snapshot date. Used in tiebreaker resolution.',
    `clinch_indicator` STRING COMMENT 'Standard league clinch/elimination indicator code displayed in standings: x = clinched playoff berth, y = clinched division title, z = clinched best record in conference, e = eliminated from playoff contention, w = clinched best overall record, p = clinched home-field advantage. Null if no clinch or elimination status applies.. Valid values are `x|y|z|e|w|p`',
    `conference_losses` STRING COMMENT 'Total number of losses recorded against conference opponents as of the snapshot date.',
    `conference_rank` STRING COMMENT 'Ordinal rank of the franchise within its conference as of the snapshot date. Used for playoff seeding and wild card qualification.',
    `conference_wins` STRING COMMENT 'Total number of wins recorded against conference opponents as of the snapshot date. Used as a tiebreaker criterion in NFL, NBA, and NHL standings.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this standing snapshot record was first created in the system, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Supports audit trail and data lineage tracking.',
    `current_streak_count` STRING COMMENT 'Number of consecutive games in the current streak of the same result type (wins, losses, or ties). Combined with current_streak_type to express the full streak.',
    `current_streak_type` STRING COMMENT 'Type of the franchises current consecutive result streak: W (Win), L (Loss), T (Tie), or D (Draw). Combined with current_streak_count to express the full streak (e.g., W5 = five consecutive wins).. Valid values are `W|L|T|D`',
    `division_losses` STRING COMMENT 'Total number of losses recorded against divisional opponents as of the snapshot date.',
    `division_rank` STRING COMMENT 'Ordinal rank of the franchise within its division as of the snapshot date. Rank 1 indicates the division leader. Used for playoff seeding and tiebreaker resolution.',
    `division_wins` STRING COMMENT 'Total number of wins recorded against divisional opponents as of the snapshot date. A primary tiebreaker criterion in NFL, NBA, MLB, and NHL standings.',
    `elimination_number` STRING COMMENT 'Combined number of losses by the trailing team and wins by the leading competitor that would result in mathematical elimination from playoff contention. Null when already eliminated or clinched.',
    `games_behind` DECIMAL(18,2) COMMENT 'Number of games the franchise trails the division or conference leader in the standings. A value of 0.0 indicates the franchise is tied for or holds the lead. Calculated as ((leader_wins - team_wins) + (team_losses - leader_losses)) / 2.',
    `games_played` STRING COMMENT 'Total number of official regular season or applicable competition games played by the franchise as of the snapshot date.',
    `home_losses` STRING COMMENT 'Total number of losses recorded in home venue games as of the snapshot date.',
    `home_ties` STRING COMMENT 'Total number of ties or draws recorded in home venue games. Applicable in MLS, FIFA, and NFL regular season formats.',
    `home_wins` STRING COMMENT 'Total number of wins recorded in home venue games as of the snapshot date. Used in tiebreaker resolution and home-field advantage analysis.',
    `last10_losses` STRING COMMENT 'Number of losses in the franchises most recent 10 official games. Combined with last10_wins to express the last-10 record (e.g., 7-3).',
    `last10_wins` STRING COMMENT 'Number of wins in the franchises most recent 10 official games. Used as a recent form indicator in standings displays and playoff race analysis.',
    `league_rank` STRING COMMENT 'Ordinal rank of the franchise across the entire league as of the snapshot date. Used for draft order determination and overall competitive positioning.',
    `losses` STRING COMMENT 'Total number of official games lost by the franchise in regulation, overtime, or shootout as of the snapshot date.',
    `magic_number` STRING COMMENT 'Combined number of wins by the leading team and losses by the closest competitor needed to clinch a division title or playoff berth. Null when not applicable or when already clinched/eliminated.',
    `overtime_losses` STRING COMMENT 'Total number of games lost in overtime or shootout. Used primarily in NHL standings where an overtime loss earns one point. Null or zero for leagues without overtime loss distinction.',
    `playoff_seed` STRING COMMENT 'Projected or confirmed playoff seeding position for the franchise based on current standings. Determines bracket placement, home-field advantage, and first-round matchups. Null if the franchise is eliminated or the playoff field is not yet determined.',
    `points` STRING COMMENT 'Total standings points accumulated by the franchise. Used in NHL (2 pts per win, 1 pt per OTL), MLS, and FIFA competition formats. Null for leagues using winning percentage as the primary ranking metric.',
    `run_differential` STRING COMMENT 'Net difference between total runs/goals/points scored and total runs/goals/points allowed across all games. Positive values indicate the franchise scores more than it concedes. Used as a tiebreaker and competitive health indicator across MLB (runs), NHL/MLS/FIFA (goals), and NBA (points).',
    `runs_allowed` STRING COMMENT 'Total runs (MLB), goals (NHL/MLS/FIFA), or points (NBA/NFL) allowed by the franchise across all applicable games as of the snapshot date.',
    `runs_scored` STRING COMMENT 'Total runs (MLB), goals (NHL/MLS/FIFA), or points (NBA/NFL) scored by the franchise across all applicable games as of the snapshot date.',
    `snapshot_date` DATE COMMENT 'The calendar date on which this standings snapshot was captured, typically updated after each official game result is processed.',
    `standing_status` STRING COMMENT 'Current lifecycle status of this standing record: active (season in progress), clinched (playoff berth secured), eliminated (mathematically eliminated from playoff contention), pending (awaiting game result), or final (season concluded).. Valid values are `active|clinched|eliminated|pending|final`',
    `standings_type` STRING COMMENT 'Classification of the standings context: regular season, postseason, preseason, tournament group stage, or playoff bracket. Determines which game results are included in the standing calculation.. Valid values are `regular_season|postseason|preseason|tournament|group_stage|playoff`',
    `strength_of_schedule` DECIMAL(18,2) COMMENT 'Composite metric representing the combined winning percentage of all opponents faced by the franchise as of the snapshot date. Used as a tiebreaker criterion in NFL standings and for playoff seeding analysis.',
    `ties` STRING COMMENT 'Total number of official games ending in a tie or draw (applicable in MLS, FIFA, and NFL regular season). Null or zero for leagues that do not permit ties.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this standing snapshot record was last modified, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Updated after each official game result is processed and standings are recalculated.',
    `wild_card_rank` STRING COMMENT 'Ordinal rank of the franchise among wild card contenders within its conference or league. Null if the franchise has clinched a division title or is eliminated from wild card contention.',
    `win_pct` DECIMAL(18,2) COMMENT 'Winning percentage calculated as wins divided by games played (ties count as half a win in applicable leagues). Primary ranking metric in MLB and NBA standings.',
    `wins` STRING COMMENT 'Total number of official games won by the franchise in regulation, overtime, or shootout as of the snapshot date.',
    CONSTRAINT pk_standing PRIMARY KEY(`standing_id`)
) COMMENT 'Periodic snapshot of competitive standings for a franchise within a division, conference, and league for a given season. Tracks wins, losses, ties/draws, overtime losses, points (hockey/soccer), winning percentage, games behind leader, home/away/divisional/conference records, goal/run/point differential, current streak, last-10 record, strength of schedule, clinch/elimination status, and standings rank. Updated after each official game result. Drives playoff qualification logic and tiebreaker resolution.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` (
    `playoff_bracket_id` BIGINT COMMENT 'Unique surrogate identifier for the playoff bracket record. Primary key for the playoff_bracket data product in the league domain.',
    `budget_id` BIGINT COMMENT 'Foreign key linking to finance.budget. Business justification: Playoff operations carry dedicated budgets covering venue costs, officiating, broadcast production, security, and championship event logistics. Finance teams create playoff-specific budgets for planni',
    `venue_id` BIGINT COMMENT 'Reference to the pre-designated venue for the championship game or final series, applicable when neutral_site_final is true. Used for venue operations, ticketing, and broadcast planning.',
    `league_id` BIGINT COMMENT 'Reference to the professional league (e.g., NFL, NBA, MLB, NHL, MLS, FIFA) that owns and governs this playoff bracket.',
    `athlete_profile_id` BIGINT COMMENT 'Reference to the athlete awarded the Most Valuable Player (MVP) honor for the playoff bracket/championship series. Populated upon bracket completion. Drives NIL, sponsorship, and award management processes.',
    `media_rights_deal_id` BIGINT COMMENT 'Reference to the broadcast and media rights package governing playoff coverage, including OTT, RSN, PPV, and DTC distribution rights for this brackets games.',
    `franchise_id` BIGINT COMMENT 'Reference to the franchise that won the championship in this playoff bracket. Populated only upon bracket completion. Used for historical records, trophy management, and league governance reporting.',
    `season_id` BIGINT COMMENT 'Reference to the league season for which this playoff bracket is defined. Links the bracket to the regular-season standings and schedule that determine seeding.',
    `ada_compliance_required` BOOLEAN COMMENT 'Indicates whether all venues hosting games in this playoff bracket must meet ADA (Americans with Disabilities Act) accessibility standards. Mandatory for all US-based professional league events.',
    `bracket_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying this playoff bracket within the league and season (e.g., NFL-2024-PLAYOFFS, NBA-2024-EAST). Used in broadcast, ticketing, and fan-facing systems.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `bracket_end_date` DATE COMMENT 'Calendar date on which the final championship game is scheduled or was completed. Used for season close-out, financial reporting, and broadcast rights expiry.',
    `bracket_name` STRING COMMENT 'Human-readable name of the playoff bracket (e.g., NFL 2024 AFC Playoffs, NBA 2024 Eastern Conference Bracket). Used in fan-facing platforms, broadcast graphics, and reporting.',
    `bracket_notes` STRING COMMENT 'Free-text field for league administrators to record special circumstances, rule exceptions, force-majeure events, or governance decisions affecting this playoff bracket (e.g., COVID-19 bubble format, relocated games).',
    `bracket_region` STRING COMMENT 'Geographic or organizational region label for the bracket (e.g., AFC, NFC, Eastern Conference, Western Conference, Americas, Europe). Used for multi-region league structures and broadcast rights segmentation.',
    `bracket_start_date` DATE COMMENT 'Calendar date on which the first playoff game in this bracket is scheduled to be played. Used for scheduling, ticketing, and broadcast rights activation.',
    `bracket_status` STRING COMMENT 'Current lifecycle state of the playoff bracket. draft indicates the bracket is being configured; published means seeding is finalized and publicly released; in_progress means competition is underway; completed means a champion has been crowned; cancelled covers force-majeure scenarios.. Valid values are `draft|published|in_progress|completed|cancelled`',
    `bracket_type` STRING COMMENT 'Format of the playoff bracket structure governing how teams advance. Determines match scheduling logic and advancement rules. [ENUM-REF-CANDIDATE: single_elimination|double_elimination|best_of_series|round_robin|seeded_bracket — promote to reference product if additional formats are needed]. Valid values are `single_elimination|double_elimination|best_of_series|round_robin|seeded_bracket`',
    `bye_rounds_count` STRING COMMENT 'Number of first-round byes awarded to top-seeded teams. A value of 0 indicates no byes are granted. Bye rules are defined in the leagues CBA and playoff format documentation.',
    `championship_game_name` STRING COMMENT 'Official branded name of the final championship game or series in this bracket (e.g., Super Bowl, NBA Finals, Stanley Cup Finals, World Series). Used in broadcast, sponsorship, and fan engagement contexts.',
    `conference_division_scope` STRING COMMENT 'Organizational scope of the bracket indicating whether it covers the full league, a single conference, a division, or a wild-card pool. Drives seeding and matchup logic.. Valid values are `full_league|conference|division|wild_card|inter_conference`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this playoff bracket record was first created in the system. Used for audit trail and data lineage tracking.',
    `current_round` STRING COMMENT 'The round number currently in progress within the bracket (1 = first round, incrementing through to the championship). Null if the bracket has not yet started or has been completed.',
    `disciplinary_review_body` STRING COMMENT 'Name of the governing body or panel responsible for adjudicating disciplinary actions, appeals, and rule enforcement during this playoff bracket (e.g., NFL Commissioners Office, NBA Basketball Operations, CAS).',
    `governing_body_code` STRING COMMENT 'Code identifying the sports governing body that oversees the rules and competitive integrity of this playoff bracket (e.g., NFL, NBA, MLB, NHL, MLS, FIFA, IOC). Drives regulatory compliance and officiating standards. [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|FIFA|IOC|UFC|ATP — 9 candidates stripped; promote to reference product]',
    `home_advantage_rule` STRING COMMENT 'Rule governing which team hosts home games in a series. higher_seed awards home games to the better-seeded team; predetermined uses a fixed schedule; neutral_site applies to championship games; alternating rotates home games.. Valid values are `higher_seed|predetermined|neutral_site|alternating`',
    `iso_20121_certified` BOOLEAN COMMENT 'Indicates whether the playoff bracket events are managed under ISO 20121 Event Sustainability Management System certification, reflecting the leagues commitment to sustainable event operations.',
    `neutral_site_final` BOOLEAN COMMENT 'Indicates whether the championship game/series final is played at a pre-selected neutral venue rather than the higher seeds home venue. True for events like the Super Bowl, FIFA World Cup Final, and NBA All-Star Game.',
    `ppv_applicable` BOOLEAN COMMENT 'Indicates whether any games in this playoff bracket are distributed under a Pay-Per-View (PPV) model. Drives revenue recognition, fan access controls, and broadcast rights activation.',
    `published_timestamp` TIMESTAMP COMMENT 'Date and time when the playoff bracket seeding and structure were officially published and made available to teams, media, and fans. Represents the principal real-world business event timestamp for this entity.',
    `reseeding_rule` STRING COMMENT 'Defines whether teams are reseeded after each round based on remaining seeds or whether the bracket is fixed at the start. fixed_bracket locks matchups at bracket publication; reseed_each_round re-ranks remaining teams each round.. Valid values are `fixed_bracket|reseed_each_round|conference_reseed|no_reseed`',
    `salary_cap_compliance_required` BOOLEAN COMMENT 'Indicates whether participating franchises must be in salary cap compliance at the time of bracket entry. True if the league enforces cap compliance as a condition of playoff eligibility, per CBA terms.',
    `season_year` STRING COMMENT 'The calendar year (or starting year for cross-year seasons) of the league season associated with this playoff bracket (e.g., 2024 for the 2024-25 NBA season). Used for partitioning, reporting, and historical analysis.',
    `seeding_methodology` STRING COMMENT 'The rule set used to assign seed positions to franchises entering the bracket (e.g., win-loss record, points percentage, division winner priority). Governs competitive integrity and is defined in the CBA and league rulebook.. Valid values are `win_loss_record|points_percentage|division_winner_priority|wild_card_ranking|strength_of_schedule`',
    `series_games_per_round` STRING COMMENT 'Comma-separated list of maximum games per series for each round in order (e.g., 7,7,7,7 for NBA best-of-7 throughout, or 1,1,1,1 for NFL single-elimination). Null for single-elimination formats where each round is one game.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this playoff bracket record originated or is mastered (e.g., SAP S/4HANA league operations module, Salesforce CRM, or manual league office entry).. Valid values are `SAP_S4HANA|SALESFORCE_CRM|TICKETMASTER|ARCHTICS|MANUAL|LEAGUE_OPS`',
    `ticket_sales_open_date` DATE COMMENT 'Date on which general public ticket sales for playoff games in this bracket open. Used by Ticketmaster/AXS and Archtics for inventory release and revenue management.',
    `tiebreaker_rule` STRING COMMENT 'Description of the tiebreaker criteria applied when two or more teams have identical records for seeding purposes (e.g., head-to-head record, division record, strength of schedule, point differential). Defined in the league rulebook and CBA.',
    `total_rounds` STRING COMMENT 'Total number of competitive rounds in the bracket from first round through championship (e.g., 4 for NFL: Wild Card, Divisional, Conference Championship, Super Bowl).',
    `total_teams` STRING COMMENT 'Total number of franchises/teams that qualify and enter the playoff bracket. Determines bracket size and bye-round eligibility.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this playoff bracket record. Used for change tracking, audit compliance, and downstream ETL incremental loads.',
    `var_tmo_enabled` BOOLEAN COMMENT 'Indicates whether Video Assistant Referee (VAR) or Television Match Official (TMO) technology is mandated for officiating decisions in all games within this playoff bracket. Relevant for FIFA, MLS, and rugby-governed competitions.',
    `wada_compliance_required` BOOLEAN COMMENT 'Indicates whether WADA anti-doping protocols and PED (Performance Enhancing Drug) testing are mandated for all athletes competing in this playoff bracket. Relevant for international and Olympic-affiliated competitions.',
    CONSTRAINT pk_playoff_bracket PRIMARY KEY(`playoff_bracket_id`)
) COMMENT 'Defines the postseason bracket structure for a league season, including bracket format (single elimination, best-of-series), number of rounds, seeding methodology, bye rules, home-court/field advantage rules, and bracket position assignments per franchise. Tracks advancement status and series results through each round to championship.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`game_result` (
    `game_result_id` BIGINT COMMENT 'Unique surrogate identifier for the official game result record. Primary key for the game_result data product in the league domain.',
    `franchise_id` BIGINT COMMENT 'Reference to the franchise or team entity that won the game. Null for draws or no-contest results. Primary input for win-loss standings calculations.',
    `broadcast_schedule_id` BIGINT COMMENT 'Foreign key linking to broadcast.broadcast_schedule. Business justification: Post-game broadcast performance reporting (ratings attribution, rights compliance certification) requires linking game results to their broadcast schedule entry. broadcast_network on game_result is a ',
    `competition_round_id` BIGINT COMMENT 'Foreign key linking to event.competition_round. Business justification: Game results must be attributed to competition rounds for standings calculation, bracket advancement decisions, and round-level performance reporting. In league operations, knowing which round a resul',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Game results trigger gate revenue, broadcast rights payments, and attendance-based revenue recognition. Finance teams must assign each game result to a fiscal period for ASC 606/IFRS 15 compliance and',
    `fixture_id` BIGINT COMMENT 'Reference to the scheduled fixture or game that this result corresponds to. Links the official outcome back to the pre-game scheduling record.',
    `league_id` BIGINT COMMENT 'Foreign key linking to league.league. Business justification: game_result currently stores league_code as a STRING denormalization. Adding league_id as a proper FK to league.league normalizes this relationship and enables joins to league governance data. The lea',
    `playoff_bracket_id` BIGINT COMMENT 'Foreign key linking to league.playoff_bracket. Business justification: Playoff game results feed into bracket progression (advancing teams, series scores, champion determination). Adding playoff_bracket_id to game_result links completed playoff game results to their brac',
    `primary_game_franchise_id` BIGINT COMMENT 'Reference to the home franchise or team entity participating in this game. Used for standings calculations and franchise performance reporting.',
    `quaternary_game_losing_team_franchise_id` BIGINT COMMENT 'Reference to the franchise or team entity that lost the game. Null for draws or no-contest results. Used in standings and franchise performance reporting.',
    `quinary_game_protest_filing_team_franchise_id` BIGINT COMMENT 'Reference to the franchise or team entity that filed the formal protest against this result. Null if no protest has been filed. Used in disciplinary case management.',
    `season_id` BIGINT COMMENT 'Reference to the league season calendar record under which this game result is recorded. Enables season-level standings aggregation.',
    `tertiary_game_franchise_id` BIGINT COMMENT 'Reference to the home franchise or team entity participating in this game. Used for standings calculations and franchise performance reporting.',
    `tertiary_game_winning_team_franchise_id` BIGINT COMMENT 'Reference to the franchise or team entity that won the game. Null for draws or no-contest results. Primary input for win-loss standings calculations.',
    `tertiary_quinary_game_protest_filing_team_franchise_id` BIGINT COMMENT 'Reference to the franchise or team entity that filed the formal protest against this result. Null if no protest has been filed. Used in disciplinary case management.',
    `venue_id` BIGINT COMMENT 'Reference to the venue or facility where the game was played. Used for venue operations reporting and attendance reconciliation.',
    `away_score_regulation` STRING COMMENT 'Away team score at the end of regulation time only, excluding overtime and shootout. Required for tiebreaker calculations and sport-specific standings rules.',
    `away_team_score` STRING COMMENT 'Official final score for the away team at the conclusion of the game, including all regulation and overtime periods. The authoritative score used in standings calculations.',
    `certification_timestamp` TIMESTAMP COMMENT 'Date and time (ISO 8601 with timezone offset) when the game result was officially certified as final by the league office. Marks the point at which the result becomes the SSOT for standings calculations.',
    `certified_by` STRING COMMENT 'Name or identifier of the league official or commissioners office representative who certified this game result as final and authoritative.',
    `competition_phase` STRING COMMENT 'Phase of the league competition calendar in which this game was played. Determines how the result is applied to standings and playoff seeding calculations.. Valid values are `regular_season|playoffs|preseason|finals|all_star|exhibition`',
    `competitive_integrity_flag` BOOLEAN COMMENT 'Indicates whether a competitive integrity concern (match-fixing, tanking, PED violation, or unusual betting pattern) has been flagged for this game result (True) or not (False). Triggers league compliance investigation workflow.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time (ISO 8601 with timezone offset) when this game result record was first created in the data platform. Mandatory audit field for data lineage and SOX compliance.',
    `disciplinary_action_flag` BOOLEAN COMMENT 'Indicates whether any disciplinary action (red card, ejection, fine, suspension) was issued during or as a result of this game (True) or not (False). Triggers downstream disciplinary record creation.',
    `forfeit_reason` STRING COMMENT 'Description of the reason a forfeit was declared, such as insufficient eligible players, failure to appear, or safety grounds. Null if result_type is not forfeit.',
    `game_date` DATE COMMENT 'Calendar date on which the game was played. Principal business event date used for standings calculations, scheduling, and broadcast rights reporting.',
    `game_end_timestamp` TIMESTAMP COMMENT 'Precise date and time (ISO 8601 with timezone offset) when the game officially concluded, including all overtime or shootout periods. Used for broadcast rights reconciliation and venue operations.',
    `game_start_timestamp` TIMESTAMP COMMENT 'Precise date and time (ISO 8601 with timezone offset) when the game officially commenced. Used for broadcast scheduling, OTT streaming rights windows, and operational reporting.',
    `home_score_regulation` STRING COMMENT 'Home team score at the end of regulation time only, excluding overtime and shootout. Required for tiebreaker calculations and sport-specific standings rules (e.g., NHL regulation wins).',
    `home_team_score` STRING COMMENT 'Official final score for the home team at the conclusion of the game, including all regulation and overtime periods. The authoritative score used in standings calculations.',
    `is_draw` BOOLEAN COMMENT 'Indicates whether the game ended in a draw or tie (True) or produced a winner (False). Applicable in sports that allow draws such as MLS, FIFA, and some NHL regular season formats.',
    `is_neutral_site` BOOLEAN COMMENT 'Indicates whether the game was played at a neutral site (True) rather than the home teams designated venue (False). Relevant for playoff games, international fixtures, and special events.',
    `official_attendance` STRING COMMENT 'Officially certified number of spectators in attendance at the venue as reported to the league office. Used for franchise reporting, venue capacity compliance, and fan engagement analytics.',
    `overtime_periods_played` STRING COMMENT 'Number of overtime or extra-time periods played beyond regulation. Zero if the game was decided in regulation. Used for game duration analytics and broadcast scheduling.',
    `protest_flag` BOOLEAN COMMENT 'Indicates whether a formal protest has been filed against this game result by either participating franchise (True) or not (False). Triggers league disciplinary and review workflows.',
    `protest_reason` STRING COMMENT 'Brief description of the grounds on which the formal protest was filed (e.g., officiating error, ineligible player, rule violation). Null if no protest filed.',
    `result_reference_number` STRING COMMENT 'Externally-known official result reference number assigned by the league office. Used for regulatory filings, media distribution, and official record-keeping across NFL, NBA, MLB, NHL, MLS, and FIFA.. Valid values are `^[A-Z]{2,6}-[0-9]{4}-[0-9]{6}$`',
    `result_status` STRING COMMENT 'Current certification lifecycle status of the official game result as determined by the league office. certified indicates the result is final and authoritative for standings. provisional indicates pending review. under_review indicates active investigation. protested indicates a formal protest has been filed. voided indicates the result has been nullified.. Valid values are `certified|provisional|under_review|protested|voided`',
    `result_type` STRING COMMENT 'Classification of how the game result was determined. regulation indicates decided within standard playing time. overtime indicates decided in extra time/OT periods. shootout indicates decided by penalty shootout or shootout format (NHL/MLS/FIFA). forfeit indicates awarded due to a teams failure to compete. no_contest indicates the game was declared void without a winner.. Valid values are `regulation|overtime|shootout|forfeit|no_contest`',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this game result was ingested (e.g., SportsCode/Hudl performance analytics platform, manual league entry, or third-party stats provider). Supports data lineage and audit traceability.. Valid values are `SPORTSCODE|HUDL|MANUAL|STATSPERFORM|OPTA`',
    `temperature_celsius` DECIMAL(18,2) COMMENT 'Ambient temperature in degrees Celsius recorded at the venue at game time. Applicable to outdoor venues. Used for performance analytics, player safety reporting, and broadcast metadata.',
    `tmo_intervention_flag` BOOLEAN COMMENT 'Indicates whether a Television Match Official (TMO) review was invoked during the game (True) or not (False). Applicable to rugby and other sports using TMO protocols. Supports officiating quality review.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time (ISO 8601 with timezone offset) when this game result record was last modified. Tracks result amendments, certification updates, and protest resolutions for audit compliance.',
    `var_intervention_flag` BOOLEAN COMMENT 'Indicates whether a Video Assistant Referee (VAR) intervention occurred during the game (True) or not (False). Applicable to sports using VAR technology such as FIFA, MLS, and NFL replay review. Supports officiating quality review and competitive integrity reporting.',
    `venue_capacity` STRING COMMENT 'Total certified seating and standing capacity of the venue at the time of the game. Used to calculate attendance utilization rate and for regulatory compliance reporting.',
    `weather_condition` STRING COMMENT 'Prevailing weather condition at the venue during the game. Applicable to outdoor venues only; dome or indoor used for enclosed facilities. Impacts game analytics, broadcast commentary, and insurance claims. [ENUM-REF-CANDIDATE: clear|cloudy|rain|snow|fog|wind|dome|indoor — 8 candidates stripped; promote to reference product]',
    `wind_speed_kmh` DECIMAL(18,2) COMMENT 'Wind speed in kilometres per hour recorded at the venue at game time. Applicable to outdoor venues. Used for performance analytics and broadcast metadata.',
    CONSTRAINT pk_game_result PRIMARY KEY(`game_result_id`)
) COMMENT 'Official final result record for a completed scheduled game. Captures final score by team, overtime periods played, winning/losing franchise, result type (regulation, OT, SO, forfeit), official attendance, weather conditions (outdoor venues), VAR/TMO intervention flag, protest flag, and result certification status. SSOT for official game outcomes used in standings calculations.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`official` (
    `official_id` BIGINT COMMENT 'Unique surrogate identifier for a game official (referee, umpire, linesman, VAR operator, TMO, line judge) within the league officiating bureau master record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Officiating costs (referee salaries, travel, per diems, training) are tracked against dedicated cost centers in league finance. Assigning officials to cost centers enables officiating budget managemen',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Officials are certified and governed by a specific officiating governing body (e.g., FIFA Referees Committee, NFL Officiating). Officiating compliance, certification tracking, and disciplinary oversig',
    `league_id` BIGINT COMMENT 'Foreign key linking to league.league. Business justification: An official (referee, umpire, VAR operator, TMO) is certified and governed by a specific league. The official table currently has sport_code and officiating_body as string fields but no FK to the leag',
    `background_check_date` DATE COMMENT 'Date on which the most recent background check and integrity screening was completed for this official. Used to ensure compliance with league-mandated periodic screening intervals.',
    `badge_number` STRING COMMENT 'Externally-known unique badge or credential number assigned by the officiating body to identify the official on the field and in league records. Serves as the business-facing identifier across game sheets, broadcast graphics, and disciplinary filings.. Valid values are `^[A-Z]{2,4}-[0-9]{4,8}$`',
    `certification_tier` STRING COMMENT 'Officiating certification level awarded by the officiating body, reflecting demonstrated competency, experience, and performance evaluations. Determines eligibility for playoff, championship, and international assignments.. Valid values are `elite|senior|intermediate|entry|trainee`',
    `contract_end_date` DATE COMMENT 'Date on which the officials current contract or engagement agreement expires or is scheduled to terminate. Nullable for open-ended arrangements. Used for renewal planning and assignment eligibility cutoffs.',
    `contract_start_date` DATE COMMENT 'Date on which the officials current contract or engagement agreement with the officiating body becomes effective. Used for CBA compliance tracking, payroll activation, and assignment eligibility determination.',
    `contract_type` STRING COMMENT 'Classification of the employment or engagement arrangement between the official and the officiating body. Determines benefit eligibility, assignment priority, and CBA (Collective Bargaining Agreement) applicability.. Valid values are `full_time|part_time|seasonal|freelance|developmental`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this officials master record was first created in the league officiating bureau system. Supports data lineage, audit trail requirements, and SOX compliance for record integrity.',
    `date_of_birth` DATE COMMENT 'Officials date of birth. Used for mandatory retirement age enforcement (e.g., FIFA mandates retirement at age 45 for international referees), age-based eligibility checks, and HR compliance.',
    `disciplinary_flag` BOOLEAN COMMENT 'Indicates whether the official currently has an open disciplinary matter, investigation, or formal review initiated by the officiating bureau or league governance body. When True, assignment eligibility may be restricted pending resolution.',
    `email_address` STRING COMMENT 'Primary professional email address for the official, used for assignment notifications, crew communications, and officiating bureau correspondence.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `external_code` STRING COMMENT 'Identifier assigned to this official in the originating source system (e.g., SAP SuccessFactors employee ID, Salesforce contact ID, league portal user ID). Enables cross-system reconciliation and data lineage tracing.',
    `first_name` STRING COMMENT 'Given (first) name of the official, used for broadcast graphics, crew communications, and personalized correspondence.',
    `full_name` STRING COMMENT 'Full legal name of the official as registered with the officiating body and used in official game documentation, broadcast overlays, and disciplinary records.',
    `games_officiated_career` STRING COMMENT 'Cumulative total number of professional games officiated across the officials entire career. Used for milestone recognition, Hall of Fame eligibility, and historical analytics.',
    `games_officiated_season` STRING COMMENT 'Count of games officiated by this official in the current season. Used for workload management, assignment balancing, and CBA-mandated minimum/maximum game thresholds.',
    `geographic_region` STRING COMMENT 'Primary geographic region or territory to which the official is assigned for scheduling and travel logistics purposes (e.g., Northeast, Southeast, Midwest, West, Europe, South America). Used to optimize crew travel costs and regional assignment balance.',
    `home_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the officials country of residence or primary domicile. Used for international assignment eligibility, tax withholding jurisdiction, and GDPR/CCPA data residency compliance.. Valid values are `^[A-Z]{3}$`',
    `integrity_clearance_status` STRING COMMENT 'Current competitive integrity clearance status issued by the leagues integrity and compliance unit. Reflects background check outcomes, betting prohibition compliance, and conflict-of-interest reviews. Critical for assignment eligibility and regulatory reporting.. Valid values are `cleared|under_review|suspended|revoked`',
    `international_eligible` BOOLEAN COMMENT 'Indicates whether the official is cleared for international competition assignments (e.g., FIFA World Cup, Olympic Games, international friendlies). Requires FIFA/IOC certification and compliance with neutrality rules.',
    `language_codes` STRING COMMENT 'Comma-separated ISO 639-1 language codes representing languages spoken by the official. Relevant for international assignment eligibility, player communication in multilingual competitions, and VAR communication protocols.',
    `last_name` STRING COMMENT 'Family (last) name of the official, used as the primary sort key in officiating rosters, game sheets, and league reports.',
    `nationality_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the officials nationality. Relevant for international tournament eligibility rules (e.g., FIFA prohibits officials from officiating matches involving their home nation).. Valid values are `^[A-Z]{3}$`',
    `official_status` STRING COMMENT 'Current lifecycle status of the official within the officiating bureau. Drives eligibility for game assignments, payroll processing, and compliance reporting. suspended indicates a disciplinary or investigative hold; probation indicates conditional active status under performance review.. Valid values are `active|inactive|suspended|retired|probation`',
    `performance_rating` DECIMAL(18,2) COMMENT 'Most recent composite performance rating assigned by the officiating bureaus evaluators, typically on a 0–10 or 0–100 scale depending on the governing body. Drives assignment priority, certification tier reviews, and playoff eligibility determinations.',
    `performance_rating_season` STRING COMMENT 'The league season identifier (e.g., 2024-25) for which the current performance rating applies. Ensures ratings are interpreted in the correct seasonal context for year-over-year trend analysis.. Valid values are `^[0-9]{4}-[0-9]{2}$`',
    `phone_number` STRING COMMENT 'Primary contact phone number for the official, used for urgent assignment changes, crew coordination, and emergency contact by the officiating bureau.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `playoff_eligible` BOOLEAN COMMENT 'Indicates whether the official is currently eligible for postseason, playoff, or championship game assignments based on performance ratings, certification tier, and disciplinary standing. Managed by the officiating bureaus assignment committee.',
    `primary_position` STRING COMMENT 'The specific crew position this official is primarily assigned to within their sport (e.g., Referee, Head Linesman, Back Judge, Home Plate Umpire, First Base Umpire). More granular than role_type; used for crew composition and assignment matching.',
    `professional_debut_date` DATE COMMENT 'Date on which the official first officiated a professional-level game under the current or a predecessor officiating body. Establishes the officials career start point for seniority, pension, and historical record purposes.',
    `retirement_date` DATE COMMENT 'Date on which the official formally retired from active officiating duties. Nullable for currently active officials. Used for historical record-keeping, pension processing, and Hall of Fame eligibility tracking.',
    `role_type` STRING COMMENT 'Categorical classification of the officiating role performed by this individual. Determines crew position, authority scope, and applicable rule sets. [ENUM-REF-CANDIDATE: referee|umpire|linesman|line_judge|var_operator|tmo|fourth_official|video_review_official — promote to reference product]',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this officials master record was originated or last updated (e.g., SAP SuccessFactors for HR-managed officials, League Portal for bureau-direct entries). Supports data lineage and reconciliation.. Valid values are `SAP_SUCCESSFACTORS|SALESFORCE_CRM|MANUAL|LEAGUE_PORTAL|OTHER`',
    `sport_code` STRING COMMENT 'Standardized code identifying the sport or league for which this official is certified and primarily assigned. Aligns with governing body league codes. [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|FIFA|UFC|ATP|IOC|OTHER — promote to reference product]',
    `tmo_certified` BOOLEAN COMMENT 'Indicates whether the official holds a current TMO (Television Match Official) certification, qualifying them for video review assignments in rugby and other applicable sports.',
    `uniform_number` STRING COMMENT 'Numeric identifier displayed on the officials uniform during games, used for broadcast identification, fan-facing graphics, and post-game incident reporting (e.g., Official #54 issued the penalty).. Valid values are `^[0-9]{1,3}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this officials master record. Used for change data capture (CDC), data lineage tracking, and audit compliance.',
    `var_certified` BOOLEAN COMMENT 'Indicates whether the official holds a current VAR (Video Assistant Referee) certification, qualifying them for VAR room assignments in applicable competitions. Governed by FIFA VAR certification protocols and equivalent league standards.',
    `years_of_experience` STRING COMMENT 'Total number of years the official has been actively officiating at any professional or sanctioned level. Used for certification tier assessments, playoff eligibility criteria, and performance benchmarking.',
    CONSTRAINT pk_official PRIMARY KEY(`official_id`)
) COMMENT 'Master record for an individual game official (referee, umpire, linesman, VAR operator, TMO, line judge). Captures official name, badge number, officiating body, certification tier, sport specialization, active status, years of experience, geographic assignment region, and contract type. Distinct from athlete and workforce domains — officials are governed by league officiating bureaus.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` (
    `disciplinary_action_id` BIGINT COMMENT 'Unique surrogate identifier for each disciplinary action record issued by the league. Primary key for the disciplinary_action data product in the Silver Layer.',
    `athlete_profile_id` BIGINT COMMENT 'Foreign key linking to athlete.athlete_profile. Business justification: Disciplinary actions are frequently issued against individual athletes. The current subject_entity_ref/subject_entity_name are denormalized text fields. A proper FK to athlete_profile is required for ',
    `doping_violation_id` BIGINT COMMENT 'Foreign key linking to compliance.doping_violation. Business justification: League disciplinary proceedings are triggered by doping violations (positive tests, whereabouts failures). Linking disciplinary_action to doping_violation enables the league to track which disciplinar',
    `ejection_record_id` BIGINT COMMENT 'Foreign key linking to security.ejection_record. Business justification: League disciplinary actions (suspensions, fines) arising from in-game ejections must reference the originating ejection record. The league disciplinary office reviews ejection records to issue formal ',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Fine revenue and financial penalties from disciplinary actions must be accrued and recognized in the correct fiscal period for financial reporting and audit. disciplinary_action has gl_account_id but ',
    `fixture_id` BIGINT COMMENT 'Reference to the specific game or fixture during which the disciplinary incident occurred. Nullable for off-field infractions not tied to a specific game.',
    `franchise_id` BIGINT COMMENT 'Reference to the franchise (team) associated with the subject entity at the time of the disciplinary action. Supports franchise-level compliance tracking and CBA reporting.',
    `game_result_id` BIGINT COMMENT 'Foreign key linking to league.game_result. Business justification: disciplinary_action has an unlinked game_id BIGINT column that semantically refers to the completed game that triggered the disciplinary action. game_result is the authoritative completed-game record ',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Fines from disciplinary actions (fine_amount field) are league revenue that must post to specific GL accounts. The fine revenue recognition and GL posting process requires traceability from disciplina',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Disciplinary actions in sports leagues are issued by specific governing bodies (league office, federation, anti-doping authority). Linking to governing_body normalizes the issuing_authority text field',
    `investigation_id` BIGINT COMMENT 'Foreign key linking to compliance.investigation. Business justification: Disciplinary actions are the formal outcome of compliance investigations. End-to-end integrity case tracking (investigation → disciplinary action → appeal) is a core sports integrity business process ',
    `league_id` BIGINT COMMENT 'Reference to the professional league (NFL, NBA, MLB, NHL, MLS, FIFA, etc.) that issued this disciplinary action. Supports multi-league governance reporting.',
    `policy_id` BIGINT COMMENT 'Foreign key linking to compliance.policy. Business justification: Disciplinary actions are taken under specific compliance policies (conduct policies, anti-doping policies, integrity codes). Policy-level disciplinary reporting and CBA compliance tracking require str',
    `season_id` BIGINT COMMENT 'Reference to the competitive season during which the disciplinary infraction occurred. Enables season-level CBA compliance and competitive integrity analytics.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Disciplinary actions triggered by security incidents (player altercations, fan misconduct escalated to league) must reference the originating security incident record. League integrity officers requir',
    `action_reference_number` STRING COMMENT 'Externally-known, human-readable reference number assigned by the league office to uniquely identify this disciplinary action (e.g., NFL-DISC-2024-00412). Used in official correspondence, press releases, and CBA compliance reporting.',
    `action_status` STRING COMMENT 'Current lifecycle state of the disciplinary action. Tracks the workflow from initial issuance through appeal resolution and final ruling. Drives CBA compliance dashboards and competitive integrity reporting. [ENUM-REF-CANDIDATE: pending|active|appealed|upheld|overturned|reduced|withdrawn — 7 candidates stripped; promote to reference product]',
    `appeal_deadline_date` DATE COMMENT 'The last calendar date by which the subject entity must file a formal appeal under the applicable CBA or league rules. Nullable when appeal_eligible is false.',
    `appeal_eligible` BOOLEAN COMMENT 'Indicates whether the subject entity is eligible to appeal the disciplinary ruling under the applicable CBA or league rules. Drives appeal workflow initiation in Salesforce CRM case management.',
    `appeal_filed_date` DATE COMMENT 'The calendar date on which the subject entity formally filed an appeal against the disciplinary ruling. Nullable when no appeal has been filed.',
    `appeal_ruling_date` DATE COMMENT 'The calendar date on which the appeal body (league arbitrator, CAS, or independent panel) issued its final ruling on the appeal. Nullable until appeal is resolved.',
    `appeal_status` STRING COMMENT 'Current status of the appeal process for this disciplinary action. Tracks the appeal lifecycle from filing through final resolution by the league arbitrator or CAS. [ENUM-REF-CANDIDATE: not_filed|filed|pending|upheld|overturned|reduced|withdrawn — 7 candidates stripped; promote to reference product]',
    `cba_article_reference` STRING COMMENT 'Specific CBA (Collective Bargaining Agreement) article or section under which the disciplinary action was issued or the appeal is governed. Critical for labor relations compliance and arbitration proceedings.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this disciplinary action record was first created in the system. Supports audit trail, data lineage, and SOX compliance for financial-impact records.',
    `draft_pick_loss_round` STRING COMMENT 'The draft round of the pick forfeited as part of the disciplinary penalty. Nullable for non-draft-pick-loss penalty types. Supports draft governance and franchise asset tracking.',
    `draft_pick_loss_year` STRING COMMENT 'The draft year in which the forfeited pick applies. Nullable for non-draft-pick-loss penalty types. Used in conjunction with draft_pick_loss_round for franchise asset management.',
    `final_ruling_description` STRING COMMENT 'Narrative summary of the final ruling outcome after all appeal processes are exhausted. Documents any modifications to the original penalty (e.g., reduced from 4 games to 2 games). Used for legal records and CBA compliance audit.',
    `fine_amount` DECIMAL(18,2) COMMENT 'Gross monetary fine levied against the subject entity as part of the disciplinary action, expressed in the base currency. Nullable when the penalty type does not include a financial component.',
    `fine_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the fine amount (e.g., USD, EUR, GBP). Required for multi-league international operations (FIFA, MLS international competitions).. Valid values are `^[A-Z]{3}$`',
    `fine_paid_amount` DECIMAL(18,2) COMMENT 'Actual monetary amount paid by the subject entity against the assessed fine. Supports accounts receivable tracking in SAP S/4HANA and outstanding balance reporting for league finance.',
    `fine_payment_date` DATE COMMENT 'Date on which the fine was paid in full or the most recent partial payment was received. Used for financial reconciliation and delinquency tracking.',
    `incident_date` DATE COMMENT 'The calendar date on which the disciplinary incident or infraction occurred. Distinct from the ruling date; used for timeline analysis and statute-of-limitations compliance.',
    `incident_timestamp` TIMESTAMP COMMENT 'Precise date and time at which the disciplinary incident occurred, including timezone offset. Used for in-game incident correlation (e.g., ejection time, VAR/TMO review timestamp).',
    `infraction_category` STRING COMMENT 'Broader category grouping the nature of the infraction (e.g., on-field conduct, PED violation, gambling, domestic violence, financial misconduct, game integrity). Supports regulatory reporting to WADA, CAS, and league governing bodies. [ENUM-REF-CANDIDATE: on_field_conduct|ped_violation|gambling|domestic_violence|financial_misconduct|game_integrity|social_conduct|equipment_violation — promote to reference product]',
    `infraction_description` STRING COMMENT 'Detailed narrative description of the specific rule violation or conduct that triggered the disciplinary action, as documented by the league office. Supports legal review, CBA arbitration, and CAS proceedings.',
    `infraction_type` STRING COMMENT 'Primary classification of the disciplinary penalty imposed. Drives downstream CBA compliance tracking, salary cap impact assessment, and competitive integrity reporting. [ENUM-REF-CANDIDATE: suspension|fine|ejection|probation|draft_pick_loss|warning|roster_restriction|conditional_reinstatement — promote to reference product if additional types are needed]. Valid values are `suspension|fine|ejection|probation|draft_pick_loss|warning`',
    `is_game_integrity_related` BOOLEAN COMMENT 'Indicates whether the disciplinary action involves a game integrity violation (e.g., match-fixing, gambling, sign-stealing). Triggers enhanced regulatory reporting to league governing bodies and law enforcement liaisons.',
    `is_ped_related` BOOLEAN COMMENT 'Indicates whether the disciplinary action is related to a Performance Enhancing Drug (PED) violation. Triggers mandatory WADA reporting obligations and anti-doping compliance workflows.',
    `is_publicly_disclosed` BOOLEAN COMMENT 'Indicates whether the disciplinary action has been publicly disclosed by the league. Some actions (e.g., private reprimands) are not publicly announced. Governs data access and GDPR/CCPA disclosure controls.',
    `prior_offense_count` STRING COMMENT 'Number of prior disciplinary actions of the same infraction category recorded against the subject entity. Supports escalating penalty calculation per CBA and league disciplinary schedules.',
    `public_announcement_date` DATE COMMENT 'The date on which the league publicly announced the disciplinary action. Used for media relations tracking, fan communications, and compliance with league transparency requirements.',
    `repeat_offender` BOOLEAN COMMENT 'Indicates whether the subject entity has a prior disciplinary history for the same or similar infraction category. Used to apply escalating penalty schedules per CBA provisions and league rules.',
    `rule_code_violated` STRING COMMENT 'The specific league rulebook article, section, or CBA provision code that was violated (e.g., NFL Rule 12, Section 2, Article 8; NBA CBA Article XXXV). Enables precise regulatory and compliance cross-referencing.',
    `ruling_date` DATE COMMENT 'The calendar date on which the league office issued the formal disciplinary ruling. Used for CBA compliance timelines, appeal window calculation, and regulatory reporting.',
    `subject_entity_type` STRING COMMENT 'Classifies the type of entity against whom the disciplinary action was issued. Determines which reference table the subject_entity_id resolves to (player, coach, franchise, official, or staff member).. Valid values are `player|coach|franchise|official|staff`',
    `suspension_end_date` DATE COMMENT 'Calendar date on which the suspension period ends and the subject entity becomes eligible to return. Nullable for indefinite suspensions pending reinstatement review.',
    `suspension_games` STRING COMMENT 'Number of games for which the subject entity is suspended as part of the disciplinary action. Nullable for non-suspension penalty types. Used for roster planning, salary cap impact, and CBA compliance.',
    `suspension_start_date` DATE COMMENT 'Calendar date on which the suspension period begins. Used for roster eligibility management and salary cap entry adjustments.',
    `suspension_with_pay` BOOLEAN COMMENT 'Indicates whether the subject entity continues to receive salary compensation during the suspension period. Directly impacts salary cap accounting and CBA compliance reporting.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this disciplinary action record was most recently modified. Tracks appeal status changes, fine payment updates, and ruling amendments for audit and compliance purposes.',
    `var_tmo_reviewed` BOOLEAN COMMENT 'Indicates whether the incident that triggered this disciplinary action was reviewed by VAR (Video Assistant Referee) or TMO (Television Match Official) technology during the game. Supports officiating quality analytics.',
    CONSTRAINT pk_disciplinary_action PRIMARY KEY(`disciplinary_action_id`)
) COMMENT 'Record of a formal disciplinary action issued by the league against a player, coach, franchise, or official. Includes infraction type (suspension, fine, ejection, probation, loss of draft pick), subject entity type and reference, incident date, game reference, ruling date, penalty amount, suspension length in games, appeal eligibility, appeal status, and final ruling. Supports competitive integrity and CBA compliance tracking.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`salary_cap` (
    `salary_cap_id` BIGINT COMMENT 'Unique surrogate identifier for each salary cap record. Serves as the primary key for the salary_cap data product in the league domain.',
    `budget_id` BIGINT COMMENT 'Foreign key linking to finance.budget. Business justification: The salary cap amount per franchise/season is a direct input to the franchise payroll budget. Payroll budget vs. cap compliance variance reporting and annual budget planning for player costs require l',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Salary cap calculations are tied to specific fiscal periods for cap year accounting, luxury tax liability recognition, and CBA financial disclosure. salary_cap has cap_year (plain text) but no FK to f',
    `franchise_id` BIGINT COMMENT 'Reference to the team franchise for which this compliance snapshot applies. NULL when the record represents the league-wide cap definition rather than a franchise-level snapshot.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Luxury tax liabilities, cap penalties, and cap-related financial obligations post to specific GL accounts. The cap compliance-to-GL reconciliation is a mandatory finance close process; auditors requir',
    `league_id` BIGINT COMMENT 'Reference to the professional sports league (e.g., NFL, NBA, MLB, NHL, MLS) for which this salary cap rule set applies.',
    `media_rights_deal_id` BIGINT COMMENT 'Foreign key linking to broadcast.media_rights_deal. Business justification: CBA-mandated salary cap calculation is directly derived from league broadcast revenue. The media rights deal is the primary revenue source for cap calculation; linking salary_cap to media_rights_deal ',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Salary cap compliance is governed by specific CBA obligations. CBA obligation tracking for salary cap administration, compliance status reporting, and penalty assessment require structured FK; salary_',
    `season_id` BIGINT COMMENT 'Reference to the competitive season for which this salary cap definition is in effect.',
    `active_payroll_amount` DECIMAL(18,2) COMMENT 'The total current payroll charged against the franchises salary cap for all active roster contracts in the cap year. Updated on each roster transaction or contract signing. Expressed in USD.',
    `announcement_date` DATE COMMENT 'The official date on which the league announced the salary cap figures for the cap year. Marks the start of the free agency and contract negotiation window.',
    `apron_amount` DECIMAL(18,2) COMMENT 'The second apron threshold above the luxury tax line, above which franchises face additional CBA restrictions on roster moves (e.g., no trade aggregation, no MLE use). Expressed in USD. Introduced in NBA CBA 2023.',
    `bi_annual_exception_amount` DECIMAL(18,2) COMMENT 'The dollar value of the bi-annual exception available to franchises for the cap year, usable once every two years to sign players above the soft cap. Expressed in USD.',
    `cap_calculation_methodology` STRING COMMENT 'Narrative description of the formula or methodology used to derive the hard cap and soft cap amounts from total league revenue, as specified in the CBA. For example, BRI (Basketball Related Income) split at 51% player share or All Revenue multiplied by player cost percentage.',
    `cap_effective_date` DATE COMMENT 'The date on which the salary cap rules for this cap year become legally binding and enforceable for all franchises, as defined in the CBA.',
    `cap_exception_notes` STRING COMMENT 'Free-text notes documenting any special cap exceptions, waivers, or league-approved adjustments applied to this franchises cap calculation for the cap year (e.g., COVID-19 cap smoothing, hardship exceptions).',
    `cap_expiry_date` DATE COMMENT 'The date on which the salary cap period ends and the cap year closes. After this date, final compliance determinations are made and luxury tax bills are issued.',
    `cap_floor_amount` DECIMAL(18,2) COMMENT 'The minimum total payroll a franchise must commit to active player contracts for the cap year. Franchises below the floor may be subject to CBA penalties or required to distribute the shortfall to players. Expressed in USD.',
    `cap_holds_amount` DECIMAL(18,2) COMMENT 'Total cap holds charged against the franchise for unsigned draft picks, restricted free agents, and qualifying offers outstanding. Cap holds reserve space until contracts are signed or rights are renounced. Expressed in USD.',
    `cap_space_remaining` DECIMAL(18,2) COMMENT 'The amount of salary cap space available to the franchise for additional player signings, calculated as the applicable cap ceiling minus total cap charges. Expressed in USD. Updated in real time on roster transactions.',
    `cap_type` STRING COMMENT 'Classification of the cap structure applicable to this league and season. Hard cap enforces an absolute ceiling; soft cap allows exceptions; luxury tax imposes financial penalties above threshold; no_cap indicates an uncapped league.. Valid values are `hard_cap|soft_cap|luxury_tax|no_cap`',
    `cap_year` STRING COMMENT 'The calendar year of the salary cap period (e.g., 2024). Used to distinguish multi-year cap tracking and align with the Collective Bargaining Agreement (CBA) cap year definition.',
    `cba_version` STRING COMMENT 'The version or effective date identifier of the Collective Bargaining Agreement governing the salary cap rules for this cap year (e.g., NFL CBA 2020-2030, NBA CBA 2023). Ensures traceability to the correct CBA provisions.',
    `compliance_status` STRING COMMENT 'Current compliance state of the franchise against the applicable salary cap rules for the cap year. Compliant = within all thresholds; warning = approaching cap ceiling or floor; violation = exceeds hard cap or breaches CBA rules; under_review = pending league adjudication.. Valid values are `compliant|warning|violation|under_review`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this salary cap record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary cap amounts are denominated (e.g., USD for US Dollar, CAD for Canadian Dollar for NHL franchises).. Valid values are `^[A-Z]{3}$`',
    `dead_cap_amount` DECIMAL(18,2) COMMENT 'The total cap charges attributed to players no longer on the active roster (released, traded, or retired) whose guaranteed money or signing bonus proration still counts against the franchises cap. Expressed in USD.',
    `draft_pick_penalty_flag` BOOLEAN COMMENT 'Indicates whether the franchise has been assessed a draft pick forfeiture as a penalty for a salary cap violation in this cap year.',
    `escrow_percentage` DECIMAL(18,2) COMMENT 'The percentage of player salaries withheld in escrow during the season to ensure the players share of revenue does not exceed the CBA-defined threshold. Expressed as a decimal (e.g., 0.1000 = 10%). Reconciled at season end.',
    `first_apron_amount` DECIMAL(18,2) COMMENT 'The first apron threshold above the luxury tax line, above which franchises face initial CBA restrictions on roster moves (e.g., reduced MLE, no sign-and-trade as acquiring team). Expressed in USD.',
    `franchise_tag_amount` DECIMAL(18,2) COMMENT 'The one-year tender value applied when a franchise designates a player with the franchise tag, preventing free agency. Calculated as the average of the top-N salaries at the players position or a percentage of the cap, per CBA rules. Expressed in USD.',
    `hard_cap_amount` DECIMAL(18,2) COMMENT 'The absolute maximum total player payroll permitted under the leagues hard cap rule for the cap year. Franchises may not exceed this amount under any circumstance. Expressed in USD.',
    `injured_reserve_credit` DECIMAL(18,2) COMMENT 'Cap relief credit granted to a franchise when a player is placed on the injured reserve list, allowing a replacement signing above the normal cap threshold. Expressed in USD. Governed by CBA injured reserve rules.',
    `last_transaction_date` DATE COMMENT 'The date of the most recent roster transaction (signing, release, trade, IR placement) that triggered an update to this franchises cap compliance snapshot.',
    `luxury_tax_liability` DECIMAL(18,2) COMMENT 'The calculated luxury tax dollar amount owed by the franchise based on the amount by which total payroll exceeds the luxury tax threshold, multiplied by the applicable CBA tax rate. Expressed in USD. Zero if payroll is below threshold.',
    `luxury_tax_repeater_flag` BOOLEAN COMMENT 'Indicates whether the franchise qualifies as a luxury tax repeater under CBA rules, triggering higher incremental tax rates for franchises that have been taxpayers in multiple seasons within a defined lookback window.',
    `luxury_tax_threshold` DECIMAL(18,2) COMMENT 'The payroll level above which a franchise incurs luxury tax penalties. Franchises exceeding this threshold pay a tax rate per dollar over the threshold as defined in the CBA. Expressed in USD.',
    `mid_level_exception_amount` DECIMAL(18,2) COMMENT 'The dollar value of the mid-level exception available to franchises for the cap year, allowing teams over the soft cap to sign players up to this amount. Expressed in USD. Applicable in NBA-style soft cap leagues.',
    `penalty_amount` DECIMAL(18,2) COMMENT 'The financial penalty assessed against the franchise for a salary cap violation, as determined by the league office. Expressed in USD. Zero if no violation exists.',
    `player_share_percentage` DECIMAL(18,2) COMMENT 'The CBA-defined percentage of total league revenue allocated to player salaries and benefits for the cap year. Expressed as a decimal (e.g., 0.5100 = 51%). Drives cap calculation methodology.',
    `practice_squad_charges` DECIMAL(18,2) COMMENT 'Total salary cap charges attributable to players on the practice squad roster for the cap year. Expressed in USD. Governed by CBA practice squad rules.',
    `record_type` STRING COMMENT 'Discriminator indicating whether this record is a league-wide cap rule definition or a per-franchise compliance snapshot. Drives downstream processing logic.. Valid values are `league_definition|franchise_snapshot`',
    `snapshot_timestamp` TIMESTAMP COMMENT 'The exact date and time at which the franchise-level compliance snapshot was captured. Enables point-in-time cap analysis and audit trail for roster transactions.',
    `soft_cap_amount` DECIMAL(18,2) COMMENT 'The baseline salary cap ceiling above which teams may still sign players using defined CBA exceptions (e.g., mid-level exception, Bird rights). Expressed in USD. Applicable primarily in NBA-style cap structures.',
    `total_league_revenue_basis` DECIMAL(18,2) COMMENT 'The total league-wide revenue figure used as the basis for calculating the salary cap for the cap year, as defined in the CBA. Typically derived from broadcast rights, gate receipts, and other shared revenue streams. Expressed in USD.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this salary cap record was last modified. Updated on every roster transaction, contract signing, or league adjustment that affects cap figures.',
    `violation_description` STRING COMMENT 'Narrative description of the nature of any salary cap violation identified for this franchise in the cap year. Populated only when compliance_status is violation or under_review.',
    CONSTRAINT pk_salary_cap PRIMARY KEY(`salary_cap_id`)
) COMMENT 'Annual salary cap definition and franchise compliance tracking per league and season. Defines hard cap, soft cap, luxury tax threshold, cap floor, and applicable exceptions (mid-level, bi-annual, franchise tag). Tracks cap year, total league revenue basis, escrow percentage, cap calculation methodology, and official announcement date. Also captures per-franchise compliance snapshots: total active payroll, cap space remaining, dead cap, injured reserve credits, practice squad charges, cap holds, luxury tax liability, and compliance status (compliant, warning, violation). Updated on roster transactions and contract signings. SSOT for salary cap rules AND franchise-level cap compliance.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`draft` (
    `draft_id` BIGINT COMMENT 'Unique surrogate identifier for the draft event record in the league competition governance system.',
    `broadcast_schedule_id` BIGINT COMMENT 'Foreign key linking to broadcast.broadcast_schedule. Business justification: Draft events are major broadcast productions with dedicated broadcast schedules. Draft has ott_streaming_enabled indicating broadcast awareness. Linking draft to broadcast_schedule supports draft broa',
    `budget_id` BIGINT COMMENT 'Foreign key linking to finance.budget. Business justification: Draft events carry significant budgets covering venue costs, broadcast production, logistics, and operational expenses. Finance teams create and track draft-specific budgets for planning and variance ',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Draft event operational costs (venue rental, broadcast production, staffing, security, fan experience) are charged to a specific cost center. Draft event budget vs. actuals reporting and opex allocati',
    `governing_body_id` BIGINT COMMENT 'Foreign key linking to compliance.governing_body. Business justification: Drafts are conducted under specific governing body rules (eligibility standards, anti-tampering, WADA compliance). Draft compliance reporting and eligibility oversight require structured governing bod',
    `league_id` BIGINT COMMENT 'Reference to the professional league (NFL, NBA, MLB, NHL, MLS, FIFA, etc.) that governs and administers this draft event.',
    `season_id` BIGINT COMMENT 'Reference to the competitive season calendar record to which this draft event belongs, linking draft class to the corresponding league season.',
    `venue_id` BIGINT COMMENT 'Reference to the venue or facility where the live draft event is hosted. Null for fully virtual drafts.',
    `actual_attendance` STRING COMMENT 'Actual number of fans who attended the live draft event in person, recorded post-event for reporting, sponsorship fulfillment, and future event planning benchmarking.',
    `cba_version` STRING COMMENT 'Version or effective date identifier of the Collective Bargaining Agreement governing the rules, eligibility criteria, rookie wage scale, and draft procedures for this draft event.',
    `compensatory_picks_authorized` BOOLEAN COMMENT 'Indicates whether compensatory picks have been authorized for this draft event by the league office, awarded to franchises that lost qualifying free agents in the prior season.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this draft event record was first created in the league governance system, used for audit trail and data lineage tracking.',
    `draft_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying this draft event across league systems and partner integrations (e.g., NFL-DRAFT-2025, NBA-DRAFT-2025-SUPP).. Valid values are `^[A-Z]{2,6}-DRAFT-[0-9]{4}(-[A-Z0-9]+)?$`',
    `draft_date` DATE COMMENT 'Calendar date on which the draft event commences (first day of the draft), used for scheduling, broadcast rights activation, and athlete eligibility confirmation deadlines.',
    `draft_name` STRING COMMENT 'Official human-readable name of the draft event as published by the governing league (e.g., 2025 NFL Draft, 2025 NBA Draft).',
    `draft_status` STRING COMMENT 'Current lifecycle state of the draft event, governing downstream processing of pick selections, trade executions, and athlete eligibility confirmations.. Valid values are `scheduled|in_progress|completed|cancelled|postponed`',
    `eligibility_class` STRING COMMENT 'Classification of the athlete pool eligible for this draft, determining applicable eligibility rules, age requirements, and CBA provisions (e.g., college seniors, international prospects, supplemental class). [ENUM-REF-CANDIDATE: college|international|supplemental|developmental|undrafted_free_agent — promote to reference product]. Valid values are `college|international|supplemental|developmental|undrafted_free_agent`',
    `end_date` DATE COMMENT 'Calendar date on which the draft event concludes (last day of selections), relevant for multi-day drafts such as the NFL Draft (3 days) or MLB Draft.',
    `expected_attendance` STRING COMMENT 'Projected number of fans expected to attend the live draft event in person, used for venue capacity planning, security staffing, and sponsorship activation sizing.',
    `fan_attendance_allowed` BOOLEAN COMMENT 'Indicates whether public fan attendance is permitted at the live draft venue, affecting ticketing operations, venue capacity planning, and fan engagement activations.',
    `forfeited_picks` STRING COMMENT 'Number of pick slots forfeited during this draft event due to disciplinary actions, salary cap violations, or clock expiration, as ruled by the league office.',
    `format` STRING COMMENT 'Operational format of the draft event indicating whether selections are made in-person at a live venue, fully virtual via remote broadcast, or a hybrid combination of both.. Valid values are `live|virtual|hybrid`',
    `gdpr_applicable` BOOLEAN COMMENT 'Indicates whether GDPR data privacy regulations apply to this draft event based on the host country jurisdiction and the nationalities of eligible athletes.',
    `host_city` STRING COMMENT 'Name of the city hosting the live draft event, used for event planning, fan engagement, sponsorship activation, and broadcast production logistics.',
    `host_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the nation hosting the draft event, used for regulatory compliance, broadcast rights jurisdiction, and international fan engagement.. Valid values are `^[A-Z]{3}$`',
    `integrity_review_notes` STRING COMMENT 'Free-text notes documenting the nature and outcome of any competitive integrity review associated with this draft event, maintained by the league compliance office.',
    `integrity_review_required` BOOLEAN COMMENT 'Indicates whether this draft event or any of its picks are subject to a competitive integrity review by the league office, triggered by suspected rule violations or tanking investigations.',
    `lottery_conducted` BOOLEAN COMMENT 'Indicates whether a draft lottery was conducted to determine the order of top picks for this draft event (True = lottery held; False = order determined by standings or other method).',
    `lottery_date` DATE COMMENT 'Calendar date on which the draft lottery was conducted to determine pick order, applicable when lottery_conducted is True.',
    `notes` STRING COMMENT 'Free-text operational notes or administrative remarks about this draft event recorded by the league office, covering special circumstances, rule exceptions, or logistical details.',
    `order_method` STRING COMMENT 'Method used to determine the order in which franchises make their selections (e.g., lottery for top picks, inverse regular-season standings, coin flip for tied records, or predetermined compensatory formula). [ENUM-REF-CANDIDATE: lottery|inverse_standings|coin_flip|predetermined|compensatory — promote to reference product]. Valid values are `lottery|inverse_standings|coin_flip|predetermined|compensatory`',
    `ott_streaming_enabled` BOOLEAN COMMENT 'Indicates whether the draft event is available for live streaming via OTT/DTC digital platforms in addition to or instead of traditional broadcast, supporting digital fan engagement.',
    `pick_clock_seconds` STRING COMMENT 'Allotted time in seconds each franchise has to submit a pick selection before the clock expires and the pick may be forfeited or auto-submitted, as defined by league rules.',
    `picks_completed` STRING COMMENT 'Running count of pick selections that have been exercised and confirmed during the draft event, used for real-time progress tracking and broadcast production.',
    `salary_cap_year` STRING COMMENT 'The salary cap fiscal year applicable to rookie contracts signed by athletes selected in this draft, governing rookie wage scale calculations and cap hit projections.',
    `sport` STRING COMMENT 'The professional sport discipline governed by this draft event, used to apply sport-specific eligibility rules, CBA provisions, and draft format configurations.. Valid values are `football|basketball|baseball|hockey|soccer|other`',
    `start_timestamp` TIMESTAMP COMMENT 'Precise date and time at which the draft event officially begins (first pick clock starts), used for broadcast scheduling, OTT streaming activation, and real-time pick tracking.',
    `supplemental_draft` BOOLEAN COMMENT 'Indicates whether this draft event is a supplemental draft (True) rather than the primary annual draft (False), used for athletes who became eligible after the standard draft deadline.',
    `total_picks` STRING COMMENT 'Total number of pick slots in this draft event, including standard picks, compensatory picks, and supplemental picks as authorized by the governing league.',
    `total_rounds` STRING COMMENT 'Total number of rounds in this draft event as defined by the governing leagues CBA and draft rules (e.g., NFL = 7 rounds, NBA = 2 rounds, MLB = 20+ rounds).',
    `trades_executed` STRING COMMENT 'Total number of pick trade transactions executed during this draft event, used for trade analysis, draft asset management reporting, and competitive intelligence.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this draft event record was most recently modified in the league governance system, supporting change tracking, audit compliance, and Silver layer delta processing.',
    `wada_compliance_confirmed` BOOLEAN COMMENT 'Indicates whether all athletes in the eligible draft class have been confirmed compliant with WADA anti-doping regulations prior to the draft event commencing.',
    `year` STRING COMMENT 'Calendar year in which the draft event takes place, used as the primary temporal classification for draft class cohort analysis and future pick valuation.',
    CONSTRAINT pk_draft PRIMARY KEY(`draft_id`)
) COMMENT 'Master record for a league player draft event and all individual pick selections. At the event level: draft year, sport, number of rounds, total picks, draft format (live, virtual, hybrid), draft date and location, eligibility class (college, international, supplemental), draft order determination method (lottery, inverse standings, coin flip), and draft status. At the pick level: round number, overall pick number, current owning franchise, original owning franchise (if traded), full trade history chain, compensatory/conditional pick flags, pick protection level (top-N protected), pick status (available, traded, exercised, forfeited, voided), and selected athlete reference upon exercise. Supports draft asset management, trade analysis, and future pick valuation models.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`draft_pick` (
    `draft_pick_id` BIGINT COMMENT 'Unique surrogate identifier for each individual draft pick record within the league draft management system. Primary key for the draft_pick entity.',
    `draft_id` BIGINT COMMENT 'Reference to the parent draft event to which this pick belongs (e.g., 2024 NFL Draft, 2024 NBA Draft). Links the pick to its governing draft event.',
    `trade_transaction_id` BIGINT COMMENT 'Reference to the most recent trade transaction record in which this pick was transferred. Enables full trade audit trail linkage.',
    `league_id` BIGINT COMMENT 'Reference to the professional league (NFL, NBA, MLB, NHL, MLS, FIFA, etc.) that governs this draft pick and its associated rules.',
    `athlete_profile_id` BIGINT COMMENT 'Reference to the athlete selected with this pick upon exercise. Null until the pick is exercised. Links to the athlete profile for post-draft roster and contract management.',
    `franchise_id` BIGINT COMMENT 'Reference to the franchise that currently holds the rights to exercise this draft pick. May differ from the original owning franchise if the pick has been traded.',
    `season_id` BIGINT COMMENT 'Reference to the league season associated with this draft pick. Links the pick to the competitive season calendar for standings-based draft order determination.',
    `cba_compliance_status` STRING COMMENT 'Current CBA compliance status of this draft pick record. compliant = meets all CBA requirements; under_review = pending league review; violation = CBA rule breach identified; waived = compliance requirement formally waived by league.. Valid values are `compliant|under_review|violation|waived`',
    `competitive_integrity_flag` BOOLEAN COMMENT 'Indicates whether this pick has been flagged for competitive integrity review by the league office (e.g., suspected tanking, collusion, or improper trade). Triggers compliance investigation workflow.',
    `condition_description` STRING COMMENT 'Free-text description of the conditions governing a conditional pick (e.g., Converts to 1st round if franchise wins division; otherwise 2nd round). Populated only when is_conditional is true.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp at which this draft pick record was first created in the system, including timezone offset. Supports audit trail and data lineage requirements.',
    `draft_position_tier` STRING COMMENT 'Categorical tier classification of this picks position within the draft (e.g., lottery for NBA lottery picks, top_10, first_round, second_round, later_round). Used for pick valuation segmentation and trade analysis.. Valid values are `lottery|top_10|first_round|second_round|later_round`',
    `draft_year` STRING COMMENT 'The calendar year of the draft event in which this pick is to be exercised. Critical for future pick tracking and multi-year trade asset management.',
    `exercise_date` DATE COMMENT 'The date on which this pick was exercised (i.e., used to select an athlete during the draft event). Null until the pick is exercised.',
    `exercise_timestamp` TIMESTAMP COMMENT 'The precise date and time at which this pick was exercised during the draft event, including timezone offset. Supports real-time draft broadcast and pick clock compliance tracking.',
    `external_ref` STRING COMMENT 'The externally-known identifier for this pick as published by the league office or official transaction systems (e.g., league transaction ID, official pick number code). Supports system-of-record reconciliation.',
    `forfeiture_reason` STRING COMMENT 'Description of the reason this pick was forfeited, if applicable (e.g., salary cap violation, tampering penalty, CBA non-compliance). Populated only when pick_status is forfeited.',
    `forfeiture_ruling_date` DATE COMMENT 'The date on which the league office issued the ruling to forfeit this pick. Populated only when pick_status is forfeited.',
    `is_compensatory_pick` BOOLEAN COMMENT 'Indicates whether this pick was awarded as a compensatory pick by the league office (e.g., NFL compensatory picks for lost free agents). Compensatory picks are subject to special trade restrictions in some leagues.',
    `is_conditional` BOOLEAN COMMENT 'Indicates whether this pick is subject to conditions that may alter its round, year, or validity (e.g., becomes a 1st round pick if team makes playoffs). When true, condition_description provides the governing terms.',
    `is_lottery_eligible` BOOLEAN COMMENT 'Indicates whether this pick is eligible to be determined by a lottery mechanism (e.g., NBA Draft Lottery). Relevant for protected pick valuation and conditional pick resolution.',
    `is_tradeable` BOOLEAN COMMENT 'Indicates whether this pick is currently eligible to be traded under league rules. Some picks (e.g., compensatory picks in certain leagues, picks under CBA restrictions) may be non-tradeable.',
    `last_trade_date` DATE COMMENT 'The date on which this pick was most recently traded to its current owning franchise. Null if the pick has never been traded.',
    `pick_announcement_name` STRING COMMENT 'The official name announced for this pick during the draft broadcast (e.g., The Dallas Cowboys select...). Used for broadcast production, content, and DAM (Digital Asset Management) workflows.',
    `pick_clock_seconds_remaining` STRING COMMENT 'The number of seconds remaining on the pick clock when the pick was submitted. Used for draft broadcast analytics and compliance with league pick clock rules.',
    `pick_number` STRING COMMENT 'The sequential overall pick number within the entire draft event (e.g., pick #1 through #259 in the NFL Draft). Used for pick valuation models and historical analysis.',
    `pick_source_league_rule` STRING COMMENT 'The specific league rule, CBA article, or governing provision under which this pick was created or awarded (e.g., CBA Article 5, Section 3 - Compensatory Pick Formula, Expansion Draft Rule 12). Supports compliance and audit.',
    `pick_status` STRING COMMENT 'Current lifecycle status of the draft pick. available = held and ready to use; traded = transferred to another franchise; exercised = used to select an athlete; forfeited = surrendered as penalty; voided = invalidated by league ruling.. Valid values are `available|traded|exercised|forfeited|voided`',
    `pick_type` STRING COMMENT 'Classification of the pick by its origin type. standard = regular draft order pick; compensatory = awarded by league for free agent losses; supplemental = mid-year supplemental draft; expansion = awarded to expansion franchise; traded = acquired via trade.. Valid values are `standard|compensatory|supplemental|expansion|traded`',
    `pick_valuation_score` DECIMAL(18,2) COMMENT 'Quantitative valuation score assigned to this pick based on the leagues or franchises draft pick value chart (e.g., NFL Jimmy Johnson Chart, Chase Stuart Chart). Used for trade analysis and asset management. Not a calculated aggregate — represents the chart-assigned value for this pick position.',
    `pick_within_round` STRING COMMENT 'The sequential pick number within the specific round (e.g., 3rd pick in Round 2). Combined with round_number provides the full pick address (e.g., Round 2, Pick 3).',
    `protection_level` STRING COMMENT 'The top-N protection threshold for this pick (e.g., 3 = top-3 protected, meaning if the pick falls in the top 3 overall, it does not convey to the trading partner and rolls over). Null if unprotected.',
    `protection_rollover_year_limit` STRING COMMENT 'The maximum number of years a protected pick can roll over before it must convey regardless of protection status. Governs the expiry of pick protection in multi-year trade agreements.',
    `round_number` STRING COMMENT 'The round within the draft event in which this pick falls (e.g., Round 1, Round 2, Round 7). Determines pick tier and associated contract slot values in CBA-governed leagues.',
    `salary_cap_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the salary cap slot value (e.g., USD for NFL/NBA/MLB/NHL, EUR for FIFA leagues). Supports multi-league and international operations.. Valid values are `^[A-Z]{3}$`',
    `salary_cap_slot_value` DECIMAL(18,2) COMMENT 'The CBA-mandated salary cap slot value associated with this pick position, expressed in the leagues designated currency. Governs the rookie contract value for the selected athlete. Critical for salary cap compliance reporting.',
    `trade_count` STRING COMMENT 'Total number of times this pick has been traded between franchises. Used for trade complexity analysis and pick valuation models.',
    `trade_history` STRING COMMENT 'Serialized summary of the full trade chain for this pick, recording each franchise that has held the pick in sequence (e.g., FranchiseA → FranchiseB → FranchiseC). Supports trade analysis and pick provenance auditing.',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp at which this draft pick record was most recently modified, including timezone offset. Supports change tracking, audit compliance, and silver layer incremental processing.',
    CONSTRAINT pk_draft_pick PRIMARY KEY(`draft_pick_id`)
) COMMENT 'Individual draft pick record within a draft event, tracking round number, overall pick number, current owning franchise, original owning franchise (if traded), full trade history chain, compensatory pick flag, conditional pick flag with conditions description, pick protection level (top-N protected), pick status (available, traded, exercised, forfeited, voided), and selected athlete reference upon exercise. Supports draft asset management, trade analysis, and future pick valuation models.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` (
    `trade_transaction_id` BIGINT COMMENT 'Primary key for trade_transaction',
    `contract_id` BIGINT COMMENT 'Foreign key linking to athlete.athlete_contract. Business justification: When an athlete is traded, their contract obligations transfer to the acquiring franchise. Linking trade_transaction to the specific athlete_contract being transferred is essential for cap accounting ',
    `investigation_id` BIGINT COMMENT 'Foreign key linking to compliance.investigation. Business justification: Trade transactions can trigger integrity investigations (tampering, salary cap circumvention, undisclosed side agreements). Direct FK from trade_transaction to investigation enables transaction-level ',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Trade transactions involving cash consideration (cash_consideration_amount field) require journal entries for financial posting of cash transfers between franchises. SOX audit trail and financial reco',
    `league_id` BIGINT COMMENT 'Reference to the league (e.g., NFL, NBA, MLB, NHL, MLS) under whose governance this transaction is processed and approved.',
    `franchise_id` BIGINT COMMENT 'Reference to the franchise receiving the primary asset (player, draft pick, or cash consideration) in this transaction. In waiver claims, this is the claiming franchise.',
    `athlete_profile_id` BIGINT COMMENT 'Reference to the primary athlete (player) being transferred in this transaction. For multi-player trades, this represents the headline player; additional players are captured in associated transaction line records. Null for cash-only or draft-pick-only transactions.',
    `season_id` BIGINT COMMENT 'Foreign key linking to league.season. Business justification: trade_transaction currently stores season_year as an INT denormalization. Adding season_id as a proper FK to league.season normalizes the season reference and enables joins to the full season record (',
    `tertiary_trade_third_franchise_id` BIGINT COMMENT 'Reference to the third franchise involved in a three-way trade transaction. Null for bilateral trades, waiver claims, and all other non-three-way transaction types.',
    `transaction_window_id` BIGINT COMMENT 'Foreign key linking to league.transaction_window. Business justification: Trade transactions must occur within official league transaction windows (trade deadline, free agency window). trade_transaction has transaction_window_compliant (BOOLEAN) indicating compliance but no',
    `approval_date` DATE COMMENT 'The date on which the league office officially approved and ratified this transaction. Null if the transaction is still pending, rejected, or voided.',
    `cash_consideration_amount` DECIMAL(18,2) COMMENT 'The gross monetary value of cash included in this transaction (e.g., player-for-cash trade, cash balancing payment). Subject to league-mandated cash consideration limits per CBA. Zero if no cash is exchanged.',
    `cash_consideration_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the cash consideration amount (e.g., USD, CAD, EUR). Required when cash_consideration_amount is non-zero.. Valid values are `^[A-Z]{3}$`',
    `cba_compliance_status` STRING COMMENT 'The CBA compliance determination for this transaction, covering salary cap rules, roster limits, player movement restrictions, and cash consideration limits. under_review = league compliance office is actively reviewing; waived = league granted a formal CBA waiver.. Valid values are `compliant|non_compliant|under_review|waived`',
    `clearing_date` DATE COMMENT 'For waiver transactions, the date on which the player clears the waiver wire without being claimed, making them eligible for outright assignment or free agency. Null for non-waiver transaction types.',
    `competitive_integrity_review_flag` BOOLEAN COMMENT 'Indicates whether this transaction was flagged for competitive integrity review by the league office (e.g., suspected tanking, collusion between franchises, or circumvention of salary cap rules). True = flagged for review.',
    `condition_resolution_date` DATE COMMENT 'The date by which all conditional terms of this transaction must be resolved or triggered. Null for unconditional transactions. Used to monitor outstanding conditional trade obligations.',
    `conditional_terms_description` STRING COMMENT 'Free-text description of any conditions attached to this transaction (e.g., Draft pick converts to 1st round if team makes playoffs, Player option triggers salary escalation). Null for unconditional transactions.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time (with timezone offset) when this transaction record was first created in the league data platform. Serves as the system audit creation timestamp for data lineage and SOX compliance.',
    `draft_pick_id` BIGINT COMMENT 'Reference to the draft pick asset being transferred as part of this transaction. Null if no draft pick is included. For multi-pick trades, this captures the primary pick; additional picks are in associated line records.',
    `effective_date` DATE COMMENT 'The date on which the transaction takes operational effect — i.e., when the player or asset officially moves to the acquiring franchises roster and salary cap. May differ from transaction_date or approval_date (e.g., post-trade deadline holds).',
    `no_trade_clause_waived` BOOLEAN COMMENT 'Indicates whether the player involved in this transaction had a contractual no-trade clause that was formally waived by the player to allow the transaction to proceed. True = player waived their no-trade clause.',
    `no_trade_clause_waiver_date` DATE COMMENT 'The date on which the player formally waived their no-trade clause to permit this transaction. Null if no no-trade clause existed or was not applicable.',
    `notes` STRING COMMENT 'Free-text field for league operations staff to record supplementary context, special circumstances, or administrative notes related to this transaction that are not captured in structured fields.',
    `physical_exam_required` BOOLEAN COMMENT 'Indicates whether the transaction is contingent upon the acquired player passing a physical examination by the acquiring franchises medical staff. True = physical required before transaction is fully ratified.',
    `physical_exam_status` STRING COMMENT 'Current status of the required physical examination for the acquired player: not_required, pending (scheduled but not completed), passed (cleared), failed (transaction may be voided), waived (franchise waived physical requirement).. Valid values are `not_required|pending|passed|failed|waived`',
    `rejection_reason` STRING COMMENT 'Official league-provided explanation for why this transaction was rejected (e.g., salary cap violation, roster limit exceeded, CBA restriction, competitive integrity concern). Null for approved or pending transactions.',
    `salary_cap_impact_acquiring` DECIMAL(18,2) COMMENT 'The net change to the acquiring franchises salary cap space resulting from this transaction (positive = cap charge added). Used for real-time cap compliance monitoring per CBA salary cap rules.',
    `salary_cap_impact_trading` DECIMAL(18,2) COMMENT 'The net change to the trading franchises salary cap space resulting from this transaction (negative = cap relief received). Used for real-time cap compliance monitoring per CBA salary cap rules.',
    `salary_obligation_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the salary obligation transferred amount (e.g., USD, CAD).. Valid values are `^[A-Z]{3}$`',
    `salary_obligation_transferred_amount` DECIMAL(18,2) COMMENT 'The total remaining salary obligation (base salary plus guaranteed money) transferred from the trading franchise to the acquiring franchise as part of this transaction. Critical for salary cap compliance tracking per CBA.',
    `source_system_transaction_code` STRING COMMENT 'The native transaction identifier from the originating operational system of record (e.g., SAP S/4HANA SD document number, Salesforce CRM opportunity ID) used for lineage tracing and reconciliation with upstream systems.',
    `trade_deadline_exception_flag` BOOLEAN COMMENT 'Indicates whether this transaction required and received a formal league exception to proceed after the official trade deadline. True = exception granted; False = standard transaction within deadline.',
    `transaction_date` DATE COMMENT 'The official calendar date on which the franchises agreed to and executed the transaction. This is the principal real-world business event date, distinct from the league approval date and system audit timestamps.',
    `transaction_reference_number` STRING COMMENT 'Externally-known league-assigned alphanumeric reference number for this transaction, used in official league communications, press releases, and regulatory filings. Format: LEAGUE_CODE-TXN-YEAR-SEQUENCE.. Valid values are `^[A-Z]{2,5}-TXN-[0-9]{4}-[0-9]{6}$`',
    `transaction_status` STRING COMMENT 'Current lifecycle state of the transaction in the league approval workflow: pending_approval (submitted, awaiting league review), approved (league has ratified), rejected (league denied), voided (approved but subsequently nullified), conditional_pending (approved subject to future conditions being met), rescinded (mutually withdrawn by franchises prior to approval).. Valid values are `pending_approval|approved|rejected|voided|conditional_pending|rescinded`',
    `transaction_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone offset) at which the transaction was formally executed and submitted to the league for approval. Used for waiver priority ordering and transaction window compliance validation.',
    `transaction_type` STRING COMMENT 'Classification of the inter-franchise movement: trade (bilateral asset exchange), waiver_claim (franchise claims player off waivers), waiver_placement (franchise places player on waiver wire), dfa_assignment (Designated for Assignment), conditional_trade (trade with future conditions), three_way_trade (multi-franchise exchange). [ENUM-REF-CANDIDATE: trade|waiver_claim|waiver_placement|dfa_assignment|conditional_trade|three_way_trade|release_claim|emergency_acquisition — promote to reference product]. Valid values are `trade|waiver_claim|waiver_placement|dfa_assignment|conditional_trade|three_way_trade`',
    `transaction_window_compliant` BOOLEAN COMMENT 'Indicates whether this transaction was executed within the league-mandated transaction window (e.g., trade deadline, waiver wire period). True = compliant; False = executed outside the permitted window, requiring league exception review.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time (with timezone offset) when this transaction record was most recently modified in the league data platform. Used for change data capture, audit trails, and incremental ETL processing.',
    `void_date` DATE COMMENT 'The date on which this transaction was officially voided or rescinded by the league. Null for non-voided transactions.',
    `void_reason` STRING COMMENT 'Explanation of why this transaction was voided or rescinded (e.g., failed physical examination, player refusal of trade, salary cap violation discovered post-approval). Null for non-voided transactions.',
    `waiver_claim_fee_amount` DECIMAL(18,2) COMMENT 'The standard waiver claim fee charged to the acquiring franchise by the league upon a successful waiver claim. Amount is defined by the applicable CBA. Zero or null for non-waiver transactions.',
    `waiver_priority_order` STRING COMMENT 'The league-assigned waiver priority rank of the claiming franchise at the time of the waiver transaction. Lower number indicates higher priority (e.g., 1 = first priority). Null for non-waiver transaction types.',
    CONSTRAINT pk_trade_transaction PRIMARY KEY(`trade_transaction_id`)
) COMMENT 'Record of inter-franchise player and asset movement including trades, waiver claims, and waiver wire transactions. Captures transaction date, involved franchises, assets exchanged (player references, draft pick references, cash considerations), transaction type (trade, waiver claim, waiver placement, DFA assignment), league approval status, approval date, voiding conditions, transaction window compliance flag, waiver priority order, salary obligation transfer details, and clearing dates. SSOT for all inter-franchise roster movement requiring league approval.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`transaction_window` (
    `transaction_window_id` BIGINT COMMENT 'Unique surrogate identifier for the league transaction window record. Primary key for the transaction_window data product in the league domain.',
    `extended_transaction_window_id` BIGINT COMMENT 'Self-referencing FK on transaction_window (extended_transaction_window_id)',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Transaction windows (trade deadlines, free agency periods) trigger salary cap adjustments, signing bonus accruals, and waiver claim fees that must be recorded in the correct fiscal period. Finance tea',
    `league_id` BIGINT COMMENT 'Reference to the league that owns and governs this transaction window. Determines which leagues rules and CBA provisions apply.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Transaction windows are governed by specific CBA/regulatory obligations (transfer window rules, waiver wire obligations). CBA compliance tracking for transaction windows requires structured FK; transa',
    `season_id` BIGINT COMMENT 'Reference to the league season during which this transaction window is active. Anchors the window to a specific competitive year and salary cap period.',
    `announcement_date` DATE COMMENT 'Date on which the league officially announced this transaction window to franchises and the public. Establishes the notice period for franchise preparation.',
    `approval_turnaround_hours` STRING COMMENT 'Maximum number of hours within which the league office must approve or reject a transaction submitted during this window. Defines the Service Level Agreement (SLA) for transaction processing.',
    `cap_year` STRING COMMENT 'The salary cap year (four-digit year) applicable to transactions executed within this window. Determines which cap years limits and exceptions apply for compliance validation.',
    `cba_article_reference` STRING COMMENT 'Specific article, section, or clause of the Collective Bargaining Agreement (CBA) that authorizes and governs this transaction window (e.g., Article VI, Section 4). Supports compliance audit and legal review.',
    `close_date` DATE COMMENT 'The official calendar date on which the transaction window closes and no further transactions may be submitted. Null for open-ended windows such as certain waiver periods.',
    `close_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the transaction window officially closes. Critical for trade deadline compliance — transactions submitted after this timestamp are invalid.',
    `competitive_integrity_review_required` BOOLEAN COMMENT 'Indicates whether transactions executed during this window are subject to a competitive integrity review by the league office to prevent collusion, tanking, or other violations of fair competition standards.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this transaction window record was first created in the system. Supports audit trail and data lineage requirements.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary limits and penalty amounts defined within this transaction window (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `eligible_transaction_types` STRING COMMENT 'Comma-separated list of transaction types authorized during this window (e.g., trade,waiver_claim,free_agent_signing,dfa,option_exercise). Defines the scope of permissible roster movements for compliance validation of league_trade_transaction and waiver_claim records.',
    `franchise_participation_scope` STRING COMMENT 'Defines which franchises are eligible to participate in this transaction window. all_franchises applies league-wide; other values restrict participation to a subset of franchises.. Valid values are `all_franchises|conference_specific|division_specific|selected_franchises`',
    `governing_body_code` STRING COMMENT 'Code identifying the primary governing body that oversees and enforces the rules of this transaction window (e.g., NFL, NBA, MLB, NHL, MLS, FIFA, IOC). [ENUM-REF-CANDIDATE: NFL|NBA|MLB|NHL|MLS|FIFA|IOC|UFC|ATP|OTHER — 10 candidates stripped; promote to reference product]',
    `international_transfer_rules_apply` BOOLEAN COMMENT 'Indicates whether FIFA Transfer Regulations or equivalent international governing body transfer rules apply to transactions within this window. Relevant for MLS, international soccer, and cross-border athlete movements.',
    `is_free_agency_eligible` BOOLEAN COMMENT 'Indicates whether free agent signings are permitted during this transaction window. Governs whether franchises may negotiate and execute contracts with unrestricted or restricted free agents.',
    `is_international_signing_eligible` BOOLEAN COMMENT 'Indicates whether international player signings are authorized during this window. Relevant for MLB International Signing Period, FIFA transfer windows, and MLS international roster slots.',
    `is_trade_eligible` BOOLEAN COMMENT 'Indicates whether player-for-player or player-for-pick trades are permitted during this transaction window. False for windows restricted to free agency or waiver activity only.',
    `is_waiver_eligible` BOOLEAN COMMENT 'Indicates whether waiver claims and waiver wire transactions are permitted during this transaction window. Determines whether waiver_claim records may be anchored to this window.',
    `league_approval_required` BOOLEAN COMMENT 'Indicates whether transactions executed during this window require explicit league office approval before becoming effective. When true, transactions remain pending until the league approves.',
    `max_cash_consideration_usd` DECIMAL(18,2) COMMENT 'Maximum cash consideration in US dollars permitted in a single transaction during this window, as governed by CBA provisions. Null if no cash limit applies. Used for compliance validation of league_trade_transaction records.',
    `max_transactions_per_franchise` STRING COMMENT 'Maximum number of transactions a single franchise may execute during this window, as defined by league rules or CBA provisions. Null indicates no per-franchise limit.',
    `open_date` DATE COMMENT 'The official calendar date on which the transaction window opens and franchises may begin submitting eligible transactions. Established by the league calendar and CBA provisions.',
    `open_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the transaction window officially opens. Used for compliance validation of transaction submission timestamps, particularly for trade deadline enforcement.',
    `penalty_description` STRING COMMENT 'Narrative description of the penalty provisions applicable to violations of this transaction window, including fine schedules, draft pick forfeiture rules, and suspension terms as defined in the CBA or league governance documents.',
    `penalty_draft_pick_loss` BOOLEAN COMMENT 'Indicates whether violation of this transaction windows rules may result in forfeiture of draft picks as a disciplinary penalty, per CBA or league governance provisions.',
    `penalty_fine_amount` DECIMAL(18,2) COMMENT 'Monetary fine amount imposed on a franchise for executing a transaction outside the authorized window or in violation of window rules. Expressed in the currency defined by currency_code.',
    `penalty_suspension_eligible` BOOLEAN COMMENT 'Indicates whether franchise personnel (e.g., general managers, coaches) may be suspended for violations of this transaction windows rules.',
    `physical_exam_required` BOOLEAN COMMENT 'Indicates whether a medical physical examination of the athlete is required before a transaction executed during this window becomes effective. Common for trade transactions involving player health risk.',
    `roster_freeze_applies` BOOLEAN COMMENT 'Indicates whether a roster freeze is in effect during this transaction window, prohibiting certain roster moves. Common during playoff periods or immediately preceding the trade deadline.',
    `salary_cap_applies` BOOLEAN COMMENT 'Indicates whether salary cap compliance checks are required for transactions executed during this window. When true, all transactions must be validated against the franchises cap space before league approval.',
    `season_phase` STRING COMMENT 'The phase of the competitive season during which this transaction window is active. Determines applicable roster rules, salary cap treatment, and CBA provisions for transactions executed within the window.. Valid values are `preseason|regular_season|postseason|offseason`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this transaction window record originated (e.g., SAP S/4HANA, Salesforce CRM, league operations platform). Supports data lineage and Silver layer provenance tracking.',
    `sport_type` STRING COMMENT 'The sport discipline to which this transaction window applies. Determines sport-specific CBA rules, roster size limits, and eligible transaction types. [ENUM-REF-CANDIDATE: football|basketball|baseball|hockey|soccer|tennis|mma|other — 8 candidates stripped; promote to reference product]',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this transaction window record. Supports change tracking, audit trail, and downstream incremental processing in the Databricks Silver layer.',
    `wada_clearance_required` BOOLEAN COMMENT 'Indicates whether World Anti-Doping Agency (WADA) clearance is required for athletes involved in transactions during this window. Applicable for international transfers and leagues with mandatory anti-doping compliance.',
    `window_name` STRING COMMENT 'Official human-readable name of the transaction window as published by the league (e.g., NFL Trade Deadline 2024, NBA Free Agency Window 2024-25, MLB International Signing Period 2024).',
    `window_notes` STRING COMMENT 'Free-text field for league operations staff to record supplementary information about this transaction window, including special conditions, amendments, or exceptions not captured in structured fields.',
    `window_reference_number` STRING COMMENT 'Externally-known alphanumeric reference code assigned by the league office to uniquely identify this transaction window for official communications, compliance filings, and franchise notifications.. Valid values are `^[A-Z]{2,6}-TW-[0-9]{4}-[A-Z0-9]{4,12}$`',
    `window_status` STRING COMMENT 'Current lifecycle state of the transaction window. scheduled = announced but not yet open; open = active and accepting transactions; closed = period has ended; suspended = temporarily halted by league order; cancelled = voided before opening.. Valid values are `scheduled|open|closed|suspended|cancelled`',
    `window_type` STRING COMMENT 'Classification of the transaction window by its primary business purpose. Determines which roster movement and trade activity types are authorized. DFA = Designated for Assignment. [ENUM-REF-CANDIDATE: trade_deadline|free_agency|waiver_period|dfa_window|international_signing|supplemental_draft — promote to reference product if additional types emerge]. Valid values are `trade_deadline|free_agency|waiver_period|dfa_window|international_signing`',
    CONSTRAINT pk_transaction_window PRIMARY KEY(`transaction_window_id`)
) COMMENT 'Defines official league transaction periods (trade deadline, free agency window, waiver period, DFA window, international signing period) with open/close dates, eligible transaction types, franchise participation rules, and penalty provisions for violations. Anchors all roster movement and trade activity to authorized periods. Supports compliance validation for league_trade_transaction and waiver_claim records.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`team` (
    `team_id` BIGINT COMMENT 'Primary key for team',
    `conference_id` BIGINT COMMENT 'Identifier of the conference this team belongs to, if the league uses a conference structure (e.g., Eastern Conference, Western Conference).',
    `division_id` BIGINT COMMENT 'Identifier of the division or conference this team is assigned to within the league (e.g., AFC East, Western Conference).',
    `franchise_id` BIGINT COMMENT 'Unique identifier for the franchise entity that owns this team. Links to franchise agreements and ownership records.',
    `venue_id` BIGINT COMMENT 'Identifier of the primary venue or stadium where the team plays home games.',
    `league_id` BIGINT COMMENT 'Identifier of the league this team competes in (e.g., NFL, NBA, Premier League, La Liga).',
    `parent_team_id` BIGINT COMMENT 'Self-referencing FK on team (parent_team_id)',
    `facility_id` BIGINT COMMENT 'Identifier of the primary training facility or practice venue used by the team.',
    `championship_count` STRING COMMENT 'Total number of league championships or titles won by the team in its history.',
    `city` STRING COMMENT 'Primary city where the team is based and represents.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code for the teams home country (e.g., USA, GBR, CAN).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this team record was first created in the system.',
    `established_date` DATE COMMENT 'Date when the team officially joined the current league or was granted franchise status.',
    `fan_base_size` BIGINT COMMENT 'Estimated number of registered or tracked fans associated with the team across all engagement platforms.',
    `founded_date` DATE COMMENT 'Date when the team was originally established or founded.',
    `is_expansion_team` BOOLEAN COMMENT 'Indicates whether the team was added to the league as an expansion franchise (true) or is an original/relocated team (false).',
    `jersey_sponsor` STRING COMMENT 'Name of the primary corporate sponsor whose branding appears on team jerseys.',
    `logo_url` STRING COMMENT 'URL or file path to the official team logo image asset.',
    `market_value` DECIMAL(18,2) COMMENT 'Estimated market valuation of the team franchise. Expressed in leagues base currency.',
    `market_value_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for market value (e.g., USD, EUR, GBP).',
    `mascot_name` STRING COMMENT 'Name of the teams official mascot character used for fan engagement and entertainment.',
    `nickname` STRING COMMENT 'Common nickname or informal name used by fans and media to refer to the team.',
    `playoff_appearances` STRING COMMENT 'Total number of playoff or postseason appearances by the team in its history.',
    `primary_color` STRING COMMENT 'Primary brand color of the team (hex code or color name). Used for uniforms, branding, and broadcast graphics.',
    `relocation_history` STRING COMMENT 'Textual summary of any previous cities or locations where the team was based before current location.',
    `rivalry_teams` STRING COMMENT 'Comma-separated list of team codes representing traditional rivals or derby opponents.',
    `roster_size` STRING COMMENT 'Current number of players on the active roster.',
    `salary_cap_amount` DECIMAL(18,2) COMMENT 'Maximum total salary amount the team is allowed to spend on player contracts under league salary cap rules. Expressed in leagues base currency.',
    `salary_cap_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for salary cap amounts (e.g., USD, EUR, GBP).',
    `social_media_handle` STRING COMMENT 'Primary social media handle or username for the team (e.g., Twitter/X handle).',
    `state_province` STRING COMMENT 'State, province, or region where the team is based.',
    `team_code` STRING COMMENT 'Short alphanumeric code or abbreviation for the team (e.g., LAL, MUN, NYY). Used for broadcast graphics and standings displays.',
    `team_name` STRING COMMENT 'Official full name of the team (e.g., Los Angeles Lakers, Manchester United).',
    `team_status` STRING COMMENT 'Current operational status of the team within the league.',
    `team_type` STRING COMMENT 'Classification of the team by competitive level and organizational structure.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the teams home location (e.g., America/New_York, Europe/London).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this team record was last modified in the system.',
    `website_url` STRING COMMENT 'Official website URL for the team.',
    CONSTRAINT pk_team PRIMARY KEY(`team_id`)
) COMMENT 'Master reference table for team. Referenced by preferred_team_id.';

CREATE OR REPLACE TABLE `sports_entertainment_ecm`.`league`.`official_assignment` (
    `official_assignment_id` BIGINT COMMENT 'Primary key for the official_assignment association',
    `game_result_id` BIGINT COMMENT 'Foreign key linking to the official game result record for which this crew assignment was made',
    `official_id` BIGINT COMMENT 'Foreign key linking to the assigned game official (referee, umpire, linesman, VAR operator, etc.)',
    `assignment_date` DATE COMMENT 'Calendar date on which the officiating bureau formally issued this crew assignment to the official. Used for lead-time tracking and conflict-of-interest window calculations.',
    `conflict_of_interest_flag` BOOLEAN COMMENT 'Indicates whether a conflict-of-interest concern was raised or reviewed for this specific official-game pairing (e.g., official has a known affiliation with one of the competing franchises). Managed per-assignment by the officiating bureaus integrity unit.',
    `crew_role` STRING COMMENT 'The specific officiating role this official performed in this game (e.g., Head Referee, Linesman, VAR Operator, TMO, Umpire). Distinct from official.primary_position which reflects career-level specialization; this captures the actual role performed on the day.',
    `performance_score` DECIMAL(18,2) COMMENT 'Numeric performance grade issued by the officiating bureaus evaluation team for this officials performance in this specific game. Distinct from official.performance_rating which is a rolling composite season score. Feeds into the composite rating calculation.',
    `var_tmo_intervened` BOOLEAN COMMENT 'Indicates whether this official exercised a VAR or TMO intervention decision during this specific game. Complements game_result.var_tmo_intervention_flag at the game level by attributing the intervention to the specific official responsible.',
    CONSTRAINT pk_official_assignment PRIMARY KEY(`official_assignment_id`)
) COMMENT 'This association product represents the Assignment between an official and a game_result. It captures the formal crew assignment record created by the league officiating bureau for each game, recording which official served in which crew role for a specific game result, along with per-game performance grading, VAR/TMO intervention tracking, and conflict-of-interest clearance. Each record links one official to one game_result and carries attributes that exist only in the context of that specific assignment.. Existence Justification: In professional sports leagues, each game is officiated by a multi-person crew (head referee, linesmen, VAR operators, etc.), meaning one game_result is associated with multiple officials. Simultaneously, each official works many games per season. The league officiating department actively manages these crew assignments as a formal business process — creating, updating, and tracking them with role, performance grade, and conflict-of-interest data that belongs to neither the official nor the game result alone.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ADD CONSTRAINT `fk_league_conference_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ADD CONSTRAINT `fk_league_division_conference_id` FOREIGN KEY (`conference_id`) REFERENCES `sports_entertainment_ecm`.`league`.`conference`(`conference_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ADD CONSTRAINT `fk_league_division_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ADD CONSTRAINT `fk_league_franchise_division_id` FOREIGN KEY (`division_id`) REFERENCES `sports_entertainment_ecm`.`league`.`division`(`division_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ADD CONSTRAINT `fk_league_franchise_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ADD CONSTRAINT `fk_league_season_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ADD CONSTRAINT `fk_league_league_schedule_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ADD CONSTRAINT `fk_league_league_schedule_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ADD CONSTRAINT `fk_league_league_schedule_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ADD CONSTRAINT `fk_league_league_schedule_rescheduled_from_league_schedule_id` FOREIGN KEY (`rescheduled_from_league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ADD CONSTRAINT `fk_league_league_schedule_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ADD CONSTRAINT `fk_league_standing_conference_id` FOREIGN KEY (`conference_id`) REFERENCES `sports_entertainment_ecm`.`league`.`conference`(`conference_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ADD CONSTRAINT `fk_league_standing_division_id` FOREIGN KEY (`division_id`) REFERENCES `sports_entertainment_ecm`.`league`.`division`(`division_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ADD CONSTRAINT `fk_league_standing_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ADD CONSTRAINT `fk_league_standing_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ADD CONSTRAINT `fk_league_standing_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ADD CONSTRAINT `fk_league_standing_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ADD CONSTRAINT `fk_league_playoff_bracket_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ADD CONSTRAINT `fk_league_playoff_bracket_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ADD CONSTRAINT `fk_league_playoff_bracket_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_primary_game_franchise_id` FOREIGN KEY (`primary_game_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_quaternary_game_losing_team_franchise_id` FOREIGN KEY (`quaternary_game_losing_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_quinary_game_protest_filing_team_franchise_id` FOREIGN KEY (`quinary_game_protest_filing_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_tertiary_game_franchise_id` FOREIGN KEY (`tertiary_game_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_tertiary_game_winning_team_franchise_id` FOREIGN KEY (`tertiary_game_winning_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_tertiary_quinary_game_protest_filing_team_franchise_id` FOREIGN KEY (`tertiary_quinary_game_protest_filing_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ADD CONSTRAINT `fk_league_official_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ADD CONSTRAINT `fk_league_draft_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ADD CONSTRAINT `fk_league_draft_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ADD CONSTRAINT `fk_league_draft_pick_draft_id` FOREIGN KEY (`draft_id`) REFERENCES `sports_entertainment_ecm`.`league`.`draft`(`draft_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ADD CONSTRAINT `fk_league_draft_pick_trade_transaction_id` FOREIGN KEY (`trade_transaction_id`) REFERENCES `sports_entertainment_ecm`.`league`.`trade_transaction`(`trade_transaction_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ADD CONSTRAINT `fk_league_draft_pick_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ADD CONSTRAINT `fk_league_draft_pick_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ADD CONSTRAINT `fk_league_draft_pick_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_tertiary_trade_third_franchise_id` FOREIGN KEY (`tertiary_trade_third_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_transaction_window_id` FOREIGN KEY (`transaction_window_id`) REFERENCES `sports_entertainment_ecm`.`league`.`transaction_window`(`transaction_window_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ADD CONSTRAINT `fk_league_transaction_window_extended_transaction_window_id` FOREIGN KEY (`extended_transaction_window_id`) REFERENCES `sports_entertainment_ecm`.`league`.`transaction_window`(`transaction_window_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ADD CONSTRAINT `fk_league_transaction_window_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ADD CONSTRAINT `fk_league_transaction_window_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ADD CONSTRAINT `fk_league_team_conference_id` FOREIGN KEY (`conference_id`) REFERENCES `sports_entertainment_ecm`.`league`.`conference`(`conference_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ADD CONSTRAINT `fk_league_team_division_id` FOREIGN KEY (`division_id`) REFERENCES `sports_entertainment_ecm`.`league`.`division`(`division_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ADD CONSTRAINT `fk_league_team_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ADD CONSTRAINT `fk_league_team_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ADD CONSTRAINT `fk_league_team_parent_team_id` FOREIGN KEY (`parent_team_id`) REFERENCES `sports_entertainment_ecm`.`league`.`team`(`team_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ADD CONSTRAINT `fk_league_official_assignment_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ADD CONSTRAINT `fk_league_official_assignment_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);

-- ========= TAGS =========
ALTER SCHEMA `sports_entertainment_ecm`.`league` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `sports_entertainment_ecm`.`league` SET TAGS ('dbx_domain' = 'league');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` SET TAGS ('dbx_subdomain' = 'league_structure');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `acronym` SET TAGS ('dbx_business_glossary_term' = 'League Acronym');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `acronym` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `age_category` SET TAGS ('dbx_business_glossary_term' = 'Age Category');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `age_category` SET TAGS ('dbx_value_regex' = 'senior|under_23|under_21|under_18|youth|masters');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `anti_doping_body` SET TAGS ('dbx_business_glossary_term' = 'Anti-Doping Body');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `cba_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Expiry Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `cba_expiry_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `championship_name` SET TAGS ('dbx_business_glossary_term' = 'Championship Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `draft_enabled` SET TAGS ('dbx_business_glossary_term' = 'Draft Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `draft_round_count` SET TAGS ('dbx_business_glossary_term' = 'Draft Round Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `expansion_team_count` SET TAGS ('dbx_business_glossary_term' = 'Expansion Team Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `founding_year` SET TAGS ('dbx_business_glossary_term' = 'League Founding Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `games_per_team_per_season` SET TAGS ('dbx_business_glossary_term' = 'Games Per Team Per Season');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `gender_category` SET TAGS ('dbx_business_glossary_term' = 'Gender Category');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `gender_category` SET TAGS ('dbx_value_regex' = 'mens|womens|mixed|open');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `gender_category` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `gender_category` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `headquarters_city` SET TAGS ('dbx_business_glossary_term' = 'Headquarters City');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `headquarters_country_code` SET TAGS ('dbx_business_glossary_term' = 'Headquarters Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `headquarters_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `ip_owner_entity` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Owner Entity');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `ip_owner_entity` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `league_code` SET TAGS ('dbx_business_glossary_term' = 'League Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `league_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `league_status` SET TAGS ('dbx_business_glossary_term' = 'League Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `league_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|dissolved|founding');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `league_type` SET TAGS ('dbx_business_glossary_term' = 'League Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `league_type` SET TAGS ('dbx_value_regex' = 'professional|semi_professional|amateur|governing_body|developmental');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `num_conferences` SET TAGS ('dbx_business_glossary_term' = 'Number of Conferences');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `num_divisions` SET TAGS ('dbx_business_glossary_term' = 'Number of Divisions');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `num_teams` SET TAGS ('dbx_business_glossary_term' = 'Number of Teams');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `official_name` SET TAGS ('dbx_business_glossary_term' = 'Official League Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `officiating_body` SET TAGS ('dbx_business_glossary_term' = 'Officiating Body');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `ott_platform_name` SET TAGS ('dbx_business_glossary_term' = 'Over-The-Top (OTT) Platform Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `playoff_format` SET TAGS ('dbx_business_glossary_term' = 'Playoff Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `revenue_sharing_model` SET TAGS ('dbx_business_glossary_term' = 'Revenue Sharing Model');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `revenue_sharing_model` SET TAGS ('dbx_value_regex' = 'equal_share|performance_based|hybrid|none');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `revenue_sharing_model` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_enabled` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_enabled` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `salary_cap_enabled` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `season_end_month` SET TAGS ('dbx_business_glossary_term' = 'Season End Month');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `season_format` SET TAGS ('dbx_business_glossary_term' = 'Season Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `season_format` SET TAGS ('dbx_value_regex' = 'regular_season_playoff|round_robin|knockout|league_cup|mixed');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `season_start_month` SET TAGS ('dbx_business_glossary_term' = 'Season Start Month');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `social_media_handle` SET TAGS ('dbx_business_glossary_term' = 'Primary Social Media Handle');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `tax_exempt_status` SET TAGS ('dbx_business_glossary_term' = 'Tax Exempt Status Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `tax_exempt_status` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `var_enabled` SET TAGS ('dbx_business_glossary_term' = 'Video Assistant Referee (VAR) Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'League Official Website URL');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ALTER COLUMN `website_url` SET TAGS ('dbx_value_regex' = '^https?://[^s/$.?#].[^s]*$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` SET TAGS ('dbx_subdomain' = 'league_structure');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_id` SET TAGS ('dbx_business_glossary_term' = 'Conference ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `abbreviation` SET TAGS ('dbx_business_glossary_term' = 'Conference Abbreviation');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `abbreviation` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `ada_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Americans with Disabilities Act (ADA) Compliance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `broadcast_tier` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Tier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `broadcast_tier` SET TAGS ('dbx_value_regex' = 'national|regional|international|local|ott_exclusive');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `cba_applicable` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_code` SET TAGS ('dbx_business_glossary_term' = 'Conference Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_description` SET TAGS ('dbx_business_glossary_term' = 'Conference Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_name` SET TAGS ('dbx_business_glossary_term' = 'Conference Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_status` SET TAGS ('dbx_business_glossary_term' = 'Conference Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|dissolved|pending');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_type` SET TAGS ('dbx_business_glossary_term' = 'Conference Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `conference_type` SET TAGS ('dbx_value_regex' = 'conference|association|league_division|group|pool');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `division_count` SET TAGS ('dbx_business_glossary_term' = 'Division Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `founded_date` SET TAGS ('dbx_business_glossary_term' = 'Founded Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `games_per_team` SET TAGS ('dbx_business_glossary_term' = 'Games Per Team');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `geographic_alignment` SET TAGS ('dbx_business_glossary_term' = 'Geographic Alignment');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `headquarters_city` SET TAGS ('dbx_business_glossary_term' = 'Headquarters City');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `headquarters_country_code` SET TAGS ('dbx_business_glossary_term' = 'Headquarters Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `headquarters_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `is_international` SET TAGS ('dbx_business_glossary_term' = 'International Conference Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `iso_20121_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 20121 Event Sustainability Certified Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Conference Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `official_website_url` SET TAGS ('dbx_business_glossary_term' = 'Official Website URL');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `official_website_url` SET TAGS ('dbx_value_regex' = '^https?://[^s/$.?#].[^s]*$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `playoff_berth_count` SET TAGS ('dbx_business_glossary_term' = 'Playoff Berth Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `playoff_format` SET TAGS ('dbx_business_glossary_term' = 'Playoff Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `playoff_format` SET TAGS ('dbx_value_regex' = 'single_elimination|double_elimination|round_robin|seeded_bracket|wild_card');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `primary_timezone` SET TAGS ('dbx_business_glossary_term' = 'Primary Time Zone');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `region_name` SET TAGS ('dbx_business_glossary_term' = 'Region Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `salary_cap_applicable` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `salary_cap_applicable` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `salary_cap_applicable` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `schedule_format` SET TAGS ('dbx_business_glossary_term' = 'Schedule Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `schedule_format` SET TAGS ('dbx_value_regex' = 'balanced|unbalanced|interleague|round_robin|hybrid');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `season_end_year` SET TAGS ('dbx_business_glossary_term' = 'Season End Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `season_start_year` SET TAGS ('dbx_business_glossary_term' = 'Season Start Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `social_media_handle` SET TAGS ('dbx_business_glossary_term' = 'Social Media Handle');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `team_count` SET TAGS ('dbx_business_glossary_term' = 'Team Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `tiebreaker_rules_version` SET TAGS ('dbx_business_glossary_term' = 'Tiebreaker Rules Version');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `tmo_enabled` SET TAGS ('dbx_business_glossary_term' = 'Television Match Official (TMO) Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `var_enabled` SET TAGS ('dbx_business_glossary_term' = 'Video Assistant Referee (VAR) Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ALTER COLUMN `wada_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'World Anti-Doping Agency (WADA) Compliance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` SET TAGS ('dbx_subdomain' = 'league_structure');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_id` SET TAGS ('dbx_business_glossary_term' = 'Division ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `conference_id` SET TAGS ('dbx_business_glossary_term' = 'Conference ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `abbreviation` SET TAGS ('dbx_business_glossary_term' = 'Division Abbreviation');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `abbreviation` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `ada_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Americans with Disabilities Act (ADA) Compliance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `broadcast_tier` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Tier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `broadcast_tier` SET TAGS ('dbx_value_regex' = 'national|regional|local|international|ott_only');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `cba_agreement_code` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `cba_agreement_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `current_team_count` SET TAGS ('dbx_business_glossary_term' = 'Current Team Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_name` SET TAGS ('dbx_business_glossary_term' = 'Division Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_status` SET TAGS ('dbx_business_glossary_term' = 'Division Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|dissolved|pending');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_type` SET TAGS ('dbx_business_glossary_term' = 'Division Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `division_type` SET TAGS ('dbx_value_regex' = 'geographic|skill_level|age_group|gender|other');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `draft_order_method` SET TAGS ('dbx_business_glossary_term' = 'Draft Order Method');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `draft_order_method` SET TAGS ('dbx_value_regex' = 'inverse_standings|lottery|hybrid|waiver|none');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `effective_until_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `external_league_ref_code` SET TAGS ('dbx_business_glossary_term' = 'External League Reference Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `founded_date` SET TAGS ('dbx_business_glossary_term' = 'Division Founded Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `games_per_team_regular_season` SET TAGS ('dbx_business_glossary_term' = 'Games Per Team Regular Season');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `gdpr_applicable` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `geographic_region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `intra_division_games` SET TAGS ('dbx_business_glossary_term' = 'Intra-Division Games Per Team');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `max_team_count` SET TAGS ('dbx_business_glossary_term' = 'Maximum Team Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `nil_policy_applicable` SET TAGS ('dbx_business_glossary_term' = 'Name Image and Likeness (NIL) Policy Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Division Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `officiating_standard` SET TAGS ('dbx_business_glossary_term' = 'Officiating Standard');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `officiating_standard` SET TAGS ('dbx_value_regex' = 'var_enabled|tmo_enabled|standard|enhanced|none');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `playoff_qualification_spots` SET TAGS ('dbx_business_glossary_term' = 'Playoff Qualification Spots');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `primary_color_hex` SET TAGS ('dbx_business_glossary_term' = 'Division Primary Color Hex Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `primary_color_hex` SET TAGS ('dbx_value_regex' = '^#[0-9A-Fa-f]{6}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `revenue_sharing_applicable` SET TAGS ('dbx_business_glossary_term' = 'Revenue Sharing Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_applicable` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_applicable` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_applicable` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Currency');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `season_end_month` SET TAGS ('dbx_business_glossary_term' = 'Season End Month');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `season_format` SET TAGS ('dbx_business_glossary_term' = 'Season Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `season_format` SET TAGS ('dbx_value_regex' = 'round_robin|single_elimination|double_elimination|hybrid|other');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `season_start_month` SET TAGS ('dbx_business_glossary_term' = 'Season Start Month');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `tiebreaker_rule_set` SET TAGS ('dbx_business_glossary_term' = 'Tiebreaker Rule Set');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`division` ALTER COLUMN `wada_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'World Anti-Doping Agency (WADA) Compliance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` SET TAGS ('dbx_subdomain' = 'league_structure');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `division_id` SET TAGS ('dbx_business_glossary_term' = 'Division ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `venue_id` SET TAGS ('dbx_business_glossary_term' = 'Home Venue ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `abbreviation` SET TAGS ('dbx_business_glossary_term' = 'Franchise Abbreviation');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `abbreviation` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `active_roster_count` SET TAGS ('dbx_business_glossary_term' = 'Active Roster Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Effective Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_effective_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_execution_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Execution Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_execution_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Expiry Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_expiry_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_version` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Version');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `agreement_version` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `amendment_history_notes` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Amendment History Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `amendment_history_notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `competitive_integrity_flag` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `disciplinary_sanction_status` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Sanction Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `disciplinary_sanction_status` SET TAGS ('dbx_value_regex' = 'none|warning_issued|fined|draft_pick_forfeited|suspended|under_investigation');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `draft_pick_order_priority` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Order Priority');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `expansion_fee_paid` SET TAGS ('dbx_business_glossary_term' = 'Expansion Fee Paid');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `expansion_fee_paid` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `founding_year` SET TAGS ('dbx_business_glossary_term' = 'Founding Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `franchise_status` SET TAGS ('dbx_business_glossary_term' = 'Franchise Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `franchise_status` SET TAGS ('dbx_value_regex' = 'active|suspended|defunct|expansion_pending|relocated');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `injured_reserve_count` SET TAGS ('dbx_business_glossary_term' = 'Injured Reserve (IR) Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `is_cba_participant` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Participant Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `is_expansion_franchise` SET TAGS ('dbx_business_glossary_term' = 'Expansion Franchise Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `legal_name` SET TAGS ('dbx_business_glossary_term' = 'Franchise Legal Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `legal_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `market_city` SET TAGS ('dbx_business_glossary_term' = 'Market City');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `market_country_code` SET TAGS ('dbx_business_glossary_term' = 'Market Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `market_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `official_website_url` SET TAGS ('dbx_business_glossary_term' = 'Official Website URL');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `official_website_url` SET TAGS ('dbx_value_regex' = '^https?://[^s/$.?#].[^s]*$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `ownership_transfer_rules_summary` SET TAGS ('dbx_business_glossary_term' = 'Ownership Transfer Rules Summary');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `ownership_transfer_rules_summary` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `practice_squad_count` SET TAGS ('dbx_business_glossary_term' = 'Practice Squad Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `primary_jersey_color` SET TAGS ('dbx_business_glossary_term' = 'Primary Jersey Color');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `relocation_restriction_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Relocation Restriction Expiry Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `relocation_restriction_expiry_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `relocation_restriction_flag` SET TAGS ('dbx_business_glossary_term' = 'Relocation Restriction Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `relocation_restriction_flag` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `revenue_sharing_tier` SET TAGS ('dbx_business_glossary_term' = 'Revenue Sharing Tier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `revenue_sharing_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|tier_4');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `revenue_sharing_tier` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `roster_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Roster Compliance Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `roster_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|under_review|waiver_granted');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `roster_snapshot_date` SET TAGS ('dbx_business_glossary_term' = 'Roster Snapshot Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `salary_cap_allotment` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Allotment');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `salary_cap_allotment` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `social_media_handle` SET TAGS ('dbx_business_glossary_term' = 'Primary Social Media Handle');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `team_nickname` SET TAGS ('dbx_business_glossary_term' = 'Team Nickname');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `territorial_rights_description` SET TAGS ('dbx_business_glossary_term' = 'Territorial Rights Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `territorial_rights_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `valuation_estimate` SET TAGS ('dbx_business_glossary_term' = 'Franchise Valuation Estimate');
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ALTER COLUMN `valuation_estimate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Identifier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `venue_id` SET TAGS ('dbx_business_glossary_term' = 'Championship Venue ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `bye_teams` SET TAGS ('dbx_business_glossary_term' = 'Bye Teams');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `draft_date` SET TAGS ('dbx_business_glossary_term' = 'Draft Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `draft_year` SET TAGS ('dbx_business_glossary_term' = 'Draft Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Season End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `expansion_season_flag` SET TAGS ('dbx_business_glossary_term' = 'Expansion Season Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `free_agency_start_date` SET TAGS ('dbx_business_glossary_term' = 'Free Agency Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `games_per_team` SET TAGS ('dbx_business_glossary_term' = 'Games Per Team');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `home_advantage_rule` SET TAGS ('dbx_business_glossary_term' = 'Home Court/Field Advantage Rule');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `luxury_tax_threshold` SET TAGS ('dbx_business_glossary_term' = 'Luxury Tax Threshold');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `luxury_tax_threshold` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `neutral_site_championship_flag` SET TAGS ('dbx_business_glossary_term' = 'Neutral Site Championship Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Season Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `officiating_system` SET TAGS ('dbx_business_glossary_term' = 'Officiating System');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `officiating_system` SET TAGS ('dbx_value_regex' = 'VAR|TMO|standard|challenge_system|none');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `playoff_format` SET TAGS ('dbx_business_glossary_term' = 'Playoff Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `playoff_format` SET TAGS ('dbx_value_regex' = 'single_elimination|best_of_series|double_elimination|round_robin|hybrid');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `playoff_rounds` SET TAGS ('dbx_business_glossary_term' = 'Playoff Rounds');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `playoff_teams` SET TAGS ('dbx_business_glossary_term' = 'Playoff Teams');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `postseason_end_date` SET TAGS ('dbx_business_glossary_term' = 'Postseason End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `postseason_start_date` SET TAGS ('dbx_business_glossary_term' = 'Postseason Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `regular_season_end_date` SET TAGS ('dbx_business_glossary_term' = 'Regular Season End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `regular_season_start_date` SET TAGS ('dbx_business_glossary_term' = 'Regular Season Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `roster_freeze_date` SET TAGS ('dbx_business_glossary_term' = 'Roster Freeze Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Currency');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_year_flag` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Year Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_year_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `salary_cap_year_flag` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_code` SET TAGS ('dbx_business_glossary_term' = 'Season Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_name` SET TAGS ('dbx_business_glossary_term' = 'Season Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_status` SET TAGS ('dbx_business_glossary_term' = 'Season Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_status` SET TAGS ('dbx_value_regex' = 'upcoming|active|suspended|completed|cancelled');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_type` SET TAGS ('dbx_business_glossary_term' = 'Season Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `season_type` SET TAGS ('dbx_value_regex' = 'preseason|regular|postseason|allstar|exhibition');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `seeding_methodology` SET TAGS ('dbx_business_glossary_term' = 'Seeding Methodology');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `series_games_format` SET TAGS ('dbx_business_glossary_term' = 'Series Games Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `series_games_format` SET TAGS ('dbx_value_regex' = 'best_of_3|best_of_5|best_of_7|single_game|best_of_2');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `shortened_season_flag` SET TAGS ('dbx_business_glossary_term' = 'Shortened Season Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Season Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `theme` SET TAGS ('dbx_business_glossary_term' = 'Season Theme');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `trade_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Trade Deadline Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `wada_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'World Anti-Doping Agency (WADA) Compliance Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ALTER COLUMN `year` SET TAGS ('dbx_business_glossary_term' = 'Season Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `league_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Schedule ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `playoff_bracket_id` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Home Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `rescheduled_from_league_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Rescheduled From Schedule ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `venue_id` SET TAGS ('dbx_business_glossary_term' = 'Venue ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `attendance_capacity` SET TAGS ('dbx_business_glossary_term' = 'Venue Attendance Capacity');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `broadcast_network` SET TAGS ('dbx_business_glossary_term' = 'Primary Broadcast Network');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `competitive_integrity_flag` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Game Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `game_number` SET TAGS ('dbx_business_glossary_term' = 'Game Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `game_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}-[0-9]{4}-[0-9]{4,6}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `game_type` SET TAGS ('dbx_business_glossary_term' = 'Game Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `game_type` SET TAGS ('dbx_value_regex' = 'regular_season|playoff|exhibition|neutral_site|all_star|championship');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `gate_revenue_split_pct` SET TAGS ('dbx_business_glossary_term' = 'Gate Revenue Split Percentage');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `gate_revenue_split_pct` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `international_broadcast_flag` SET TAGS ('dbx_business_glossary_term' = 'International Broadcast Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `is_home_away_reversed` SET TAGS ('dbx_business_glossary_term' = 'Home Away Designation Reversed Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `is_neutral_site` SET TAGS ('dbx_business_glossary_term' = 'Neutral Site Game Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `matchday_label` SET TAGS ('dbx_business_glossary_term' = 'Matchday Label');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `original_scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Original Scheduled Game Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `original_start_time` SET TAGS ('dbx_business_glossary_term' = 'Original Scheduled Start Time');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `postponement_reason` SET TAGS ('dbx_business_glossary_term' = 'Postponement Reason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `ppv_flag` SET TAGS ('dbx_business_glossary_term' = 'Pay-Per-View (PPV) Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `published_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Schedule Published Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `round_number` SET TAGS ('dbx_business_glossary_term' = 'Competition Round Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `salary_cap_window_flag` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Window Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `salary_cap_window_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `salary_cap_window_flag` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Game Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Game Start Time');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `scheduling_status` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `scheduling_status` SET TAGS ('dbx_value_regex' = 'confirmed|postponed|cancelled|rescheduled|pending|suspended');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `season_phase` SET TAGS ('dbx_business_glossary_term' = 'Season Phase');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `season_phase` SET TAGS ('dbx_value_regex' = 'preseason|regular_season|postseason|offseason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `series_game_number` SET TAGS ('dbx_business_glossary_term' = 'Series Game Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `series_game_total` SET TAGS ('dbx_business_glossary_term' = 'Series Total Games');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'TICKETMASTER|AXS|SAP_SD|ARCHTICS|MANUAL|LEAGUE_API');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `ticket_on_sale_date` SET TAGS ('dbx_business_glossary_term' = 'Ticket On-Sale Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `timezone` SET TAGS ('dbx_business_glossary_term' = 'Game Timezone');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `timezone` SET TAGS ('dbx_value_regex' = '^[A-Za-z]+/[A-Za-z_]+$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `transaction_window_compliant` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Compliance Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `var_enabled` SET TAGS ('dbx_business_glossary_term' = 'Video Assistant Referee (VAR) Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ALTER COLUMN `week_number` SET TAGS ('dbx_business_glossary_term' = 'Season Week Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `standing_id` SET TAGS ('dbx_business_glossary_term' = 'Standing ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `conference_id` SET TAGS ('dbx_business_glossary_term' = 'Conference ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `division_id` SET TAGS ('dbx_business_glossary_term' = 'Division ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `playoff_bracket_id` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `away_losses` SET TAGS ('dbx_business_glossary_term' = 'Away Losses');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `away_ties` SET TAGS ('dbx_business_glossary_term' = 'Away Ties / Draws');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `away_wins` SET TAGS ('dbx_business_glossary_term' = 'Away Wins');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `clinch_indicator` SET TAGS ('dbx_business_glossary_term' = 'Clinch Indicator');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `clinch_indicator` SET TAGS ('dbx_value_regex' = 'x|y|z|e|w|p');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `conference_losses` SET TAGS ('dbx_business_glossary_term' = 'Conference Losses');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `conference_rank` SET TAGS ('dbx_business_glossary_term' = 'Conference Rank');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `conference_wins` SET TAGS ('dbx_business_glossary_term' = 'Conference Wins');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `current_streak_count` SET TAGS ('dbx_business_glossary_term' = 'Current Streak Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `current_streak_type` SET TAGS ('dbx_business_glossary_term' = 'Current Streak Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `current_streak_type` SET TAGS ('dbx_value_regex' = 'W|L|T|D');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `division_losses` SET TAGS ('dbx_business_glossary_term' = 'Division Losses');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `division_rank` SET TAGS ('dbx_business_glossary_term' = 'Division Rank');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `division_wins` SET TAGS ('dbx_business_glossary_term' = 'Division Wins');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `elimination_number` SET TAGS ('dbx_business_glossary_term' = 'Elimination Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `games_behind` SET TAGS ('dbx_business_glossary_term' = 'Games Behind Leader (GB)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `games_played` SET TAGS ('dbx_business_glossary_term' = 'Games Played');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `home_losses` SET TAGS ('dbx_business_glossary_term' = 'Home Losses');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `home_ties` SET TAGS ('dbx_business_glossary_term' = 'Home Ties / Draws');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `home_wins` SET TAGS ('dbx_business_glossary_term' = 'Home Wins');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `last10_losses` SET TAGS ('dbx_business_glossary_term' = 'Last 10 Games Losses');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `last10_wins` SET TAGS ('dbx_business_glossary_term' = 'Last 10 Games Wins');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `league_rank` SET TAGS ('dbx_business_glossary_term' = 'League Rank');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `losses` SET TAGS ('dbx_business_glossary_term' = 'Losses');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `magic_number` SET TAGS ('dbx_business_glossary_term' = 'Magic Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `overtime_losses` SET TAGS ('dbx_business_glossary_term' = 'Overtime Losses (OTL)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `playoff_seed` SET TAGS ('dbx_business_glossary_term' = 'Playoff Seed');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `points` SET TAGS ('dbx_business_glossary_term' = 'Standings Points');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `run_differential` SET TAGS ('dbx_business_glossary_term' = 'Run / Goal / Point Differential');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `runs_allowed` SET TAGS ('dbx_business_glossary_term' = 'Runs / Goals / Points Allowed');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `runs_scored` SET TAGS ('dbx_business_glossary_term' = 'Runs / Goals / Points Scored');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `snapshot_date` SET TAGS ('dbx_business_glossary_term' = 'Standings Snapshot Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `standing_status` SET TAGS ('dbx_business_glossary_term' = 'Standing Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `standing_status` SET TAGS ('dbx_value_regex' = 'active|clinched|eliminated|pending|final');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `standings_type` SET TAGS ('dbx_business_glossary_term' = 'Standings Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `standings_type` SET TAGS ('dbx_value_regex' = 'regular_season|postseason|preseason|tournament|group_stage|playoff');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `strength_of_schedule` SET TAGS ('dbx_business_glossary_term' = 'Strength of Schedule (SOS)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `ties` SET TAGS ('dbx_business_glossary_term' = 'Ties / Draws');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `wild_card_rank` SET TAGS ('dbx_business_glossary_term' = 'Wild Card Rank');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `win_pct` SET TAGS ('dbx_business_glossary_term' = 'Winning Percentage (Win Pct)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`standing` ALTER COLUMN `wins` SET TAGS ('dbx_business_glossary_term' = 'Wins');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `playoff_bracket_id` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `venue_id` SET TAGS ('dbx_business_glossary_term' = 'Championship Venue ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `athlete_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Most Valuable Player (MVP) Athlete ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `media_rights_deal_id` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Rights Package ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Champion Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `ada_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Americans with Disabilities Act (ADA) Compliance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_code` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_end_date` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_name` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_notes` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_region` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Region');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_start_date` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_status` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_status` SET TAGS ('dbx_value_regex' = 'draft|published|in_progress|completed|cancelled');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_type` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bracket_type` SET TAGS ('dbx_value_regex' = 'single_elimination|double_elimination|best_of_series|round_robin|seeded_bracket');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `bye_rounds_count` SET TAGS ('dbx_business_glossary_term' = 'Bye Rounds Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `championship_game_name` SET TAGS ('dbx_business_glossary_term' = 'Championship Game Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `conference_division_scope` SET TAGS ('dbx_business_glossary_term' = 'Conference/Division Scope');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `conference_division_scope` SET TAGS ('dbx_value_regex' = 'full_league|conference|division|wild_card|inter_conference');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `current_round` SET TAGS ('dbx_business_glossary_term' = 'Current Playoff Round');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `disciplinary_review_body` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Review Body');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `governing_body_code` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `home_advantage_rule` SET TAGS ('dbx_business_glossary_term' = 'Home Court/Field Advantage Rule');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `home_advantage_rule` SET TAGS ('dbx_value_regex' = 'higher_seed|predetermined|neutral_site|alternating');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `iso_20121_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 20121 Event Sustainability Certified Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `neutral_site_final` SET TAGS ('dbx_business_glossary_term' = 'Neutral Site Final Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `ppv_applicable` SET TAGS ('dbx_business_glossary_term' = 'Pay-Per-View (PPV) Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `published_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Bracket Published Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `reseeding_rule` SET TAGS ('dbx_business_glossary_term' = 'Reseeding Rule');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `reseeding_rule` SET TAGS ('dbx_value_regex' = 'fixed_bracket|reseed_each_round|conference_reseed|no_reseed');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `salary_cap_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Compliance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `salary_cap_compliance_required` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `salary_cap_compliance_required` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `season_year` SET TAGS ('dbx_business_glossary_term' = 'Season Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `seeding_methodology` SET TAGS ('dbx_business_glossary_term' = 'Seeding Methodology');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `seeding_methodology` SET TAGS ('dbx_value_regex' = 'win_loss_record|points_percentage|division_winner_priority|wild_card_ranking|strength_of_schedule');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `series_games_per_round` SET TAGS ('dbx_business_glossary_term' = 'Series Games Per Round');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|TICKETMASTER|ARCHTICS|MANUAL|LEAGUE_OPS');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `ticket_sales_open_date` SET TAGS ('dbx_business_glossary_term' = 'Playoff Ticket Sales Open Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `tiebreaker_rule` SET TAGS ('dbx_business_glossary_term' = 'Tiebreaker Rule');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `total_rounds` SET TAGS ('dbx_business_glossary_term' = 'Total Playoff Rounds');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `total_teams` SET TAGS ('dbx_business_glossary_term' = 'Total Playoff Teams');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `var_tmo_enabled` SET TAGS ('dbx_business_glossary_term' = 'Video Assistant Referee/Television Match Official (VAR/TMO) Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ALTER COLUMN `wada_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'World Anti-Doping Agency (WADA) Compliance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `game_result_id` SET TAGS ('dbx_business_glossary_term' = 'Game Result ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Winning Team ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `broadcast_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Schedule Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `competition_round_id` SET TAGS ('dbx_business_glossary_term' = 'Competition Round Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Fixture ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `playoff_bracket_id` SET TAGS ('dbx_business_glossary_term' = 'Playoff Bracket Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `primary_game_franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Home Team ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `quaternary_game_losing_team_franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Losing Team ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `quinary_game_protest_filing_team_franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Protest Filing Team ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `tertiary_game_franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Home Team ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `tertiary_game_winning_team_franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Winning Team ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `tertiary_quinary_game_protest_filing_team_franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Protest Filing Team ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `venue_id` SET TAGS ('dbx_business_glossary_term' = 'Venue ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `away_score_regulation` SET TAGS ('dbx_business_glossary_term' = 'Away Team Regulation Score');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `away_team_score` SET TAGS ('dbx_business_glossary_term' = 'Away Team Final Score');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `certification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Result Certification Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `certified_by` SET TAGS ('dbx_business_glossary_term' = 'Certified By');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `competition_phase` SET TAGS ('dbx_business_glossary_term' = 'Competition Phase');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `competition_phase` SET TAGS ('dbx_value_regex' = 'regular_season|playoffs|preseason|finals|all_star|exhibition');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `competitive_integrity_flag` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `disciplinary_action_flag` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `forfeit_reason` SET TAGS ('dbx_business_glossary_term' = 'Forfeit Reason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `game_date` SET TAGS ('dbx_business_glossary_term' = 'Game Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `game_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Game End Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `game_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Game Start Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `home_score_regulation` SET TAGS ('dbx_business_glossary_term' = 'Home Team Regulation Score');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `home_team_score` SET TAGS ('dbx_business_glossary_term' = 'Home Team Final Score');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `is_draw` SET TAGS ('dbx_business_glossary_term' = 'Draw Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `is_neutral_site` SET TAGS ('dbx_business_glossary_term' = 'Neutral Site Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `official_attendance` SET TAGS ('dbx_business_glossary_term' = 'Official Attendance');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `overtime_periods_played` SET TAGS ('dbx_business_glossary_term' = 'Overtime Periods Played');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `protest_flag` SET TAGS ('dbx_business_glossary_term' = 'Protest Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `protest_reason` SET TAGS ('dbx_business_glossary_term' = 'Protest Reason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `result_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Result Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `result_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `result_status` SET TAGS ('dbx_business_glossary_term' = 'Result Certification Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `result_status` SET TAGS ('dbx_value_regex' = 'certified|provisional|under_review|protested|voided');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `result_type` SET TAGS ('dbx_business_glossary_term' = 'Result Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `result_type` SET TAGS ('dbx_value_regex' = 'regulation|overtime|shootout|forfeit|no_contest');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'SPORTSCODE|HUDL|MANUAL|STATSPERFORM|OPTA');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature (Celsius)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `tmo_intervention_flag` SET TAGS ('dbx_business_glossary_term' = 'Television Match Official (TMO) Intervention Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `var_intervention_flag` SET TAGS ('dbx_business_glossary_term' = 'Video Assistant Referee (VAR) Intervention Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `venue_capacity` SET TAGS ('dbx_business_glossary_term' = 'Venue Capacity');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ALTER COLUMN `wind_speed_kmh` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (km/h)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `official_id` SET TAGS ('dbx_business_glossary_term' = 'Official ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `background_check_date` SET TAGS ('dbx_business_glossary_term' = 'Background Check Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `background_check_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `badge_number` SET TAGS ('dbx_business_glossary_term' = 'Official Badge Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `badge_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[0-9]{4,8}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `certification_tier` SET TAGS ('dbx_business_glossary_term' = 'Certification Tier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `certification_tier` SET TAGS ('dbx_value_regex' = 'elite|senior|intermediate|entry|trainee');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'full_time|part_time|seasonal|freelance|developmental');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Date of Birth');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `disciplinary_flag` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `disciplinary_flag` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Official Email Address');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `external_code` SET TAGS ('dbx_business_glossary_term' = 'External System ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Official First Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Official Full Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `games_officiated_career` SET TAGS ('dbx_business_glossary_term' = 'Career Games Officiated');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `games_officiated_season` SET TAGS ('dbx_business_glossary_term' = 'Games Officiated Current Season');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `geographic_region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Assignment Region');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `home_country_code` SET TAGS ('dbx_business_glossary_term' = 'Home Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `home_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `integrity_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Integrity Clearance Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `integrity_clearance_status` SET TAGS ('dbx_value_regex' = 'cleared|under_review|suspended|revoked');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `integrity_clearance_status` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `international_eligible` SET TAGS ('dbx_business_glossary_term' = 'International Assignment Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `language_codes` SET TAGS ('dbx_business_glossary_term' = 'Language Codes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Official Last Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `nationality_code` SET TAGS ('dbx_business_glossary_term' = 'Nationality Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `nationality_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `nationality_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `nationality_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `official_status` SET TAGS ('dbx_business_glossary_term' = 'Official Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `official_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|retired|probation');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Official Performance Rating');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `performance_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `performance_rating_season` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating Season');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `performance_rating_season` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Official Phone Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `phone_number` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `playoff_eligible` SET TAGS ('dbx_business_glossary_term' = 'Playoff Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `primary_position` SET TAGS ('dbx_business_glossary_term' = 'Primary Officiating Position');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `professional_debut_date` SET TAGS ('dbx_business_glossary_term' = 'Professional Debut Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `retirement_date` SET TAGS ('dbx_business_glossary_term' = 'Retirement Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `role_type` SET TAGS ('dbx_business_glossary_term' = 'Official Role Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'SAP_SUCCESSFACTORS|SALESFORCE_CRM|MANUAL|LEAGUE_PORTAL|OTHER');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `sport_code` SET TAGS ('dbx_business_glossary_term' = 'Sport Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `tmo_certified` SET TAGS ('dbx_business_glossary_term' = 'TMO (Television Match Official) Certified');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `uniform_number` SET TAGS ('dbx_business_glossary_term' = 'Official Uniform Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `uniform_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `var_certified` SET TAGS ('dbx_business_glossary_term' = 'VAR (Video Assistant Referee) Certified');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ALTER COLUMN `years_of_experience` SET TAGS ('dbx_business_glossary_term' = 'Years of Officiating Experience');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `disciplinary_action_id` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `athlete_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Athlete Profile Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `doping_violation_id` SET TAGS ('dbx_business_glossary_term' = 'Doping Violation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `ejection_record_id` SET TAGS ('dbx_business_glossary_term' = 'Ejection Record Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fixture_id` SET TAGS ('dbx_business_glossary_term' = 'Game ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `game_result_id` SET TAGS ('dbx_business_glossary_term' = 'Game Result Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `investigation_id` SET TAGS ('dbx_business_glossary_term' = 'Investigation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `policy_id` SET TAGS ('dbx_business_glossary_term' = 'Policy Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `action_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `action_status` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `appeal_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Appeal Deadline Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `appeal_eligible` SET TAGS ('dbx_business_glossary_term' = 'Appeal Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `appeal_filed_date` SET TAGS ('dbx_business_glossary_term' = 'Appeal Filed Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `appeal_ruling_date` SET TAGS ('dbx_business_glossary_term' = 'Appeal Ruling Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `appeal_status` SET TAGS ('dbx_business_glossary_term' = 'Appeal Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `cba_article_reference` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Article Reference');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `draft_pick_loss_round` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Loss Round');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `draft_pick_loss_year` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Loss Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `final_ruling_description` SET TAGS ('dbx_business_glossary_term' = 'Final Ruling Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fine_amount` SET TAGS ('dbx_business_glossary_term' = 'Fine Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fine_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fine_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Fine Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fine_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fine_paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Fine Paid Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fine_paid_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `fine_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Fine Payment Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `incident_date` SET TAGS ('dbx_business_glossary_term' = 'Incident Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `incident_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `infraction_category` SET TAGS ('dbx_business_glossary_term' = 'Infraction Category');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `infraction_description` SET TAGS ('dbx_business_glossary_term' = 'Infraction Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `infraction_type` SET TAGS ('dbx_business_glossary_term' = 'Infraction Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `infraction_type` SET TAGS ('dbx_value_regex' = 'suspension|fine|ejection|probation|draft_pick_loss|warning');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `is_game_integrity_related` SET TAGS ('dbx_business_glossary_term' = 'Game Integrity Related Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `is_ped_related` SET TAGS ('dbx_business_glossary_term' = 'Performance Enhancing Drug (PED) Related Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `is_publicly_disclosed` SET TAGS ('dbx_business_glossary_term' = 'Publicly Disclosed Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `prior_offense_count` SET TAGS ('dbx_business_glossary_term' = 'Prior Offense Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `public_announcement_date` SET TAGS ('dbx_business_glossary_term' = 'Public Announcement Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `repeat_offender` SET TAGS ('dbx_business_glossary_term' = 'Repeat Offender Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `rule_code_violated` SET TAGS ('dbx_business_glossary_term' = 'Rule Code Violated');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `ruling_date` SET TAGS ('dbx_business_glossary_term' = 'Ruling Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `subject_entity_type` SET TAGS ('dbx_business_glossary_term' = 'Subject Entity Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `subject_entity_type` SET TAGS ('dbx_value_regex' = 'player|coach|franchise|official|staff');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `suspension_end_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `suspension_games` SET TAGS ('dbx_business_glossary_term' = 'Suspension Length in Games');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `suspension_start_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Start Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `suspension_with_pay` SET TAGS ('dbx_business_glossary_term' = 'Suspension With Pay Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `suspension_with_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ALTER COLUMN `var_tmo_reviewed` SET TAGS ('dbx_business_glossary_term' = 'Video Assistant Referee / Television Match Official (VAR/TMO) Reviewed Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` SET TAGS ('dbx_subdomain' = 'roster_transactions');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `salary_cap_id` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `salary_cap_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `salary_cap_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `media_rights_deal_id` SET TAGS ('dbx_business_glossary_term' = 'Media Rights Deal Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Obligation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `active_payroll_amount` SET TAGS ('dbx_business_glossary_term' = 'Active Payroll Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `active_payroll_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `announcement_date` SET TAGS ('dbx_business_glossary_term' = 'Cap Announcement Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `apron_amount` SET TAGS ('dbx_business_glossary_term' = 'Second Apron Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `apron_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `bi_annual_exception_amount` SET TAGS ('dbx_business_glossary_term' = 'Bi-Annual Exception (BAE) Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `bi_annual_exception_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_calculation_methodology` SET TAGS ('dbx_business_glossary_term' = 'Cap Calculation Methodology');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Cap Effective Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_exception_notes` SET TAGS ('dbx_business_glossary_term' = 'Cap Exception Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Cap Expiry Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_floor_amount` SET TAGS ('dbx_business_glossary_term' = 'Cap Floor Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_floor_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_holds_amount` SET TAGS ('dbx_business_glossary_term' = 'Cap Holds Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_holds_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_space_remaining` SET TAGS ('dbx_business_glossary_term' = 'Cap Space Remaining');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_space_remaining` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_type` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_type` SET TAGS ('dbx_value_regex' = 'hard_cap|soft_cap|luxury_tax|no_cap');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cap_year` SET TAGS ('dbx_business_glossary_term' = 'Cap Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `cba_version` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Version');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Cap Compliance Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|warning|violation|under_review');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `dead_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Dead Cap Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `dead_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `draft_pick_penalty_flag` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Penalty Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `escrow_percentage` SET TAGS ('dbx_business_glossary_term' = 'Escrow Percentage');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `escrow_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `first_apron_amount` SET TAGS ('dbx_business_glossary_term' = 'First Apron Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `first_apron_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `franchise_tag_amount` SET TAGS ('dbx_business_glossary_term' = 'Franchise Tag Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `franchise_tag_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `hard_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Hard Cap Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `hard_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `injured_reserve_credit` SET TAGS ('dbx_business_glossary_term' = 'Injured Reserve (IR) Credit');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `injured_reserve_credit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `last_transaction_date` SET TAGS ('dbx_business_glossary_term' = 'Last Roster Transaction Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `luxury_tax_liability` SET TAGS ('dbx_business_glossary_term' = 'Luxury Tax Liability');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `luxury_tax_liability` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `luxury_tax_repeater_flag` SET TAGS ('dbx_business_glossary_term' = 'Luxury Tax Repeater Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `luxury_tax_threshold` SET TAGS ('dbx_business_glossary_term' = 'Luxury Tax Threshold');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `luxury_tax_threshold` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `mid_level_exception_amount` SET TAGS ('dbx_business_glossary_term' = 'Mid-Level Exception (MLE) Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `mid_level_exception_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_business_glossary_term' = 'Cap Penalty Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `player_share_percentage` SET TAGS ('dbx_business_glossary_term' = 'Player Share Percentage');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `player_share_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `practice_squad_charges` SET TAGS ('dbx_business_glossary_term' = 'Practice Squad Cap Charges');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `practice_squad_charges` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `record_type` SET TAGS ('dbx_business_glossary_term' = 'Record Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `record_type` SET TAGS ('dbx_value_regex' = 'league_definition|franchise_snapshot');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `snapshot_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Compliance Snapshot Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `soft_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Soft Cap Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `soft_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `total_league_revenue_basis` SET TAGS ('dbx_business_glossary_term' = 'Total League Revenue Basis');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `total_league_revenue_basis` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ALTER COLUMN `violation_description` SET TAGS ('dbx_business_glossary_term' = 'Cap Violation Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` SET TAGS ('dbx_subdomain' = 'roster_transactions');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `draft_id` SET TAGS ('dbx_business_glossary_term' = 'Draft ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `broadcast_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Broadcast Schedule Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `governing_body_id` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `venue_id` SET TAGS ('dbx_business_glossary_term' = 'Venue ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `actual_attendance` SET TAGS ('dbx_business_glossary_term' = 'Actual Fan Attendance');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `cba_version` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Version');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `compensatory_picks_authorized` SET TAGS ('dbx_business_glossary_term' = 'Compensatory Picks Authorized Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `draft_code` SET TAGS ('dbx_business_glossary_term' = 'Draft Event Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `draft_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}-DRAFT-[0-9]{4}(-[A-Z0-9]+)?$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `draft_date` SET TAGS ('dbx_business_glossary_term' = 'Draft Event Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `draft_name` SET TAGS ('dbx_business_glossary_term' = 'Draft Event Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `draft_status` SET TAGS ('dbx_business_glossary_term' = 'Draft Event Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `draft_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|postponed');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `eligibility_class` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Class');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `eligibility_class` SET TAGS ('dbx_value_regex' = 'college|international|supplemental|developmental|undrafted_free_agent');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Draft Event End Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `expected_attendance` SET TAGS ('dbx_business_glossary_term' = 'Expected Fan Attendance');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `fan_attendance_allowed` SET TAGS ('dbx_business_glossary_term' = 'Fan Attendance Allowed Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `forfeited_picks` SET TAGS ('dbx_business_glossary_term' = 'Forfeited Picks Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `format` SET TAGS ('dbx_business_glossary_term' = 'Draft Format');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `format` SET TAGS ('dbx_value_regex' = 'live|virtual|hybrid');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `gdpr_applicable` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Applicable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `host_city` SET TAGS ('dbx_business_glossary_term' = 'Draft Host City');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `host_country_code` SET TAGS ('dbx_business_glossary_term' = 'Host Country Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `host_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `integrity_review_notes` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Review Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `integrity_review_notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `integrity_review_required` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Review Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `lottery_conducted` SET TAGS ('dbx_business_glossary_term' = 'Draft Lottery Conducted Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `lottery_date` SET TAGS ('dbx_business_glossary_term' = 'Draft Lottery Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Draft Event Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `order_method` SET TAGS ('dbx_business_glossary_term' = 'Draft Order Determination Method');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `order_method` SET TAGS ('dbx_value_regex' = 'lottery|inverse_standings|coin_flip|predetermined|compensatory');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `ott_streaming_enabled` SET TAGS ('dbx_business_glossary_term' = 'Over-The-Top (OTT) Streaming Enabled Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `pick_clock_seconds` SET TAGS ('dbx_business_glossary_term' = 'Pick Clock Duration (Seconds)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `picks_completed` SET TAGS ('dbx_business_glossary_term' = 'Picks Completed Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `salary_cap_year` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `salary_cap_year` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `salary_cap_year` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `sport` SET TAGS ('dbx_business_glossary_term' = 'Sport Discipline');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `sport` SET TAGS ('dbx_value_regex' = 'football|basketball|baseball|hockey|soccer|other');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Draft Start Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `supplemental_draft` SET TAGS ('dbx_business_glossary_term' = 'Supplemental Draft Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `total_picks` SET TAGS ('dbx_business_glossary_term' = 'Total Draft Picks');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `total_rounds` SET TAGS ('dbx_business_glossary_term' = 'Total Draft Rounds');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `trades_executed` SET TAGS ('dbx_business_glossary_term' = 'Draft Trades Executed Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `wada_compliance_confirmed` SET TAGS ('dbx_business_glossary_term' = 'World Anti-Doping Agency (WADA) Compliance Confirmed Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ALTER COLUMN `year` SET TAGS ('dbx_business_glossary_term' = 'Draft Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` SET TAGS ('dbx_subdomain' = 'roster_transactions');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `draft_pick_id` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `draft_id` SET TAGS ('dbx_business_glossary_term' = 'Draft Event ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `trade_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Last Trade Transaction ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `athlete_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Selected Athlete ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Current Owner Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `cba_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Compliance Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `cba_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|under_review|violation|waived');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `competitive_integrity_flag` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `condition_description` SET TAGS ('dbx_business_glossary_term' = 'Conditional Pick Condition Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `draft_position_tier` SET TAGS ('dbx_business_glossary_term' = 'Draft Position Tier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `draft_position_tier` SET TAGS ('dbx_value_regex' = 'lottery|top_10|first_round|second_round|later_round');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `draft_year` SET TAGS ('dbx_business_glossary_term' = 'Draft Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `exercise_date` SET TAGS ('dbx_business_glossary_term' = 'Pick Exercise Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `exercise_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pick Exercise Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `external_ref` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick External Reference Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `forfeiture_reason` SET TAGS ('dbx_business_glossary_term' = 'Pick Forfeiture Reason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `forfeiture_ruling_date` SET TAGS ('dbx_business_glossary_term' = 'Pick Forfeiture Ruling Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `is_compensatory_pick` SET TAGS ('dbx_business_glossary_term' = 'Compensatory Pick Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `is_conditional` SET TAGS ('dbx_business_glossary_term' = 'Conditional Pick Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `is_lottery_eligible` SET TAGS ('dbx_business_glossary_term' = 'Lottery Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `is_tradeable` SET TAGS ('dbx_business_glossary_term' = 'Tradeable Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `last_trade_date` SET TAGS ('dbx_business_glossary_term' = 'Last Trade Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_announcement_name` SET TAGS ('dbx_business_glossary_term' = 'Pick Announcement Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_clock_seconds_remaining` SET TAGS ('dbx_business_glossary_term' = 'Pick Clock Seconds Remaining');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_number` SET TAGS ('dbx_business_glossary_term' = 'Overall Pick Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_source_league_rule` SET TAGS ('dbx_business_glossary_term' = 'Pick Source League Rule Reference');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_status` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_status` SET TAGS ('dbx_value_regex' = 'available|traded|exercised|forfeited|voided');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_type` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_type` SET TAGS ('dbx_value_regex' = 'standard|compensatory|supplemental|expansion|traded');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_valuation_score` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick Valuation Score');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `pick_within_round` SET TAGS ('dbx_business_glossary_term' = 'Pick Number Within Round');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `protection_level` SET TAGS ('dbx_business_glossary_term' = 'Pick Protection Level (Top-N)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `protection_rollover_year_limit` SET TAGS ('dbx_business_glossary_term' = 'Protection Rollover Year Limit');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `round_number` SET TAGS ('dbx_business_glossary_term' = 'Draft Round Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Currency Code (ISO 4217)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `salary_cap_currency_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `salary_cap_slot_value` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap (CBA) Slot Value');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `salary_cap_slot_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `trade_count` SET TAGS ('dbx_business_glossary_term' = 'Trade Count');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `trade_history` SET TAGS ('dbx_business_glossary_term' = 'Trade History Chain Summary');
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` SET TAGS ('dbx_subdomain' = 'roster_transactions');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `trade_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Transaction Identifier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Athlete Contract Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `investigation_id` SET TAGS ('dbx_business_glossary_term' = 'Investigation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Acquiring Franchise ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `athlete_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Athlete ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `tertiary_trade_third_franchise_id` SET TAGS ('dbx_business_glossary_term' = 'Third Franchise ID (Three-Way Trade)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_window_id` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'League Approval Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `cash_consideration_amount` SET TAGS ('dbx_business_glossary_term' = 'Cash Consideration Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `cash_consideration_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `cash_consideration_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Cash Consideration Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `cash_consideration_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `cba_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Compliance Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `cba_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|under_review|waived');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Clearing Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `competitive_integrity_review_flag` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Review Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `condition_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Condition Resolution Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `conditional_terms_description` SET TAGS ('dbx_business_glossary_term' = 'Conditional Trade Terms Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `draft_pick_id` SET TAGS ('dbx_business_glossary_term' = 'Draft Pick ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Transaction Effective Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `no_trade_clause_waived` SET TAGS ('dbx_business_glossary_term' = 'No-Trade Clause Waived Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `no_trade_clause_waiver_date` SET TAGS ('dbx_business_glossary_term' = 'No-Trade Clause Waiver Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Transaction Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `physical_exam_required` SET TAGS ('dbx_business_glossary_term' = 'Physical Examination Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `physical_exam_status` SET TAGS ('dbx_business_glossary_term' = 'Physical Examination Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `physical_exam_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|passed|failed|waived');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Transaction Rejection Reason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_cap_impact_acquiring` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Impact — Acquiring Franchise');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_cap_impact_acquiring` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_cap_impact_trading` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Impact — Trading Franchise');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_cap_impact_trading` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_obligation_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Salary Obligation Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_obligation_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_obligation_currency_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_obligation_currency_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_obligation_transferred_amount` SET TAGS ('dbx_business_glossary_term' = 'Salary Obligation Transferred Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `salary_obligation_transferred_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `source_system_transaction_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Transaction ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `trade_deadline_exception_flag` SET TAGS ('dbx_business_glossary_term' = 'Trade Deadline Exception Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_date` SET TAGS ('dbx_business_glossary_term' = 'Transaction Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Transaction Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}-TXN-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_value_regex' = 'pending_approval|approved|rejected|voided|conditional_pending|rescinded');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Transaction Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Transaction Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'trade|waiver_claim|waiver_placement|dfa_assignment|conditional_trade|three_way_trade');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `transaction_window_compliant` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Compliance Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `void_date` SET TAGS ('dbx_business_glossary_term' = 'Transaction Void Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `void_reason` SET TAGS ('dbx_business_glossary_term' = 'Transaction Void Reason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `waiver_claim_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Waiver Claim Fee Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `waiver_claim_fee_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ALTER COLUMN `waiver_priority_order` SET TAGS ('dbx_business_glossary_term' = 'Waiver Priority Order');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` SET TAGS ('dbx_subdomain' = 'roster_transactions');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `transaction_window_id` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `extended_transaction_window_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `league_id` SET TAGS ('dbx_business_glossary_term' = 'League ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Obligation Id (Foreign Key)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season ID');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `announcement_date` SET TAGS ('dbx_business_glossary_term' = 'Window Announcement Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `approval_turnaround_hours` SET TAGS ('dbx_business_glossary_term' = 'Approval Turnaround Hours');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `cap_year` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Year');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `cba_article_reference` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Article Reference');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Window Close Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `close_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Window Close Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `competitive_integrity_review_required` SET TAGS ('dbx_business_glossary_term' = 'Competitive Integrity Review Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `eligible_transaction_types` SET TAGS ('dbx_business_glossary_term' = 'Eligible Transaction Types');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `franchise_participation_scope` SET TAGS ('dbx_business_glossary_term' = 'Franchise Participation Scope');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `franchise_participation_scope` SET TAGS ('dbx_value_regex' = 'all_franchises|conference_specific|division_specific|selected_franchises');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `governing_body_code` SET TAGS ('dbx_business_glossary_term' = 'Governing Body Code');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `international_transfer_rules_apply` SET TAGS ('dbx_business_glossary_term' = 'International Transfer Rules Apply Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `is_free_agency_eligible` SET TAGS ('dbx_business_glossary_term' = 'Free Agency Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `is_international_signing_eligible` SET TAGS ('dbx_business_glossary_term' = 'International Signing Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `is_trade_eligible` SET TAGS ('dbx_business_glossary_term' = 'Trade Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `is_waiver_eligible` SET TAGS ('dbx_business_glossary_term' = 'Waiver Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `league_approval_required` SET TAGS ('dbx_business_glossary_term' = 'League Approval Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `max_cash_consideration_usd` SET TAGS ('dbx_business_glossary_term' = 'Maximum Cash Consideration (USD)');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `max_cash_consideration_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `max_transactions_per_franchise` SET TAGS ('dbx_business_glossary_term' = 'Maximum Transactions Per Franchise');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Window Open Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `open_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Window Open Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `penalty_description` SET TAGS ('dbx_business_glossary_term' = 'Penalty Provision Description');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `penalty_draft_pick_loss` SET TAGS ('dbx_business_glossary_term' = 'Penalty Draft Pick Loss Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `penalty_fine_amount` SET TAGS ('dbx_business_glossary_term' = 'Penalty Fine Amount');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `penalty_fine_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `penalty_suspension_eligible` SET TAGS ('dbx_business_glossary_term' = 'Penalty Suspension Eligible Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `physical_exam_required` SET TAGS ('dbx_business_glossary_term' = 'Physical Examination Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `roster_freeze_applies` SET TAGS ('dbx_business_glossary_term' = 'Roster Freeze Applies Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `salary_cap_applies` SET TAGS ('dbx_business_glossary_term' = 'Salary Cap Applies Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `salary_cap_applies` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `salary_cap_applies` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `season_phase` SET TAGS ('dbx_business_glossary_term' = 'Season Phase');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `season_phase` SET TAGS ('dbx_value_regex' = 'preseason|regular_season|postseason|offseason');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `sport_type` SET TAGS ('dbx_business_glossary_term' = 'Sport Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `wada_clearance_required` SET TAGS ('dbx_business_glossary_term' = 'World Anti-Doping Agency (WADA) Clearance Required Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_name` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Name');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_notes` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Notes');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Reference Number');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}-TW-[0-9]{4}-[A-Z0-9]{4,12}$');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Status');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_status` SET TAGS ('dbx_value_regex' = 'scheduled|open|closed|suspended|cancelled');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_type` SET TAGS ('dbx_business_glossary_term' = 'Transaction Window Type');
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ALTER COLUMN `window_type` SET TAGS ('dbx_value_regex' = 'trade_deadline|free_agency|waiver_period|dfa_window|international_signing');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` SET TAGS ('dbx_subdomain' = 'league_structure');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ALTER COLUMN `team_id` SET TAGS ('dbx_business_glossary_term' = 'Team Identifier');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ALTER COLUMN `parent_team_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ALTER COLUMN `market_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ALTER COLUMN `salary_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ALTER COLUMN `salary_cap_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` SET TAGS ('dbx_subdomain' = 'competitive_operations');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` SET TAGS ('dbx_association_edges' = 'league.official,league.game_result');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `official_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Official Assignment - Official Assignment Id');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `game_result_id` SET TAGS ('dbx_business_glossary_term' = 'Official Assignment - Game Result Id');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `official_id` SET TAGS ('dbx_business_glossary_term' = 'Official Assignment - Official Id');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `assignment_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Date');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `conflict_of_interest_flag` SET TAGS ('dbx_business_glossary_term' = 'Conflict of Interest Flag');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `crew_role` SET TAGS ('dbx_business_glossary_term' = 'Crew Role');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `performance_score` SET TAGS ('dbx_business_glossary_term' = 'Per-Game Performance Score');
ALTER TABLE `sports_entertainment_ecm`.`league`.`official_assignment` ALTER COLUMN `var_tmo_intervened` SET TAGS ('dbx_business_glossary_term' = 'VAR/TMO Intervention Flag');
