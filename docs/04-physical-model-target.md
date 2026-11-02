# Physical model — the target

The target physical model is the upstream Databricks Sports Entertainment MVM.
A verbatim copy is vendored at [../source/mvm/](../source/mvm/) so that every
derived artifact in this repository has a fixed input and the measurements below
are reproducible offline.

What is **not** done is re-modeling it. The 200 tables of generated target DDL
are used as they are published; nothing here restates, re-emits or improves
them, because that would add no information and would drift the moment upstream
changed.

What this document does instead is state the target's physical conventions
**as constraints on the source tier**, and record two measured defects anyone
deploying it should know about.

## What the target model is

| Property | Value |
|---|---|
| Model type | `business`, Databricks **Silver layer**, Unity Catalog |
| Scope variant | MVM (Minimum Viable Model); the sibling ECM has 473 tables |
| Catalog | `sports_entertainment_ecm` |
| Schemas | One per domain — 14 of them |
| Tables | 200, averaging 45.5 columns |
| Columns | 9,102 |
| Foreign keys | 2,034 — **557 intra-domain, 1,477 cross-domain** |
| Metric views | 130 |
| Keys | `BIGINT` surrogate, `_id` suffix, informational (non-enforced) constraints |
| Naming | `snake_case` throughout |
| Timestamps | `yyyy-MM-dd'T'HH:mm:ss.SSSXXX` |

## The conventions that constrain the source tier

Six properties of the target that the source model has to satisfy.

### 1. Uniform `BIGINT` surrogate keys

Every target table is keyed on a single `BIGINT` with an `_id` suffix. **No
source system provides this.** Keys in the source tier are `CHAR` composites
led by `MANDT`, 18-character Salesforce IDs, platform-assigned Shopify
`BIGINT`s, client-generated `UUID`s and namespaced AEP identity values.

The uniform target key is therefore a *product of integration*, and
[`common.entity_xref`](../models/physical/sql/01_common.sql) is where that production happens:
it maps each system-local key to the canonical surrogate the lakehouse will
use. Twelve business entities need it, registered in
`common.canonical_entity`.

### 2. Informational constraints only

Databricks declares `PRIMARY KEY` and `FOREIGN KEY` but does not enforce them.
Duplicate or orphaned rows load silently.

That shifts the burden entirely upstream: **this tier enforces what the target
cannot**. 341 enforced primary keys, 504 enforced foreign keys, 925 `CHECK`
constraints and 150 unique constraints, all verified by
`tests/test_schemas_load.py`. If a constraint is going to catch anything, it
has to catch it here.

### 3. 1,477 cross-domain foreign keys

Only 27% of the target's foreign keys stay within a domain. The rest cross
domain boundaries — and in the source tier, most of those cross a *database*
boundary.

So they become business-key columns with no `REFERENCES` clause, named after
the system they point at:

```sql
-- tm_axs.event
archtics_event_code VARCHAR(30),   -- business key into another database
sap_profit_center   VARCHAR(10),   -- business key into another database
```

No foreign key in this model crosses a schema. That is asserted twice, by
`offball-check` and by a test.

### 4. `source_system_code` on every table

The target carries it and constrains it to five values:

```
TICKETMASTER | ARCHTICS | SAP_SD | MANUAL | LEAGUE_FEED
```

**The same model names ten systems of record.** Five of the ten cannot be
expressed in their own provenance column — Salesforce, Dalet, AEP, Shopify,
SuccessFactors, Workday and Hudl all have nowhere to go, while `LEAGUE_FEED`
names a system the model does not list.

`common.source_system` carries the full registry of ten with the schema name,
vendor category, tier and extract pattern. Loading into the target means either
widening that enum or losing provenance for seven systems.

### 5. `created_timestamp` / `updated_timestamp`

The target says of `updated_timestamp`:

> Required for incremental data pipeline processing in the Databricks Silver
> Layer and audit trail compliance under SOX.

So the source tier maintains its watermark **by trigger**, not by application
code — an application-maintained timestamp is missed on exactly the `UPDATE`
paths nobody remembers.

But a high-water-mark read cannot observe a **delete**. The target model offers
no tombstone mechanism at all, which is why every source schema carries a
`_change_log`. The sharpest case is `sap_s4.bsid`/`bsik`: a row is deleted the
moment an invoice clears, so without the change log an extract could never see
an invoice being paid.

### 6. Denormalized by design

45.5 columns per table, 6 associative tables out of 200. The upstream readme is
explicit that the MVM "minimises M:N associations and relies on direct foreign
key relationships for simplicity".

That is a reasonable choice for an analytical model and the wrong one for a
transactional tier, which is why the logical model restores 32 associative
entities. [What the target cannot represent](#what-the-target-cannot-represent)
below lists what the flattening costs.

## Two measured defects in the upstream model

Both found by comparing artifacts, not by inspection. Both reproducible.

### Defect 1 — 12.9% of columns disagree between `model.json` and the DDL

Comparing `model.json` against the generated `.sql` across four domains
(`event`, `venue`, `ticketing`, `finance`), **328 of 2,536 columns have a
different type in the two artifacts**:

| Pattern | Count |
|---|--:|
| `INT` → `STRING` | 215 |
| `DECIMAL(p,s)` → `DECIMAL(18,2)` | 113 |

The `INT → STRING` cases are scores, attendances and counts. In the deployable
DDL, `event.fixture` carries `actual_attendance`, `attendance_capacity`,
`home_score`, `away_score`, `leg_number` and `matchday_number` as `STRING` —
all declared `INT` in `model.json`. Anyone aggregating them has to cast first,
and a non-numeric value would load without complaint.

The `DECIMAL` flattening is worse in one specific place: **latitude and
longitude are declared `DECIMAL(9,6)` and emitted as `DECIMAL(18,2)`**. Two
decimal places of latitude is roughly a kilometre, so venue coordinates in the
deployed model cannot locate a stadium within a city.

**This model uses the `model.json` types**, which preserve intent. The
comparison is reproducible:

Both artifacts are vendored, so the comparison needs no network access:

```bash
# the declared types
../source/mvm/model.json
# the deployable types for the same domain
../source/mvm/schemas/sports_entertainment_event_schema_v1_mvm.sql
```

### Defect 2 — `source_system_code` cannot name seven of the ten systems

Covered in §4 above. A five-value enum in a model that names ten systems of
record.

## What the target cannot represent

The point of building the upstream side is that it makes the cost of
denormalization measurable rather than theoretical. Each item below is
documented at the relevant source table.

| Fact | Where it lives upstream | Why the target loses it |
|---|---|---|
| A payment that took four declines before succeeding | `tm_axs.payment_attempt` | `ticketing.ticket_payment` keeps only the settled result |
| Why a sponsorship deal was lost | `sfdc_crm.opportunity.loss_reason__c` | No target column exists |
| The quoted-versus-contracted gap | `sfdc_crm.quote` | No target table corresponds, so the realised discount is invisible |
| What a coded match event means | `hudl.instance_label` | `event.scoring_event` has fixed columns; five labels become none |
| Which rendition of an asset | `dalet.essence` | `content.asset` is one row for six files, so storage cost cannot be reported |
| A consent never asked for, versus declined | `adobe_aep.consent_record` (3 states) | `fan.consent_preference` is a boolean |
| A fan exiting a segment | `adobe_aep.segment_membership.status` | `fan.segment_assignment` carries a flag; the exit is the actionable state |
| Why a message was not sent | `adobe_aep.journey_step_event.suppression_reason` | `fan.communication` merges suppression with delivery failure |
| Shirt personalisation | `shopify.line_item.properties` | No target column, so the reason an item cannot be resold is lost |
| Committed versus available stock | `shopify.inventory_level` | `merchandise.inventory_position` has one quantity, overstating availability |
| Which promotion cost what | `shopify.discount_application.allocated_amount` | Neither `promotion` nor `order_line` retains the allocation |
| A seat licence outliving its holder | `archtics.psl` | A few columns on `season_ticket_account` is all that survives |
| Partial season-ticket churn | `archtics.renewal` | Six seats dropping to two is just a renewal upstream |
| A reusable seating manifest | `archtics.manifest` vs `event_manifest` | `venue.capacity_config` collapses both, losing the reuse |
| The report-to-authorisation lag | `sap_s4.qmel` vs `aufk` | `venue.maintenance_work_order` merges notification and order |
| A cost centre before a reorganisation | `sap_s4.csks` (dated key) | `finance.cost_center` keeps one row, so history is rewritten |
| An IFRS and a local-GAAP view of one posting | `sap_s4.t881` parallel ledgers | Arrive as two rows that look like a duplicate |
| A budget scenario versus the approved plan | `workday_ap.version` | `finance.budget` has one amount column |
| Why a budget figure is what it is | `workday_ap.driver` | No target counterpart |
| Athlete pay components | `sap_sfsf.emp_pay_component` | `athlete.contract` has one value column |
| The reason for a squad change | `sap_sfsf.emp_job.event_reason` | `athlete.roster` keeps none of it |
| A no-show | `admission` vs `access_grant` | Both exist upstream, but the gap is only computable if both are loaded |

None of these is an argument against the target model. A Silver-layer
analytical model is *supposed* to be denormalized, and most of these facts
genuinely do not belong in it. The value of writing them down is that the
mapping then states what is being given up, rather than implying the
transformation is lossless.

## Where the mapping lives

| File | Contents |
|---|---|
| [mapping/table_level_mapping.csv](../mapping/table_level_mapping.csv) | All 153 in-scope target tables: owning system, source tables, transform type, grain change, confidence |
| [mapping/column_level_key_tables.csv](../mapping/column_level_key_tables.csv) | Column by column for the tables carrying the money and the joins |
| [mapping/out_of_scope.csv](../mapping/out_of_scope.csv) | The 47 excluded tables with reasons |
| [mapping/lineage.md](../mapping/lineage.md) | Narrative, including the 213 unresolved foreign keys and every low-confidence call |

## Deploying against this source tier

The practical sequence, which this repository does not automate:

1. **Extract** per the pattern in
   [07-integration-contract.md](07-integration-contract.md) — CDC where
   available, watermark polling otherwise, change log for deletes.
2. **Resolve identity** through `common.entity_xref` before anything else.
   Twelve entities need it, and loading a fact before its canonical key exists
   produces orphans the target will not reject.
3. **Apply the transform** named in the mapping: `1:1`, `join`, `union`,
   `pivot`, `derive` or `scd2`. 105 of the 153 are joins, which is a direct
   consequence of the header/line splits in the source systems.
4. **Set `source_system_code`** — and widen the target enum first, or lose
   provenance for seven systems.
5. **Leave the 213 unresolved foreign keys null.** They are documented, not
   forgotten.
