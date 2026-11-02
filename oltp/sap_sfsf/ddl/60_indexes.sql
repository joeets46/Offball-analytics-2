-- =========================================================================
-- sap_sfsf -- indexes
--
-- Effective-dated tables are read one way above all others: the row in force
-- on a given date for a given person. That is (key, effective_start_date
-- DESC), and it is the shape of nearly every index here.
-- =========================================================================

CREATE INDEX ix_fo_department_company   ON sap_sfsf.fo_department (company_code);
CREATE INDEX ix_fo_department_parent    ON sap_sfsf.fo_department (parent_department_code)
    WHERE parent_department_code IS NOT NULL;
CREATE INDEX ix_fo_department_function  ON sap_sfsf.fo_department (function_type)
    WHERE function_type IS NOT NULL;
CREATE INDEX ix_fo_cost_center_company  ON sap_sfsf.fo_cost_center (company_code);
CREATE INDEX ix_fo_cost_center_sap      ON sap_sfsf.fo_cost_center (sap_kostl)
    WHERE sap_kostl IS NOT NULL;
CREATE INDEX ix_fo_company_sap          ON sap_sfsf.fo_company (sap_bukrs)
    WHERE sap_bukrs IS NOT NULL;

CREATE INDEX ix_position_company        ON sap_sfsf.position (company_code);
CREATE INDEX ix_position_department     ON sap_sfsf.position (department_code)
    WHERE department_code IS NOT NULL;
CREATE INDEX ix_position_cost_center    ON sap_sfsf.position (cost_center_code)
    WHERE cost_center_code IS NOT NULL;
CREATE INDEX ix_position_pay_grade      ON sap_sfsf.position (pay_grade_code)
    WHERE pay_grade_code IS NOT NULL;
CREATE INDEX ix_position_parent         ON sap_sfsf.position (parent_position_code)
    WHERE parent_position_code IS NOT NULL;
-- Vacancies, which is what workforce planning actually reads.
CREATE INDEX ix_position_vacant         ON sap_sfsf.position (department_code, position_category)
    WHERE is_vacant AND status = 'A';
-- Matchday staffing requirements.
CREATE INDEX ix_position_matchday       ON sap_sfsf.position (position_category)
    WHERE is_matchday_only AND status = 'A';

-- -------------------------------------------------------------------------
-- Person lookup.
-- -------------------------------------------------------------------------
CREATE INDEX ix_per_person_dob          ON sap_sfsf.per_person (date_of_birth)
    WHERE date_of_birth IS NOT NULL;
CREATE INDEX ix_per_person_nationality  ON sap_sfsf.per_person (primary_nationality)
    WHERE primary_nationality IS NOT NULL;
-- The current-name lookup: latest effective row per person.
CREATE INDEX ix_per_personal_current
    ON sap_sfsf.per_personal (person_id_external, effective_start_date DESC);
CREATE INDEX ix_per_personal_name       ON sap_sfsf.per_personal (last_name, first_name);
CREATE INDEX ix_per_email_address       ON sap_sfsf.per_email (email_address);
CREATE INDEX ix_per_address_current
    ON sap_sfsf.per_address (person_id_external, effective_start_date DESC);

-- -------------------------------------------------------------------------
-- Employment.
-- -------------------------------------------------------------------------
CREATE INDEX ix_emp_employment_person   ON sap_sfsf.emp_employment (person_id_external);
CREATE INDEX ix_emp_employment_previous ON sap_sfsf.emp_employment (previous_user_id)
    WHERE previous_user_id IS NOT NULL;
CREATE INDEX ix_emp_employment_active   ON sap_sfsf.emp_employment (hire_date)
    WHERE employment_status = 'active';

-- The effective-dated read: current job per person.
CREATE INDEX ix_emp_job_current         ON sap_sfsf.emp_job (user_id, effective_start_date DESC);
CREATE INDEX ix_emp_job_position        ON sap_sfsf.emp_job (position_code)
    WHERE position_code IS NOT NULL;
CREATE INDEX ix_emp_job_department      ON sap_sfsf.emp_job (department_code)
    WHERE department_code IS NOT NULL;
CREATE INDEX ix_emp_job_cost_center     ON sap_sfsf.emp_job (cost_center_code)
    WHERE cost_center_code IS NOT NULL;
CREATE INDEX ix_emp_job_company         ON sap_sfsf.emp_job (company_code);
CREATE INDEX ix_emp_job_manager         ON sap_sfsf.emp_job (manager_user_id)
    WHERE manager_user_id IS NOT NULL;
-- Squad registration, which carries competition limits.
CREATE INDEX ix_emp_job_squad
    ON sap_sfsf.emp_job (company_code, effective_start_date DESC)
    WHERE is_squad_registered;

CREATE INDEX ix_emp_compensation_current
    ON sap_sfsf.emp_compensation (user_id, effective_start_date DESC);
CREATE INDEX ix_emp_compensation_pay_grade
    ON sap_sfsf.emp_compensation (pay_grade_code) WHERE pay_grade_code IS NOT NULL;
CREATE INDEX ix_emp_compensation_sap
    ON sap_sfsf.emp_compensation (sap_contract_vbeln) WHERE sap_contract_vbeln IS NOT NULL;
CREATE INDEX ix_emp_pay_component_type  ON sap_sfsf.emp_pay_component (component_type);
-- Conditional components, which have to be evaluated against performance.
CREATE INDEX ix_emp_pay_component_conditional
    ON sap_sfsf.emp_pay_component (user_id) WHERE is_conditional;

CREATE INDEX ix_emp_time_off_user       ON sap_sfsf.emp_time_off (user_id, start_date DESC);
-- Suspensions, which target athlete.suspension_record is derived from.
CREATE INDEX ix_emp_time_off_suspension ON sap_sfsf.emp_time_off (start_date, end_date)
    WHERE time_type = 'suspension';
-- Current absences: the availability question.
CREATE INDEX ix_emp_time_off_current    ON sap_sfsf.emp_time_off (user_id, end_date)
    WHERE approval_status = 'approved';

-- -------------------------------------------------------------------------
-- Recruiting.
-- -------------------------------------------------------------------------
CREATE INDEX ix_job_req_position        ON sap_sfsf.job_requisition (position_code)
    WHERE position_code IS NOT NULL;
CREATE INDEX ix_job_req_department      ON sap_sfsf.job_requisition (department_code)
    WHERE department_code IS NOT NULL;
CREATE INDEX ix_job_req_company         ON sap_sfsf.job_requisition (company_code);
CREATE INDEX ix_job_req_open
    ON sap_sfsf.job_requisition (recruiting_type, target_start_date)
    WHERE requisition_status = 'open';
CREATE INDEX ix_candidate_email         ON sap_sfsf.candidate (email) WHERE email IS NOT NULL;
CREATE INDEX ix_candidate_person        ON sap_sfsf.candidate (person_id_external)
    WHERE person_id_external IS NOT NULL;
CREATE INDEX ix_job_application_req     ON sap_sfsf.job_application (job_req_id, selection_order);
CREATE INDEX ix_job_application_candidate ON sap_sfsf.job_application (candidate_id);
CREATE INDEX ix_job_application_open    ON sap_sfsf.job_application (applied_on)
    WHERE application_status NOT IN ('hired', 'rejected', 'withdrawn');

-- -------------------------------------------------------------------------
-- Extraction watermarks. The column is last_modified_on, not updated_at.
-- -------------------------------------------------------------------------
CREATE INDEX ix_per_person_modified     ON sap_sfsf.per_person (last_modified_on);
CREATE INDEX ix_per_personal_modified   ON sap_sfsf.per_personal (last_modified_on);
CREATE INDEX ix_emp_employment_modified ON sap_sfsf.emp_employment (last_modified_on);
CREATE INDEX ix_emp_job_modified        ON sap_sfsf.emp_job (last_modified_on);
CREATE INDEX ix_emp_compensation_modified ON sap_sfsf.emp_compensation (last_modified_on);
CREATE INDEX ix_emp_time_off_modified   ON sap_sfsf.emp_time_off (last_modified_on);
CREATE INDEX ix_position_modified       ON sap_sfsf.position (last_modified_on);
CREATE INDEX ix_job_application_modified ON sap_sfsf.job_application (last_modified_on);
