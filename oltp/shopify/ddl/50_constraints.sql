-- =========================================================================
-- shopify -- foreign keys
--
-- Two shapes to note:
--
--   * line_item.variant_id and line_item.product_id are nullable and
--     ON DELETE SET NULL. A product removed from the catalog after it was
--     ordered must not take the order line with it, which is why the title
--     and sku are copied onto the line.
--   * metafield.owner_id is polymorphic across six resource types and cannot
--     be constrained at all.
-- =========================================================================

ALTER TABLE shopify.location
    ADD CONSTRAINT fk_location_shop
        FOREIGN KEY (shop_id) REFERENCES shopify.shop (id) ON DELETE CASCADE;

ALTER TABLE shopify.product
    ADD CONSTRAINT fk_product_shop
        FOREIGN KEY (shop_id) REFERENCES shopify.shop (id) ON DELETE CASCADE;

ALTER TABLE shopify.product_variant
    ADD CONSTRAINT fk_variant_product
        FOREIGN KEY (product_id) REFERENCES shopify.product (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_variant_inventory_item
        FOREIGN KEY (inventory_item_id) REFERENCES shopify.inventory_item (id)
        ON DELETE RESTRICT;

ALTER TABLE shopify.collection
    ADD CONSTRAINT fk_collection_shop
        FOREIGN KEY (shop_id) REFERENCES shopify.shop (id) ON DELETE CASCADE;

ALTER TABLE shopify.collection_product
    ADD CONSTRAINT fk_collection_product_collection
        FOREIGN KEY (collection_id) REFERENCES shopify.collection (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_collection_product_product
        FOREIGN KEY (product_id) REFERENCES shopify.product (id) ON DELETE CASCADE;

ALTER TABLE shopify.inventory_level
    ADD CONSTRAINT fk_inventory_level_item
        FOREIGN KEY (inventory_item_id) REFERENCES shopify.inventory_item (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_inventory_level_location
        FOREIGN KEY (location_id) REFERENCES shopify.location (id) ON DELETE CASCADE;

ALTER TABLE shopify.customer
    ADD CONSTRAINT fk_customer_shop
        FOREIGN KEY (shop_id) REFERENCES shopify.shop (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_customer_default_address
        FOREIGN KEY (default_address_id) REFERENCES shopify.customer_address (id)
        ON DELETE SET NULL;

ALTER TABLE shopify.customer_address
    ADD CONSTRAINT fk_customer_address_customer
        FOREIGN KEY (customer_id) REFERENCES shopify.customer (id) ON DELETE CASCADE;

ALTER TABLE shopify.price_rule
    ADD CONSTRAINT fk_price_rule_shop
        FOREIGN KEY (shop_id) REFERENCES shopify.shop (id) ON DELETE CASCADE;

ALTER TABLE shopify.discount_code
    ADD CONSTRAINT fk_discount_code_price_rule
        FOREIGN KEY (price_rule_id) REFERENCES shopify.price_rule (id) ON DELETE CASCADE;

-- -------------------------------------------------------------------------
-- Orders.
-- -------------------------------------------------------------------------
ALTER TABLE shopify.sales_order
    ADD CONSTRAINT fk_order_shop
        FOREIGN KEY (shop_id) REFERENCES shopify.shop (id) ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES shopify.customer (id) ON DELETE SET NULL;

-- A deleted product leaves its order lines intact: the line carries its own
-- copy of the title and sku precisely so that this is safe.
ALTER TABLE shopify.line_item
    ADD CONSTRAINT fk_line_item_order
        FOREIGN KEY (order_id) REFERENCES shopify.sales_order (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_line_item_variant
        FOREIGN KEY (variant_id) REFERENCES shopify.product_variant (id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_line_item_product
        FOREIGN KEY (product_id) REFERENCES shopify.product (id) ON DELETE SET NULL;

ALTER TABLE shopify.shipping_line
    ADD CONSTRAINT fk_shipping_line_order
        FOREIGN KEY (order_id) REFERENCES shopify.sales_order (id) ON DELETE CASCADE;

ALTER TABLE shopify.discount_application
    ADD CONSTRAINT fk_discount_app_order
        FOREIGN KEY (order_id) REFERENCES shopify.sales_order (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_discount_app_line_item
        FOREIGN KEY (line_item_id) REFERENCES shopify.line_item (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_discount_app_code
        FOREIGN KEY (discount_code_id) REFERENCES shopify.discount_code (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_discount_app_price_rule
        FOREIGN KEY (price_rule_id) REFERENCES shopify.price_rule (id)
        ON DELETE RESTRICT;

ALTER TABLE shopify.fulfillment
    ADD CONSTRAINT fk_fulfillment_order
        FOREIGN KEY (order_id) REFERENCES shopify.sales_order (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_fulfillment_location
        FOREIGN KEY (location_id) REFERENCES shopify.location (id) ON DELETE RESTRICT;

ALTER TABLE shopify.fulfillment_line_item
    ADD CONSTRAINT fk_fli_fulfillment
        FOREIGN KEY (fulfillment_id) REFERENCES shopify.fulfillment (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_fli_line_item
        FOREIGN KEY (line_item_id) REFERENCES shopify.line_item (id) ON DELETE CASCADE;

-- Payment records are never cascade-deleted.
ALTER TABLE shopify.transaction
    ADD CONSTRAINT fk_transaction_order
        FOREIGN KEY (order_id) REFERENCES shopify.sales_order (id) ON DELETE RESTRICT,
    ADD CONSTRAINT fk_transaction_parent
        FOREIGN KEY (parent_id) REFERENCES shopify.transaction (id) ON DELETE RESTRICT;

ALTER TABLE shopify.refund
    ADD CONSTRAINT fk_refund_order
        FOREIGN KEY (order_id) REFERENCES shopify.sales_order (id) ON DELETE RESTRICT;

ALTER TABLE shopify.refund_line_item
    ADD CONSTRAINT fk_rli_refund
        FOREIGN KEY (refund_id) REFERENCES shopify.refund (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_rli_line_item
        FOREIGN KEY (line_item_id) REFERENCES shopify.line_item (id) ON DELETE RESTRICT,
    ADD CONSTRAINT fk_rli_location
        FOREIGN KEY (location_id) REFERENCES shopify.location (id) ON DELETE RESTRICT;

ALTER TABLE shopify.return_request
    ADD CONSTRAINT fk_return_order
        FOREIGN KEY (order_id) REFERENCES shopify.sales_order (id) ON DELETE RESTRICT;

ALTER TABLE shopify.return_line_item
    ADD CONSTRAINT fk_return_line_return
        FOREIGN KEY (return_id) REFERENCES shopify.return_request (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_return_line_line_item
        FOREIGN KEY (line_item_id) REFERENCES shopify.line_item (id) ON DELETE RESTRICT;

-- shopify.metafield.owner_id is polymorphic across six resource types and is
-- therefore deliberately unconstrained.
