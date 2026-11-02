-- =========================================================================
-- shopify -- Shopify Plus
--
-- Named in the upstream model as "Shopify Plus (Merchandise E-Commerce
-- Platform)".
--
-- Owns 8 of the 153 in-scope MVM tables: the storefront half of
-- `merchandise`. The other half -- stock, costing and supplier settlement --
-- belongs to SAP, and the split between them runs straight through the
-- merchandise domain.
--
-- Native idiom modeled here:
--   * IDs are platform-assigned BIGINTs, NOT identity columns. This is the
--     sharpest contrast with tm_axs in the whole model: Shopify is SaaS, the
--     replica receives ids it did not mint, and so every key here is
--     client-supplied. An extract target that declares IDENTITY would reject
--     the data.
--   * `admin_graphql_api_id`, the gid:// string form of the same id. Both
--     forms circulate through the API and webhooks.
--   * Money as NUMERIC with an explicit currency, though the REST API returns
--     it as a decimal string -- which is a standing source of float errors in
--     naive integrations.
--   * Soft lifecycle rather than deletion: `published_at`, `cancelled_at`,
--     `closed_at`, `archived`. Shopify rarely removes a row.
--   * Metafields: arbitrary key-value extension, which is where every
--     retailer puts the attributes the platform does not model. Stored as
--     JSONB-backed rows here rather than pretending they are columns.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS shopify;

COMMENT ON SCHEMA shopify IS
    'Shopify Plus -- storefront catalog, orders, fulfilment and returns. '
    'System of record for the sellable side of merchandise.*; SAP owns stock '
    'and costing. Extract pattern: webhooks for near-real-time plus a '
    'reconciling API sweep on updated_at.';
