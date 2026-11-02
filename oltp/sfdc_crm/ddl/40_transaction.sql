-- =========================================================================
-- sfdc_crm -- transactional objects
--
-- Opportunities, contracts, quotes, orders, campaigns, cases and activities.
--
-- The sponsorship sales cycle runs Opportunity -> Quote -> Contract -> Order,
-- and the target model collapses it: sponsorship.deal is the Opportunity
-- joined to the Contract, so the quote stage disappears entirely and
-- win/loss analysis against quoted versus contracted value is not possible
-- downstream.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Opportunity and its line items. Feed target sponsorship.deal,
-- sponsorship.deal_term and broadcast.media_rights_deal.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.opportunity (
    id                  CHAR(18)     PRIMARY KEY,
    record_type_id      CHAR(18)     NOT NULL,
    account_id          CHAR(18),
    name                VARCHAR(120) NOT NULL,
    description         TEXT,
    stage_name          VARCHAR(40)  NOT NULL
        CHECK (stage_name IN
            ('Prospecting', 'Qualification', 'Needs Analysis', 'Proposal',
             'Negotiation', 'Closed Won', 'Closed Lost')),
    amount              NUMERIC(18,2) CHECK (amount IS NULL OR amount >= 0),
    currency_iso_code   common.dom_iso3_code NOT NULL,
    -- Probability and expected revenue: Salesforce derives expected revenue as
    -- amount * probability, so it is generated here rather than stored twice.
    probability         NUMERIC(5,2) NOT NULL DEFAULT 0
        CHECK (probability BETWEEN 0 AND 100),
    expected_revenue    NUMERIC(18,2)
        GENERATED ALWAYS AS (amount * probability / 100) STORED,
    close_date          DATE         NOT NULL,
    type                VARCHAR(40),
    lead_source         VARCHAR(40),
    pricebook2_id       CHAR(18),
    owner_id            CHAR(18)     NOT NULL,

    is_closed           BOOLEAN      NOT NULL DEFAULT FALSE,
    is_won              BOOLEAN      NOT NULL DEFAULT FALSE,
    -- Loss reason is the single most useful field for pipeline analysis and
    -- the one the target model drops.
    loss_reason__c      VARCHAR(40)
        CHECK (loss_reason__c IS NULL OR loss_reason__c IN
            ('price', 'competitor', 'no_budget', 'no_decision', 'timing',
             'inventory_unavailable', 'brand_conflict', 'other')),
    -- Category sponsorships are exclusive, so a competing brand in the same
    -- category blocks the deal. Tracked because it drives inventory conflicts.
    exclusivity_category__c VARCHAR(60),

    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_by_id       CHAR(18)     NOT NULL,
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_by_id CHAR(18)     NOT NULL,
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- The three closed-state columns have to agree with each other.
    CONSTRAINT ck_opportunity_closed_stage
        CHECK (is_closed = (stage_name IN ('Closed Won', 'Closed Lost'))),
    CONSTRAINT ck_opportunity_won_stage
        CHECK (is_won = (stage_name = 'Closed Won')),
    CONSTRAINT ck_opportunity_lost_has_reason
        CHECK (stage_name <> 'Closed Lost' OR loss_reason__c IS NOT NULL),
    CONSTRAINT ck_opportunity_won_probability
        CHECK (NOT is_won OR probability = 100)
);

COMMENT ON COLUMN sfdc_crm.opportunity.loss_reason__c IS
    'Why a deal was lost. No target column corresponds, so the lakehouse can '
    'report what was won but not why anything was lost.';

CREATE TABLE sfdc_crm.opportunity_line_item (
    id                  CHAR(18)     PRIMARY KEY,
    opportunity_id      CHAR(18)     NOT NULL,
    pricebook_entry_id  CHAR(18)     NOT NULL,
    product2_id         CHAR(18),
    quantity            NUMERIC(18,2) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price          NUMERIC(18,2) NOT NULL CHECK (unit_price >= 0),
    list_price          NUMERIC(18,2) CHECK (list_price IS NULL OR list_price >= 0),
    total_price         NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (quantity * unit_price) STORED,
    -- Discount against list, generated so sales cannot report it differently
    -- from finance.
    discount_percent    NUMERIC(6,3)
        GENERATED ALWAYS AS (
            CASE WHEN list_price IS NULL OR list_price = 0 THEN NULL
                 ELSE (list_price - unit_price) / list_price * 100 END
        ) STORED,
    description         TEXT,
    service_date        DATE,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Quote and its line items.
--
-- No target table corresponds. Quoting is where the negotiation happens, and
-- the gap between quoted and contracted value is the discount the
-- organisation actually gave away -- invisible downstream.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.quote (
    id                  CHAR(18)     PRIMARY KEY,
    opportunity_id      CHAR(18)     NOT NULL,
    name                VARCHAR(255) NOT NULL,
    quote_number        VARCHAR(40)  NOT NULL UNIQUE,
    status              VARCHAR(40)  NOT NULL DEFAULT 'Draft'
        CHECK (status IN ('Draft', 'In Review', 'Approved', 'Presented', 'Accepted', 'Rejected', 'Expired')),
    expiration_date     DATE,
    total_price         NUMERIC(18,2) CHECK (total_price IS NULL OR total_price >= 0),
    currency_iso_code   common.dom_iso3_code NOT NULL,
    is_syncing          BOOLEAN      NOT NULL DEFAULT FALSE,
    version_number__c   INTEGER      NOT NULL DEFAULT 1 CHECK (version_number__c > 0),
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (opportunity_id, version_number__c)
);

COMMENT ON TABLE sfdc_crm.quote IS
    'No target table corresponds. The quoted-versus-contracted gap is the '
    'realised discount, and it is not reconstructable from the lakehouse.';

CREATE TABLE sfdc_crm.quote_line_item (
    id                  CHAR(18)     PRIMARY KEY,
    quote_id            CHAR(18)     NOT NULL,
    pricebook_entry_id  CHAR(18)     NOT NULL,
    product2_id         CHAR(18),
    quantity            NUMERIC(18,2) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price          NUMERIC(18,2) NOT NULL CHECK (unit_price >= 0),
    list_price          NUMERIC(18,2) CHECK (list_price IS NULL OR list_price >= 0),
    total_price         NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (quantity * unit_price) STORED,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Contract and its line items.
--
-- Feed six target tables by record type: sponsorship.deal (with the
-- Opportunity), sponsorship.deal_term, sponsorship.naming_right,
-- broadcast.media_rights_deal, fan.loyalty_enrollment and
-- broadcast.streaming_subscription.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.contract (
    id                  CHAR(18)     PRIMARY KEY,
    record_type_id      CHAR(18)     NOT NULL,
    account_id          CHAR(18)     NOT NULL,
    contact_id          CHAR(18),
    contract_number     VARCHAR(30)  NOT NULL UNIQUE,
    opportunity_id__c   CHAR(18),
    status              VARCHAR(40)  NOT NULL DEFAULT 'Draft'
        CHECK (status IN ('Draft', 'In Approval Process', 'Activated', 'Terminated', 'Expired')),
    start_date          DATE,
    contract_term       INTEGER      CHECK (contract_term IS NULL OR contract_term > 0),
    -- End date is derived from start plus term in months, which is how
    -- Salesforce computes it.
    end_date            DATE,
    owner_expiration_notice VARCHAR(10)
        CHECK (owner_expiration_notice IS NULL OR owner_expiration_notice IN ('15', '30', '45', '60', '90', '120')),
    contract_value__c   NUMERIC(18,2) CHECK (contract_value__c IS NULL OR contract_value__c >= 0),
    currency_iso_code   common.dom_iso3_code NOT NULL,
    payment_frequency__c VARCHAR(20)
        CHECK (payment_frequency__c IS NULL OR payment_frequency__c IN
            ('annual', 'semi_annual', 'quarterly', 'monthly', 'one_time')),
    auto_renew__c       BOOLEAN      NOT NULL DEFAULT FALSE,
    -- Business key into the SAP contract that carries the money.
    sap_contract_number__c CHAR(10),
    activated_date      TIMESTAMPTZ,
    activated_by_id     CHAR(18),
    owner_id            CHAR(18)     NOT NULL,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_contract_dates
        CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date),
    CONSTRAINT ck_contract_activated_pair
        CHECK ((activated_date IS NULL) = (activated_by_id IS NULL)),
    CONSTRAINT ck_contract_activated_requires_stamp
        CHECK (status <> 'Activated' OR activated_date IS NOT NULL)
);

CREATE TABLE sfdc_crm.contract_line_item (
    id                  CHAR(18)     PRIMARY KEY,
    contract_id         CHAR(18)     NOT NULL,
    pricebook_entry_id  CHAR(18),
    product2_id         CHAR(18),
    quantity            NUMERIC(18,2) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price          NUMERIC(18,2) NOT NULL CHECK (unit_price >= 0),
    total_price         NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (quantity * unit_price) STORED,
    start_date          DATE,
    end_date            DATE,
    -- Deliverable terms. Target sponsorship.deal_term is this table.
    deliverable_type__c VARCHAR(40)
        CHECK (deliverable_type__c IS NULL OR deliverable_type__c IN
            ('signage', 'broadcast_spot', 'digital_impression', 'hospitality',
             'naming', 'athlete_appearance', 'content_series', 'activation_space', 'other')),
    deliverable_quantity__c INTEGER
        CHECK (deliverable_quantity__c IS NULL OR deliverable_quantity__c >= 0),
    delivered_quantity__c INTEGER NOT NULL DEFAULT 0
        CHECK (delivered_quantity__c >= 0),
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_cli_dates
        CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date),
    -- Over-delivery is real and is not an error, so this is deliberately not
    -- constrained to the committed quantity.
    CONSTRAINT ck_cli_delivery_tracked
        CHECK (deliverable_quantity__c IS NOT NULL OR delivered_quantity__c = 0)
);

COMMENT ON CONSTRAINT ck_cli_delivery_tracked ON sfdc_crm.contract_line_item IS
    'Delivery can only be recorded against a committed quantity. Deliberately '
    'permits over-delivery: exceeding a commitment is common and is not an error.';

-- -------------------------------------------------------------------------
-- Order and its items. Feed target fan.loyalty_transaction and the
-- subscription side of target broadcast.streaming_subscription.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.sales_order (
    id                  CHAR(18)     PRIMARY KEY,
    account_id          CHAR(18)     NOT NULL,
    contract_id         CHAR(18),
    order_number        VARCHAR(30)  NOT NULL UNIQUE,
    status              VARCHAR(40)  NOT NULL DEFAULT 'Draft'
        CHECK (status IN ('Draft', 'Activated', 'Cancelled', 'Completed')),
    effective_date      DATE         NOT NULL,
    end_date            DATE,
    total_amount        NUMERIC(18,2) NOT NULL DEFAULT 0,
    currency_iso_code   common.dom_iso3_code NOT NULL,
    -- Loyalty point movements are recorded as orders, which is why the point
    -- balance can be negative on a redemption.
    order_class__c      VARCHAR(30)  NOT NULL DEFAULT 'commercial'
        CHECK (order_class__c IN ('commercial', 'loyalty_accrual', 'loyalty_redemption', 'subscription')),
    points_delta__c     INTEGER,
    pricebook2_id       CHAR(18),
    owner_id            CHAR(18)     NOT NULL,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_sf_order_dates
        CHECK (end_date IS NULL OR end_date >= effective_date),
    -- A loyalty order moves points; a commercial one does not.
    CONSTRAINT ck_sf_order_points
        CHECK ((order_class__c IN ('loyalty_accrual', 'loyalty_redemption'))
               = (points_delta__c IS NOT NULL)),
    CONSTRAINT ck_sf_order_points_direction
        CHECK (points_delta__c IS NULL
               OR (order_class__c = 'loyalty_accrual' AND points_delta__c > 0)
               OR (order_class__c = 'loyalty_redemption' AND points_delta__c < 0))
);

CREATE TABLE sfdc_crm.sales_order_item (
    id                  CHAR(18)     PRIMARY KEY,
    order_id            CHAR(18)     NOT NULL,
    pricebook_entry_id  CHAR(18)     NOT NULL,
    product2_id         CHAR(18),
    quantity            NUMERIC(18,2) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price          NUMERIC(18,2) NOT NULL,
    total_price         NUMERIC(18,2) NOT NULL
        GENERATED ALWAYS AS (quantity * unit_price) STORED,
    service_date        DATE,
    end_date            DATE,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Campaign and CampaignMember. Feed target fan.campaign,
-- target sponsorship.activation and target sponsorship.activation_fulfillment.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.campaign (
    id                  CHAR(18)     PRIMARY KEY,
    name                VARCHAR(80)  NOT NULL,
    parent_id           CHAR(18),
    type                VARCHAR(40)
        CHECK (type IS NULL OR type IN
            ('Email', 'Social', 'Advertisement', 'Event', 'Sponsorship Activation',
             'Direct Mail', 'Referral', 'Other')),
    status              VARCHAR(40)  NOT NULL DEFAULT 'Planned'
        CHECK (status IN ('Planned', 'In Progress', 'Completed', 'Aborted')),
    start_date          DATE,
    end_date            DATE,
    budgeted_cost       NUMERIC(18,2) CHECK (budgeted_cost IS NULL OR budgeted_cost >= 0),
    actual_cost         NUMERIC(18,2) CHECK (actual_cost IS NULL OR actual_cost >= 0),
    expected_revenue    NUMERIC(18,2),
    number_sent         INTEGER      NOT NULL DEFAULT 0 CHECK (number_sent >= 0),
    currency_iso_code   common.dom_iso3_code NOT NULL,
    -- Links a sponsorship activation back to the deal that commissioned it.
    contract_id__c      CHAR(18),
    aep_journey_id__c   VARCHAR(80),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    owner_id            CHAR(18)     NOT NULL,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_campaign_not_self_parent CHECK (parent_id IS NULL OR parent_id <> id),
    CONSTRAINT ck_campaign_dates
        CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

COMMENT ON COLUMN sfdc_crm.campaign.aep_journey_id__c IS
    'Business key into adobe_aep.journey. Salesforce plans the campaign; AEP '
    'executes it. Target fan.communication comes from the AEP side.';

CREATE TABLE sfdc_crm.campaign_member (
    id                  CHAR(18)     PRIMARY KEY,
    campaign_id         CHAR(18)     NOT NULL,
    contact_id          CHAR(18),
    lead_id             CHAR(18),
    status              VARCHAR(40)  NOT NULL DEFAULT 'Sent'
        CHECK (status IN ('Planned', 'Sent', 'Opened', 'Clicked', 'Responded', 'Attended', 'Bounced', 'Unsubscribed')),
    has_responded       BOOLEAN      NOT NULL DEFAULT FALSE,
    first_responded_date DATE,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- Salesforce requires exactly one of contact or lead.
    CONSTRAINT ck_campaign_member_target
        CHECK ((contact_id IS NOT NULL) <> (lead_id IS NOT NULL)),
    CONSTRAINT ck_campaign_member_responded
        CHECK (has_responded = (first_responded_date IS NOT NULL))
);

-- -------------------------------------------------------------------------
-- Case and CaseComment. Feed target fan.service_case.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.service_case (
    id                  CHAR(18)     PRIMARY KEY,
    case_number         VARCHAR(30)  NOT NULL UNIQUE,
    account_id          CHAR(18),
    contact_id          CHAR(18),
    parent_id           CHAR(18),
    subject             VARCHAR(255) NOT NULL,
    description         TEXT,
    type                VARCHAR(40)
        CHECK (type IS NULL OR type IN
            ('Ticketing', 'Access', 'Refund', 'Merchandise', 'Streaming',
             'Membership', 'Accessibility', 'Complaint', 'Data Request', 'Other')),
    status              VARCHAR(40)  NOT NULL DEFAULT 'New'
        CHECK (status IN ('New', 'Working', 'Escalated', 'Awaiting Customer', 'Closed')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'Medium'
        CHECK (priority IN ('Critical', 'High', 'Medium', 'Low')),
    origin              VARCHAR(40)
        CHECK (origin IS NULL OR origin IN ('Phone', 'Email', 'Web', 'Chat', 'Social', 'In Person')),
    reason              VARCHAR(40),
    is_escalated        BOOLEAN      NOT NULL DEFAULT FALSE,
    is_closed           BOOLEAN      NOT NULL DEFAULT FALSE,
    closed_date         TIMESTAMPTZ,
    -- First response and resolution are the two service commitments actually
    -- reported on.
    first_response_at__c TIMESTAMPTZ,
    sla_breached__c     BOOLEAN      NOT NULL DEFAULT FALSE,
    satisfaction_score__c SMALLINT
        CHECK (satisfaction_score__c IS NULL OR satisfaction_score__c BETWEEN 1 AND 5),
    -- Business keys to the order or ticket the case is about.
    tm_order_number__c  VARCHAR(30),
    shopify_order_id__c BIGINT,
    owner_id            CHAR(18)     NOT NULL,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_case_not_self_parent CHECK (parent_id IS NULL OR parent_id <> id),
    CONSTRAINT ck_case_closed_consistent
        CHECK (is_closed = (status = 'Closed')),
    CONSTRAINT ck_case_closed_has_date
        CHECK (is_closed = (closed_date IS NOT NULL)),
    CONSTRAINT ck_case_escalated_status
        CHECK (NOT is_escalated OR status IN ('Escalated', 'Working', 'Closed'))
);

CREATE TABLE sfdc_crm.service_case_comment (
    id                  CHAR(18)     PRIMARY KEY,
    parent_id           CHAR(18)     NOT NULL,
    comment_body        TEXT         NOT NULL,
    -- Public comments are visible to the fan in the portal; private ones are
    -- internal. The target model keeps no comments at all.
    is_published        BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_by_id       CHAR(18)     NOT NULL,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Task and Event. Salesforce activities.
--
-- Feed the human-initiated side of target fan.communication and target
-- sponsorship.activation_fulfillment.
--
-- `event_activity`, not `event`: the Salesforce object is called Event, but
-- that name is already taken by tm_axs.event in this model and the collision
-- would be genuinely confusing.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.task (
    id                  CHAR(18)     PRIMARY KEY,
    subject             VARCHAR(255) NOT NULL,
    description         TEXT,
    -- WhoId points at a Contact or Lead; WhatId at any other object. Both are
    -- polymorphic in Salesforce and therefore unconstrainable.
    who_id              CHAR(18),
    what_id             CHAR(18),
    what_object_type    VARCHAR(40),
    status              VARCHAR(40)  NOT NULL DEFAULT 'Not Started'
        CHECK (status IN ('Not Started', 'In Progress', 'Completed', 'Waiting on someone else', 'Deferred')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'Normal'
        CHECK (priority IN ('High', 'Normal', 'Low')),
    activity_date       DATE,
    is_closed           BOOLEAN      NOT NULL DEFAULT FALSE,
    task_subtype        VARCHAR(40)
        CHECK (task_subtype IS NULL OR task_subtype IN ('Task', 'Email', 'Call', 'ListEmail')),
    owner_id            CHAR(18)     NOT NULL,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_task_closed_consistent
        CHECK (is_closed = (status IN ('Completed', 'Deferred'))),
    -- A polymorphic reference needs to say what it points at.
    CONSTRAINT ck_task_what_typed
        CHECK ((what_id IS NULL) = (what_object_type IS NULL))
);

COMMENT ON COLUMN sfdc_crm.task.what_id IS
    'Polymorphic reference -- may point at an Opportunity, Contract, Campaign '
    'or Case. Cannot be a foreign key, which is why what_object_type is '
    'mandatory alongside it.';

CREATE TABLE sfdc_crm.event_activity (
    id                  CHAR(18)     PRIMARY KEY,
    subject             VARCHAR(255) NOT NULL,
    description         TEXT,
    who_id              CHAR(18),
    what_id             CHAR(18),
    what_object_type    VARCHAR(40),
    location            VARCHAR(255),
    start_date_time     TIMESTAMPTZ,
    end_date_time       TIMESTAMPTZ,
    duration_in_minutes INTEGER      CHECK (duration_in_minutes IS NULL OR duration_in_minutes >= 0),
    is_all_day_event    BOOLEAN      NOT NULL DEFAULT FALSE,
    event_subtype       VARCHAR(40),
    owner_id            CHAR(18)     NOT NULL,
    is_deleted          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_sf_event_times
        CHECK (end_date_time IS NULL OR start_date_time IS NULL OR end_date_time >= start_date_time),
    CONSTRAINT ck_sf_event_what_typed
        CHECK ((what_id IS NULL) = (what_object_type IS NULL))
);
