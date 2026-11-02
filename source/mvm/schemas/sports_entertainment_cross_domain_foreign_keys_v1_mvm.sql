-- Cross-Domain Foreign Keys for Business: Sports Entertainment | Version: v1_mvm
-- Generated on: 2026-05-09 04:52:12
-- Total cross-domain FK constraints: 1477
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: athlete, broadcast, compliance, content, event, fan, finance, gaming, league, merchandise, security, sponsorship, ticketing, venue

-- ========= athlete --> compliance (18 constraint(s)) =========
-- Requires: athlete schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_eligibility_certification_id` FOREIGN KEY (`eligibility_certification_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`eligibility_certification`(`eligibility_certification_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_eligibility_certification_id` FOREIGN KEY (`eligibility_certification_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`eligibility_certification`(`eligibility_certification_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`eligibility_status` ADD CONSTRAINT `fk_athlete_eligibility_status_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`agent_relationship` ADD CONSTRAINT `fk_athlete_agent_relationship_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`agent_relationship` ADD CONSTRAINT `fk_athlete_agent_relationship_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_doping_violation_id` FOREIGN KEY (`doping_violation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`doping_violation`(`doping_violation_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`free_agency_status` ADD CONSTRAINT `fk_athlete_free_agency_status_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`agent` ADD CONSTRAINT `fk_athlete_agent_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`agency` ADD CONSTRAINT `fk_athlete_agency_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);

-- ========= athlete --> content (4 constraint(s)) =========
-- Requires: athlete schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= athlete --> event (4 constraint(s)) =========
-- Requires: athlete schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`performance_stat` ADD CONSTRAINT `fk_athlete_performance_stat_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`performance_stat` ADD CONSTRAINT `fk_athlete_performance_stat_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);

-- ========= athlete --> finance (17 constraint(s)) =========
-- Requires: athlete schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_ledger_id` FOREIGN KEY (`ledger_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`ledger`(`ledger_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);

-- ========= athlete --> league (47 constraint(s)) =========
-- Requires: athlete schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_roster_franchise_id` FOREIGN KEY (`roster_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_roster_loaned_from_team_franchise_id` FOREIGN KEY (`roster_loaned_from_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`roster` ADD CONSTRAINT `fk_athlete_roster_transaction_window_id` FOREIGN KEY (`transaction_window_id`) REFERENCES `sports_entertainment_ecm`.`league`.`transaction_window`(`transaction_window_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`athlete_profile` ADD CONSTRAINT `fk_athlete_athlete_profile_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`athlete_profile` ADD CONSTRAINT `fk_athlete_athlete_profile_team_id` FOREIGN KEY (`team_id`) REFERENCES `sports_entertainment_ecm`.`league`.`team`(`team_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_contract_team_franchise_id` FOREIGN KEY (`contract_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`contract` ADD CONSTRAINT `fk_athlete_contract_transaction_window_id` FOREIGN KEY (`transaction_window_id`) REFERENCES `sports_entertainment_ecm`.`league`.`transaction_window`(`transaction_window_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`performance_stat` ADD CONSTRAINT `fk_athlete_performance_stat_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`performance_stat` ADD CONSTRAINT `fk_athlete_performance_stat_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`performance_stat` ADD CONSTRAINT `fk_athlete_performance_stat_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`performance_stat` ADD CONSTRAINT `fk_athlete_performance_stat_tertiary_performance_opponent_team_franchise_id` FOREIGN KEY (`tertiary_performance_opponent_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_draft_pick_id` FOREIGN KEY (`draft_pick_id`) REFERENCES `sports_entertainment_ecm`.`league`.`draft_pick`(`draft_pick_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_draft_id` FOREIGN KEY (`draft_id`) REFERENCES `sports_entertainment_ecm`.`league`.`draft`(`draft_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_tertiary_draft_original_team_franchise_id` FOREIGN KEY (`tertiary_draft_original_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`eligibility_status` ADD CONSTRAINT `fk_athlete_eligibility_status_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`eligibility_status` ADD CONSTRAINT `fk_athlete_eligibility_status_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`eligibility_status` ADD CONSTRAINT `fk_athlete_eligibility_status_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`agent_relationship` ADD CONSTRAINT `fk_athlete_agent_relationship_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_disciplinary_action_id` FOREIGN KEY (`disciplinary_action_id`) REFERENCES `sports_entertainment_ecm`.`league`.`disciplinary_action`(`disciplinary_action_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_salary_cap_id` FOREIGN KEY (`salary_cap_id`) REFERENCES `sports_entertainment_ecm`.`league`.`salary_cap`(`salary_cap_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`salary_cap_entry` ADD CONSTRAINT `fk_athlete_salary_cap_entry_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`free_agency_status` ADD CONSTRAINT `fk_athlete_free_agency_status_draft_pick_id` FOREIGN KEY (`draft_pick_id`) REFERENCES `sports_entertainment_ecm`.`league`.`draft_pick`(`draft_pick_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`free_agency_status` ADD CONSTRAINT `fk_athlete_free_agency_status_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`free_agency_status` ADD CONSTRAINT `fk_athlete_free_agency_status_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`free_agency_status` ADD CONSTRAINT `fk_athlete_free_agency_status_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`free_agency_status` ADD CONSTRAINT `fk_athlete_free_agency_status_tertiary_free_signing_team_franchise_id` FOREIGN KEY (`tertiary_free_signing_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`free_agency_status` ADD CONSTRAINT `fk_athlete_free_agency_status_transaction_window_id` FOREIGN KEY (`transaction_window_id`) REFERENCES `sports_entertainment_ecm`.`league`.`transaction_window`(`transaction_window_id`);

-- ========= athlete --> security (3 constraint(s)) =========
-- Requires: athlete schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_ejection_record_id` FOREIGN KEY (`ejection_record_id`) REFERENCES `sports_entertainment_ecm`.`security`.`ejection_record`(`ejection_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`suspension_record` ADD CONSTRAINT `fk_athlete_suspension_record_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);

-- ========= athlete --> sponsorship (2 constraint(s)) =========
-- Requires: athlete schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);

-- ========= athlete --> venue (4 constraint(s)) =========
-- Requires: athlete schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`performance_stat` ADD CONSTRAINT `fk_athlete_performance_stat_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`injury_record` ADD CONSTRAINT `fk_athlete_injury_record_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`draft_selection` ADD CONSTRAINT `fk_athlete_draft_selection_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`athlete`.`nil_agreement` ADD CONSTRAINT `fk_athlete_nil_agreement_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);

-- ========= broadcast --> athlete (5 constraint(s)) =========
-- Requires: broadcast schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);

-- ========= broadcast --> compliance (21 constraint(s)) =========
-- Requires: broadcast schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_rights_deal` ADD CONSTRAINT `fk_broadcast_media_rights_deal_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`live_feed` ADD CONSTRAINT `fk_broadcast_live_feed_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_holder` ADD CONSTRAINT `fk_broadcast_rights_holder_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`licensee` ADD CONSTRAINT `fk_broadcast_licensee_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`licensee` ADD CONSTRAINT `fk_broadcast_licensee_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);

-- ========= broadcast --> content (12 constraint(s)) =========
-- Requires: broadcast schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_category_id` FOREIGN KEY (`category_id`) REFERENCES `sports_entertainment_ecm`.`content`.`category`(`category_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_license_id` FOREIGN KEY (`license_id`) REFERENCES `sports_entertainment_ecm`.`content`.`license`(`license_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`live_feed` ADD CONSTRAINT `fk_broadcast_live_feed_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`live_feed` ADD CONSTRAINT `fk_broadcast_live_feed_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_category_id` FOREIGN KEY (`category_id`) REFERENCES `sports_entertainment_ecm`.`content`.`category`(`category_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `sports_entertainment_ecm`.`content`.`production_order`(`production_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= broadcast --> event (16 constraint(s)) =========
-- Requires: broadcast schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`live_feed` ADD CONSTRAINT `fk_broadcast_live_feed_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`live_feed` ADD CONSTRAINT `fk_broadcast_live_feed_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_production_fixture_id` FOREIGN KEY (`production_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);

-- ========= broadcast --> fan (3 constraint(s)) =========
-- Requires: broadcast schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`payment_method`(`payment_method_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);

-- ========= broadcast --> finance (10 constraint(s)) =========
-- Requires: broadcast schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_rights_deal` ADD CONSTRAINT `fk_broadcast_media_rights_deal_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`live_feed` ADD CONSTRAINT `fk_broadcast_live_feed_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);

-- ========= broadcast --> league (21 constraint(s)) =========
-- Requires: broadcast schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_rights_deal` ADD CONSTRAINT `fk_broadcast_media_rights_deal_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_rights_deal` ADD CONSTRAINT `fk_broadcast_media_rights_deal_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_rights_deal` ADD CONSTRAINT `fk_broadcast_media_rights_deal_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`channel` ADD CONSTRAINT `fk_broadcast_channel_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`blackout_rule` ADD CONSTRAINT `fk_broadcast_blackout_rule_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`streaming_subscription` ADD CONSTRAINT `fk_broadcast_streaming_subscription_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`media_asset` ADD CONSTRAINT `fk_broadcast_media_asset_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`rights_window` ADD CONSTRAINT `fk_broadcast_rights_window_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= broadcast --> security (1 constraint(s)) =========
-- Requires: broadcast schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_response_plan`(`emergency_response_plan_id`);

-- ========= broadcast --> sponsorship (3 constraint(s)) =========
-- Requires: broadcast schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`audience_rating` ADD CONSTRAINT `fk_broadcast_audience_rating_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);

-- ========= broadcast --> venue (5 constraint(s)) =========
-- Requires: broadcast schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule` ADD CONSTRAINT `fk_broadcast_broadcast_schedule_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`live_feed` ADD CONSTRAINT `fk_broadcast_live_feed_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_capacity_config_id` FOREIGN KEY (`capacity_config_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`capacity_config`(`capacity_config_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`broadcast`.`production` ADD CONSTRAINT `fk_broadcast_production_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= compliance --> athlete (4 constraint(s)) =========
-- Requires: compliance schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_test` ADD CONSTRAINT `fk_compliance_doping_test_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_violation` ADD CONSTRAINT `fk_compliance_doping_violation_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`whereabouts_filing` ADD CONSTRAINT `fk_compliance_whereabouts_filing_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`eligibility_certification` ADD CONSTRAINT `fk_compliance_eligibility_certification_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);

-- ========= compliance --> event (8 constraint(s)) =========
-- Requires: compliance schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_test` ADD CONSTRAINT `fk_compliance_doping_test_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_test` ADD CONSTRAINT `fk_compliance_doping_test_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`whereabouts_filing` ADD CONSTRAINT `fk_compliance_whereabouts_filing_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`eligibility_certification` ADD CONSTRAINT `fk_compliance_eligibility_certification_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);

-- ========= compliance --> fan (3 constraint(s)) =========
-- Requires: compliance schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`privacy_request` ADD CONSTRAINT `fk_compliance_privacy_request_account_id` FOREIGN KEY (`account_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`account`(`account_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`privacy_request` ADD CONSTRAINT `fk_compliance_privacy_request_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);

-- ========= compliance --> finance (17 constraint(s)) =========
-- Requires: compliance schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_test` ADD CONSTRAINT `fk_compliance_doping_test_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_violation` ADD CONSTRAINT `fk_compliance_doping_violation_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`data_processing_record` ADD CONSTRAINT `fk_compliance_data_processing_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);

-- ========= compliance --> gaming (7 constraint(s)) =========
-- Requires: compliance schema, gaming schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);

-- ========= compliance --> league (30 constraint(s)) =========
-- Requires: compliance schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_salary_cap_id` FOREIGN KEY (`salary_cap_id`) REFERENCES `sports_entertainment_ecm`.`league`.`salary_cap`(`salary_cap_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_test` ADD CONSTRAINT `fk_compliance_doping_test_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_test` ADD CONSTRAINT `fk_compliance_doping_test_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_test` ADD CONSTRAINT `fk_compliance_doping_test_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_violation` ADD CONSTRAINT `fk_compliance_doping_violation_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`doping_violation` ADD CONSTRAINT `fk_compliance_doping_violation_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`whereabouts_filing` ADD CONSTRAINT `fk_compliance_whereabouts_filing_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`whereabouts_filing` ADD CONSTRAINT `fk_compliance_whereabouts_filing_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`eligibility_certification` ADD CONSTRAINT `fk_compliance_eligibility_certification_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`eligibility_certification` ADD CONSTRAINT `fk_compliance_eligibility_certification_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`eligibility_certification` ADD CONSTRAINT `fk_compliance_eligibility_certification_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= compliance --> security (1 constraint(s)) =========
-- Requires: compliance schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);

-- ========= compliance --> sponsorship (5 constraint(s)) =========
-- Requires: compliance schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`arbitration_case` ADD CONSTRAINT `fk_compliance_arbitration_case_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`data_processing_record` ADD CONSTRAINT `fk_compliance_data_processing_record_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);

-- ========= compliance --> ticketing (1 constraint(s)) =========
-- Requires: compliance schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`privacy_request` ADD CONSTRAINT `fk_compliance_privacy_request_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);

-- ========= compliance --> venue (6 constraint(s)) =========
-- Requires: compliance schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_engagement` ADD CONSTRAINT `fk_compliance_audit_engagement_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_safety_incident_id` FOREIGN KEY (`safety_incident_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`safety_incident`(`safety_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`eligibility_certification` ADD CONSTRAINT `fk_compliance_eligibility_certification_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`compliance`.`investigation` ADD CONSTRAINT `fk_compliance_investigation_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);

-- ========= content --> athlete (7 constraint(s)) =========
-- Requires: content schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_asset_athlete_profile_id` FOREIGN KEY (`asset_athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);

-- ========= content --> broadcast (10 constraint(s)) =========
-- Requires: content schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_live_feed_id` FOREIGN KEY (`live_feed_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`live_feed`(`live_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_rights_window_id` FOREIGN KEY (`rights_window_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`rights_window`(`rights_window_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);

-- ========= content --> compliance (14 constraint(s)) =========
-- Requires: content schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`metadata_tag` ADD CONSTRAINT `fk_content_metadata_tag_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`category` ADD CONSTRAINT `fk_content_category_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);

-- ========= content --> event (23 constraint(s)) =========
-- Requires: content schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_asset_fixture_id` FOREIGN KEY (`asset_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_primary_publish_fixture_id` FOREIGN KEY (`primary_publish_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_collection_fixture_id` FOREIGN KEY (`collection_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_bracket_id` FOREIGN KEY (`bracket_id`) REFERENCES `sports_entertainment_ecm`.`event`.`bracket`(`bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_production_schedule_id` FOREIGN KEY (`production_schedule_id`) REFERENCES `sports_entertainment_ecm`.`event`.`production_schedule`(`production_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);

-- ========= content --> fan (4 constraint(s)) =========
-- Requires: content schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`campaign`(`campaign_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);

-- ========= content --> finance (12 constraint(s)) =========
-- Requires: content schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_revenue_recognition_schedule_id` FOREIGN KEY (`revenue_recognition_schedule_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`(`revenue_recognition_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);

-- ========= content --> gaming (6 constraint(s)) =========
-- Requires: content schema, gaming schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_betting_market_id` FOREIGN KEY (`betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);

-- ========= content --> league (31 constraint(s)) =========
-- Requires: content schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_draft_id` FOREIGN KEY (`draft_id`) REFERENCES `sports_entertainment_ecm`.`league`.`draft`(`draft_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`metadata_tag` ADD CONSTRAINT `fk_content_metadata_tag_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_disciplinary_action_id` FOREIGN KEY (`disciplinary_action_id`) REFERENCES `sports_entertainment_ecm`.`league`.`disciplinary_action`(`disciplinary_action_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_trade_transaction_id` FOREIGN KEY (`trade_transaction_id`) REFERENCES `sports_entertainment_ecm`.`league`.`trade_transaction`(`trade_transaction_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`platform_channel` ADD CONSTRAINT `fk_content_platform_channel_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);

-- ========= content --> merchandise (3 constraint(s)) =========
-- Requires: content schema, merchandise schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_sku_catalog_id` FOREIGN KEY (`sku_catalog_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`sku_catalog`(`sku_catalog_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);

-- ========= content --> security (2 constraint(s)) =========
-- Requires: content schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_emergency_activation_id` FOREIGN KEY (`emergency_activation_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_activation`(`emergency_activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);

-- ========= content --> sponsorship (10 constraint(s)) =========
-- Requires: content schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`publish_event` ADD CONSTRAINT `fk_content_publish_event_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`license` ADD CONSTRAINT `fk_content_license_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);

-- ========= content --> venue (5 constraint(s)) =========
-- Requires: content schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`content`.`asset` ADD CONSTRAINT `fk_content_asset_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`production_order` ADD CONSTRAINT `fk_content_production_order_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`ingest_job` ADD CONSTRAINT `fk_content_ingest_job_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`collection` ADD CONSTRAINT `fk_content_collection_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`content`.`editorial_brief` ADD CONSTRAINT `fk_content_editorial_brief_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);

-- ========= event --> athlete (9 constraint(s)) =========
-- Requires: event schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_tertiary_scoring_athlete_profile_id` FOREIGN KEY (`tertiary_scoring_athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_eligibility_status_id` FOREIGN KEY (`eligibility_status_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`eligibility_status`(`eligibility_status_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_suspension_record_id` FOREIGN KEY (`suspension_record_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`suspension_record`(`suspension_record_id`);

-- ========= event --> broadcast (18 constraint(s)) =========
-- Requires: event schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_fixture_channel_id` FOREIGN KEY (`fixture_channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`calendar` ADD CONSTRAINT `fk_event_calendar_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_media_asset_id` FOREIGN KEY (`media_asset_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_asset`(`media_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_production_id` FOREIGN KEY (`production_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`production`(`production_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_live_feed_id` FOREIGN KEY (`live_feed_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`live_feed`(`live_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_media_asset_id` FOREIGN KEY (`media_asset_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_asset`(`media_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`broadcast_window` ADD CONSTRAINT `fk_event_broadcast_window_production_id` FOREIGN KEY (`production_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`production`(`production_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`broadcast_window` ADD CONSTRAINT `fk_event_broadcast_window_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`broadcast_window` ADD CONSTRAINT `fk_event_broadcast_window_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`broadcast_window` ADD CONSTRAINT `fk_event_broadcast_window_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`broadcast_window` ADD CONSTRAINT `fk_event_broadcast_window_rights_window_id` FOREIGN KEY (`rights_window_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`rights_window`(`rights_window_id`);

-- ========= event --> compliance (15 constraint(s)) =========
-- Requires: event schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`calendar` ADD CONSTRAINT `fk_event_calendar_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`calendar` ADD CONSTRAINT `fk_event_calendar_calendar_scheduling_authority_governing_body_id` FOREIGN KEY (`calendar_scheduling_authority_governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`calendar` ADD CONSTRAINT `fk_event_calendar_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_eligibility_certification_id` FOREIGN KEY (`eligibility_certification_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`eligibility_certification`(`eligibility_certification_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_eligibility_certification_id` FOREIGN KEY (`eligibility_certification_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`eligibility_certification`(`eligibility_certification_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`venue_assignment` ADD CONSTRAINT `fk_event_venue_assignment_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`broadcast_window` ADD CONSTRAINT `fk_event_broadcast_window_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`type` ADD CONSTRAINT `fk_event_type_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);

-- ========= event --> content (2 constraint(s)) =========
-- Requires: event schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= event --> finance (10 constraint(s)) =========
-- Requires: event schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`calendar` ADD CONSTRAINT `fk_event_calendar_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`venue_assignment` ADD CONSTRAINT `fk_event_venue_assignment_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`venue_assignment` ADD CONSTRAINT `fk_event_venue_assignment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);

-- ========= event --> league (35 constraint(s)) =========
-- Requires: event schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_conference_id` FOREIGN KEY (`conference_id`) REFERENCES `sports_entertainment_ecm`.`league`.`conference`(`conference_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_fixture_franchise_id` FOREIGN KEY (`fixture_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`calendar` ADD CONSTRAINT `fk_event_calendar_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`calendar` ADD CONSTRAINT `fk_event_calendar_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_conference_id` FOREIGN KEY (`conference_id`) REFERENCES `sports_entertainment_ecm`.`league`.`conference`(`conference_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_quaternary_match_winning_team_franchise_id` FOREIGN KEY (`quaternary_match_winning_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_tertiary_match_franchise_id` FOREIGN KEY (`tertiary_match_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_tertiary_match_winning_team_franchise_id` FOREIGN KEY (`tertiary_match_winning_team_franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`participant` ADD CONSTRAINT `fk_event_participant_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_disciplinary_action_id` FOREIGN KEY (`disciplinary_action_id`) REFERENCES `sports_entertainment_ecm`.`league`.`disciplinary_action`(`disciplinary_action_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_conference_id` FOREIGN KEY (`conference_id`) REFERENCES `sports_entertainment_ecm`.`league`.`conference`(`conference_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= event --> security (4 constraint(s)) =========
-- Requires: event schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_response_plan`(`emergency_response_plan_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_credential_id` FOREIGN KEY (`credential_id`) REFERENCES `sports_entertainment_ecm`.`security`.`credential`(`credential_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`venue_assignment` ADD CONSTRAINT `fk_event_venue_assignment_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_response_plan`(`emergency_response_plan_id`);

-- ========= event --> sponsorship (6 constraint(s)) =========
-- Requires: event schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_property_id` FOREIGN KEY (`property_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`property`(`property_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);

-- ========= event --> ticketing (1 constraint(s)) =========
-- Requires: event schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_price_tier_id` FOREIGN KEY (`price_tier_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`price_tier`(`price_tier_id`);

-- ========= event --> venue (16 constraint(s)) =========
-- Requires: event schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_capacity_config_id` FOREIGN KEY (`capacity_config_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`capacity_config`(`capacity_config_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`fixture` ADD CONSTRAINT `fk_event_fixture_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_capacity_config_id` FOREIGN KEY (`capacity_config_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`capacity_config`(`capacity_config_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`tournament` ADD CONSTRAINT `fk_event_tournament_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`bracket` ADD CONSTRAINT `fk_event_bracket_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`match_result` ADD CONSTRAINT `fk_event_match_result_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`scoring_event` ADD CONSTRAINT `fk_event_scoring_event_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_capacity_config_id` FOREIGN KEY (`capacity_config_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`capacity_config`(`capacity_config_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`production_schedule` ADD CONSTRAINT `fk_event_production_schedule_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`officiating_assignment` ADD CONSTRAINT `fk_event_officiating_assignment_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`event_incident` ADD CONSTRAINT `fk_event_event_incident_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`venue_assignment` ADD CONSTRAINT `fk_event_venue_assignment_capacity_config_id` FOREIGN KEY (`capacity_config_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`capacity_config`(`capacity_config_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`venue_assignment` ADD CONSTRAINT `fk_event_venue_assignment_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`competition_round` ADD CONSTRAINT `fk_event_competition_round_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`event`.`broadcast_window` ADD CONSTRAINT `fk_event_broadcast_window_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= fan --> athlete (5 constraint(s)) =========
-- Requires: fan schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_club_athlete_profile_id` FOREIGN KEY (`club_athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);

-- ========= fan --> broadcast (10 constraint(s)) =========
-- Requires: fan schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_streaming_subscription_id` FOREIGN KEY (`streaming_subscription_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`streaming_subscription`(`streaming_subscription_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_streaming_subscription_id` FOREIGN KEY (`streaming_subscription_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`streaming_subscription`(`streaming_subscription_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_live_feed_id` FOREIGN KEY (`live_feed_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`live_feed`(`live_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_streaming_subscription_id` FOREIGN KEY (`streaming_subscription_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`streaming_subscription`(`streaming_subscription_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_streaming_subscription_id` FOREIGN KEY (`streaming_subscription_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`streaming_subscription`(`streaming_subscription_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);

-- ========= fan --> compliance (23 constraint(s)) =========
-- Requires: fan schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment` ADD CONSTRAINT `fk_fan_segment_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment` ADD CONSTRAINT `fk_fan_segment_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment_assignment` ADD CONSTRAINT `fk_fan_segment_assignment_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`consent_preference` ADD CONSTRAINT `fk_fan_consent_preference_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`consent_preference` ADD CONSTRAINT `fk_fan_consent_preference_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`payment_method` ADD CONSTRAINT `fk_fan_payment_method_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`payment_method` ADD CONSTRAINT `fk_fan_payment_method_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);

-- ========= fan --> content (7 constraint(s)) =========
-- Requires: fan schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `sports_entertainment_ecm`.`content`.`collection`(`collection_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment` ADD CONSTRAINT `fk_fan_segment_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= fan --> event (15 constraint(s)) =========
-- Requires: fan schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_bracket_id` FOREIGN KEY (`bracket_id`) REFERENCES `sports_entertainment_ecm`.`event`.`bracket`(`bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_primary_engagement_fixture_id` FOREIGN KEY (`primary_engagement_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_scoring_event_id` FOREIGN KEY (`scoring_event_id`) REFERENCES `sports_entertainment_ecm`.`event`.`scoring_event`(`scoring_event_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);

-- ========= fan --> finance (12 constraint(s)) =========
-- Requires: fan schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`account` ADD CONSTRAINT `fk_fan_account_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);

-- ========= fan --> gaming (5 constraint(s)) =========
-- Requires: fan schema, gaming schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_wager_id` FOREIGN KEY (`wager_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`wager`(`wager_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_bettor_account_id` FOREIGN KEY (`bettor_account_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`bettor_account`(`bettor_account_id`);

-- ========= fan --> league (29 constraint(s)) =========
-- Requires: fan schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`fan_profile` ADD CONSTRAINT `fk_fan_fan_profile_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`account` ADD CONSTRAINT `fk_fan_account_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`account` ADD CONSTRAINT `fk_fan_account_team_id` FOREIGN KEY (`team_id`) REFERENCES `sports_entertainment_ecm`.`league`.`team`(`team_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_team_id` FOREIGN KEY (`team_id`) REFERENCES `sports_entertainment_ecm`.`league`.`team`(`team_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_team_id` FOREIGN KEY (`team_id`) REFERENCES `sports_entertainment_ecm`.`league`.`team`(`team_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment` ADD CONSTRAINT `fk_fan_segment_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment` ADD CONSTRAINT `fk_fan_segment_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment` ADD CONSTRAINT `fk_fan_segment_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`segment` ADD CONSTRAINT `fk_fan_segment_team_id` FOREIGN KEY (`team_id`) REFERENCES `sports_entertainment_ecm`.`league`.`team`(`team_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_team_id` FOREIGN KEY (`team_id`) REFERENCES `sports_entertainment_ecm`.`league`.`team`(`team_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= fan --> merchandise (10 constraint(s)) =========
-- Requires: fan schema, merchandise schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`price_list`(`price_list_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_merch_order_id` FOREIGN KEY (`merch_order_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`merch_order`(`merch_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_sku_catalog_id` FOREIGN KEY (`sku_catalog_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`sku_catalog`(`sku_catalog_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_merch_order_id` FOREIGN KEY (`merch_order_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`merch_order`(`merch_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_return_request_id` FOREIGN KEY (`return_request_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`return_request`(`return_request_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);

-- ========= fan --> security (5 constraint(s)) =========
-- Requires: fan schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_credential_id` FOREIGN KEY (`credential_id`) REFERENCES `sports_entertainment_ecm`.`security`.`credential`(`credential_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_ejection_record_id` FOREIGN KEY (`ejection_record_id`) REFERENCES `sports_entertainment_ecm`.`security`.`ejection_record`(`ejection_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);

-- ========= fan --> sponsorship (10 constraint(s)) =========
-- Requires: fan schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_club_sponsorship_partner_sponsor_id` FOREIGN KEY (`club_sponsorship_partner_sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);

-- ========= fan --> ticketing (8 constraint(s)) =========
-- Requires: fan schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_season_ticket_package_id` FOREIGN KEY (`season_ticket_package_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`season_ticket_package`(`season_ticket_package_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_ticket_inventory_id` FOREIGN KEY (`ticket_inventory_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_inventory`(`ticket_inventory_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_ticket_order_line_id` FOREIGN KEY (`ticket_order_line_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order_line`(`ticket_order_line_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`communication` ADD CONSTRAINT `fk_fan_communication_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_access_entitlement_id` FOREIGN KEY (`access_entitlement_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`access_entitlement`(`access_entitlement_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_refund_id` FOREIGN KEY (`refund_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`refund`(`refund_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);

-- ========= fan --> venue (21 constraint(s)) =========
-- Requires: fan schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`fan`.`fan_profile` ADD CONSTRAINT `fk_fan_fan_profile_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`account` ADD CONSTRAINT `fk_fan_account_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_program` ADD CONSTRAINT `fk_fan_loyalty_program_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_enrollment` ADD CONSTRAINT `fk_fan_loyalty_enrollment_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_concession_stand_id` FOREIGN KEY (`concession_stand_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`concession_stand`(`concession_stand_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`loyalty_transaction` ADD CONSTRAINT `fk_fan_loyalty_transaction_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_seat_id` FOREIGN KEY (`seat_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seat`(`seat_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_parking_lot_id` FOREIGN KEY (`parking_lot_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`parking_lot`(`parking_lot_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_suite_id` FOREIGN KEY (`suite_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`suite`(`suite_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`membership` ADD CONSTRAINT `fk_fan_membership_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_concession_stand_id` FOREIGN KEY (`concession_stand_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`concession_stand`(`concession_stand_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`engagement_event` ADD CONSTRAINT `fk_fan_engagement_event_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_concession_stand_id` FOREIGN KEY (`concession_stand_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`concession_stand`(`concession_stand_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_parking_lot_id` FOREIGN KEY (`parking_lot_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`parking_lot`(`parking_lot_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_seat_id` FOREIGN KEY (`seat_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seat`(`seat_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_suite_id` FOREIGN KEY (`suite_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`suite`(`suite_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`service_case` ADD CONSTRAINT `fk_fan_service_case_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`club` ADD CONSTRAINT `fk_fan_club_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`fan`.`campaign` ADD CONSTRAINT `fk_fan_campaign_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= finance --> athlete (5 constraint(s)) =========
-- Requires: finance schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`contract`(`contract_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_agent_id` FOREIGN KEY (`agent_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`agent`(`agent_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_agent_id` FOREIGN KEY (`agent_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`agent`(`agent_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule` ADD CONSTRAINT `fk_finance_revenue_recognition_schedule_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);

-- ========= finance --> broadcast (3 constraint(s)) =========
-- Requires: finance schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule` ADD CONSTRAINT `fk_finance_revenue_recognition_schedule_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);

-- ========= finance --> event (6 constraint(s)) =========
-- Requires: finance schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_officiating_assignment_id` FOREIGN KEY (`officiating_assignment_id`) REFERENCES `sports_entertainment_ecm`.`event`.`officiating_assignment`(`officiating_assignment_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_participant_id` FOREIGN KEY (`participant_id`) REFERENCES `sports_entertainment_ecm`.`event`.`participant`(`participant_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule` ADD CONSTRAINT `fk_finance_revenue_recognition_schedule_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule` ADD CONSTRAINT `fk_finance_revenue_recognition_schedule_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule` ADD CONSTRAINT `fk_finance_revenue_recognition_schedule_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule` ADD CONSTRAINT `fk_finance_revenue_recognition_schedule_venue_assignment_id` FOREIGN KEY (`venue_assignment_id`) REFERENCES `sports_entertainment_ecm`.`event`.`venue_assignment`(`venue_assignment_id`);

-- ========= finance --> fan (4 constraint(s)) =========
-- Requires: finance schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`account`(`account_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`membership`(`membership_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`membership`(`membership_id`);

-- ========= finance --> league (1 constraint(s)) =========
-- Requires: finance schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);

-- ========= finance --> security (1 constraint(s)) =========
-- Requires: finance schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);

-- ========= finance --> sponsorship (1 constraint(s)) =========
-- Requires: finance schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);

-- ========= finance --> ticketing (4 constraint(s)) =========
-- Requires: finance schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_group_sale_id` FOREIGN KEY (`group_sale_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`group_sale`(`group_sale_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_season_ticket_account_id` FOREIGN KEY (`season_ticket_account_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`season_ticket_account`(`season_ticket_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_ticket_payment_id` FOREIGN KEY (`ticket_payment_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_payment`(`ticket_payment_id`);

-- ========= finance --> venue (2 constraint(s)) =========
-- Requires: finance schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= gaming --> athlete (10 constraint(s)) =========
-- Requires: gaming schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_eligibility_status_id` FOREIGN KEY (`eligibility_status_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`eligibility_status`(`eligibility_status_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_performance_stat_id` FOREIGN KEY (`performance_stat_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`performance_stat`(`performance_stat_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_suspension_record_id` FOREIGN KEY (`suspension_record_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`suspension_record`(`suspension_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_eligibility_status_id` FOREIGN KEY (`eligibility_status_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`eligibility_status`(`eligibility_status_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_injury_record_id` FOREIGN KEY (`injury_record_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`injury_record`(`injury_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_roster_id` FOREIGN KEY (`roster_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`roster`(`roster_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_suspension_record_id` FOREIGN KEY (`suspension_record_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`suspension_record`(`suspension_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ADD CONSTRAINT `fk_gaming_selection_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);

-- ========= gaming --> broadcast (8 constraint(s)) =========
-- Requires: gaming schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_rights_window_id` FOREIGN KEY (`rights_window_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`rights_window`(`rights_window_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_live_feed_id` FOREIGN KEY (`live_feed_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`live_feed`(`live_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_streaming_subscription_id` FOREIGN KEY (`streaming_subscription_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`streaming_subscription`(`streaming_subscription_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);

-- ========= gaming --> compliance (9 constraint(s)) =========
-- Requires: gaming schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`jurisdiction` ADD CONSTRAINT `fk_gaming_jurisdiction_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ADD CONSTRAINT `fk_gaming_responsible_gaming_limit_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`responsible_gaming_limit` ADD CONSTRAINT `fk_gaming_responsible_gaming_limit_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ADD CONSTRAINT `fk_gaming_operator_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);

-- ========= gaming --> content (2 constraint(s)) =========
-- Requires: gaming schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `sports_entertainment_ecm`.`content`.`collection`(`collection_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= gaming --> event (25 constraint(s)) =========
-- Requires: gaming schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_scoring_event_id` FOREIGN KEY (`scoring_event_id`) REFERENCES `sports_entertainment_ecm`.`event`.`scoring_event`(`scoring_event_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_wager_fixture_id` FOREIGN KEY (`wager_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_participant_id` FOREIGN KEY (`participant_id`) REFERENCES `sports_entertainment_ecm`.`event`.`participant`(`participant_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_scoring_event_id` FOREIGN KEY (`scoring_event_id`) REFERENCES `sports_entertainment_ecm`.`event`.`scoring_event`(`scoring_event_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_bracket_id` FOREIGN KEY (`bracket_id`) REFERENCES `sports_entertainment_ecm`.`event`.`bracket`(`bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ADD CONSTRAINT `fk_gaming_selection_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ADD CONSTRAINT `fk_gaming_selection_match_result_id` FOREIGN KEY (`match_result_id`) REFERENCES `sports_entertainment_ecm`.`event`.`match_result`(`match_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ADD CONSTRAINT `fk_gaming_selection_participant_id` FOREIGN KEY (`participant_id`) REFERENCES `sports_entertainment_ecm`.`event`.`participant`(`participant_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`selection` ADD CONSTRAINT `fk_gaming_selection_scoring_event_id` FOREIGN KEY (`scoring_event_id`) REFERENCES `sports_entertainment_ecm`.`event`.`scoring_event`(`scoring_event_id`);

-- ========= gaming --> fan (7 constraint(s)) =========
-- Requires: gaming schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`campaign`(`campaign_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ADD CONSTRAINT `fk_gaming_bettor_account_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`campaign`(`campaign_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ADD CONSTRAINT `fk_gaming_bettor_account_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_club_id` FOREIGN KEY (`club_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`club`(`club_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ADD CONSTRAINT `fk_gaming_wallet_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`payment_method`(`payment_method_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`loyalty_program`(`loyalty_program_id`);

-- ========= gaming --> finance (19 constraint(s)) =========
-- Requires: gaming schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ADD CONSTRAINT `fk_gaming_wallet_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wallet` ADD CONSTRAINT `fk_gaming_wallet_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ADD CONSTRAINT `fk_gaming_operator_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);

-- ========= gaming --> league (22 constraint(s)) =========
-- Requires: gaming schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`betting_market` ADD CONSTRAINT `fk_gaming_betting_market_playoff_bracket_id` FOREIGN KEY (`playoff_bracket_id`) REFERENCES `sports_entertainment_ecm`.`league`.`playoff_bracket`(`playoff_bracket_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`odds_feed` ADD CONSTRAINT `fk_gaming_odds_feed_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`prop_bet` ADD CONSTRAINT `fk_gaming_prop_bet_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_league` ADD CONSTRAINT `fk_gaming_fantasy_league_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_roster` ADD CONSTRAINT `fk_gaming_fantasy_roster_trade_transaction_id` FOREIGN KEY (`trade_transaction_id`) REFERENCES `sports_entertainment_ecm`.`league`.`trade_transaction`(`trade_transaction_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ADD CONSTRAINT `fk_gaming_fantasy_team_division_id` FOREIGN KEY (`division_id`) REFERENCES `sports_entertainment_ecm`.`league`.`division`(`division_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ADD CONSTRAINT `fk_gaming_fantasy_team_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`fantasy_team` ADD CONSTRAINT `fk_gaming_fantasy_team_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`payout` ADD CONSTRAINT `fk_gaming_payout_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= gaming --> merchandise (4 constraint(s)) =========
-- Requires: gaming schema, merchandise schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_retail_location_id` FOREIGN KEY (`retail_location_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`retail_location`(`retail_location_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_sku_catalog_id` FOREIGN KEY (`sku_catalog_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`sku_catalog`(`sku_catalog_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_merch_order_id` FOREIGN KEY (`merch_order_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`merch_order`(`merch_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_retail_location_id` FOREIGN KEY (`retail_location_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`retail_location`(`retail_location_id`);

-- ========= gaming --> security (3 constraint(s)) =========
-- Requires: gaming schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_emergency_activation_id` FOREIGN KEY (`emergency_activation_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_activation`(`emergency_activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_emergency_activation_id` FOREIGN KEY (`emergency_activation_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_activation`(`emergency_activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);

-- ========= gaming --> ticketing (5 constraint(s)) =========
-- Requires: gaming schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`bettor_account` ADD CONSTRAINT `fk_gaming_bettor_account_season_ticket_account_id` FOREIGN KEY (`season_ticket_account_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`season_ticket_account`(`season_ticket_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_season_ticket_package_id` FOREIGN KEY (`season_ticket_package_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`season_ticket_package`(`season_ticket_package_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest` ADD CONSTRAINT `fk_gaming_contest_ticket_inventory_id` FOREIGN KEY (`ticket_inventory_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_inventory`(`ticket_inventory_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_access_entitlement_id` FOREIGN KEY (`access_entitlement_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`access_entitlement`(`access_entitlement_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`contest_entry` ADD CONSTRAINT `fk_gaming_contest_entry_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);

-- ========= gaming --> venue (4 constraint(s)) =========
-- Requires: gaming schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`wager` ADD CONSTRAINT `fk_gaming_wager_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`self_exclusion` ADD CONSTRAINT `fk_gaming_self_exclusion_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`regulatory_report` ADD CONSTRAINT `fk_gaming_regulatory_report_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`gaming`.`operator` ADD CONSTRAINT `fk_gaming_operator_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);

-- ========= league --> athlete (5 constraint(s)) =========
-- Requires: league schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ADD CONSTRAINT `fk_league_playoff_bracket_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft_pick` ADD CONSTRAINT `fk_league_draft_pick_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`contract`(`contract_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);

-- ========= league --> broadcast (4 constraint(s)) =========
-- Requires: league schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ADD CONSTRAINT `fk_league_playoff_bracket_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ADD CONSTRAINT `fk_league_draft_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);

-- ========= league --> compliance (12 constraint(s)) =========
-- Requires: league schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ADD CONSTRAINT `fk_league_league_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ADD CONSTRAINT `fk_league_conference_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ADD CONSTRAINT `fk_league_season_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ADD CONSTRAINT `fk_league_official_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_doping_violation_id` FOREIGN KEY (`doping_violation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`doping_violation`(`doping_violation_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ADD CONSTRAINT `fk_league_draft_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ADD CONSTRAINT `fk_league_transaction_window_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);

-- ========= league --> event (3 constraint(s)) =========
-- Requires: league schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);

-- ========= league --> finance (19 constraint(s)) =========
-- Requires: league schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`league`.`league` ADD CONSTRAINT `fk_league_league_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ADD CONSTRAINT `fk_league_conference_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`conference` ADD CONSTRAINT `fk_league_conference_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ADD CONSTRAINT `fk_league_franchise_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ADD CONSTRAINT `fk_league_franchise_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ADD CONSTRAINT `fk_league_franchise_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ADD CONSTRAINT `fk_league_season_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ADD CONSTRAINT `fk_league_playoff_bracket_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`official` ADD CONSTRAINT `fk_league_official_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`salary_cap` ADD CONSTRAINT `fk_league_salary_cap_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ADD CONSTRAINT `fk_league_draft_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ADD CONSTRAINT `fk_league_draft_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`trade_transaction` ADD CONSTRAINT `fk_league_trade_transaction_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`transaction_window` ADD CONSTRAINT `fk_league_transaction_window_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);

-- ========= league --> security (2 constraint(s)) =========
-- Requires: league schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_ejection_record_id` FOREIGN KEY (`ejection_record_id`) REFERENCES `sports_entertainment_ecm`.`security`.`ejection_record`(`ejection_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`disciplinary_action` ADD CONSTRAINT `fk_league_disciplinary_action_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);

-- ========= league --> venue (8 constraint(s)) =========
-- Requires: league schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`league`.`franchise` ADD CONSTRAINT `fk_league_franchise_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`season` ADD CONSTRAINT `fk_league_season_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`league_schedule` ADD CONSTRAINT `fk_league_league_schedule_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`playoff_bracket` ADD CONSTRAINT `fk_league_playoff_bracket_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`game_result` ADD CONSTRAINT `fk_league_game_result_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`draft` ADD CONSTRAINT `fk_league_draft_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ADD CONSTRAINT `fk_league_team_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`league`.`team` ADD CONSTRAINT `fk_league_team_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);

-- ========= merchandise --> athlete (9 constraint(s)) =========
-- Requires: merchandise schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`order_line` ADD CONSTRAINT `fk_merchandise_order_line_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_agent_id` FOREIGN KEY (`agent_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`agent`(`agent_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_agent_id` FOREIGN KEY (`agent_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`agent`(`agent_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`contract`(`contract_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);

-- ========= merchandise --> broadcast (2 constraint(s)) =========
-- Requires: merchandise schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);

-- ========= merchandise --> compliance (17 constraint(s)) =========
-- Requires: merchandise schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_audit_engagement_id` FOREIGN KEY (`audit_engagement_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`audit_engagement`(`audit_engagement_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`fulfillment_shipment` ADD CONSTRAINT `fk_merchandise_fulfillment_shipment_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`return_request` ADD CONSTRAINT `fk_merchandise_return_request_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`supplier` ADD CONSTRAINT `fk_merchandise_supplier_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`product_category` ADD CONSTRAINT `fk_merchandise_product_category_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);

-- ========= merchandise --> content (3 constraint(s)) =========
-- Requires: merchandise schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_license_id` FOREIGN KEY (`license_id`) REFERENCES `sports_entertainment_ecm`.`content`.`license`(`license_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `sports_entertainment_ecm`.`content`.`collection`(`collection_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= merchandise --> event (16 constraint(s)) =========
-- Requires: merchandise schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_type_id` FOREIGN KEY (`type_id`) REFERENCES `sports_entertainment_ecm`.`event`.`type`(`type_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`order_line` ADD CONSTRAINT `fk_merchandise_order_line_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`fulfillment_shipment` ADD CONSTRAINT `fk_merchandise_fulfillment_shipment_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`return_request` ADD CONSTRAINT `fk_merchandise_return_request_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_competition_round_id` FOREIGN KEY (`competition_round_id`) REFERENCES `sports_entertainment_ecm`.`event`.`competition_round`(`competition_round_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);

-- ========= merchandise --> fan (12 constraint(s)) =========
-- Requires: merchandise schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`payment_method`(`payment_method_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`membership`(`membership_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`fulfillment_shipment` ADD CONSTRAINT `fk_merchandise_fulfillment_shipment_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`return_request` ADD CONSTRAINT `fk_merchandise_return_request_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`loyalty_program`(`loyalty_program_id`);

-- ========= merchandise --> finance (29 constraint(s)) =========
-- Requires: merchandise schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`order_line` ADD CONSTRAINT `fk_merchandise_order_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_revenue_recognition_schedule_id` FOREIGN KEY (`revenue_recognition_schedule_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`(`revenue_recognition_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`fulfillment_shipment` ADD CONSTRAINT `fk_merchandise_fulfillment_shipment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`fulfillment_shipment` ADD CONSTRAINT `fk_merchandise_fulfillment_shipment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`return_request` ADD CONSTRAINT `fk_merchandise_return_request_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`return_request` ADD CONSTRAINT `fk_merchandise_return_request_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`supplier` ADD CONSTRAINT `fk_merchandise_supplier_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`product_category` ADD CONSTRAINT `fk_merchandise_product_category_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);

-- ========= merchandise --> gaming (1 constraint(s)) =========
-- Requires: merchandise schema, gaming schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);

-- ========= merchandise --> league (23 constraint(s)) =========
-- Requires: merchandise schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`order_line` ADD CONSTRAINT `fk_merchandise_order_line_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`royalty_payment` ADD CONSTRAINT `fk_merchandise_royalty_payment_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`return_request` ADD CONSTRAINT `fk_merchandise_return_request_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_promotion_league_id` FOREIGN KEY (`promotion_league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`supplier` ADD CONSTRAINT `fk_merchandise_supplier_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);

-- ========= merchandise --> security (2 constraint(s)) =========
-- Requires: merchandise schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);

-- ========= merchandise --> sponsorship (7 constraint(s)) =========
-- Requires: merchandise schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`sku_catalog` ADD CONSTRAINT `fk_merchandise_sku_catalog_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`licensing_agreement` ADD CONSTRAINT `fk_merchandise_licensing_agreement_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`supplier` ADD CONSTRAINT `fk_merchandise_supplier_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);

-- ========= merchandise --> ticketing (2 constraint(s)) =========
-- Requires: merchandise schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_season_ticket_package_id` FOREIGN KEY (`season_ticket_package_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`season_ticket_package`(`season_ticket_package_id`);

-- ========= merchandise --> venue (10 constraint(s)) =========
-- Requires: merchandise schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`inventory_position` ADD CONSTRAINT `fk_merchandise_inventory_position_event_day_ops_id` FOREIGN KEY (`event_day_ops_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`event_day_ops`(`event_day_ops_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`retail_location` ADD CONSTRAINT `fk_merchandise_retail_location_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_event_day_ops_id` FOREIGN KEY (`event_day_ops_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`event_day_ops`(`event_day_ops_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`merch_order` ADD CONSTRAINT `fk_merchandise_merch_order_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`order_line` ADD CONSTRAINT `fk_merchandise_order_line_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`fulfillment_shipment` ADD CONSTRAINT `fk_merchandise_fulfillment_shipment_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`return_request` ADD CONSTRAINT `fk_merchandise_return_request_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`price_list` ADD CONSTRAINT `fk_merchandise_price_list_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`merchandise`.`promotion` ADD CONSTRAINT `fk_merchandise_promotion_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= security --> athlete (6 constraint(s)) =========
-- Requires: security schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);

-- ========= security --> broadcast (4 constraint(s)) =========
-- Requires: security schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_production_id` FOREIGN KEY (`production_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`production`(`production_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_live_feed_id` FOREIGN KEY (`live_feed_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`live_feed`(`live_feed_id`);

-- ========= security --> compliance (8 constraint(s)) =========
-- Requires: security schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_eligibility_certification_id` FOREIGN KEY (`eligibility_certification_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`eligibility_certification`(`eligibility_certification_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);

-- ========= security --> content (2 constraint(s)) =========
-- Requires: security schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= security --> event (16 constraint(s)) =========
-- Requires: security schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_credential_fixture_id` FOREIGN KEY (`credential_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_primary_access_fixture_id` FOREIGN KEY (`primary_access_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_primary_screening_fixture_id` FOREIGN KEY (`primary_screening_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_tournament_id` FOREIGN KEY (`tournament_id`) REFERENCES `sports_entertainment_ecm`.`event`.`tournament`(`tournament_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);

-- ========= security --> fan (8 constraint(s)) =========
-- Requires: security schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`membership`(`membership_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`membership`(`membership_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_account_id` FOREIGN KEY (`account_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`account`(`account_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`membership`(`membership_id`);

-- ========= security --> finance (3 constraint(s)) =========
-- Requires: security schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_zone` ADD CONSTRAINT `fk_security_access_zone_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_checkpoint` ADD CONSTRAINT `fk_security_screening_checkpoint_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);

-- ========= security --> league (23 constraint(s)) =========
-- Requires: security schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_zone` ADD CONSTRAINT `fk_security_access_zone_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_official_id` FOREIGN KEY (`official_id`) REFERENCES `sports_entertainment_ecm`.`league`.`official`(`official_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_game_result_id` FOREIGN KEY (`game_result_id`) REFERENCES `sports_entertainment_ecm`.`league`.`game_result`(`game_result_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= security --> merchandise (1 constraint(s)) =========
-- Requires: security schema, merchandise schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_retail_location_id` FOREIGN KEY (`retail_location_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`retail_location`(`retail_location_id`);

-- ========= security --> sponsorship (1 constraint(s)) =========
-- Requires: security schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);

-- ========= security --> ticketing (2 constraint(s)) =========
-- Requires: security schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_access_entitlement_id` FOREIGN KEY (`access_entitlement_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`access_entitlement`(`access_entitlement_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_ticket_order_id` FOREIGN KEY (`ticket_order_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`ticket_order`(`ticket_order_id`);

-- ========= security --> venue (13 constraint(s)) =========
-- Requires: security schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential` ADD CONSTRAINT `fk_security_credential_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_zone` ADD CONSTRAINT `fk_security_access_zone_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_zone` ADD CONSTRAINT `fk_security_access_zone_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`credential_assignment` ADD CONSTRAINT `fk_security_credential_assignment_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_checkpoint` ADD CONSTRAINT `fk_security_screening_checkpoint_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`screening_event` ADD CONSTRAINT `fk_security_screening_event_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_event_day_ops_id` FOREIGN KEY (`event_day_ops_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`event_day_ops`(`event_day_ops_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`ejection_record` ADD CONSTRAINT `fk_security_ejection_record_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_response_plan` ADD CONSTRAINT `fk_security_emergency_response_plan_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_event_day_ops_id` FOREIGN KEY (`event_day_ops_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`event_day_ops`(`event_day_ops_id`);
ALTER TABLE `sports_entertainment_ecm`.`security`.`emergency_activation` ADD CONSTRAINT `fk_security_emergency_activation_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= sponsorship --> athlete (7 constraint(s)) =========
-- Requires: sponsorship schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);

-- ========= sponsorship --> broadcast (13 constraint(s)) =========
-- Requires: sponsorship schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_audience_rating_id` FOREIGN KEY (`audience_rating_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`audience_rating`(`audience_rating_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_live_feed_id` FOREIGN KEY (`live_feed_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`live_feed`(`live_feed_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_audience_rating_id` FOREIGN KEY (`audience_rating_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`audience_rating`(`audience_rating_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`channel`(`channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_live_feed_id` FOREIGN KEY (`live_feed_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`live_feed`(`live_feed_id`);

-- ========= sponsorship --> compliance (17 constraint(s)) =========
-- Requires: sponsorship schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_audit_engagement_id` FOREIGN KEY (`audit_engagement_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`audit_engagement`(`audit_engagement_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_unit` ADD CONSTRAINT `fk_sponsorship_inventory_unit_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`policy`(`policy_id`);

-- ========= sponsorship --> content (9 constraint(s)) =========
-- Requires: sponsorship schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_license_id` FOREIGN KEY (`license_id`) REFERENCES `sports_entertainment_ecm`.`content`.`license`(`license_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_unit` ADD CONSTRAINT `fk_sponsorship_inventory_unit_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);

-- ========= sponsorship --> event (7 constraint(s)) =========
-- Requires: sponsorship schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_activation_fixture_id` FOREIGN KEY (`activation_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_broadcast_window_id` FOREIGN KEY (`broadcast_window_id`) REFERENCES `sports_entertainment_ecm`.`event`.`broadcast_window`(`broadcast_window_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_unit` ADD CONSTRAINT `fk_sponsorship_inventory_unit_type_id` FOREIGN KEY (`type_id`) REFERENCES `sports_entertainment_ecm`.`event`.`type`(`type_id`);

-- ========= sponsorship --> fan (4 constraint(s)) =========
-- Requires: sponsorship schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);

-- ========= sponsorship --> finance (22 constraint(s)) =========
-- Requires: sponsorship schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_revenue_recognition_schedule_id` FOREIGN KEY (`revenue_recognition_schedule_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`(`revenue_recognition_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_revenue_recognition_schedule_id` FOREIGN KEY (`revenue_recognition_schedule_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`(`revenue_recognition_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_revenue_recognition_schedule_id` FOREIGN KEY (`revenue_recognition_schedule_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`(`revenue_recognition_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_revenue_recognition_schedule_id` FOREIGN KEY (`revenue_recognition_schedule_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`(`revenue_recognition_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_revenue_recognition_schedule_id` FOREIGN KEY (`revenue_recognition_schedule_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`(`revenue_recognition_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_unit` ADD CONSTRAINT `fk_sponsorship_inventory_unit_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);

-- ========= sponsorship --> gaming (18 constraint(s)) =========
-- Requires: sponsorship schema, gaming schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`sponsor` ADD CONSTRAINT `fk_sponsorship_sponsor_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_betting_market_id` FOREIGN KEY (`betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_betting_market_id` FOREIGN KEY (`betting_market_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`betting_market`(`betting_market_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`contest`(`contest_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_operator_id` FOREIGN KEY (`operator_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`operator`(`operator_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);

-- ========= sponsorship --> league (29 constraint(s)) =========
-- Requires: sponsorship schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`payment_schedule` ADD CONSTRAINT `fk_sponsorship_payment_schedule_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_unit` ADD CONSTRAINT `fk_sponsorship_inventory_unit_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_unit` ADD CONSTRAINT `fk_sponsorship_inventory_unit_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= sponsorship --> merchandise (1 constraint(s)) =========
-- Requires: sponsorship schema, merchandise schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal_term` ADD CONSTRAINT `fk_sponsorship_deal_term_product_category_id` FOREIGN KEY (`product_category_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`product_category`(`product_category_id`);

-- ========= sponsorship --> security (2 constraint(s)) =========
-- Requires: sponsorship schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);

-- ========= sponsorship --> venue (10 constraint(s)) =========
-- Requires: sponsorship schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`deal` ADD CONSTRAINT `fk_sponsorship_deal_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation` ADD CONSTRAINT `fk_sponsorship_activation_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`activation_fulfillment` ADD CONSTRAINT `fk_sponsorship_activation_fulfillment_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`facility`(`facility_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`naming_right` ADD CONSTRAINT `fk_sponsorship_naming_right_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`ad_inventory` ADD CONSTRAINT `fk_sponsorship_ad_inventory_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_allocation` ADD CONSTRAINT `fk_sponsorship_inventory_allocation_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`performance_metric` ADD CONSTRAINT `fk_sponsorship_performance_metric_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`property` ADD CONSTRAINT `fk_sponsorship_property_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`sponsorship`.`inventory_unit` ADD CONSTRAINT `fk_sponsorship_inventory_unit_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= ticketing --> athlete (6 constraint(s)) =========
-- Requires: ticketing schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`contract`(`contract_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_roster_id` FOREIGN KEY (`roster_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`roster`(`roster_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`contract`(`contract_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_nil_agreement_id` FOREIGN KEY (`nil_agreement_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`nil_agreement`(`nil_agreement_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_roster_id` FOREIGN KEY (`roster_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`roster`(`roster_id`);

-- ========= ticketing --> broadcast (3 constraint(s)) =========
-- Requires: ticketing schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_media_rights_deal_id` FOREIGN KEY (`media_rights_deal_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`media_rights_deal`(`media_rights_deal_id`);

-- ========= ticketing --> compliance (7 constraint(s)) =========
-- Requires: ticketing schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_payment` ADD CONSTRAINT `fk_ticketing_ticket_payment_data_processing_record_id` FOREIGN KEY (`data_processing_record_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`data_processing_record`(`data_processing_record_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);

-- ========= ticketing --> content (10 constraint(s)) =========
-- Requires: ticketing schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order_line` ADD CONSTRAINT `fk_ticketing_ticket_order_line_license_id` FOREIGN KEY (`license_id`) REFERENCES `sports_entertainment_ecm`.`content`.`license`(`license_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order_line` ADD CONSTRAINT `fk_ticketing_ticket_order_line_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order_line` ADD CONSTRAINT `fk_ticketing_ticket_order_line_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_license_id` FOREIGN KEY (`license_id`) REFERENCES `sports_entertainment_ecm`.`content`.`license`(`license_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_platform_channel_id` FOREIGN KEY (`platform_channel_id`) REFERENCES `sports_entertainment_ecm`.`content`.`platform_channel`(`platform_channel_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= ticketing --> event (15 constraint(s)) =========
-- Requires: ticketing schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order_line` ADD CONSTRAINT `fk_ticketing_ticket_order_line_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_type_id` FOREIGN KEY (`type_id`) REFERENCES `sports_entertainment_ecm`.`event`.`type`(`type_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_resale_fixture_id` FOREIGN KEY (`resale_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`gate_scan` ADD CONSTRAINT `fk_ticketing_gate_scan_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`gate_scan` ADD CONSTRAINT `fk_ticketing_gate_scan_production_schedule_id` FOREIGN KEY (`production_schedule_id`) REFERENCES `sports_entertainment_ecm`.`event`.`production_schedule`(`production_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_refund_fixture_id` FOREIGN KEY (`refund_fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_transfer` ADD CONSTRAINT `fk_ticketing_ticket_transfer_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);

-- ========= ticketing --> fan (23 constraint(s)) =========
-- Requires: ticketing schema, fan schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_account_id` FOREIGN KEY (`account_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`account`(`account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`campaign`(`campaign_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`membership`(`membership_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`payment_method`(`payment_method_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order_line` ADD CONSTRAINT `fk_ticketing_ticket_order_line_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_account_id` FOREIGN KEY (`account_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`account`(`account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_account_id` FOREIGN KEY (`account_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`account`(`account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_resale_fan_profile_id` FOREIGN KEY (`resale_fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_loyalty_enrollment_id` FOREIGN KEY (`loyalty_enrollment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`loyalty_enrollment`(`loyalty_enrollment_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_tertiary_access_original_fan_fan_profile_id` FOREIGN KEY (`tertiary_access_original_fan_fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`gate_scan` ADD CONSTRAINT `fk_ticketing_gate_scan_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_payment` ADD CONSTRAINT `fk_ticketing_ticket_payment_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`payment_method`(`payment_method_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_payment` ADD CONSTRAINT `fk_ticketing_ticket_payment_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_refund_fan_profile_id` FOREIGN KEY (`refund_fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_club_id` FOREIGN KEY (`club_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`club`(`club_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`segment`(`segment_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_transfer` ADD CONSTRAINT `fk_ticketing_ticket_transfer_fan_profile_id` FOREIGN KEY (`fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_transfer` ADD CONSTRAINT `fk_ticketing_ticket_transfer_tertiary_ticket_recipient_fan_fan_profile_id` FOREIGN KEY (`tertiary_ticket_recipient_fan_fan_profile_id`) REFERENCES `sports_entertainment_ecm`.`fan`.`fan_profile`(`fan_profile_id`);

-- ========= ticketing --> finance (23 constraint(s)) =========
-- Requires: ticketing schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order_line` ADD CONSTRAINT `fk_ticketing_ticket_order_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_payment` ADD CONSTRAINT `fk_ticketing_ticket_payment_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_payment` ADD CONSTRAINT `fk_ticketing_ticket_payment_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_payment` ADD CONSTRAINT `fk_ticketing_ticket_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_payment` ADD CONSTRAINT `fk_ticketing_ticket_payment_payment_run_id` FOREIGN KEY (`payment_run_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`payment_run`(`payment_run_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);

-- ========= ticketing --> league (22 constraint(s)) =========
-- Requires: ticketing schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_league_schedule_id` FOREIGN KEY (`league_schedule_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league_schedule`(`league_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_season_id` FOREIGN KEY (`season_id`) REFERENCES `sports_entertainment_ecm`.`league`.`season`(`season_id`);

-- ========= ticketing --> merchandise (1 constraint(s)) =========
-- Requires: ticketing schema, merchandise schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `sports_entertainment_ecm`.`merchandise`.`promotion`(`promotion_id`);

-- ========= ticketing --> security (9 constraint(s)) =========
-- Requires: ticketing schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_credential_id` FOREIGN KEY (`credential_id`) REFERENCES `sports_entertainment_ecm`.`security`.`credential`(`credential_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`gate_scan` ADD CONSTRAINT `fk_ticketing_gate_scan_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`gate_scan` ADD CONSTRAINT `fk_ticketing_gate_scan_screening_checkpoint_id` FOREIGN KEY (`screening_checkpoint_id`) REFERENCES `sports_entertainment_ecm`.`security`.`screening_checkpoint`(`screening_checkpoint_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`gate_scan` ADD CONSTRAINT `fk_ticketing_gate_scan_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`refund` ADD CONSTRAINT `fk_ticketing_refund_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_zone` ADD CONSTRAINT `fk_ticketing_price_zone_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);

-- ========= ticketing --> sponsorship (9 constraint(s)) =========
-- Requires: ticketing schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_activation_id` FOREIGN KEY (`activation_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`activation`(`activation_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);

-- ========= ticketing --> venue (21 constraint(s)) =========
-- Requires: ticketing schema, venue schema
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_capacity_config_id` FOREIGN KEY (`capacity_config_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`capacity_config`(`capacity_config_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_seat_id` FOREIGN KEY (`seat_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seat`(`seat_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_inventory` ADD CONSTRAINT `fk_ticketing_ticket_inventory_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order` ADD CONSTRAINT `fk_ticketing_ticket_order_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_order_line` ADD CONSTRAINT `fk_ticketing_ticket_order_line_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_tier` ADD CONSTRAINT `fk_ticketing_price_tier_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_package` ADD CONSTRAINT `fk_ticketing_season_ticket_package_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`season_ticket_account` ADD CONSTRAINT `fk_ticketing_season_ticket_account_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`group_sale` ADD CONSTRAINT `fk_ticketing_group_sale_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`resale` ADD CONSTRAINT `fk_ticketing_resale_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`access_entitlement` ADD CONSTRAINT `fk_ticketing_access_entitlement_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`gate_scan` ADD CONSTRAINT `fk_ticketing_gate_scan_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_capacity_config_id` FOREIGN KEY (`capacity_config_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`capacity_config`(`capacity_config_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_seating_section_id` FOREIGN KEY (`seating_section_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`seating_section`(`seating_section_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`hold_allocation` ADD CONSTRAINT `fk_ticketing_hold_allocation_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`ticket_transfer` ADD CONSTRAINT `fk_ticketing_ticket_transfer_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);
ALTER TABLE `sports_entertainment_ecm`.`ticketing`.`price_zone` ADD CONSTRAINT `fk_ticketing_price_zone_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `sports_entertainment_ecm`.`venue`.`venue`(`venue_id`);

-- ========= venue --> athlete (1 constraint(s)) =========
-- Requires: venue schema, athlete schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_athlete_profile_id` FOREIGN KEY (`athlete_profile_id`) REFERENCES `sports_entertainment_ecm`.`athlete`.`athlete_profile`(`athlete_profile_id`);

-- ========= venue --> broadcast (2 constraint(s)) =========
-- Requires: venue schema, broadcast schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`event_day_ops` ADD CONSTRAINT `fk_venue_event_day_ops_broadcast_schedule_id` FOREIGN KEY (`broadcast_schedule_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`broadcast_schedule`(`broadcast_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_production_id` FOREIGN KEY (`production_id`) REFERENCES `sports_entertainment_ecm`.`broadcast`.`production`(`production_id`);

-- ========= venue --> compliance (19 constraint(s)) =========
-- Requires: venue schema, compliance schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`capacity_config` ADD CONSTRAINT `fk_venue_capacity_config_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`capacity_config` ADD CONSTRAINT `fk_venue_capacity_config_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_audit_engagement_id` FOREIGN KEY (`audit_engagement_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`audit_engagement`(`audit_engagement_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_governing_body_id` FOREIGN KEY (`governing_body_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`governing_body`(`governing_body_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`investigation`(`investigation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`event_day_ops` ADD CONSTRAINT `fk_venue_event_day_ops_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`accessibility_feature` ADD CONSTRAINT `fk_venue_accessibility_feature_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `sports_entertainment_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);

-- ========= venue --> content (2 constraint(s)) =========
-- Requires: venue schema, content schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `sports_entertainment_ecm`.`content`.`asset`(`asset_id`);

-- ========= venue --> event (10 constraint(s)) =========
-- Requires: venue schema, event schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`capacity_config` ADD CONSTRAINT `fk_venue_capacity_config_type_id` FOREIGN KEY (`type_id`) REFERENCES `sports_entertainment_ecm`.`event`.`type`(`type_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `sports_entertainment_ecm`.`event`.`calendar`(`calendar_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`event_day_ops` ADD CONSTRAINT `fk_venue_event_day_ops_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`event_day_ops` ADD CONSTRAINT `fk_venue_event_day_ops_production_schedule_id` FOREIGN KEY (`production_schedule_id`) REFERENCES `sports_entertainment_ecm`.`event`.`production_schedule`(`production_schedule_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_fixture_id` FOREIGN KEY (`fixture_id`) REFERENCES `sports_entertainment_ecm`.`event`.`fixture`(`fixture_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_production_schedule_id` FOREIGN KEY (`production_schedule_id`) REFERENCES `sports_entertainment_ecm`.`event`.`production_schedule`(`production_schedule_id`);

-- ========= venue --> finance (26 constraint(s)) =========
-- Requires: venue schema, finance schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`facility` ADD CONSTRAINT `fk_venue_facility_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`facility` ADD CONSTRAINT `fk_venue_facility_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`facility` ADD CONSTRAINT `fk_venue_facility_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`seating_section` ADD CONSTRAINT `fk_venue_seating_section_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`seat` ADD CONSTRAINT `fk_venue_seat_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`capacity_config` ADD CONSTRAINT `fk_venue_capacity_config_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`event_day_ops` ADD CONSTRAINT `fk_venue_event_day_ops_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`accessibility_feature` ADD CONSTRAINT `fk_venue_accessibility_feature_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`accessibility_feature` ADD CONSTRAINT `fk_venue_accessibility_feature_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`venue` ADD CONSTRAINT `fk_venue_venue_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `sports_entertainment_ecm`.`finance`.`company_code`(`company_code_id`);

-- ========= venue --> gaming (1 constraint(s)) =========
-- Requires: venue schema, gaming schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`facility` ADD CONSTRAINT `fk_venue_facility_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `sports_entertainment_ecm`.`gaming`.`jurisdiction`(`jurisdiction_id`);

-- ========= venue --> league (7 constraint(s)) =========
-- Requires: venue schema, league schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`facility` ADD CONSTRAINT `fk_venue_facility_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`capacity_config` ADD CONSTRAINT `fk_venue_capacity_config_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_franchise_id` FOREIGN KEY (`franchise_id`) REFERENCES `sports_entertainment_ecm`.`league`.`franchise`(`franchise_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`venue` ADD CONSTRAINT `fk_venue_venue_league_id` FOREIGN KEY (`league_id`) REFERENCES `sports_entertainment_ecm`.`league`.`league`(`league_id`);

-- ========= venue --> security (14 constraint(s)) =========
-- Requires: venue schema, security schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`seating_section` ADD CONSTRAINT `fk_venue_seating_section_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_screening_checkpoint_id` FOREIGN KEY (`screening_checkpoint_id`) REFERENCES `sports_entertainment_ecm`.`security`.`screening_checkpoint`(`screening_checkpoint_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_screening_checkpoint_id` FOREIGN KEY (`screening_checkpoint_id`) REFERENCES `sports_entertainment_ecm`.`security`.`screening_checkpoint`(`screening_checkpoint_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`maintenance_work_order` ADD CONSTRAINT `fk_venue_maintenance_work_order_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_inspection` ADD CONSTRAINT `fk_venue_safety_inspection_screening_checkpoint_id` FOREIGN KEY (`screening_checkpoint_id`) REFERENCES `sports_entertainment_ecm`.`security`.`screening_checkpoint`(`screening_checkpoint_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_response_plan`(`emergency_response_plan_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_screening_checkpoint_id` FOREIGN KEY (`screening_checkpoint_id`) REFERENCES `sports_entertainment_ecm`.`security`.`screening_checkpoint`(`screening_checkpoint_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`safety_incident` ADD CONSTRAINT `fk_venue_safety_incident_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `sports_entertainment_ecm`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`event_day_ops` ADD CONSTRAINT `fk_venue_event_day_ops_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_response_plan`(`emergency_response_plan_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`accessibility_feature` ADD CONSTRAINT `fk_venue_accessibility_feature_access_zone_id` FOREIGN KEY (`access_zone_id`) REFERENCES `sports_entertainment_ecm`.`security`.`access_zone`(`access_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`staff_plan` ADD CONSTRAINT `fk_venue_staff_plan_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `sports_entertainment_ecm`.`security`.`emergency_response_plan`(`emergency_response_plan_id`);

-- ========= venue --> sponsorship (5 constraint(s)) =========
-- Requires: venue schema, sponsorship schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`concession_stand` ADD CONSTRAINT `fk_venue_concession_stand_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_deal_id` FOREIGN KEY (`deal_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`deal`(`deal_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`suite` ADD CONSTRAINT `fk_venue_suite_sponsor_id` FOREIGN KEY (`sponsor_id`) REFERENCES `sports_entertainment_ecm`.`sponsorship`.`sponsor`(`sponsor_id`);

-- ========= venue --> ticketing (3 constraint(s)) =========
-- Requires: venue schema, ticketing schema
ALTER TABLE `sports_entertainment_ecm`.`venue`.`seating_section` ADD CONSTRAINT `fk_venue_seating_section_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`price_zone`(`price_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`seat` ADD CONSTRAINT `fk_venue_seat_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`price_zone`(`price_zone_id`);
ALTER TABLE `sports_entertainment_ecm`.`venue`.`parking_lot` ADD CONSTRAINT `fk_venue_parking_lot_price_tier_id` FOREIGN KEY (`price_tier_id`) REFERENCES `sports_entertainment_ecm`.`ticketing`.`price_tier`(`price_tier_id`);

