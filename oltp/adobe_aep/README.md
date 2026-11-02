# `adobe_aep` — Adobe Experience Platform

Tier **A**. 21 base tables plus 8 partitions, owning **8** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **Identity is namespaced and plural.** A person has no single key; the target `fan.fan_profile` reduces all of it to one `BIGINT`.
- **Graph links are pairwise, probabilistic and revocable.** The target model has no concept of a disputed identity.
- **Experience events carry no foreign key to identity**, deliberately: events arrive before identities are registered, and a per-row check on the hottest write path is not viable.
- **Consent has three states** -- allow, deny, unknown -- because "not asked" is not "declined".

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `broadcast.audience_rating` | `experience_event`, `dataset` | `derive` | low |
| `compliance.data_processing_record` | `data_use_label`, `consent_policy`, `dataset`, `privacy_job` | `join` | medium |
| `fan.communication` | `journey`, `journey_step`, `journey_step_event` | `join` | high |
| `fan.consent_preference` | `consent_record`, `consent_policy` | `join` | high |
| `fan.engagement_event` | `experience_event`, `event_type_ref` | `join` | high |
| `fan.fan_profile` | `profile`, `identity`, `identity_map` | `join` | high |
| `fan.segment` | `segment_definition`, `audience` | `join` | high |
| `fan.segment_assignment` | `segment_membership` | `1:1` | high |

### Low-confidence mappings

No real system of record exists for these; this schema models only
part of the concept.

- **`broadcast.audience_rating`** — Panel ratings come from Nielsen-style providers; AEP only has owned-platform viewing

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
bash tools/load.sh adobe_aep
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
