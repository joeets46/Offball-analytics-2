-- =========================================================================
-- tm_axs -- PII satellites
--
-- The upstream model tags 281 in-scope columns with a `pii_*` subtype and 665
-- as confidential or restricted, spread across 66 tables. Carrying those
-- columns inline on the master records -- which is what the target model does,
-- because an analytical model has no reason not to -- would mean every
-- operational ticketing query reads restricted data.
--
-- So identifying attributes are split out one-to-one from their parent. The
-- parent carries the keys and the commercial state; the satellite carries the
-- person. That buys three things a single wide table cannot:
--
--   * Grants. REVOKE on the satellite leaves the parent fully usable, so the
--     reporting and operations roles never hold PII.
--   * A single place to encrypt, should column encryption be introduced.
--   * A tractable GDPR/CCPA erasure target: a DSAR delete is one row per
--     satellite rather than a column-level update across the schema.
--
-- The split is reversed on the way into the lakehouse: the mapping rejoins
-- parent and satellite, which is why these appear as `join` transforms in
-- mapping/table_level_mapping.csv.
-- =========================================================================

CREATE TABLE tm_axs.customer_account_pii (
    -- Shares the parent key: this is a one-to-one extension, not a child.
    customer_account_id BIGINT       PRIMARY KEY,

    given_name          VARCHAR(80)  NOT NULL,
    family_name         VARCHAR(80)  NOT NULL,
    middle_name         VARCHAR(80),
    name_prefix         VARCHAR(20),
    name_suffix         VARCHAR(20),

    date_of_birth       DATE,
    -- Age gating for alcohol service and some wagering jurisdictions; a future
    -- date of birth is always a data entry error.
    CONSTRAINT ck_customer_pii_dob_past CHECK (date_of_birth IS NULL OR date_of_birth < CURRENT_DATE),

    mobile_phone        VARCHAR(32),
    alternate_phone     VARCHAR(32),

    address_line_1      VARCHAR(160),
    address_line_2      VARCHAR(160),
    city                VARCHAR(80),
    state_province      common.dom_state_province,
    postal_code         VARCHAR(20),
    country_code        common.dom_iso3_code,

    -- Accessibility needs are health-adjacent and attract the strictest
    -- handling of anything in this schema.
    ada_requirement_note TEXT,

    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE tm_axs.customer_account_pii IS
    'One-to-one PII satellite of tm_axs.customer_account. Separate grants; '
    'the DSAR erasure target for this system. Rejoined on load into target '
    'fan.fan_profile and fan.account.';
COMMENT ON COLUMN tm_axs.customer_account_pii.ada_requirement_note IS
    'Health-adjacent free text (pii_health in the upstream tagging). Should '
    'not propagate to the lakehouse without an explicit lawful basis.';

CREATE TABLE tm_axs.credential_pii (
    credential_id       BIGINT       PRIMARY KEY,

    date_of_birth       DATE,
    -- Government identifier reference, not the identifier itself: the document
    -- is verified at accreditation and only the check result is retained.
    government_id_type  VARCHAR(20)
        CHECK (government_id_type IS NULL OR government_id_type IN
            ('passport','national_id','drivers_licence','residence_permit','other')),
    government_id_last_four common.dom_card_last_four,
    government_id_country common.dom_iso3_code,

    personal_email      common.dom_email,
    personal_phone      VARCHAR(32),
    emergency_contact_name  VARCHAR(160),
    emergency_contact_phone VARCHAR(32),

    -- Biometric template reference. The template lives in the access-control
    -- appliance; this is the handle, so the appliance stays the only system
    -- holding biometrics.
    biometric_template_ref VARCHAR(80),

    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_credential_pii_dob_past
        CHECK (date_of_birth IS NULL OR date_of_birth < CURRENT_DATE),
    -- Document fragments only make sense alongside a document type.
    CONSTRAINT ck_credential_pii_id_fields
        CHECK (government_id_type IS NOT NULL
               OR (government_id_last_four IS NULL AND government_id_country IS NULL))
);

COMMENT ON COLUMN tm_axs.credential_pii.biometric_template_ref IS
    'Opaque handle to a template held in the access-control appliance. '
    'Biometric data itself is deliberately not stored in this tier.';
