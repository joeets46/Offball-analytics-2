-- =========================================================================
-- sap_s4 -- table comments
--
-- SAP table names are opaque by design, so these comments do more work here
-- than in any other schema: they are the only thing that tells a reader what
-- `bsik` or `t009b` holds. The names are kept because anyone building the
-- extract will be reading SAP documentation, not this file.
-- =========================================================================

-- Organisational structure (customising tables).
COMMENT ON TABLE sap_s4.t001w IS
    'Plant / site -- the physical operating location. Feeds target venue.facility and target merchandise.retail_location; a stadium, a store and a warehouse are all plants to SAP.';
COMMENT ON TABLE sap_s4.t001l IS
    'Storage location within a plant. The location dimension of target merchandise.inventory_position.';
COMMENT ON TABLE sap_s4.t009 IS
    'Fiscal year variant -- how many posting and special periods a year has. Feeds target finance.fiscal_period and, by compromise, target league.season.';
COMMENT ON TABLE sap_s4.t009b IS
    'Fiscal period definitions with their calendar boundaries and open/closed state. The period status is what blocks a posting at month end.';

-- Master data: general view and organisational view pairs.
COMMENT ON TABLE sap_s4.ska1 IS
    'GL account, chart-of-accounts view. One character (XBILK) decides whether the account appears in the balance sheet or the P&L.';
COMMENT ON TABLE sap_s4.kna1 IS
    'Customer master, client view. The counterparty side of receivables, and -- through common.entity_xref -- target sponsorship.sponsor.';
COMMENT ON TABLE sap_s4.knb1 IS
    'Customer master, company-code view: reconciliation account, payment terms and dunning state. The same customer can be dunned differently per company code.';
COMMENT ON TABLE sap_s4.lfa1 IS
    'Vendor master, client view. Feeds target merchandise.supplier; the vendor_role column is what lets licensors, agents and athletes share the table.';
COMMENT ON TABLE sap_s4.lfb1 IS
    'Vendor master, company-code view, including the payment block that stops a vendor being paid by the payment run.';
COMMENT ON TABLE sap_s4.mara IS
    'Material master, client view. SAP is authoritative for the material; Shopify owns the sellable catalog, which is why target merchandise.sku_catalog maps there and not here.';
COMMENT ON TABLE sap_s4.marc IS
    'Material master, plant view: reorder point, safety stock and planned delivery time -- the parameters that drive replenishment.';
COMMENT ON TABLE sap_s4.anla IS
    'Fixed asset master. Venue infrastructure is the bulk of a sports organisation asset base, so the asset-to-plant link is what connects finance to the building.';
COMMENT ON TABLE sap_s4.a004 IS
    'Pricing condition access table, keyed on the combination that was looked up. KNUMH is not unique here, which is why KONP cannot reference it.';

-- Documents.
COMMENT ON TABLE sap_s4.vbak IS
    'Sales document header. Covers orders and contracts alike, which is how an athlete contract and a ticket sale come to share a table.';
COMMENT ON TABLE sap_s4.vbap IS
    'Sales document item.';
COMMENT ON TABLE sap_s4.vbrp IS
    'Billing document item, carrying the originating sales document so revenue traces back to the order that produced it.';
COMMENT ON TABLE sap_s4.rbkp IS
    'Vendor invoice header. The RBSTAT three-way-match state is what holds an invoice back from payment on a quantity or price variance.';
COMMENT ON TABLE sap_s4.rseg IS
    'Vendor invoice item. Royalty lines carry the licence contract they settle, which is how target merchandise.royalty_payment resolves to an agreement.';
COMMENT ON TABLE sap_s4.bsik IS
    'Open vendor items. Like BSID, rows are DELETED when the item clears rather than flagged, so a watermark extract can never observe a payment.';
COMMENT ON TABLE sap_s4.reguh IS
    'Automatic payment run header. Feeds target finance.payment_run; the XVORL flag separates a proposal from an actual payment, and reporting that ignores it overstates cash out.';
COMMENT ON TABLE sap_s4.regup IS
    'Payment run item. Cannot reference REGUH: the item key omits XVORL, LIFNR and KUNNR, which are all in the header key.';

-- Plant maintenance.
COMMENT ON TABLE sap_s4.aufk IS
    'Order master, including maintenance orders. Planned against actual cost is the budget variance facilities managers are held to.';
COMMENT ON TABLE sap_s4.afih IS
    'Maintenance order header: equipment, functional location, priority and the breakdown flag that drives the response-time commitment.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE sap_s4.t001 IS
    'Company code -- the legal entity and the unit of external reporting. Also doing duty as the league and franchise structure, which is a documented compromise rather than a good fit.';
COMMENT ON TABLE sap_s4.csks IS
    'Cost centre, time-dependent: the key ends in a validity date, so one centre has several rows over its life and the target model keeps only one.';
COMMENT ON TABLE sap_s4.cepc IS
    'Profit centre, time-dependent. Four target tables map here -- finance.profit_center plus league.conference, division and team -- separated only by the structure_level column.';
COMMENT ON TABLE sap_s4.bkpf IS
    'Accounting document header. Posted documents are immutable: a correction is a second, reversing document, so any sum that ignores reversals double-counts.';
COMMENT ON TABLE sap_s4.bseg IS
    'Accounting document line item, and the grain of target finance.journal_entry. Amounts are unsigned with the debit/credit sign in a separate character, which is the commonest source of sign errors in an extract.';
COMMENT ON TABLE sap_s4.vbrk IS
    'Billing document header. Only documents released to accounting have hit the ledger, so revenue reporting that ignores the release status counts invoices that do not yet exist in the GL.';
COMMENT ON TABLE sap_s4.mard IS
    'Stock balance per material and storage location. Three buckets -- unrestricted, in inspection, blocked -- collapse to one quantity in the target model, which overstates what is actually sellable.';
COMMENT ON TABLE sap_s4.konp IS
    'Pricing condition values. Rows are marked deleted rather than removed, so an extract that ignores the flag loads prices no longer in force.';
COMMENT ON TABLE sap_s4.veda IS
    'Contract data, and the busiest table in the mapping: eight target tables reach it. SAP does not care what a contract is about, so the contract_category column is what keeps them apart.';
