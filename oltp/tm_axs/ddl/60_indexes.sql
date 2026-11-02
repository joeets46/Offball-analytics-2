-- =========================================================================
-- tm_axs -- indexes
--
-- Only indexes that serve a named access path. PostgreSQL already indexes
-- primary keys and UNIQUE constraints, so none of those are repeated here.
--
-- Foreign key columns are indexed where the child is read by parent (every
-- order-to-line and ticket-to-barcode lookup) or where the parent is deleted or
-- updated, which otherwise forces a sequential scan of the child to validate
-- the constraint. FK columns on low-cardinality reference tables are left
-- unindexed: the planner will not use them and they cost write throughput.
--
-- Partial indexes are used heavily. Most operational queries want live rows
-- only -- active listings, unsettled payments, open incidents -- and a WHERE
-- clause on the index keeps it a fraction of the table size.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Event lookup. The on-sale and event-day paths.
-- -------------------------------------------------------------------------
CREATE INDEX ix_event_date_status
    ON tm_axs.event (event_date, lifecycle_status);

-- The "what is on sale now" query, which runs constantly on the storefront.
CREATE INDEX ix_event_on_sale
    ON tm_axs.event (on_sale_at, event_date)
    WHERE lifecycle_status = 'confirmed';

CREATE INDEX ix_event_venue_date
    ON tm_axs.event (venue_ref_id, event_date);

-- Supports resolution against the seating system; only rows that carry a link.
CREATE INDEX ix_event_archtics_key
    ON tm_axs.event (archtics_event_code)
    WHERE archtics_event_code IS NOT NULL;

CREATE INDEX ix_event_group_parent
    ON tm_axs.event_group (parent_event_group_id)
    WHERE parent_event_group_id IS NOT NULL;

-- -------------------------------------------------------------------------
-- Customer lookup. Email is the de facto search key at the box office.
-- -------------------------------------------------------------------------
-- The domain is built on citext, so this index is already case-insensitive.
CREATE INDEX ix_customer_email
    ON tm_axs.customer_account (email)
    WHERE email IS NOT NULL AND NOT is_deleted;

CREATE INDEX ix_customer_merge_chain
    ON tm_axs.customer_account (merged_into_customer_account_id)
    WHERE merged_into_customer_account_id IS NOT NULL;

CREATE INDEX ix_payment_method_customer
    ON tm_axs.payment_method (customer_account_id)
    WHERE is_active;

-- One default instrument per customer, enforced as a partial unique index
-- because a plain UNIQUE would forbid more than one non-default row.
CREATE UNIQUE INDEX ux_payment_method_one_default
    ON tm_axs.payment_method (customer_account_id)
    WHERE is_default AND is_active;

-- -------------------------------------------------------------------------
-- Inventory and holds.
-- -------------------------------------------------------------------------
-- The seat map query: available inventory for an event by zone.
CREATE INDEX ix_ticket_inventory_available
    ON tm_axs.ticket_inventory (event_id, price_zone_id)
    WHERE inventory_status = 'available';

CREATE INDEX ix_ticket_inventory_event_status
    ON tm_axs.ticket_inventory (event_id, inventory_status);

CREATE INDEX ix_hold_event_active
    ON tm_axs.inventory_hold (event_id, hold_code)
    WHERE hold_status = 'active';

-- Drives the hold-expiry sweep.
CREATE INDEX ix_hold_release_due
    ON tm_axs.inventory_hold (release_due_at)
    WHERE hold_status = 'active' AND release_due_at IS NOT NULL;

CREATE INDEX ix_hold_inventory
    ON tm_axs.inventory_hold (ticket_inventory_id)
    WHERE ticket_inventory_id IS NOT NULL;

-- -------------------------------------------------------------------------
-- Orders, lines and tickets.
-- -------------------------------------------------------------------------
CREATE INDEX ix_order_customer_ordered
    ON tm_axs.sales_order (customer_account_id, ordered_at DESC);

CREATE INDEX ix_order_event_status
    ON tm_axs.sales_order (event_id, order_status);

CREATE INDEX ix_order_ordered_at
    ON tm_axs.sales_order (ordered_at);

-- The finance reconciliation query: completed orders not yet in the ledger.
CREATE INDEX ix_order_awaiting_gl
    ON tm_axs.sales_order (completed_at)
    WHERE order_status = 'completed' AND posted_to_gl_at IS NULL;

CREATE INDEX ix_order_line_order
    ON tm_axs.order_line (sales_order_id);
CREATE INDEX ix_order_line_price_level
    ON tm_axs.order_line (price_level_id);
CREATE INDEX ix_order_line_inventory
    ON tm_axs.order_line (ticket_inventory_id)
    WHERE ticket_inventory_id IS NOT NULL;

CREATE INDEX ix_ticket_order_line
    ON tm_axs.ticket (order_line_id);
CREATE INDEX ix_ticket_event_status
    ON tm_axs.ticket (event_id, ticket_status);
CREATE INDEX ix_ticket_holder
    ON tm_axs.ticket (holder_customer_account_id)
    WHERE holder_customer_account_id IS NOT NULL;
CREATE INDEX ix_ticket_inventory_ref
    ON tm_axs.ticket (ticket_inventory_id)
    WHERE ticket_inventory_id IS NOT NULL;

-- The gate path: resolve a presented barcode to a live ticket. This is the
-- latency-critical lookup in the whole schema -- it runs once per person
-- entering the building, in a burst.
CREATE UNIQUE INDEX ux_barcode_live
    ON tm_axs.barcode (barcode_value)
    WHERE NOT is_voided;

CREATE INDEX ix_barcode_ticket
    ON tm_axs.barcode (ticket_id, rotation_sequence DESC);

CREATE INDEX ix_delivery_ticket
    ON tm_axs.delivery (ticket_id);
-- Drives the delivery retry sweep.
CREATE INDEX ix_delivery_pending
    ON tm_axs.delivery (created_at)
    WHERE delivery_status IN ('pending', 'failed');

-- -------------------------------------------------------------------------
-- Transfer and resale.
-- -------------------------------------------------------------------------
CREATE INDEX ix_transfer_ticket
    ON tm_axs.ticket_transfer (ticket_id);
CREATE INDEX ix_transfer_to_email_offered
    ON tm_axs.ticket_transfer (to_email)
    WHERE transfer_status = 'offered';
CREATE INDEX ix_transfer_expiry_sweep
    ON tm_axs.ticket_transfer (expires_at)
    WHERE transfer_status = 'offered' AND expires_at IS NOT NULL;

-- One live listing per ticket. A ticket may have many historical listings but
-- only ever one on the market.
CREATE UNIQUE INDEX ux_resale_one_active_per_ticket
    ON tm_axs.resale_listing (ticket_id)
    WHERE listing_status = 'active';

CREATE INDEX ix_resale_seller
    ON tm_axs.resale_listing (seller_customer_account_id, listed_at DESC);

CREATE INDEX ix_resale_txn_listing
    ON tm_axs.resale_transaction (resale_listing_id);
CREATE INDEX ix_resale_txn_payout_due
    ON tm_axs.resale_transaction (sold_at)
    WHERE payout_status IN ('pending', 'scheduled');

-- -------------------------------------------------------------------------
-- Payments and refunds.
-- -------------------------------------------------------------------------
CREATE INDEX ix_payment_order
    ON tm_axs.payment (sales_order_id);
CREATE INDEX ix_payment_method_ref
    ON tm_axs.payment (payment_method_id)
    WHERE payment_method_id IS NOT NULL;
-- Captured but not yet settled: the daily settlement reconciliation.
CREATE INDEX ix_payment_unsettled
    ON tm_axs.payment (captured_at)
    WHERE payment_status = 'captured';

CREATE INDEX ix_payment_txn_payment
    ON tm_axs.payment_transaction (payment_id, occurred_at DESC);
-- Decline analysis by gateway response.
CREATE INDEX ix_payment_txn_declines
    ON tm_axs.payment_transaction (occurred_at, response_code)
    WHERE NOT is_approved;

CREATE INDEX ix_refund_order
    ON tm_axs.refund (sales_order_id);
CREATE INDEX ix_refund_payment
    ON tm_axs.refund (payment_id) WHERE payment_id IS NOT NULL;
CREATE INDEX ix_refund_order_line
    ON tm_axs.refund (order_line_id) WHERE order_line_id IS NOT NULL;
CREATE INDEX ix_refund_ticket
    ON tm_axs.refund (ticket_id) WHERE ticket_id IS NOT NULL;
-- The refund approval queue.
CREATE INDEX ix_refund_pending
    ON tm_axs.refund (requested_at)
    WHERE refund_status IN ('pending', 'approved');

-- -------------------------------------------------------------------------
-- Scans. Indexes are created on the partitioned parent, so PostgreSQL builds
-- and maintains a matching local index on every partition, including ones
-- attached later.
-- -------------------------------------------------------------------------
-- Gate throughput for an event: the primary post-event analysis query.
CREATE INDEX ix_scan_event_time
    ON tm_axs.scan (event_id, scanned_at);

CREATE INDEX ix_scan_access_point_time
    ON tm_axs.scan (access_point_id, scanned_at);

-- Duplicate-barcode investigation: the fraud path.
CREATE INDEX ix_scan_barcode
    ON tm_axs.scan (barcode_id, scanned_at)
    WHERE barcode_id IS NOT NULL;

CREATE INDEX ix_scan_credential
    ON tm_axs.scan (credential_id, scanned_at)
    WHERE credential_id IS NOT NULL;

-- Rejected scans only -- a small fraction of rows and the ones anyone reads
-- individually.
CREATE INDEX ix_scan_rejected
    ON tm_axs.scan (event_id, scan_result, scanned_at)
    WHERE scan_result <> 'admitted';

-- The ingestion watermark is uploaded_at, not scanned_at, because offline
-- readers backfill. This index is what makes incremental extraction cheap.
CREATE INDEX ix_scan_uploaded_at
    ON tm_axs.scan (uploaded_at);

-- -------------------------------------------------------------------------
-- Credentials, screening, incidents.
-- -------------------------------------------------------------------------
CREATE INDEX ix_credential_type_validity
    ON tm_axs.credential (credential_type, valid_to)
    WHERE revoked_at IS NULL;
CREATE INDEX ix_credential_sfsf
    ON tm_axs.credential (sfsf_person_id) WHERE sfsf_person_id IS NOT NULL;
CREATE INDEX ix_credential_sfdc
    ON tm_axs.credential (sfdc_contact_id) WHERE sfdc_contact_id IS NOT NULL;

CREATE INDEX ix_cred_assignment_credential
    ON tm_axs.credential_assignment (credential_id);
CREATE INDEX ix_cred_assignment_zone
    ON tm_axs.credential_assignment (access_zone_id);
CREATE INDEX ix_cred_assignment_event
    ON tm_axs.credential_assignment (event_id) WHERE event_id IS NOT NULL;

CREATE INDEX ix_screening_event_checkpoint
    ON tm_axs.screening_event (screening_checkpoint_id, screened_at);
CREATE INDEX ix_screening_event_event
    ON tm_axs.screening_event (event_id, screened_at);

CREATE INDEX ix_incident_event
    ON tm_axs.security_incident (event_id) WHERE event_id IS NOT NULL;
CREATE INDEX ix_incident_venue_occurred
    ON tm_axs.security_incident (venue_ref_id, occurred_at DESC);
CREATE INDEX ix_incident_open
    ON tm_axs.security_incident (severity, occurred_at DESC)
    WHERE incident_status IN ('open', 'under_review', 'escalated');

CREATE INDEX ix_ejection_incident
    ON tm_axs.ejection (security_incident_id);
CREATE INDEX ix_ejection_event
    ON tm_axs.ejection (event_id);
CREATE INDEX ix_ejection_customer
    ON tm_axs.ejection (customer_account_id) WHERE customer_account_id IS NOT NULL;
-- Active bans, checked at purchase and at the gate.
CREATE INDEX ix_ejection_active_bans
    ON tm_axs.ejection (customer_account_id, ban_expires_on)
    WHERE ban_issued AND customer_account_id IS NOT NULL;

CREATE INDEX ix_event_day_log_event_time
    ON tm_axs.event_day_log (event_id, logged_at);
CREATE INDEX ix_event_day_log_venue
    ON tm_axs.event_day_log (venue_ref_id);
CREATE INDEX ix_event_day_log_followup
    ON tm_axs.event_day_log (logged_at)
    WHERE requires_followup;

-- -------------------------------------------------------------------------
-- Incremental extraction. Every table the ingestion layer reads needs an
-- index on its watermark column or the nightly extract degrades into a full
-- scan as the table grows.
-- -------------------------------------------------------------------------
CREATE INDEX ix_event_updated_at           ON tm_axs.event (updated_at);
CREATE INDEX ix_customer_updated_at        ON tm_axs.customer_account (updated_at);
CREATE INDEX ix_order_updated_at           ON tm_axs.sales_order (updated_at);
CREATE INDEX ix_order_line_updated_at      ON tm_axs.order_line (updated_at);
CREATE INDEX ix_ticket_updated_at          ON tm_axs.ticket (updated_at);
CREATE INDEX ix_ticket_inventory_updated_at ON tm_axs.ticket_inventory (updated_at);
CREATE INDEX ix_payment_updated_at         ON tm_axs.payment (updated_at);
CREATE INDEX ix_refund_updated_at          ON tm_axs.refund (updated_at);
CREATE INDEX ix_incident_updated_at        ON tm_axs.security_incident (updated_at);
