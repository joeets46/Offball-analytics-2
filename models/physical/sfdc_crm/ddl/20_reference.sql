-- =========================================================================
-- sfdc_crm -- platform configuration
--
-- Record types and users. Both are referenced by nearly every object, and
-- record type in particular is load-bearing for this model: four different
-- target tables are the same `account` rows separated only by record type.
-- =========================================================================

-- -------------------------------------------------------------------------
-- RecordType. The mechanism that lets one object serve several business
-- entities.
--
-- This single table is why the mapping can send sfdc_crm.account to four
-- different target tables without guessing: sponsorship.sponsor,
-- athlete.agency, broadcast.rights_holder and broadcast.licensee are all
-- Accounts with different record types.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.record_type (
    id                  CHAR(18)     PRIMARY KEY,
    name                VARCHAR(80)  NOT NULL,
    developer_name      VARCHAR(80)  NOT NULL,
    sobject_type        VARCHAR(40)  NOT NULL,
    description         VARCHAR(255),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (sobject_type, developer_name)
);

INSERT INTO sfdc_crm.record_type (id, name, developer_name, sobject_type, description)
VALUES
    ('012000000000001AAA', 'Fan',             'Fan',           'Account',     'Individual supporter household'),
    ('012000000000002AAA', 'Sponsor',         'Sponsor',       'Account',     'Commercial partner -- target sponsorship.sponsor'),
    ('012000000000003AAA', 'Agency',          'Agency',        'Account',     'Athlete representation -- target athlete.agency'),
    ('012000000000004AAA', 'Rights Holder',   'RightsHolder',  'Account',     'Media rights counterparty -- target broadcast.rights_holder'),
    ('012000000000005AAA', 'Licensee',        'Licensee',      'Account',     'Sub-licensee -- target broadcast.licensee'),
    ('012000000000006AAA', 'Supplier',        'Supplier',      'Account',     'Merchandise supplier'),
    ('012000000000011AAA', 'Fan Contact',     'FanContact',    'Contact',     'Individual fan'),
    ('012000000000012AAA', 'Agent',           'Agent',         'Contact',     'Athlete agent -- target athlete.agent'),
    ('012000000000013AAA', 'Sponsor Contact', 'SponsorContact','Contact',     'Commercial contact at a sponsor'),
    ('012000000000021AAA', 'Sponsorship',     'Sponsorship',   'Opportunity', 'Sponsorship deal -- target sponsorship.deal'),
    ('012000000000022AAA', 'Media Rights',    'MediaRights',   'Opportunity', 'Rights deal -- target broadcast.media_rights_deal'),
    ('012000000000031AAA', 'Sponsorship',     'Sponsorship',   'Contract',    'Executed sponsorship contract'),
    ('012000000000032AAA', 'Media Rights',    'MediaRights',   'Contract',    'Executed media rights contract'),
    ('012000000000033AAA', 'Loyalty',         'Loyalty',       'Contract',    'Loyalty enrolment -- target fan.loyalty_enrollment'),
    ('012000000000034AAA', 'Subscription',    'Subscription',  'Contract',    'Streaming subscription'),
    ('012000000000035AAA', 'Naming Right',    'NamingRight',   'Contract',    'Venue naming rights');

COMMENT ON TABLE sfdc_crm.record_type IS
    'The seed rows are not illustrative -- the mapping depends on them. Four '
    'target tables are sfdc_crm.account filtered by record_type_id.';

-- -------------------------------------------------------------------------
-- User. Owner of every record, and the actor in every audit column.
-- -------------------------------------------------------------------------
CREATE TABLE sfdc_crm.sf_user (
    id                  CHAR(18)     PRIMARY KEY,
    username            common.dom_email NOT NULL UNIQUE,
    name                VARCHAR(121) NOT NULL,
    email               common.dom_email NOT NULL,
    user_role_name      VARCHAR(80),
    profile_name        VARCHAR(80)  NOT NULL,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN sfdc_crm.sf_user.name IS
    'VARCHAR(121) -- Salesforce computes Name as FirstName + space + LastName '
    'at 40 and 80 characters respectively. The odd width is the platform''s, '
    'not a typo.';
