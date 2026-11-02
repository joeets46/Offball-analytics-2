-- =========================================================================
-- workday_ap -- table comments
-- =========================================================================

COMMENT ON TABLE workday_ap.dimension IS
    'User-defined cube axes. A sports organisation plans by fixture, competition, sponsor and squad, and none of those are accounts or levels.';
COMMENT ON TABLE workday_ap.plan IS
    'A named planning exercise -- the annual budget round, a reforecast, a salary-cap plan. Supplies the metadata target finance.budget needs beyond the numbers.';
COMMENT ON TABLE workday_ap.allocation_rule IS
    'How a cost pool is split across levels: evenly, by a driver, or by fixed percentages. No target counterpart, so an allocated figure arrives unexplained.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE workday_ap.model IS
    'A planning model -- a workspace with its own dimensions, accounts and versions. Its fiscal calendar need not match the SAP one, and when they differ a period remap is required.';
COMMENT ON TABLE workday_ap.account IS
    'The planning chart of accounts. The sign-flip flag prevents the commonest FP&A integration error: revenue is stored negative in many Adaptive models.';
COMMENT ON TABLE workday_ap.level IS
    'The organisational dimension. A rollup level holds no input of its own, so loading rollups alongside leaves double counts.';
COMMENT ON TABLE workday_ap.dimension_value IS
    'Dimension members. A member is usually a business entity from another system -- a fixture, a player, a sponsor -- and the external reference is how a planning cell resolves to anything real.';
