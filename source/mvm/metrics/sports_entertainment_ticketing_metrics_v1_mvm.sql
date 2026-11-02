-- Metric views for domain: ticketing | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_ticket_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core ticketing revenue and order performance metrics. Tracks gross revenue, service fees, discounts, refunds, and order mix across channels, franchises, and pricing models. Primary steering dashboard for ticketing revenue management."
  source: "`sports_entertainment_ecm`.`ticketing`.`ticket_order`"
  dimensions:
    - name: "sales_channel_code"
      expr: sales_channel_code
      comment: "Channel through which the ticket order was placed (e.g. web, mobile, box office, kiosk). Used to evaluate channel mix and optimize distribution strategy."
    - name: "order_status"
      expr: order_status
      comment: "Current lifecycle status of the order (e.g. confirmed, cancelled, pending). Enables funnel and cancellation analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO currency code for the order. Supports multi-currency revenue reporting."
    - name: "delivery_method"
      expr: delivery_method
      comment: "Ticket delivery method (e.g. mobile, print-at-home, will-call). Informs fulfillment cost and fan experience strategy."
    - name: "pricing_model"
      expr: pricing_model
      comment: "Pricing model applied to the order (e.g. fixed, dynamic). Used to evaluate dynamic pricing adoption and revenue uplift."
    - name: "resale_flag"
      expr: resale_flag
      comment: "Indicates whether the order is a resale transaction. Separates primary and secondary market revenue."
    - name: "ppv_flag"
      expr: ppv_flag
      comment: "Indicates whether the order is a pay-per-view purchase. Segments digital vs. live attendance revenue."
    - name: "payment_status"
      expr: payment_status
      comment: "Payment collection status of the order. Identifies unpaid or failed payment orders for collections follow-up."
    - name: "order_purchase_date"
      expr: DATE_TRUNC('day', purchase_timestamp)
      comment: "Date the order was purchased, truncated to day. Enables daily sales trend analysis."
    - name: "order_purchase_month"
      expr: DATE_TRUNC('month', purchase_timestamp)
      comment: "Month the order was purchased. Supports monthly revenue cadence reporting."
    - name: "ticket_tier"
      expr: ticket_tier
      comment: "Tier classification of tickets in the order (e.g. premium, standard, GA). Supports tier-mix and yield analysis."
    - name: "accessible_seating_flag"
      expr: accessible_seating_flag
      comment: "Indicates whether the order includes ADA-accessible seating. Supports compliance and accessibility reporting."
  measures:
    - name: "total_orders"
      expr: COUNT(DISTINCT ticket_order_id)
      comment: "Total number of distinct ticket orders placed. Baseline volume KPI for ticketing demand."
    - name: "gross_ticket_revenue"
      expr: SUM(CAST(order_total_amount AS DOUBLE))
      comment: "Total gross revenue from all ticket orders including fees and taxes. Primary top-line revenue KPI for ticketing."
    - name: "total_face_value_revenue"
      expr: SUM(CAST(face_value_amount AS DOUBLE))
      comment: "Sum of face value amounts across all orders, excluding fees and taxes. Measures pure ticket revenue before add-ons."
    - name: "total_service_fee_revenue"
      expr: SUM(CAST(service_fee_amount AS DOUBLE))
      comment: "Total service fees collected across all orders. Service fees are a high-margin revenue stream tracked separately."
    - name: "total_tax_collected"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount collected across all orders. Required for tax remittance and compliance reporting."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discounts applied across all orders. Tracks promotional spend and discount exposure."
    - name: "total_refund_amount"
      expr: SUM(CAST(refund_amount AS DOUBLE))
      comment: "Total refund amounts issued against ticket orders. High refund volume signals event cancellations or fan dissatisfaction."
    - name: "avg_order_value"
      expr: AVG(CAST(order_total_amount AS DOUBLE))
      comment: "Average total order value. Key yield metric — rising AOV indicates upsell effectiveness or premium mix shift."
    - name: "avg_face_value_per_order"
      expr: AVG(CAST(face_value_amount AS DOUBLE))
      comment: "Average face value per order. Benchmarks pricing tier effectiveness and demand elasticity."
    - name: "cancelled_orders"
      expr: COUNT(DISTINCT CASE WHEN order_status = 'cancelled' THEN ticket_order_id END)
      comment: "Number of cancelled orders. Elevated cancellation rates trigger operational and pricing reviews."
    - name: "resale_order_count"
      expr: COUNT(DISTINCT CASE WHEN resale_flag = TRUE THEN ticket_order_id END)
      comment: "Number of resale orders. Tracks secondary market activity volume for revenue share and compliance monitoring."
    - name: "unique_buyers"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Number of distinct fans who placed at least one order. Measures audience reach and fan acquisition."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_ticket_order_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Line-level ticket economics and fulfillment metrics. Provides granular seat-level revenue, fee, and discount analysis by price zone, section, and delivery method. Enables yield management and inventory monetization analysis."
  source: "`sports_entertainment_ecm`.`ticketing`.`ticket_order_line`"
  dimensions:
    - name: "ticket_type"
      expr: ticket_type
      comment: "Type of ticket on the line (e.g. adult, child, VIP, comp). Drives ticket mix and yield analysis."
    - name: "line_status"
      expr: line_status
      comment: "Current status of the order line (e.g. active, cancelled, refunded). Enables line-level fulfillment tracking."
    - name: "delivery_method"
      expr: delivery_method
      comment: "Delivery method for this ticket line. Supports fulfillment cost and digital adoption analysis."
    - name: "delivery_status"
      expr: delivery_status
      comment: "Delivery fulfillment status of the ticket line. Identifies undelivered tickets requiring intervention."
    - name: "sales_channel"
      expr: sales_channel
      comment: "Sales channel for this line item. Enables channel-level yield and margin analysis."
    - name: "seat_section"
      expr: seat_section
      comment: "Seating section for the ticket. Supports section-level revenue and demand analysis."
    - name: "is_comp"
      expr: is_comp
      comment: "Indicates whether the ticket is a complimentary (zero-revenue) ticket. Tracks comp exposure against paid inventory."
    - name: "is_resale"
      expr: is_resale
      comment: "Indicates whether the line is a resale ticket. Separates primary and secondary market line economics."
    - name: "is_ada_accessible"
      expr: is_ada_accessible
      comment: "Indicates ADA-accessible seating on this line. Supports accessibility compliance reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency for this line item. Supports multi-currency revenue analysis."
    - name: "issued_date"
      expr: DATE_TRUNC('day', issued_timestamp)
      comment: "Date the ticket was issued. Enables daily issuance volume and revenue trend analysis."
    - name: "issued_month"
      expr: DATE_TRUNC('month', issued_timestamp)
      comment: "Month the ticket was issued. Supports monthly revenue cadence and seasonal demand analysis."
  measures:
    - name: "total_line_revenue"
      expr: SUM(CAST(line_total AS DOUBLE))
      comment: "Total revenue across all ticket order lines. Granular revenue KPI at the seat level."
    - name: "total_face_value"
      expr: SUM(CAST(face_value AS DOUBLE))
      comment: "Sum of face values across all ticket lines. Measures base ticket revenue before fees and discounts."
    - name: "total_service_fees"
      expr: SUM(CAST(service_fee AS DOUBLE))
      comment: "Total service fees collected at the line level. High-margin ancillary revenue stream."
    - name: "total_facility_fees"
      expr: SUM(CAST(facility_fee AS DOUBLE))
      comment: "Total facility fees collected at the line level. Venue cost recovery metric."
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax collected at the line level. Required for tax compliance and remittance."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discounts applied at the line level. Tracks promotional and comp discount exposure."
    - name: "total_dynamic_price_revenue"
      expr: SUM(CAST(dynamic_price AS DOUBLE))
      comment: "Total revenue captured via dynamic pricing. Measures incremental yield from dynamic pricing strategy."
    - name: "avg_face_value_per_ticket"
      expr: AVG(CAST(face_value AS DOUBLE))
      comment: "Average face value per ticket line. Core yield metric for pricing strategy evaluation."
    - name: "avg_dynamic_price_per_ticket"
      expr: AVG(CAST(dynamic_price AS DOUBLE))
      comment: "Average dynamic price per ticket. Benchmarks dynamic pricing uplift vs. face value."
    - name: "comp_ticket_lines"
      expr: COUNT(DISTINCT CASE WHEN is_comp = TRUE THEN ticket_order_line_id END)
      comment: "Number of complimentary ticket lines. Tracks comp inventory usage and its revenue opportunity cost."
    - name: "total_ticket_lines"
      expr: COUNT(DISTINCT ticket_order_line_id)
      comment: "Total number of ticket order lines. Baseline volume metric for seat-level demand."
    - name: "resale_original_price_total"
      expr: SUM(CAST(resale_original_price AS DOUBLE))
      comment: "Sum of original face values for resale tickets. Enables price uplift calculation vs. resale sale price."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_ticket_payment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Ticket payment collection, fraud, and settlement metrics. Tracks gross payment volume, refunds, fraud scores, and payment method mix. Critical for treasury, fraud operations, and payment processor performance management."
  source: "`sports_entertainment_ecm`.`ticketing`.`ticket_payment`"
  dimensions:
    - name: "payment_status"
      expr: payment_status
      comment: "Current status of the payment (e.g. captured, failed, refunded, disputed). Drives collections and reconciliation workflows."
    - name: "payment_method_type"
      expr: payment_method_type
      comment: "Type of payment method used (e.g. credit card, debit, wallet, installment). Informs payment mix and processing cost strategy."
    - name: "payment_channel"
      expr: payment_channel
      comment: "Channel through which payment was processed (e.g. web, mobile, POS). Supports channel-level payment performance analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO currency code for the payment. Supports multi-currency treasury reporting."
    - name: "card_network"
      expr: card_network
      comment: "Card network used (e.g. Visa, Mastercard, Amex). Informs interchange cost and network fee negotiations."
    - name: "chargeback_status"
      expr: chargeback_status
      comment: "Chargeback status of the payment. Elevated chargeback rates trigger fraud and dispute management reviews."
    - name: "is_recurring"
      expr: is_recurring
      comment: "Indicates whether the payment is part of a recurring installment plan. Tracks installment plan adoption and collection risk."
    - name: "wallet_provider"
      expr: wallet_provider
      comment: "Digital wallet provider used (e.g. Apple Pay, Google Pay). Tracks digital wallet adoption trends."
    - name: "settlement_date"
      expr: settlement_date
      comment: "Date the payment was settled. Enables cash flow and settlement timing analysis."
    - name: "settlement_month"
      expr: DATE_TRUNC('month', CAST(settlement_date AS TIMESTAMP))
      comment: "Month of payment settlement. Supports monthly cash flow and treasury reporting."
    - name: "is_3ds_authenticated"
      expr: is_3ds_authenticated
      comment: "Indicates whether 3D Secure authentication was used. Tracks fraud prevention coverage."
  measures:
    - name: "total_gross_payment_amount"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross payment amount collected. Primary cash collection KPI for ticketing treasury."
    - name: "total_net_payment_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net payment amount after fees and deductions. Measures actual cash retained by the organization."
    - name: "total_refund_amount"
      expr: SUM(CAST(refund_amount AS DOUBLE))
      comment: "Total refunds issued against payments. High refund volume signals event disruptions or fraud exposure."
    - name: "total_service_fee_collected"
      expr: SUM(CAST(service_fee_amount AS DOUBLE))
      comment: "Total service fees collected at payment level. Ancillary revenue stream tracked for margin analysis."
    - name: "total_tax_collected"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax collected at payment level. Required for tax remittance compliance."
    - name: "avg_fraud_score"
      expr: AVG(CAST(fraud_score AS DOUBLE))
      comment: "Average fraud risk score across payments. Rising average fraud score triggers fraud operations review and rule tightening."
    - name: "avg_exchange_rate"
      expr: AVG(CAST(exchange_rate AS DOUBLE))
      comment: "Average exchange rate applied across multi-currency payments. Supports FX exposure monitoring."
    - name: "total_payments"
      expr: COUNT(DISTINCT ticket_payment_id)
      comment: "Total number of payment transactions. Baseline volume metric for payment operations."
    - name: "failed_payments"
      expr: COUNT(DISTINCT CASE WHEN payment_status = 'failed' THEN ticket_payment_id END)
      comment: "Number of failed payment transactions. High failure rates indicate processor issues or fraud friction."
    - name: "avg_gross_payment_amount"
      expr: AVG(CAST(gross_amount AS DOUBLE))
      comment: "Average gross payment amount per transaction. Benchmarks transaction size trends for yield and fraud monitoring."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_refund`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Refund volume, value, and SLA performance metrics. Tracks refund exposure by type, reason, and event origin. Enables finance, operations, and compliance teams to manage refund liability and service quality."
  source: "`sports_entertainment_ecm`.`ticketing`.`refund`"
  dimensions:
    - name: "refund_status"
      expr: refund_status
      comment: "Current status of the refund (e.g. approved, pending, rejected, completed). Drives refund queue management."
    - name: "refund_type"
      expr: refund_type
      comment: "Type of refund (e.g. full, partial, service fee only). Informs refund policy and liability analysis."
    - name: "reason_code"
      expr: reason_code
      comment: "Reason code for the refund (e.g. event cancelled, fan request, fraud). Identifies root causes driving refund volume."
    - name: "refund_method"
      expr: refund_method
      comment: "Method used to issue the refund (e.g. original payment method, voucher, credit). Tracks refund channel mix and cost."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the refund. Supports multi-currency refund liability reporting."
    - name: "is_event_initiated"
      expr: is_event_initiated
      comment: "Indicates whether the refund was triggered by an event cancellation or postponement. Separates event-driven vs. fan-initiated refund liability."
    - name: "is_fraud_related"
      expr: is_fraud_related
      comment: "Indicates whether the refund is fraud-related. Tracks fraud-driven refund exposure for risk management."
    - name: "sla_breach_flag"
      expr: sla_breach_flag
      comment: "Indicates whether the refund breached its SLA target. SLA breaches drive customer satisfaction and regulatory risk."
    - name: "resale_refund_flag"
      expr: resale_refund_flag
      comment: "Indicates whether the refund is associated with a resale transaction. Tracks secondary market refund exposure."
    - name: "approval_level"
      expr: approval_level
      comment: "Approval authority level required for the refund. Supports governance and escalation analysis."
    - name: "refund_requested_month"
      expr: DATE_TRUNC('month', requested_timestamp)
      comment: "Month the refund was requested. Enables monthly refund liability trend analysis."
    - name: "refund_completed_month"
      expr: DATE_TRUNC('month', completed_timestamp)
      comment: "Month the refund was completed. Supports cash outflow timing and SLA performance reporting."
  measures:
    - name: "total_refunds"
      expr: COUNT(DISTINCT refund_id)
      comment: "Total number of refund transactions. Baseline volume KPI for refund operations management."
    - name: "total_gross_refund_amount"
      expr: SUM(CAST(gross_refund_amount AS DOUBLE))
      comment: "Total gross refund value issued. Primary refund liability KPI — directly impacts net revenue."
    - name: "total_net_refund_amount"
      expr: SUM(CAST(net_refund_amount AS DOUBLE))
      comment: "Total net refund amount after service fee retention. Measures actual cash outflow from refunds."
    - name: "total_service_fee_refunded"
      expr: SUM(CAST(service_fee_refund_amount AS DOUBLE))
      comment: "Total service fees refunded. Tracks ancillary revenue erosion from refund activity."
    - name: "total_tax_refunded"
      expr: SUM(CAST(tax_refund_amount AS DOUBLE))
      comment: "Total tax amounts refunded. Required for tax reconciliation and compliance reporting."
    - name: "avg_gross_refund_amount"
      expr: AVG(CAST(gross_refund_amount AS DOUBLE))
      comment: "Average gross refund value per transaction. Benchmarks refund size trends for liability forecasting."
    - name: "sla_breach_count"
      expr: COUNT(DISTINCT CASE WHEN sla_breach_flag = TRUE THEN refund_id END)
      comment: "Number of refunds that breached SLA targets. SLA breaches drive fan dissatisfaction and regulatory scrutiny."
    - name: "fraud_related_refund_count"
      expr: COUNT(DISTINCT CASE WHEN is_fraud_related = TRUE THEN refund_id END)
      comment: "Number of fraud-related refunds. Tracks fraud-driven financial exposure for risk management."
    - name: "event_initiated_refund_amount"
      expr: SUM(CAST(CASE WHEN is_event_initiated = TRUE THEN gross_refund_amount ELSE 0 END AS DOUBLE))
      comment: "Total refund value triggered by event cancellations or postponements. Key liability metric for event risk management."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_gate_scan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Gate scan throughput, entry success, and access control metrics. Tracks admission rates, denial patterns, mobile ticket adoption, and ADA entry usage. Drives venue operations, security, and fan experience decisions."
  source: "`sports_entertainment_ecm`.`ticketing`.`gate_scan`"
  dimensions:
    - name: "scan_result"
      expr: scan_result
      comment: "Outcome of the gate scan (e.g. approved, denied, override). Primary dimension for admission success analysis."
    - name: "denial_reason_code"
      expr: denial_reason_code
      comment: "Reason code for scan denial. Identifies root causes of entry failures (e.g. invalid ticket, duplicate scan, wrong event)."
    - name: "gate_identifier"
      expr: gate_identifier
      comment: "Identifier of the gate where the scan occurred. Enables gate-level throughput and bottleneck analysis."
    - name: "scan_direction"
      expr: scan_direction
      comment: "Direction of the scan (e.g. entry, exit, re-entry). Supports attendance flow and re-entry policy analysis."
    - name: "ticket_type"
      expr: ticket_type
      comment: "Type of ticket scanned. Enables admission analysis by ticket category."
    - name: "ticket_source_channel"
      expr: ticket_source_channel
      comment: "Channel from which the scanned ticket was purchased. Connects admission data back to sales channel performance."
    - name: "is_mobile_ticket"
      expr: is_mobile_ticket
      comment: "Indicates whether the scanned ticket was a mobile ticket. Tracks mobile ticket adoption at the gate."
    - name: "is_ada_accessible_entry"
      expr: is_ada_accessible_entry
      comment: "Indicates whether the entry was through an ADA-accessible gate. Supports accessibility compliance reporting."
    - name: "override_flag"
      expr: override_flag
      comment: "Indicates whether a manual override was applied at the gate. High override rates signal process or system issues."
    - name: "device_type"
      expr: device_type
      comment: "Type of scanning device used. Supports device fleet performance and upgrade planning."
    - name: "network_mode"
      expr: network_mode
      comment: "Network connectivity mode of the scanning device (e.g. online, offline). Tracks offline scan exposure and risk."
    - name: "event_date"
      expr: event_date
      comment: "Date of the event being scanned. Enables event-level attendance and throughput analysis."
    - name: "scan_hour"
      expr: DATE_TRUNC('hour', scan_timestamp)
      comment: "Hour of the scan. Enables intra-event gate throughput and crowd flow analysis."
  measures:
    - name: "total_scans"
      expr: COUNT(DISTINCT gate_scan_id)
      comment: "Total number of gate scan attempts. Baseline attendance and throughput volume metric."
    - name: "successful_scans"
      expr: COUNT(DISTINCT CASE WHEN scan_result = 'approved' THEN gate_scan_id END)
      comment: "Number of successful (approved) gate scans. Measures actual admitted attendance."
    - name: "denied_scans"
      expr: COUNT(DISTINCT CASE WHEN scan_result = 'denied' THEN gate_scan_id END)
      comment: "Number of denied gate scan attempts. Elevated denial rates indicate ticketing fraud, system errors, or fan confusion."
    - name: "override_scans"
      expr: COUNT(DISTINCT CASE WHEN override_flag = TRUE THEN gate_scan_id END)
      comment: "Number of scans processed via manual override. High override volume signals gate system or policy issues."
    - name: "mobile_ticket_scans"
      expr: COUNT(DISTINCT CASE WHEN is_mobile_ticket = TRUE THEN gate_scan_id END)
      comment: "Number of mobile ticket scans. Tracks mobile adoption at the gate — key digital transformation KPI."
    - name: "ada_entry_scans"
      expr: COUNT(DISTINCT CASE WHEN is_ada_accessible_entry = TRUE THEN gate_scan_id END)
      comment: "Number of scans through ADA-accessible entry points. Supports accessibility compliance and capacity planning."
    - name: "unique_fans_admitted"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Number of distinct fans admitted via gate scan. Measures actual unique attendance for event reporting."
    - name: "unique_events_scanned"
      expr: COUNT(DISTINCT fixture_id)
      comment: "Number of distinct events with gate scan activity. Tracks operational coverage of the scanning system."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_resale`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Secondary market ticket resale economics, pricing uplift, and compliance metrics. Tracks resale revenue, platform fees, seller proceeds, price uplift, and anti-scalping compliance. Enables secondary market strategy and regulatory oversight."
  source: "`sports_entertainment_ecm`.`ticketing`.`resale`"
  dimensions:
    - name: "lifecycle_status"
      expr: lifecycle_status
      comment: "Current lifecycle status of the resale listing (e.g. listed, sold, expired, cancelled). Drives resale funnel analysis."
    - name: "seller_type"
      expr: seller_type
      comment: "Type of seller (e.g. season ticket holder, individual, broker). Informs secondary market supply composition."
    - name: "delivery_method"
      expr: delivery_method
      comment: "Delivery method for the resale ticket. Supports fulfillment analysis in the secondary market."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the resale transaction. Supports multi-currency secondary market reporting."
    - name: "anti_scalping_compliant"
      expr: anti_scalping_compliant
      comment: "Indicates whether the resale transaction complied with anti-scalping rules. Non-compliant transactions trigger regulatory and legal review."
    - name: "dynamic_pricing_applied"
      expr: dynamic_pricing_applied
      comment: "Indicates whether dynamic pricing was applied to the resale listing. Tracks dynamic pricing adoption in the secondary market."
    - name: "movement_type"
      expr: movement_type
      comment: "Type of ticket movement (e.g. transfer, resale, forward). Classifies secondary market transaction types."
    - name: "gdpr_consent_verified"
      expr: gdpr_consent_verified
      comment: "Indicates whether GDPR consent was verified for the resale transaction. Required for data compliance in regulated markets."
    - name: "listing_created_month"
      expr: DATE_TRUNC('month', listing_created_timestamp)
      comment: "Month the resale listing was created. Enables monthly secondary market supply trend analysis."
    - name: "transaction_month"
      expr: DATE_TRUNC('month', transaction_timestamp)
      comment: "Month the resale transaction was completed. Supports monthly secondary market revenue reporting."
  measures:
    - name: "total_resale_transactions"
      expr: COUNT(DISTINCT resale_id)
      comment: "Total number of completed resale transactions. Baseline secondary market volume KPI."
    - name: "total_resale_sale_price"
      expr: SUM(CAST(sale_price AS DOUBLE))
      comment: "Total revenue from resale ticket sales. Primary secondary market revenue KPI."
    - name: "total_listing_price"
      expr: SUM(CAST(listing_price AS DOUBLE))
      comment: "Total value of resale listings. Measures secondary market supply value and demand potential."
    - name: "total_platform_fees"
      expr: SUM(CAST(platform_fee_amount AS DOUBLE))
      comment: "Total platform fees earned from resale transactions. Key ancillary revenue stream from secondary market operations."
    - name: "total_seller_proceeds"
      expr: SUM(CAST(seller_proceeds AS DOUBLE))
      comment: "Total proceeds paid to sellers. Tracks seller economics and platform value proposition."
    - name: "total_revenue_share"
      expr: SUM(CAST(revenue_share_amount AS DOUBLE))
      comment: "Total revenue share amounts from resale transactions. Tracks revenue share obligations to franchises or leagues."
    - name: "total_original_face_value"
      expr: SUM(CAST(original_face_value AS DOUBLE))
      comment: "Sum of original face values for resold tickets. Baseline for price uplift calculation."
    - name: "avg_price_uplift_pct"
      expr: AVG(CAST(price_uplift_pct AS DOUBLE))
      comment: "Average price uplift percentage on resale vs. original face value. Measures secondary market demand premium — key indicator of event desirability."
    - name: "avg_sale_price"
      expr: AVG(CAST(sale_price AS DOUBLE))
      comment: "Average resale sale price per transaction. Benchmarks secondary market pricing trends."
    - name: "non_compliant_resale_count"
      expr: COUNT(DISTINCT CASE WHEN anti_scalping_compliant = FALSE THEN resale_id END)
      comment: "Number of resale transactions that violated anti-scalping rules. Regulatory compliance KPI — non-zero values trigger legal review."
    - name: "avg_revenue_share_rate"
      expr: AVG(CAST(revenue_share_rate AS DOUBLE))
      comment: "Average revenue share rate applied to resale transactions. Monitors contractual revenue share compliance."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_ticket_inventory`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Ticket inventory availability, pricing, and utilization metrics. Tracks inventory status mix, dynamic pricing adoption, face value distribution, and ADA inventory coverage. Drives inventory management, yield optimization, and capacity planning decisions."
  source: "`sports_entertainment_ecm`.`ticketing`.`ticket_inventory`"
  dimensions:
    - name: "inventory_status"
      expr: inventory_status
      comment: "Current status of the inventory record (e.g. available, sold, held, killed). Primary dimension for inventory availability analysis."
    - name: "inventory_type"
      expr: inventory_type
      comment: "Type of inventory (e.g. general admission, reserved, suite, standing). Supports inventory mix and yield analysis."
    - name: "sale_channel"
      expr: sale_channel
      comment: "Channel through which the inventory is allocated for sale. Enables channel-level inventory distribution analysis."
    - name: "is_dynamic_pricing_enabled"
      expr: is_dynamic_pricing_enabled
      comment: "Indicates whether dynamic pricing is enabled for this inventory. Tracks dynamic pricing coverage across inventory."
    - name: "is_ada_accessible"
      expr: is_ada_accessible
      comment: "Indicates whether the seat is ADA-accessible. Supports accessibility inventory compliance reporting."
    - name: "is_season_ticket_eligible"
      expr: is_season_ticket_eligible
      comment: "Indicates whether the seat is eligible for season ticket packages. Supports season ticket inventory planning."
    - name: "resale_eligible"
      expr: resale_eligible
      comment: "Indicates whether the inventory is eligible for resale. Tracks secondary market supply availability."
    - name: "is_obstructed_view"
      expr: is_obstructed_view
      comment: "Indicates whether the seat has an obstructed view. Supports pricing discount and fan experience management."
    - name: "seating_capacity_type"
      expr: seating_capacity_type
      comment: "Capacity type classification of the seating (e.g. fixed, flexible, GA). Supports venue capacity planning."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency for inventory pricing. Supports multi-currency inventory valuation."
    - name: "on_sale_month"
      expr: DATE_TRUNC('month', on_sale_timestamp)
      comment: "Month inventory went on sale. Enables on-sale timing and demand ramp analysis."
  measures:
    - name: "total_inventory_seats"
      expr: COUNT(DISTINCT ticket_inventory_id)
      comment: "Total number of inventory seats. Baseline capacity metric for event and venue planning."
    - name: "available_inventory_seats"
      expr: COUNT(DISTINCT CASE WHEN inventory_status = 'available' THEN ticket_inventory_id END)
      comment: "Number of currently available (unsold) inventory seats. Key real-time inventory management KPI."
    - name: "sold_inventory_seats"
      expr: COUNT(DISTINCT CASE WHEN inventory_status = 'sold' THEN ticket_inventory_id END)
      comment: "Number of sold inventory seats. Measures sell-through volume for event performance assessment."
    - name: "held_inventory_seats"
      expr: COUNT(DISTINCT CASE WHEN inventory_status = 'held' THEN ticket_inventory_id END)
      comment: "Number of seats currently on hold. Tracks hold inventory that is not yet monetized."
    - name: "total_face_value_inventory"
      expr: SUM(CAST(face_value_amount AS DOUBLE))
      comment: "Total face value of all inventory. Measures total revenue potential of the inventory pool."
    - name: "total_dynamic_price_inventory"
      expr: SUM(CAST(dynamic_price_amount AS DOUBLE))
      comment: "Total dynamic price value across inventory. Measures incremental revenue potential from dynamic pricing."
    - name: "avg_face_value"
      expr: AVG(CAST(face_value_amount AS DOUBLE))
      comment: "Average face value per inventory seat. Benchmarks pricing tier distribution across inventory."
    - name: "avg_dynamic_price"
      expr: AVG(CAST(dynamic_price_amount AS DOUBLE))
      comment: "Average dynamic price per inventory seat. Measures dynamic pricing uplift vs. face value at inventory level."
    - name: "dynamic_pricing_enabled_seats"
      expr: COUNT(DISTINCT CASE WHEN is_dynamic_pricing_enabled = TRUE THEN ticket_inventory_id END)
      comment: "Number of seats with dynamic pricing enabled. Tracks dynamic pricing coverage — strategic yield management KPI."
    - name: "ada_accessible_seats"
      expr: COUNT(DISTINCT CASE WHEN is_ada_accessible = TRUE THEN ticket_inventory_id END)
      comment: "Number of ADA-accessible seats in inventory. Compliance KPI for accessibility mandates."
    - name: "resale_eligible_seats"
      expr: COUNT(DISTINCT CASE WHEN resale_eligible = TRUE THEN ticket_inventory_id END)
      comment: "Number of seats eligible for resale. Measures secondary market supply capacity."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_season_ticket_account`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Season ticket holder account health, renewal, and revenue metrics. Tracks account balances, renewal rates, NPS, payment plan status, and package economics. Core KPIs for season ticket retention and long-term revenue planning."
  source: "`sports_entertainment_ecm`.`ticketing`.`season_ticket_account`"
  dimensions:
    - name: "account_status"
      expr: account_status
      comment: "Current status of the season ticket account (e.g. active, lapsed, cancelled, pending). Primary dimension for account health segmentation."
    - name: "account_type"
      expr: account_type
      comment: "Type of season ticket account (e.g. individual, corporate, group). Supports account mix and revenue segmentation."
    - name: "renewal_status"
      expr: renewal_status
      comment: "Renewal status of the account (e.g. renewed, not renewed, pending). Primary KPI dimension for retention management."
    - name: "payment_plan_type"
      expr: payment_plan_type
      comment: "Type of payment plan (e.g. full pay, installment). Tracks payment plan mix and collection risk."
    - name: "payment_plan_status"
      expr: payment_plan_status
      comment: "Current status of the payment plan (e.g. current, delinquent, completed). Identifies at-risk accounts for collections."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the account. Supports multi-currency season ticket revenue reporting."
    - name: "parking_included"
      expr: parking_included
      comment: "Indicates whether parking is included in the package. Tracks parking bundle adoption and ancillary revenue."
    - name: "ada_accommodation"
      expr: ada_accommodation
      comment: "Indicates whether the account has ADA accommodation. Supports accessibility compliance reporting."
    - name: "resale_opt_in"
      expr: resale_opt_in
      comment: "Indicates whether the account holder has opted into the resale program. Tracks secondary market supply participation."
    - name: "enrollment_month"
      expr: DATE_TRUNC('month', CAST(enrollment_date AS TIMESTAMP))
      comment: "Month the account was enrolled. Enables cohort-based retention and revenue analysis."
    - name: "expiration_month"
      expr: DATE_TRUNC('month', CAST(expiration_date AS TIMESTAMP))
      comment: "Month the account expires. Supports renewal pipeline and revenue cliff analysis."
  measures:
    - name: "total_season_ticket_accounts"
      expr: COUNT(DISTINCT season_ticket_account_id)
      comment: "Total number of season ticket accounts. Baseline KPI for season ticket holder base size."
    - name: "active_accounts"
      expr: COUNT(DISTINCT CASE WHEN account_status = 'active' THEN season_ticket_account_id END)
      comment: "Number of active season ticket accounts. Core retention metric — declining active accounts signal churn risk."
    - name: "renewed_accounts"
      expr: COUNT(DISTINCT CASE WHEN renewal_status = 'renewed' THEN season_ticket_account_id END)
      comment: "Number of accounts that have renewed. Primary renewal performance KPI for season ticket retention strategy."
    - name: "total_net_package_revenue"
      expr: SUM(CAST(net_package_amount AS DOUBLE))
      comment: "Total net package revenue from season ticket accounts. Primary season ticket revenue KPI after discounts."
    - name: "total_face_value_revenue"
      expr: SUM(CAST(face_value_amount AS DOUBLE))
      comment: "Total face value revenue from season ticket accounts. Measures base ticket revenue from the season ticket channel."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discounts applied to season ticket accounts. Tracks promotional and loyalty discount exposure."
    - name: "total_account_balance"
      expr: SUM(CAST(account_balance AS DOUBLE))
      comment: "Total outstanding account balances across all season ticket accounts. Measures deferred revenue and collection exposure."
    - name: "avg_net_package_amount"
      expr: AVG(CAST(net_package_amount AS DOUBLE))
      comment: "Average net package value per season ticket account. Benchmarks package yield and pricing effectiveness."
    - name: "avg_nps_score"
      expr: AVG(CAST(nps_score AS DOUBLE))
      comment: "Average Net Promoter Score across season ticket holders. Key fan satisfaction and retention predictor — declining NPS triggers proactive outreach."
    - name: "delinquent_payment_accounts"
      expr: COUNT(DISTINCT CASE WHEN payment_plan_status = 'delinquent' THEN season_ticket_account_id END)
      comment: "Number of accounts with delinquent payment plans. Identifies collection risk and revenue at risk from non-payment."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_group_sale`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Group sales revenue, fulfillment, and pipeline metrics. Tracks gross and net group sale revenue, deposit collection, catering, and approval pipeline. Enables group sales team performance management and revenue forecasting."
  source: "`sports_entertainment_ecm`.`ticketing`.`group_sale`"
  dimensions:
    - name: "sale_status"
      expr: sale_status
      comment: "Current status of the group sale (e.g. pending, confirmed, cancelled). Drives group sales pipeline management."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of the group sale. Tracks deals awaiting approval vs. confirmed revenue."
    - name: "fulfillment_status"
      expr: fulfillment_status
      comment: "Fulfillment status of the group sale (e.g. fulfilled, pending, partial). Identifies unfulfilled group commitments."
    - name: "group_type"
      expr: group_type
      comment: "Type of group (e.g. corporate, school, nonprofit, military). Supports group segment revenue analysis."
    - name: "payment_method"
      expr: payment_method
      comment: "Payment method used for the group sale. Tracks payment mix and collection risk."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the group sale. Supports multi-currency group revenue reporting."
    - name: "catering_included"
      expr: catering_included
      comment: "Indicates whether catering is included in the group package. Tracks hospitality bundle adoption and ancillary revenue."
    - name: "ticket_delivery_method"
      expr: ticket_delivery_method
      comment: "Delivery method for group sale tickets. Supports fulfillment planning for large group orders."
    - name: "sale_month"
      expr: DATE_TRUNC('month', CAST(sale_date AS TIMESTAMP))
      comment: "Month the group sale was recorded. Enables monthly group sales pipeline and revenue trend analysis."
    - name: "approval_month"
      expr: DATE_TRUNC('month', CAST(approval_date AS TIMESTAMP))
      comment: "Month the group sale was approved. Supports approval pipeline velocity analysis."
  measures:
    - name: "total_group_sales"
      expr: COUNT(DISTINCT group_sale_id)
      comment: "Total number of group sale transactions. Baseline volume KPI for group sales channel."
    - name: "total_gross_group_revenue"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross revenue from group sales. Primary group sales revenue KPI."
    - name: "total_net_group_revenue"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net revenue from group sales after discounts and fees. Measures actual group sales contribution to revenue."
    - name: "total_catering_revenue"
      expr: SUM(CAST(catering_amount AS DOUBLE))
      comment: "Total catering revenue from group sales. Tracks hospitality ancillary revenue stream."
    - name: "total_service_fees"
      expr: SUM(CAST(service_fee_amount AS DOUBLE))
      comment: "Total service fees collected on group sales. Ancillary revenue from group channel."
    - name: "total_tax_collected"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax collected on group sales. Required for tax compliance and remittance."
    - name: "total_deposits_received"
      expr: SUM(CAST(deposit_amount AS DOUBLE))
      comment: "Total deposit amounts received for group sales. Tracks cash collected ahead of final payment — deferred revenue indicator."
    - name: "avg_negotiated_price"
      expr: AVG(CAST(negotiated_price AS DOUBLE))
      comment: "Average negotiated price per group sale. Benchmarks group pricing vs. face value for yield management."
    - name: "avg_face_value_price"
      expr: AVG(CAST(face_value_price AS DOUBLE))
      comment: "Average face value price per group sale. Baseline for discount rate and yield analysis."
    - name: "cancelled_group_sales"
      expr: COUNT(DISTINCT CASE WHEN sale_status = 'cancelled' THEN group_sale_id END)
      comment: "Number of cancelled group sales. Elevated cancellations signal pipeline risk and revenue leakage."
$$;


CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`ticketing_ticket_transfer`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Ticket transfer volume, completion, and fraud risk metrics. Tracks transfer activity, completion rates, fraud flags, and GDPR consent compliance. Enables fan engagement, fraud operations, and compliance teams to manage ticket mobility."
  source: "`sports_entertainment_ecm`.`ticketing`.`ticket_transfer`"
  dimensions:
    - name: "transfer_status"
      expr: transfer_status
      comment: "Current status of the transfer (e.g. pending, completed, cancelled, expired). Drives transfer pipeline management."
    - name: "transfer_type"
      expr: transfer_type
      comment: "Type of transfer (e.g. gift, forward, return). Classifies transfer intent for fan engagement analysis."
    - name: "transfer_method"
      expr: transfer_method
      comment: "Method used to execute the transfer (e.g. email, app, SMS). Tracks digital transfer channel adoption."
    - name: "transfer_direction"
      expr: transfer_direction
      comment: "Direction of the transfer (e.g. outbound, inbound). Supports transfer flow analysis."
    - name: "is_return_transfer"
      expr: is_return_transfer
      comment: "Indicates whether the transfer is a return of a previously transferred ticket. Tracks ticket return activity."
    - name: "fraud_risk_flag"
      expr: fraud_risk_flag
      comment: "Indicates whether the transfer has been flagged for fraud risk. Fraud-flagged transfers trigger security review."
    - name: "gdpr_consent_flag"
      expr: gdpr_consent_flag
      comment: "Indicates whether GDPR consent was obtained for the transfer. Required for data compliance in regulated markets."
    - name: "is_ada_accessible"
      expr: is_ada_accessible
      comment: "Indicates whether the transferred ticket is for an ADA-accessible seat. Supports accessibility tracking through the transfer lifecycle."
    - name: "token_format"
      expr: token_format
      comment: "Format of the entitlement token used in the transfer. Tracks token technology adoption (e.g. QR, NFC, barcode)."
    - name: "initiated_month"
      expr: DATE_TRUNC('month', initiated_timestamp)
      comment: "Month the transfer was initiated. Enables monthly transfer volume trend analysis."
    - name: "completed_month"
      expr: DATE_TRUNC('month', completed_timestamp)
      comment: "Month the transfer was completed. Supports transfer completion velocity analysis."
  measures:
    - name: "total_transfers"
      expr: COUNT(DISTINCT ticket_transfer_id)
      comment: "Total number of ticket transfer transactions. Baseline volume KPI for ticket mobility and fan sharing behavior."
    - name: "completed_transfers"
      expr: COUNT(DISTINCT CASE WHEN transfer_status = 'completed' THEN ticket_transfer_id END)
      comment: "Number of successfully completed transfers. Measures effective ticket mobility — key fan experience KPI."
    - name: "cancelled_transfers"
      expr: COUNT(DISTINCT CASE WHEN transfer_status = 'cancelled' THEN ticket_transfer_id END)
      comment: "Number of cancelled transfers. Elevated cancellations may indicate UX friction or fraud intervention."
    - name: "fraud_flagged_transfers"
      expr: COUNT(DISTINCT CASE WHEN fraud_risk_flag = TRUE THEN ticket_transfer_id END)
      comment: "Number of transfers flagged for fraud risk. Critical security KPI — triggers fraud operations review."
    - name: "gdpr_non_consent_transfers"
      expr: COUNT(DISTINCT CASE WHEN gdpr_consent_flag = FALSE THEN ticket_transfer_id END)
      comment: "Number of transfers without GDPR consent. Compliance KPI — non-zero values in regulated markets require immediate remediation."
    - name: "unique_senders"
      expr: COUNT(DISTINCT fan_profile_id)
      comment: "Number of distinct fans who initiated ticket transfers. Measures fan sharing engagement breadth."
    - name: "unique_recipients"
      expr: COUNT(DISTINCT tertiary_ticket_recipient_fan_fan_profile_id)
      comment: "Number of distinct fans who received transferred tickets. Measures audience reach expansion through ticket sharing."
    - name: "return_transfer_count"
      expr: COUNT(DISTINCT CASE WHEN is_return_transfer = TRUE THEN ticket_transfer_id END)
      comment: "Number of return transfers. Tracks ticket return activity which may indicate event dissatisfaction or scheduling conflicts."
$$;
