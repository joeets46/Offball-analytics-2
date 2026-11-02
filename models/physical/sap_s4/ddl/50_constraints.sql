-- =========================================================================
-- sap_s4 -- foreign keys
--
-- A real SAP system declares almost no database-level referential integrity:
-- it enforces "check tables" in the application layer instead. The keys are
-- declared here anyway, because a reference model should state the
-- relationships it means -- but only where the key structure actually permits
-- it, and that is the interesting part.
--
-- Four relationships that obviously exist CANNOT be declared, and each one is
-- a real obstacle for anyone building the extract:
--
--   1. SKB1 -> SKA1. The company-code view of a GL account is keyed
--      (MANDT, BUKRS, SAKNR); the chart-of-accounts view is keyed
--      (MANDT, KTOPL, SAKNR). SKB1 does not carry KTOPL, so the join has to go
--      through T001.KTOPL. Target finance.gl_account therefore needs a
--      three-table join, not two.
--
--   2. BSEG -> CSKS and BSEG -> CEPC. Cost and profit centres are
--      time-dependent: their key ends in DATBI, a validity date. A posting
--      line carries only the centre code, so resolving it means selecting the
--      row whose validity window contains the posting date. No foreign key
--      can express that, and an extract that joins on code alone fans out to
--      one row per historical version.
--
--   3. KONP -> A004. The condition record number KNUMH is not a unique key of
--      A004 -- A004 is keyed on the access combination -- so the pricing
--      lookup is a join on a non-unique column by design.
--
--   4. REGUP -> REGUH. The payment-run item key omits XVORL, LIFNR and KUNNR,
--      which are all in the header key, so the child cannot reference its own
--      parent.
--
-- Where a reference is to time-dependent master data, the column is left
-- unconstrained and the resolution rule is documented on the column instead.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Organisational structure.
-- -------------------------------------------------------------------------
ALTER TABLE sap_s4.t001
    ADD CONSTRAINT fk_t001_fiscal_variant
        FOREIGN KEY (mandt, periv) REFERENCES sap_s4.t009 (mandt, periv)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.t001w
    ADD CONSTRAINT fk_t001w_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.t001l
    ADD CONSTRAINT fk_t001l_plant
        FOREIGN KEY (mandt, werks) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE CASCADE;

ALTER TABLE sap_s4.t009b
    ADD CONSTRAINT fk_t009b_variant
        FOREIGN KEY (mandt, periv) REFERENCES sap_s4.t009 (mandt, periv)
        ON DELETE CASCADE;

ALTER TABLE sap_s4.csks
    ADD CONSTRAINT fk_csks_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.cepc
    ADD CONSTRAINT fk_cepc_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Master data. The general/organisational view pairs.
-- -------------------------------------------------------------------------
-- SKB1 cannot reference SKA1 (see the header note); it references the company
-- code, which is what carries the chart of accounts.
ALTER TABLE sap_s4.skb1
    ADD CONSTRAINT fk_skb1_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.knb1
    ADD CONSTRAINT fk_knb1_customer
        FOREIGN KEY (mandt, kunnr) REFERENCES sap_s4.kna1 (mandt, kunnr)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_knb1_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.lfb1
    ADD CONSTRAINT fk_lfb1_vendor
        FOREIGN KEY (mandt, lifnr) REFERENCES sap_s4.lfa1 (mandt, lifnr)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_lfb1_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.mara
    ADD CONSTRAINT fk_mara_licensor
        FOREIGN KEY (mandt, licensor_lifnr) REFERENCES sap_s4.lfa1 (mandt, lifnr)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.marc
    ADD CONSTRAINT fk_marc_material
        FOREIGN KEY (mandt, matnr) REFERENCES sap_s4.mara (mandt, matnr)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_marc_plant
        FOREIGN KEY (mandt, werks) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.mard
    ADD CONSTRAINT fk_mard_material_plant
        FOREIGN KEY (mandt, matnr, werks) REFERENCES sap_s4.marc (mandt, matnr, werks)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_mard_storage_location
        FOREIGN KEY (mandt, werks, lgort) REFERENCES sap_s4.t001l (mandt, werks, lgort)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.anla
    ADD CONSTRAINT fk_anla_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_anla_plant
        FOREIGN KEY (mandt, werks) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.anlc
    ADD CONSTRAINT fk_anlc_asset
        FOREIGN KEY (mandt, bukrs, anln1, anln2)
        REFERENCES sap_s4.anla (mandt, bukrs, anln1, anln2)
        ON DELETE CASCADE;

ALTER TABLE sap_s4.veda
    ADD CONSTRAINT fk_veda_customer
        FOREIGN KEY (mandt, kunnr) REFERENCES sap_s4.kna1 (mandt, kunnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_veda_vendor
        FOREIGN KEY (mandt, lifnr) REFERENCES sap_s4.lfa1 (mandt, lifnr)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.a004
    ADD CONSTRAINT fk_a004_material
        FOREIGN KEY (mandt, matnr) REFERENCES sap_s4.mara (mandt, matnr)
        ON DELETE CASCADE;

-- -------------------------------------------------------------------------
-- Documents. Every header/line pair cascades: a line has no meaning without
-- its document. Nothing else does -- accounting records are never deleted.
-- -------------------------------------------------------------------------
ALTER TABLE sap_s4.bkpf
    ADD CONSTRAINT fk_bkpf_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_bkpf_ledger
        FOREIGN KEY (mandt, rldnr) REFERENCES sap_s4.t881 (mandt, rldnr)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.bseg
    ADD CONSTRAINT fk_bseg_document
        FOREIGN KEY (mandt, bukrs, belnr, gjahr)
        REFERENCES sap_s4.bkpf (mandt, bukrs, belnr, gjahr)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_bseg_customer
        FOREIGN KEY (mandt, kunnr) REFERENCES sap_s4.kna1 (mandt, kunnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_bseg_vendor
        FOREIGN KEY (mandt, lifnr) REFERENCES sap_s4.lfa1 (mandt, lifnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_bseg_material
        FOREIGN KEY (mandt, matnr) REFERENCES sap_s4.mara (mandt, matnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_bseg_plant
        FOREIGN KEY (mandt, werks) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE RESTRICT;

COMMENT ON COLUMN sap_s4.bseg.kostl IS
    'Cost centre code only. Deliberately unconstrained: CSKS is time-dependent '
    'and keyed on a validity date this row does not carry, so resolution means '
    'picking the CSKS row whose DATAB..DATBI window contains BUDAT.';
COMMENT ON COLUMN sap_s4.bseg.prctr IS
    'Profit centre code only. Unconstrained for the same reason as KOSTL: CEPC '
    'is time-dependent. Joining on code alone fans out across every version.';

ALTER TABLE sap_s4.faglflexa
    ADD CONSTRAINT fk_faglflexa_ledger
        FOREIGN KEY (mandt, rldnr) REFERENCES sap_s4.t881 (mandt, rldnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_faglflexa_company
        FOREIGN KEY (mandt, rbukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.bsid
    ADD CONSTRAINT fk_bsid_customer
        FOREIGN KEY (mandt, kunnr) REFERENCES sap_s4.kna1 (mandt, kunnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_bsid_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.bsik
    ADD CONSTRAINT fk_bsik_vendor
        FOREIGN KEY (mandt, lifnr) REFERENCES sap_s4.lfa1 (mandt, lifnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_bsik_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.vbak
    ADD CONSTRAINT fk_vbak_customer
        FOREIGN KEY (mandt, kunnr) REFERENCES sap_s4.kna1 (mandt, kunnr)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.vbap
    ADD CONSTRAINT fk_vbap_document
        FOREIGN KEY (mandt, vbeln) REFERENCES sap_s4.vbak (mandt, vbeln)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_vbap_material
        FOREIGN KEY (mandt, matnr) REFERENCES sap_s4.mara (mandt, matnr)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.vbrk
    ADD CONSTRAINT fk_vbrk_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_vbrk_payer
        FOREIGN KEY (mandt, kunrg) REFERENCES sap_s4.kna1 (mandt, kunnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_vbrk_accounting_document
        FOREIGN KEY (mandt, bukrs, belnr, gjahr)
        REFERENCES sap_s4.bkpf (mandt, bukrs, belnr, gjahr)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.vbrp
    ADD CONSTRAINT fk_vbrp_document
        FOREIGN KEY (mandt, vbeln) REFERENCES sap_s4.vbrk (mandt, vbeln)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_vbrp_material
        FOREIGN KEY (mandt, matnr) REFERENCES sap_s4.mara (mandt, matnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_vbrp_sales_document
        FOREIGN KEY (mandt, aubel) REFERENCES sap_s4.vbak (mandt, vbeln)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.rbkp
    ADD CONSTRAINT fk_rbkp_vendor
        FOREIGN KEY (mandt, lifnr) REFERENCES sap_s4.lfa1 (mandt, lifnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_rbkp_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.rseg
    ADD CONSTRAINT fk_rseg_document
        FOREIGN KEY (mandt, belnr, gjahr) REFERENCES sap_s4.rbkp (mandt, belnr, gjahr)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_rseg_material
        FOREIGN KEY (mandt, matnr) REFERENCES sap_s4.mara (mandt, matnr)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_rseg_plant
        FOREIGN KEY (mandt, werks) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.reguh
    ADD CONSTRAINT fk_reguh_paying_company
        FOREIGN KEY (mandt, zbukr) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT;

-- REGUP cannot reference REGUH (see the header note), so it references the
-- document it settles instead.
ALTER TABLE sap_s4.regup
    ADD CONSTRAINT fk_regup_settled_document
        FOREIGN KEY (mandt, bukrs, belnr, gjahr)
        REFERENCES sap_s4.bkpf (mandt, bukrs, belnr, gjahr)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Plant maintenance.
-- -------------------------------------------------------------------------
ALTER TABLE sap_s4.aufk
    ADD CONSTRAINT fk_aufk_company
        FOREIGN KEY (mandt, bukrs) REFERENCES sap_s4.t001 (mandt, bukrs)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_aufk_plant
        FOREIGN KEY (mandt, werks) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.afih
    ADD CONSTRAINT fk_afih_order
        FOREIGN KEY (mandt, aufnr) REFERENCES sap_s4.aufk (mandt, aufnr)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_afih_planning_plant
        FOREIGN KEY (mandt, iwerk) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE RESTRICT;

ALTER TABLE sap_s4.qmel
    ADD CONSTRAINT fk_qmel_order
        FOREIGN KEY (mandt, aufnr) REFERENCES sap_s4.aufk (mandt, aufnr)
        -- Column list on SET NULL (PG 15+): without it the action would try to
        -- null MANDT, which is NOT NULL.
        ON DELETE SET NULL (aufnr),
    ADD CONSTRAINT fk_qmel_plant
        FOREIGN KEY (mandt, werks) REFERENCES sap_s4.t001w (mandt, werks)
        ON DELETE RESTRICT;
