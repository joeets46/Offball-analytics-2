-- =========================================================================
-- tm_axs -- transactions
--
-- The sell-to-scan path: hold inventory, take an order, issue an entitlement,
-- capture payment, admit the holder. Plus the security events that share the
-- same scan infrastructure.
--
-- Two tables are partitioned by time. Scans and screening events arrive in
-- sharp event-time bursts -- tens of thousands of rows in the ninety minutes
-- before kick-off, then nothing -- and are almost always queried for a single
-- event or a single day. Monthly range partitions keep the hot partition small
-- and make retention a DETACH rather than a DELETE.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Inventory holds. Feeds target ticketing.hold_allocation.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.inventory_hold (
    inventory_hold_id   BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            BIGINT       NOT NULL,
    hold_code           VARCHAR(20)  NOT NULL,
    price_zone_id       INTEGER,
    -- A hold is placed either on a specific seat set or as a block count
    -- against a zone, never both.
    ticket_inventory_id BIGINT,
    block_quantity      INTEGER      CHECK (block_quantity IS NULL OR block_quantity > 0),
    held_for_party      VARCHAR(160),
    requested_by        VARCHAR(120) NOT NULL,
    hold_status         VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (hold_status IN ('active','released','converted','expired')),
    held_from           TIMESTAMPTZ  NOT NULL DEFAULT now(),
    release_due_at      TIMESTAMPTZ,
    released_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_hold_seat_xor_block
        CHECK ((ticket_inventory_id IS NOT NULL) <> (block_quantity IS NOT NULL)),
    CONSTRAINT ck_hold_block_needs_zone
        CHECK (block_quantity IS NULL OR price_zone_id IS NOT NULL),
    CONSTRAINT ck_hold_released_has_timestamp
        CHECK ((hold_status = 'released') = (released_at IS NOT NULL))
);

COMMENT ON CONSTRAINT ck_hold_seat_xor_block ON tm_axs.inventory_hold IS
    'A hold is either seat-specific or a block count against a zone. The target '
    'ticketing.hold_allocation flattens both shapes into one row.';

-- -------------------------------------------------------------------------
-- Group sales. Feeds target ticketing.group_sale.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.group_sale (
    group_sale_id       BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    group_sale_code     VARCHAR(30)  NOT NULL UNIQUE,
    event_id            BIGINT       NOT NULL,
    group_name          VARCHAR(160) NOT NULL,
    group_type          VARCHAR(20)  NOT NULL
        CHECK (group_type IN ('corporate','school','youth_sport','community','tour_operator','charity')),
    contact_email       common.dom_email,
    contact_phone       VARCHAR(32),
    committed_quantity  INTEGER      NOT NULL CHECK (committed_quantity > 0),
    sold_quantity       INTEGER      NOT NULL DEFAULT 0 CHECK (sold_quantity >= 0),
    discount_percent    NUMERIC(5,2) NOT NULL DEFAULT 0
        CHECK (discount_percent BETWEEN 0 AND 100),
    sales_rep           VARCHAR(120),
    approval_status     VARCHAR(20)  NOT NULL DEFAULT 'pending'
        CHECK (approval_status IN ('not_required','pending','approved','rejected')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_group_sale_not_oversold CHECK (sold_quantity <= committed_quantity)
);

-- -------------------------------------------------------------------------
-- Order header and line. Feeds target ticketing.ticket_order and
-- ticketing.ticket_order_line.
--
-- `sales_order` rather than `order`: the native system calls it an order, but
-- `order` is reserved in PostgreSQL and quoting it everywhere is worse than
-- naming it plainly.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.sales_order (
    sales_order_id      BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_number        VARCHAR(30)  NOT NULL UNIQUE,
    customer_account_id BIGINT       NOT NULL,
    event_id            BIGINT,
    sales_channel_code  VARCHAR(20)  NOT NULL,
    group_sale_id       BIGINT,
    promo_code_id       INTEGER,

    order_status        VARCHAR(20)  NOT NULL DEFAULT 'pending_payment'
        CHECK (order_status IN
            ('pending_payment','completed','cancelled','refunded','partially_refunded','disputed')),
    ordered_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    completed_at        TIMESTAMPTZ,
    cancelled_at        TIMESTAMPTZ,

    currency_code       common.dom_iso3_code NOT NULL,
    -- Totals are denormalized onto the header because the payment gateway
    -- settles against the header, not the lines. Line sums are asserted by the
    -- application; the database cannot express a cross-row CHECK.
    subtotal_amount     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (subtotal_amount >= 0),
    fee_amount          NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (fee_amount >= 0),
    tax_amount          NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (tax_amount >= 0),
    discount_amount     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
    total_amount        NUMERIC(18,4) NOT NULL
        GENERATED ALWAYS AS (subtotal_amount + fee_amount + tax_amount - discount_amount) STORED,

    -- Set once the order has been posted to the general ledger. Null means the
    -- revenue has not yet reached SAP, which is the reconciliation gap finance
    -- reports on.
    sap_billing_doc_number VARCHAR(10),
    posted_to_gl_at     TIMESTAMPTZ,

    ip_address          INET,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    row_version         INTEGER      NOT NULL DEFAULT 1,

    CONSTRAINT ck_order_completed_has_timestamp
        CHECK (order_status <> 'completed' OR completed_at IS NOT NULL),
    CONSTRAINT ck_order_cancelled_has_timestamp
        CHECK ((order_status = 'cancelled') = (cancelled_at IS NOT NULL)),
    CONSTRAINT ck_order_discount_within_subtotal
        CHECK (discount_amount <= subtotal_amount + fee_amount + tax_amount),
    CONSTRAINT ck_order_gl_posting_pair
        CHECK ((sap_billing_doc_number IS NULL) = (posted_to_gl_at IS NULL))
);

COMMENT ON COLUMN tm_axs.sales_order.ip_address IS
    'Native INET. The target model types its equivalent as STRING; the upstream '
    'tagging marks it pii_ip.';
COMMENT ON COLUMN tm_axs.sales_order.sap_billing_doc_number IS
    'Business key into sap_s4.vbrk. Null until revenue posts, which is the '
    'ticketing-to-finance reconciliation gap.';

CREATE TABLE tm_axs.order_line (
    order_line_id       BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sales_order_id      BIGINT       NOT NULL,
    line_number         SMALLINT     NOT NULL CHECK (line_number > 0),
    ticket_inventory_id BIGINT,
    price_level_id      INTEGER      NOT NULL,
    delivery_method_code VARCHAR(20) NOT NULL,

    quantity            SMALLINT     NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_face_value     NUMERIC(18,4) NOT NULL CHECK (unit_face_value >= 0),
    unit_fee_amount     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (unit_fee_amount >= 0),
    unit_tax_amount     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (unit_tax_amount >= 0),
    line_discount_amount NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (line_discount_amount >= 0),
    line_total_amount   NUMERIC(18,4) NOT NULL
        GENERATED ALWAYS AS
            (quantity * (unit_face_value + unit_fee_amount + unit_tax_amount) - line_discount_amount)
        STORED,

    line_status         VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (line_status IN ('active','cancelled','refunded','exchanged')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (sales_order_id, line_number),
    -- A seat-specific line sells exactly one seat.
    CONSTRAINT ck_order_line_seat_quantity
        CHECK (ticket_inventory_id IS NULL OR quantity = 1)
);

-- -------------------------------------------------------------------------
-- Ticket, barcode and delivery.
--
-- Feeds target ticketing.access_entitlement, which flattens all three into one
-- row. Keeping them apart here is what the separation buys: a ticket outlives
-- its barcodes (rotating barcodes issue a new row per rotation) and a delivery
-- can be retried without reissuing the ticket.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.ticket (
    ticket_id           BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_number       VARCHAR(30)  NOT NULL UNIQUE,
    order_line_id       BIGINT       NOT NULL,
    event_id            BIGINT       NOT NULL,
    ticket_inventory_id BIGINT,
    -- Seat labels are copied onto the ticket at issue: the manifest may be
    -- reconfigured later and the ticket must keep saying what it said.
    section_label       VARCHAR(20),
    row_label           VARCHAR(10),
    seat_label          VARCHAR(10),

    ticket_status       VARCHAR(20)  NOT NULL DEFAULT 'issued'
        CHECK (ticket_status IN
            ('issued','transferred','resold','redeemed','voided','refunded','expired')),
    -- The holder may differ from the purchaser after a transfer.
    holder_customer_account_id BIGINT,
    is_comp             BOOLEAN      NOT NULL DEFAULT FALSE,
    face_value          NUMERIC(18,4) NOT NULL CHECK (face_value >= 0),
    issued_at           TIMESTAMPTZ  NOT NULL DEFAULT now(),
    redeemed_at         TIMESTAMPTZ,
    voided_at           TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    row_version         INTEGER      NOT NULL DEFAULT 1,

    -- A comp has no face value by definition.
    CONSTRAINT ck_ticket_comp_face_value CHECK (NOT is_comp OR face_value = 0),
    CONSTRAINT ck_ticket_redeemed_has_timestamp
        CHECK (ticket_status <> 'redeemed' OR redeemed_at IS NOT NULL),
    CONSTRAINT ck_ticket_voided_has_timestamp
        CHECK ((ticket_status = 'voided') = (voided_at IS NOT NULL))
);

CREATE TABLE tm_axs.barcode (
    barcode_id          BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_id           BIGINT       NOT NULL,
    barcode_value       VARCHAR(80)  NOT NULL,
    barcode_format      VARCHAR(20)  NOT NULL
        CHECK (barcode_format IN ('pdf417','qr','aztec','code128','nfc_token')),
    -- Rotating barcodes supersede one another; only the newest is live.
    rotation_sequence   INTEGER      NOT NULL DEFAULT 1 CHECK (rotation_sequence > 0),
    valid_from          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    valid_to            TIMESTAMPTZ,
    is_voided           BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (barcode_value),
    UNIQUE (ticket_id, rotation_sequence),
    CONSTRAINT ck_barcode_window CHECK (valid_to IS NULL OR valid_to > valid_from)
);

COMMENT ON TABLE tm_axs.barcode IS
    'One row per barcode rotation. A rotating-barcode ticket accumulates many; '
    'the target access_entitlement keeps only the live one.';

CREATE TABLE tm_axs.delivery (
    delivery_id         BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_id           BIGINT       NOT NULL,
    delivery_method_code VARCHAR(20) NOT NULL,
    delivery_status     VARCHAR(20)  NOT NULL DEFAULT 'pending'
        CHECK (delivery_status IN ('pending','sent','delivered','failed','collected','returned')),
    attempt_number      SMALLINT     NOT NULL DEFAULT 1 CHECK (attempt_number > 0),
    sent_to             VARCHAR(200),
    sent_at             TIMESTAMPTZ,
    delivered_at        TIMESTAMPTZ,
    failure_reason      VARCHAR(200),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (ticket_id, delivery_method_code, attempt_number),
    CONSTRAINT ck_delivery_failed_has_reason
        CHECK ((delivery_status = 'failed') = (failure_reason IS NOT NULL)),
    CONSTRAINT ck_delivery_timestamp_order
        CHECK (delivered_at IS NULL OR sent_at IS NULL OR delivered_at >= sent_at)
);

-- -------------------------------------------------------------------------
-- Transfer and resale. Feeds target ticketing.ticket_transfer and
-- ticketing.resale.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.ticket_transfer (
    ticket_transfer_id  BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_id           BIGINT       NOT NULL,
    from_customer_account_id BIGINT  NOT NULL,
    -- Null until the recipient accepts: a transfer is offered to an email
    -- address before an account necessarily exists.
    to_customer_account_id BIGINT,
    to_email            common.dom_email NOT NULL,
    transfer_status     VARCHAR(20)  NOT NULL DEFAULT 'offered'
        CHECK (transfer_status IN ('offered','accepted','declined','cancelled','expired')),
    offered_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    responded_at        TIMESTAMPTZ,
    expires_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_transfer_parties_differ
        CHECK (to_customer_account_id IS NULL
               OR to_customer_account_id <> from_customer_account_id),
    CONSTRAINT ck_transfer_accepted_has_recipient
        CHECK (transfer_status <> 'accepted'
               OR (to_customer_account_id IS NOT NULL AND responded_at IS NOT NULL))
);

CREATE TABLE tm_axs.resale_listing (
    resale_listing_id   BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_id           BIGINT       NOT NULL,
    seller_customer_account_id BIGINT NOT NULL,
    listed_price        NUMERIC(18,4) NOT NULL CHECK (listed_price >= 0),
    currency_code       common.dom_iso3_code NOT NULL,
    -- Many jurisdictions and most leagues cap resale at a multiple of face
    -- value; the cap in force is recorded so a listing can be explained later.
    price_cap_applied   NUMERIC(18,4) CHECK (price_cap_applied IS NULL OR price_cap_applied >= 0),
    listing_status      VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (listing_status IN ('active','sold','withdrawn','expired','suspended')),
    listed_at           TIMESTAMPTZ  NOT NULL DEFAULT now(),
    delisted_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_resale_within_cap
        CHECK (price_cap_applied IS NULL OR listed_price <= price_cap_applied),
    -- One live listing per ticket. A sold or withdrawn listing may coexist.
    CONSTRAINT ck_resale_delisted_timestamp
        CHECK ((listing_status = 'active') = (delisted_at IS NULL))
);

CREATE TABLE tm_axs.resale_transaction (
    resale_transaction_id BIGINT     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    resale_listing_id   BIGINT       NOT NULL,
    buyer_customer_account_id BIGINT NOT NULL,
    sales_order_id      BIGINT,
    sale_price          NUMERIC(18,4) NOT NULL CHECK (sale_price >= 0),
    -- The platform fee splits between the venue, the league and the operator;
    -- the split rules live in the settlement engine, not here.
    platform_fee        NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (platform_fee >= 0),
    seller_payout       NUMERIC(18,4) NOT NULL CHECK (seller_payout >= 0),
    payout_status       VARCHAR(20)  NOT NULL DEFAULT 'pending'
        CHECK (payout_status IN ('pending','scheduled','paid','held','reversed')),
    sold_at             TIMESTAMPTZ  NOT NULL DEFAULT now(),
    paid_out_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_resale_txn_payout_balance
        CHECK (seller_payout <= sale_price),
    CONSTRAINT ck_resale_txn_paid_has_timestamp
        CHECK ((payout_status = 'paid') = (paid_out_at IS NOT NULL))
);

-- -------------------------------------------------------------------------
-- Payment capture and refund. Feeds target ticketing.ticket_payment and
-- ticketing.refund.
--
-- The payment is the intent; payment_transaction is each attempt against the
-- gateway. The target model keeps only the settled result, so an order that
-- took four declines before succeeding looks identical to one that worked
-- first time -- a real loss of operational signal, noted in mapping/lineage.md.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.payment (
    payment_id          BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sales_order_id      BIGINT       NOT NULL,
    payment_method_id   BIGINT,
    payment_status      VARCHAR(20)  NOT NULL DEFAULT 'authorized'
        CHECK (payment_status IN
            ('authorized','captured','settled','declined','voided','refunded','charged_back')),
    currency_code       common.dom_iso3_code NOT NULL,
    authorized_amount   NUMERIC(18,4) NOT NULL CHECK (authorized_amount >= 0),
    captured_amount     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (captured_amount >= 0),
    refunded_amount     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (refunded_amount >= 0),
    authorized_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    captured_at         TIMESTAMPTZ,
    settled_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_payment_capture_within_auth
        CHECK (captured_amount <= authorized_amount),
    CONSTRAINT ck_payment_refund_within_capture
        CHECK (refunded_amount <= captured_amount)
);

CREATE TABLE tm_axs.payment_transaction (
    payment_transaction_id BIGINT    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_id          BIGINT       NOT NULL,
    attempt_number      SMALLINT     NOT NULL DEFAULT 1 CHECK (attempt_number > 0),
    transaction_type    VARCHAR(20)  NOT NULL
        CHECK (transaction_type IN
            ('authorization','capture','void','refund','chargeback','representment')),
    gateway_name        VARCHAR(40)  NOT NULL,
    gateway_reference   VARCHAR(80)  NOT NULL,
    response_code       VARCHAR(20)  NOT NULL,
    is_approved         BOOLEAN      NOT NULL,
    decline_reason      VARCHAR(120),
    amount              NUMERIC(18,4) NOT NULL,
    occurred_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (gateway_name, gateway_reference),
    UNIQUE (payment_id, transaction_type, attempt_number),
    CONSTRAINT ck_payment_txn_decline_reason
        CHECK (is_approved OR decline_reason IS NOT NULL)
);

CREATE TABLE tm_axs.refund (
    refund_id           BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    refund_number       VARCHAR(30)  NOT NULL UNIQUE,
    sales_order_id      BIGINT       NOT NULL,
    payment_id          BIGINT,
    order_line_id       BIGINT,
    ticket_id           BIGINT,
    refund_reason       VARCHAR(30)  NOT NULL
        CHECK (refund_reason IN
            ('event_cancelled','event_postponed','customer_request','duplicate_order',
             'fraud','service_failure','goodwill','chargeback')),
    refund_type         VARCHAR(20)  NOT NULL DEFAULT 'full'
        CHECK (refund_type IN ('full','partial','fee_only','face_value_only')),
    currency_code       common.dom_iso3_code NOT NULL,
    refund_amount       NUMERIC(18,4) NOT NULL CHECK (refund_amount >= 0),
    -- Fees are frequently non-refundable except on cancellation, so the split
    -- has to survive into the ledger.
    fee_refunded_amount NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (fee_refunded_amount >= 0),
    refund_status       VARCHAR(20)  NOT NULL DEFAULT 'pending'
        CHECK (refund_status IN ('pending','approved','processed','rejected','failed')),
    requested_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    approved_at         TIMESTAMPTZ,
    processed_at        TIMESTAMPTZ,
    approved_by         VARCHAR(120),
    sap_reversal_doc_number VARCHAR(10),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_refund_fee_within_total CHECK (fee_refunded_amount <= refund_amount),
    CONSTRAINT ck_refund_approved_pair
        CHECK ((approved_at IS NULL) = (approved_by IS NULL)),
    CONSTRAINT ck_refund_processed_requires_approval
        CHECK (refund_status <> 'processed' OR (approved_at IS NOT NULL AND processed_at IS NOT NULL))
);

-- -------------------------------------------------------------------------
-- Scan stream. Feeds target ticketing.gate_scan and security.access_event.
--
-- Partitioned monthly by scan time. This is the single highest-volume table in
-- the estate: one row per presentation of a barcode or credential at a reader,
-- including every rejected attempt.
--
-- The primary key includes the partition key because PostgreSQL requires every
-- unique constraint on a partitioned table to contain it.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.scan (
    scan_id             BIGINT       GENERATED ALWAYS AS IDENTITY,
    scanned_at          TIMESTAMPTZ  NOT NULL,
    event_id            BIGINT       NOT NULL,
    access_point_id     INTEGER      NOT NULL,
    -- A scan presents either a ticket barcode or a credential, never both.
    barcode_id          BIGINT,
    credential_id       BIGINT,

    scan_result         VARCHAR(20)  NOT NULL
        CHECK (scan_result IN
            ('admitted','duplicate','invalid','wrong_event','wrong_zone','expired',
             'revoked','void','clearance_denied','reader_error')),
    direction           VARCHAR(10)  NOT NULL DEFAULT 'entry'
        CHECK (direction IN ('entry','exit','re_entry')),
    -- Device and operator, for fraud investigation and gate-performance work.
    reader_device_id    VARCHAR(40),
    operator_badge      VARCHAR(30),
    is_manual_override  BOOLEAN      NOT NULL DEFAULT FALSE,
    override_reason     VARCHAR(120),
    offline_captured    BOOLEAN      NOT NULL DEFAULT FALSE,
    -- Readers buffer when the network drops at gates, so a scan can reach the
    -- database long after it happened. This is the late-arrival case the
    -- ingestion contract has to handle.
    uploaded_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (scan_id, scanned_at),
    CONSTRAINT ck_scan_barcode_xor_credential
        CHECK ((barcode_id IS NOT NULL) <> (credential_id IS NOT NULL)),
    CONSTRAINT ck_scan_override_reason
        CHECK (is_manual_override = (override_reason IS NOT NULL)),
    CONSTRAINT ck_scan_upload_not_before_scan CHECK (uploaded_at >= scanned_at)
) PARTITION BY RANGE (scanned_at);

COMMENT ON TABLE tm_axs.scan IS
    'Every barcode or credential presentation, including rejections. Monthly '
    'range partitions: queried per event or per day, and retention is a DETACH.';
COMMENT ON COLUMN tm_axs.scan.offline_captured IS
    'Reader buffered the scan while offline. Such rows arrive late and out of '
    'order, which is why the ingestion watermark uses uploaded_at, not scanned_at.';

-- A year of partitions plus a catch-all. In production these are created by a
-- maintenance job; here they are explicit so the DDL loads standalone.
CREATE TABLE tm_axs.scan_2026_01 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE tm_axs.scan_2026_02 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
CREATE TABLE tm_axs.scan_2026_03 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
CREATE TABLE tm_axs.scan_2026_04 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');
CREATE TABLE tm_axs.scan_2026_05 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
CREATE TABLE tm_axs.scan_2026_06 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');
CREATE TABLE tm_axs.scan_2026_07 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-07-01') TO ('2026-08-01');
CREATE TABLE tm_axs.scan_2026_08 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-08-01') TO ('2026-09-01');
CREATE TABLE tm_axs.scan_2026_09 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');
CREATE TABLE tm_axs.scan_2026_10 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-10-01') TO ('2026-11-01');
CREATE TABLE tm_axs.scan_2026_11 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-11-01') TO ('2026-12-01');
CREATE TABLE tm_axs.scan_2026_12 PARTITION OF tm_axs.scan
    FOR VALUES FROM ('2026-12-01') TO ('2027-01-01');
CREATE TABLE tm_axs.scan_default PARTITION OF tm_axs.scan DEFAULT;

COMMENT ON TABLE tm_axs.scan_default IS
    'Catch-all. Rows landing here mean the partition maintenance job has fallen '
    'behind; it should be monitored and stay empty.';

-- -------------------------------------------------------------------------
-- Credential assignment. Feeds target security.credential_assignment.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.credential_assignment (
    credential_assignment_id BIGINT  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    credential_id       BIGINT       NOT NULL,
    access_zone_id      INTEGER      NOT NULL,
    event_id            BIGINT,
    -- Null event means a standing assignment for the whole season rather than
    -- one fixture.
    assignment_status   VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (assignment_status IN ('active','suspended','revoked','expired')),
    valid_from          TIMESTAMPTZ  NOT NULL,
    valid_to            TIMESTAMPTZ,
    granted_by          VARCHAR(120) NOT NULL,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_cred_assignment_window
        CHECK (valid_to IS NULL OR valid_to > valid_from)
);

-- -------------------------------------------------------------------------
-- Screening, incidents and ejections. Feed target security.screening_event,
-- security.security_incident and security.ejection_record.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.screening_event (
    screening_event_id  BIGINT       GENERATED ALWAYS AS IDENTITY,
    screened_at         TIMESTAMPTZ  NOT NULL,
    screening_checkpoint_id INTEGER  NOT NULL,
    event_id            BIGINT       NOT NULL,
    screening_result    VARCHAR(20)  NOT NULL
        CHECK (screening_result IN ('cleared','secondary_required','prohibited_item','refused_entry','alarm_resolved')),
    prohibited_item_category VARCHAR(30),
    secondary_screening_performed BOOLEAN NOT NULL DEFAULT FALSE,
    -- Deliberately not linked to a ticket or a person: screening is anonymous
    -- throughput unless it escalates to an incident. Keeping it that way is a
    -- data-minimisation decision, not an oversight.
    resolved_by_badge   VARCHAR(30),
    duration_seconds    INTEGER      CHECK (duration_seconds IS NULL OR duration_seconds >= 0),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (screening_event_id, screened_at),
    CONSTRAINT ck_screening_prohibited_item
        CHECK ((screening_result = 'prohibited_item') = (prohibited_item_category IS NOT NULL))
) PARTITION BY RANGE (screened_at);

COMMENT ON TABLE tm_axs.screening_event IS
    'Anonymous screening throughput. Carries no ticket or person reference by '
    'design; escalation creates a security_incident, which does.';

CREATE TABLE tm_axs.screening_event_2026_h1 PARTITION OF tm_axs.screening_event
    FOR VALUES FROM ('2026-01-01') TO ('2026-07-01');
CREATE TABLE tm_axs.screening_event_2026_h2 PARTITION OF tm_axs.screening_event
    FOR VALUES FROM ('2026-07-01') TO ('2027-01-01');
CREATE TABLE tm_axs.screening_event_default PARTITION OF tm_axs.screening_event DEFAULT;

CREATE TABLE tm_axs.security_incident (
    security_incident_id BIGINT      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    incident_number     VARCHAR(30)  NOT NULL UNIQUE,
    event_id            BIGINT,
    venue_ref_id        INTEGER      NOT NULL,
    access_zone_id      INTEGER,
    incident_category   VARCHAR(30)  NOT NULL
        CHECK (incident_category IN
            ('disorder','intoxication','trespass','pitch_incursion','prohibited_item',
             'medical','fire_safety','theft','assault','counterfeit_ticket','structural','other')),
    severity            VARCHAR(20)  NOT NULL
        CHECK (severity IN ('low','medium','high','critical')),
    occurred_at         TIMESTAMPTZ  NOT NULL,
    reported_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),
    reported_by_badge   VARCHAR(30),
    description         TEXT         NOT NULL,
    location_note       VARCHAR(200),
    persons_involved_count SMALLINT  NOT NULL DEFAULT 0 CHECK (persons_involved_count >= 0),
    police_involved     BOOLEAN      NOT NULL DEFAULT FALSE,
    police_reference    VARCHAR(40),
    medical_response    BOOLEAN      NOT NULL DEFAULT FALSE,
    incident_status     VARCHAR(20)  NOT NULL DEFAULT 'open'
        CHECK (incident_status IN ('open','under_review','closed','escalated')),
    closed_at           TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_incident_reported_after_occurred CHECK (reported_at >= occurred_at),
    CONSTRAINT ck_incident_police_reference
        CHECK (police_involved OR police_reference IS NULL),
    CONSTRAINT ck_incident_closed_has_timestamp
        CHECK ((incident_status = 'closed') = (closed_at IS NOT NULL))
);

COMMENT ON TABLE tm_axs.security_incident IS
    'Feeds both target security.security_incident and target '
    'venue.safety_incident -- the two overlap because no EHS system is named. '
    'Also unions into event.event_incident.';

CREATE TABLE tm_axs.ejection (
    ejection_id         BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    security_incident_id BIGINT      NOT NULL,
    event_id            BIGINT       NOT NULL,
    ticket_id           BIGINT,
    customer_account_id BIGINT,
    -- An ejected person is often unidentified; neither reference is mandatory.
    ejection_reason     VARCHAR(30)  NOT NULL
        CHECK (ejection_reason IN
            ('disorder','intoxication','prohibited_item','pitch_incursion',
             'smoking','counterfeit_ticket','abuse','refusal_to_comply','other')),
    ejected_at          TIMESTAMPTZ  NOT NULL,
    ejected_by_badge    VARCHAR(30)  NOT NULL,
    was_arrested        BOOLEAN      NOT NULL DEFAULT FALSE,
    -- A ban is a separate, longer-lived consequence of the ejection.
    ban_issued          BOOLEAN      NOT NULL DEFAULT FALSE,
    ban_duration_months SMALLINT     CHECK (ban_duration_months IS NULL OR ban_duration_months > 0),
    ban_expires_on      DATE,
    refund_offered      BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_ejection_ban_fields
        CHECK (ban_issued OR (ban_duration_months IS NULL AND ban_expires_on IS NULL))
);

-- -------------------------------------------------------------------------
-- Event-day operations log. Feeds target venue.event_day_ops and unions into
-- target event.event_incident.
-- -------------------------------------------------------------------------
CREATE TABLE tm_axs.event_day_log (
    event_day_log_id    BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            BIGINT       NOT NULL,
    venue_ref_id        INTEGER      NOT NULL,
    log_category        VARCHAR(30)  NOT NULL
        CHECK (log_category IN
            ('doors_open','doors_close','gate_status','queue_alert','weather',
             'delay','announcement','capacity_milestone','system_outage','other')),
    logged_at           TIMESTAMPTZ  NOT NULL DEFAULT now(),
    logged_by_badge     VARCHAR(30),
    note                TEXT         NOT NULL,
    -- Snapshot counters at the moment of logging, used for queue and gate
    -- throughput analysis after the event.
    admitted_count      INTEGER      CHECK (admitted_count IS NULL OR admitted_count >= 0),
    open_gate_count     SMALLINT     CHECK (open_gate_count IS NULL OR open_gate_count >= 0),
    requires_followup   BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);
