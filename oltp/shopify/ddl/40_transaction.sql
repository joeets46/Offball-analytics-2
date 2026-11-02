-- =========================================================================
-- shopify -- orders, fulfilment, payment and returns
--
-- The order lifecycle. Shopify splits it across six tables that the target
-- model folds into four, and the asymmetry matters: a single order line can
-- be partially fulfilled from two locations, partially refunded, and
-- partially returned, each tracked separately. Target
-- merchandise.order_line carries one quantity and one status.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Order. Feeds target merchandise.merch_order.
--
-- Three independent lifecycle axes, which is the thing to notice:
-- financial_status (money), fulfillment_status (goods) and cancelled_at
-- (existence). They move independently -- a paid, unfulfilled, uncancelled
-- order is perfectly normal -- and the target model has a single status column.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.sales_order (
    id                  BIGINT       PRIMARY KEY,
    shop_id             BIGINT       NOT NULL,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    customer_id         BIGINT,
    -- Guest checkout is normal, so customer_id is nullable. The target
    -- merch_order has a mandatory fan reference, which means guest orders
    -- either get a synthetic fan or are dropped.
    order_number        INTEGER      NOT NULL,
    name                VARCHAR(40)  NOT NULL,
    email               common.dom_email,
    phone               VARCHAR(40),

    financial_status    VARCHAR(30)  NOT NULL DEFAULT 'pending'
        CHECK (financial_status IN
            ('pending', 'authorized', 'partially_paid', 'paid',
             'partially_refunded', 'refunded', 'voided')),
    fulfillment_status  VARCHAR(30)
        CHECK (fulfillment_status IS NULL OR fulfillment_status IN
            ('fulfilled', 'partial', 'restocked', 'unfulfilled')),

    currency            common.dom_iso3_code NOT NULL,
    -- Presentment currency differs from shop currency on a multi-currency
    -- store, and both totals are retained.
    presentment_currency common.dom_iso3_code NOT NULL,
    subtotal_price      NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (subtotal_price >= 0),
    total_discounts     NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_discounts >= 0),
    total_tax           NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_tax >= 0),
    total_shipping      NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_shipping >= 0),
    total_price         NUMERIC(18,2) NOT NULL CHECK (total_price >= 0),
    total_outstanding   NUMERIC(18,2) NOT NULL DEFAULT 0,
    taxes_included      BOOLEAN      NOT NULL DEFAULT FALSE,

    -- Shipping address is denormalized onto the order, not a reference to
    -- customer_address: the address at the time of order must not change when
    -- the customer later edits their address book.
    shipping_name       VARCHAR(160),
    shipping_address1   VARCHAR(255),
    shipping_city       VARCHAR(80),
    shipping_province_code common.dom_state_province,
    shipping_country_code common.dom_iso3_code,
    shipping_zip        VARCHAR(20),

    source_name         VARCHAR(40),
    landing_site        TEXT,
    referring_site      TEXT,
    tags                TEXT,
    note                TEXT,

    cancelled_at        TIMESTAMPTZ,
    cancel_reason       VARCHAR(30)
        CHECK (cancel_reason IS NULL OR cancel_reason IN
            ('customer', 'fraud', 'inventory', 'declined', 'staff', 'other')),
    closed_at           TIMESTAMPTZ,
    processed_at        TIMESTAMPTZ,
    -- Business key into the SAP billing document that recognises the revenue.
    sap_vbeln           CHAR(10),
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (shop_id, order_number),
    CONSTRAINT ck_order_cancel_pair
        CHECK ((cancelled_at IS NULL) = (cancel_reason IS NULL)),
    CONSTRAINT ck_order_discount_within_subtotal
        CHECK (total_discounts <= subtotal_price)
);

COMMENT ON COLUMN shopify.sales_order.customer_id IS
    'Nullable: guest checkout is normal. Target merchandise.merch_order '
    'expects a fan reference, so guest orders need a synthetic identity or '
    'they fall out of fan-level revenue reporting.';
COMMENT ON COLUMN shopify.sales_order.shipping_address1 IS
    'Denormalized deliberately. The address as shipped must not change when '
    'the customer edits their address book afterwards.';

-- -------------------------------------------------------------------------
-- Line item. Feeds target merchandise.order_line.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.line_item (
    id                  BIGINT       PRIMARY KEY,
    order_id            BIGINT       NOT NULL,
    variant_id          BIGINT,
    product_id          BIGINT,
    -- Both are nullable: a product deleted after the order was placed leaves
    -- the line behind, which is why the title and sku are copied onto it.
    title               VARCHAR(255) NOT NULL,
    variant_title       VARCHAR(255),
    sku                 VARCHAR(255),
    vendor              VARCHAR(255),
    quantity            INTEGER      NOT NULL CHECK (quantity > 0),
    fulfillable_quantity INTEGER     NOT NULL DEFAULT 0 CHECK (fulfillable_quantity >= 0),
    price               NUMERIC(18,2) NOT NULL CHECK (price >= 0),
    total_discount      NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_discount >= 0),
    line_total          NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (quantity * price - total_discount) STORED,
    taxable             BOOLEAN      NOT NULL DEFAULT TRUE,
    requires_shipping   BOOLEAN      NOT NULL DEFAULT TRUE,
    gift_card           BOOLEAN      NOT NULL DEFAULT FALSE,
    fulfillment_status  VARCHAR(20)
        CHECK (fulfillment_status IS NULL OR fulfillment_status IN ('fulfilled', 'partial', 'not_eligible')),
    -- Personalisation. For sports merchandise this is the name and number on
    -- the shirt, and it makes the item non-returnable.
    properties          JSONB,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_line_item_fulfillable_within_quantity
        CHECK (fulfillable_quantity <= quantity),
    CONSTRAINT ck_line_item_discount_within_total
        CHECK (total_discount <= quantity * price)
);

COMMENT ON COLUMN shopify.line_item.properties IS
    'Line-level personalisation -- shirt name and number for sports kit. '
    'JSONB because the keys are retailer-defined. Target '
    'merchandise.order_line has no equivalent, so customisation is lost and '
    'with it the reason the item cannot be resold.';

CREATE TABLE shopify.shipping_line (
    id                  BIGINT       PRIMARY KEY,
    order_id            BIGINT       NOT NULL,
    title               VARCHAR(255) NOT NULL,
    code                VARCHAR(80),
    source              VARCHAR(80),
    price               NUMERIC(18,2) NOT NULL CHECK (price >= 0),
    discounted_price    NUMERIC(18,2) NOT NULL CHECK (discounted_price >= 0),
    carrier_identifier  VARCHAR(80),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_shipping_discount_within_price CHECK (discounted_price <= price)
);

-- -------------------------------------------------------------------------
-- Discount application. Which discount hit which line and for how much.
--
-- Feeds the discount side of target merchandise.order_line and
-- merchandise.promotion. The link between a promotion and the revenue it
-- actually cost is here and nowhere else.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.discount_application (
    id                  BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id            BIGINT       NOT NULL,
    line_item_id        BIGINT,
    -- Order-level discounts have no line, so this is nullable.
    discount_code_id    BIGINT,
    price_rule_id       BIGINT,
    application_type    VARCHAR(20)  NOT NULL
        CHECK (application_type IN ('discount_code', 'manual', 'script', 'automatic')),
    target_type         VARCHAR(20)  NOT NULL
        CHECK (target_type IN ('line_item', 'shipping_line')),
    value_type          VARCHAR(20)  NOT NULL
        CHECK (value_type IN ('fixed_amount', 'percentage')),
    value               NUMERIC(18,2) NOT NULL,
    allocated_amount    NUMERIC(18,2) NOT NULL CHECK (allocated_amount >= 0),
    description         VARCHAR(255),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A discount-code application must name its code.
    CONSTRAINT ck_discount_app_code
        CHECK (application_type <> 'discount_code' OR discount_code_id IS NOT NULL)
);

COMMENT ON COLUMN shopify.discount_application.allocated_amount IS
    'The money this discount actually cost on this line. The only place '
    'promotion effectiveness can be measured; neither target '
    'merchandise.promotion nor order_line retains it.';

-- -------------------------------------------------------------------------
-- Fulfilment. Feeds target merchandise.fulfillment_shipment.
--
-- One order line can be fulfilled across several shipments from several
-- locations. The target model has one shipment row per order line, so a split
-- shipment is either collapsed or duplicated.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.fulfillment (
    id                  BIGINT       PRIMARY KEY,
    order_id            BIGINT       NOT NULL,
    location_id         BIGINT,
    status              VARCHAR(20)  NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'open', 'success', 'cancelled', 'error', 'failure')),
    shipment_status     VARCHAR(30)
        CHECK (shipment_status IS NULL OR shipment_status IN
            ('label_printed', 'label_purchased', 'attempted_delivery', 'ready_for_pickup',
             'picked_up', 'confirmed', 'in_transit', 'out_for_delivery', 'delivered', 'failure')),
    tracking_company    VARCHAR(80),
    tracking_number     VARCHAR(120),
    tracking_url        TEXT,
    service             VARCHAR(80),
    -- Delivered timestamp, which is what service-level reporting measures
    -- against the order date.
    delivered_at        TIMESTAMPTZ,
    estimated_delivery_at TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_fulfillment_delivered_status
        CHECK (delivered_at IS NULL OR status = 'success')
);

CREATE TABLE shopify.fulfillment_line_item (
    id                  BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fulfillment_id      BIGINT       NOT NULL,
    line_item_id        BIGINT       NOT NULL,
    quantity            INTEGER      NOT NULL CHECK (quantity > 0),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (fulfillment_id, line_item_id)
);

-- -------------------------------------------------------------------------
-- Transaction. Payment attempts against the order.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.transaction (
    id                  BIGINT       PRIMARY KEY,
    order_id            BIGINT       NOT NULL,
    parent_id           BIGINT,
    -- A capture references its authorization; a refund references its capture.
    kind                VARCHAR(20)  NOT NULL
        CHECK (kind IN ('authorization', 'capture', 'sale', 'void', 'refund')),
    status              VARCHAR(20)  NOT NULL
        CHECK (status IN ('pending', 'failure', 'success', 'error')),
    gateway             VARCHAR(80)  NOT NULL,
    amount              NUMERIC(18,2) NOT NULL CHECK (amount >= 0),
    currency            common.dom_iso3_code NOT NULL,
    -- Card fragments only; Shopify holds no PAN either.
    payment_method      VARCHAR(40),
    card_brand          VARCHAR(20),
    card_last_four      common.dom_card_last_four,
    authorization_code  VARCHAR(80),
    error_code          VARCHAR(80),
    message             TEXT,
    test                BOOLEAN      NOT NULL DEFAULT FALSE,
    processed_at        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL,

    CONSTRAINT ck_transaction_not_self_parent CHECK (parent_id IS NULL OR parent_id <> id),
    CONSTRAINT ck_transaction_failure_has_reason
        CHECK (status NOT IN ('failure', 'error') OR error_code IS NOT NULL)
);

COMMENT ON COLUMN shopify.transaction.test IS
    'Test-mode transactions are real rows with no money behind them. An '
    'extract that does not exclude them inflates revenue.';

-- -------------------------------------------------------------------------
-- Refund and its lines.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.refund (
    id                  BIGINT       PRIMARY KEY,
    order_id            BIGINT       NOT NULL,
    note                TEXT,
    -- Restock controls whether the goods came back into stock, which is the
    -- difference between a return and a write-off.
    restock             BOOLEAN      NOT NULL DEFAULT FALSE,
    total_refunded      NUMERIC(18,2) NOT NULL CHECK (total_refunded >= 0),
    currency            common.dom_iso3_code NOT NULL,
    processed_at        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL
);

CREATE TABLE shopify.refund_line_item (
    id                  BIGINT       PRIMARY KEY,
    refund_id           BIGINT       NOT NULL,
    line_item_id        BIGINT       NOT NULL,
    location_id         BIGINT,
    quantity            INTEGER      NOT NULL CHECK (quantity > 0),
    subtotal            NUMERIC(18,2) NOT NULL CHECK (subtotal >= 0),
    total_tax           NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_tax >= 0),
    restock_type        VARCHAR(20)  NOT NULL DEFAULT 'no_restock'
        CHECK (restock_type IN ('no_restock', 'cancel', 'return', 'legacy_restock')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Return. The customer-initiated process, distinct from the refund that
-- settles it. Feeds target merchandise.return_request.
--
-- `return_request`, not `return`: RETURN is reserved in PostgreSQL.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.return_request (
    id                  BIGINT       PRIMARY KEY,
    order_id            BIGINT       NOT NULL,
    status              VARCHAR(20)  NOT NULL DEFAULT 'requested'
        CHECK (status IN ('requested', 'open', 'declined', 'cancelled', 'closed')),
    -- Declined returns are the interesting ones: a personalised shirt cannot
    -- be returned, and the decline reason is the evidence for that.
    decline_reason      VARCHAR(40)
        CHECK (decline_reason IS NULL OR decline_reason IN
            ('final_sale', 'personalised', 'return_period_ended', 'no_proof_of_purchase',
             'item_not_as_sold', 'other')),
    total_quantity      INTEGER      NOT NULL DEFAULT 0 CHECK (total_quantity >= 0),
    requested_at        TIMESTAMPTZ  NOT NULL,
    closed_at           TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_return_declined_has_reason
        CHECK ((status = 'declined') = (decline_reason IS NOT NULL)),
    CONSTRAINT ck_return_closed_has_timestamp
        CHECK ((status IN ('closed', 'cancelled', 'declined')) = (closed_at IS NOT NULL))
);

CREATE TABLE shopify.return_line_item (
    id                  BIGINT       PRIMARY KEY,
    return_id           BIGINT       NOT NULL,
    line_item_id        BIGINT       NOT NULL,
    quantity            INTEGER      NOT NULL CHECK (quantity > 0),
    return_reason       VARCHAR(40)  NOT NULL
        CHECK (return_reason IN
            ('size_too_small', 'size_too_large', 'unwanted', 'not_as_described',
             'wrong_item', 'defective', 'damaged_in_transit', 'style', 'other')),
    return_reason_note  TEXT,
    customer_note       TEXT,
    -- Condition on arrival determines whether the item restocks or is written
    -- off, and the two have very different margin consequences.
    received_condition  VARCHAR(20)
        CHECK (received_condition IS NULL OR received_condition IN
            ('resellable', 'damaged', 'worn', 'missing_tags', 'not_received')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN shopify.return_line_item.return_reason IS
    'Sizing accounts for most apparel returns, and separating too-small from '
    'too-large is what makes the data actionable on the size curve. Target '
    'merchandise.return_request has a single reason column.';
