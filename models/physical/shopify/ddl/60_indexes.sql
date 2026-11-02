-- =========================================================================
-- shopify -- indexes
--
-- The extract here is two-part: webhooks deliver changes in near-real time,
-- and a reconciling sweep on updated_at catches whatever the webhooks dropped
-- (they are at-least-once but not guaranteed). So every extracted table needs
-- its updated_at index, and they are not an afterthought.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Catalog.
-- -------------------------------------------------------------------------
CREATE INDEX ix_location_shop        ON shopify.location (shop_id);
CREATE INDEX ix_location_sap         ON shopify.location (sap_werks) WHERE sap_werks IS NOT NULL;

CREATE INDEX ix_product_shop         ON shopify.product (shop_id);
CREATE INDEX ix_product_published
    ON shopify.product (shop_id, published_at) WHERE status = 'active';
CREATE INDEX ix_product_vendor       ON shopify.product (shop_id, vendor);
CREATE INDEX ix_product_type         ON shopify.product (shop_id, product_type);

CREATE INDEX ix_variant_product      ON shopify.product_variant (product_id, position);
CREATE INDEX ix_variant_sku          ON shopify.product_variant (sku) WHERE sku IS NOT NULL;
CREATE INDEX ix_variant_barcode      ON shopify.product_variant (barcode) WHERE barcode IS NOT NULL;
CREATE INDEX ix_variant_inventory_item ON shopify.product_variant (inventory_item_id);
-- Resolution against the SAP material master.
CREATE INDEX ix_variant_sap          ON shopify.product_variant (sap_matnr) WHERE sap_matnr IS NOT NULL;

CREATE INDEX ix_collection_shop      ON shopify.collection (shop_id);
CREATE INDEX ix_collection_product_product ON shopify.collection_product (product_id);

CREATE INDEX ix_inventory_item_sku   ON shopify.inventory_item (sku) WHERE sku IS NOT NULL;
CREATE INDEX ix_inventory_level_location ON shopify.inventory_level (location_id);
-- Oversold positions: negative availability, which only happens under a
-- `continue` inventory policy and is worth watching.
CREATE INDEX ix_inventory_level_oversold
    ON shopify.inventory_level (location_id, inventory_item_id) WHERE available < 0;

-- -------------------------------------------------------------------------
-- Customers.
-- -------------------------------------------------------------------------
CREATE INDEX ix_customer_shop        ON shopify.customer (shop_id);
CREATE INDEX ix_customer_email       ON shopify.customer (email) WHERE email IS NOT NULL;
CREATE INDEX ix_customer_phone       ON shopify.customer (phone) WHERE phone IS NOT NULL;
CREATE INDEX ix_customer_default_address
    ON shopify.customer (default_address_id) WHERE default_address_id IS NOT NULL;
-- Identity resolution outward.
CREATE INDEX ix_customer_sfdc        ON shopify.customer (sfdc_contact_id) WHERE sfdc_contact_id IS NOT NULL;
CREATE INDEX ix_customer_aep         ON shopify.customer (aep_ecid) WHERE aep_ecid IS NOT NULL;
-- The marketable population.
CREATE INDEX ix_customer_marketable
    ON shopify.customer (shop_id) WHERE email_marketing_state = 'subscribed';
CREATE INDEX ix_customer_address_customer ON shopify.customer_address (customer_id);

CREATE INDEX ix_price_rule_shop      ON shopify.price_rule (shop_id);
CREATE INDEX ix_price_rule_active    ON shopify.price_rule (starts_at, ends_at);
CREATE INDEX ix_discount_code_price_rule ON shopify.discount_code (price_rule_id);

-- Polymorphic owner, so the type has to lead the index.
CREATE INDEX ix_metafield_owner      ON shopify.metafield (owner_resource, owner_id);
CREATE INDEX ix_metafield_namespace  ON shopify.metafield (namespace, key);

-- -------------------------------------------------------------------------
-- Orders. The three independent lifecycle axes each get their own path.
-- -------------------------------------------------------------------------
CREATE INDEX ix_order_shop_created   ON shopify.sales_order (shop_id, created_at DESC);
CREATE INDEX ix_order_customer       ON shopify.sales_order (customer_id) WHERE customer_id IS NOT NULL;
CREATE INDEX ix_order_email          ON shopify.sales_order (email) WHERE email IS NOT NULL;
-- Unpaid orders.
CREATE INDEX ix_order_unpaid
    ON shopify.sales_order (shop_id, created_at)
    WHERE financial_status IN ('pending', 'authorized', 'partially_paid');
-- Unfulfilled orders: the warehouse pick list.
CREATE INDEX ix_order_unfulfilled
    ON shopify.sales_order (shop_id, created_at)
    WHERE fulfillment_status IS NULL OR fulfillment_status IN ('unfulfilled', 'partial');
CREATE INDEX ix_order_cancelled      ON shopify.sales_order (cancelled_at) WHERE cancelled_at IS NOT NULL;
-- Revenue not yet recognised in SAP.
CREATE INDEX ix_order_awaiting_sap
    ON shopify.sales_order (shop_id, created_at)
    WHERE sap_vbeln IS NULL AND financial_status = 'paid';
CREATE INDEX ix_order_sap            ON shopify.sales_order (sap_vbeln) WHERE sap_vbeln IS NOT NULL;

CREATE INDEX ix_line_item_order      ON shopify.line_item (order_id);
CREATE INDEX ix_line_item_variant    ON shopify.line_item (variant_id) WHERE variant_id IS NOT NULL;
CREATE INDEX ix_line_item_product    ON shopify.line_item (product_id) WHERE product_id IS NOT NULL;
CREATE INDEX ix_line_item_sku        ON shopify.line_item (sku) WHERE sku IS NOT NULL;
-- Personalised lines, which are non-returnable. GIN because properties is JSONB.
CREATE INDEX ix_line_item_properties
    ON shopify.line_item USING GIN (properties) WHERE properties IS NOT NULL;

CREATE INDEX ix_shipping_line_order  ON shopify.shipping_line (order_id);

CREATE INDEX ix_discount_app_order   ON shopify.discount_application (order_id);
CREATE INDEX ix_discount_app_line    ON shopify.discount_application (line_item_id)
    WHERE line_item_id IS NOT NULL;
-- Promotion effectiveness: what each code actually cost.
CREATE INDEX ix_discount_app_code    ON shopify.discount_application (discount_code_id)
    WHERE discount_code_id IS NOT NULL;
CREATE INDEX ix_discount_app_rule    ON shopify.discount_application (price_rule_id)
    WHERE price_rule_id IS NOT NULL;

CREATE INDEX ix_fulfillment_order    ON shopify.fulfillment (order_id);
CREATE INDEX ix_fulfillment_location ON shopify.fulfillment (location_id) WHERE location_id IS NOT NULL;
CREATE INDEX ix_fulfillment_tracking ON shopify.fulfillment (tracking_number) WHERE tracking_number IS NOT NULL;
-- In-transit shipments, for the delivery-performance report.
CREATE INDEX ix_fulfillment_in_transit
    ON shopify.fulfillment (created_at)
    WHERE status = 'success' AND delivered_at IS NULL;
CREATE INDEX ix_fli_fulfillment      ON shopify.fulfillment_line_item (fulfillment_id);
CREATE INDEX ix_fli_line_item        ON shopify.fulfillment_line_item (line_item_id);

CREATE INDEX ix_transaction_order    ON shopify.transaction (order_id, created_at);
CREATE INDEX ix_transaction_parent   ON shopify.transaction (parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX ix_transaction_gateway  ON shopify.transaction (gateway, created_at);
-- Failed payments, excluding test-mode noise.
CREATE INDEX ix_transaction_failures
    ON shopify.transaction (created_at, error_code)
    WHERE status IN ('failure', 'error') AND NOT test;

CREATE INDEX ix_refund_order         ON shopify.refund (order_id);
CREATE INDEX ix_refund_processed     ON shopify.refund (processed_at);
CREATE INDEX ix_rli_refund           ON shopify.refund_line_item (refund_id);
CREATE INDEX ix_rli_line_item        ON shopify.refund_line_item (line_item_id);
CREATE INDEX ix_rli_location         ON shopify.refund_line_item (location_id) WHERE location_id IS NOT NULL;

CREATE INDEX ix_return_order         ON shopify.return_request (order_id);
CREATE INDEX ix_return_open          ON shopify.return_request (requested_at)
    WHERE status IN ('requested', 'open');
CREATE INDEX ix_return_line_return   ON shopify.return_line_item (return_id);
CREATE INDEX ix_return_line_line_item ON shopify.return_line_item (line_item_id);
-- The size curve: which sizes come back and in which direction.
CREATE INDEX ix_return_line_reason   ON shopify.return_line_item (return_reason);

-- -------------------------------------------------------------------------
-- Reconciling sweep. Webhooks are at-least-once but not guaranteed, so the
-- updated_at sweep is the safety net and needs an index on every table it
-- reads.
-- -------------------------------------------------------------------------
CREATE INDEX ix_product_updated_at   ON shopify.product (updated_at);
CREATE INDEX ix_variant_updated_at   ON shopify.product_variant (updated_at);
CREATE INDEX ix_inventory_item_updated_at ON shopify.inventory_item (updated_at);
CREATE INDEX ix_inventory_level_updated_at ON shopify.inventory_level (updated_at);
CREATE INDEX ix_customer_updated_at  ON shopify.customer (updated_at);
CREATE INDEX ix_order_updated_at     ON shopify.sales_order (updated_at);
CREATE INDEX ix_line_item_updated_at ON shopify.line_item (updated_at);
CREATE INDEX ix_fulfillment_updated_at ON shopify.fulfillment (updated_at);
CREATE INDEX ix_return_updated_at    ON shopify.return_request (updated_at);
CREATE INDEX ix_collection_updated_at ON shopify.collection (updated_at);
CREATE INDEX ix_price_rule_updated_at ON shopify.price_rule (updated_at);
