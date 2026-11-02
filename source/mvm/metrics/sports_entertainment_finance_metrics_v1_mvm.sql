-- Metric views for domain: finance | Business: Sports Entertainment | Version: 1 | Generated on: 2026-05-09 04:47:44

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_ap_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Accounts Payable invoice metrics covering vendor spend, discount capture, tax obligations, withholding, and payment efficiency. Supports cash-flow forecasting, vendor management, and working-capital optimisation for the sports-entertainment finance function."
  source: "`sports_entertainment_ecm`.`finance`.`ap_invoice`"
  dimensions:
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of AP invoice (e.g. standard, credit memo, recurring) used to segment payables by obligation class."
    - name: "invoice_status"
      expr: invoice_status
      comment: "Current lifecycle status of the invoice (e.g. open, paid, blocked) for payables ageing and clearance tracking."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval workflow state of the invoice, enabling identification of bottlenecks in the payables approval chain."
    - name: "payment_status"
      expr: payment_status
      comment: "Payment execution status (e.g. paid, outstanding, overdue) for cash-flow and vendor-relationship management."
    - name: "payment_method"
      expr: payment_method
      comment: "Method used to settle the invoice (e.g. ACH, wire, check) for treasury and payment-channel analysis."
    - name: "expense_category"
      expr: expense_category
      comment: "Business expense category (e.g. player costs, venue ops, broadcast) for cost-centre spend analysis."
    - name: "vendor_category"
      expr: vendor_category
      comment: "Category of the vendor (e.g. media, facilities, athlete services) enabling spend concentration analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency of the invoice for multi-currency payables exposure reporting."
    - name: "is_recurring"
      expr: is_recurring
      comment: "Flag indicating whether the invoice is part of a recurring obligation, supporting committed-cost forecasting."
    - name: "invoice_date_month"
      expr: DATE_TRUNC('MONTH', invoice_date)
      comment: "Calendar month of the invoice date for monthly payables trend analysis."
    - name: "posting_date_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Calendar month of the GL posting date for period-accurate expense recognition."
    - name: "three_way_match_status"
      expr: three_way_match_status
      comment: "Status of the three-way match (PO / GR / invoice) for procurement compliance and fraud-risk monitoring."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Agreed payment terms code (e.g. Net30, 2/10Net30) for discount-capture and DPO analysis."
  measures:
    - name: "total_gross_payables"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross AP invoice amount. Primary measure of vendor spend and payables exposure used in cash-flow forecasting and budget variance reviews."
    - name: "total_net_payables"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net AP invoice amount after discounts. Reflects actual cash obligation to vendors and is the basis for DPO calculation."
    - name: "total_tax_payable"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount on AP invoices. Drives VAT/GST liability reporting and tax-cash-flow planning."
    - name: "total_withholding_tax"
      expr: SUM(CAST(withholding_tax_amount AS DOUBLE))
      comment: "Total withholding tax deducted from vendor payments. Critical for athlete/agent NIL and officiating payment compliance reporting."
    - name: "total_discount_captured"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total early-payment discounts captured. Measures treasury efficiency in leveraging payment-term discounts to reduce net spend."
    - name: "total_local_currency_amount"
      expr: SUM(CAST(local_currency_amount AS DOUBLE))
      comment: "Total AP invoice amount in local functional currency. Used for FX exposure analysis and multi-entity consolidation."
    - name: "invoice_count"
      expr: COUNT(1)
      comment: "Total number of AP invoices processed. Baseline volume metric for payables throughput and vendor activity benchmarking."
    - name: "distinct_vendor_invoice_count"
      expr: COUNT(DISTINCT vendor_invoice_number)
      comment: "Count of unique vendor invoice numbers. Detects duplicate invoice submissions and supports three-way-match completeness audits."
    - name: "blocked_invoice_count"
      expr: COUNT(CASE WHEN payment_block_reason IS NOT NULL THEN 1 END)
      comment: "Number of invoices currently blocked from payment. High values signal procurement or compliance issues requiring immediate resolution."
    - name: "recurring_invoice_count"
      expr: COUNT(CASE WHEN is_recurring = TRUE THEN 1 END)
      comment: "Count of recurring invoices. Quantifies committed periodic obligations (e.g. venue leases, broadcast fees) for fixed-cost forecasting."
    - name: "avg_invoice_gross_amount"
      expr: AVG(CAST(gross_amount AS DOUBLE))
      comment: "Average gross amount per AP invoice. Benchmarks typical vendor transaction size and flags anomalous high-value invoices."
    - name: "avg_days_to_payment"
      expr: AVG(CAST(DATEDIFF(payment_date, invoice_date) AS DOUBLE))
      comment: "Average number of days from invoice date to payment date. Core Days Payable Outstanding (DPO) driver used to assess working-capital efficiency."
    - name: "overdue_invoice_gross_amount"
      expr: SUM(CASE WHEN payment_status <> 'PAID' AND due_date < CURRENT_DATE() THEN CAST(gross_amount AS DOUBLE) ELSE 0 END)
      comment: "Total gross amount of invoices past their due date and not yet paid. Measures vendor-relationship risk and potential late-payment penalty exposure."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_ar_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Accounts Receivable invoice metrics covering revenue billed, collections performance, deferred revenue, write-offs, and dispute management. Supports revenue recognition, DSO tracking, and fan/sponsor receivables governance."
  source: "`sports_entertainment_ecm`.`finance`.`ar_invoice`"
  dimensions:
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of AR invoice (e.g. standard, credit memo, intercompany) for receivables segmentation."
    - name: "revenue_category"
      expr: revenue_category
      comment: "Revenue stream category (e.g. ticketing, sponsorship, media rights, merchandise) for top-line revenue mix analysis."
    - name: "payment_status"
      expr: payment_status
      comment: "Current payment status of the AR invoice (e.g. open, cleared, overdue) for collections prioritisation."
    - name: "revenue_recognition_status"
      expr: revenue_recognition_status
      comment: "ASC 606 / IFRS 15 recognition status (e.g. recognised, deferred, pending) for compliance and audit reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency receivables exposure and FX risk reporting."
    - name: "intercompany_flag"
      expr: intercompany_flag
      comment: "Indicates intercompany AR transactions for elimination in consolidated financial statements."
    - name: "dunning_level"
      expr: dunning_level
      comment: "Current dunning escalation level for overdue receivables, driving collections strategy and bad-debt provisioning."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Agreed payment terms code for DSO benchmarking and credit-policy compliance."
    - name: "billing_date_month"
      expr: DATE_TRUNC('MONTH', billing_date)
      comment: "Calendar month of billing for monthly revenue billed trend analysis."
    - name: "posting_date_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Calendar month of GL posting for period-accurate revenue reporting."
    - name: "sap_document_type"
      expr: sap_document_type
      comment: "SAP document type for technical reconciliation between AR sub-ledger and general ledger."
  measures:
    - name: "total_gross_billed"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross amount billed to customers. Primary top-line revenue billed metric used in revenue performance reviews and board reporting."
    - name: "total_net_billed"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net billed amount after discounts. Reflects actual revenue recognised net of promotional and contractual discounts."
    - name: "total_amount_collected"
      expr: SUM(CAST(amount_paid AS DOUBLE))
      comment: "Total cash collected against AR invoices. Core collections performance metric and cash-flow realisation indicator."
    - name: "total_deferred_revenue"
      expr: SUM(CAST(deferred_revenue_amount AS DOUBLE))
      comment: "Total revenue deferred to future periods (e.g. season tickets, multi-year sponsorships). Critical for balance-sheet liability and ASC 606 compliance reporting."
    - name: "total_write_offs"
      expr: SUM(CAST(write_off_amount AS DOUBLE))
      comment: "Total amount written off as uncollectable. Measures bad-debt exposure and credit-risk management effectiveness."
    - name: "total_tax_billed"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount billed on AR invoices. Supports VAT/sales-tax remittance reconciliation and regulatory reporting."
    - name: "total_discount_granted"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discounts granted to customers. Measures revenue leakage from promotional and contractual discount programmes."
    - name: "invoice_count"
      expr: COUNT(1)
      comment: "Total number of AR invoices issued. Baseline billing volume metric for revenue operations throughput benchmarking."
    - name: "open_invoice_count"
      expr: COUNT(CASE WHEN payment_status <> 'CLEARED' THEN 1 END)
      comment: "Number of invoices not yet fully collected. Drives collections workload planning and DSO calculation."
    - name: "disputed_invoice_count"
      expr: COUNT(CASE WHEN dispute_reason_code IS NOT NULL THEN 1 END)
      comment: "Number of invoices under dispute. High dispute rates signal contract, billing, or service-delivery issues requiring executive attention."
    - name: "avg_days_to_collection"
      expr: AVG(CAST(DATEDIFF(payment_date, billing_date) AS DOUBLE))
      comment: "Average days from billing to cash collection. Core Days Sales Outstanding (DSO) driver used to assess receivables efficiency and credit policy effectiveness."
    - name: "collection_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(amount_paid AS DOUBLE)) / NULLIF(SUM(CAST(gross_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of gross billed amount actually collected. Measures collections effectiveness and revenue quality; low rates trigger credit-policy review."
    - name: "overdue_gross_amount"
      expr: SUM(CASE WHEN payment_status <> 'CLEARED' AND due_date < CURRENT_DATE() THEN CAST(gross_amount AS DOUBLE) ELSE 0 END)
      comment: "Total gross amount of overdue unpaid invoices. Quantifies at-risk receivables for bad-debt provisioning and collections escalation."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_budget`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Budget planning and variance metrics covering planned vs. actual vs. forecast spend and revenue across business units, cost elements, and fiscal periods. Supports financial planning & analysis (FP&A), budget governance, and executive variance reviews."
  source: "`sports_entertainment_ecm`.`finance`.`budget`"
  dimensions:
    - name: "budget_type"
      expr: budget_type
      comment: "Type of budget (e.g. operating, capital, media rights) for segmented financial planning analysis."
    - name: "plan_type"
      expr: plan_type
      comment: "Planning type (e.g. original plan, revised plan, rolling forecast) for version-controlled budget comparison."
    - name: "scenario_type"
      expr: scenario_type
      comment: "Budget scenario (e.g. base case, upside, downside) for scenario-based financial planning and stress testing."
    - name: "business_unit"
      expr: business_unit
      comment: "Business unit owning the budget line for P&L accountability and cost-centre governance."
    - name: "functional_area"
      expr: functional_area
      comment: "Functional area (e.g. operations, marketing, player development) for cross-functional spend analysis."
    - name: "approval_status"
      expr: approval_status
      comment: "Budget approval workflow status for governance and audit trail reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the budget for multi-currency consolidation and FX impact analysis."
    - name: "period_granularity"
      expr: period_granularity
      comment: "Time granularity of the budget (e.g. monthly, quarterly, annual) for planning cadence analysis."
    - name: "cost_element_code"
      expr: cost_element_code
      comment: "Cost element classification for granular cost-type analysis within the budget."
    - name: "is_intercompany"
      expr: is_intercompany
      comment: "Flag for intercompany budget lines requiring elimination in consolidated reporting."
    - name: "effective_from_month"
      expr: DATE_TRUNC('MONTH', effective_from_date)
      comment: "Start month of the budget effective period for time-series planning analysis."
    - name: "version"
      expr: version
      comment: "Budget version identifier for tracking iterative revisions and comparing plan versions over time."
  measures:
    - name: "total_planned_amount"
      expr: SUM(CAST(planned_amount AS DOUBLE))
      comment: "Total planned budget amount. Baseline financial plan measure used in all budget-vs-actual variance analyses and board presentations."
    - name: "total_actuals_amount"
      expr: SUM(CAST(actuals_amount AS DOUBLE))
      comment: "Total actual spend/revenue posted against the budget. Core measure for budget execution tracking and variance reporting."
    - name: "total_forecast_amount"
      expr: SUM(CAST(forecast_amount AS DOUBLE))
      comment: "Total forecast amount for the period. Used in rolling-forecast reviews to project full-year financial outcomes."
    - name: "total_revised_amount"
      expr: SUM(CAST(revised_amount AS DOUBLE))
      comment: "Total revised budget amount after mid-period adjustments. Tracks budget reallocation decisions and their cumulative impact."
    - name: "total_committed_amount"
      expr: SUM(CAST(committed_amount AS DOUBLE))
      comment: "Total committed (encumbered) amount against the budget. Measures obligations not yet invoiced, critical for available-budget management."
    - name: "total_prior_year_actual"
      expr: SUM(CAST(prior_year_actual_amount AS DOUBLE))
      comment: "Total prior-year actual amount for year-over-year comparison. Provides historical baseline for growth and efficiency benchmarking."
    - name: "budget_variance_amount"
      expr: SUM(CAST(actuals_amount AS DOUBLE) - CAST(planned_amount AS DOUBLE))
      comment: "Absolute variance between actuals and plan (positive = overspend / under-revenue). Primary FP&A metric triggering management intervention when thresholds are breached."
    - name: "budget_utilisation_pct"
      expr: ROUND(100.0 * SUM(CAST(actuals_amount AS DOUBLE)) / NULLIF(SUM(CAST(planned_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of planned budget consumed by actuals. Measures budget execution pace; used in quarterly reviews to flag under- or over-spend."
    - name: "forecast_vs_plan_variance"
      expr: SUM(CAST(forecast_amount AS DOUBLE) - CAST(planned_amount AS DOUBLE))
      comment: "Variance between current forecast and original plan. Signals expected full-year deviation from budget, driving reforecast and reallocation decisions."
    - name: "yoy_actuals_growth_amount"
      expr: SUM(CAST(actuals_amount AS DOUBLE) - CAST(prior_year_actual_amount AS DOUBLE))
      comment: "Year-over-year growth in actuals vs. prior year. Measures absolute financial performance improvement or deterioration across comparable periods."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_journal_entry`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "General ledger journal entry metrics covering posting volumes, transaction amounts, intercompany activity, tax, and SOX compliance. Supports period-close governance, audit readiness, and financial control monitoring."
  source: "`sports_entertainment_ecm`.`finance`.`journal_entry`"
  dimensions:
    - name: "document_type"
      expr: document_type
      comment: "Journal entry document type (e.g. SA, KR, DR) for GL activity classification and audit trail analysis."
    - name: "posting_status"
      expr: posting_status
      comment: "Posting status of the journal entry (e.g. posted, parked, reversed) for period-close completeness monitoring."
    - name: "revenue_category"
      expr: revenue_category
      comment: "Revenue category associated with the journal entry for P&L revenue stream analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency GL analysis and FX impact reporting."
    - name: "intercompany_indicator"
      expr: intercompany_indicator
      comment: "Flag for intercompany journal entries requiring elimination in group consolidation."
    - name: "reversal_indicator"
      expr: reversal_indicator
      comment: "Flag indicating the entry is a reversal. High reversal rates signal posting errors or control weaknesses."
    - name: "sox_approval_status"
      expr: sox_approval_status
      comment: "SOX approval status of the journal entry for internal controls compliance and external audit evidence."
    - name: "functional_area"
      expr: functional_area
      comment: "Functional area of the journal entry for segment and cost-centre reporting."
    - name: "posting_date_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Calendar month of the posting date for monthly GL activity and period-close trend analysis."
    - name: "document_date_month"
      expr: DATE_TRUNC('MONTH', document_date)
      comment: "Calendar month of the document date for timing-difference and cut-off analysis."
  measures:
    - name: "total_transaction_amount"
      expr: SUM(CAST(transaction_amount AS DOUBLE))
      comment: "Total transaction amount across all journal entries. Primary GL activity volume measure used in period-close reconciliation and financial statement preparation."
    - name: "total_local_currency_amount"
      expr: SUM(CAST(local_currency_amount AS DOUBLE))
      comment: "Total journal entry amount in local functional currency. Used for entity-level P&L reporting and multi-currency consolidation."
    - name: "total_group_currency_amount"
      expr: SUM(CAST(group_currency_amount AS DOUBLE))
      comment: "Total journal entry amount translated to group reporting currency. Drives consolidated financial statement preparation and FX translation analysis."
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount posted via journal entries. Supports indirect tax reconciliation and regulatory tax reporting."
    - name: "journal_entry_count"
      expr: COUNT(1)
      comment: "Total number of journal entries posted. Baseline GL activity volume metric for period-close workload and control monitoring."
    - name: "reversal_entry_count"
      expr: COUNT(CASE WHEN reversal_indicator = TRUE THEN 1 END)
      comment: "Number of reversal journal entries. Elevated reversal counts indicate posting errors or control failures requiring investigation."
    - name: "intercompany_entry_count"
      expr: COUNT(CASE WHEN intercompany_indicator = TRUE THEN 1 END)
      comment: "Number of intercompany journal entries. Drives intercompany reconciliation and elimination processes in group consolidation."
    - name: "sox_unapproved_entry_count"
      expr: COUNT(CASE WHEN sox_approval_status <> 'APPROVED' THEN 1 END)
      comment: "Number of journal entries lacking SOX approval. A non-zero value is a critical internal-controls finding requiring immediate remediation before period close."
    - name: "reversal_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN reversal_indicator = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of journal entries that are reversals. High rates signal systemic posting quality issues and are a key SOX control metric."
    - name: "avg_transaction_amount"
      expr: AVG(CAST(transaction_amount AS DOUBLE))
      comment: "Average transaction amount per journal entry. Used to detect anomalous large entries that may require additional review or approval."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_payment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Payment execution metrics covering outbound and inbound cash flows, payment method mix, discount capture, withholding tax, and reversal rates. Supports treasury management, cash-flow forecasting, and payment-controls governance."
  source: "`sports_entertainment_ecm`.`finance`.`payment`"
  dimensions:
    - name: "payment_type"
      expr: payment_type
      comment: "Type of payment (e.g. vendor, fan, athlete, intercompany) for cash-flow segmentation by obligation class."
    - name: "payment_method"
      expr: payment_method
      comment: "Payment channel used (e.g. ACH, wire, check, card) for payment-method mix and cost-per-payment analysis."
    - name: "payment_status"
      expr: payment_status
      comment: "Execution status of the payment (e.g. cleared, pending, failed, reversed) for cash-position and exception management."
    - name: "direction"
      expr: direction
      comment: "Payment direction (inbound / outbound) for net cash-flow and treasury position reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency cash-flow and FX exposure analysis."
    - name: "business_area"
      expr: business_area
      comment: "Business area associated with the payment for segment-level cash-flow attribution."
    - name: "payment_date_month"
      expr: DATE_TRUNC('MONTH', payment_date)
      comment: "Calendar month of payment execution for monthly cash-flow trend and treasury reporting."
    - name: "remittance_advice_sent"
      expr: remittance_advice_sent
      comment: "Flag indicating whether remittance advice was sent to the payee, supporting vendor-reconciliation quality monitoring."
  measures:
    - name: "total_gross_payment_amount"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross cash disbursed or received. Primary treasury cash-flow measure used in daily cash-position reporting and liquidity management."
    - name: "total_net_payment_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net payment amount after discounts and withholding. Reflects actual cash movement for bank reconciliation and cash-flow forecasting."
    - name: "total_withholding_tax_deducted"
      expr: SUM(CAST(withholding_tax_amount AS DOUBLE))
      comment: "Total withholding tax deducted from payments. Critical for athlete, agent, and NIL payment tax-compliance reporting and regulatory remittance."
    - name: "total_discount_taken"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total early-payment discounts taken at payment execution. Measures treasury's realised savings from dynamic discounting programmes."
    - name: "payment_count"
      expr: COUNT(1)
      comment: "Total number of payments executed. Baseline payment operations volume metric for throughput benchmarking and processing-cost analysis."
    - name: "failed_payment_count"
      expr: COUNT(CASE WHEN payment_status = 'FAILED' THEN 1 END)
      comment: "Number of failed payments. Elevated failure rates indicate bank connectivity, data quality, or fraud-screening issues requiring immediate treasury action."
    - name: "reversed_payment_count"
      expr: COUNT(CASE WHEN reversal_reason_code IS NOT NULL THEN 1 END)
      comment: "Number of reversed payments. High reversal counts signal payment-process control weaknesses and increase operational cost."
    - name: "payment_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN payment_status = 'FAILED' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of payments that failed execution. Key treasury operations KPI; high rates trigger bank and payment-processor reviews."
    - name: "avg_payment_amount"
      expr: AVG(CAST(gross_amount AS DOUBLE))
      comment: "Average gross payment amount. Used to detect anomalous large payments and benchmark payment-size distributions across channels."
    - name: "outbound_payment_amount"
      expr: SUM(CASE WHEN direction = 'OUTBOUND' THEN CAST(gross_amount AS DOUBLE) ELSE 0 END)
      comment: "Total outbound cash payments. Core cash-outflow measure for liquidity planning and working-capital management."
    - name: "inbound_payment_amount"
      expr: SUM(CASE WHEN direction = 'INBOUND' THEN CAST(gross_amount AS DOUBLE) ELSE 0 END)
      comment: "Total inbound cash receipts. Core cash-inflow measure for revenue collections tracking and liquidity planning."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_payment_run`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Payment run execution metrics covering batch payment success rates, failed amounts, discount capture, and reconciliation status. Supports treasury operations governance, payment-run quality monitoring, and period-close cash management."
  source: "`sports_entertainment_ecm`.`finance`.`payment_run`"
  dimensions:
    - name: "payment_run_status"
      expr: payment_run_status
      comment: "Overall status of the payment run (e.g. completed, failed, in-progress) for treasury operations monitoring."
    - name: "run_type"
      expr: run_type
      comment: "Type of payment run (e.g. regular, emergency, reversal) for payment-batch classification and audit."
    - name: "payment_method"
      expr: payment_method
      comment: "Payment method used in the run (e.g. ACH, wire) for channel-level success-rate analysis."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of the payment run for governance and dual-control compliance monitoring."
    - name: "reconciliation_status"
      expr: reconciliation_status
      comment: "Bank reconciliation status of the payment run for period-close completeness tracking."
    - name: "is_reversal"
      expr: is_reversal
      comment: "Flag indicating the run is a reversal batch. Reversal runs require additional scrutiny for fraud and error detection."
    - name: "payment_currency"
      expr: payment_currency
      comment: "Currency of the payment run for multi-currency treasury position reporting."
    - name: "posting_date_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Calendar month of the payment run posting date for monthly cash-flow and period-close analysis."
  measures:
    - name: "total_payment_run_amount"
      expr: SUM(CAST(total_payment_amount AS DOUBLE))
      comment: "Total cash value of all payment runs. Primary treasury cash-disbursement measure for liquidity management and bank-position reporting."
    - name: "total_successful_payment_amount"
      expr: SUM(CAST(successful_payment_amount AS DOUBLE))
      comment: "Total amount of successfully executed payments within runs. Measures effective cash disbursement and payment-run quality."
    - name: "total_failed_payment_amount"
      expr: SUM(CAST(failed_payment_amount AS DOUBLE))
      comment: "Total amount of payments that failed within runs. Quantifies cash-disbursement risk and operational loss from payment failures."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total early-payment discounts captured across payment runs. Measures treasury's realised savings from payment-term optimisation."
    - name: "total_withholding_tax_amount"
      expr: SUM(CAST(withholding_tax_amount AS DOUBLE))
      comment: "Total withholding tax deducted across payment runs. Supports tax-compliance reporting and regulatory remittance reconciliation."
    - name: "payment_run_count"
      expr: COUNT(1)
      comment: "Total number of payment runs executed. Baseline treasury operations volume metric for workload and processing-efficiency benchmarking."
    - name: "payment_run_success_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(successful_payment_amount AS DOUBLE)) / NULLIF(SUM(CAST(total_payment_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of total payment run value successfully executed. Key treasury operations KPI; low rates trigger bank and payment-processor escalation."
    - name: "avg_payment_run_amount"
      expr: AVG(CAST(total_payment_amount AS DOUBLE))
      comment: "Average total amount per payment run. Used to benchmark run sizes and detect anomalously large or small batches."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_fixed_asset`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fixed asset metrics covering net book value, accumulated depreciation, impairment, disposal proceeds, and asset utilisation. Supports capital expenditure governance, asset lifecycle management, and balance-sheet integrity for venues, broadcast equipment, and sports infrastructure."
  source: "`sports_entertainment_ecm`.`finance`.`fixed_asset`"
  dimensions:
    - name: "asset_category"
      expr: asset_category
      comment: "High-level asset category (e.g. venue infrastructure, broadcast equipment, IT) for capital portfolio analysis."
    - name: "asset_class_name"
      expr: asset_class_name
      comment: "Detailed asset class for granular depreciation and capex-budget tracking."
    - name: "asset_status"
      expr: asset_status
      comment: "Current lifecycle status of the asset (e.g. active, disposed, under construction) for asset-register completeness monitoring."
    - name: "depreciation_method_code"
      expr: depreciation_method_code
      comment: "Depreciation method applied (e.g. straight-line, declining balance) for accounting-policy consistency analysis."
    - name: "disposal_type"
      expr: disposal_type
      comment: "Type of asset disposal (e.g. sale, write-off, transfer) for gain/loss on disposal reporting."
    - name: "is_leased"
      expr: is_leased
      comment: "Flag indicating leased assets (IFRS 16 / ASC 842 right-of-use assets) for lease liability and ROU asset reporting."
    - name: "is_fully_depreciated"
      expr: is_fully_depreciated
      comment: "Flag for fully depreciated assets still in service. High counts indicate ageing infrastructure requiring capex refresh planning."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the asset valuation for multi-entity fixed-asset consolidation."
    - name: "acquisition_date_year"
      expr: DATE_TRUNC('YEAR', acquisition_date)
      comment: "Year of asset acquisition for capex vintage analysis and asset-age distribution reporting."
    - name: "asset_location_description"
      expr: asset_location_description
      comment: "Physical location of the asset (e.g. venue name, broadcast facility) for location-based asset management."
  measures:
    - name: "total_acquisition_cost"
      expr: SUM(CAST(acquisition_cost AS DOUBLE))
      comment: "Total historical acquisition cost of fixed assets. Primary capex investment measure for balance-sheet gross asset value reporting."
    - name: "total_net_book_value"
      expr: SUM(CAST(net_book_value AS DOUBLE))
      comment: "Total net book value (cost less accumulated depreciation). Core balance-sheet asset measure used in financial statements and asset-coverage ratios."
    - name: "total_accumulated_depreciation"
      expr: SUM(CAST(accumulated_depreciation AS DOUBLE))
      comment: "Total accumulated depreciation charged to date. Measures asset consumption and drives depreciation expense in the P&L."
    - name: "total_annual_depreciation_charge"
      expr: SUM(CAST(annual_depreciation_charge AS DOUBLE))
      comment: "Total annual depreciation charge across the asset portfolio. Key P&L non-cash expense measure for EBITDA-to-EBIT bridge and budget planning."
    - name: "total_impairment_loss"
      expr: SUM(CAST(impairment_loss AS DOUBLE))
      comment: "Total impairment losses recognised on fixed assets. Signals asset value deterioration (e.g. venue closures, broadcast rights write-downs) requiring board-level disclosure."
    - name: "total_disposal_proceeds"
      expr: SUM(CAST(disposal_proceeds AS DOUBLE))
      comment: "Total proceeds from asset disposals. Used to calculate gain/loss on disposal and assess asset monetisation strategy effectiveness."
    - name: "total_insured_value"
      expr: SUM(CAST(insured_value AS DOUBLE))
      comment: "Total insured value of fixed assets. Measures insurance coverage adequacy relative to net book value for risk management."
    - name: "asset_count"
      expr: COUNT(1)
      comment: "Total number of fixed assets on the register. Baseline asset portfolio size metric for asset-management and physical-verification planning."
    - name: "fully_depreciated_asset_count"
      expr: COUNT(CASE WHEN is_fully_depreciated = TRUE THEN 1 END)
      comment: "Number of fully depreciated assets still in service. High counts indicate ageing infrastructure and drive capex refresh investment decisions."
    - name: "avg_net_book_value_per_asset"
      expr: AVG(CAST(net_book_value AS DOUBLE))
      comment: "Average net book value per asset. Used to benchmark asset quality and identify asset classes with disproportionately low residual values."
    - name: "depreciation_coverage_pct"
      expr: ROUND(100.0 * SUM(CAST(accumulated_depreciation AS DOUBLE)) / NULLIF(SUM(CAST(acquisition_cost AS DOUBLE)), 0), 2)
      comment: "Percentage of acquisition cost consumed by accumulated depreciation. Measures overall asset age and remaining useful life across the portfolio; high values signal imminent capex requirements."
$$;

CREATE OR REPLACE VIEW `sports_entertainment_ecm`.`_metrics`.`finance_revenue_recognition_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Revenue recognition metrics covering deferred revenue balances, cumulative recognised amounts, current-period recognition, variable consideration, and contract performance obligations. Supports ASC 606 / IFRS 15 compliance, audit readiness, and revenue quality reporting for media rights, sponsorships, NIL agreements, and ticketing."
  source: "`sports_entertainment_ecm`.`finance`.`revenue_recognition_schedule`"
  dimensions:
    - name: "recognition_status"
      expr: recognition_status
      comment: "Current recognition status (e.g. in-progress, completed, deferred) for revenue pipeline and compliance monitoring."
    - name: "recognition_method"
      expr: recognition_method
      comment: "Method of revenue recognition (e.g. over-time, point-in-time) per ASC 606 / IFRS 15 for accounting-policy compliance."
    - name: "contract_type"
      expr: contract_type
      comment: "Type of underlying contract (e.g. media rights, sponsorship, NIL, ticketing) for revenue stream segmentation."
    - name: "accounting_standard"
      expr: accounting_standard
      comment: "Applicable accounting standard (e.g. ASC 606, IFRS 15) for multi-GAAP revenue reporting."
    - name: "recognition_basis"
      expr: recognition_basis
      comment: "Basis for revenue recognition (e.g. performance obligation satisfied, time elapsed) for audit evidence and compliance documentation."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency revenue recognition and FX impact analysis."
    - name: "variable_consideration_flag"
      expr: variable_consideration_flag
      comment: "Flag for contracts with variable consideration (e.g. performance bonuses, royalties). Drives constraint analysis and revenue estimation uncertainty disclosures."
    - name: "significant_financing_flag"
      expr: significant_financing_flag
      comment: "Flag for contracts with a significant financing component requiring interest adjustment under ASC 606 / IFRS 15."
    - name: "modification_flag"
      expr: modification_flag
      comment: "Flag indicating the contract has been modified. Contract modifications require reassessment of performance obligations and recognition schedules."
    - name: "recognition_start_month"
      expr: DATE_TRUNC('MONTH', recognition_start_date)
      comment: "Month recognition commenced for revenue pipeline and backlog analysis."
    - name: "recognition_end_month"
      expr: DATE_TRUNC('MONTH', recognition_end_date)
      comment: "Month recognition is scheduled to complete for deferred revenue burn-down forecasting."
  measures:
    - name: "total_contract_value"
      expr: SUM(CAST(total_contract_value AS DOUBLE))
      comment: "Total contracted revenue value across all recognition schedules. Primary revenue backlog measure used in investor reporting and revenue forecasting."
    - name: "total_cumulative_recognised"
      expr: SUM(CAST(cumulative_recognized_amount AS DOUBLE))
      comment: "Total revenue recognised to date across all contracts. Measures revenue realisation progress against total contract value."
    - name: "total_current_period_recognition"
      expr: SUM(CAST(current_period_recognition_amount AS DOUBLE))
      comment: "Total revenue recognised in the current period. Core P&L revenue measure for period-accurate financial reporting under ASC 606 / IFRS 15."
    - name: "total_deferred_revenue_balance"
      expr: SUM(CAST(deferred_revenue_balance AS DOUBLE))
      comment: "Total deferred revenue liability outstanding. Critical balance-sheet measure for season tickets, multi-year sponsorships, and media rights prepayments."
    - name: "total_variable_consideration"
      expr: SUM(CAST(variable_consideration_amount AS DOUBLE))
      comment: "Total variable consideration included in recognition schedules. Measures revenue estimation uncertainty and constraint risk under ASC 606."
    - name: "recognition_schedule_count"
      expr: COUNT(1)
      comment: "Total number of active revenue recognition schedules. Baseline measure for revenue contract portfolio size and recognition complexity."
    - name: "modified_contract_count"
      expr: COUNT(CASE WHEN modification_flag = TRUE THEN 1 END)
      comment: "Number of contracts with recognised modifications. High counts increase audit complexity and signal commercial renegotiation activity."
    - name: "revenue_recognition_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(cumulative_recognized_amount AS DOUBLE)) / NULLIF(SUM(CAST(total_contract_value AS DOUBLE)), 0), 2)
      comment: "Percentage of total contract value recognised to date. Measures revenue realisation progress and deferred revenue burn-down rate; key metric for investor and audit reporting."
    - name: "avg_contract_value"
      expr: AVG(CAST(total_contract_value AS DOUBLE))
      comment: "Average total contract value per recognition schedule. Benchmarks deal size across revenue streams and identifies high-value contract concentration risk."
    - name: "deferred_revenue_pct_of_contract"
      expr: ROUND(100.0 * SUM(CAST(deferred_revenue_balance AS DOUBLE)) / NULLIF(SUM(CAST(total_contract_value AS DOUBLE)), 0), 2)
      comment: "Percentage of total contract value still deferred. Measures revenue quality and the proportion of contracted revenue not yet earned; high values indicate future revenue visibility."
$$;