-- =========================================================================
-- sap_sfsf -- foreign keys
--
-- Effective-dated children reference their parent by the parent's plain key,
-- not by the dated one: emp_job references emp_employment(user_id), because
-- the employment is one row while the job assignment is many.
--
-- Foundation objects (company, department, cost centre, position) are
-- themselves effective-dated in a real SuccessFactors instance. Here they are
-- keyed on the code alone, which is the simplification Tier B permits. Worth
-- being explicit about: a full-depth model would key them on
-- (code, effective_start_date) and would then lose these foreign keys for
-- exactly the reason sap_s4 loses its references to CSKS and CEPC.
-- =========================================================================

ALTER TABLE sap_sfsf.fo_department
    ADD CONSTRAINT fk_fo_department_company
        FOREIGN KEY (company_code) REFERENCES sap_sfsf.fo_company (company_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_fo_department_parent
        FOREIGN KEY (parent_department_code) REFERENCES sap_sfsf.fo_department (department_code)
        ON DELETE RESTRICT;

ALTER TABLE sap_sfsf.fo_cost_center
    ADD CONSTRAINT fk_fo_cost_center_company
        FOREIGN KEY (company_code) REFERENCES sap_sfsf.fo_company (company_code)
        ON DELETE RESTRICT;

ALTER TABLE sap_sfsf.position
    ADD CONSTRAINT fk_position_company
        FOREIGN KEY (company_code) REFERENCES sap_sfsf.fo_company (company_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_position_department
        FOREIGN KEY (department_code) REFERENCES sap_sfsf.fo_department (department_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_position_cost_center
        FOREIGN KEY (cost_center_code) REFERENCES sap_sfsf.fo_cost_center (cost_center_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_position_pay_grade
        FOREIGN KEY (pay_grade_code) REFERENCES sap_sfsf.fo_pay_grade (pay_grade_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_position_parent
        FOREIGN KEY (parent_position_code) REFERENCES sap_sfsf.position (position_code)
        ON DELETE RESTRICT;

-- Person detail cascades from the person: it is the person's own data.
ALTER TABLE sap_sfsf.per_personal
    ADD CONSTRAINT fk_per_personal_person
        FOREIGN KEY (person_id_external) REFERENCES sap_sfsf.per_person (person_id_external)
        ON DELETE CASCADE;

ALTER TABLE sap_sfsf.per_email
    ADD CONSTRAINT fk_per_email_person
        FOREIGN KEY (person_id_external) REFERENCES sap_sfsf.per_person (person_id_external)
        ON DELETE CASCADE;

ALTER TABLE sap_sfsf.per_phone
    ADD CONSTRAINT fk_per_phone_person
        FOREIGN KEY (person_id_external) REFERENCES sap_sfsf.per_person (person_id_external)
        ON DELETE CASCADE;

ALTER TABLE sap_sfsf.per_address
    ADD CONSTRAINT fk_per_address_person
        FOREIGN KEY (person_id_external) REFERENCES sap_sfsf.per_person (person_id_external)
        ON DELETE CASCADE;

ALTER TABLE sap_sfsf.emp_employment
    ADD CONSTRAINT fk_emp_employment_person
        FOREIGN KEY (person_id_external) REFERENCES sap_sfsf.per_person (person_id_external)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_emp_employment_previous
        FOREIGN KEY (previous_user_id) REFERENCES sap_sfsf.emp_employment (user_id)
        ON DELETE RESTRICT;

ALTER TABLE sap_sfsf.emp_job
    ADD CONSTRAINT fk_emp_job_employment
        FOREIGN KEY (user_id) REFERENCES sap_sfsf.emp_employment (user_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_emp_job_position
        FOREIGN KEY (position_code) REFERENCES sap_sfsf.position (position_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_emp_job_department
        FOREIGN KEY (department_code) REFERENCES sap_sfsf.fo_department (department_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_emp_job_cost_center
        FOREIGN KEY (cost_center_code) REFERENCES sap_sfsf.fo_cost_center (cost_center_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_emp_job_company
        FOREIGN KEY (company_code) REFERENCES sap_sfsf.fo_company (company_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_emp_job_manager
        FOREIGN KEY (manager_user_id) REFERENCES sap_sfsf.emp_employment (user_id)
        ON DELETE RESTRICT;

ALTER TABLE sap_sfsf.emp_compensation
    ADD CONSTRAINT fk_emp_compensation_employment
        FOREIGN KEY (user_id) REFERENCES sap_sfsf.emp_employment (user_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_emp_compensation_pay_grade
        FOREIGN KEY (pay_grade_code) REFERENCES sap_sfsf.fo_pay_grade (pay_grade_code)
        ON DELETE RESTRICT;

-- The pay component shares its parent's composite effective-dated key, so the
-- reference carries both columns.
ALTER TABLE sap_sfsf.emp_pay_component
    ADD CONSTRAINT fk_emp_pay_component_compensation
        FOREIGN KEY (user_id, effective_start_date)
        REFERENCES sap_sfsf.emp_compensation (user_id, effective_start_date)
        ON DELETE CASCADE;

ALTER TABLE sap_sfsf.emp_time_off
    ADD CONSTRAINT fk_emp_time_off_employment
        FOREIGN KEY (user_id) REFERENCES sap_sfsf.emp_employment (user_id)
        ON DELETE CASCADE;

ALTER TABLE sap_sfsf.job_requisition
    ADD CONSTRAINT fk_job_req_position
        FOREIGN KEY (position_code) REFERENCES sap_sfsf.position (position_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_job_req_department
        FOREIGN KEY (department_code) REFERENCES sap_sfsf.fo_department (department_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_job_req_company
        FOREIGN KEY (company_code) REFERENCES sap_sfsf.fo_company (company_code)
        ON DELETE RESTRICT;

ALTER TABLE sap_sfsf.candidate
    ADD CONSTRAINT fk_candidate_person
        FOREIGN KEY (person_id_external) REFERENCES sap_sfsf.per_person (person_id_external)
        ON DELETE SET NULL;

ALTER TABLE sap_sfsf.job_application
    ADD CONSTRAINT fk_job_application_requisition
        FOREIGN KEY (job_req_id) REFERENCES sap_sfsf.job_requisition (job_req_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_job_application_candidate
        FOREIGN KEY (candidate_id) REFERENCES sap_sfsf.candidate (candidate_id)
        ON DELETE CASCADE;
