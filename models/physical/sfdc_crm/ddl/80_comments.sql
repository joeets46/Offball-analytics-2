-- =========================================================================
-- sfdc_crm -- table comments
-- =========================================================================

COMMENT ON TABLE sfdc_crm.lead IS
    'Unqualified demand, converted into an Account and Contact. Conversion writes all three references at once and cannot be partially applied.';
COMMENT ON TABLE sfdc_crm.account_contact_relation IS
    'The many-to-many Salesforce added because a contact genuinely belongs to more than one account. Feeds target athlete.agent_relationship and target fan.club_membership.';
COMMENT ON TABLE sfdc_crm.product2 IS
    'Products. A sponsorable asset is a product in Salesforce, which is why four target tables -- sponsorship.property, inventory_unit, ad_inventory and fan.loyalty_program -- all map here, separated by product_class__c.';
COMMENT ON TABLE sfdc_crm.pricebook2 IS
    'Price books. A Plus org runs several -- standard, partner, renewal -- and the same product carries a different price in each.';
COMMENT ON TABLE sfdc_crm.pricebook_entry IS
    'One price per product per book per currency. The join that makes a product sellable.';
COMMENT ON TABLE sfdc_crm.asset IS
    'A product instance a customer holds. Feeds the allocated side of target sponsorship.inventory_allocation and sponsorship.activation.';
COMMENT ON TABLE sfdc_crm.opportunity_line_item IS
    'Opportunity lines with the discount against list generated, so sales cannot report a discount differently from finance.';
COMMENT ON TABLE sfdc_crm.quote_line_item IS
    'Quote lines. No target table corresponds, so the quoted-versus-contracted gap -- the realised discount -- is not reconstructable downstream.';
COMMENT ON TABLE sfdc_crm.contract IS
    'Executed contracts. Six target tables map here by record type, from sponsorship.deal through fan.loyalty_enrollment to broadcast.streaming_subscription.';
COMMENT ON TABLE sfdc_crm.contract_line_item IS
    'Contract deliverables and their delivery progress. Target sponsorship.deal_term is this table; over-delivery is permitted because exceeding a commitment is common and not an error.';
COMMENT ON TABLE sfdc_crm.sales_order IS
    'Salesforce orders. Loyalty point movements are recorded here as orders, which is why the points delta can be negative on a redemption.';
COMMENT ON TABLE sfdc_crm.sales_order_item IS
    'Order lines.';
COMMENT ON TABLE sfdc_crm.campaign_member IS
    'Campaign membership and response. Requires exactly one of a contact or a lead, which Salesforce enforces and so does this schema.';
COMMENT ON TABLE sfdc_crm.service_case IS
    'Service cases. Feeds target fan.service_case; first response and resolution are the two service commitments actually reported on.';
COMMENT ON TABLE sfdc_crm.service_case_comment IS
    'Case correspondence, public or internal. The target model keeps no comments at all, so the substance of a complaint does not reach the lakehouse.';
COMMENT ON TABLE sfdc_crm.event_activity IS
    'Salesforce Events -- meetings and appointments. Named event_activity because `event` is already taken by tm_axs.event in this model and the collision would be genuinely confusing.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE sfdc_crm.sf_user IS
    'Salesforce users -- the owner of every record and the actor in every audit column.';
COMMENT ON TABLE sfdc_crm.account IS
    'Companies and fan households. Six target tables are this one table filtered by record type, which is what makes sfdc_crm.record_type load-bearing.';
COMMENT ON TABLE sfdc_crm.opportunity IS
    'The sales pipeline. Carries the loss reason, which has no target column -- so the lakehouse can report what was won and nothing about why anything was lost.';
COMMENT ON TABLE sfdc_crm.campaign IS
    'Marketing and sponsorship-activation campaigns. Salesforce plans them; AEP executes them, which is why target fan.communication comes from the AEP side.';
COMMENT ON TABLE sfdc_crm.task IS
    'Salesforce tasks: calls, emails and to-dos. WhoId and WhatId are polymorphic and so cannot be foreign keys, which is why what_object_type is mandatory alongside WhatId.';
