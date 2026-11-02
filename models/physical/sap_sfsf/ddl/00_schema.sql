-- =========================================================================
-- sap_sfsf -- SAP SuccessFactors (Employee Central)
--
-- Named in the upstream model as "SAP SuccessFactors (Human Capital
-- Management - Recruitment; Payroll; Talent)".
--
-- Owns 7 of the 153 in-scope MVM tables. TIER B: abbreviated DDL -- the key
-- entities with full keys and constraints, and representative rather than
-- exhaustive column sets. The plan scopes depth to the core revenue and
-- operations path, and HCM is adjacent to it.
--
-- What it owns is nonetheless important: SuccessFactors holds the athlete as
-- a PERSON. target athlete.athlete_profile maps here, not to Hudl, because
-- Hudl knows a performer and this knows a human being with a date of birth, a
-- nationality and a contract.
--
-- Native idiom modeled here:
--   * The Employee Central effective-dated model. Almost nothing is a simple
--     row: an employment, a job assignment and a compensation record each have
--     an effective-start date as part of the key, and the "current" record is
--     the one whose window contains today. This is the single most important
--     property of the schema and the commonest source of duplicated rows in a
--     naive extract.
--   * The person / employment separation. A person can have several
--     employments -- a player who retires and returns as a coach is the same
--     person with two employments, and treating them as two people loses the
--     career.
--   * MDF-style string keys rather than integers.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS sap_sfsf;

COMMENT ON SCHEMA sap_sfsf IS
    'SAP SuccessFactors Employee Central -- person, employment, job, position '
    'and compensation, plus recruiting. System of record for athlete identity '
    'and workforce planning. Effective-dated throughout. Extract pattern: API '
    'incremental on last_modified_on. TIER B: abbreviated depth.';
