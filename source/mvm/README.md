# `source/mvm` — the upstream model, vendored

A **verbatim copy** of the Databricks Industry Solutions Sports Entertainment
MVM data model. Nothing in this directory is edited, reformatted or
regenerated. It is an input.

## Provenance

| | |
|---|---|
| Repository | [databricks-industry-solutions/lakehouse-industry-data-models](https://github.com/databricks-industry-solutions/lakehouse-industry-data-models) |
| Path | `data-models/sports_entertainment/v1/mvm` |
| Commit | `b8595c93593d03ed647791a6b64fcafeb6322dbb` (2026-07-18) |
| Copied | 2026-11-02 |
| Files | 39, 22.9 MB |

Every file was size-verified against the GitHub tree API on download, and
`model.json` is byte-identical to the copy the derived artifacts in
`tools/derived/` were originally built from.

## Why it is committed rather than downloaded

Three reasons, in order of how much they matter:

1. **The input cannot shift under the derived artifacts.** Everything in
   `tools/derived/`, `mapping/` and `models/physical/sql/01_common.sql` is
   generated from `model.json`. If that file is fetched at build time, the
   upstream `main` branch moving turns a reproducible derivation into a
   coincidence. The counts quoted throughout `docs/` are only checkable because
   this exact copy is here.
2. **The defect measurements stay reproducible.**
   [docs/04-physical-model-target.md](../../docs/04-physical-model-target.md)
   reports that 12.9% of columns disagree between `model.json` and the
   deployable DDL. Both sides of that comparison are in this directory, so
   anyone can re-run it offline.
3. **The project is self-contained.** `uv sync && uv run offball-extract`
   works with no network access.

`.gitattributes` marks this tree `-text linguist-vendored=true`: no line-ending
normalisation, and GitHub does not count it in the repository's language
statistics. The first of those is load-bearing — normalising line endings would
change the bytes and break claim 2.

## What is in here

| Path | What it is | Used by this project? |
|---|---|---|
| `model.json` | The machine-readable model: 14 domains, 200 tables, 9,102 columns, each with `type`, `value_regex`, `tags`, `foreign_key_to` and a `references` field naming its origin system | **Yes — the input of record.** Read by `tools/scope.py` |
| `schemas/*.sql` | Deployable Databricks DDL, one file per domain, plus the catalog definition and the 1,477 cross-domain foreign keys | **Yes** — the right-hand side of the type comparison in `docs/04` |
| `docs/sports_entertainment_model_v1_mvm.csv` | The same model flattened to one row per column | No — `model.json` is richer |
| `docs/..._v1_mvm.xlsx` | The CSV as a workbook | No |
| `docs/releasenotes.txt` | Upstream release notes | No |
| `diagram/..._dbml_v1_mvm.txt` | The whole model as DBML | No — but useful for comparing against [models/logical/](../../models/logical/), which re-normalizes it |
| `ontology/..._rdf_v1_mvm.ttl` | RDF/Turtle ontology | No |
| `metrics/*.sql` | The 130 metric view definitions | No — **out of scope**, see [docs/08-scope-boundary.md](../../docs/08-scope-boundary.md) |
| `vibes/*.txt` | Upstream planning notes | No |

The four files that matter are `model.json` and the `schemas/*.sql`. The rest is
kept because a partial copy is not a self-contained one, and because dropping
files invites the question of what else was dropped.

## Refreshing it

Only do this deliberately. A refresh changes the input every derived artifact is
built from, so the counts in `docs/` and the row counts in `mapping/` will move
with it.

```bash
# from the repository root
uv run offball-extract      # rebuild tools/derived/ from the new model.json
uv run offball-common       # rebuild models/physical/sql/01_common.sql
uv run offball-mapping
uv run offball-check        # this is what tells you whether anything broke
uv run pytest
```

Then update the commit SHA and date in the table above, and re-check any count
quoted in `docs/` or `README.md` that `offball-check` does not assert.

## Licence

The vendored content is Databricks' and carries the upstream repository's
licence, not this project's. See the upstream repository for terms.
