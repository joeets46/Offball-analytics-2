-- =========================================================================
-- sfdc_crm -- indexes
--
-- Two things drive almost every index here:
--
--   * Record type. Four target tables are `account` filtered by record type
--     and three are `contract` filtered the same way, so the extract reads
--     these tables by record type above all else.
--   * The IsDeleted / SystemModstamp pair. Every incremental extract is
--     "rows where system_modstamp > watermark and not is_deleted", so that is
--     the index, as a partial one -- deleted rows are a small minority and
--     never wanted.
-- =========================================================================

-- -------------------------------------------------------------------------
-- The extraction path: one partial index per extracted object.
-- -------------------------------------------------------------------------
CREATE INDEX ix_account_modstamp
    ON sfdc_crm.account (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_contact_modstamp
    ON sfdc_crm.contact (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_opportunity_modstamp
    ON sfdc_crm.opportunity (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_contract_modstamp
    ON sfdc_crm.contract (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_case_modstamp
    ON sfdc_crm.service_case (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_campaign_modstamp
    ON sfdc_crm.campaign (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_campaign_member_modstamp
    ON sfdc_crm.campaign_member (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_sf_order_modstamp
    ON sfdc_crm.sales_order (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_product2_modstamp
    ON sfdc_crm.product2 (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_task_modstamp
    ON sfdc_crm.task (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_cli_modstamp
    ON sfdc_crm.contract_line_item (system_modstamp) WHERE NOT is_deleted;
CREATE INDEX ix_oli_modstamp
    ON sfdc_crm.opportunity_line_item (system_modstamp) WHERE NOT is_deleted;

-- Recycle Bin sweep: the rows the extract must tombstone rather than load.
CREATE INDEX ix_account_deleted
    ON sfdc_crm.account (system_modstamp) WHERE is_deleted;
CREATE INDEX ix_contact_deleted
    ON sfdc_crm.contact (system_modstamp) WHERE is_deleted;

-- -------------------------------------------------------------------------
-- Record type, the discriminator the mapping depends on.
-- -------------------------------------------------------------------------
CREATE INDEX ix_account_record_type
    ON sfdc_crm.account (record_type_id) WHERE NOT is_deleted;
CREATE INDEX ix_contact_record_type
    ON sfdc_crm.contact (record_type_id) WHERE NOT is_deleted;
CREATE INDEX ix_opportunity_record_type
    ON sfdc_crm.opportunity (record_type_id) WHERE NOT is_deleted;
CREATE INDEX ix_contract_record_type
    ON sfdc_crm.contract (record_type_id) WHERE NOT is_deleted;
CREATE INDEX ix_product2_class
    ON sfdc_crm.product2 (product_class__c) WHERE is_active AND NOT is_deleted;

-- -------------------------------------------------------------------------
-- Relationship navigation.
-- -------------------------------------------------------------------------
CREATE INDEX ix_account_parent
    ON sfdc_crm.account (parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX ix_account_owner       ON sfdc_crm.account (owner_id);
CREATE INDEX ix_account_name        ON sfdc_crm.account (name);
-- Resolution against SAP.
CREATE INDEX ix_account_sap_customer
    ON sfdc_crm.account (sap_customer_number__c) WHERE sap_customer_number__c IS NOT NULL;
CREATE INDEX ix_account_sap_vendor
    ON sfdc_crm.account (sap_vendor_number__c) WHERE sap_vendor_number__c IS NOT NULL;

CREATE INDEX ix_contact_account     ON sfdc_crm.contact (account_id);
CREATE INDEX ix_contact_owner       ON sfdc_crm.contact (owner_id);
CREATE INDEX ix_contact_name        ON sfdc_crm.contact (last_name, first_name);
CREATE INDEX ix_contact_reports_to
    ON sfdc_crm.contact (reports_to_id) WHERE reports_to_id IS NOT NULL;
-- The five cross-system business keys. These are the identity-resolution
-- lookups, run once per record on every load.
CREATE INDEX ix_contact_tm
    ON sfdc_crm.contact (tm_account_number__c) WHERE tm_account_number__c IS NOT NULL;
CREATE INDEX ix_contact_archtics
    ON sfdc_crm.contact (archtics_account__c) WHERE archtics_account__c IS NOT NULL;
CREATE INDEX ix_contact_aep
    ON sfdc_crm.contact (aep_ecid__c) WHERE aep_ecid__c IS NOT NULL;
CREATE INDEX ix_contact_shopify
    ON sfdc_crm.contact (shopify_customer_id__c) WHERE shopify_customer_id__c IS NOT NULL;
CREATE INDEX ix_contact_sfsf
    ON sfdc_crm.contact (sfsf_person_id__c) WHERE sfsf_person_id__c IS NOT NULL;

-- Email lives on the satellite, so the lookup index does too.
CREATE INDEX ix_contact_pii_email
    ON sfdc_crm.contact_pii (email) WHERE email IS NOT NULL;

CREATE INDEX ix_acr_contact         ON sfdc_crm.account_contact_relation (contact_id);
CREATE INDEX ix_acr_account         ON sfdc_crm.account_contact_relation (account_id);
-- Salesforce permits exactly one direct relation per contact.
CREATE UNIQUE INDEX ux_acr_one_direct
    ON sfdc_crm.account_contact_relation (contact_id) WHERE is_direct AND NOT is_deleted;

CREATE INDEX ix_lead_owner          ON sfdc_crm.lead (owner_id);
CREATE INDEX ix_lead_email          ON sfdc_crm.lead (email) WHERE email IS NOT NULL;
CREATE INDEX ix_lead_open           ON sfdc_crm.lead (status) WHERE NOT is_converted AND NOT is_deleted;

-- -------------------------------------------------------------------------
-- Pipeline and delivery.
-- -------------------------------------------------------------------------
CREATE INDEX ix_opportunity_account ON sfdc_crm.opportunity (account_id);
CREATE INDEX ix_opportunity_owner   ON sfdc_crm.opportunity (owner_id);
-- The open pipeline, by expected close. The single most-run query in any CRM.
CREATE INDEX ix_opportunity_open_pipeline
    ON sfdc_crm.opportunity (close_date, stage_name)
    WHERE NOT is_closed AND NOT is_deleted;
-- Win/loss analysis.
CREATE INDEX ix_opportunity_closed
    ON sfdc_crm.opportunity (close_date) WHERE is_closed AND NOT is_deleted;
CREATE INDEX ix_opportunity_loss_reason
    ON sfdc_crm.opportunity (loss_reason__c) WHERE loss_reason__c IS NOT NULL;
-- Category exclusivity conflicts, checked before a deal can be sold.
CREATE INDEX ix_opportunity_exclusivity
    ON sfdc_crm.opportunity (exclusivity_category__c)
    WHERE exclusivity_category__c IS NOT NULL AND NOT is_closed;

CREATE INDEX ix_oli_opportunity     ON sfdc_crm.opportunity_line_item (opportunity_id);
CREATE INDEX ix_oli_pricebook_entry ON sfdc_crm.opportunity_line_item (pricebook_entry_id);
CREATE INDEX ix_oli_product         ON sfdc_crm.opportunity_line_item (product2_id);

CREATE INDEX ix_quote_opportunity   ON sfdc_crm.quote (opportunity_id);
CREATE INDEX ix_qli_quote           ON sfdc_crm.quote_line_item (quote_id);
CREATE INDEX ix_qli_pricebook_entry ON sfdc_crm.quote_line_item (pricebook_entry_id);
CREATE INDEX ix_qli_product         ON sfdc_crm.quote_line_item (product2_id);

CREATE INDEX ix_contract_account    ON sfdc_crm.contract (account_id);
CREATE INDEX ix_contract_contact    ON sfdc_crm.contract (contact_id) WHERE contact_id IS NOT NULL;
CREATE INDEX ix_contract_opportunity
    ON sfdc_crm.contract (opportunity_id__c) WHERE opportunity_id__c IS NOT NULL;
CREATE INDEX ix_contract_owner      ON sfdc_crm.contract (owner_id);
CREATE INDEX ix_contract_activated_by
    ON sfdc_crm.contract (activated_by_id) WHERE activated_by_id IS NOT NULL;
CREATE INDEX ix_contract_sap
    ON sfdc_crm.contract (sap_contract_number__c) WHERE sap_contract_number__c IS NOT NULL;
-- Renewal and expiry pipeline.
CREATE INDEX ix_contract_expiring
    ON sfdc_crm.contract (end_date) WHERE status = 'Activated';

CREATE INDEX ix_cli_contract        ON sfdc_crm.contract_line_item (contract_id);
CREATE INDEX ix_cli_pricebook_entry ON sfdc_crm.contract_line_item (pricebook_entry_id);
CREATE INDEX ix_cli_product         ON sfdc_crm.contract_line_item (product2_id);
-- Under-delivered commitments: the fulfilment worklist.
CREATE INDEX ix_cli_under_delivered
    ON sfdc_crm.contract_line_item (contract_id)
    WHERE deliverable_quantity__c IS NOT NULL
      AND delivered_quantity__c < deliverable_quantity__c;

CREATE INDEX ix_pbe_pricebook       ON sfdc_crm.pricebook_entry (pricebook2_id);
CREATE INDEX ix_pbe_product         ON sfdc_crm.pricebook_entry (product2_id);

CREATE INDEX ix_asset_account       ON sfdc_crm.asset (account_id) WHERE account_id IS NOT NULL;
CREATE INDEX ix_asset_contact       ON sfdc_crm.asset (contact_id) WHERE contact_id IS NOT NULL;
CREATE INDEX ix_asset_product       ON sfdc_crm.asset (product2_id) WHERE product2_id IS NOT NULL;
CREATE INDEX ix_asset_tm_event
    ON sfdc_crm.asset (tm_event_code__c) WHERE tm_event_code__c IS NOT NULL;

CREATE INDEX ix_sf_order_account    ON sfdc_crm.sales_order (account_id);
CREATE INDEX ix_sf_order_contract   ON sfdc_crm.sales_order (contract_id) WHERE contract_id IS NOT NULL;
CREATE INDEX ix_sf_order_pricebook  ON sfdc_crm.sales_order (pricebook2_id) WHERE pricebook2_id IS NOT NULL;
CREATE INDEX ix_sf_order_owner      ON sfdc_crm.sales_order (owner_id);
-- Loyalty point ledger for an account.
CREATE INDEX ix_sf_order_loyalty
    ON sfdc_crm.sales_order (account_id, effective_date)
    WHERE order_class__c IN ('loyalty_accrual', 'loyalty_redemption');

CREATE INDEX ix_sf_order_item_order ON sfdc_crm.sales_order_item (order_id);
CREATE INDEX ix_sf_order_item_pbe   ON sfdc_crm.sales_order_item (pricebook_entry_id);
CREATE INDEX ix_sf_order_item_product
    ON sfdc_crm.sales_order_item (product2_id) WHERE product2_id IS NOT NULL;

-- -------------------------------------------------------------------------
-- Marketing and service.
-- -------------------------------------------------------------------------
CREATE INDEX ix_campaign_parent     ON sfdc_crm.campaign (parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX ix_campaign_contract   ON sfdc_crm.campaign (contract_id__c) WHERE contract_id__c IS NOT NULL;
CREATE INDEX ix_campaign_owner      ON sfdc_crm.campaign (owner_id);
CREATE INDEX ix_campaign_aep
    ON sfdc_crm.campaign (aep_journey_id__c) WHERE aep_journey_id__c IS NOT NULL;
CREATE INDEX ix_campaign_running    ON sfdc_crm.campaign (start_date) WHERE status = 'In Progress';

CREATE INDEX ix_campaign_member_campaign ON sfdc_crm.campaign_member (campaign_id);
CREATE INDEX ix_campaign_member_contact
    ON sfdc_crm.campaign_member (contact_id) WHERE contact_id IS NOT NULL;
CREATE INDEX ix_campaign_member_lead
    ON sfdc_crm.campaign_member (lead_id) WHERE lead_id IS NOT NULL;
CREATE INDEX ix_campaign_member_responded
    ON sfdc_crm.campaign_member (campaign_id) WHERE has_responded;

CREATE INDEX ix_case_account        ON sfdc_crm.service_case (account_id) WHERE account_id IS NOT NULL;
CREATE INDEX ix_case_contact        ON sfdc_crm.service_case (contact_id) WHERE contact_id IS NOT NULL;
CREATE INDEX ix_case_parent         ON sfdc_crm.service_case (parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX ix_case_owner          ON sfdc_crm.service_case (owner_id);
-- The service queue, by priority then age.
CREATE INDEX ix_case_open_queue
    ON sfdc_crm.service_case (priority, created_date)
    WHERE NOT is_closed AND NOT is_deleted;
CREATE INDEX ix_case_sla_breaches
    ON sfdc_crm.service_case (created_date) WHERE sla_breached__c;
CREATE INDEX ix_case_tm_order
    ON sfdc_crm.service_case (tm_order_number__c) WHERE tm_order_number__c IS NOT NULL;
CREATE INDEX ix_case_shopify_order
    ON sfdc_crm.service_case (shopify_order_id__c) WHERE shopify_order_id__c IS NOT NULL;

CREATE INDEX ix_case_comment_case   ON sfdc_crm.service_case_comment (parent_id);
CREATE INDEX ix_case_comment_created_by ON sfdc_crm.service_case_comment (created_by_id);

CREATE INDEX ix_task_owner          ON sfdc_crm.task (owner_id);
CREATE INDEX ix_task_who            ON sfdc_crm.task (who_id) WHERE who_id IS NOT NULL;
-- Polymorphic lookup: the type has to be part of the index to be useful.
CREATE INDEX ix_task_what           ON sfdc_crm.task (what_object_type, what_id) WHERE what_id IS NOT NULL;
CREATE INDEX ix_task_open           ON sfdc_crm.task (activity_date) WHERE NOT is_closed;

CREATE INDEX ix_sf_event_owner      ON sfdc_crm.event_activity (owner_id);
CREATE INDEX ix_sf_event_who        ON sfdc_crm.event_activity (who_id) WHERE who_id IS NOT NULL;
CREATE INDEX ix_sf_event_what
    ON sfdc_crm.event_activity (what_object_type, what_id) WHERE what_id IS NOT NULL;
CREATE INDEX ix_sf_event_start      ON sfdc_crm.event_activity (start_date_time);
