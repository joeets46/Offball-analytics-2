-- =========================================================================
-- sap_sfsf -- foundation objects, person and employment
--
-- TIER B: representative column sets.
--
-- Read the effective dating carefully. `emp_employment`, `emp_job` and
-- `emp_compensation` are all keyed on (user_id, effective_start_date), so one
-- employee has many rows and only one of them is current. Target
-- athlete.roster and athlete.contract each keep a single row, so every
-- extract from this schema has to pick the window in force -- and an extract
-- that does not will multiply the roster by the number of job changes.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Foundation objects: the org structure SuccessFactors hangs jobs from.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.fo_company (
    company_code        VARCHAR(20)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    country_code        common.dom_iso3_code NOT NULL,
    currency_code       common.dom_iso3_code NOT NULL,
    -- Business key to the SAP company code, which is the same legal entity.
    sap_bukrs           CHAR(4),
    effective_start_date DATE        NOT NULL DEFAULT CURRENT_DATE,
    status              VARCHAR(10)  NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE sap_sfsf.fo_department (
    department_code     VARCHAR(20)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    company_code        VARCHAR(20)  NOT NULL,
    parent_department_code VARCHAR(20),
    -- Departments carry the squad or function: first team, academy,
    -- commercial, venue operations.
    function_type       VARCHAR(30)
        CHECK (function_type IS NULL OR function_type IN
            ('playing_squad', 'coaching', 'medical', 'performance', 'academy',
             'commercial', 'venue_operations', 'media', 'administration', 'security')),
    effective_start_date DATE        NOT NULL DEFAULT CURRENT_DATE,
    status              VARCHAR(10)  NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_fo_department_not_self_parent
        CHECK (parent_department_code IS NULL OR parent_department_code <> department_code)
);

CREATE TABLE sap_sfsf.fo_cost_center (
    cost_center_code    VARCHAR(20)  PRIMARY KEY,
    name                VARCHAR(160) NOT NULL,
    company_code        VARCHAR(20)  NOT NULL,
    -- Business key into SAP controlling, which is the authoritative cost centre.
    sap_kostl           CHAR(10),
    effective_start_date DATE        NOT NULL DEFAULT CURRENT_DATE,
    status              VARCHAR(10)  NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE sap_sfsf.fo_pay_grade (
    pay_grade_code      VARCHAR(20)  PRIMARY KEY,
    name                VARCHAR(80)  NOT NULL,
    min_amount          NUMERIC(18,2) CHECK (min_amount IS NULL OR min_amount >= 0),
    max_amount          NUMERIC(18,2) CHECK (max_amount IS NULL OR max_amount >= 0),
    currency_code       common.dom_iso3_code,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_pay_grade_range CHECK (max_amount IS NULL OR min_amount IS NULL OR max_amount >= min_amount)
);

-- -------------------------------------------------------------------------
-- Position. The seat, which exists whether or not anyone occupies it.
-- Feeds target venue.staff_plan and contributes to target
-- event.officiating_assignment.
--
-- A vacant position is the whole point of workforce planning: "we need
-- fourteen stewards for this fixture" is a statement about positions, not
-- about people.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.position (
    position_code       VARCHAR(30)  PRIMARY KEY,
    title               VARCHAR(160) NOT NULL,
    company_code        VARCHAR(20)  NOT NULL,
    department_code     VARCHAR(20),
    cost_center_code    VARCHAR(20),
    pay_grade_code      VARCHAR(20),
    parent_position_code VARCHAR(30),
    -- FTE allows a part-time or matchday-only position, which is most venue
    -- staffing.
    fte                 NUMERIC(5,4) NOT NULL DEFAULT 1.0
        CHECK (fte > 0 AND fte <= 1),
    is_vacant           BOOLEAN      NOT NULL DEFAULT TRUE,
    -- Matchday positions are staffed per event rather than continuously.
    is_matchday_only    BOOLEAN      NOT NULL DEFAULT FALSE,
    position_category   VARCHAR(30)
        CHECK (position_category IS NULL OR position_category IN
            ('athlete', 'coach', 'medical', 'official', 'steward', 'security',
             'hospitality', 'retail', 'production', 'administration')),
    effective_start_date DATE        NOT NULL DEFAULT CURRENT_DATE,
    status              VARCHAR(10)  NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_position_not_self_parent
        CHECK (parent_position_code IS NULL OR parent_position_code <> position_code)
);

COMMENT ON COLUMN sap_sfsf.position.is_vacant IS
    'A vacant position is the unit of workforce planning: "fourteen stewards '
    'needed for this fixture" is a statement about positions, not people. '
    'Target venue.staff_plan is built from these.';

-- -------------------------------------------------------------------------
-- Person. The human being. Feeds target athlete.athlete_profile.
--
-- Split across per_person (the immutable identity) and per_personal (the
-- effective-dated attributes that change, like legal name). That split is
-- SuccessFactors' and it matters: a name change is a new per_personal row,
-- not an update.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.per_person (
    person_id_external  VARCHAR(40)  PRIMARY KEY,
    -- Date of birth lives on the immutable record because it does not change.
    date_of_birth       DATE,
    country_of_birth    common.dom_iso3_code,
    -- Nationality governs work eligibility and, in many competitions, squad
    -- registration limits -- so it is a competition-rules field, not just an
    -- HR one.
    primary_nationality common.dom_iso3_code,
    secondary_nationality common.dom_iso3_code,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_per_person_dob_past
        CHECK (date_of_birth IS NULL OR date_of_birth < CURRENT_DATE),
    CONSTRAINT ck_per_person_nationalities_differ
        CHECK (secondary_nationality IS NULL
               OR primary_nationality IS NULL
               OR secondary_nationality <> primary_nationality)
);

COMMENT ON COLUMN sap_sfsf.per_person.primary_nationality IS
    'Governs work eligibility and, in most competitions, squad registration '
    'limits on non-domestic players. A competition-rules field as much as an '
    'HR one.';

-- -------------------------------------------------------------------------
-- Personal information. Effective-dated, because legal names change.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.per_personal (
    person_id_external  VARCHAR(40)  NOT NULL,
    effective_start_date DATE        NOT NULL,
    first_name          VARCHAR(80),
    last_name           VARCHAR(80)  NOT NULL,
    middle_name         VARCHAR(80),
    preferred_name      VARCHAR(80),
    gender              VARCHAR(10)
        CHECK (gender IS NULL OR gender IN ('M', 'F', 'O', 'U')),
    marital_status      VARCHAR(20),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (person_id_external, effective_start_date)
);

COMMENT ON TABLE sap_sfsf.per_personal IS
    'Effective-dated. A legal name change creates a new row rather than '
    'updating the old one, so the extract must select the window in force or '
    'it returns one row per historical name.';

CREATE TABLE sap_sfsf.per_email (
    person_id_external  VARCHAR(40)  NOT NULL,
    email_type          VARCHAR(20)  NOT NULL
        CHECK (email_type IN ('business', 'personal', 'other')),
    email_address       common.dom_email NOT NULL,
    is_primary          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (person_id_external, email_type)
);

CREATE TABLE sap_sfsf.per_phone (
    person_id_external  VARCHAR(40)  NOT NULL,
    phone_type          VARCHAR(20)  NOT NULL
        CHECK (phone_type IN ('business', 'home', 'cell', 'emergency', 'other')),
    phone_number        VARCHAR(40)  NOT NULL,
    is_primary          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (person_id_external, phone_type)
);

CREATE TABLE sap_sfsf.per_address (
    person_id_external  VARCHAR(40)  NOT NULL,
    address_type        VARCHAR(20)  NOT NULL
        CHECK (address_type IN ('home', 'mailing', 'temporary', 'other')),
    effective_start_date DATE        NOT NULL,
    address_line_1      VARCHAR(160),
    address_line_2      VARCHAR(160),
    city                VARCHAR(80),
    state_province      common.dom_state_province,
    postal_code         VARCHAR(20),
    country_code        common.dom_iso3_code,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (person_id_external, address_type, effective_start_date)
);
