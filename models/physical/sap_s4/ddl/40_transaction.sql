-- =========================================================================
-- sap_s4 -- documents
--
-- The ledger itself: accounting documents, billing, vendor invoices, payment
-- runs, sales orders and maintenance orders.
--
-- The header/line split is universal in SAP and is the reason nearly every
-- finance mapping is a `join`: BKPF/BSEG, VBRK/VBRP, RBKP/RSEG, VBAK/VBAP,
-- REGUH/REGUP. The document number is unique only within a company code and
-- fiscal year, so the key is always composite.
-- =========================================================================

-- -------------------------------------------------------------------------
-- BKPF -- Accounting document header.
-- BSEG -- Accounting document line item.
--
-- Together with FAGLFLEXA they feed target finance.journal_entry, whose grain
-- is the document line, not the document. A 400-line payroll posting becomes
-- 400 target rows that repeat the header 400 times.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.bkpf (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    belnr       CHAR(10)     NOT NULL,   -- document number
    gjahr       SMALLINT     NOT NULL CHECK (gjahr BETWEEN 1850 AND 2200),
    blart       CHAR(2)      NOT NULL,   -- document type
    bldat       DATE         NOT NULL,   -- document date
    budat       DATE         NOT NULL,   -- posting date
    monat       SMALLINT     NOT NULL CHECK (monat BETWEEN 1 AND 16),  -- period
    cpudt       DATE         NOT NULL,   -- entry date
    usnam       VARCHAR(12)  NOT NULL,   -- entered by
    tcode       CHAR(20),                -- transaction code
    waers       CHAR(3)      NOT NULL,   -- document currency
    kursf       NUMERIC(13,5),           -- exchange rate
    xblnr       VARCHAR(16),             -- reference document number
    bktxt       VARCHAR(25),             -- document header text
    rldnr       CHAR(2)      NOT NULL DEFAULT '0L',  -- ledger
    -- Reversal is by counter-document, never by deletion. An accounting
    -- document is immutable once posted; this is the whole basis of SOX
    -- auditability and the reason the change log here has no delete path.
    stblg       CHAR(10),                -- reversal document number
    stjah       SMALLINT,                -- reversal fiscal year
    xreversal   CHAR(1)      CHECK (xreversal IS NULL OR xreversal IN ('1', '2')),
    -- Business key back to the originating system, so ticketing and
    -- merchandise revenue can be traced to its source.
    awtyp       CHAR(5),                 -- reference transaction type
    awkey       VARCHAR(20),             -- reference key
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs, belnr, gjahr),
    -- Posting date cannot precede the document date in a well-formed posting.
    CONSTRAINT ck_bkpf_posting_not_before_document CHECK (budat >= bldat),
    CONSTRAINT ck_bkpf_reversal_pair
        CHECK ((stblg IS NULL) = (stjah IS NULL))
);

COMMENT ON COLUMN sap_s4.bkpf.awkey IS
    'Reference key into the originating system. For ticketing revenue this '
    'carries the TM/AXS billing document, which is what makes the '
    'order-to-ledger reconciliation possible at all.';
COMMENT ON COLUMN sap_s4.bkpf.stblg IS
    'Reversal document. Posted documents are never updated or deleted, so '
    'corrections appear as a second document -- and a naive extract that sums '
    'without excluding reversals double-counts.';

CREATE TABLE sap_s4.bseg (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    belnr       CHAR(10)     NOT NULL,
    gjahr       SMALLINT     NOT NULL,
    buzei       SMALLINT     NOT NULL CHECK (buzei > 0),  -- line item
    -- Debit/credit indicator. SAP stores the amount unsigned and the sign in
    -- this one character, which is the commonest source of sign errors in an
    -- extract: DMBTR is always positive.
    shkzg       CHAR(1)      NOT NULL CHECK (shkzg IN ('S', 'H')),
    dmbtr       NUMERIC(18,2) NOT NULL CHECK (dmbtr >= 0),  -- amount in local currency
    wrbtr       NUMERIC(18,2) NOT NULL CHECK (wrbtr >= 0),  -- amount in document currency
    -- Signed amount, generated. Derived rather than stored so no extract has
    -- to remember the SHKZG rule.
    signed_amount NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (CASE WHEN shkzg = 'S' THEN dmbtr ELSE -dmbtr END) STORED,
    hkont       CHAR(10),                -- GL account
    kostl       CHAR(10),                -- cost centre
    prctr       CHAR(10),                -- profit centre
    kunnr       CHAR(10),                -- customer
    lifnr       CHAR(10),                -- vendor
    matnr       CHAR(18),                -- material
    werks       CHAR(4),                 -- plant
    mwskz       CHAR(2),                 -- tax code
    zuonr       VARCHAR(18),             -- assignment number
    sgtxt       VARCHAR(50),             -- line item text
    -- Clearing state. An open item is unpaid; a cleared one has a clearing
    -- document. This is what AR and AP ageing reads.
    augbl       CHAR(10),                -- clearing document
    augdt       DATE,                    -- clearing date
    zfbdt       DATE,                    -- baseline date for due date
    zbd1t       SMALLINT,                -- payment terms days
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs, belnr, gjahr, buzei),
    CONSTRAINT ck_bseg_clearing_pair CHECK ((augbl IS NULL) = (augdt IS NULL)),
    -- A line posts to a GL account, a customer or a vendor.
    CONSTRAINT ck_bseg_has_account
        CHECK (hkont IS NOT NULL OR kunnr IS NOT NULL OR lifnr IS NOT NULL)
);

COMMENT ON COLUMN sap_s4.bseg.signed_amount IS
    'Generated from SHKZG and DMBTR. SAP stores amounts unsigned with the '
    'debit/credit sign in a separate character; extracts that miss this '
    'produce a trial balance that does not net to zero.';

-- -------------------------------------------------------------------------
-- FAGLFLEXA -- General ledger line item (the universal journal view).
--
-- S/4HANA's ACDOCA successor table. Kept separate from BSEG because the
-- ledger split means one BSEG line can produce several GL lines, one per
-- parallel ledger.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.faglflexa (
    mandt       CHAR(3)      NOT NULL,
    ryear       SMALLINT     NOT NULL CHECK (ryear BETWEEN 1850 AND 2200),
    docnr       CHAR(10)     NOT NULL,
    rldnr       CHAR(2)      NOT NULL,
    rbukrs      CHAR(4)      NOT NULL,
    docln       SMALLINT     NOT NULL CHECK (docln > 0),
    racct       CHAR(10)     NOT NULL,   -- account
    rcntr       CHAR(10),                -- cost centre
    prctr       CHAR(10),                -- profit centre
    segment     CHAR(10),
    -- Three currency columns: transaction, company code and group. Group
    -- reporting consolidates on HSL, and the target model carries one amount.
    tsl         NUMERIC(18,2) NOT NULL DEFAULT 0,  -- transaction currency
    hsl         NUMERIC(18,2) NOT NULL DEFAULT 0,  -- company code currency
    ksl         NUMERIC(18,2) NOT NULL DEFAULT 0,  -- group currency
    rtcur       CHAR(3)      NOT NULL,
    drcrk       CHAR(1)      NOT NULL CHECK (drcrk IN ('S', 'H')),
    budat       DATE         NOT NULL,
    poper       SMALLINT     NOT NULL CHECK (poper BETWEEN 1 AND 16),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, ryear, docnr, rldnr, rbukrs, docln)
);

COMMENT ON TABLE sap_s4.faglflexa IS
    'GL line items per ledger. One BSEG line becomes several rows here when '
    'parallel ledgers value it differently -- so a target finance.journal_entry '
    'built from this table without a ledger filter multiplies every amount.';

-- -------------------------------------------------------------------------
-- BSID / BSIK -- Open AR and AP items.
--
-- Index tables: SAP maintains them as a fast path to unpaid items, and a row
-- disappears from them the moment the item clears. Cleared items move to BSAD
-- and BSAK, which are out of scope here.
--
-- This is the one place in the whole source model where a delete is routine
-- business rather than an anomaly, and it is the strongest argument for the
-- change log: an extract on updated_at alone would never see an item get paid.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.bsid (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    kunnr       CHAR(10)     NOT NULL,
    umsks       CHAR(1)      NOT NULL DEFAULT ' ',
    umskz       CHAR(1)      NOT NULL DEFAULT ' ',
    augdt       DATE         NOT NULL DEFAULT '9999-12-31',
    augbl       CHAR(10)     NOT NULL DEFAULT ' ',
    zuonr       VARCHAR(18)  NOT NULL DEFAULT ' ',
    gjahr       SMALLINT     NOT NULL,
    belnr       CHAR(10)     NOT NULL,
    buzei       SMALLINT     NOT NULL,
    shkzg       CHAR(1)      NOT NULL CHECK (shkzg IN ('S', 'H')),
    dmbtr       NUMERIC(18,2) NOT NULL CHECK (dmbtr >= 0),
    waers       CHAR(3)      NOT NULL,
    budat       DATE         NOT NULL,
    zfbdt       DATE,
    zbd1t       SMALLINT,
    -- Due date, generated from the baseline date and the terms, so ageing
    -- buckets cannot be computed two different ways.
    due_on      DATE
        GENERATED ALWAYS AS (zfbdt + COALESCE(zbd1t, 0)) STORED,
    mahns       SMALLINT     NOT NULL DEFAULT 0 CHECK (mahns >= 0),  -- dunning level
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs, kunnr, umsks, umskz, augdt, augbl, zuonr, gjahr, belnr, buzei)
);

COMMENT ON TABLE sap_s4.bsid IS
    'Open customer items. Rows are DELETED when the item clears, not flagged. '
    'The eleven-column primary key is genuine SAP: it is an index table whose '
    'key encodes the clearing state.';

CREATE TABLE sap_s4.bsik (
    mandt       CHAR(3)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    lifnr       CHAR(10)     NOT NULL,
    umsks       CHAR(1)      NOT NULL DEFAULT ' ',
    umskz       CHAR(1)      NOT NULL DEFAULT ' ',
    augdt       DATE         NOT NULL DEFAULT '9999-12-31',
    augbl       CHAR(10)     NOT NULL DEFAULT ' ',
    zuonr       VARCHAR(18)  NOT NULL DEFAULT ' ',
    gjahr       SMALLINT     NOT NULL,
    belnr       CHAR(10)     NOT NULL,
    buzei       SMALLINT     NOT NULL,
    shkzg       CHAR(1)      NOT NULL CHECK (shkzg IN ('S', 'H')),
    dmbtr       NUMERIC(18,2) NOT NULL CHECK (dmbtr >= 0),
    waers       CHAR(3)      NOT NULL,
    budat       DATE         NOT NULL,
    zfbdt       DATE,
    zbd1t       SMALLINT,
    due_on      DATE
        GENERATED ALWAYS AS (zfbdt + COALESCE(zbd1t, 0)) STORED,
    zlspr       CHAR(1),                 -- payment block
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, bukrs, lifnr, umsks, umskz, augdt, augbl, zuonr, gjahr, belnr, buzei)
);

-- -------------------------------------------------------------------------
-- VBAK / VBAP -- Sales document header and item. Covers orders and contracts.
-- VBRK / VBRP -- Billing document header and item. Feeds target
-- finance.ar_invoice.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.vbak (
    mandt       CHAR(3)      NOT NULL,
    vbeln       CHAR(10)     NOT NULL,
    auart       CHAR(4)      NOT NULL,   -- sales document type
    vkorg       CHAR(4)      NOT NULL,   -- sales organisation
    vtweg       CHAR(2)      NOT NULL,
    spart       CHAR(2)      NOT NULL,   -- division
    erdat       DATE         NOT NULL,
    ernam       VARCHAR(12)  NOT NULL,
    kunnr       CHAR(10)     NOT NULL,
    netwr       NUMERIC(18,2) NOT NULL DEFAULT 0,
    waerk       CHAR(3)      NOT NULL,
    bukrs_vf    CHAR(4),                 -- company code
    -- Contracts are sales documents too, which is how an athlete contract and
    -- a ticket sale share a table.
    gueen       DATE,                    -- valid to
    guebg       DATE,                    -- valid from
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, vbeln),
    CONSTRAINT ck_vbak_validity CHECK (gueen IS NULL OR guebg IS NULL OR gueen >= guebg)
);

CREATE TABLE sap_s4.vbap (
    mandt       CHAR(3)      NOT NULL,
    vbeln       CHAR(10)     NOT NULL,
    posnr       SMALLINT     NOT NULL CHECK (posnr > 0),
    matnr       CHAR(18),
    arktx        VARCHAR(40),            -- item description
    kwmeng      NUMERIC(13,3) NOT NULL DEFAULT 0,  -- order quantity
    vrkme       CHAR(3),                 -- sales unit
    netwr       NUMERIC(18,2) NOT NULL DEFAULT 0,
    waerk       CHAR(3)      NOT NULL,
    werks       CHAR(4),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, vbeln, posnr)
);

CREATE TABLE sap_s4.vbrk (
    mandt       CHAR(3)      NOT NULL,
    vbeln       CHAR(10)     NOT NULL,   -- billing document
    fkart       CHAR(4)      NOT NULL,   -- billing type
    fkdat       DATE         NOT NULL,   -- billing date
    bukrs       CHAR(4)      NOT NULL,
    kunrg       CHAR(10)     NOT NULL,   -- payer
    netwr       NUMERIC(18,2) NOT NULL DEFAULT 0,
    mwsbk       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- tax amount
    -- Gross, generated.
    gross_amount NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (netwr + mwsbk) STORED,
    waerk       CHAR(3)      NOT NULL,
    zterm       CHAR(4),
    -- Accounting status. A billing document that has not released to
    -- accounting has no GL effect yet, which is a standing month-end worklist.
    rfbsk       CHAR(1)      NOT NULL DEFAULT 'A'
        CHECK (rfbsk IN ('A', 'B', 'C', 'E')),
    belnr       CHAR(10),                -- resulting accounting document
    gjahr       SMALLINT,
    fksto       BOOLEAN      NOT NULL DEFAULT FALSE,  -- cancelled
    sfakn       CHAR(10),                -- cancelled document
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, vbeln),
    CONSTRAINT ck_vbrk_accounting_doc_pair CHECK ((belnr IS NULL) = (gjahr IS NULL)),
    -- Released to accounting means there must be a document.
    CONSTRAINT ck_vbrk_released_has_doc
        CHECK (rfbsk <> 'C' OR belnr IS NOT NULL)
);

COMMENT ON COLUMN sap_s4.vbrk.rfbsk IS
    'Accounting release status: A not released, B partial, C released, E error. '
    'Only C has hit the ledger, so revenue reporting that ignores this column '
    'counts invoices that do not yet exist in the GL.';

CREATE TABLE sap_s4.vbrp (
    mandt       CHAR(3)      NOT NULL,
    vbeln       CHAR(10)     NOT NULL,
    posnr       SMALLINT     NOT NULL CHECK (posnr > 0),
    matnr       CHAR(18),
    arktx       VARCHAR(40),
    fkimg       NUMERIC(13,3) NOT NULL DEFAULT 0,  -- billed quantity
    vrkme       CHAR(3),
    netwr       NUMERIC(18,2) NOT NULL DEFAULT 0,
    mwsbp       NUMERIC(18,2) NOT NULL DEFAULT 0,
    waerk       CHAR(3)      NOT NULL,
    werks       CHAR(4),
    prctr       CHAR(10),
    -- The originating sales document, so revenue traces back to the order.
    aubel       CHAR(10),
    aupos       SMALLINT,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, vbeln, posnr)
);

-- -------------------------------------------------------------------------
-- RBKP / RSEG -- Vendor (logistics) invoice header and item.
-- Feeds target finance.ap_invoice and target merchandise.royalty_payment.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.rbkp (
    mandt       CHAR(3)      NOT NULL,
    belnr       CHAR(10)     NOT NULL,
    gjahr       SMALLINT     NOT NULL CHECK (gjahr BETWEEN 1850 AND 2200),
    blart       CHAR(2)      NOT NULL,
    bldat       DATE         NOT NULL,
    budat       DATE         NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    lifnr       CHAR(10)     NOT NULL,
    rmwwr       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- gross amount
    wrbtr       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- net amount
    waers       CHAR(3)      NOT NULL,
    zterm       CHAR(4),
    zfbdt       DATE,
    xblnr       VARCHAR(16),             -- vendor invoice reference
    -- Three-way-match state: an invoice blocked for quantity or price variance
    -- is not paid until released.
    rbstat      CHAR(1)      NOT NULL DEFAULT '5'
        CHECK (rbstat IN ('1', '2', '3', '4', '5')),
    zlspr       CHAR(1),                 -- payment block
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, belnr, gjahr),
    CONSTRAINT ck_rbkp_posting_not_before_document CHECK (budat >= bldat)
);

CREATE TABLE sap_s4.rseg (
    mandt       CHAR(3)      NOT NULL,
    belnr       CHAR(10)     NOT NULL,
    gjahr       SMALLINT     NOT NULL,
    buzei       SMALLINT     NOT NULL CHECK (buzei > 0),
    matnr       CHAR(18),
    werks       CHAR(4),
    menge       NUMERIC(13,3) NOT NULL DEFAULT 0,
    bstme       CHAR(3),
    wrbtr       NUMERIC(18,2) NOT NULL DEFAULT 0,
    -- Royalty lines carry the licence contract they settle, which is how
    -- merchandise.royalty_payment resolves to a licensing agreement.
    licence_vbeln CHAR(10),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, belnr, gjahr, buzei)
);

-- -------------------------------------------------------------------------
-- REGUH / REGUP -- Payment run header and item.
-- Feed target finance.payment and target finance.payment_run.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.reguh (
    mandt       CHAR(3)      NOT NULL,
    laufd       DATE         NOT NULL,   -- run date
    laufi       CHAR(6)      NOT NULL,   -- run identification
    xvorl       BOOLEAN      NOT NULL DEFAULT FALSE,  -- proposal only
    zbukr       CHAR(4)      NOT NULL,   -- paying company code
    -- SAP blank-pads rather than nulling key columns, so both are NOT NULL
    -- with a blank default and exactly one carries a value.
    lifnr       CHAR(10)     NOT NULL DEFAULT ' ',
    kunnr       CHAR(10)     NOT NULL DEFAULT ' ',
    vblnr       CHAR(10),                -- payment document number
    zaldt       DATE,                    -- posting date
    waers       CHAR(3)      NOT NULL,
    rwbtr       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- payment amount
    rzawe       CHAR(1)      NOT NULL,   -- payment method
    -- Bank detail references, not the detail itself: account numbers stay in
    -- the bank master.
    hbkid       CHAR(5),                 -- house bank
    hktid       CHAR(5),                 -- account id
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, laufd, laufi, xvorl, zbukr, lifnr, kunnr),
    -- A payment run row pays a vendor or collects from a customer, not both.
    CONSTRAINT ck_reguh_payee
        CHECK ((btrim(lifnr) <> '') <> (btrim(kunnr) <> ''))
);

CREATE TABLE sap_s4.regup (
    mandt       CHAR(3)      NOT NULL,
    laufd       DATE         NOT NULL,
    laufi       CHAR(6)      NOT NULL,
    zbukr       CHAR(4)      NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    belnr       CHAR(10)     NOT NULL,
    gjahr       SMALLINT     NOT NULL,
    buzei       SMALLINT     NOT NULL,
    wrbtr       NUMERIC(18,2) NOT NULL DEFAULT 0,
    waers       CHAR(3)      NOT NULL,
    sknto       NUMERIC(18,2) NOT NULL DEFAULT 0,  -- cash discount taken
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, laufd, laufi, zbukr, bukrs, belnr, gjahr, buzei)
);

-- -------------------------------------------------------------------------
-- AUFK / AFIH / QMEL -- Plant maintenance: order master, maintenance header
-- and notification. Feed target venue.maintenance_work_order.
--
-- A notification reports a problem; an order authorises the work. The target
-- model has one table, so the reporting-to-authorisation lag -- a real
-- facilities KPI -- cannot be measured downstream.
-- -------------------------------------------------------------------------
CREATE TABLE sap_s4.aufk (
    mandt       CHAR(3)      NOT NULL,
    aufnr       CHAR(12)     NOT NULL,   -- order number
    auart       CHAR(4)      NOT NULL,   -- order type
    ktext       VARCHAR(40)  NOT NULL,
    bukrs       CHAR(4)      NOT NULL,
    werks       CHAR(4),
    kostl       CHAR(10),
    erdat       DATE         NOT NULL,
    ernam       VARCHAR(12)  NOT NULL,
    -- Order status. SAP tracks this as a status-object bitmask; the simplified
    -- column here is what an extract would derive from it.
    order_status VARCHAR(20) NOT NULL DEFAULT 'created'
        CHECK (order_status IN ('created', 'released', 'partially_confirmed',
                                'confirmed', 'technically_complete', 'closed', 'cancelled')),
    user_status VARCHAR(20),
    -- Planned and actual cost, which is the budget variance facilities
    -- managers are held to.
    planned_cost NUMERIC(18,2) CHECK (planned_cost IS NULL OR planned_cost >= 0),
    actual_cost  NUMERIC(18,2) CHECK (actual_cost IS NULL OR actual_cost >= 0),
    waers       CHAR(3),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, aufnr)
);

CREATE TABLE sap_s4.afih (
    mandt       CHAR(3)      NOT NULL,
    aufnr       CHAR(12)     NOT NULL,
    equnr       CHAR(18),                -- equipment number
    tplnr       CHAR(30),                -- functional location
    iwerk       CHAR(4),                 -- maintenance planning plant
    gewrk       CHAR(8),                 -- main work centre
    -- Priority and breakdown flag drive the response-time commitment.
    priok       CHAR(1)      CHECK (priok IS NULL OR priok IN ('1', '2', '3', '4')),
    msaus       BOOLEAN      NOT NULL DEFAULT FALSE,  -- breakdown
    addat       DATE,                    -- malfunction start
    auszt       NUMERIC(11,2) CHECK (auszt IS NULL OR auszt >= 0),  -- downtime hours
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, aufnr)
);

CREATE TABLE sap_s4.qmel (
    mandt       CHAR(3)      NOT NULL,
    qmnum       CHAR(12)     NOT NULL,   -- notification number
    qmart       CHAR(2)      NOT NULL,   -- notification type
    qmtxt       VARCHAR(40)  NOT NULL,
    aufnr       CHAR(12),                -- resulting order
    equnr       CHAR(18),
    tplnr       CHAR(30),
    werks       CHAR(4),
    qmdat       DATE         NOT NULL,   -- notification date
    mzeit       TIME,                    -- notification time
    qmnam       VARCHAR(12)  NOT NULL,   -- reported by
    priok       CHAR(1)      CHECK (priok IS NULL OR priok IN ('1', '2', '3', '4')),
    -- Required-by, which is what makes a notification overdue.
    ltrmn       DATE,
    msaus       BOOLEAN      NOT NULL DEFAULT FALSE,
    notification_status VARCHAR(20) NOT NULL DEFAULT 'outstanding'
        CHECK (notification_status IN ('outstanding', 'in_process', 'order_assigned',
                                       'completed', 'rejected', 'deleted')),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (mandt, qmnum)
);

COMMENT ON TABLE sap_s4.qmel IS
    'Maintenance notification -- the report of a problem, distinct from the '
    'order that authorises work on it. Target venue.maintenance_work_order '
    'merges the two, losing the report-to-authorisation lag.';
