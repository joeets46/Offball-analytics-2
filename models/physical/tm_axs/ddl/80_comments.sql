-- =========================================================================
-- tm_axs -- table comments
--
-- One line per table, stating what it is and which target table it feeds.
-- These are the descriptions the generated data dictionary publishes
-- (dictionary/oltp_tables.csv), so a table with no comment becomes an empty
-- dictionary row. Tables whose comment is already set alongside their
-- definition are not repeated here.
-- =========================================================================

COMMENT ON TABLE tm_axs.sales_channel IS
    'Configured sales channels. Drives the fee schedule and settlement routing, and is operator-maintained rather than code-level.';
COMMENT ON TABLE tm_axs.delivery_method IS
    'How a ticket reaches its holder. Determines whether a barcode is issued at purchase or rotated at scan time, which changes the fraud model.';
COMMENT ON TABLE tm_axs.hold_code IS
    'Reasons inventory is withheld from sale. Held inventory is unsold revenue, so the categories are reported on directly.';
COMMENT ON TABLE tm_axs.event_type IS
    'Configured event classifications. Feeds target event.type; the category column is what the logical model turns into an event subtype.';
COMMENT ON TABLE tm_axs.season IS
    'A selling period, not a competition structure. Contributes to target event.calendar and target league.season.';
COMMENT ON TABLE tm_axs.event_group IS
    'Self-referencing hierarchy for series, tournaments, phases and rounds. Four target tables derive from this one structure, which is why three of them map at low confidence.';
COMMENT ON TABLE tm_axs.price_zone IS
    'Venue pricing zones, ranked by desirability. Feeds target ticketing.price_zone and is the axis dynamic pricing walks.';
COMMENT ON TABLE tm_axs.price_scale IS
    'A versioned price structure for one event. Versioned because dynamic pricing rescales during an on-sale and past orders must stay explicable.';
COMMENT ON TABLE tm_axs.promo_code IS
    'Promotional discount codes with redemption limits. Feeds the discount side of target ticketing.ticket_order.';
COMMENT ON TABLE tm_axs.access_zone IS
    'Venue access zones with nested clearance levels. Feeds target security.access_zone; a zone requires at least its clearance level on the presented credential.';
COMMENT ON TABLE tm_axs.access_point IS
    'Physical entry points -- turnstiles, doors, gates, mobile readers. Throughput drives queue modelling and doors-open planning.';
COMMENT ON TABLE tm_axs.screening_checkpoint IS
    'Security screening positions attached to an access point. Feeds target security.screening_checkpoint.';
COMMENT ON TABLE tm_axs.credential IS
    'Non-ticket access for staff, media, athletes, officials and vendors. Feeds target security.credential; clearance 4 and above requires a cleared background check.';
COMMENT ON TABLE tm_axs.credential_assignment IS
    'Which zones a credential reaches, per event or as a standing season assignment. Feeds target security.credential_assignment.';
COMMENT ON TABLE tm_axs.inventory_hold IS
    'Inventory withheld from sale, either seat-specific or as a block count against a zone. Feeds target ticketing.hold_allocation, which flattens both shapes.';
COMMENT ON TABLE tm_axs.group_sale IS
    'Group bookings with a committed quantity and negotiated discount. Feeds target ticketing.group_sale.';
COMMENT ON TABLE tm_axs.order_line IS
    'Order lines. Feeds target ticketing.ticket_order_line; a seat-specific line sells exactly one seat.';
COMMENT ON TABLE tm_axs.ticket IS
    'The issued entitlement. Seat labels are copied on at issue so a later manifest change cannot rewrite what the ticket said.';
COMMENT ON TABLE tm_axs.delivery IS
    'Delivery attempts per ticket. Separate from the ticket so a delivery can be retried without reissuing the entitlement.';
COMMENT ON TABLE tm_axs.ticket_transfer IS
    'Ticket transfers between accounts. Offered to an email address before a recipient account necessarily exists, which is why the recipient is nullable.';
COMMENT ON TABLE tm_axs.resale_listing IS
    'Verified resale listings with the price cap in force recorded, so a listing can be explained after the fact.';
COMMENT ON TABLE tm_axs.resale_transaction IS
    'Completed resales and the seller payout. The platform fee splits between venue, league and operator by rules held in the settlement engine.';
COMMENT ON TABLE tm_axs.payment IS
    'Payment intent and its settled state per order. Feeds target ticketing.ticket_payment.';
COMMENT ON TABLE tm_axs.payment_transaction IS
    'Every gateway attempt, including declines. The target model keeps only the settled result, so an order that took four declines looks identical to one that worked first time.';
COMMENT ON TABLE tm_axs.refund IS
    'Refunds with the fee split retained, because fees are frequently non-refundable except on cancellation and the distinction has to survive into the ledger.';
COMMENT ON TABLE tm_axs.ejection IS
    'Ejections arising from a security incident. Neither the ticket nor the account is mandatory: an ejected person is often unidentified.';
COMMENT ON TABLE tm_axs.event_day_log IS
    'Event-day operations log with snapshot gate counters. Feeds target venue.event_day_ops and unions into target event.event_incident.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE tm_axs.venue_ref IS
    'The venue as TM/AXS holds it. Deliberately a separate record from archtics.building and sap_s4.t001w: all three describe the same building and none shares a key, which is the clearest illustration of why the target venue_id is a product of integration.';
COMMENT ON TABLE tm_axs.customer_account IS
    'Ticketing accounts. One of four places the same human exists; identifying attributes live in customer_account_pii so operational queries never read restricted data.';
COMMENT ON TABLE tm_axs.customer_account_pii IS
    'One-to-one PII satellite of customer_account. Separate grants, and the DSAR erasure target for this system.';
COMMENT ON TABLE tm_axs.credential_pii IS
    'One-to-one PII satellite of credential. Holds a biometric template reference rather than a template, so the appliance stays the only system holding biometrics.';
COMMENT ON TABLE tm_axs.price_level IS
    'Price points within a scale and zone, with the face value, fee, facility fee and tax kept apart because they settle to different parties.';
COMMENT ON TABLE tm_axs.sales_order IS
    'Ticket orders. Totals are denormalized onto the header because the gateway settles against the header, not the lines.';
