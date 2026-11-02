# Target model

The target is the upstream **Databricks Sports Entertainment Lakehouse Data
Model (MVM)**.

It is deliberately **not vendored into this repository**.

## Why not

Three reasons, in order of weight:

1. **It would drift.** The upstream model is generated and versioned; a copy
   here would diverge the first time it changed, and a stale copy is worse than
   a link.
2. **It adds no information.** 200 tables of generated DDL that this project
   does not author, cannot improve, and has no business restating.
3. **It is already authoritative where it lives.** The point of this
   repository is the *source* tier and the mapping between the two, not a
   second copy of the destination.

## Where it is

<https://github.com/databricks-industry-solutions/lakehouse-industry-data-models/tree/main/data-models/sports_entertainment/v1/mvm>

The artifacts worth knowing about:

| Path | What it is |
|---|---|
| `model.json` | The full model as data: 14 domains, 200 tables, 9,102 columns, with every column's type, value domain, tags and `references` provenance. **The authoritative artifact** |
| `schemas/*.sql` | Deployable Databricks DDL, one file per domain |
| `diagram/*.txt` | DBML of the whole model |
| `docs/*.csv`, `*.xlsx` | The model as a spreadsheet |
| `metrics/*.sql` | 130 metric view definitions |
| `ontology/*.ttl` | RDF/Turtle ontology |
| `readme.md` | Generated documentation |

**Prefer `model.json` over `schemas/*.sql`.** The two disagree on 12.9% of
columns, and `model.json` is the one that preserves intent — see
[../docs/04-physical-model-target.md](../docs/04-physical-model-target.md) for
the measurement.

## How this project uses it

`model.json` is cached at `tools/.cache/mvm_model.json` (7 MB, gitignored) and
read by the derivation tooling. Everything in `tools/derived/` comes from it,
and nothing about the target model is hand-typed anywhere in this repository.

To fetch or refresh the cache:

```bash
mkdir -p tools/.cache
curl -s https://raw.githubusercontent.com/databricks-industry-solutions/lakehouse-industry-data-models/main/data-models/sports_entertainment/v1/mvm/model.json   -o tools/.cache/mvm_model.json
uv run offball-extract
```

## What is here instead

| File | Contents |
|---|---|
| [physical-target-conventions.md](physical-target-conventions.md) | The target's physical conventions, stated as constraints the source tier has to satisfy |

The fuller treatment, including the two measured defects and the catalogue of
facts the target cannot represent, is in
[../docs/04-physical-model-target.md](../docs/04-physical-model-target.md).
