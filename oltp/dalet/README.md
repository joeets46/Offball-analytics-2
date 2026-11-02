# `dalet` — Dalet Galaxy

Tier **A**. 23 base tables, owning **20** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **`media_object` / `essence` split.** The object is editorial; an essence is one rendition. Six renditions are six rows here and one row in the target model.
- **Placeholders are normal.** An asset with no essence is created by the production order before anything is shot.
- **Metadata is data, not columns** -- fields, vocabularies and typed values, because a broadcaster extends its model monthly.
- **Rights windows carry territory arrays**, so the compliance question is a containment test and the columns are GIN-indexed.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `broadcast.blackout_rule` | `rights_window`, `publication_target` | `derive` | medium |
| `broadcast.broadcast_schedule` | `schedule_item`, `running_order`, `channel` | `join` | high |
| `broadcast.channel` | `channel` | `1:1` | high |
| `broadcast.live_feed` | `feed`, `essence` | `join` | high |
| `broadcast.media_asset` | `media_object`, `essence` | `join` | high |
| `broadcast.production` | `job`, `job_task` | `join` | high |
| `broadcast.rights_window` | `rights_window`, `rights_contract` | `join` | high |
| `content.asset` | `media_object`, `essence`, `metadata_value` | `join` | high |
| `content.asset_tag` | `tag_assignment`, `metadata_value` | `join` | medium |
| `content.category` | `folder` | `1:1` | medium |
| `content.collection` | `collection` | `1:1` | high |
| `content.collection_item` | `collection_member` | `1:1` | medium |
| `content.editorial_brief` | `editorial_brief` | `1:1` | high |
| `content.ingest_job` | `job`, `transfer`, `media_object` | `join` | high |
| `content.metadata_tag` | `metadata_field`, `vocabulary`, `vocabulary_term` | `join` | high |
| `content.platform_channel` | `publication_target`, `channel` | `join` | high |
| `content.production_order` | `job`, `job_task`, `media_object` | `join` | high |
| `content.publish_event` | `publication`, `publication_target` | `join` | high |
| `event.broadcast_window` | `schedule_item`, `channel` | `join` | high |
| `event.production_schedule` | `job`, `job_task`, `running_order` | `join` | high |

## Files

| File | Contents |
|---|---|
| `ddl/00_schema.sql` | Schema creation and the schema `COMMENT` |
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
bash tools/load.sh dalet
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
