# Physical model — the source OLTP tier

Ten PostgreSQL 18 schemas, one per named system of record. **255 base tables
plus 24 partitions.**

The DDL is in [../models/physical/](../models/physical/), and the conventions it follows are in
[06-conventions.md](06-conventions.md).

## What got built

| Schema | System | Tier | Tables | Partitions |
|---|---|:--:|--:|--:|
| `sap_s4` | SAP S/4HANA FI/CO/MM/SD | A | 39 | 0 |
| `tm_axs` | Ticketmaster / AXS | A | 42 | 16 |
| `sfdc_crm` | Salesforce CRM | A | 26 | 0 |
| `shopify` | Shopify Plus | A | 25 | 0 |
| `archtics` | Archtics | A | 23 | 0 |
| `dalet` | Dalet Galaxy | A | 23 | 0 |
| `hudl` | SportsCode / Hudl | A | 22 | 0 |
| `adobe_aep` | Adobe Experience Platform | A | 21 | 8 |
| `sap_sfsf` | SAP SuccessFactors | B | 19 | 0 |
| `workday_ap` | Workday Adaptive Planning | B | 12 | 0 |
| `common` | shared domains and identity resolution | — | 3 | 0 |

Object totals, read from the loaded database:

| | Count |
|---|--:|
| Primary keys | 341 |
| Foreign keys | 504 |
| CHECK constraints | 925 |
| Unique constraints | 150 |
| Shared `DOMAIN` types | 55 |
| Indexes | 1,431 |
| Triggers | 308 |

## The defining decision

**Each schema uses its own system idiom, not a house style.**

A house style would read more smoothly and would be a lie. Keys are `CHAR`
composites led by `MANDT` in `sap_s4`, 18-character platform IDs in
`sfdc_crm`, client-supplied `BIGINT`s in `shopify`, client-generated `UUID`s in
`hudl`. Watermark columns are `updated_at`, `system_modstamp` and
`last_modified_on` depending on the vendor.

Those differences *are* the integration work. The target model's uniform
`BIGINT` surrogate keys are a consequence of it, and flattening the source tier
into one style would hide exactly what this model exists to show.

[05-source-systems.md](05-source-systems.md) has the distinctive property of
each schema.

## No foreign key crosses a schema

The structural premise, enforced twice — by `offball-check` and by
`tests/test_schemas_load.py`.

A cross-system reference is a business-key column with no `REFERENCES` clause,
named after the system it points at:

```sql
-- tm_axs.event
archtics_event_code VARCHAR(30),   -- business key, different database
sap_profit_center   VARCHAR(10),   -- business key, different database
```

The target model's 1,477 cross-domain foreign keys all become one of these,
resolved through `common.entity_xref`. This is the single largest structural
difference between the two tiers.

## Where SAP cannot declare integrity even internally

Four relationships in `sap_s4` obviously exist and cannot be declared, each for
a structural reason worth knowing before writing the extract:

| Relationship | Why not |
|---|---|
| `skb1` → `ska1` | The company-code view is keyed `(MANDT, BUKRS, SAKNR)`; the chart view is `(MANDT, KTOPL, SAKNR)`. `skb1` has no `KTOPL`, so the join must route through `t001` — a three-table join for `finance.gl_account` |
| `bseg` → `csks`, `cepc` | Cost and profit centres are time-dependent, with a validity date **in the key**. A posting line carries only the code, so resolution means picking the row whose window contains the posting date. No foreign key can express that, and joining on code alone fans out across every historical version |
| `konp` → `a004` | `KNUMH` is not a unique key of `a004`, which is keyed on the access combination. The pricing lookup is a join on a non-unique column by design |
| `regup` → `reguh` | The item key omits `XVORL`, `LIFNR` and `KUNNR`, all of which are in the header key, so the child cannot reference its own parent |

Each of those columns carries a `COMMENT` stating the resolution rule instead.

## Privacy: the PII satellite

The upstream model tags 281 in-scope columns with a `pii_*` subtype across 66
tables. Carrying them inline — which is what an analytical model reasonably
does — would mean every operational query reads restricted data.

So identifying attributes are split one-to-one from their parent:

```
tm_axs.customer_account        keys, status, purchase counts
tm_axs.customer_account_pii    name, date of birth, address, phone
```

Three things that buys: `REVOKE` on the satellite leaves the parent usable, so
the analyst role never holds PII; one place to encrypt; and a DSAR erasure that
is one row per satellite rather than a column-level update across the schema.

Satellites exist where the platform allows the separation — `tm_axs`,
`sfdc_crm`, `sap_sfsf`. They do **not** exist for `shopify` and `adobe_aep`,
because those platforms hold identity inline and inventing a split would
misrepresent them; grants restrict the tables instead.

## Partitioning

Four tables, all `RANGE` on an event timestamp, all with a `DEFAULT` partition
that should stay empty:

| Table | Grain | Why |
|---|---|---|
| `tm_axs.scan` | monthly | Highest-volume table in the estate; sharp pre-kickoff bursts |
| `tm_axs.screening_event` | half-yearly | Same profile, lower volume |
| `adobe_aep.experience_event` | quarterly | Every page view, app open, stream start |
| `adobe_aep.journey_step_event` | half-yearly | Every message sent or suppressed |

The primary key includes the partition key, which PostgreSQL requires — hence
`scan` keyed `(scan_id, scanned_at)` rather than on the surrogate alone.

## Loading it

```bash
docker compose up -d
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f models/physical/sql/00_create_all.sql
```

Or, with no local `psql`, through the container:

```bash
bash tools/load.sh            # all ten schemas
bash tools/load.sh tm_axs     # just one
```

The numbered file layout means a single forward pass works without deferred
constraints or a dependency sort: `50_constraints.sql` runs after every table
in the schema exists. The ten schemas are mutually independent and can load in
any order.

## Verifying it

```bash
uv run pytest
```

30 tests. The ones that matter most:

- every DDL file loads into a clean database with no errors
- every base table has a primary key
- every foreign key resolves, and none crosses a schema
- every partitioned table has a `DEFAULT` partition
- every schema maintains its watermark by trigger
- every table is documented, so the data dictionary has no blank rows

## Next layer

[04-physical-model-target.md](04-physical-model-target.md) — the upstream
Databricks model as a constraint on this one, plus the two measured defects in
it.
