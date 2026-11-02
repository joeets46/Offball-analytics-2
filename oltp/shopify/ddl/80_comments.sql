-- =========================================================================
-- shopify -- table comments
-- =========================================================================

COMMENT ON TABLE shopify.location IS
    'Stock and fulfilment locations. Feeds target merchandise.retail_location; a location can hold stock, fulfil orders, both or neither.';
COMMENT ON TABLE shopify.collection_product IS
    'Explicit collection membership. Smart collections have none, so target merchandise.product_category cannot be fully populated from this table alone.';
COMMENT ON TABLE shopify.inventory_item IS
    'The stock-keeping entity behind a variant, carrying the only unit cost Shopify holds. The SAP moving average price is the authoritative one.';
COMMENT ON TABLE shopify.customer_address IS
    'Customer address book. Distinct from the shipping address copied onto an order, which must not change when the book is later edited.';
COMMENT ON TABLE shopify.discount_code IS
    'Discount codes, matched case-insensitively at checkout.';
COMMENT ON TABLE shopify.shipping_line IS
    'Shipping charges on an order, before and after discount.';
COMMENT ON TABLE shopify.fulfillment IS
    'Shipments. One order line can be fulfilled across several shipments from several locations; the target model has one shipment row per line.';
COMMENT ON TABLE shopify.fulfillment_line_item IS
    'Which lines, and how many units, went in which shipment.';
COMMENT ON TABLE shopify.refund IS
    'Refunds. The restock flag is the difference between a return and a write-off.';
COMMENT ON TABLE shopify.refund_line_item IS
    'Refunded lines with their restock disposition.';
COMMENT ON TABLE shopify.return_request IS
    'The customer-initiated return, distinct from the refund that settles it. Declined returns are the informative ones: a personalised shirt cannot come back.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE shopify.shop IS
    'The storefront. A Plus account runs several -- one per market or team -- and the target model has no concept of them at all.';
COMMENT ON TABLE shopify.product_variant IS
    'The sellable item, and the grain of target merchandise.sku_catalog. Variant axes are three fixed option slots rather than a normalized option table, which is Shopify, not a simplification.';
COMMENT ON TABLE shopify.collection IS
    'Product collections. A smart collection is a stored rule with no membership rows, so target merchandise.product_category cannot be fully populated from membership alone.';
COMMENT ON TABLE shopify.inventory_level IS
    'Stock per item and location. Available is deliberately allowed to go negative: a variant with a continue inventory policy oversells by design.';
COMMENT ON TABLE shopify.customer IS
    'Storefront customers. The redacted marketing state is a completed GDPR erasure and must not be loaded as a marketable state.';
COMMENT ON TABLE shopify.sales_order IS
    'Orders, with three independent lifecycle axes -- money, goods and existence -- that move separately. The target model has a single status column.';
COMMENT ON TABLE shopify.line_item IS
    'Order lines. Title and SKU are copied onto the line so a product deleted afterwards does not take the order history with it.';
COMMENT ON TABLE shopify.price_rule IS
    'Discount rules. The value is negative by Shopify convention, and inverting the sign on load turns a discount into a surcharge.';
COMMENT ON TABLE shopify.discount_application IS
    'Which discount hit which line and for how much. The only place promotion effectiveness can be measured; neither target table retains it.';
COMMENT ON TABLE shopify.transaction IS
    'Payment attempts. Test-mode rows are real rows with no money behind them, so an extract that does not exclude them inflates revenue.';
COMMENT ON TABLE shopify.return_line_item IS
    'Returned lines with reason and received condition. Separating too-small from too-large is what makes the data actionable on the size curve.';
