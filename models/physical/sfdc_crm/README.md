# `sfdc_crm` — Salesforce CRM

Tier **A**. 26 base tables, owning **26** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../../docs/05-source-systems.md](../../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **`CHAR(18)` record IDs** -- 15 case-sensitive characters plus a 3-character checksum. Both forms circulate, and mixing them is a standing integration bug.
- **Replication is on `SystemModstamp`, not `LastModifiedDate`.** The former moves on platform-driven changes the latter misses, so an extract keyed on the wrong column silently loses rows.
- **`IsDeleted` is the Recycle Bin**, not a deletion. Records stay queryable for 15 days.
- **`RecordTypeId` is load-bearing.** Six target tables are `account` filtered by record type; the seed rows in `record_type` are not illustrative, the mapping depends on them.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `athlete.agency` | `account` | `1:1` | medium |
| `athlete.agent` | `contact` | `1:1` | medium |
| `athlete.agent_relationship` | `account_contact_relation`, `contact` | `join` | high |
| `broadcast.licensee` | `account` | `1:1` | medium |
| `broadcast.media_rights_deal` | `contract`, `contract_line_item`, `account` | `join` | high |
| `broadcast.rights_holder` | `account` | `1:1` | medium |
| `broadcast.streaming_subscription` | `contract`, `sales_order`, `sales_order_item` | `join` | medium |
| `fan.account` | `account`, `contact` | `join` | high |
| `fan.campaign` | `campaign` | `1:1` | medium |
| `fan.club` | `account`, `product2` | `join` | medium |
| `fan.club_membership` | `account_contact_relation` | `1:1` | low |
| `fan.loyalty_enrollment` | `contract`, `contract_line_item` | `join` | medium |
| `fan.loyalty_program` | `product2`, `pricebook_entry` | `join` | medium |
| `fan.loyalty_transaction` | `sales_order`, `sales_order_item` | `join` | medium |
| `fan.service_case` | `service_case`, `service_case_comment`, `task` | `join` | high |
| `sponsorship.activation` | `campaign`, `asset` | `join` | high |
| `sponsorship.activation_fulfillment` | `campaign_member`, `task` | `join` | high |
| `sponsorship.ad_inventory` | `product2`, `pricebook_entry`, `asset` | `join` | medium |
| `sponsorship.deal` | `opportunity`, `contract` | `join` | high |
| `sponsorship.deal_term` | `contract_line_item`, `opportunity_line_item` | `join` | high |
| `sponsorship.inventory_allocation` | `opportunity_line_item`, `asset` | `join` | high |
| `sponsorship.inventory_unit` | `product2`, `pricebook_entry` | `join` | medium |
| `sponsorship.naming_right` | `contract`, `contract_line_item` | `join` | medium |
| `sponsorship.performance_metric` | `campaign` | `derive` | medium |
| `sponsorship.property` | `product2` | `1:1` | medium |
| `sponsorship.sponsor` | `account` | `1:1` | high |

### Low-confidence mappings

No real system of record exists for these; this schema models only
part of the concept.

- **`fan.club_membership`** — Minimal affinity signal; modeled as a Salesforce account-contact relation

## Files

| File | Contents |
|---|---|
| `ddl/00_schema.sql` | Schema creation and the schema `COMMENT` |
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
bash tools/load.sh sfdc_crm
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
