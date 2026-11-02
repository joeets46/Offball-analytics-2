-- =========================================================================
-- shopify -- shop, catalog and customers
--
-- Every primary key in this file is a plain BIGINT with no IDENTITY clause.
-- That is deliberate and it is the defining property of a SaaS replica: these
-- ids are minted by Shopify and arrive with the data.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Shop. The storefront itself. A Plus account runs several -- one per market
-- or per team -- and the target model has no concept of them at all.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.shop (
    id                  BIGINT       PRIMARY KEY,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    name                VARCHAR(255) NOT NULL,
    myshopify_domain    VARCHAR(255) NOT NULL UNIQUE,
    primary_domain      VARCHAR(255),
    currency            common.dom_iso3_code NOT NULL,
    -- Presentment currencies: a Plus shop prices in several. Target
    -- merchandise.* carries one currency per row, so multi-currency revenue
    -- has to be normalized on load.
    enabled_presentment_currencies TEXT[],
    timezone            common.dom_iana_timezone NOT NULL,
    country_code        common.dom_iso3_code NOT NULL,
    plan_name           VARCHAR(40)  NOT NULL DEFAULT 'shopify_plus',
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN shopify.shop.enabled_presentment_currencies IS
    'Native array. A Plus shop presents prices in several currencies; the '
    'target model has one currency column, so conversion happens on load.';

-- -------------------------------------------------------------------------
-- Location. Where stock sits and where orders are fulfilled from.
-- Feeds target merchandise.retail_location.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.location (
    id                  BIGINT       PRIMARY KEY,
    shop_id             BIGINT       NOT NULL,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    name                VARCHAR(255) NOT NULL,
    address1            VARCHAR(255),
    address2            VARCHAR(255),
    city                VARCHAR(80),
    province_code       common.dom_state_province,
    country_code        common.dom_iso3_code,
    zip                 VARCHAR(20),
    phone               VARCHAR(40),
    -- A location can hold stock, fulfil orders, or both. Stadium retail is
    -- usually both; a pop-up may be neither once the event ends.
    active              BOOLEAN      NOT NULL DEFAULT TRUE,
    legacy              BOOLEAN      NOT NULL DEFAULT FALSE,
    fulfills_online_orders BOOLEAN   NOT NULL DEFAULT FALSE,
    -- Business key into the SAP plant that carries the stock valuation.
    sap_werks           CHAR(4),
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Product and variant. Feed target merchandise.sku_catalog.
--
-- Shopify's product/variant split is the thing the target model loses: a
-- "Home Shirt 2026" product with eighteen size and name-print variants
-- becomes eighteen unrelated sku_catalog rows, so product-level reporting has
-- to be reconstructed by string matching.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.product (
    id                  BIGINT       PRIMARY KEY,
    shop_id             BIGINT       NOT NULL,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    title               VARCHAR(255) NOT NULL,
    handle              VARCHAR(255) NOT NULL,
    body_html           TEXT,
    vendor              VARCHAR(255),
    product_type        VARCHAR(255),
    tags                TEXT,
    status              VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'archived', 'draft')),
    -- published_at null means unpublished; Shopify does not delete products.
    published_at        TIMESTAMPTZ,
    published_scope     VARCHAR(20)  NOT NULL DEFAULT 'web'
        CHECK (published_scope IN ('web', 'global')),
    template_suffix     VARCHAR(255),
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (shop_id, handle),
    -- A draft or archived product cannot be published.
    CONSTRAINT ck_product_published_status
        CHECK (status = 'active' OR published_at IS NULL)
);

COMMENT ON TABLE shopify.product IS
    'The product grouping. Target merchandise.sku_catalog is the variant, so '
    'the grouping is dropped and product-level reporting cannot be rebuilt '
    'from the lakehouse without matching on title.';

CREATE TABLE shopify.product_variant (
    id                  BIGINT       PRIMARY KEY,
    product_id          BIGINT       NOT NULL,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    inventory_item_id   BIGINT       NOT NULL,
    title               VARCHAR(255) NOT NULL,
    sku                 VARCHAR(255),
    barcode             VARCHAR(255),
    position            SMALLINT     NOT NULL DEFAULT 1 CHECK (position > 0),
    -- Shopify models variant axes as three fixed option slots, not as a
    -- normalized option table. Size, colour and print are the usual three for
    -- sports merchandise.
    option1             VARCHAR(255),
    option2             VARCHAR(255),
    option3             VARCHAR(255),
    price               NUMERIC(18,2) NOT NULL CHECK (price >= 0),
    compare_at_price    NUMERIC(18,2) CHECK (compare_at_price IS NULL OR compare_at_price >= 0),
    taxable             BOOLEAN      NOT NULL DEFAULT TRUE,
    tax_code            VARCHAR(40),
    weight              NUMERIC(12,3) CHECK (weight IS NULL OR weight >= 0),
    weight_unit         VARCHAR(10)
        CHECK (weight_unit IS NULL OR weight_unit IN ('g', 'kg', 'oz', 'lb')),
    requires_shipping   BOOLEAN      NOT NULL DEFAULT TRUE,
    inventory_policy    VARCHAR(10)  NOT NULL DEFAULT 'deny'
        CHECK (inventory_policy IN ('deny', 'continue')),
    inventory_management VARCHAR(20),
    -- Business key into the SAP material master.
    sap_matnr           CHAR(18),
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (product_id, position),
    -- A compare-at price below the price is a misconfigured "sale".
    CONSTRAINT ck_variant_compare_at
        CHECK (compare_at_price IS NULL OR compare_at_price >= price),
    CONSTRAINT ck_variant_weight_unit
        CHECK ((weight IS NULL) OR weight_unit IS NOT NULL)
);

COMMENT ON COLUMN shopify.product_variant.inventory_policy IS
    '`continue` permits overselling. Target merchandise.sku_catalog has no '
    'equivalent, so the lakehouse cannot distinguish a genuine stockout from '
    'a deliberate backorder.';

-- -------------------------------------------------------------------------
-- Collection. Feeds target merchandise.product_category.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.collection (
    id                  BIGINT       PRIMARY KEY,
    shop_id             BIGINT       NOT NULL,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    title               VARCHAR(255) NOT NULL,
    handle              VARCHAR(255) NOT NULL,
    body_html           TEXT,
    -- Smart collections are rule-driven and have no explicit membership rows,
    -- so the target category assignment is incomplete for them by nature.
    collection_type     VARCHAR(10)  NOT NULL DEFAULT 'custom'
        CHECK (collection_type IN ('custom', 'smart')),
    disjunctive         BOOLEAN      NOT NULL DEFAULT FALSE,
    sort_order          VARCHAR(30),
    published_at        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (shop_id, handle)
);

COMMENT ON COLUMN shopify.collection.collection_type IS
    'A smart collection has no membership rows -- it is a stored rule. Target '
    'merchandise.product_category therefore cannot be fully populated from '
    'collection_product alone.';

CREATE TABLE shopify.collection_product (
    collection_id       BIGINT       NOT NULL,
    product_id          BIGINT       NOT NULL,
    position            INTEGER      NOT NULL DEFAULT 1 CHECK (position > 0),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (collection_id, product_id)
);

-- -------------------------------------------------------------------------
-- Inventory item and level. The storefront's view of stock.
--
-- Target merchandise.inventory_position maps to SAP, not here, because SAP is
-- authoritative for stock. These tables are the mirror the storefront sells
-- against, and the two drift -- which is what oversells.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.inventory_item (
    id                  BIGINT       PRIMARY KEY,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    sku                 VARCHAR(255),
    -- Unit cost, which is the only costing Shopify holds. SAP's moving
    -- average price is the real one.
    cost                NUMERIC(18,2) CHECK (cost IS NULL OR cost >= 0),
    country_code_of_origin common.dom_iso3_code,
    harmonized_system_code VARCHAR(20),
    tracked             BOOLEAN      NOT NULL DEFAULT TRUE,
    requires_shipping   BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE shopify.inventory_level (
    inventory_item_id   BIGINT       NOT NULL,
    location_id         BIGINT       NOT NULL,
    -- Available can go negative when inventory_policy is `continue`, so it is
    -- deliberately unconstrained.
    available           INTEGER      NOT NULL DEFAULT 0,
    -- Committed is stock sold but not yet fulfilled. The target model has one
    -- quantity, so committed stock reads as available.
    committed           INTEGER      NOT NULL DEFAULT 0 CHECK (committed >= 0),
    incoming            INTEGER      NOT NULL DEFAULT 0 CHECK (incoming >= 0),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (inventory_item_id, location_id)
);

COMMENT ON COLUMN shopify.inventory_level.available IS
    'Deliberately permits negative values: a variant with inventory_policy '
    '`continue` oversells by design, and a non-negative CHECK would reject '
    'rows a real extract delivers.';

-- -------------------------------------------------------------------------
-- Customer and address. The fourth place the same human exists.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.customer (
    id                  BIGINT       PRIMARY KEY,
    shop_id             BIGINT       NOT NULL,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    email               common.dom_email,
    phone               VARCHAR(40),
    first_name          VARCHAR(80),
    last_name           VARCHAR(80),
    state               VARCHAR(20)  NOT NULL DEFAULT 'enabled'
        CHECK (state IN ('disabled', 'invited', 'enabled', 'declined')),
    verified_email      BOOLEAN      NOT NULL DEFAULT FALSE,
    tax_exempt          BOOLEAN      NOT NULL DEFAULT FALSE,
    tags                TEXT,
    note                TEXT,
    -- Marketing consent, which the target fan.consent_preference needs. AEP
    -- is authoritative, but this is where a storefront opt-in originates.
    email_marketing_state VARCHAR(20) NOT NULL DEFAULT 'not_subscribed'
        CHECK (email_marketing_state IN ('not_subscribed', 'pending', 'subscribed', 'unsubscribed', 'redacted')),
    email_marketing_consent_updated_at TIMESTAMPTZ,
    sms_marketing_state VARCHAR(20)  NOT NULL DEFAULT 'not_subscribed'
        CHECK (sms_marketing_state IN ('not_subscribed', 'pending', 'subscribed', 'unsubscribed', 'redacted')),
    -- Rolled-up spend, maintained by the platform.
    orders_count        INTEGER      NOT NULL DEFAULT 0 CHECK (orders_count >= 0),
    total_spent         NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_spent >= 0),
    default_address_id  BIGINT,
    -- Business keys to the other systems holding this person.
    sfdc_contact_id     CHAR(18),
    aep_ecid            VARCHAR(80),
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- Shopify requires an email or a phone to identify a customer.
    CONSTRAINT ck_customer_contactable
        CHECK (email IS NOT NULL OR phone IS NOT NULL)
);

COMMENT ON COLUMN shopify.customer.email_marketing_state IS
    'The `redacted` state is a completed GDPR erasure. It is not the same as '
    'unsubscribed and must not be loaded as a marketable state.';

CREATE TABLE shopify.customer_address (
    id                  BIGINT       PRIMARY KEY,
    customer_id         BIGINT       NOT NULL,
    first_name          VARCHAR(80),
    last_name           VARCHAR(80),
    company             VARCHAR(255),
    address1            VARCHAR(255),
    address2            VARCHAR(255),
    city                VARCHAR(80),
    province            VARCHAR(80),
    province_code       common.dom_state_province,
    country             VARCHAR(80),
    country_code        common.dom_iso3_code,
    zip                 VARCHAR(20),
    phone               VARCHAR(40),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Price rule and discount code. Feed target merchandise.promotion.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.price_rule (
    id                  BIGINT       PRIMARY KEY,
    shop_id             BIGINT       NOT NULL,
    admin_graphql_api_id VARCHAR(120) NOT NULL UNIQUE,
    title               VARCHAR(255) NOT NULL,
    target_type         VARCHAR(20)  NOT NULL
        CHECK (target_type IN ('line_item', 'shipping_line')),
    target_selection    VARCHAR(20)  NOT NULL
        CHECK (target_selection IN ('all', 'entitled')),
    allocation_method   VARCHAR(20)  NOT NULL
        CHECK (allocation_method IN ('across', 'each')),
    value_type          VARCHAR(20)  NOT NULL
        CHECK (value_type IN ('fixed_amount', 'percentage')),
    -- Shopify stores discount value as a NEGATIVE number. A sign error here
    -- turns a discount into a surcharge, so the constraint is worth having.
    value               NUMERIC(18,2) NOT NULL CHECK (value <= 0),
    once_per_customer   BOOLEAN      NOT NULL DEFAULT FALSE,
    usage_limit         INTEGER      CHECK (usage_limit IS NULL OR usage_limit > 0),
    customer_selection  VARCHAR(20)  NOT NULL DEFAULT 'all'
        CHECK (customer_selection IN ('all', 'prerequisite')),
    starts_at           TIMESTAMPTZ  NOT NULL,
    ends_at             TIMESTAMPTZ,
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_price_rule_window CHECK (ends_at IS NULL OR ends_at > starts_at),
    CONSTRAINT ck_price_rule_percentage_bound
        CHECK (value_type <> 'percentage' OR value >= -100)
);

COMMENT ON COLUMN shopify.price_rule.value IS
    'Negative by Shopify convention -- a 20%% discount is -20. The CHECK is '
    'there because sign inversion on load is a real and silent failure.';

CREATE TABLE shopify.discount_code (
    id                  BIGINT       PRIMARY KEY,
    price_rule_id       BIGINT       NOT NULL,
    code                CITEXT       NOT NULL,
    usage_count         INTEGER      NOT NULL DEFAULT 0 CHECK (usage_count >= 0),
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- Discount codes are matched case-insensitively at checkout.
    UNIQUE (code)
);

-- -------------------------------------------------------------------------
-- Metafield. Shopify's extension mechanism.
--
-- Every retailer puts the attributes the platform does not model here --
-- player name, kit year, licensing body, squad number. The target
-- merchandise.sku_catalog has fixed columns, so whichever metafields the
-- mapping happens to know about get promoted and the rest are dropped.
-- -------------------------------------------------------------------------
CREATE TABLE shopify.metafield (
    id                  BIGINT       PRIMARY KEY,
    owner_resource      VARCHAR(40)  NOT NULL
        CHECK (owner_resource IN ('product', 'variant', 'collection', 'customer', 'order', 'shop')),
    owner_id            BIGINT       NOT NULL,
    namespace           VARCHAR(40)  NOT NULL,
    key                 VARCHAR(64)  NOT NULL,
    type                VARCHAR(40)  NOT NULL,
    value               JSONB        NOT NULL,
    created_at          TIMESTAMPTZ  NOT NULL,
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (owner_resource, owner_id, namespace, key)
);

COMMENT ON TABLE shopify.metafield IS
    'Polymorphic key-value extension, so owner_id cannot be a foreign key. '
    'JSONB rather than text because the type column genuinely varies: a '
    'metafield holds a scalar, a list or a reference.';
