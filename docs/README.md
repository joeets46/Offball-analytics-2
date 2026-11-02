# Documentation index

Read in order for the full argument, or jump to what you need.

## The four model layers

| # | Doc | The layer |
|--:|---|---|
| 01 | [01-conceptual-model.md](01-conceptual-model.md) | 38 business entities, 5 subject areas, no attributes |
| 02 | [02-logical-model.md](02-logical-model.md) | 169 entities in 3NF, supertypes, 32 associative entities |
| 03 | [03-physical-model-oltp.md](03-physical-model-oltp.md) | 10 PostgreSQL 18 schemas, 255 tables |
| 04 | [04-physical-model-target.md](04-physical-model-target.md) | The upstream Databricks model as a constraint, plus its two measured defects |

## Reference

| # | Doc | Contents |
|--:|---|---|
| 05 | [05-source-systems.md](05-source-systems.md) | The ten systems, how ownership was assigned, what makes each distinctive |
| 06 | [06-conventions.md](06-conventions.md) | Naming, keys, types, value domains, privacy, audit, constraints, indexes, partitioning |
| 07 | [07-integration-contract.md](07-integration-contract.md) | The five hard problems a pipeline has to solve, and the per-system traps |
| 08 | [08-scope-boundary.md](08-scope-boundary.md) | Why 47 of 200 target tables are out of scope, and the one compromise |

## Elsewhere in the repository

| Location | Contents |
|---|---|
| [../conceptual/](../conceptual/) | Subject areas and the conceptual ERD |
| [../logical/](../logical/) | Five DBML files and the logical ERDs |
| [../oltp/](../oltp/) | The DDL, one directory per system |
| [../mapping/](../mapping/) | Table-level, column-level, out-of-scope, and [lineage.md](../mapping/lineage.md) |
| [../dictionary/](../dictionary/) | Generated data dictionary |
| [../target/](../target/) | The upstream model, documented rather than vendored |
| [../README.md](../README.md) | How to run everything |

## If you only read three things

1. [08-scope-boundary.md](08-scope-boundary.md) — what this model does *not*
   cover, and why that is a measured decision rather than an omission.
2. [04-physical-model-target.md](04-physical-model-target.md) — the catalogue
   of facts the target model cannot represent, which is the whole argument for
   building the source tier at all.
3. [07-integration-contract.md](07-integration-contract.md) — the five hard
   problems, because they are what makes this an integration project rather
   than a schema exercise.
