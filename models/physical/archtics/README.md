# `archtics` — Archtics

Tier **A**. 23 base tables, owning **14** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../../docs/05-source-systems.md](../../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **A five-level seating hierarchy**: building, level, section, row, seat. The target model flattens it to three.
- **Manifests are reusable.** One configuration serves many events; `event_manifest` applies it to one. The target `venue.capacity_config` collapses both, losing the reuse.
- **Personal seat licences** are a property right in a seat, separable from any season ticket. No target table corresponds.
- **Capacity is a stated figure, not a count** -- it is signed off by the fire authority, which is why an approved manifest must carry a valid certificate.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `event.venue_assignment` | `event_manifest`, `building` | `join` | high |
| `fan.membership` | `sta_account`, `plan`, `renewal` | `join` | medium |
| `ticketing.season_ticket_account` | `sta_account`, `account_seat_assignment`, `psl` | `join` | high |
| `ticketing.season_ticket_package` | `plan`, `plan_seat` | `join` | high |
| `ticketing.ticket_inventory` | `event_manifest`, `manifest_section`, `seat` | `join` | high |
| `venue.accessibility_feature` | `accessibility_feature`, `seat_attribute` | `join` | medium |
| `venue.capacity_config` | `manifest`, `manifest_section` | `join` | high |
| `venue.config_section_allocation` | `manifest_section` | `1:1` | high |
| `venue.parking_activation` | `parking_activation`, `parking_inventory` | `join` | medium |
| `venue.parking_lot` | `parking_lot` | `1:1` | high |
| `venue.seat` | `seat`, `seat_row`, `seat_attribute_assignment` | `join` | high |
| `venue.seating_section` | `section`, `level` | `join` | high |
| `venue.suite` | `suite`, `suite_lease` | `join` | high |
| `venue.venue` | `building` | `1:1` | high |

## Files

| File | Contents |
|---|---|
| `ddl/00_schema.sql` | Schema creation and the schema `COMMENT` |
| `ddl/20_reference.sql` | Configuration and reference data |
| `ddl/30_master.sql` | Master data |
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
bash tools/load.sh archtics
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
