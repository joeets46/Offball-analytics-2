-- =========================================================================
-- tm_axs -- foreign keys
--
-- Declared last so a single ordered load works without deferred constraints.
--
-- Every foreign key here is intra-schema. References to the other nine systems
-- are business-key columns with no REFERENCES clause -- tm_axs.event
-- .archtics_event_code, tm_axs.sales_order.sap_billing_doc_number,
-- tm_axs.credential.sfdc_contact_id and so on -- because they cross a database
-- boundary. Those are resolved through common.entity_xref at load time.
--
-- ON DELETE behaviour is chosen rather than defaulted:
--   CASCADE   where the child has no meaning without the parent (a barcode
--             without its ticket, an order line without its order).
--   RESTRICT  where deleting the parent should be blocked outright, which is
--             most reference data and anything financial.
--   SET NULL  where the link is optional context (a promo code on an order).
-- =========================================================================

-- -------------------------------------------------------------------------
-- Reference and master.
-- -------------------------------------------------------------------------
ALTER TABLE tm_axs.price_zone
    ADD CONSTRAINT fk_price_zone_venue
        FOREIGN KEY (venue_ref_id) REFERENCES tm_axs.venue_ref (venue_ref_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.event_group
    ADD CONSTRAINT fk_event_group_parent
        FOREIGN KEY (parent_event_group_id) REFERENCES tm_axs.event_group (event_group_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_event_group_season
        FOREIGN KEY (season_id) REFERENCES tm_axs.season (season_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.access_zone
    ADD CONSTRAINT fk_access_zone_venue
        FOREIGN KEY (venue_ref_id) REFERENCES tm_axs.venue_ref (venue_ref_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.access_point
    ADD CONSTRAINT fk_access_point_venue
        FOREIGN KEY (venue_ref_id) REFERENCES tm_axs.venue_ref (venue_ref_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_access_point_zone
        FOREIGN KEY (access_zone_id) REFERENCES tm_axs.access_zone (access_zone_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.screening_checkpoint
    ADD CONSTRAINT fk_screening_checkpoint_access_point
        FOREIGN KEY (access_point_id) REFERENCES tm_axs.access_point (access_point_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.event
    ADD CONSTRAINT fk_event_event_type
        FOREIGN KEY (event_type_id) REFERENCES tm_axs.event_type (event_type_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_event_venue
        FOREIGN KEY (venue_ref_id) REFERENCES tm_axs.venue_ref (venue_ref_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_event_season
        FOREIGN KEY (season_id) REFERENCES tm_axs.season (season_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_event_event_group
        FOREIGN KEY (event_group_id) REFERENCES tm_axs.event_group (event_group_id)
        ON DELETE SET NULL;

ALTER TABLE tm_axs.price_scale
    ADD CONSTRAINT fk_price_scale_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE CASCADE;

ALTER TABLE tm_axs.price_level
    ADD CONSTRAINT fk_price_level_scale
        FOREIGN KEY (price_scale_id) REFERENCES tm_axs.price_scale (price_scale_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_price_level_zone
        FOREIGN KEY (price_zone_id) REFERENCES tm_axs.price_zone (price_zone_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.customer_account
    ADD CONSTRAINT fk_customer_merged_into
        FOREIGN KEY (merged_into_customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE RESTRICT;

-- The PII satellite is owned by its parent: erasing the account erases the
-- person. This is the one place CASCADE is a privacy control rather than a
-- convenience.
ALTER TABLE tm_axs.customer_account_pii
    ADD CONSTRAINT fk_customer_pii_account
        FOREIGN KEY (customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE CASCADE;

ALTER TABLE tm_axs.credential_pii
    ADD CONSTRAINT fk_credential_pii_credential
        FOREIGN KEY (credential_id) REFERENCES tm_axs.credential (credential_id)
        ON DELETE CASCADE;

ALTER TABLE tm_axs.payment_method
    ADD CONSTRAINT fk_payment_method_customer
        FOREIGN KEY (customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE CASCADE;

ALTER TABLE tm_axs.ticket_inventory
    ADD CONSTRAINT fk_ticket_inventory_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_ticket_inventory_price_zone
        FOREIGN KEY (price_zone_id) REFERENCES tm_axs.price_zone (price_zone_id)
        ON DELETE RESTRICT;

-- -------------------------------------------------------------------------
-- Transactions.
-- -------------------------------------------------------------------------
ALTER TABLE tm_axs.inventory_hold
    ADD CONSTRAINT fk_hold_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_hold_hold_code
        FOREIGN KEY (hold_code) REFERENCES tm_axs.hold_code (hold_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_hold_price_zone
        FOREIGN KEY (price_zone_id) REFERENCES tm_axs.price_zone (price_zone_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_hold_inventory
        FOREIGN KEY (ticket_inventory_id)
        REFERENCES tm_axs.ticket_inventory (ticket_inventory_id)
        ON DELETE CASCADE;

ALTER TABLE tm_axs.group_sale
    ADD CONSTRAINT fk_group_sale_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.sales_order
    ADD CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_sales_channel
        FOREIGN KEY (sales_channel_code)
        REFERENCES tm_axs.sales_channel (sales_channel_code)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_group_sale
        FOREIGN KEY (group_sale_id) REFERENCES tm_axs.group_sale (group_sale_id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_order_promo_code
        FOREIGN KEY (promo_code_id) REFERENCES tm_axs.promo_code (promo_code_id)
        ON DELETE SET NULL;

ALTER TABLE tm_axs.order_line
    ADD CONSTRAINT fk_order_line_order
        FOREIGN KEY (sales_order_id) REFERENCES tm_axs.sales_order (sales_order_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_order_line_inventory
        FOREIGN KEY (ticket_inventory_id)
        REFERENCES tm_axs.ticket_inventory (ticket_inventory_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_line_price_level
        FOREIGN KEY (price_level_id) REFERENCES tm_axs.price_level (price_level_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_line_delivery_method
        FOREIGN KEY (delivery_method_code)
        REFERENCES tm_axs.delivery_method (delivery_method_code)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.ticket
    ADD CONSTRAINT fk_ticket_order_line
        FOREIGN KEY (order_line_id) REFERENCES tm_axs.order_line (order_line_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_ticket_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_ticket_inventory
        FOREIGN KEY (ticket_inventory_id)
        REFERENCES tm_axs.ticket_inventory (ticket_inventory_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_ticket_holder
        FOREIGN KEY (holder_customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.barcode
    ADD CONSTRAINT fk_barcode_ticket
        FOREIGN KEY (ticket_id) REFERENCES tm_axs.ticket (ticket_id)
        ON DELETE CASCADE;

ALTER TABLE tm_axs.delivery
    ADD CONSTRAINT fk_delivery_ticket
        FOREIGN KEY (ticket_id) REFERENCES tm_axs.ticket (ticket_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_delivery_method
        FOREIGN KEY (delivery_method_code)
        REFERENCES tm_axs.delivery_method (delivery_method_code)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.ticket_transfer
    ADD CONSTRAINT fk_transfer_ticket
        FOREIGN KEY (ticket_id) REFERENCES tm_axs.ticket (ticket_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_transfer_from_customer
        FOREIGN KEY (from_customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_transfer_to_customer
        FOREIGN KEY (to_customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.resale_listing
    ADD CONSTRAINT fk_resale_listing_ticket
        FOREIGN KEY (ticket_id) REFERENCES tm_axs.ticket (ticket_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_resale_listing_seller
        FOREIGN KEY (seller_customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.resale_transaction
    ADD CONSTRAINT fk_resale_txn_listing
        FOREIGN KEY (resale_listing_id)
        REFERENCES tm_axs.resale_listing (resale_listing_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_resale_txn_buyer
        FOREIGN KEY (buyer_customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_resale_txn_order
        FOREIGN KEY (sales_order_id) REFERENCES tm_axs.sales_order (sales_order_id)
        ON DELETE SET NULL;

-- Financial records are never cascade-deleted: RESTRICT throughout.
ALTER TABLE tm_axs.payment
    ADD CONSTRAINT fk_payment_order
        FOREIGN KEY (sales_order_id) REFERENCES tm_axs.sales_order (sales_order_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_payment_method
        FOREIGN KEY (payment_method_id) REFERENCES tm_axs.payment_method (payment_method_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.payment_transaction
    ADD CONSTRAINT fk_payment_txn_payment
        FOREIGN KEY (payment_id) REFERENCES tm_axs.payment (payment_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.refund
    ADD CONSTRAINT fk_refund_order
        FOREIGN KEY (sales_order_id) REFERENCES tm_axs.sales_order (sales_order_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_refund_payment
        FOREIGN KEY (payment_id) REFERENCES tm_axs.payment (payment_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_refund_order_line
        FOREIGN KEY (order_line_id) REFERENCES tm_axs.order_line (order_line_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_refund_ticket
        FOREIGN KEY (ticket_id) REFERENCES tm_axs.ticket (ticket_id)
        ON DELETE RESTRICT;

-- Partitioned parents take foreign keys normally; PostgreSQL propagates them
-- to every partition.
ALTER TABLE tm_axs.scan
    ADD CONSTRAINT fk_scan_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_scan_access_point
        FOREIGN KEY (access_point_id) REFERENCES tm_axs.access_point (access_point_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_scan_barcode
        FOREIGN KEY (barcode_id) REFERENCES tm_axs.barcode (barcode_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_scan_credential
        FOREIGN KEY (credential_id) REFERENCES tm_axs.credential (credential_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.credential_assignment
    ADD CONSTRAINT fk_cred_assignment_credential
        FOREIGN KEY (credential_id) REFERENCES tm_axs.credential (credential_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_cred_assignment_zone
        FOREIGN KEY (access_zone_id) REFERENCES tm_axs.access_zone (access_zone_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_cred_assignment_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE CASCADE;

ALTER TABLE tm_axs.screening_event
    ADD CONSTRAINT fk_screening_event_checkpoint
        FOREIGN KEY (screening_checkpoint_id)
        REFERENCES tm_axs.screening_checkpoint (screening_checkpoint_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_screening_event_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE RESTRICT;

ALTER TABLE tm_axs.security_incident
    ADD CONSTRAINT fk_incident_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_incident_venue
        FOREIGN KEY (venue_ref_id) REFERENCES tm_axs.venue_ref (venue_ref_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_incident_zone
        FOREIGN KEY (access_zone_id) REFERENCES tm_axs.access_zone (access_zone_id)
        ON DELETE SET NULL;

ALTER TABLE tm_axs.ejection
    ADD CONSTRAINT fk_ejection_incident
        FOREIGN KEY (security_incident_id)
        REFERENCES tm_axs.security_incident (security_incident_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_ejection_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE RESTRICT,
    ADD CONSTRAINT fk_ejection_ticket
        FOREIGN KEY (ticket_id) REFERENCES tm_axs.ticket (ticket_id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_ejection_customer
        FOREIGN KEY (customer_account_id)
        REFERENCES tm_axs.customer_account (customer_account_id)
        ON DELETE SET NULL;

ALTER TABLE tm_axs.event_day_log
    ADD CONSTRAINT fk_event_day_log_event
        FOREIGN KEY (event_id) REFERENCES tm_axs.event (event_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_event_day_log_venue
        FOREIGN KEY (venue_ref_id) REFERENCES tm_axs.venue_ref (venue_ref_id)
        ON DELETE RESTRICT;
