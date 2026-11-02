-- =========================================================================
-- sap_s4 -- indexes
--
-- SAP's own secondary indexes are what make a real system queryable at all,
-- because the primary keys all lead with MANDT and then the organisational
-- unit -- useless for "find the document for this reference" or "age the open
-- items". The ones declared here are the paths the extract and the
-- month-end close actually use.
--
-- Note the shape of every leading column: MANDT first, mirroring the primary
-- keys, because any real query filters the client before anything else.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Master data lookups.
-- -------------------------------------------------------------------------
CREATE INDEX ix_t001w_company       ON sap_s4.t001w (mandt, bukrs);
CREATE INDEX ix_t001w_archtics
    ON sap_s4.t001w (archtics_building_code) WHERE archtics_building_code IS NOT NULL;
-- The league structure lives in these two tables, so the role columns that
-- separate it from the operating companies are worth indexing.
CREATE INDEX ix_t001_entity_role    ON sap_s4.t001 (mandt, entity_role);
CREATE INDEX ix_cepc_structure
    ON sap_s4.cepc (mandt, structure_level) WHERE structure_level IS NOT NULL;
CREATE INDEX ix_cepc_hierarchy
    ON sap_s4.cepc (mandt, hier_node) WHERE hier_node IS NOT NULL;

-- Time-dependent master data is resolved by validity window, so the window is
-- the index.
CREATE INDEX ix_csks_validity       ON sap_s4.csks (mandt, kostl, datab, datbi);
CREATE INDEX ix_csks_company        ON sap_s4.csks (mandt, bukrs);
CREATE INDEX ix_csks_profit_center  ON sap_s4.csks (mandt, prctr) WHERE prctr IS NOT NULL;
CREATE INDEX ix_cepc_validity       ON sap_s4.cepc (mandt, prctr, datab, datbi);
CREATE INDEX ix_cepc_company        ON sap_s4.cepc (mandt, bukrs) WHERE bukrs IS NOT NULL;

-- The period-open check, run before every posting.
CREATE INDEX ix_t009b_open_periods
    ON sap_s4.t009b (mandt, periv, bdatj, poper) WHERE period_status = 'open';
CREATE INDEX ix_t009b_date_range    ON sap_s4.t009b (mandt, period_start_on, period_end_on);

CREATE INDEX ix_skb1_company        ON sap_s4.skb1 (mandt, bukrs);
-- Open-item managed accounts are the ones AR and AP ageing touches.
CREATE INDEX ix_skb1_open_item      ON sap_s4.skb1 (mandt, bukrs) WHERE xopvw;
CREATE INDEX ix_ska1_group          ON sap_s4.ska1 (mandt, ktopl, ktoks) WHERE NOT xloev;

CREATE INDEX ix_kna1_name           ON sap_s4.kna1 (mandt, name1);
CREATE INDEX ix_kna1_sortl          ON sap_s4.kna1 (mandt, sortl) WHERE sortl IS NOT NULL;
CREATE INDEX ix_kna1_sfdc
    ON sap_s4.kna1 (sfdc_account_id) WHERE sfdc_account_id IS NOT NULL;
CREATE INDEX ix_knb1_customer       ON sap_s4.knb1 (mandt, kunnr);
CREATE INDEX ix_knb1_company        ON sap_s4.knb1 (mandt, bukrs);

CREATE INDEX ix_lfa1_name           ON sap_s4.lfa1 (mandt, name1);
CREATE INDEX ix_lfa1_role           ON sap_s4.lfa1 (mandt, vendor_role) WHERE NOT loevm;
CREATE INDEX ix_lfb1_vendor         ON sap_s4.lfb1 (mandt, lifnr);
CREATE INDEX ix_lfb1_company        ON sap_s4.lfb1 (mandt, bukrs);

CREATE INDEX ix_mara_group          ON sap_s4.mara (mandt, matkl) WHERE NOT lvorm;
CREATE INDEX ix_mara_licensed       ON sap_s4.mara (mandt, licensor_lifnr) WHERE is_licensed;
CREATE INDEX ix_mara_shopify
    ON sap_s4.mara (shopify_variant_id) WHERE shopify_variant_id IS NOT NULL;
CREATE INDEX ix_marc_material       ON sap_s4.marc (mandt, matnr);
CREATE INDEX ix_marc_plant          ON sap_s4.marc (mandt, werks);
CREATE INDEX ix_mard_material       ON sap_s4.mard (mandt, matnr);
CREATE INDEX ix_mard_location       ON sap_s4.mard (mandt, werks, lgort);
-- Replenishment: stock below the reorder point.
CREATE INDEX ix_mard_stock_level    ON sap_s4.mard (mandt, werks, matnr, labst);

CREATE INDEX ix_anla_company        ON sap_s4.anla (mandt, bukrs);
CREATE INDEX ix_anla_cost_center    ON sap_s4.anla (mandt, kostl) WHERE kostl IS NOT NULL;
CREATE INDEX ix_anla_plant          ON sap_s4.anla (mandt, werks) WHERE werks IS NOT NULL;
CREATE INDEX ix_anla_active         ON sap_s4.anla (mandt, anlkl) WHERE deakt IS NULL;
CREATE INDEX ix_anlc_asset          ON sap_s4.anlc (mandt, bukrs, anln1, anln2);

-- The contract table is reached by eight target tables, so the category is the
-- most important index in the schema.
CREATE INDEX ix_veda_category       ON sap_s4.veda (mandt, contract_category);
CREATE INDEX ix_veda_customer       ON sap_s4.veda (mandt, kunnr) WHERE kunnr IS NOT NULL;
CREATE INDEX ix_veda_vendor         ON sap_s4.veda (mandt, lifnr) WHERE lifnr IS NOT NULL;
-- Expiry sweep, which drives the free-agency derivation and renewal campaigns.
CREATE INDEX ix_veda_expiry         ON sap_s4.veda (mandt, vendat) WHERE vkdat IS NULL;

CREATE INDEX ix_a004_material       ON sap_s4.a004 (mandt, matnr, datbi);
CREATE INDEX ix_a004_condition_rec  ON sap_s4.a004 (mandt, knumh);
-- Live condition records only.
CREATE INDEX ix_konp_record         ON sap_s4.konp (mandt, knumh) WHERE NOT loevm_ko;

-- -------------------------------------------------------------------------
-- Documents.
-- -------------------------------------------------------------------------
-- Posting date is the primary reporting axis, and the one the primary key
-- cannot serve.
CREATE INDEX ix_bkpf_posting_date   ON sap_s4.bkpf (mandt, bukrs, budat);
CREATE INDEX ix_bkpf_period         ON sap_s4.bkpf (mandt, bukrs, gjahr, monat);
CREATE INDEX ix_bkpf_type           ON sap_s4.bkpf (mandt, blart, budat);
CREATE INDEX ix_bkpf_ledger         ON sap_s4.bkpf (mandt, rldnr);
-- Trace a ledger entry back to the ticketing or merchandise order that caused
-- it. This is the reconciliation path.
CREATE INDEX ix_bkpf_reference      ON sap_s4.bkpf (mandt, awtyp, awkey) WHERE awkey IS NOT NULL;
CREATE INDEX ix_bkpf_ref_doc        ON sap_s4.bkpf (mandt, xblnr) WHERE xblnr IS NOT NULL;
-- Reversed and reversing documents, which must be excluded from any sum.
CREATE INDEX ix_bkpf_reversals      ON sap_s4.bkpf (mandt, stblg) WHERE stblg IS NOT NULL;

CREATE INDEX ix_bseg_document       ON sap_s4.bseg (mandt, bukrs, belnr, gjahr);
CREATE INDEX ix_bseg_account        ON sap_s4.bseg (mandt, hkont) WHERE hkont IS NOT NULL;
CREATE INDEX ix_bseg_cost_center    ON sap_s4.bseg (mandt, kostl) WHERE kostl IS NOT NULL;
CREATE INDEX ix_bseg_profit_center  ON sap_s4.bseg (mandt, prctr) WHERE prctr IS NOT NULL;
CREATE INDEX ix_bseg_customer       ON sap_s4.bseg (mandt, kunnr) WHERE kunnr IS NOT NULL;
CREATE INDEX ix_bseg_vendor         ON sap_s4.bseg (mandt, lifnr) WHERE lifnr IS NOT NULL;
CREATE INDEX ix_bseg_material       ON sap_s4.bseg (mandt, matnr) WHERE matnr IS NOT NULL;
CREATE INDEX ix_bseg_plant          ON sap_s4.bseg (mandt, werks) WHERE werks IS NOT NULL;
-- Uncleared lines: the open-item population.
CREATE INDEX ix_bseg_open_items     ON sap_s4.bseg (mandt, bukrs, hkont) WHERE augbl IS NULL;

CREATE INDEX ix_faglflexa_ledger_period
    ON sap_s4.faglflexa (mandt, rldnr, rbukrs, ryear, poper);
CREATE INDEX ix_faglflexa_account   ON sap_s4.faglflexa (mandt, racct, budat);
CREATE INDEX ix_faglflexa_profit_center
    ON sap_s4.faglflexa (mandt, prctr) WHERE prctr IS NOT NULL;
CREATE INDEX ix_faglflexa_company   ON sap_s4.faglflexa (mandt, rbukrs);

-- AR/AP ageing reads the generated due date.
CREATE INDEX ix_bsid_due            ON sap_s4.bsid (mandt, bukrs, due_on);
CREATE INDEX ix_bsid_customer       ON sap_s4.bsid (mandt, kunnr, due_on);
CREATE INDEX ix_bsid_company        ON sap_s4.bsid (mandt, bukrs);
-- The dunning worklist.
CREATE INDEX ix_bsid_dunning        ON sap_s4.bsid (mandt, bukrs, mahns) WHERE mahns > 0;
CREATE INDEX ix_bsik_due            ON sap_s4.bsik (mandt, bukrs, due_on);
CREATE INDEX ix_bsik_vendor         ON sap_s4.bsik (mandt, lifnr, due_on);
CREATE INDEX ix_bsik_company        ON sap_s4.bsik (mandt, bukrs);
-- Payment proposal: due, unblocked items.
CREATE INDEX ix_bsik_payable        ON sap_s4.bsik (mandt, bukrs, due_on) WHERE zlspr IS NULL;

CREATE INDEX ix_vbak_customer       ON sap_s4.vbak (mandt, kunnr, erdat);
CREATE INDEX ix_vbak_type_date      ON sap_s4.vbak (mandt, auart, erdat);
CREATE INDEX ix_vbap_document       ON sap_s4.vbap (mandt, vbeln);
CREATE INDEX ix_vbap_material       ON sap_s4.vbap (mandt, matnr) WHERE matnr IS NOT NULL;

CREATE INDEX ix_vbrk_billing_date   ON sap_s4.vbrk (mandt, bukrs, fkdat);
CREATE INDEX ix_vbrk_payer          ON sap_s4.vbrk (mandt, kunrg, fkdat);
CREATE INDEX ix_vbrk_company        ON sap_s4.vbrk (mandt, bukrs);
CREATE INDEX ix_vbrk_accounting_doc
    ON sap_s4.vbrk (mandt, bukrs, belnr, gjahr) WHERE belnr IS NOT NULL;
-- The month-end worklist: billed but not released to accounting.
CREATE INDEX ix_vbrk_not_released   ON sap_s4.vbrk (mandt, bukrs, fkdat) WHERE rfbsk <> 'C';
CREATE INDEX ix_vbrp_document       ON sap_s4.vbrp (mandt, vbeln);
CREATE INDEX ix_vbrp_material       ON sap_s4.vbrp (mandt, matnr) WHERE matnr IS NOT NULL;
CREATE INDEX ix_vbrp_sales_doc      ON sap_s4.vbrp (mandt, aubel) WHERE aubel IS NOT NULL;
CREATE INDEX ix_vbrp_profit_center  ON sap_s4.vbrp (mandt, prctr) WHERE prctr IS NOT NULL;

CREATE INDEX ix_rbkp_vendor         ON sap_s4.rbkp (mandt, lifnr, budat);
CREATE INDEX ix_rbkp_company        ON sap_s4.rbkp (mandt, bukrs);
CREATE INDEX ix_rbkp_vendor_ref     ON sap_s4.rbkp (mandt, xblnr) WHERE xblnr IS NOT NULL;
-- Blocked invoices: the three-way-match exception queue.
CREATE INDEX ix_rbkp_blocked        ON sap_s4.rbkp (mandt, bukrs, budat)
    WHERE rbstat <> '5' OR zlspr IS NOT NULL;
CREATE INDEX ix_rseg_document       ON sap_s4.rseg (mandt, belnr, gjahr);
CREATE INDEX ix_rseg_material       ON sap_s4.rseg (mandt, matnr) WHERE matnr IS NOT NULL;
CREATE INDEX ix_rseg_plant          ON sap_s4.rseg (mandt, werks) WHERE werks IS NOT NULL;
-- Royalty settlement by licence contract.
CREATE INDEX ix_rseg_licence        ON sap_s4.rseg (mandt, licence_vbeln) WHERE licence_vbeln IS NOT NULL;

CREATE INDEX ix_reguh_run           ON sap_s4.reguh (mandt, laufd, laufi);
CREATE INDEX ix_reguh_vendor        ON sap_s4.reguh (mandt, lifnr) WHERE btrim(lifnr) <> '';
CREATE INDEX ix_reguh_customer      ON sap_s4.reguh (mandt, kunnr) WHERE btrim(kunnr) <> '';
CREATE INDEX ix_reguh_payment_doc   ON sap_s4.reguh (mandt, vblnr) WHERE vblnr IS NOT NULL;
CREATE INDEX ix_reguh_company       ON sap_s4.reguh (mandt, zbukr);
-- Proposals are not payments; reporting must exclude them.
CREATE INDEX ix_reguh_actual        ON sap_s4.reguh (mandt, zbukr, laufd) WHERE NOT xvorl;
CREATE INDEX ix_regup_settled_doc   ON sap_s4.regup (mandt, bukrs, belnr, gjahr);
CREATE INDEX ix_regup_run           ON sap_s4.regup (mandt, laufd, laufi);

-- -------------------------------------------------------------------------
-- Plant maintenance.
-- -------------------------------------------------------------------------
CREATE INDEX ix_aufk_plant          ON sap_s4.aufk (mandt, werks, erdat);
CREATE INDEX ix_aufk_company        ON sap_s4.aufk (mandt, bukrs);
CREATE INDEX ix_aufk_cost_center    ON sap_s4.aufk (mandt, kostl) WHERE kostl IS NOT NULL;
-- Open orders, which is the facilities backlog.
CREATE INDEX ix_aufk_open           ON sap_s4.aufk (mandt, werks, erdat)
    WHERE order_status NOT IN ('closed', 'cancelled');
CREATE INDEX ix_afih_order          ON sap_s4.afih (mandt, aufnr);
CREATE INDEX ix_afih_equipment      ON sap_s4.afih (mandt, equnr) WHERE equnr IS NOT NULL;
CREATE INDEX ix_afih_location       ON sap_s4.afih (mandt, tplnr) WHERE tplnr IS NOT NULL;
CREATE INDEX ix_afih_planning_plant ON sap_s4.afih (mandt, iwerk) WHERE iwerk IS NOT NULL;
-- Breakdowns, which carry a response-time commitment.
CREATE INDEX ix_afih_breakdowns     ON sap_s4.afih (mandt, addat) WHERE msaus;
CREATE INDEX ix_qmel_order          ON sap_s4.qmel (mandt, aufnr) WHERE aufnr IS NOT NULL;
CREATE INDEX ix_qmel_plant_date     ON sap_s4.qmel (mandt, werks, qmdat);
CREATE INDEX ix_qmel_equipment      ON sap_s4.qmel (mandt, equnr) WHERE equnr IS NOT NULL;
-- Overdue notifications with no order raised yet.
CREATE INDEX ix_qmel_unassigned     ON sap_s4.qmel (mandt, ltrmn)
    WHERE aufnr IS NULL AND notification_status IN ('outstanding', 'in_process');

-- -------------------------------------------------------------------------
-- Incremental extraction watermarks.
-- -------------------------------------------------------------------------
CREATE INDEX ix_t001_updated_at     ON sap_s4.t001 (updated_at);
CREATE INDEX ix_csks_updated_at     ON sap_s4.csks (updated_at);
CREATE INDEX ix_cepc_updated_at     ON sap_s4.cepc (updated_at);
CREATE INDEX ix_ska1_updated_at     ON sap_s4.ska1 (updated_at);
CREATE INDEX ix_kna1_updated_at     ON sap_s4.kna1 (updated_at);
CREATE INDEX ix_lfa1_updated_at     ON sap_s4.lfa1 (updated_at);
CREATE INDEX ix_mara_updated_at     ON sap_s4.mara (updated_at);
CREATE INDEX ix_mard_updated_at     ON sap_s4.mard (updated_at);
CREATE INDEX ix_veda_updated_at     ON sap_s4.veda (updated_at);
CREATE INDEX ix_bkpf_updated_at     ON sap_s4.bkpf (updated_at);
CREATE INDEX ix_bseg_updated_at     ON sap_s4.bseg (updated_at);
CREATE INDEX ix_vbrk_updated_at     ON sap_s4.vbrk (updated_at);
CREATE INDEX ix_rbkp_updated_at     ON sap_s4.rbkp (updated_at);
CREATE INDEX ix_reguh_updated_at    ON sap_s4.reguh (updated_at);
CREATE INDEX ix_aufk_updated_at     ON sap_s4.aufk (updated_at);
-- The open-item tables are the ones where deletes are routine business, so the
-- change log carries them -- but the watermark index is still needed for the
-- insert and update stream.
CREATE INDEX ix_bsid_updated_at     ON sap_s4.bsid (updated_at);
CREATE INDEX ix_bsik_updated_at     ON sap_s4.bsik (updated_at);
