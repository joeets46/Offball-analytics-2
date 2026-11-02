# `tm_axs` — Ticketmaster / AXS

Tier **A**. 42 base tables plus 16 partitions, owning **30** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **The scan stream is the highest-volume table in the estate.** One row per barcode or credential presentation, including every rejection, partitioned monthly.
- **Offline-captured scans arrive late.** Gate readers buffer when the network drops, so the extraction watermark is `uploaded_at`, not `scanned_at`.
- **`venue_ref` is deliberately a separate record** from `archtics.building` and `sap_s4.t001w`. All three describe the same building and none shares a key.
- **PII satellites** split identifying attributes from `customer_account` and `credential`, with separate grants.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `event.bracket` | `event_group` | `derive` | low |
| `event.calendar` | `season`, `event_group` | `join` | medium |
| `event.competition_round` | `event_group`, `event` | `derive` | low |
| `event.event_incident` | `security_incident`, `event_day_log` | `union` | medium |
| `event.fixture` | `event`, `event_type`, `venue_ref` | `join` | high |
| `event.tournament` | `event_group` | `1:1` | low |
| `event.type` | `event_type` | `1:1` | medium |
| `fan.payment_method` | `payment_method` | `union` | medium |
| `security.access_event` | `scan`, `access_point` | `join` | high |
| `security.access_zone` | `access_zone`, `access_point` | `join` | high |
| `security.credential` | `credential` | `1:1` | high |
| `security.credential_assignment` | `credential_assignment` | `1:1` | medium |
| `security.ejection_record` | `ejection`, `security_incident` | `join` | high |
| `security.screening_checkpoint` | `screening_checkpoint`, `access_point` | `join` | medium |
| `security.screening_event` | `screening_event` | `1:1` | medium |
| `security.security_incident` | `security_incident` | `1:1` | high |
| `ticketing.access_entitlement` | `ticket`, `barcode`, `delivery` | `join` | high |
| `ticketing.gate_scan` | `scan`, `access_point` | `join` | high |
| `ticketing.group_sale` | `group_sale`, `sales_order` | `join` | high |
| `ticketing.hold_allocation` | `inventory_hold`, `hold_code` | `join` | high |
| `ticketing.price_tier` | `price_scale`, `price_level` | `join` | high |
| `ticketing.price_zone` | `price_zone` | `1:1` | medium |
| `ticketing.refund` | `refund`, `payment_transaction` | `join` | high |
| `ticketing.resale` | `resale_listing`, `resale_transaction` | `join` | high |
| `ticketing.ticket_order` | `sales_order`, `customer_account` | `join` | high |
| `ticketing.ticket_order_line` | `order_line`, `ticket` | `join` | high |
| `ticketing.ticket_payment` | `payment`, `payment_transaction` | `join` | high |
| `ticketing.ticket_transfer` | `ticket_transfer`, `ticket` | `join` | high |
| `venue.event_day_ops` | `event_day_log` | `1:1` | medium |
| `venue.safety_incident` | `security_incident` | `1:1` | low |

### Low-confidence mappings

No real system of record exists for these; this schema models only
part of the concept.

- **`event.bracket`** — No system of record for bracket topology; derived from event_group nesting
- **`event.competition_round`** — Round/matchday is an event_group level in TM/AXS, not a first-class entity
- **`event.tournament`** — TM/AXS models tournaments only as event groupings, not as competition structures
- **`venue.safety_incident`** — Venue safety incidents overlap the TM/AXS security incident log; no EHS system named

## Files

| File | Contents |
|---|---|
| `ddl/00_schema.sql` | Schema creation and the schema `COMMENT` |
| `ddl/10_domains_and_enums.sql` | Local value domains restored as reference tables |
| `ddl/20_reference.sql` | Configuration and reference data |
| `ddl/30_master.sql` | Master data |
| `ddl/31_master_pii.sql` | One-to-one PII satellites, with separate grants |
| `ddl/40_transaction.sql` | Transactions, partitioned where volume warrants |
| `ddl/50_constraints.sql` | Foreign keys, declared last so one ordered pass loads |
| `ddl/60_indexes.sql` | Indexes serving named access paths |
| `ddl/70_audit.sql` | **GENERATED** -- watermark triggers, change log, role grants |
| `ddl/80_comments.sql` | Table descriptions, published by the data dictionary |

Numbered to load in order. `50_constraints.sql` runs after every table in
the schema exists, so a single forward pass works without deferred
constraints.

## Loading just this schema

```bash
bash tools/load.sh tm_axs
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
