-- =========================================================================
-- OFF-Ball -- ordered loader for the whole source OLTP model
--
-- Usage, from the repository root:
--
--     psql -v ON_ERROR_STOP=1 -f sql/00_create_all.sql
--
-- or against the docker-compose database:
--
--     psql "postgresql://offball:offball@localhost:55432/offball" \
--          -v ON_ERROR_STOP=1 -f sql/00_create_all.sql
--
-- Paths use \ir, which resolves relative to this file, so the script works
-- from any working directory.
--
-- Order matters in two ways:
--
--   1. `common` first. Every system schema declares columns on the shared
--      DOMAIN types, so the types have to exist before any table does.
--   2. Within a schema, tables before constraints. Foreign keys are declared
--      in 50_constraints.sql once every table in the schema exists, which is
--      what lets a single ordered pass work without deferred constraints or
--      a dependency sort.
--
-- The schemas themselves are independent: no schema references another, by
-- design. Cross-system references are business keys resolved through
-- common.entity_xref, so the ten systems can be loaded in any order.
-- =========================================================================

\set ON_ERROR_STOP on
\timing off

\echo '==> common (domains, source-system registry, identity resolution)'
\ir 01_common.sql
\ir 02_common_comments.sql

\echo '==> sap_s4 (SAP S/4HANA FI/CO/MM/SD)'
\ir ../oltp/sap_s4/ddl/00_schema.sql
\ir ../oltp/sap_s4/ddl/20_reference.sql
\ir ../oltp/sap_s4/ddl/30_master.sql
\ir ../oltp/sap_s4/ddl/40_transaction.sql
\ir ../oltp/sap_s4/ddl/50_constraints.sql
\ir ../oltp/sap_s4/ddl/60_indexes.sql
\ir ../oltp/sap_s4/ddl/70_audit.sql
\ir ../oltp/sap_s4/ddl/80_comments.sql

\echo '==> tm_axs (Ticketmaster / AXS)'
\ir ../oltp/tm_axs/ddl/00_schema.sql
\ir ../oltp/tm_axs/ddl/10_domains_and_enums.sql
\ir ../oltp/tm_axs/ddl/20_reference.sql
\ir ../oltp/tm_axs/ddl/30_master.sql
\ir ../oltp/tm_axs/ddl/31_master_pii.sql
\ir ../oltp/tm_axs/ddl/40_transaction.sql
\ir ../oltp/tm_axs/ddl/50_constraints.sql
\ir ../oltp/tm_axs/ddl/60_indexes.sql
\ir ../oltp/tm_axs/ddl/70_audit.sql
\ir ../oltp/tm_axs/ddl/80_comments.sql

\echo '==> archtics (Archtics)'
\ir ../oltp/archtics/ddl/00_schema.sql
\ir ../oltp/archtics/ddl/20_reference.sql
\ir ../oltp/archtics/ddl/30_master.sql
\ir ../oltp/archtics/ddl/40_transaction.sql
\ir ../oltp/archtics/ddl/50_constraints.sql
\ir ../oltp/archtics/ddl/60_indexes.sql
\ir ../oltp/archtics/ddl/70_audit.sql
\ir ../oltp/archtics/ddl/80_comments.sql

\echo '==> sfdc_crm (Salesforce CRM)'
\ir ../oltp/sfdc_crm/ddl/00_schema.sql
\ir ../oltp/sfdc_crm/ddl/20_reference.sql
\ir ../oltp/sfdc_crm/ddl/30_master.sql
\ir ../oltp/sfdc_crm/ddl/31_master_pii.sql
\ir ../oltp/sfdc_crm/ddl/40_transaction.sql
\ir ../oltp/sfdc_crm/ddl/50_constraints.sql
\ir ../oltp/sfdc_crm/ddl/60_indexes.sql
\ir ../oltp/sfdc_crm/ddl/70_audit.sql
\ir ../oltp/sfdc_crm/ddl/80_comments.sql

\echo '==> shopify (Shopify Plus)'
\ir ../oltp/shopify/ddl/00_schema.sql
\ir ../oltp/shopify/ddl/30_master.sql
\ir ../oltp/shopify/ddl/40_transaction.sql
\ir ../oltp/shopify/ddl/50_constraints.sql
\ir ../oltp/shopify/ddl/60_indexes.sql
\ir ../oltp/shopify/ddl/70_audit.sql
\ir ../oltp/shopify/ddl/80_comments.sql

\echo '==> adobe_aep (Adobe Experience Platform)'
\ir ../oltp/adobe_aep/ddl/00_schema.sql
\ir ../oltp/adobe_aep/ddl/20_reference.sql
\ir ../oltp/adobe_aep/ddl/30_master.sql
\ir ../oltp/adobe_aep/ddl/40_transaction.sql
\ir ../oltp/adobe_aep/ddl/50_constraints.sql
\ir ../oltp/adobe_aep/ddl/60_indexes.sql
\ir ../oltp/adobe_aep/ddl/70_audit.sql
\ir ../oltp/adobe_aep/ddl/80_comments.sql

\echo '==> hudl (SportsCode / Hudl)'
\ir ../oltp/hudl/ddl/00_schema.sql
\ir ../oltp/hudl/ddl/30_master.sql
\ir ../oltp/hudl/ddl/40_transaction.sql
\ir ../oltp/hudl/ddl/50_constraints.sql
\ir ../oltp/hudl/ddl/60_indexes.sql
\ir ../oltp/hudl/ddl/70_audit.sql
\ir ../oltp/hudl/ddl/80_comments.sql

\echo '==> dalet (Dalet Galaxy)'
\ir ../oltp/dalet/ddl/00_schema.sql
\ir ../oltp/dalet/ddl/30_master.sql
\ir ../oltp/dalet/ddl/40_transaction.sql
\ir ../oltp/dalet/ddl/50_constraints.sql
\ir ../oltp/dalet/ddl/60_indexes.sql
\ir ../oltp/dalet/ddl/70_audit.sql
\ir ../oltp/dalet/ddl/80_comments.sql

\echo '==> sap_sfsf (SAP SuccessFactors)'
\ir ../oltp/sap_sfsf/ddl/00_schema.sql
\ir ../oltp/sap_sfsf/ddl/30_master.sql
\ir ../oltp/sap_sfsf/ddl/40_transaction.sql
\ir ../oltp/sap_sfsf/ddl/50_constraints.sql
\ir ../oltp/sap_sfsf/ddl/60_indexes.sql
\ir ../oltp/sap_sfsf/ddl/70_audit.sql
\ir ../oltp/sap_sfsf/ddl/80_comments.sql

\echo '==> workday_ap (Workday Adaptive Planning)'
\ir ../oltp/workday_ap/ddl/00_schema.sql
\ir ../oltp/workday_ap/ddl/30_master.sql
\ir ../oltp/workday_ap/ddl/40_transaction.sql
\ir ../oltp/workday_ap/ddl/50_constraints.sql
\ir ../oltp/workday_ap/ddl/60_indexes.sql
\ir ../oltp/workday_ap/ddl/70_audit.sql
\ir ../oltp/workday_ap/ddl/80_comments.sql

\echo ''
\echo '==> load complete. Object counts:'
SELECT n.nspname AS schema,
       count(*) FILTER (WHERE NOT c.relispartition) AS tables,
       count(*) FILTER (WHERE c.relispartition)     AS partitions
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r', 'p')
  AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
GROUP BY ROLLUP (n.nspname)
ORDER BY n.nspname NULLS LAST;
