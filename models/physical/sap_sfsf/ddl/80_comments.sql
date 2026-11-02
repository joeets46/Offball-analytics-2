-- =========================================================================
-- sap_sfsf -- table comments
-- =========================================================================

COMMENT ON TABLE sap_sfsf.fo_company IS
    'Legal entities. The same entity as the referenced SAP company code.';
COMMENT ON TABLE sap_sfsf.fo_department IS
    'Departments, carrying the squad or function: first team, academy, commercial, venue operations.';
COMMENT ON TABLE sap_sfsf.fo_cost_center IS
    'Cost centres. SAP controlling holds the authoritative version; this is the HCM view of it.';
COMMENT ON TABLE sap_sfsf.fo_pay_grade IS
    'Pay grades with their ranges.';
COMMENT ON TABLE sap_sfsf.per_email IS
    'Email addresses by type. Business and personal addresses are governed differently under most privacy regimes.';
COMMENT ON TABLE sap_sfsf.per_phone IS
    'Phone numbers by type, including the emergency contact number.';
COMMENT ON TABLE sap_sfsf.per_address IS
    'Addresses, effective-dated, because people move and the history matters for tax and squad registration.';
COMMENT ON TABLE sap_sfsf.emp_compensation IS
    'Effective-dated compensation. SAP carries the contract document; this carries what is actually paid, and the two disagree more often than anyone would like.';
COMMENT ON TABLE sap_sfsf.job_requisition IS
    'Recruiting requisitions. The recruiting_type column separates ordinary hiring from a draft, a trial or an academy intake.';
COMMENT ON TABLE sap_sfsf.candidate IS
    'Recruiting candidates, linked to a person record once hired.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE sap_sfsf.per_person IS
    'The person -- the immutable identity, separate from the effective-dated attributes that change. Nationality here governs squad registration limits as much as work eligibility.';
COMMENT ON TABLE sap_sfsf.position IS
    'The seat, which exists whether or not anyone occupies it. A vacant position is the unit of workforce planning and the basis of target venue.staff_plan.';
COMMENT ON TABLE sap_sfsf.emp_employment IS
    'A person engagement with the organisation. A player who retires and returns as a coach is one person with two employments, and the rehire link is what keeps the career continuous.';
COMMENT ON TABLE sap_sfsf.emp_job IS
    'Effective-dated job assignment. The event reason distinguishes a promotion from a transfer from a loan return; the target model keeps none of it.';
COMMENT ON TABLE sap_sfsf.job_application IS
    'Applications against a requisition. The selection order is the closest a recruiting module gets to a draft pick, and it cannot represent traded or compensatory picks.';
