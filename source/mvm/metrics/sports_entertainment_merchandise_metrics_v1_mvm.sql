-- Metric views for domain: merchandise | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_merch_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Order-level KPIs for merchandise sales across all channels. Covers revenue, discounting, tax, shipping economics, and order mix — the primary steering dashboard for merchandise commercial performance."
  source: "`sports_entertainment_ecm`.`merchandise`.`merch_order`"
  dimensions:
    - name: "channel_type"
      expr: channel_type
      comment: "Top-level sales channel (e.g. online, in-venue, wholesale) used to segment revenue and order volume by go-to-market route."
    - name: "channel_subtype"
      expr: channel_subtype
      comment: "Granular sub-channel within the channel type (e.g. mobile app, kiosk, team store) for detailed channel mix analysis."
    - name: "order_status"
      expr: order_status
      comment: "Current lifecycle status of the order (e.g. confirmed, cancelled, pending) enabling funnel and cancellation analysis."
    - name: "fulfillment_status"
      expr: fulfillment_status
      comment: "Fulfillment state of the order (e.g. shipped, delivered, unfulfilled) for operational throughput monitoring."
    - name: "payment_status"
      expr: payment_status
      comment: "Payment collection status (e.g. paid, refunded, pending) to track cash conversion and payment failure rates."
    - name: "payment_method"
      expr: payment_method
      comment: "Payment instrument used (e.g. credit card, loyalty points, cash) for payment mix and fraud risk analysis."
    - name: "shipping_method"
      expr: shipping_method
      comment: "Shipping method selected by the fan (e.g. standard, express, in-store pickup) for logistics cost attribution."
    - name: "shipping_country_code"
      expr: shipping_country_code
      comment: "Destination country code enabling geographic revenue and shipping cost segmentation."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency revenue reporting and FX exposure monitoring."
    - name: "source_system"
      expr: source_system
      comment: "Originating system (e.g. Shopify, POS, SAP) for data lineage and channel reconciliation."
    - name: "gift_order_flag"
      expr: gift_order_flag
      comment: "Indicates whether the order was placed as a gift, enabling gifting program performance tracking."
    - name: "tax_exempt_flag"
      expr: tax_exempt_flag
      comment: "Flags tax-exempt orders for compliance reporting and net revenue accuracy."
    - name: "order_date_month"
      expr: DATE_TRUNC('MONTH', order_date)
      comment: "Month bucket of the order timestamp for trend analysis and seasonality reporting."
    - name: "order_date_day"
      expr: CAST(order_date AS DATE)
      comment: "Calendar day of the order for daily sales monitoring and event-day spike detection."
  measures:
    - name: "total_orders"
      expr: COUNT(1)
      comment: "Total number of merchandise orders placed. Baseline volume KPI for demand and throughput steering."
    - name: "total_gross_revenue"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Sum of gross order amounts before discounts and returns. Top-line merchandise revenue indicator used in QBRs and board decks."
    - name: "total_net_revenue"
      expr: SUM(CAST(net_total AS DOUBLE))
      comment: "Sum of net order totals after discounts. The primary bottom-line revenue KPI for merchandise P&L management."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total promotional and manual discounts applied across all orders. Tracks promotional spend and margin erosion risk."
    - name: "total_tax_collected"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax collected on merchandise orders. Required for tax remittance compliance and regulatory reporting."
    - name: "total_shipping_revenue"
      expr: SUM(CAST(shipping_amount AS DOUBLE))
      comment: "Total shipping charges billed to fans. Used to assess shipping revenue contribution and cost-to-serve offset."
    - name: "avg_order_value"
      expr: AVG(CAST(net_total AS DOUBLE))
      comment: "Average net order value per transaction. Core commercial KPI for fan spending behaviour and upsell effectiveness."
    - name: "avg_discount_per_order"
      expr: AVG(CAST(discount_amount AS DOUBLE))
      comment: "Average discount applied per order. Signals promotional intensity and potential margin leakage per transaction."
    - name: "discount_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(discount_amount AS DOUBLE)) / NULLIF(SUM(CAST(gross_amount AS DOUBLE)), 0), 2)
      comment: "Discount as a percentage of gross revenue. Executive KPI for promotional efficiency and margin protection decisions."
    - name: "shipping_cost_recovery_pct"
      expr: ROUND(100.0 * SUM(CAST(shipping_amount AS DOUBLE)) / NULLIF(SUM(CAST(net_total AS DOUBLE)), 0), 2)
      comment: "Shipping revenue as a percentage of net order value. Measures how well shipping charges offset logistics costs."
    - name: "gift_order_count"
      expr: COUNT(CASE WHEN gift_order_flag = TRUE THEN 1 END)
      comment: "Number of orders flagged as gifts. Tracks gifting program adoption and seasonal gifting demand."
    - name: "distinct_fans"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Count of unique fans who placed at least one order. Measures fan reach and customer base breadth for the merchandise business."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_order_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Line-item KPIs for merchandise sales. Enables SKU-level, category-level, and channel-level revenue, margin, royalty, and return analysis — the most granular commercial performance layer."
  source: "`sports_entertainment_ecm`.`merchandise`.`order_line`"
  dimensions:
    - name: "sales_channel"
      expr: sales_channel
      comment: "Sales channel for the line item (e.g. ecommerce, in-venue) for channel-level revenue attribution."
    - name: "fulfillment_status"
      expr: fulfillment_status
      comment: "Fulfillment state of the line item for operational throughput and backlog monitoring."
    - name: "fulfillment_location_type"
      expr: fulfillment_location_type
      comment: "Type of fulfillment location (e.g. warehouse, store, venue) for logistics network analysis."
    - name: "return_status"
      expr: return_status
      comment: "Return processing status of the line item for returns management and refund liability tracking."
    - name: "sku_code"
      expr: sku_code
      comment: "SKU identifier for product-level sales and margin analysis."
    - name: "product_name"
      expr: product_name
      comment: "Human-readable product name for business-facing reporting and merchandising decisions."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency line-item revenue reporting."
    - name: "is_personalized"
      expr: is_personalized
      comment: "Flags personalized items (e.g. name/number printing) to track premium customization demand and margin uplift."
    - name: "is_gift"
      expr: is_gift
      comment: "Flags gift line items for gifting program performance analysis."
    - name: "brand_compliance_verified"
      expr: brand_compliance_verified
      comment: "Indicates whether the line item passed brand compliance checks — critical for IP protection and licensing governance."
    - name: "tax_exempt"
      expr: tax_exempt
      comment: "Flags tax-exempt line items for accurate net revenue and compliance reporting."
    - name: "created_date_month"
      expr: DATE_TRUNC('MONTH', created_timestamp)
      comment: "Month bucket of line item creation for trend and seasonality analysis."
  measures:
    - name: "total_line_revenue"
      expr: SUM(CAST(line_total AS DOUBLE))
      comment: "Total revenue across all order lines including tax. Primary SKU-level revenue KPI for merchandising and category management."
    - name: "total_line_subtotal"
      expr: SUM(CAST(line_subtotal AS DOUBLE))
      comment: "Total pre-tax line revenue. Used for net revenue analysis and royalty base calculations."
    - name: "total_line_discount"
      expr: SUM(CAST(line_discount_amount AS DOUBLE))
      comment: "Total discount value applied at line level. Tracks promotional spend and margin erosion at SKU and category granularity."
    - name: "total_line_tax"
      expr: SUM(CAST(line_tax_amount AS DOUBLE))
      comment: "Total tax collected at line level for tax remittance and compliance reporting."
    - name: "total_royalty_amount"
      expr: SUM(CAST(royalty_amount AS DOUBLE))
      comment: "Total royalty obligations generated by merchandise sales. Critical for licensing cost management and licensor payment accuracy."
    - name: "total_unit_cost"
      expr: SUM(CAST(unit_cost AS DOUBLE))
      comment: "Aggregate cost of goods sold at line level. Used for gross margin calculation and supplier cost benchmarking."
    - name: "avg_unit_price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average selling price per unit. Tracks pricing strategy effectiveness and price mix shifts."
    - name: "avg_line_discount_pct"
      expr: AVG(CAST(line_discount_pct AS DOUBLE))
      comment: "Average discount percentage applied at line level. Signals promotional depth and potential margin risk per SKU."
    - name: "gross_margin_amount"
      expr: SUM(CAST(line_subtotal AS DOUBLE) - CAST(unit_cost AS DOUBLE))
      comment: "Gross margin in absolute terms (subtotal minus unit cost) across all lines. Core profitability KPI for merchandise category management."
    - name: "royalty_rate_avg"
      expr: AVG(CAST(royalty_rate AS DOUBLE))
      comment: "Average royalty rate across line items. Used to monitor licensing cost intensity and negotiate future agreement terms."
    - name: "distinct_skus_sold"
      expr: COUNT(DISTINCT sku_code)
      comment: "Number of unique SKUs sold. Measures product assortment breadth and identifies long-tail vs. hero SKU concentration."
    - name: "personalized_line_count"
      expr: COUNT(CASE WHEN is_personalized = TRUE THEN 1 END)
      comment: "Count of personalized order lines. Tracks premium customization demand and associated revenue uplift opportunity."
    - name: "return_eligible_line_count"
      expr: COUNT(CASE WHEN is_return_eligible = TRUE THEN 1 END)
      comment: "Count of lines eligible for return. Quantifies return liability exposure for financial provisioning."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_fulfillment_shipment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Shipment-level KPIs for merchandise fulfillment operations. Covers shipping cost economics, SLA compliance, international shipment mix, and carrier performance — the primary operational dashboard for fulfillment leadership."
  source: "`sports_entertainment_ecm`.`merchandise`.`fulfillment_shipment`"
  dimensions:
    - name: "fulfillment_channel"
      expr: fulfillment_channel
      comment: "Fulfillment channel (e.g. warehouse, store, drop-ship) for network cost and throughput analysis."
    - name: "fulfillment_type"
      expr: fulfillment_type
      comment: "Type of fulfillment (e.g. standard, express, click-and-collect) for service level mix reporting."
    - name: "fulfillment_status"
      expr: fulfillment_status
      comment: "Current fulfillment status (e.g. shipped, delivered, failed) for operational pipeline monitoring."
    - name: "shipment_status"
      expr: shipment_status
      comment: "Carrier-reported shipment status for last-mile delivery performance tracking."
    - name: "carrier_service_level"
      expr: carrier_service_level
      comment: "Carrier service tier (e.g. overnight, ground) for cost-vs-speed trade-off analysis."
    - name: "shipping_country_code"
      expr: shipping_country_code
      comment: "Destination country for geographic shipping cost and international compliance analysis."
    - name: "is_international"
      expr: is_international
      comment: "Flags international shipments for customs, duties, and cross-border logistics cost segmentation."
    - name: "is_partial_fulfillment"
      expr: is_partial_fulfillment
      comment: "Flags partial shipments to track split-fulfillment frequency and associated fan experience impact."
    - name: "sla_breach"
      expr: sla_breach
      comment: "Indicates whether the shipment breached its SLA commitment — key for carrier performance management and fan satisfaction."
    - name: "requires_signature"
      expr: requires_signature
      comment: "Flags shipments requiring signature on delivery for premium/high-value item logistics planning."
    - name: "shipping_cost_currency"
      expr: shipping_cost_currency
      comment: "Currency of shipping cost for multi-currency logistics cost reporting."
    - name: "ship_date_month"
      expr: DATE_TRUNC('MONTH', ship_date)
      comment: "Month bucket of ship date for fulfillment volume trend and seasonal capacity planning."
  measures:
    - name: "total_shipments"
      expr: COUNT(1)
      comment: "Total number of shipments processed. Baseline fulfillment throughput KPI for capacity and operational planning."
    - name: "total_shipping_cost"
      expr: SUM(CAST(shipping_cost AS DOUBLE))
      comment: "Total carrier shipping cost incurred by the business. Primary logistics cost KPI for cost-to-serve and carrier contract management."
    - name: "total_shipping_cost_charged_to_fan"
      expr: SUM(CAST(shipping_cost_charged_to_fan AS DOUBLE))
      comment: "Total shipping cost recovered from fans. Used to calculate net shipping cost burden and pricing strategy effectiveness."
    - name: "net_shipping_cost"
      expr: SUM(CAST(shipping_cost AS DOUBLE) - CAST(shipping_cost_charged_to_fan AS DOUBLE))
      comment: "Net shipping cost borne by the business (total cost minus fan recovery). Directly impacts merchandise margin and informs free-shipping threshold decisions."
    - name: "avg_shipping_cost_per_shipment"
      expr: AVG(CAST(shipping_cost AS DOUBLE))
      comment: "Average shipping cost per shipment. Benchmarks carrier efficiency and informs carrier selection and contract renegotiation."
    - name: "total_quantity_shipped"
      expr: SUM(CAST(quantity_shipped AS DOUBLE))
      comment: "Total units shipped across all shipments. Measures fulfillment output volume for capacity and demand planning."
    - name: "total_declared_customs_value"
      expr: SUM(CAST(declared_customs_value AS DOUBLE))
      comment: "Total declared customs value for international shipments. Required for customs compliance reporting and duties liability estimation."
    - name: "sla_breach_count"
      expr: COUNT(CASE WHEN sla_breach = TRUE THEN 1 END)
      comment: "Number of shipments that breached SLA commitments. Triggers carrier performance reviews and fan compensation decisions."
    - name: "sla_breach_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN sla_breach = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of shipments breaching SLA. Executive KPI for fulfillment quality and carrier contract compliance."
    - name: "international_shipment_count"
      expr: COUNT(CASE WHEN is_international = TRUE THEN 1 END)
      comment: "Number of international shipments. Tracks global fan demand and cross-border logistics complexity."
    - name: "partial_fulfillment_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_partial_fulfillment = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of shipments that are partial fulfillments. High rates signal inventory availability issues and fan experience risk."
    - name: "avg_package_weight_kg"
      expr: AVG(CAST(weight_kg AS DOUBLE))
      comment: "Average shipment weight in kilograms. Used for carrier rate benchmarking and packaging optimisation decisions."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_return_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Return and refund KPIs for merchandise. Covers return volume, refund liability, restocking economics, policy exceptions, and resolution efficiency — essential for margin protection and fan experience management."
  source: "`sports_entertainment_ecm`.`merchandise`.`return_request`"
  dimensions:
    - name: "request_status"
      expr: request_status
      comment: "Current status of the return request (e.g. pending, approved, rejected) for returns pipeline management."
    - name: "return_reason_code"
      expr: return_reason_code
      comment: "Standardised reason code for the return (e.g. defective, wrong item, changed mind) for root cause and quality analysis."
    - name: "resolution_type"
      expr: resolution_type
      comment: "How the return was resolved (e.g. refund, exchange, store credit) for refund liability and fan satisfaction analysis."
    - name: "return_channel"
      expr: return_channel
      comment: "Channel through which the return was initiated (e.g. online, in-store) for returns logistics cost attribution."
    - name: "return_method"
      expr: return_method
      comment: "Physical return method (e.g. mail, drop-off) for reverse logistics cost and process optimisation."
    - name: "refund_method"
      expr: refund_method
      comment: "Refund instrument (e.g. original payment, store credit) for cash flow and liability management."
    - name: "item_condition"
      expr: item_condition
      comment: "Condition of returned item (e.g. new, damaged, used) for restock eligibility and inventory recovery analysis."
    - name: "restock_eligible"
      expr: restock_eligible
      comment: "Flags returns eligible for restocking to quantify inventory recovery value."
    - name: "policy_exception"
      expr: policy_exception
      comment: "Flags returns processed outside standard policy for exception rate monitoring and policy governance."
    - name: "ip_compliance_flag"
      expr: ip_compliance_flag
      comment: "Flags returns with IP compliance concerns (e.g. counterfeit items) for brand protection and legal escalation."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the refund for multi-currency refund liability reporting."
    - name: "request_date_month"
      expr: DATE_TRUNC('MONTH', request_date)
      comment: "Month bucket of return request date for trend analysis and seasonal returns pattern detection."
  measures:
    - name: "total_return_requests"
      expr: COUNT(1)
      comment: "Total number of return requests submitted. Baseline returns volume KPI for operational capacity and policy review."
    - name: "total_refund_amount"
      expr: SUM(CAST(refund_amount AS DOUBLE))
      comment: "Total gross refund value issued. Primary financial liability KPI for returns — directly impacts merchandise net revenue."
    - name: "total_net_refund_amount"
      expr: SUM(CAST(net_refund_amount AS DOUBLE))
      comment: "Total net refund after restocking fees. Measures actual cash outflow from returns for P&L and cash flow management."
    - name: "total_restocking_fee_collected"
      expr: SUM(CAST(restocking_fee AS DOUBLE))
      comment: "Total restocking fees collected from returns. Quantifies fee revenue offsetting reverse logistics costs."
    - name: "avg_refund_amount"
      expr: AVG(CAST(refund_amount AS DOUBLE))
      comment: "Average refund value per return request. Signals average return ticket size and financial exposure per incident."
    - name: "policy_exception_count"
      expr: COUNT(CASE WHEN policy_exception = TRUE THEN 1 END)
      comment: "Number of returns processed as policy exceptions. High counts signal policy gaps or customer service inconsistency requiring governance action."
    - name: "policy_exception_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN policy_exception = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of returns processed outside standard policy. Executive KPI for returns governance and policy compliance."
    - name: "restock_eligible_count"
      expr: COUNT(CASE WHEN restock_eligible = TRUE THEN 1 END)
      comment: "Number of returned items eligible for restocking. Quantifies inventory recovery opportunity and reduces write-off exposure."
    - name: "ip_compliance_flag_count"
      expr: COUNT(CASE WHEN ip_compliance_flag = TRUE THEN 1 END)
      comment: "Number of returns flagged for IP compliance concerns. Triggers brand protection and anti-counterfeiting investigations."
    - name: "distinct_returning_fans"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Count of unique fans submitting return requests. Identifies repeat returners and informs fan-level return policy decisions."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_royalty_payment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Royalty payment KPIs for merchandise licensing. Covers royalty obligations, advance offsets, minimum guarantee tracking, dispute management, and payment compliance — the primary financial governance layer for licensing operations."
  source: "`sports_entertainment_ecm`.`merchandise`.`royalty_payment`"
  dimensions:
    - name: "payment_status"
      expr: payment_status
      comment: "Status of the royalty payment (e.g. paid, pending, disputed) for cash flow and compliance monitoring."
    - name: "licensor_type"
      expr: licensor_type
      comment: "Type of licensor (e.g. athlete, league, franchise) for royalty cost attribution by IP rights holder category."
    - name: "ip_rights_type"
      expr: ip_rights_type
      comment: "Type of intellectual property rights licensed (e.g. name/likeness, logo, trademark) for IP portfolio cost analysis."
    - name: "sales_channel"
      expr: sales_channel
      comment: "Sales channel generating the royalty obligation for channel-level licensing cost attribution."
    - name: "territory_code"
      expr: territory_code
      comment: "Geographic territory of the royalty obligation for international licensing cost management."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the royalty payment for multi-currency licensing cost reporting."
    - name: "payment_method"
      expr: payment_method
      comment: "Payment method used for royalty disbursement for treasury and AP process management."
    - name: "brand_compliance_status"
      expr: brand_compliance_status
      comment: "Brand compliance status of the royalty payment for licensing governance and audit readiness."
    - name: "report_submission_status"
      expr: report_submission_status
      comment: "Status of royalty report submission to licensor for contractual compliance monitoring."
    - name: "audit_flag"
      expr: audit_flag
      comment: "Flags royalty payments under audit for risk management and compliance escalation."
    - name: "reporting_period_start_month"
      expr: DATE_TRUNC('MONTH', reporting_period_start_date)
      comment: "Month bucket of the royalty reporting period start for period-over-period licensing cost trend analysis."
  measures:
    - name: "total_royalty_due"
      expr: SUM(CAST(royalty_due_amount AS DOUBLE))
      comment: "Total royalty amounts due to licensors. Primary licensing cost KPI for P&L management and licensor relationship governance."
    - name: "total_net_royalty_paid"
      expr: SUM(CAST(net_royalty_paid_amount AS DOUBLE))
      comment: "Total net royalties actually paid after adjustments and advance offsets. Measures actual cash outflow for licensing obligations."
    - name: "total_gross_sales"
      expr: SUM(CAST(gross_sales_amount AS DOUBLE))
      comment: "Total gross sales base used for royalty calculation. Validates royalty computation accuracy against sales records."
    - name: "total_net_sales"
      expr: SUM(CAST(net_sales_amount AS DOUBLE))
      comment: "Total net sales after returns and allowances used as royalty base. Core input for royalty obligation accuracy."
    - name: "total_advance_offset"
      expr: SUM(CAST(advance_offset_amount AS DOUBLE))
      comment: "Total advance payments offset against royalty obligations. Tracks recoupment progress against licensing advances."
    - name: "total_minimum_guarantee"
      expr: SUM(CAST(minimum_guarantee_amount AS DOUBLE))
      comment: "Total minimum guaranteed royalty commitments. Quantifies fixed licensing cost floor regardless of sales performance."
    - name: "total_adjustment_amount"
      expr: SUM(CAST(adjustment_amount AS DOUBLE))
      comment: "Total royalty adjustments (credits/debits). Signals reconciliation activity and potential disputes requiring management attention."
    - name: "total_returns_allowances"
      expr: SUM(CAST(returns_allowances_amount AS DOUBLE))
      comment: "Total returns and allowances deducted from royalty base. Measures the impact of merchandise returns on licensing obligations."
    - name: "avg_royalty_rate"
      expr: AVG(CAST(royalty_rate AS DOUBLE))
      comment: "Average royalty rate across all payments. Benchmarks licensing cost intensity and informs future agreement negotiations."
    - name: "effective_royalty_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(royalty_due_amount AS DOUBLE)) / NULLIF(SUM(CAST(net_sales_amount AS DOUBLE)), 0), 2)
      comment: "Effective royalty rate as royalty due divided by net sales. Measures true licensing cost burden relative to revenue — key for margin management."
    - name: "audit_flagged_payment_count"
      expr: COUNT(CASE WHEN audit_flag = TRUE THEN 1 END)
      comment: "Number of royalty payments flagged for audit. Triggers compliance review and licensor dispute resolution processes."
    - name: "distinct_licensing_agreements"
      expr: COUNT(DISTINCT licensing_agreement_id)
      comment: "Number of distinct licensing agreements generating royalty payments. Measures licensing portfolio breadth and obligation complexity."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_inventory_position`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Inventory position KPIs for merchandise. Covers stock availability, inventory value, shrinkage, transfer activity, and reorder health — the primary operational dashboard for inventory planning and working capital management."
  source: "`sports_entertainment_ecm`.`merchandise`.`inventory_position`"
  dimensions:
    - name: "location_type"
      expr: location_type
      comment: "Type of inventory location (e.g. warehouse, retail store, venue kiosk) for network-level stock distribution analysis."
    - name: "location_code"
      expr: location_code
      comment: "Specific location identifier for granular stock position monitoring and replenishment decisions."
    - name: "sku_code"
      expr: sku_code
      comment: "SKU identifier for product-level inventory position and availability analysis."
    - name: "position_status"
      expr: position_status
      comment: "Status of the inventory position (e.g. active, blocked, in-transit) for availability and operational readiness monitoring."
    - name: "valuation_method"
      expr: valuation_method
      comment: "Inventory valuation method (e.g. FIFO, LIFO, weighted average) for financial reporting consistency."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of inventory valuation for multi-currency working capital reporting."
    - name: "is_consignment"
      expr: is_consignment
      comment: "Flags consignment inventory to separate owned vs. consigned stock for balance sheet accuracy."
    - name: "is_event_allocated"
      expr: is_event_allocated
      comment: "Flags inventory allocated to specific events for event-day stock availability planning."
    - name: "transfer_status"
      expr: transfer_status
      comment: "Status of in-transit inventory transfers for supply chain visibility and receiving planning."
    - name: "last_movement_type"
      expr: last_movement_type
      comment: "Type of last inventory movement (e.g. sale, receipt, adjustment) for stock activity pattern analysis."
    - name: "snapshot_month"
      expr: DATE_TRUNC('MONTH', snapshot_timestamp)
      comment: "Month bucket of the inventory snapshot for period-over-period stock level trend analysis."
  measures:
    - name: "total_inventory_value"
      expr: SUM(CAST(inventory_value AS DOUBLE))
      comment: "Total value of on-hand inventory at cost. Primary working capital KPI for finance and supply chain leadership."
    - name: "avg_unit_cost"
      expr: AVG(CAST(unit_cost AS DOUBLE))
      comment: "Average unit cost across inventory positions. Used for COGS estimation and supplier cost benchmarking."
    - name: "total_shrinkage_value"
      expr: SUM(CAST(unit_cost AS DOUBLE))
      comment: "Proxy for total inventory cost exposure across positions. Used alongside shrinkage_qty for loss quantification and security investment decisions."
    - name: "consignment_inventory_value"
      expr: SUM(CASE WHEN is_consignment = TRUE THEN CAST(inventory_value AS DOUBLE) ELSE 0 END)
      comment: "Total value of consignment inventory. Separates owned vs. consigned stock for accurate balance sheet and liability reporting."
    - name: "event_allocated_inventory_value"
      expr: SUM(CASE WHEN is_event_allocated = TRUE THEN CAST(inventory_value AS DOUBLE) ELSE 0 END)
      comment: "Total value of inventory allocated to events. Tracks event-day stock commitment and availability risk."
    - name: "distinct_skus_in_stock"
      expr: COUNT(DISTINCT sku_code)
      comment: "Number of unique SKUs with active inventory positions. Measures assortment breadth and product range availability."
    - name: "distinct_stocked_locations"
      expr: COUNT(DISTINCT location_code)
      comment: "Number of distinct locations holding inventory. Measures distribution network reach and stock deployment breadth."
    - name: "total_inventory_positions"
      expr: COUNT(1)
      comment: "Total number of inventory position records. Baseline measure for inventory complexity and data completeness monitoring."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_licensing_agreement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Licensing agreement portfolio KPIs. Covers agreement economics, royalty rate benchmarking, exclusivity mix, advance commitments, and compliance posture — essential for IP portfolio governance and licensing strategy decisions."
  source: "`sports_entertainment_ecm`.`merchandise`.`licensing_agreement`"
  dimensions:
    - name: "agreement_status"
      expr: agreement_status
      comment: "Current status of the licensing agreement (e.g. active, expired, terminated) for portfolio health monitoring."
    - name: "agreement_type"
      expr: agreement_type
      comment: "Type of licensing agreement (e.g. athlete, league, franchise) for IP portfolio segmentation and cost attribution."
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Permitted distribution channel under the agreement for channel-level licensing coverage analysis."
    - name: "territory_code"
      expr: territory_code
      comment: "Geographic territory covered by the agreement for international licensing portfolio management."
    - name: "exclusivity_scope"
      expr: exclusivity_scope
      comment: "Scope of exclusivity granted (e.g. exclusive, non-exclusive, category-exclusive) for competitive positioning analysis."
    - name: "is_exclusive"
      expr: is_exclusive
      comment: "Flags exclusive agreements for premium IP cost and competitive advantage tracking."
    - name: "royalty_reporting_frequency"
      expr: royalty_reporting_frequency
      comment: "Frequency of royalty reporting required (e.g. monthly, quarterly) for compliance calendar management."
    - name: "currency_code"
      expr: currency_code
      comment: "Agreement currency for multi-currency licensing commitment reporting."
    - name: "renewal_option"
      expr: renewal_option
      comment: "Flags agreements with renewal options for proactive portfolio renewal planning."
    - name: "sublicensing_permitted"
      expr: sublicensing_permitted
      comment: "Flags agreements permitting sublicensing for revenue sharing and IP monetisation opportunity tracking."
    - name: "effective_start_month"
      expr: DATE_TRUNC('MONTH', effective_start_date)
      comment: "Month bucket of agreement effective start for portfolio vintage and cohort analysis."
  measures:
    - name: "total_agreements"
      expr: COUNT(1)
      comment: "Total number of licensing agreements in the portfolio. Baseline KPI for IP portfolio scale and complexity management."
    - name: "total_minimum_guaranteed_royalty"
      expr: SUM(CAST(minimum_guaranteed_royalty AS DOUBLE))
      comment: "Total minimum guaranteed royalty commitments across all agreements. Quantifies fixed licensing cost floor for financial planning."
    - name: "total_advance_payment"
      expr: SUM(CAST(advance_payment AS DOUBLE))
      comment: "Total advance payments committed under licensing agreements. Tracks upfront IP investment and recoupment exposure."
    - name: "avg_royalty_rate_pct"
      expr: AVG(CAST(royalty_rate_pct AS DOUBLE))
      comment: "Average royalty rate across the licensing portfolio. Benchmarks licensing cost intensity and informs negotiation strategy."
    - name: "max_royalty_rate_pct"
      expr: MAX(CAST(royalty_rate_pct AS DOUBLE))
      comment: "Maximum royalty rate in the portfolio. Identifies highest-cost licensing relationships for renegotiation prioritisation."
    - name: "exclusive_agreement_count"
      expr: COUNT(CASE WHEN is_exclusive = TRUE THEN 1 END)
      comment: "Number of exclusive licensing agreements. Tracks competitive IP lock-up and associated premium cost commitments."
    - name: "exclusive_agreement_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_exclusive = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of agreements that are exclusive. Measures exclusivity intensity in the IP portfolio for competitive strategy decisions."
    - name: "renewal_option_count"
      expr: COUNT(CASE WHEN renewal_option = TRUE THEN 1 END)
      comment: "Number of agreements with renewal options. Quantifies portfolio renewal pipeline for proactive licensing management."
    - name: "total_insurance_required_amount"
      expr: SUM(CAST(insurance_required_amount AS DOUBLE))
      comment: "Total insurance coverage required across licensing agreements. Tracks risk management obligations and insurance cost exposure."
    - name: "distinct_territories"
      expr: COUNT(DISTINCT territory_code)
      comment: "Number of distinct territories covered by licensing agreements. Measures global IP licensing reach and market coverage."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_sku_catalog`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "SKU catalog KPIs for merchandise product portfolio management. Covers pricing benchmarks, cost structure, royalty rates, product mix, and compliance posture — the primary product management and assortment planning dashboard."
  source: "`sports_entertainment_ecm`.`merchandise`.`sku_catalog`"
  dimensions:
    - name: "product_type"
      expr: product_type
      comment: "Product type classification (e.g. apparel, collectible, equipment) for assortment mix and category strategy analysis."
    - name: "lifecycle_status"
      expr: lifecycle_status
      comment: "Product lifecycle stage (e.g. active, discontinued, pre-launch) for portfolio health and range rationalisation."
    - name: "brand_name"
      expr: brand_name
      comment: "Brand associated with the SKU for brand portfolio performance and licensing attribution."
    - name: "gender_target"
      expr: gender_target
      comment: "Target gender demographic for the SKU for assortment inclusivity and demand segmentation."
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "Manufacturing country for supply chain risk, tariff exposure, and ethical sourcing compliance."
    - name: "sales_channel_availability"
      expr: sales_channel_availability
      comment: "Channels where the SKU is available for sale for channel assortment coverage analysis."
    - name: "is_limited_edition"
      expr: is_limited_edition
      comment: "Flags limited edition SKUs for scarcity-driven pricing and demand forecasting."
    - name: "is_autographed"
      expr: is_autographed
      comment: "Flags autographed merchandise for premium pricing and authentication compliance tracking."
    - name: "is_game_used"
      expr: is_game_used
      comment: "Flags game-used memorabilia for premium valuation and authentication requirement monitoring."
    - name: "license_required"
      expr: license_required
      comment: "Flags SKUs requiring a licensing agreement for IP compliance and unlicensed product risk management."
    - name: "brand_compliance_approved"
      expr: brand_compliance_approved
      comment: "Flags SKUs with brand compliance approval for go-to-market readiness and compliance governance."
    - name: "launch_date_month"
      expr: DATE_TRUNC('MONTH', launch_date)
      comment: "Month bucket of SKU launch date for new product introduction cadence and launch performance analysis."
  measures:
    - name: "total_active_skus"
      expr: COUNT(1)
      comment: "Total number of SKUs in the catalog. Baseline assortment breadth KPI for product portfolio management."
    - name: "avg_msrp"
      expr: AVG(CAST(msrp AS DOUBLE))
      comment: "Average manufacturer suggested retail price across the catalog. Tracks pricing tier mix and premium product penetration."
    - name: "avg_cost_price"
      expr: AVG(CAST(cost_price AS DOUBLE))
      comment: "Average cost price across SKUs. Benchmarks COGS structure and informs margin management decisions."
    - name: "avg_gross_margin_per_sku"
      expr: AVG(CAST(msrp AS DOUBLE) - CAST(cost_price AS DOUBLE))
      comment: "Average gross margin per SKU (MSRP minus cost price). Measures product-level profitability and pricing adequacy."
    - name: "avg_royalty_rate"
      expr: AVG(CAST(royalty_rate AS DOUBLE))
      comment: "Average royalty rate across SKUs. Tracks licensing cost intensity at product level for margin management."
    - name: "limited_edition_sku_count"
      expr: COUNT(CASE WHEN is_limited_edition = TRUE THEN 1 END)
      comment: "Number of limited edition SKUs in the catalog. Tracks scarcity product strategy and premium revenue opportunity."
    - name: "compliance_approved_sku_count"
      expr: COUNT(CASE WHEN brand_compliance_approved = TRUE THEN 1 END)
      comment: "Number of SKUs with brand compliance approval. Measures go-to-market readiness and compliance governance effectiveness."
    - name: "compliance_approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN brand_compliance_approved = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of SKUs with brand compliance approval. Executive KPI for IP protection and licensing governance readiness."
    - name: "licensed_sku_count"
      expr: COUNT(CASE WHEN license_required = TRUE THEN 1 END)
      comment: "Number of SKUs requiring a licensing agreement. Quantifies licensed product portfolio scope and associated royalty obligation exposure."
    - name: "distinct_brands"
      expr: COUNT(DISTINCT brand_name)
      comment: "Number of distinct brands in the SKU catalog. Measures brand portfolio breadth and licensing relationship diversity."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`merchandise_supplier`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Supplier performance and risk KPIs for merchandise procurement. Covers quality, delivery reliability, ethical sourcing compliance, and cost benchmarking — the primary supplier management dashboard for procurement and compliance leadership."
  source: "`sports_entertainment_ecm`.`merchandise`.`supplier`"
  dimensions:
    - name: "supplier_status"
      expr: supplier_status
      comment: "Current status of the supplier (e.g. active, suspended, under review) for supplier base health monitoring."
    - name: "supplier_type"
      expr: supplier_type
      comment: "Type of supplier (e.g. manufacturer, distributor, licensee) for supply chain segmentation and risk profiling."
    - name: "country_code"
      expr: country_code
      comment: "Supplier country for geographic supply chain risk, tariff exposure, and ethical sourcing analysis."
    - name: "region"
      expr: region
      comment: "Supplier region for regional supply chain concentration risk and sourcing strategy decisions."
    - name: "ethical_sourcing_certified"
      expr: ethical_sourcing_certified
      comment: "Flags suppliers with ethical sourcing certification for ESG compliance and brand reputation risk management."
    - name: "preferred_supplier_flag"
      expr: preferred_supplier_flag
      comment: "Flags preferred suppliers for procurement prioritisation and volume concentration analysis."
    - name: "is_licensed_producer"
      expr: is_licensed_producer
      comment: "Flags suppliers authorised as licensed producers for IP compliance and unlicensed production risk monitoring."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Trade terms (e.g. FOB, CIF, DDP) for logistics cost attribution and risk transfer analysis."
  measures:
    - name: "total_suppliers"
      expr: COUNT(1)
      comment: "Total number of suppliers in the base. Baseline KPI for supply chain scale and single-source concentration risk."
    - name: "avg_quality_rating_score"
      expr: AVG(CAST(quality_rating_score AS DOUBLE))
      comment: "Average quality rating across suppliers. Primary supplier performance KPI for procurement decisions and contract renewals."
    - name: "avg_on_time_delivery_rate"
      expr: AVG(CAST(on_time_delivery_rate AS DOUBLE))
      comment: "Average on-time delivery rate across suppliers. Measures supply chain reliability and informs safety stock and lead time planning."
    - name: "avg_defect_rate"
      expr: AVG(CAST(defect_rate AS DOUBLE))
      comment: "Average product defect rate across suppliers. Tracks quality risk and drives supplier development or disqualification decisions."
    - name: "avg_royalty_rate"
      expr: AVG(CAST(royalty_rate AS DOUBLE))
      comment: "Average royalty rate charged by suppliers. Benchmarks licensing cost at supplier level for contract negotiation."
    - name: "ethical_sourcing_certified_count"
      expr: COUNT(CASE WHEN ethical_sourcing_certified = TRUE THEN 1 END)
      comment: "Number of ethically certified suppliers. Tracks ESG compliance posture and brand reputation risk in the supply chain."
    - name: "ethical_sourcing_certification_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN ethical_sourcing_certified = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of suppliers with ethical sourcing certification. Executive ESG KPI for supply chain sustainability governance."
    - name: "preferred_supplier_count"
      expr: COUNT(CASE WHEN preferred_supplier_flag = TRUE THEN 1 END)
      comment: "Number of preferred suppliers. Measures strategic supplier concentration and procurement programme effectiveness."
    - name: "licensed_producer_count"
      expr: COUNT(CASE WHEN is_licensed_producer = TRUE THEN 1 END)
      comment: "Number of suppliers authorised as licensed producers. Quantifies licensed supply chain coverage and unlicensed production risk exposure."
$$;
