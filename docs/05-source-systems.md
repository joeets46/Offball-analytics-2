# The ten source systems

The upstream model names its own systems of record in
`model.operational_systems_of_records`. This project models exactly those ten,
and no others — see [08-scope-boundary.md](08-scope-boundary.md) for what that
costs.

Verbatim, as the upstream model lists them:

> SAP S/4HANA (FI/CO/MM/SD - Financial Accounting; Controlling; Materials
> Management; Sales and Distribution), Ticketmaster / AXS (Ticketing and Access
> Control), Salesforce CRM (Fan and Sponsor Relationship Management), SAP
> SuccessFactors (Human Capital Management - Recruitment; Payroll; Talent),
> Dalet Galaxy (Media Asset Management and Broadcast Workflow), Adobe
> Experience Platform (Fan Engagement; Personalization; Analytics), Archtics
> (Venue Seating and Inventory Management), Shopify Plus (Merchandise
> E-Commerce Platform), Workday Adaptive Planning (Financial Planning and
> Analysis), SportsCode / Hudl (Performance Analytics and Video Analysis)

## Ownership at a glance

| Schema | System | Tier | Target tables | Source tables | Extract pattern |
|---|---|:--:|--:|--:|---|
| [`sap_s4`](../models/physical/sap_s4/) | SAP S/4HANA FI/CO/MM/SD | A | 33 | 39 | CDC log |
| [`tm_axs`](../models/physical/tm_axs/) | Ticketmaster / AXS | A | 30 | 42 | CDC log |
| [`sfdc_crm`](../models/physical/sfdc_crm/) | Salesforce CRM | A | 26 | 26 | API incremental on `SystemModstamp` |
| [`dalet`](../models/physical/dalet/) | Dalet Galaxy | A | 20 | 23 | CDC log |
| [`archtics`](../models/physical/archtics/) | Archtics | A | 14 | 23 | CDC log |
| [`adobe_aep`](../models/physical/adobe_aep/) | Adobe Experience Platform | A | 8 | 21 | Event stream + API |
| [`shopify`](../models/physical/shopify/) | Shopify Plus | A | 8 | 25 | Webhooks + reconciling sweep |
| [`sap_sfsf`](../models/physical/sap_sfsf/) | SAP SuccessFactors | B | 7 | 19 | API incremental on `last_modified_on` |
| [`hudl`](../models/physical/hudl/) | SportsCode / Hudl | A | 5 | 22 | API incremental |
| [`workday_ap`](../models/physical/workday_ap/) | Workday Adaptive Planning | B | 2 | 12 | API snapshot per version |

**Tier A** carries full DDL: complete column sets, every constraint, indexes,
partitioning, audit triggers. **Tier B** is abbreviated by design — key
entities with full keys and constraints, representative rather than exhaustive
column sets. The approved scope was "full breadth, representative depth", and
HCM and FP&A are adjacent to the core revenue path rather than on it.

One deviation from the original plan: **Dalet was promoted from Tier B to Tier
A** once the ownership map was complete, because it turned out to own 20 target
tables — more than Archtics, Shopify, AEP or Hudl. The plan had guessed it was
peripheral; the measurement said otherwise.

## How ownership was assigned

Measured, then reviewed. Every upstream column carries a `references` field
naming the system or standard it came from, so counting those names per table
gives an affinity score. Examples of what the measurement produced:

```
ticketing   -> tm_axs 317, archtics 208, sap_s4 139
finance     -> sap_s4 321, workday_ap 38
content     -> dalet 205, adobe_aep 29
merchandise -> sap_s4 252, shopify 219
fan         -> sfdc_crm 261, adobe_aep 196
```

The raw numbers are in
[tools/derived/mvm_tables.csv](../tools/derived/mvm_tables.csv) under
`system_affinity`; the reviewed result is
[tools/ownership.py](../tools/ownership.py).

**14 tables had no affinity signal at all** and were assigned by hand. Almost
all are reference or associative tables whose owner is obvious from context:
`finance.fiscal_period` → SAP, `athlete.agent` → a Salesforce Contact,
`content.collection_item` → Dalet. Each carries a note in the ownership map
saying so.

Confidence across the 153 in-scope tables: **93 high, 45 medium, 15 low**. A
`low` rating means there is no real system of record for the concept and the
assigned owner models only part of it; every one of those carries a note
explaining what is missing, and a test enforces that.

## What makes each system distinctive

The reason for modelling ten schemas rather than one is that their idioms
genuinely differ. Each entry below is the thing worth seeing in that schema.

### sap_s4 — SAP S/4HANA

Real SAP table names: `bkpf`, `bseg`, `kna1`, `veda`, not
`journal_header`/`journal_line`. Anyone building the extract will be reading
SAP documentation, so the names have to match.

- **`MANDT` leads every primary key.** The client field. A production system
  also holds test and training clients in the same tables, so an extract that
  does not filter on `MANDT` returns duplicate business rows. This is the
  single most distinctive property of an SAP schema and the commonest cause of
  a tripled row count.
- **Amounts are unsigned, with the direction in a separate character.**
  `bseg.dmbtr` is always positive; `shkzg` carries `S` or `H`. Extracts that
  miss this produce a trial balance that does not net to zero, so the model
  adds a generated `signed_amount` so nobody has to remember.
- **Time-dependent master data.** `csks` and `cepc` carry a validity date *in
  the key*, so one cost centre has many rows. This is why `bseg.kostl` has no
  foreign key — resolving it means picking the row whose window contains the
  posting date, which no FK can express.
- **`veda` is reached by eight target tables.** SAP does not care what a
  contract is about, which is the strongest evidence for the `agreement`
  supertype in the logical model.

### tm_axs — Ticketmaster / AXS

- **The scan stream is the highest-volume table in the estate.** One row per
  presentation of a barcode or credential, including every rejection,
  partitioned monthly.
- **Offline-captured scans arrive late.** Readers buffer when the network drops
  at gates, so `scanned_at` is not monotonic and the extraction watermark is
  `uploaded_at` instead.
- **Rotating barcodes** mean one ticket accumulates many barcode rows. The
  target `access_entitlement` keeps only the live one.
- **`venue_ref` is a separate record** from `archtics.building` and
  `sap_s4.t001w`. All three describe the same building, none shares a key, and
  that is the clearest illustration in the project of why the target
  `venue_id` is a product of integration.

### sfdc_crm — Salesforce CRM

- **`CHAR(18)` IDs** — 15 case-sensitive characters plus a 3-character
  checksum. Both the 15- and 18-character forms circulate, and mixing them is
  a standing integration bug.
- **`SystemModstamp`, not `LastModifiedDate`.** The former moves on
  platform-driven changes the latter misses, so an extract keyed on the wrong
  one silently loses rows.
- **`IsDeleted` is the Recycle Bin.** Records remain queryable for 15 days
  after deletion. An extract that does not filter it loads records the business
  considers gone.
- **`RecordTypeId` is load-bearing here.** Six target tables are
  `sfdc_crm.account` filtered by record type, and three more are
  `sfdc_crm.contract`. The seed rows in `sfdc_crm.record_type` are not
  illustrative — the mapping depends on them.
- **Custom fields keep their `__c` suffix**, so configuration is visibly
  distinct from the platform's own columns.

### dalet — Dalet Galaxy

- **`media_object` / `essence` split.** The object is the editorial thing; an
  essence is one rendition of it. Six renditions of one highlights package are
  six rows here and one row in the target model, which is why storage cost
  reporting is impossible downstream.
- **Placeholders are normal.** A media object with no essence is created by the
  production order before the camera has shot anything. An empty asset is an
  intended state, not a broken row.
- **Metadata is data, not columns.** Fields, vocabularies and typed values,
  because a broadcaster extends its metadata model monthly.
- **Rights windows carry territory arrays.** A right is "Europe except the UK,
  on these channels, in these languages", so the compliance question is a
  containment test — which is why those columns are GIN-indexed.

### archtics — Archtics

- **A five-level seating hierarchy**: building → level → section → row → seat.
  The target model flattens it to three.
- **Manifests are reusable.** One "Concert End Stage" configuration serves
  forty events; `event_manifest` applies it to one. The target
  `venue.capacity_config` collapses both, losing the reuse.
- **Personal seat licences** are a property right in a seat, separable from any
  season ticket and tradeable alone. No target table corresponds.
- **Capacity is a stated figure, not a count.** It is signed off by the fire
  authority, which is why an approved manifest must carry a valid certificate.

### adobe_aep — Adobe Experience Platform

- **Identity is namespaced and plural.** A person has no single key — ECID,
  email, CRMID, loyalty number — and the target `fan.fan_profile` reduces all
  of it to one `BIGINT`.
- **Graph links are pairwise, probabilistic and revocable.** Two identities are
  linked with a confidence, and a link can be withdrawn when a shared device
  turns out to have merged two fans. The target model has no concept of a
  disputed identity.
- **Experience events carry no foreign key to identity**, deliberately. Events
  arrive before identities are registered, and a per-row FK check on a table
  taking tens of thousands of inserts a second is not viable. Resolution
  happens later and asynchronously.
- **Consent has three states.** `allow`, `deny`, `unknown` — because "not
  asked" is not "declined", and the target boolean cannot tell them apart.

### shopify — Shopify Plus

- **IDs are platform-assigned, not `IDENTITY`.** It is SaaS; the replica
  receives ids it did not mint. A target declaring `GENERATED ALWAYS AS
  IDENTITY` would reject the data.
- **Discount values are negative** by convention. A sign inversion on load
  turns a discount into a surcharge, which is why there is a `CHECK` for it.
- **Three independent order lifecycles**: financial status, fulfilment status
  and cancellation, which move separately. The target model has one status
  column.
- **Metafields** are the extension mechanism, and where every retailer puts
  what the platform does not model — player name, kit year, licensing body.

### hudl — SportsCode / Hudl

- **Client-generated UUIDs**, because an analyst codes a match offline and
  syncs later. A sequence cannot survive that.
- **The coded instance is the native unit.** A time range on a video tagged
  with labels from label groups. Statistics are *derived* from instances, not
  entered.
- **`instance_label` has no target equivalent at all.** It is what a coded
  event means — "shot, right foot, inside box, on target, goal" is five rows —
  and the target `scoring_event` has fixed columns.
- **Time is video milliseconds, not wall clock.** The match-start offset is
  what converts a position into a match minute.
- **One game has several timelines.** Different analysts code the same match
  for different purposes and legitimately disagree, so the extract must pick
  the primary timeline or it double-counts every goal.

### sap_sfsf — SAP SuccessFactors (Tier B)

- **Effective-dated throughout.** `emp_employment`, `emp_job` and
  `emp_compensation` are keyed on `(user_id, effective_start_date)`, so one
  employee has many rows and only one is current. An extract that does not
  pick the window in force multiplies the roster by the number of job changes.
- **Person and employment are separate.** A player who retires and returns as
  a coach is one person with two employments; treating them as two people
  loses the career.
- **Compensation is components, not salary.** Appearance fees, goal bonuses,
  image rights, signing-on fees. The target `athlete.contract` has one value
  column, so the structure — which is the substance of the deal — does not
  survive.

### workday_ap — Workday Adaptive Planning (Tier B)

Smallest system, and structurally unlike every other schema here, which is
what earns it a place.

- **It is a cube, not a set of entities.** One fact table addressed by six
  dimensions; nothing corresponds to a business document.
- **Versions are first-class.** Actuals, budget, forecast and any number of
  scenarios coexist for the same intersection. The target `finance.budget` has
  one amount column, so loading a scenario as the approved budget is a
  materially wrong answer.
- **Values are signed by convention per account.** Revenue is negative in many
  Adaptive models, and loading a flipped account without reversing the sign
  inverts the whole P&L.
- **Time is a dimension member, not a date.** "FY26 Q3" need not align with a
  calendar quarter.

## Extract patterns

| Pattern | Systems | How it works |
|---|---|---|
| CDC log | `sap_s4`, `tm_axs`, `archtics`, `dalet` | Read the database change stream. Deletes visible. |
| API incremental | `sfdc_crm`, `sap_sfsf`, `hudl` | Poll on the watermark column. Deletes need the soft-delete flag or the change log. |
| Event stream + API | `adobe_aep` | Events stream continuously; profile and segment state polled. |
| Webhooks + sweep | `shopify` | Webhooks for latency, a reconciling `updated_at` sweep because delivery is at-least-once, not guaranteed. |
| API snapshot | `workday_ap` | Whole version at once. A cube does not have a sensible incremental read. |

Detail in [07-integration-contract.md](07-integration-contract.md).

## Adding an eleventh system

The boundary is deliberately easy to move. To bring, say, a sportsbook in:

1. Add it to `SYSTEMS` in [tools/scope.py](../tools/scope.py).
2. Remove `gaming` from `OUT_OF_SCOPE` in the same file.
3. Add `models/physical/sportsbook/ddl/` following the numbered file layout.
4. Add the `gaming` block to `OWNERSHIP` in
   [tools/ownership.py](../tools/ownership.py).
5. Add a `SchemaConfig` to [tools/gen_audit.py](../tools/gen_audit.py).
6. Run `uv run offball-extract && uv run offball-mapping && uv run
   offball-audit && uv run offball-check && uv run pytest`.

`offball-check` will refuse to pass until the mapping names only tables that
actually exist in the new DDL, which is the point.
