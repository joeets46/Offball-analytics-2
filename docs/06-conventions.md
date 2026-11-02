# Conventions

The rules the DDL follows, and why. Decided before the schemas were written,
which is why they are consistent across 255 tables.

## The one that surprises people

**Each schema uses its own system's idiom, not a house style.**

A house style would be easier to read and would be a lie. The whole point of
modelling ten systems separately is that their keys, their types and their
timestamp semantics genuinely differ, and that those differences are the
integration work. Flattening them would hide exactly what this model exists to
show.

| Schema | Key style | Watermark column | Delete semantics |
|---|---|---|---|
| `sap_s4` | `CHAR` composite business keys led by `MANDT` | `updated_at` | Never — reversal by counter-document, except the open-item index tables which really delete |
| `tm_axs` | `INTEGER`/`BIGINT` identity, server-assigned | `updated_at` | Soft, via status |
| `sfdc_crm` | `CHAR(18)` platform IDs | `system_modstamp` | Recycle Bin: `is_deleted` for 15 days |
| `archtics` | `INTEGER`/`BIGINT` identity | `updated_at` | Soft, via status |
| `shopify` | `BIGINT`, **platform-assigned, not generated** | `updated_at` | Rare; `published_at`/`cancelled_at` instead |
| `adobe_aep` | Mixed: `BIGINT` identity, `VARCHAR` platform IDs, namespaced identity values | `updated_at`, but events use `received_at` | Events never; profiles via privacy job |
| `hudl` | `UUID`, **client-generated** | `updated_at` | Real deletes: re-coding a passage removes instances |
| `dalet` | `VARCHAR(40)` MAM IDs | `updated_at` | Rare |
| `sap_sfsf` | `VARCHAR` MDF keys, effective-dated composites | `last_modified_on` | Rare |
| `workday_ap` | `VARCHAR` model-scoped codes | `updated_at` | Routine for cells |

Three of those are worth dwelling on:

- **`shopify` keys are not `IDENTITY`.** It is SaaS: the replica *receives*
  ids it did not mint. An extract target declaring `GENERATED ALWAYS AS
  IDENTITY` would reject the data outright.
- **`hudl` keys are client-generated UUIDs** because an analyst codes a match
  on a laptop with no connectivity and syncs afterwards. A sequence cannot
  survive that.
- **`sfdc_crm` replicates on `SystemModstamp`, not `LastModifiedDate`.** The
  former moves on platform-driven changes that leave the latter untouched, so
  an extract keyed on `LastModifiedDate` silently misses rows. The audit
  generator takes the watermark column per schema for exactly this reason.

## Naming

| Thing | Rule | Example |
|---|---|---|
| Schema | The system, not the domain | `tm_axs`, not `ticketing` |
| Table | The system's own name, lowercase | `bkpf`, `media_object`, `sales_order` |
| Column | The system's own name | `mandt`, `system_modstamp`, `labst` |
| Primary key | Whatever the system uses | `event_id`, `(mandt, bukrs, belnr, gjahr)`, `id` |
| Foreign key constraint | `fk_<child>_<role>` | `fk_order_line_order` |
| Check constraint | `ck_<table>_<rule>` | `ck_event_doors_before_start` |
| Unique index | `ux_<table>_<rule>` | `ux_barcode_live` |
| Plain index | `ix_<table>_<access_path>` | `ix_scan_event_time` |
| Trigger | `trg_<table>_<purpose>` | `trg_event_touch` |
| Shared domain | `dom_<concept>` | `common.dom_iso3_code` |
| Internal table | Leading underscore | `_change_log` |

Reserved words are renamed rather than quoted: `order` → `sales_order`,
`case` → `service_case`, `return` → `return_request`, `row` → `seat_row`,
`user` → `sf_user`. Quoting a reserved identifier in every statement that
touches it is worse than naming it plainly, and `offball-check` verifies none
slipped through.

## Keys

**No foreign key crosses a schema.** This is the structural premise, and it is
enforced by both `offball-check` and `tests/test_schemas_load.py`.

A cross-system reference is modeled as what it actually is: a business-key
column with no `REFERENCES` clause, named after the system it points at, and
resolved through `common.entity_xref`.

```sql
-- tm_axs.event
archtics_event_code VARCHAR(30),   -- business key, no FK
sap_profit_center   VARCHAR(10),   -- business key, no FK
```

The target model's 1,477 cross-domain foreign keys all become one of these.
That is the single largest structural difference between the two tiers, and it
is why `common.entity_xref` exists rather than being a nicety.

## Types

Derived from the upstream model's own declarations wherever it makes one, using
`model.json` rather than the generated DDL — see
[04-physical-model-target.md](04-physical-model-target.md) for why those two
disagree on 12.9% of columns.

| Upstream declares | This model uses | Note |
|---|---|---|
| `STRING` | `VARCHAR(n)` sized from the declared regex, else `TEXT` | Unbounded text is rarely what the business means |
| `BIGINT` / `INT` | `BIGINT` / `INTEGER` | Never `STRING`, which is what the upstream DDL emits for 215 of them |
| `BOOLEAN` | `BOOLEAN` | |
| `DATE` | `DATE` | |
| `TIMESTAMP` | `TIMESTAMPTZ` | Always. A naive timestamp in a model spanning timezones is a latent bug |
| `DECIMAL(p,s)` | `NUMERIC(p,s)` as declared | Not flattened to `(18,2)`, which is what the upstream DDL does to all 113 of them |

Three deliberate upgrades on the upstream types:

- **Money is `NUMERIC(18,4)`**, not `(18,2)`, wherever fees and tax split. Tax
  on a service fee on a single ticket does not land on a cent boundary, and
  rounding at rest means the total never reconciles.
- **IP addresses are `INET`**, not `STRING`.
- **Genuinely schemaless payloads are `JSONB`**: AEP experience events, Dalet
  custom metadata, Hudl coded-instance labels, Shopify metafields. Flattening
  a customer-defined schema into columns produces a table of mostly nulls that
  breaks whenever the schema is extended.

## Value domains

The extractor finds, across the 153 in-scope tables:

| | Count | Disposition |
|---|--:|---|
| Columns with an enumerated value domain | 684 | Reference table or `CHECK` |
| Distinct enumerated domains | 662 | |
| Promoted to a reference table | 43 | Shared across 2+ tables, or the owning table is a Reference table |
| Inline `CHECK` constraint | 619 | Single-table use |
| Columns with a regex pattern | 438 | `DOMAIN` type or inline `CHECK` |
| Distinct `DOMAIN` types created | 55 | Reused by 2+ columns, plus 1 curated |
| Columns covered by a shared `DOMAIN` | 329 | |
| Explicitly flagged `ENUM-REF-CANDIDATE` upstream | 278 | All restored |

**The promotion rule**: a value domain becomes a reference *table* if two or
more tables share it, or if the owning upstream table is typed `Reference`.
Otherwise it stays an inline `CHECK`.

The reasoning is about who maintains the list. A sales channel, a hold reason
or a delivery method is operator-configurable and gets reported on, so it needs
a table someone can add a row to. A payment state or a scan result is a
protocol the application branches on, so a `CHECK` is correct — changing it
*should* require a release.

**`DOMAIN` types rather than repeated `CHECK`s** for the 55 reused patterns.
`common.dom_iso3_code` is used by 139 columns across 91 tables; declaring that
pattern 139 times would guarantee drift. This is the one place the model shares
something across schemas, and `01_common.sql` says plainly that it is a
convenience of this reference implementation rather than a claim that the real
systems share a type library.

## Privacy

Driven by measurement, not instinct. The upstream model tags its own columns,
and across the in-scope set that gives:

| | Count |
|---|--:|
| Sensitive columns (PII or above `internal`) | 667 |
| `restricted` | 153 |
| `confidential` | 512 |
| PII-tagged columns | 281 |
| Tables with at least one PII column | 66 |

Twelve PII subtypes appear, led by `pii_financial` (98), `pii_address` (62) and
`pii_health` (22).

**The response is the PII satellite.** Identifying attributes are split
one-to-one from their parent: the parent keeps the keys and the commercial
state, the satellite keeps the person.

```
tm_axs.customer_account        -- keys, status, purchase counts
tm_axs.customer_account_pii    -- name, date of birth, address, phone
```

Three things that buys:

1. **Grants.** `REVOKE SELECT` on the satellite leaves the parent fully usable,
   so the analyst role never holds PII. The ingestion role keeps it, because
   the target model rejoins the columns.
2. **One place to encrypt**, should column encryption be introduced.
3. **A tractable erasure target.** A DSAR delete is one row per satellite
   rather than a column-level update across the schema.

Satellites exist where the system permits the separation: `tm_axs`,
`sfdc_crm`, and `sap_sfsf` (where the whole schema is person data). They do
*not* exist for `shopify` and `adobe_aep`, because those platforms hold identity
inline and inventing a split would misrepresent them — grants restrict the
tables instead.

Three roles, created defensively because every schema grants to the same set:

| Role | Reads | Writes |
|---|---|---|
| `offball_app` | everything | everything |
| `offball_analyst` | everything **except PII satellites** | nothing |
| `offball_ingest` | everything, satellites included | nothing |

## Audit and change capture

Every table carries `created_at` and a watermark column, maintained **by
trigger**, not by the application. The ingestion contract treats the watermark
as truthful, and an application-maintained timestamp is missed on exactly the
`UPDATE` paths nobody remembers.

Append-only tables carry no watermark and take no trigger, which is stated in a
comment so the absence reads as deliberate: `tm_axs.scan`,
`tm_axs.screening_event`, `tm_axs.payment_transaction`,
`adobe_aep.experience_event`, `adobe_aep.journey_step_event`.

Each schema has a `_change_log` table and a generic trigger function.
**Deletes are why it exists**: a high-water-mark read of the watermark cannot
observe a row that is gone. The log stores the prior row on delete only —
inserts and updates leave it null, because the current row is still readable
and copying it would double the write volume of the busiest tables.

The clearest case is `sap_s4.bsid` and `bsik`, the open-item index tables.
A row is *deleted* the moment an invoice clears. That is routine business, not
an anomaly, and without the change log an extract could never observe an
invoice being paid.

## Constraints

Written to catch the errors that actually happen, not to demonstrate rigour.
925 `CHECK` constraints across the model, in five recurring shapes:

```sql
-- 1. Paired nullability: both or neither.
CONSTRAINT ck_bkpf_reversal_pair
    CHECK ((stblg IS NULL) = (stjah IS NULL))

-- 2. Exclusive alternatives: exactly one.
CONSTRAINT ck_scan_barcode_xor_credential
    CHECK ((barcode_id IS NOT NULL) <> (credential_id IS NOT NULL))

-- 3. Status implies data: a cancelled thing says when.
CONSTRAINT ck_event_cancelled_has_timestamp
    CHECK ((lifecycle_status = 'cancelled') = (cancelled_at IS NOT NULL))

-- 4. Ordering: time moves forwards.
CONSTRAINT ck_event_doors_before_start
    CHECK (doors_open_at IS NULL OR doors_open_at <= scheduled_start_at)

-- 5. Containment: a part does not exceed its whole.
CONSTRAINT ck_payment_refund_within_capture
    CHECK (refunded_amount <= captured_amount)
```

Where a constraint encodes a business rule that is not obvious, it carries its
own `COMMENT` — for instance `ck_credential_clearance_requires_check`, which
makes a cleared background check a precondition of reaching a restricted zone
rather than a later workflow step.

**Constraints deliberately not added** are as informative. `shopify.inventory_level
.available` permits negative values, because a variant with a `continue`
inventory policy oversells by design; `sap_s4.mard.labst` permits negative
stock, because SAP does. A constraint that rejects rows a real extract
delivers is worse than no constraint.

## Referential actions

Chosen per relationship rather than defaulted:

| Action | Used when | Example |
|---|---|---|
| `CASCADE` | The child has no meaning without the parent | `barcode` → `ticket` |
| `RESTRICT` | Deleting the parent should be blocked | anything financial, all reference data |
| `SET NULL` | The link is optional context | `promo_code` on an order |

Two uses of `CASCADE` are privacy controls rather than conveniences: the PII
satellites cascade from their parent, so erasing the account erases the person.

`ON DELETE SET NULL` on a composite key takes a column list —
`ON DELETE SET NULL (aufnr)` — because nulling the whole key would try to null
`MANDT`, which is `NOT NULL`.

## Indexes

Only indexes that serve a named access path, and every one carries a comment
saying which. Primary keys and `UNIQUE` constraints are already indexed and are
never repeated.

**Partial indexes are used heavily.** Most operational queries want live rows
only — active listings, unsettled payments, open incidents — and a `WHERE`
clause keeps the index a fraction of the table:

```sql
CREATE UNIQUE INDEX ux_resale_one_active_per_ticket
    ON tm_axs.resale_listing (ticket_id)
    WHERE listing_status = 'active';
```

That one does real work: a ticket may have many historical listings but only
ever one on the market, and a plain `UNIQUE` could not say so.

Foreign key columns are indexed where the child is read by parent, or where the
parent is deleted or updated — otherwise PostgreSQL scans the child to validate
the constraint. FK columns on small reference tables are left unindexed: the
planner will not use them and they cost write throughput.

**Every extracted table has an index on its watermark column.** Without it the
nightly extract degrades into a full scan as the table grows, which is the kind
of problem that appears six months after go-live.

## Partitioning

Five tables, all by `RANGE` on an event timestamp:

| Table | Grain | Why |
|---|---|---|
| `tm_axs.scan` | monthly | Highest-volume table in the estate; arrives in sharp pre-kickoff bursts |
| `tm_axs.screening_event` | half-yearly | Same burst profile, lower volume |
| `adobe_aep.experience_event` | quarterly | Every page view, app open and stream start |
| `adobe_aep.journey_step_event` | half-yearly | Every message sent or suppressed |

Each has a `DEFAULT` partition, and each default carries a comment saying it
should stay empty — rows landing there mean partition maintenance has fallen
behind. A test asserts every partitioned table has one, because without it an
out-of-range insert is rejected outright rather than landing somewhere visible.

The primary key includes the partition key, which PostgreSQL requires. That is
why `scan` is keyed `(scan_id, scanned_at)` rather than on the surrogate alone.

## Generated columns

Used where a derived value must never disagree with its inputs:

```sql
-- SAP stores amounts unsigned with the sign in a separate character. This is
-- the commonest source of sign errors in an SAP extract.
signed_amount NUMERIC(18,2) NOT NULL
    GENERATED ALWAYS AS (CASE WHEN shkzg = 'S' THEN dmbtr ELSE -dmbtr END) STORED
```

Also `tm_axs.price_level.total_price`, `sap_s4.anlc.nbv`,
`sap_s4.bsid.due_on`, `sfdc_crm.opportunity.expected_revenue` and
`sfdc_crm.contact.name`. In each case the alternative is an application
computing it twice and eventually computing it differently.

## File layout within a schema

Numbered to load in order, so one forward pass works without deferred
constraints or a dependency sort.

| File | Contents |
|---|---|
| `00_schema.sql` | `CREATE SCHEMA` and the schema `COMMENT` |
| `10_domains_and_enums.sql` | Local value domains restored as reference tables |
| `20_reference.sql` | Configuration |
| `30_master.sql` | Master data |
| `31_master_pii.sql` | PII satellites |
| `40_transaction.sql` | Transactions, partitioned where volume warrants |
| `50_constraints.sql` | Foreign keys — **last**, once every table exists |
| `60_indexes.sql` | Indexes |
| `70_audit.sql` | **GENERATED** — triggers, change log, grants |
| `80_comments.sql` | Table descriptions for the data dictionary |

Not every schema has every file; smaller ones omit `10_` and `20_`.

## What is generated and what is not

Edit the generator, not the output.

| Artifact | Generator |
|---|---|
| `tools/derived/*.csv`, `summary.json` | `offball-extract` |
| `sql/01_common.sql` | `offball-common` |
| `mapping/table_level_mapping.csv`, `out_of_scope.csv` | `offball-mapping` |
| `oltp/*/ddl/70_audit.sql` | `offball-audit` |
| `dictionary/*` | `offball-dictionary` |

Everything else — the DDL, the conceptual and logical models, the docs, the
column-level mapping — is written by hand, because it encodes judgement that a
generator cannot make.
