-- =========================================================================
-- workday_ap -- Workday Adaptive Planning
--
-- Named in the upstream model as "Workday Adaptive Planning (Financial
-- Planning and Analysis)".
--
-- Owns 2 of the 153 in-scope MVM tables -- target finance.budget and
-- target athlete.salary_cap_entry -- which makes it the smallest system in
-- the model. TIER B: abbreviated DDL.
--
-- Small, but structurally unlike every other schema here, and that is why it
-- earns its place:
--
--   * It is a CUBE, not a set of business entities. There is one fact table,
--     cell_value, addressed by a sparse combination of dimensions. Nothing in
--     it corresponds to a business document.
--   * Versions are first-class. The same account, level and period hold a
--     different number in Actuals, Budget, Forecast and each what-if
--     scenario. Target finance.budget has one amount column, so the extract
--     must choose a version -- and choosing wrong turns a forecast into a
--     commitment.
--   * Time is a dimension member, not a date. A plan period is "FY26 Q3",
--     which may not align with any calendar quarter.
--   * Values are signed by convention per account type, not absolutely:
--     revenue is negative in many Adaptive models. This is the single most
--     common sign error in FP&A integration.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS workday_ap;

COMMENT ON SCHEMA workday_ap IS
    'Workday Adaptive Planning -- planning cube: versions, accounts, levels, '
    'dimensions, time periods and cell values. System of record for budget '
    'and forward-looking plans. Extract pattern: API snapshot per version. '
    'TIER B: abbreviated depth.';
