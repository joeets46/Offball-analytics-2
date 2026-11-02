# OFF-Ball — Source OLTP Data Models

Source transactional data models for the Databricks **Sports Entertainment
Lakehouse Data Model (MVM)**, with the conceptual, logical and physical layers
and a source-to-target mapping.

The upstream model lives at
[`databricks-industry-solutions/lakehouse-industry-data-models`](https://github.com/databricks-industry-solutions/lakehouse-industry-data-models/tree/main/data-models/sports_entertainment/v1/mvm).
It is a denormalized Silver-layer analytical model — **a destination, with no
upstream**. This repository reconstructs the transactional tier that would feed
it.

## Why this isn't invented

The upstream model declares its own provenance in two places, which makes the
source tier *derivable* rather than guessed:

1. `model.operational_systems_of_records` names **10 real operational systems**.
2. Every one of its 9,102 columns carries a `references` field naming the system
   or standard it came from — e.g. `fixture.actual_attendance` →
   *"Ticketmaster/AXS Gate Scan Reconciliation"*.

So each of the 153 in-scope target tables is assigned to an owning system by
*measuring* how often each system is named in that table's own column metadata,
then reviewing the result by hand. The measurement lives in
`tools/derived/mvm_tables.csv`; the reviewed result lives in
`tools/ownership.py`.

## What's here

| Layer | Location | What it is |
|---|---|---|
| **Conceptual** | [models/conceptual/](models/conceptual/) | ~38 business entities in 5 subject areas, no attributes, M:N unresolved |
| **Logical** | [models/logical/](models/logical/) | Platform-neutral 3NF: supertypes, resolved associative entities, normalized value domains |
| **Physical (source)** | [models/physical/](models/physical/) | **10 PostgreSQL 18 schemas**, one per system of record, each in its native idiom |
| **Physical (target)** | [target/](target/) | The upstream Silver-layer model as a constraint on the sources — copied verbatim to [source/mvm/](source/mvm/), documented here, not re-modeled |
| **Mapping** | [mapping/](mapping/) | Table-level for all 153 in-scope tables, column-level for the key ones, plus the 47 excluded |
| **Dictionary** | [dictionary/](dictionary/) | Every OLTP table and column with its description, generated from the live database |
| **Docs** | [docs/](docs/) | Conventions, the ten systems, the scope boundary, the ingestion contract |

## The numbers

Regenerate with `uv run offball-extract`; they are never hand-typed.

| | |
|---|---|
| Upstream MVM tables | **200** (14 domains, 9,102 columns, 2,034 FKs) |
| In scope | **153** |
| Out of scope | **47** — see [docs/08-scope-boundary.md](docs/08-scope-boundary.md) |
| Source systems modeled | **10**, exactly those the upstream model names |
| OLTP tables built | **255 base + 20 partitions** |
| Foreign keys | 504 |
| CHECK constraints | 925 |
| Shared `DOMAIN` types | 55, derived from the model's own regex metadata |
| Indexes | 1,431 |

## Running it

Requires [uv](https://docs.astral.sh/uv/) and Docker.

```bash
# 1. Install the tooling (creates .venv)
uv sync --extra test

# 2. Start PostgreSQL 18 on localhost:55432
docker compose up -d

# 3. Load the whole model
psql "postgresql://offball:offball@localhost:55432/offball" \
     -v ON_ERROR_STOP=1 -f models/physical/sql/00_create_all.sql

# 4. Verify
uv run pytest
```

No local `psql`? The loader script does the same thing through the container:

```bash
bash tools/load.sh            # all ten schemas
bash tools/load.sh tm_axs     # just one
```

Copy `.env.example` to `.env` to change ports or credentials. The compose file
reads it; nothing in the repository contains a real secret.

## Regenerating the derived artifacts

Everything derived from the upstream model is generated, in this order:

```bash
uv run offball-extract      # source/mvm  -> tools/derived/*.csv + summary.json
uv run offball-common       # derived     -> models/physical/sql/01_common.sql
uv run offball-mapping      # ownership   -> mapping/*.csv
uv run offball-audit        # physical DDL -> models/physical/*/ddl/70_audit.sql
uv run offball-check        # assertions across mapping, scope and DDL
uv run offball-dictionary   # live database -> dictionary/*.csv
```

`offball-check` is the one to run after any change. It asserts that the mapping
and the exclusion register together account for exactly 200 tables, that every
source table named in the mapping **actually exists in the DDL**, and that no
foreign key crosses a system boundary. It has already caught two phantom tables
that existed only in the mapping.

The upstream model is **vendored** at [source/mvm/](source/mvm/), so no network
access is needed to regenerate anything. `source/mvm/model.json` is the input of
record; see [source/mvm/README.md](source/mvm/README.md) for its provenance and
how to refresh it.

## The ten source systems

Tier A carries full DDL; Tier B is abbreviated by design (see
[docs/05-source-systems.md](docs/05-source-systems.md)).

| Schema | System | Tier | Target tables | Native idiom worth seeing |
|---|---|:--:|:--:|---|
| [`sap_s4`](models/physical/sap_s4/) | SAP S/4HANA FI/CO/MM/SD | A | 33 | Real SAP names (`bkpf`/`bseg`), `MANDT` leading every key, unsigned amounts with a separate debit/credit character |
| [`tm_axs`](models/physical/tm_axs/) | Ticketmaster / AXS | A | 30 | Partitioned scan stream, rotating barcodes, offline-captured scans arriving late |
| [`sfdc_crm`](models/physical/sfdc_crm/) | Salesforce CRM | A | 26 | `CHAR(18)` IDs, `__c` custom fields, `IsDeleted` Recycle Bin, `SystemModstamp` replication |
| [`dalet`](models/physical/dalet/) | Dalet Galaxy | A | 20 | media_object / essence split, metadata as data, rights windows with territory arrays |
| [`archtics`](models/physical/archtics/) | Archtics | A | 14 | Five-level seating hierarchy, reusable manifests, personal seat licences |
| [`adobe_aep`](models/physical/adobe_aep/) | Adobe Experience Platform | A | 8 | Namespaced identities, probabilistic graph links, XDM in JSONB, immutable event stream |
| [`shopify`](models/physical/shopify/) | Shopify Plus | A | 8 | Platform-assigned IDs (no `IDENTITY`), negative discount values, three independent order lifecycles |
| [`hudl`](models/physical/hudl/) | SportsCode / Hudl | A | 5 | Client-generated UUIDs, coded instances on a video timeline, statistics derived from labels |
| [`sap_sfsf`](models/physical/sap_sfsf/) | SAP SuccessFactors | B | 7 | Effective-dated everything; compensation as components, not salary |
| [`workday_ap`](models/physical/workday_ap/) | Workday Adaptive Planning | B | 2 | A cube, not entities: one fact table, versions as a dimension, sign-flipped accounts |

## Things the source tier can say that the target model cannot

The point of building the upstream side is that it makes the cost of
denormalization visible. A sample, each documented at the relevant table:

- **A payment that took four declines before succeeding** looks identical to one
  that worked first time. `tm_axs.payment_transaction` keeps the attempts;
  `ticketing.ticket_payment` keeps the result.
- **Why a sponsorship deal was lost.** `sfdc_crm.opportunity.loss_reason__c` has
  no target column, so the lakehouse reports what was won and nothing about what
  was not.
- **What a statistic is made of.** `hudl.instance_label` holds the five labels
  that make a coded instance a "shot, right foot, inside box, on target, goal".
  `athlete.performance_stat` receives the count.
- **Which rendition.** A 4K master and five derived cutdowns are six
  `dalet.essence` rows under one `media_object`; `content.asset` is one row, so
  storage cost reporting is not possible downstream.
- **A consent that was never asked for** versus one that was declined.
  `adobe_aep.consent_record` has three states; `fan.consent_preference` has a
  boolean.

## Two defects found in the upstream model

Both measured, not asserted — see
[docs/04-physical-model-target.md](docs/04-physical-model-target.md).

1. **12.9% of columns disagree between `model.json` and the deployable DDL.**
   215 `INT` columns are emitted as `STRING` (scores, attendances, counts) and
   113 `DECIMAL(p,s)` columns are flattened to `DECIMAL(18,2)` — which leaves
   latitude and longitude at two decimal places, roughly a kilometre. This model
   uses the `model.json` types, which preserve intent.
2. **`source_system_code` is constrained to five values**
   (`TICKETMASTER|ARCHTICS|SAP_SD|MANUAL|LEAGUE_FEED`) while the same model names
   ten systems of record. `common.source_system` carries the full registry.

## Repository layout

```
source/mvm/        VENDORED — the upstream Databricks MVM, verbatim
                   model.json is the input every derived artifact is built from
models/
  conceptual/      Mermaid ERD + subject areas
  logical/         DBML per subject area, platform-neutral 3NF
  physical/
    <system>/      one folder per source system: ddl/00..80, erd/, README
      00_schema            schema + COMMENT
      10_domains_and_enums local value domains restored as reference tables
      20_reference         configuration
      30_master            master data
      31_master_pii        one-to-one PII satellites (separate grants)
      40_transaction       transactions, partitioned where volume warrants
      50_constraints       foreign keys, declared last so one ordered pass loads
      60_indexes           only indexes serving a named access path
      70_audit             GENERATED — watermark triggers, change log, grants
      80_comments          table descriptions, published by the data dictionary
    sql/           01_common.sql (GENERATED) + 00_create_all.sql (ordered loader)
mapping/           table-level, column-level, out-of-scope, lineage narrative
dictionary/        GENERATED data dictionary
docs/              conventions, source systems, scope boundary, ingestion contract
target/            upstream model documented as a constraint on the sources
tools/             Python package: derivation, generation, assertions
tests/             pytest: schemas load, every table has a PK, mapping is complete
```

`models/` holds the three modelling layers in the order they are derived:
conceptual, then logical, then physical. `models/physical/` keeps **one folder
per source system**, because the whole point of the source tier is that each
system is modeled in its own idiom rather than a house style. `models/physical/sql/`
holds the only two SQL files that are not specific to one system: the shared
`common` schema and the loader that orders all ten.

Files marked GENERATED are produced by `tools/` — edit the generator, not the
output.

## Conventions

Full detail in [docs/06-conventions.md](docs/06-conventions.md). The two that
matter most when reading the DDL:

- **Each schema uses its own system's idiom, not a house style.** Keys are
  `CHAR` composites in `sap_s4`, `CHAR(18)` in `sfdc_crm`, client-supplied
  `BIGINT` in `shopify`, `UUID` in `hudl`. The target model's uniform `BIGINT`
  surrogate keys are a *consequence of integration*, and the mapping shows where
  each one comes from.
- **No foreign key crosses a schema.** Cross-system references are business-key
  columns with no `REFERENCES` clause, resolved through `common.entity_xref`.
  This is enforced by `offball-check`.

## Out of scope

The 47 excluded tables, the ECM (473-table) variant, the 130 upstream metric
views, Delta/DLT pipeline code, and synthetic data generation.
