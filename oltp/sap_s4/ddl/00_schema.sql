-- =========================================================================
-- sap_s4 -- SAP S/4HANA (FI/CO/MM/SD)
--
-- Named in the upstream model as "SAP S/4HANA (FI/CO/MM/SD - Financial
-- Accounting; Controlling; Materials Management; Sales and Distribution)".
--
-- Owns 33 of the 153 in-scope MVM tables -- the largest share of any system:
-- all 14 of `finance`, the league org structure, merchandise costing and
-- stock, SAP PM maintenance orders, and every contract that carries money.
--
-- Native idiom modeled here, and it is genuinely different from the other
-- nine schemas:
--
--   * Real SAP table names. `bkpf` and `bseg`, not `journal_header` and
--     `journal_line`. Anyone who has to build the extract will be reading SAP
--     documentation, not this file, so the names have to match.
--   * MANDT, the client field, as the leading column of every primary key.
--     This is the single most distinctive thing about an SAP schema and the
--     commonest reason a naive extract returns three times too many rows: a
--     system carries production (100), test and training clients in the same
--     tables.
--   * Composite CHAR business keys, not surrogate integers. A document is
--     identified by (MANDT, BUKRS, BELNR, GJAHR) -- client, company code,
--     document number, fiscal year -- and the document number only resets
--     uniquely within a company code and year.
--   * Fixed-width CHAR, not VARCHAR. SAP pads. An extract that does not trim
--     will not join to anything.
--   * Amounts always paired with a currency key (WAERS), because a company
--     code posts in its local currency and the group reports in another.
--
-- The target model's uniform BIGINT surrogate keys and single amount columns
-- are the clearest illustration in the whole project of integration work being
-- done: none of that shape exists here.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS sap_s4;

COMMENT ON SCHEMA sap_s4 IS
    'SAP S/4HANA FI/CO/MM/SD -- general ledger, receivables, payables, assets, '
    'materials, stock, pricing, contracts and plant maintenance. System of '
    'record for finance.* and the league org structure. Extract pattern: CDC '
    'log. Every table is keyed on MANDT; extracts must filter to one client.';
