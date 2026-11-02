# `hudl` — SportsCode / Hudl

Tier **A**. 22 base tables, owning **5** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **Client-generated UUIDs**, because an analyst codes a match offline and syncs later. A sequence cannot survive that.
- **The coded instance is the native unit.** Statistics are derived from instances, not entered.
- **`instance_label` has no target equivalent at all.** It is what a coded event means, and the target `scoring_event` has fixed columns.
- **One game has several timelines.** Different analysts disagree, so the extract must pick the primary one or double-count every goal.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `athlete.injury_record` | `injury_note`, `wearable_session` | `join` | medium |
| `athlete.performance_stat` | `player_game_metric`, `metric_definition`, `game` | `join` | high |
| `event.match_result` | `game`, `game_participant` | `join` | high |
| `event.participant` | `game_participant`, `player`, `team` | `join` | medium |
| `event.scoring_event` | `instance`, `instance_label`, `timeline` | `join` | high |

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
bash tools/load.sh hudl
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
