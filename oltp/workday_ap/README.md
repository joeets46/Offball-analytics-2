# `workday_ap` — Workday Adaptive Planning

Tier **B**. 12 base tables, owning **2** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **It is a cube, not a set of entities.** One fact table addressed by six dimensions; nothing corresponds to a business document.
- **Versions are first-class.** Actuals, budget, forecast and scenarios coexist for the same intersection, and the target `finance.budget` has one amount column.
- **Values are signed by convention per account.** Revenue is negative in many Adaptive models, and missing the flip inverts the P&L.
- **Tier B**: abbreviated depth by design.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `athlete.salary_cap_entry` | `cell_value`, `account`, `dimension_value` | `join` | medium |
| `finance.budget` | `model`, `version`, `cell_value`, `account`, `time_period` | `join` | high |

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
bash tools/load.sh workday_ap
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
