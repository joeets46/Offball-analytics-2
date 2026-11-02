# Mapping

Source-to-target mapping between the ten OLTP schemas and the upstream
Databricks MVM.

| File | Rows | Coverage |
|---|--:|---|
| [table_level_mapping.csv](table_level_mapping.csv) | 153 | Every in-scope target table |
| [out_of_scope.csv](out_of_scope.csv) | 47 | Every excluded target table, with the reason and what would be needed |
| [column_level_key_tables.csv](column_level_key_tables.csv) | 1,438 | Every column of 31 key tables |
| [lineage.md](lineage.md) | — | The narrative: transforms, confidence, the 15 low-confidence calls, the 213 unresolved foreign keys |

The first two together account for exactly 200 tables. Nothing is silently
unmapped.

## Columns in table_level_mapping.csv

| Column | Contents |
|---|---|
| `mvm_domain`, `mvm_subdomain`, `mvm_table` | The target table |
| `mvm_type` | Upstream classification: master, transactional, reference, associative |
| `mvm_primary_key`, `mvm_attribute_count` | Target key and width |
| `source_system`, `source_system_name` | The owning system of record |
| `source_tables` | The native tables that feed it, as `schema.table` |
| `transform_type` | `1:1`, `join`, `union`, `pivot`, `derive`, `scd2` |
| `grain_change` | What the transform does to the grain |
| `confidence` | `high`, `medium`, `low` |
| `notes` | Why, where the assignment needs explaining |

## Reading it

Start with `confidence` and `transform_type`. Those two columns tell you where
the work and the risk are:

- **`confidence = low`** (15 rows) means no real system of record exists for
  the concept. Each one says what is missing.
- **`transform_type = derive`** (8 rows) means there is no source row to copy —
  the target row has to be computed, and the computation is the deliverable.

In `column_level_key_tables.csv`, start with `mapping_status`. The 353
`identity_resolution` rows are surrogate keys that no source system provides;
they are created during identity resolution, not mapped. The 625
`needs_review` rows are labelled as a starting point rather than presented as
a mapping, because a guess dressed up as an answer is worse than a blank.

## Regenerating

```bash
uv run offball-mapping          # table level + out of scope
uv run offball-column-mapping   # column level
uv run offball-check            # assert completeness against scope and DDL
```

`offball-check` verifies that every source table named here actually exists in
`oltp/`. It has already caught two phantom tables that existed only in the
mapping.
