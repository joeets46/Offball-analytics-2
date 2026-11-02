-- =========================================================================
-- sap_sfsf -- employment, compensation, leave and recruiting
--
-- TIER B: representative column sets.
--
-- Everything here is effective-dated. Three target tables --
-- athlete.roster, athlete.eligibility_status and athlete.suspension_record --
-- are all derived from these rows by selecting the window in force, which is
-- why two of those three mappings carry `low` confidence: the derivation is
-- real but the fit is approximate.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Employment. A person's engagement with the organisation.
--
-- A person can hold several over a career -- a player who retires and returns
-- as a coach is one person with two employments. Treating them as two people
-- loses the career, and treating the employments as one loses the transition.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.emp_employment (
    user_id             VARCHAR(40)  PRIMARY KEY,
    person_id_external  VARCHAR(40)  NOT NULL,
    hire_date           DATE         NOT NULL,
    termination_date    DATE,
    employment_status   VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (employment_status IN ('active', 'inactive', 'terminated',
                                     'suspended', 'leave_of_absence', 'retired')),
    -- Rehire marks a returning person, which is what preserves the career
    -- across two employments.
    is_rehire           BOOLEAN      NOT NULL DEFAULT FALSE,
    previous_user_id    VARCHAR(40),
    termination_reason  VARCHAR(40),
    is_regular          BOOLEAN      NOT NULL DEFAULT TRUE,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_employment_dates
        CHECK (termination_date IS NULL OR termination_date >= hire_date),
    CONSTRAINT ck_employment_terminated_pair
        CHECK ((employment_status = 'terminated') = (termination_date IS NOT NULL)),
    CONSTRAINT ck_employment_terminated_has_reason
        CHECK (employment_status <> 'terminated' OR termination_reason IS NOT NULL),
    CONSTRAINT ck_employment_rehire_reference
        CHECK (NOT is_rehire OR previous_user_id IS NOT NULL),
    CONSTRAINT ck_employment_not_self_previous
        CHECK (previous_user_id IS NULL OR previous_user_id <> user_id)
);

COMMENT ON COLUMN sap_sfsf.emp_employment.previous_user_id IS
    'The earlier employment of the same person. A player returning as a coach '
    'is one person with two employments, and this link is what keeps the '
    'career continuous.';

-- -------------------------------------------------------------------------
-- Job assignment. Effective-dated: the current job is the latest row whose
-- window contains today.
--
-- Feeds target athlete.roster and target venue.staff_plan.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.emp_job (
    user_id             VARCHAR(40)  NOT NULL,
    effective_start_date DATE        NOT NULL,
    position_code       VARCHAR(30),
    department_code     VARCHAR(20),
    cost_center_code    VARCHAR(20),
    company_code        VARCHAR(20)  NOT NULL,
    manager_user_id     VARCHAR(40),
    job_title           VARCHAR(160),
    employment_type     VARCHAR(20)  NOT NULL DEFAULT 'permanent'
        CHECK (employment_type IN ('permanent', 'fixed_term', 'casual',
                                   'matchday', 'loan', 'trial', 'contractor')),
    fte                 NUMERIC(5,4) NOT NULL DEFAULT 1.0 CHECK (fte > 0 AND fte <= 1),
    -- The event that caused this row. This is what distinguishes a promotion
    -- from a transfer from a loan return, and the target model keeps none of it.
    event_reason        VARCHAR(40)
        CHECK (event_reason IS NULL OR event_reason IN
            ('hire', 'rehire', 'promotion', 'transfer', 'loan_out', 'loan_return',
             'contract_extension', 'demotion', 'reorganisation', 'data_correction')),
    -- Squad registration: whether this assignment counts against a
    -- competition's squad limit.
    is_squad_registered BOOLEAN      NOT NULL DEFAULT FALSE,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (user_id, effective_start_date),
    CONSTRAINT ck_emp_job_not_self_manager
        CHECK (manager_user_id IS NULL OR manager_user_id <> user_id)
);

COMMENT ON COLUMN sap_sfsf.emp_job.event_reason IS
    'Why this effective-dated row exists. Distinguishes a promotion from a '
    'transfer from a loan return; target athlete.roster keeps none of it, so '
    'the reason for every squad change is lost downstream.';

-- -------------------------------------------------------------------------
-- Compensation and pay components. Effective-dated.
--
-- Contributes to target athlete.contract alongside sap_s4.veda. SAP carries
-- the contract document; this carries what is actually paid, and the two
-- disagree more often than anyone would like.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.emp_compensation (
    user_id             VARCHAR(40)  NOT NULL,
    effective_start_date DATE        NOT NULL,
    pay_grade_code      VARCHAR(20),
    -- Annualised base. Restricted data by any standard, and the upstream
    -- model tags its equivalents confidential.
    annual_salary       NUMERIC(18,2) CHECK (annual_salary IS NULL OR annual_salary >= 0),
    currency_code       common.dom_iso3_code,
    pay_frequency       VARCHAR(20)
        CHECK (pay_frequency IS NULL OR pay_frequency IN
            ('annual', 'monthly', 'semi_monthly', 'biweekly', 'weekly', 'per_appearance')),
    -- Business key to the SAP contract that governs the terms.
    sap_contract_vbeln  CHAR(10),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (user_id, effective_start_date),
    CONSTRAINT ck_compensation_currency_pair
        CHECK ((annual_salary IS NULL) = (currency_code IS NULL))
);

CREATE TABLE sap_sfsf.emp_pay_component (
    user_id             VARCHAR(40)  NOT NULL,
    effective_start_date DATE        NOT NULL,
    pay_component_code  VARCHAR(30)  NOT NULL,
    -- Sports compensation is mostly components rather than base salary:
    -- appearance fees, goal bonuses, image rights, signing-on fees. The
    -- target athlete.contract has a single value column, so the structure --
    -- which is where the negotiation happened -- is lost.
    component_type      VARCHAR(30)  NOT NULL
        CHECK (component_type IN ('base', 'signing_bonus', 'appearance_fee',
                                  'performance_bonus', 'loyalty_bonus', 'image_rights',
                                  'relocation', 'accommodation', 'vehicle', 'other')),
    amount              NUMERIC(18,2) NOT NULL CHECK (amount >= 0),
    currency_code       common.dom_iso3_code NOT NULL,
    -- Conditional components only pay on a trigger -- 25 appearances, a cup
    -- final, a clean sheet.
    is_conditional      BOOLEAN      NOT NULL DEFAULT FALSE,
    condition_note      TEXT,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    PRIMARY KEY (user_id, effective_start_date, pay_component_code),
    CONSTRAINT ck_pay_component_condition
        CHECK (is_conditional = (condition_note IS NOT NULL))
);

COMMENT ON TABLE sap_sfsf.emp_pay_component IS
    'Where athlete compensation actually lives: appearance fees, bonuses, '
    'image rights. Target athlete.contract carries one value, so the '
    'component structure -- the substance of the deal -- does not survive.';

-- -------------------------------------------------------------------------
-- Time off. Feeds target athlete.suspension_record, at low confidence.
--
-- A suspension appears here as unpaid leave, which is how HR records it. The
-- disciplinary decision that caused it lives in a league system that is out
-- of scope, so the extract can see the absence but not the reason.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.emp_time_off (
    time_off_id         VARCHAR(40)  PRIMARY KEY,
    user_id             VARCHAR(40)  NOT NULL,
    time_type           VARCHAR(30)  NOT NULL
        CHECK (time_type IN ('annual_leave', 'sick_leave', 'unpaid_leave',
                             'suspension', 'international_duty', 'compassionate',
                             'parental', 'injury_leave')),
    start_date          DATE         NOT NULL,
    end_date            DATE         NOT NULL,
    quantity_days       NUMERIC(6,2) CHECK (quantity_days IS NULL OR quantity_days >= 0),
    approval_status     VARCHAR(20)  NOT NULL DEFAULT 'pending'
        CHECK (approval_status IN ('pending', 'approved', 'rejected', 'cancelled')),
    -- Deliberately free text and nullable: the disciplinary origin of a
    -- suspension is not in this system.
    comment             TEXT,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_time_off_dates CHECK (end_date >= start_date)
);

COMMENT ON TABLE sap_sfsf.emp_time_off IS
    'A suspension is recorded here as leave, which is what HR sees. The '
    'disciplinary decision behind it belongs to league.disciplinary_action, '
    'which is out of scope -- so target athlete.suspension_record can show '
    'the absence but not the reason, and that mapping is low confidence.';

-- -------------------------------------------------------------------------
-- Recruiting. Feeds target athlete.draft_selection, at low confidence.
--
-- A draft is modeled as a requisition and applications, which captures the
-- selection but not the pick order or the trade of picks -- those belong to
-- the league transaction system, which is out of scope.
-- -------------------------------------------------------------------------
CREATE TABLE sap_sfsf.job_requisition (
    job_req_id          VARCHAR(40)  PRIMARY KEY,
    title               VARCHAR(160) NOT NULL,
    position_code       VARCHAR(30),
    department_code     VARCHAR(20),
    company_code        VARCHAR(20)  NOT NULL,
    -- Recruiting type separates ordinary hiring from a draft or a trial.
    recruiting_type     VARCHAR(20)  NOT NULL DEFAULT 'standard'
        CHECK (recruiting_type IN ('standard', 'draft', 'trial', 'academy_intake', 'scouting')),
    requisition_status  VARCHAR(20)  NOT NULL DEFAULT 'open'
        CHECK (requisition_status IN ('draft', 'open', 'on_hold', 'filled', 'cancelled')),
    openings            SMALLINT     NOT NULL DEFAULT 1 CHECK (openings > 0),
    target_start_date   DATE,
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE sap_sfsf.candidate (
    candidate_id        VARCHAR(40)  PRIMARY KEY,
    first_name          VARCHAR(80),
    last_name           VARCHAR(80)  NOT NULL,
    email               common.dom_email,
    phone               VARCHAR(40),
    date_of_birth       DATE,
    nationality         common.dom_iso3_code,
    -- Set once the candidate becomes a person in the system.
    person_id_external  VARCHAR(40),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_candidate_dob_past
        CHECK (date_of_birth IS NULL OR date_of_birth < CURRENT_DATE)
);

CREATE TABLE sap_sfsf.job_application (
    application_id      VARCHAR(40)  PRIMARY KEY,
    job_req_id          VARCHAR(40)  NOT NULL,
    candidate_id        VARCHAR(40)  NOT NULL,
    application_status  VARCHAR(30)  NOT NULL DEFAULT 'new'
        CHECK (application_status IN ('new', 'screening', 'interview', 'trial',
                                      'offer', 'hired', 'rejected', 'withdrawn')),
    -- Selection order within a requisition. For a draft this is the pick
    -- number, which is the closest this system gets to representing a draft.
    selection_order     SMALLINT     CHECK (selection_order IS NULL OR selection_order > 0),
    applied_on          DATE         NOT NULL,
    decided_on          DATE,
    rejection_reason    VARCHAR(40),
    created_on          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_modified_on    TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (job_req_id, candidate_id),
    CONSTRAINT ck_application_dates
        CHECK (decided_on IS NULL OR decided_on >= applied_on),
    CONSTRAINT ck_application_rejected_has_reason
        CHECK ((application_status = 'rejected') = (rejection_reason IS NOT NULL))
);

COMMENT ON COLUMN sap_sfsf.job_application.selection_order IS
    'Pick number, for a draft-type requisition. The closest a recruiting '
    'module gets to a draft -- it cannot represent traded picks or '
    'compensatory selections, which is why target athlete.draft_selection is '
    'mapped at low confidence.';
