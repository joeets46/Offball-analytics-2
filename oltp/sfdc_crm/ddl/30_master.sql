-- =========================================================================
-- sfdc_crm -- standard objects
--
-- Account, Contact, Product, Pricebook. The commercial master data.
--
-- Every object carries the same audit quintet and IsDeleted. That repetition
-- is the platform's, not an oversight: Salesforce objects are uniform by
-- design, and the extract relies on it.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Account. Companies and fan households.
--
-- Feeds six target tables depending on record type: sponsorship.sponsor,
-- athlete.agency, broadcast.rights_holder, broadcast.licensee, fan.account
-- and fan.club.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.account (
    id                  CHAR(18)     PRIMARY KEY,
    record_type_id      CHAR(18)     NOT NULL,
    name                VARCHAR(255) NOT NULL,
    account_number      VARCHAR(40),
    -- Self-reference for corporate hierarchies: a brand under a holding
    -- company, a regional subsidiary under a global sponsor.
    parent_id           CHAR(18),
    type                VARCHAR(40)
        CHECK (type IS NULL OR type IN
            ('Prospect', 'Customer', 'Partner', 'Sponsor', 'Agency',
             'Rights Holder', 'Licensee', 'Supplier', 'Other')),
    industry            VARCHAR(40),
    annual_revenue      NUMERIC(18,2) CHECK (annual_revenue IS NULL OR annual_revenue >= 0),
    number_of_employees INTEGER      CHECK (number_of_employees IS NULL OR number_of_employees >= 0),
    website             common.dom_url,
    phone               VARCHAR(40),
    -- Billing and shipping addresses are separate compound fields in
    -- Salesforce; only billing is modeled here.
    billing_street      VARCHAR(255),
    billing_city        VARCHAR(40),
    billing_state       VARCHAR(80),
    billing_postal_code VARCHAR(20),
    billing_country     VARCHAR(80),
    owner_id            CHAR(18)     NOT NULL,

    -- Custom fields. The __c suffix is kept so configuration is visibly
    -- distinct from the platform's own columns.
    sap_customer_number__c  CHAR(10),
    sap_vendor_number__c    CHAR(10),
    tier__c                 VARCHAR(20)
        CHECK (tier__c IS NULL OR tier__c IN ('platinum', 'gold', 'silver', 'bronze', 'unranked')),
    contract_value_total__c NUMERIC(18,2)
        CHECK (contract_value_total__c IS NULL OR contract_value_total__c >= 0),

    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_by_id       CHAR(18)     NOT NULL,
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_by_id CHAR(18)     NOT NULL,
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_account_not_self_parent CHECK (parent_id IS NULL OR parent_id <> id),
    -- A sponsor settles as an SAP customer; a supplier or licensor as a
    -- vendor. Carrying both would mean the integration cannot tell which.
    CONSTRAINT ck_account_sap_role_exclusive
        CHECK (sap_customer_number__c IS NULL OR sap_vendor_number__c IS NULL)
);

COMMENT ON COLUMN sfdc_crm.account.system_modstamp IS
    'The replication watermark. Moves on platform-driven changes that leave '
    'last_modified_date untouched, so an extract keyed on last_modified_date '
    'silently misses rows.';
COMMENT ON COLUMN sfdc_crm.account.is_deleted IS
    'Recycle Bin flag. Records remain queryable for 15 days after deletion; an '
    'extract that does not filter this loads records the business considers gone.';

-- -------------------------------------------------------------------------
-- Contact. People. Feeds target fan.fan_profile and target athlete.agent.
--
-- The PII satellite split applies here as it does in tm_axs -- see
-- 31_master_pii.sql.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.contact (
    id                  CHAR(18)     PRIMARY KEY,
    record_type_id      CHAR(18)     NOT NULL,
    account_id          CHAR(18),
    -- Name is a formula of the parts in Salesforce. Stored here as a generated
    -- column so it cannot drift.
    first_name          VARCHAR(40),
    last_name           VARCHAR(80)  NOT NULL,
    name                VARCHAR(121) NOT NULL
        GENERATED ALWAYS AS (
            CASE WHEN first_name IS NULL OR first_name = '' THEN last_name
                 ELSE first_name || ' ' || last_name END
        ) STORED,
    title               VARCHAR(128),
    department          VARCHAR(80),
    -- Reports-to, a self reference. Used for sponsor org charts.
    reports_to_id       CHAR(18),
    owner_id            CHAR(18)     NOT NULL,

    -- Opt-out flags live on the platform object, not the satellite: they are
    -- consent state, not identifying data, and the marketing integration needs
    -- them without needing the person.
    has_opted_out_of_email BOOLEAN   NOT NULL DEFAULT FALSE,
    do_not_call         BOOLEAN      NOT NULL DEFAULT FALSE,

    -- Business keys outward to the other systems holding the same human.
    tm_account_number__c    VARCHAR(10),
    archtics_account__c     VARCHAR(10),
    aep_ecid__c             VARCHAR(80),
    shopify_customer_id__c  BIGINT,
    sfsf_person_id__c       VARCHAR(40),

    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_by_id       CHAR(18)     NOT NULL,
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_by_id CHAR(18)     NOT NULL,
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_contact_not_self_manager CHECK (reports_to_id IS NULL OR reports_to_id <> id)
);

COMMENT ON TABLE sfdc_crm.contact IS
    'People. The five __c business keys are the reason `fan` is a canonical '
    'entity: the same person exists here, in TM/AXS, in Archtics, in Shopify '
    'and in AEP, under five unrelated keys.';

-- -------------------------------------------------------------------------
-- AccountContactRelation. The many-to-many Salesforce added because a contact
-- genuinely belongs to more than one account.
--
-- Feeds target athlete.agent_relationship and target fan.club_membership.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.account_contact_relation (
    id                  CHAR(18)     PRIMARY KEY,
    account_id          CHAR(18)     NOT NULL,
    contact_id          CHAR(18)     NOT NULL,
    roles               VARCHAR(255),
    -- Exactly one relation per contact is the direct one; the rest are
    -- indirect. Salesforce enforces this, and so does the partial unique index.
    is_direct           BOOLEAN      NOT NULL DEFAULT FALSE,
    start_date          DATE,
    end_date            DATE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,

    -- Agent representation terms, which is what makes this table the source
    -- for athlete.agent_relationship.
    commission_rate__c  NUMERIC(5,4)
        CHECK (commission_rate__c IS NULL OR commission_rate__c BETWEEN 0 AND 1),
    representation_scope__c VARCHAR(40)
        CHECK (representation_scope__c IS NULL OR representation_scope__c IN
            ('playing_contract', 'endorsement', 'nil', 'full_service', 'media')),

    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (account_id, contact_id),
    CONSTRAINT ck_acr_dates CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

-- -------------------------------------------------------------------------
-- Lead. Unqualified demand, converted into an Account and Contact.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.lead (
    id                  CHAR(18)     PRIMARY KEY,
    last_name           VARCHAR(80)  NOT NULL,
    first_name          VARCHAR(40),
    company             VARCHAR(255) NOT NULL,
    email               common.dom_email,
    phone               VARCHAR(40),
    status              VARCHAR(40)  NOT NULL DEFAULT 'Open'
        CHECK (status IN ('Open', 'Working', 'Nurturing', 'Qualified', 'Unqualified', 'Converted')),
    lead_source         VARCHAR(40),
    rating              VARCHAR(40) CHECK (rating IS NULL OR rating IN ('Hot', 'Warm', 'Cold')),
    owner_id            CHAR(18)     NOT NULL,
    -- Conversion writes all three references at once.
    is_converted        BOOLEAN      NOT NULL DEFAULT FALSE,
    converted_date      DATE,
    converted_account_id CHAR(18),
    converted_contact_id CHAR(18),
    converted_opportunity_id CHAR(18),
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_lead_conversion_consistent
        CHECK (is_converted = (converted_date IS NOT NULL)),
    CONSTRAINT ck_lead_converted_has_account
        CHECK (NOT is_converted OR converted_account_id IS NOT NULL),
    CONSTRAINT ck_lead_status_matches_conversion
        CHECK (is_converted = (status = 'Converted'))
);

-- -------------------------------------------------------------------------
-- Product2 / Pricebook2 / PricebookEntry.
--
-- Feed target sponsorship.property, sponsorship.inventory_unit,
-- sponsorship.ad_inventory and target fan.loyalty_program. A sponsorable
-- asset is a product in Salesforce, which is why all four map here.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.product2 (
    id                  CHAR(18)     PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    product_code        VARCHAR(255),
    description         TEXT,
    family              VARCHAR(40),
    -- The classification that separates the four target tables.
    product_class__c    VARCHAR(30)  NOT NULL DEFAULT 'other'
        CHECK (product_class__c IN
            ('sponsorship_property', 'inventory_unit', 'ad_inventory',
             'loyalty_program', 'membership', 'subscription', 'other')),
    -- Sponsorable assets are tied to a venue, a fixture or a broadcast slot.
    asset_location__c   VARCHAR(120),
    impressions_estimate__c BIGINT
        CHECK (impressions_estimate__c IS NULL OR impressions_estimate__c >= 0),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE sfdc_crm.pricebook2 (
    id                  CHAR(18)     PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    description         VARCHAR(255),
    is_standard         BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE sfdc_crm.pricebook_entry (
    id                  CHAR(18)     PRIMARY KEY,
    pricebook2_id       CHAR(18)     NOT NULL,
    product2_id         CHAR(18)     NOT NULL,
    unit_price          NUMERIC(18,2) NOT NULL CHECK (unit_price >= 0),
    currency_iso_code   common.dom_iso3_code NOT NULL,
    use_standard_price  BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- One price per product per book per currency.
    UNIQUE (pricebook2_id, product2_id, currency_iso_code)
);

-- -------------------------------------------------------------------------
-- Asset. A product instance a customer holds. Feeds the allocated side of
-- target sponsorship.inventory_allocation and sponsorship.activation.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.asset (
    id                  CHAR(18)     PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    account_id          CHAR(18),
    contact_id          CHAR(18),
    product2_id         CHAR(18),
    serial_number       VARCHAR(80),
    status              VARCHAR(40)
        CHECK (status IS NULL OR status IN ('Purchased', 'Shipped', 'Installed', 'Registered', 'Obsolete')),
    quantity            NUMERIC(18,2) CHECK (quantity IS NULL OR quantity >= 0),
    price               NUMERIC(18,2) CHECK (price IS NULL OR price >= 0),
    install_date        DATE,
    usage_end_date      DATE,
    -- Which fixture or broadcast window this allocation applies to. Business
    -- keys, since neither system is Salesforce.
    tm_event_code__c    VARCHAR(30),
    dalet_asset_id__c   VARCHAR(40),
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_asset_dates
        CHECK (usage_end_date IS NULL OR install_date IS NULL OR usage_end_date >= install_date),
    -- An asset belongs to an account or a contact.
    CONSTRAINT ck_asset_owner CHECK (account_id IS NOT NULL OR contact_id IS NOT NULL)
);
