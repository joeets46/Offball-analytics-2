-- =========================================================================
-- adobe_aep -- platform configuration
--
-- Identity namespaces, datasets, event types and data-use labels. All of it
-- is governance metadata, and the data-use labels are the only named source
-- for target compliance.data_processing_record.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Identity namespace. The vocabulary of identity in AEP.
--
-- This table is why fan identity is hard. A person is not identified by one
-- key but by several, each in its own namespace, each originating in a
-- different system. The target fan.fan_profile reduces all of it to one
-- BIGINT, and this is the table that explains what was collapsed.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.identity_namespace (
    namespace_code      VARCHAR(30)  PRIMARY KEY,
    namespace_name      VARCHAR(80)  NOT NULL,
    -- Cross-device identities stitch behaviour across sessions; person
    -- identities assert a human. Confusing the two is how a shared household
    -- tablet becomes one fan.
    identity_type       VARCHAR(20)  NOT NULL
        CHECK (identity_type IN ('cookie', 'device', 'email', 'phone', 'crm', 'account', 'custom')),
    is_person_identity  BOOLEAN      NOT NULL,
    originating_system  VARCHAR(30),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

INSERT INTO adobe_aep.identity_namespace
    (namespace_code, namespace_name, identity_type, is_person_identity, originating_system)
VALUES
    ('ECID',        'Experience Cloud ID',       'cookie',  FALSE, 'adobe_aep'),
    ('AAID',        'Analytics tracking ID',     'cookie',  FALSE, 'adobe_aep'),
    ('IDFA',        'Apple advertising ID',      'device',  FALSE, NULL),
    ('GAID',        'Google advertising ID',     'device',  FALSE, NULL),
    ('Email',       'Email address',             'email',   TRUE,  NULL),
    ('Phone',       'Phone number',              'phone',   TRUE,  NULL),
    ('CRMID',       'Salesforce contact ID',     'crm',     TRUE,  'sfdc_crm'),
    ('TM_ACCOUNT',  'Ticketmaster account',      'account', TRUE,  'tm_axs'),
    ('ARCHTICS_ACCT','Archtics season account',  'account', TRUE,  'archtics'),
    ('SHOPIFY_CUST','Shopify customer ID',       'account', TRUE,  'shopify'),
    ('LOYALTY_NO',  'Loyalty membership number', 'account', TRUE,  'sfdc_crm');

COMMENT ON COLUMN adobe_aep.identity_namespace.is_person_identity IS
    'Whether the namespace asserts a human rather than a browser or device. '
    'Stitching on a non-person identity is how a shared household device '
    'merges two fans into one profile.';

-- -------------------------------------------------------------------------
-- Dataset. Where ingested data lands, and the unit of governance.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.dataset (
    dataset_id          VARCHAR(40)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    -- Record datasets hold profile attributes; time-series datasets hold
    -- experience events. The distinction governs retention and merge
    -- behaviour.
    schema_class        VARCHAR(20)  NOT NULL
        CHECK (schema_class IN ('record', 'time_series')),
    xdm_schema_ref      VARCHAR(200) NOT NULL,
    source_system_code  VARCHAR(20),
    enabled_for_profile BOOLEAN      NOT NULL DEFAULT FALSE,
    retention_days      INTEGER      CHECK (retention_days IS NULL OR retention_days > 0),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- Only a profile-enabled dataset contributes to the unified profile, and
    -- a time-series dataset must have a retention period.
    CONSTRAINT ck_dataset_timeseries_retention
        CHECK (schema_class <> 'time_series' OR retention_days IS NOT NULL)
);

-- -------------------------------------------------------------------------
-- Experience event type. The XDM eventType vocabulary.
-- Feeds the type dimension of target fan.engagement_event.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.event_type_ref (
    event_type          VARCHAR(60)  PRIMARY KEY,
    display_name        VARCHAR(120) NOT NULL,
    event_category      VARCHAR(30)  NOT NULL
        CHECK (event_category IN
            ('web', 'mobile', 'commerce', 'media', 'email', 'venue', 'loyalty', 'custom')),
    -- Whether the event is a conversion, which is what attribution counts.
    is_conversion       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

INSERT INTO adobe_aep.event_type_ref (event_type, display_name, event_category, is_conversion)
VALUES
    ('web.webpagedetails.pageViews', 'Page view',          'web',     FALSE),
    ('web.webinteraction.linkClicks','Link click',         'web',     FALSE),
    ('application.launch',           'App launch',         'mobile',  FALSE),
    ('commerce.productViews',        'Product view',       'commerce',FALSE),
    ('commerce.productListAdds',     'Add to cart',        'commerce',FALSE),
    ('commerce.checkouts',           'Checkout started',   'commerce',FALSE),
    ('commerce.purchases',           'Purchase',           'commerce',TRUE),
    ('media.sessionStart',           'Stream started',     'media',   FALSE),
    ('media.sessionComplete',        'Stream completed',   'media',   TRUE),
    ('directMarketing.emailOpened',  'Email opened',       'email',   FALSE),
    ('directMarketing.emailClicked', 'Email clicked',      'email',   FALSE),
    ('venue.gateEntry',              'Venue entry',        'venue',   TRUE),
    ('venue.concessionPurchase',     'Concession purchase','venue',   TRUE),
    ('loyalty.pointsEarned',         'Loyalty points earned','loyalty',FALSE),
    ('loyalty.rewardRedeemed',       'Loyalty reward redeemed','loyalty',TRUE);

-- -------------------------------------------------------------------------
-- Data use label and consent policy.
--
-- Together with dataset and privacy_job these are the ONLY named source for
-- target compliance.data_processing_record -- the single compliance table
-- that survives the scope boundary. Everything else in that domain needs a
-- GRC system, which is not among the ten.
-- -------------------------------------------------------------------------
CREATE TABLE adobe_aep.data_use_label (
    label_code          VARCHAR(20)  PRIMARY KEY,
    label_name          VARCHAR(80)  NOT NULL,
    label_category      VARCHAR(20)  NOT NULL
        CHECK (label_category IN ('contract', 'identity', 'sensitive')),
    description         TEXT         NOT NULL,
    -- The legal basis the label asserts, which is what a processing record
    -- has to state.
    lawful_basis        VARCHAR(30)
        CHECK (lawful_basis IS NULL OR lawful_basis IN
            ('consent', 'contract', 'legal_obligation', 'vital_interests',
             'public_task', 'legitimate_interests')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

INSERT INTO adobe_aep.data_use_label
    (label_code, label_name, label_category, description, lawful_basis)
VALUES
    ('C1',  'Cross-site data',      'contract',  'Data from other sites; restricted re-use', 'consent'),
    ('C2',  'Onsite advertising',   'contract',  'May not be used for onsite ad targeting', 'consent'),
    ('C4',  'Email targeting',      'contract',  'May not be used for email targeting', 'consent'),
    ('C8',  'Data science',         'contract',  'May not be used in data science models', 'legitimate_interests'),
    ('I1',  'Directly identifiable','identity',  'Directly identifies a person', NULL),
    ('I2',  'Indirectly identifiable','identity','Identifies when combined', NULL),
    ('S1',  'Special category',     'sensitive', 'GDPR Article 9 special category data', 'consent'),
    ('S2',  'Health data',          'sensitive', 'Health or accessibility information', 'consent'),
    ('S3',  'Precise geolocation',  'sensitive', 'Precise location data', 'consent');

CREATE TABLE adobe_aep.consent_policy (
    consent_policy_id   VARCHAR(40)  PRIMARY KEY,
    policy_name         VARCHAR(120) NOT NULL,
    -- Marketing actions are what a policy permits or denies: email, targeted
    -- advertising, personalisation, analytics.
    marketing_action    VARCHAR(40)  NOT NULL,
    policy_status       VARCHAR(20)  NOT NULL DEFAULT 'draft'
        CHECK (policy_status IN ('draft', 'enabled', 'disabled')),
    -- Jurisdiction, because consent requirements differ: GDPR opt-in versus
    -- CCPA opt-out are genuinely different defaults.
    jurisdiction        VARCHAR(20)
        CHECK (jurisdiction IS NULL OR jurisdiction IN ('GDPR', 'CCPA', 'CPRA', 'LGPD', 'PIPEDA', 'GLOBAL')),
    default_state       VARCHAR(10)  NOT NULL DEFAULT 'deny'
        CHECK (default_state IN ('allow', 'deny')),
    denied_label_codes  TEXT[],
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN adobe_aep.consent_policy.default_state IS
    'GDPR requires opt-in (default deny); CCPA permits opt-out (default '
    'allow). The target fan.consent_preference carries a boolean, which cannot '
    'express the difference between "not asked" and "declined".';
