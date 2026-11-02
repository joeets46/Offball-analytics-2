# Target physical conventions, as constraints on the source

A checklist rather than an essay. Each row is a property of the upstream
Databricks MVM, what it requires of this source tier, and where that
requirement is satisfied.

The reasoning behind each is in
[../docs/04-physical-model-target.md](../docs/04-physical-model-target.md).

## Declared conventions

Taken verbatim from `model.model_conventions`:

| Convention | Value |
|---|---|
| `data_asset_naming_convention` | `snake_case` |
| `primary_key_suffix` | `_id` |
| `table_id_type` | `BIGINT` |
| `boolean_format` | Boolean (True/False) |
| `date_format` | `yyyy-MM-dd` |
| `timestamp_format` | `yyyy-MM-dd'T'HH:mm:ss.SSSXXX` |
| `data_classification_levels` | `restricted`, `confidential`, `internal`, `public` |
| `schema_prefix` / `schema_suffix` | none |
| `tag_prefix` | `dbx_` |
| `housekeeping_columns` | *(declared empty)* |
| `history_tracking_columns` | *(declared empty)* |

The last two being empty is worth noting: the model declares no housekeeping or
history-tracking convention, yet individual column comments say
`updated_timestamp` is "required for incremental data pipeline processing".
The requirement is real but is not expressed in the conventions, so this tier
treats it as binding anyway.

## Requirements on the source tier

| # | Target property | What the source must provide | Where |
|--:|---|---|---|
| 1 | Uniform `BIGINT` `_id` keys | A mapping from every system-local key to a canonical surrogate | `common.entity_xref`, `common.canonical_entity` |
| 2 | Constraints are informational, not enforced | Real enforcement, since the target will not catch anything | 341 PKs, 504 FKs, 925 CHECKs, 150 UNIQUEs |
| 3 | 1,477 cross-domain FKs | Business-key columns plus resolution, because these cross databases | Unenforced `*_code` / `*_id` columns; no FK crosses a schema |
| 4 | `source_system_code` per table | A registry of all ten systems — the target enum names only five | `common.source_system` |
| 5 | `created_timestamp` / `updated_timestamp` | A watermark maintained by trigger, not by application code | `common.touch_updated_at()`, per-schema variants |
| 6 | No tombstone mechanism | A change log, so deletes are observable | `<schema>._change_log` |
| 7 | `TIMESTAMP` with offset | `TIMESTAMPTZ` throughout; never a naive timestamp | All ten schemas |
| 8 | Value domains as bare `STRING` | The enumerations restored as reference tables or CHECKs | 43 reference tables, 619 CHECKs, 55 DOMAIN types |
| 9 | 4 classification levels | Columns classified, and PII separated where the platform allows | 3 PII satellites, 3 roles with differing grants |
| 10 | Denormalized, 6 associative tables | The many-to-many relationships restored | 32 associative entities in the logical model |

## Type mapping

Source (`model.json`) to target to this tier:

| `model.json` | Target DDL | This tier | Note |
|---|---|---|---|
| `STRING` | `STRING` | `VARCHAR(n)` or `TEXT` | Sized from the declared regex where one exists |
| `BIGINT` | `BIGINT` | `BIGINT` | |
| `INT` | **`STRING`** | `INTEGER` | The target DDL degrades 215 of these; `model.json` is right |
| `BOOLEAN` | `BOOLEAN` | `BOOLEAN` | |
| `DATE` | `DATE` | `DATE` | |
| `TIMESTAMP` | `TIMESTAMP` | `TIMESTAMPTZ` | Always zoned |
| `DECIMAL(p,s)` | **`DECIMAL(18,2)`** | `NUMERIC(p,s)` | The target DDL flattens 113 of these; `model.json` is right |

The two bold cells are the measured upstream defect. At `DECIMAL(18,2)`,
latitude and longitude locate a venue to about a kilometre.

## Load sequence

What a pipeline has to do, in order. This repository does not automate it.

1. **Extract** per the pattern in
   [../docs/07-integration-contract.md](../docs/07-integration-contract.md):
   CDC where available, watermark polling otherwise, `_change_log` for deletes.
2. **Resolve identity** through `common.entity_xref` before loading any fact.
   Twelve entities need it; loading a fact before its canonical key exists
   produces orphans the target will not reject.
3. **Apply the transform** the mapping names — `1:1`, `join`, `union`, `pivot`,
   `derive`, `scd2`. 105 of 153 are joins, a direct consequence of the
   header/line splits in the source systems.
4. **Stamp `source_system_code`.** Widen the target enum first, or lose
   provenance for seven of the ten systems.
5. **Leave the 213 unresolved foreign keys null.** They point at out-of-scope
   tables and are documented in
   [../mapping/lineage.md](../mapping/lineage.md).
