-- =========================================================================
-- sfdc_crm -- foreign keys
--
-- Salesforce has two reference kinds, and only one of them can be a foreign
-- key here:
--
--   * Lookup and master-detail relationships point at a named object, and are
--     declared below. Master-detail cascades on delete; a lookup does not.
--   * Polymorphic references -- Task.WhoId, Task.WhatId, Event.WhatId -- can
--     point at any of several objects and are therefore left unconstrained,
--     with a companion *_object_type column saying which.
--
-- Note also that Salesforce does not really delete: IsDeleted sends a record
-- to the Recycle Bin. So the ON DELETE actions below describe what a hard
-- purge should do, which is a less frequent event than it is in the other
-- schemas.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Everything references record_type and sf_user, so those come first.
-- -------------------------------------------------------------------------
ALTER TABLE sfdc_crm.account
    ADD CONSTRAINT fk_account_record_type
        FOREIGN KEY (record_type_id) REFERENCES sfdc_crm.record_type (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_account_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_account_created_by
        FOREIGN KEY (created_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_account_modified_by
        FOREIGN KEY (last_modified_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_account_parent
        FOREIGN KEY (parent_id) REFERENCES sfdc_crm.account (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.contact
    ADD CONSTRAINT fk_contact_record_type
        FOREIGN KEY (record_type_id) REFERENCES sfdc_crm.record_type (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_contact_account
        FOREIGN KEY (account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_contact_reports_to
        FOREIGN KEY (reports_to_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_contact_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_contact_created_by
        FOREIGN KEY (created_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_contact_modified_by
        FOREIGN KEY (last_modified_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

-- The PII satellite is owned by its contact: purging the record purges the
-- person. Same privacy reasoning as tm_axs.
ALTER TABLE sfdc_crm.contact_pii
    ADD CONSTRAINT fk_contact_pii_contact
        FOREIGN KEY (contact_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE CASCADE;

ALTER TABLE sfdc_crm.account_contact_relation
    ADD CONSTRAINT fk_acr_account
        FOREIGN KEY (account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_acr_contact
        FOREIGN KEY (contact_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE CASCADE;

ALTER TABLE sfdc_crm.lead
    ADD CONSTRAINT fk_lead_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_lead_converted_account
        FOREIGN KEY (converted_account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_lead_converted_contact
        FOREIGN KEY (converted_contact_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE SET NULL;

-- -------------------------------------------------------------------------
-- Products and pricing.
-- -------------------------------------------------------------------------
ALTER TABLE sfdc_crm.pricebook_entry
    ADD CONSTRAINT fk_pbe_pricebook
        FOREIGN KEY (pricebook2_id) REFERENCES sfdc_crm.pricebook2 (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_pbe_product
        FOREIGN KEY (product2_id) REFERENCES sfdc_crm.product2 (id)
        ON DELETE CASCADE;

ALTER TABLE sfdc_crm.asset
    ADD CONSTRAINT fk_asset_account
        FOREIGN KEY (account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_asset_contact
        FOREIGN KEY (contact_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_asset_product
        FOREIGN KEY (product2_id) REFERENCES sfdc_crm.product2 (id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- The sales cycle: opportunity -> quote -> contract -> order.
-- Line items are master-detail and cascade; headers do not.
-- -------------------------------------------------------------------------
ALTER TABLE sfdc_crm.opportunity
    ADD CONSTRAINT fk_opportunity_record_type
        FOREIGN KEY (record_type_id) REFERENCES sfdc_crm.record_type (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_opportunity_account
        FOREIGN KEY (account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_opportunity_pricebook
        FOREIGN KEY (pricebook2_id) REFERENCES sfdc_crm.pricebook2 (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_opportunity_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_opportunity_created_by
        FOREIGN KEY (created_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_opportunity_modified_by
        FOREIGN KEY (last_modified_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.opportunity_line_item
    ADD CONSTRAINT fk_oli_opportunity
        FOREIGN KEY (opportunity_id) REFERENCES sfdc_crm.opportunity (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_oli_pricebook_entry
        FOREIGN KEY (pricebook_entry_id) REFERENCES sfdc_crm.pricebook_entry (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_oli_product
        FOREIGN KEY (product2_id) REFERENCES sfdc_crm.product2 (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.quote
    ADD CONSTRAINT fk_quote_opportunity
        FOREIGN KEY (opportunity_id) REFERENCES sfdc_crm.opportunity (id)
        ON DELETE CASCADE;

ALTER TABLE sfdc_crm.quote_line_item
    ADD CONSTRAINT fk_qli_quote
        FOREIGN KEY (quote_id) REFERENCES sfdc_crm.quote (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_qli_pricebook_entry
        FOREIGN KEY (pricebook_entry_id) REFERENCES sfdc_crm.pricebook_entry (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_qli_product
        FOREIGN KEY (product2_id) REFERENCES sfdc_crm.product2 (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.contract
    ADD CONSTRAINT fk_contract_record_type
        FOREIGN KEY (record_type_id) REFERENCES sfdc_crm.record_type (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_contract_account
        FOREIGN KEY (account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_contract_contact
        FOREIGN KEY (contact_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_contract_opportunity
        FOREIGN KEY (opportunity_id__c) REFERENCES sfdc_crm.opportunity (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_contract_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_contract_activated_by
        FOREIGN KEY (activated_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.contract_line_item
    ADD CONSTRAINT fk_cli_contract
        FOREIGN KEY (contract_id) REFERENCES sfdc_crm.contract (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cli_pricebook_entry
        FOREIGN KEY (pricebook_entry_id) REFERENCES sfdc_crm.pricebook_entry (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_cli_product
        FOREIGN KEY (product2_id) REFERENCES sfdc_crm.product2 (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.sales_order
    ADD CONSTRAINT fk_sf_order_account
        FOREIGN KEY (account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_sf_order_contract
        FOREIGN KEY (contract_id) REFERENCES sfdc_crm.contract (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_sf_order_pricebook
        FOREIGN KEY (pricebook2_id) REFERENCES sfdc_crm.pricebook2 (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_sf_order_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.sales_order_item
    ADD CONSTRAINT fk_sf_order_item_order
        FOREIGN KEY (order_id) REFERENCES sfdc_crm.sales_order (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_sf_order_item_pricebook_entry
        FOREIGN KEY (pricebook_entry_id) REFERENCES sfdc_crm.pricebook_entry (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_sf_order_item_product
        FOREIGN KEY (product2_id) REFERENCES sfdc_crm.product2 (id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Campaigns, cases and activities.
-- -------------------------------------------------------------------------
ALTER TABLE sfdc_crm.campaign
    ADD CONSTRAINT fk_campaign_parent
        FOREIGN KEY (parent_id) REFERENCES sfdc_crm.campaign (id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_campaign_contract
        FOREIGN KEY (contract_id__c) REFERENCES sfdc_crm.contract (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_campaign_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.campaign_member
    ADD CONSTRAINT fk_campaign_member_campaign
        FOREIGN KEY (campaign_id) REFERENCES sfdc_crm.campaign (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_campaign_member_contact
        FOREIGN KEY (contact_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_campaign_member_lead
        FOREIGN KEY (lead_id) REFERENCES sfdc_crm.lead (id)
        ON DELETE CASCADE;

ALTER TABLE sfdc_crm.service_case
    ADD CONSTRAINT fk_case_account
        FOREIGN KEY (account_id) REFERENCES sfdc_crm.account (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_case_contact
        FOREIGN KEY (contact_id) REFERENCES sfdc_crm.contact (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_case_parent
        FOREIGN KEY (parent_id) REFERENCES sfdc_crm.service_case (id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_case_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.service_case_comment
    ADD CONSTRAINT fk_case_comment_case
        FOREIGN KEY (parent_id) REFERENCES sfdc_crm.service_case (id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_case_comment_created_by
        FOREIGN KEY (created_by_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

-- who_id and what_id are polymorphic and deliberately unconstrained.
ALTER TABLE sfdc_crm.task
    ADD CONSTRAINT fk_task_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;

ALTER TABLE sfdc_crm.event_activity
    ADD CONSTRAINT fk_sf_event_owner
        FOREIGN KEY (owner_id) REFERENCES sfdc_crm.sf_user (id)
        ON DELETE RESTRICT;
