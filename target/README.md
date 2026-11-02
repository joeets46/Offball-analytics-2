# Target model

The target is the upstream **Databricks Sports Entertainment Lakehouse Data
Model (MVM)**.

Its published artifacts are vendored verbatim at
[../source/mvm/](../source/mvm/), pinned to one upstream commit. What this
project deliberately does **not** do is *re-model* the target.

## Copied, not re-modeled

The distinction matters:

- **Copied**, because a fixed input is what makes the derivation reproducible.
  Every count in `docs/`, every row in `mapping/`, and the 55 `DOMAIN` types in
  `models/physical/sql/01_common.sql` are generated from
  `source/mvm/model.json`. Fetching that file at build time would make all of it
  contingent on the upstream `main` branch not moving.
- **Not re-modeled**, because 200 tables of generated target DDL are something
  this project does not author, cannot improve and has no business restating.
  The point of this repository is the *source* tier and the mapping between the
  two, not a second rendering of the destination.

So `target/` contains documentation, not DDL: the target's conventions stated as
constraints the source tier has to satisfy.

## Where it comes from

<https://github.com/databricks-industry-solutions/lakehouse-industry-data-models/tree/main/data-models/sports_entertainment/v1/mvm>

Pinned to commit `b8595c9` (2026-07-18). The artifacts worth knowing about, all
present under [../source/mvm/](../source/mvm/):

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

The upstream model is vendored at [../source/mvm/](../source/mvm/) and read from
there by the derivation tooling. Everything in `tools/derived/` comes from
`source/mvm/model.json`, and nothing about the target model is hand-typed
anywhere in this repository.

Because it is committed rather than downloaded, the derived artifacts can be
rebuilt offline and the input cannot shift under them:

```bash
uv run offball-extract
```

See [../source/mvm/README.md](../source/mvm/README.md) for provenance and how to
refresh the vendored copy.

## What is here instead

| File | Contents |
|---|---|
| [physical-target-conventions.md](physical-target-conventions.md) | The target's physical conventions, stated as constraints the source tier has to satisfy |

The fuller treatment, including the two measured defects and the catalogue of
facts the target cannot represent, is in
[../docs/04-physical-model-target.md](../docs/04-physical-model-target.md).
