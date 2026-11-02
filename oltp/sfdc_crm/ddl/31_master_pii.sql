-- =========================================================================
-- sfdc_crm -- PII satellite
--
-- Same reasoning as tm_axs/31_master_pii.sql: the identifying attributes of a
-- Contact are split one-to-one from the record so the analyst role can read
-- the relationship without reading the person.
--
-- Salesforce itself does not work this way -- Contact is one wide object, and
-- its field-level security is how a real org restricts these columns. The
-- split here is the normalized equivalent, and it is the shape the target
-- model has to undo on load.
-- =========================================================================

CREATE TABLE sfdc_crm.contact_pii (
    contact_id          CHAR(18)     PRIMARY KEY,

    email               common.dom_email,
    phone               VARCHAR(40),
    mobile_phone        VARCHAR(40),
    home_phone          VARCHAR(40),

    mailing_street      VARCHAR(255),
    mailing_city        VARCHAR(40),
    mailing_state       VARCHAR(80),
    mailing_postal_code VARCHAR(20),
    mailing_country     VARCHAR(80),

    birthdate           DATE,

    -- Marketing-derived attributes. Inferred rather than declared, and the
    -- upstream model tags its equivalents confidential.
    household_income_band__c VARCHAR(20)
        CHECK (household_income_band__c IS NULL OR household_income_band__c IN
            ('under_25k', '25k_50k', '50k_75k', '75k_100k', '100k_150k', 'over_150k', 'undisclosed')),
    preferred_language__c common.dom_language_code,

    created_date        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_date  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    system_modstamp     TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_contact_pii_birthdate_past
        CHECK (birthdate IS NULL OR birthdate < CURRENT_DATE)
);

COMMENT ON TABLE sfdc_crm.contact_pii IS
    'One-to-one PII satellite of sfdc_crm.contact. In a real org these are '
    'Contact fields restricted by field-level security; this is the normalized '
    'equivalent, and target fan.fan_profile rejoins them.';
COMMENT ON COLUMN sfdc_crm.contact_pii.household_income_band__c IS
    'Inferred from third-party marketing data, not declared by the fan. Worth '
    'treating more carefully than declared attributes, not less.';
