# Integration contract

What a pipeline reading this source tier has to handle. Not pipeline code —
the contract the pipeline has to satisfy, and the properties of the source
model that make each requirement unavoidable.

## The five hard problems

In order of how much damage getting them wrong does.

| # | Problem | Why it is hard here | Mechanism |
|--:|---|---|---|
| 1 | Cross-system identity | The same fan exists in five systems under five unrelated keys | `common.entity_xref` |
| 2 | Deletes | A watermark read cannot see a row that is gone | `<schema>._change_log` |
| 3 | Late-arriving events | Gate readers and mobile SDKs buffer offline and backfill | Separate occurrence and arrival timestamps |
| 4 | Per-system watermark semantics | Three different column names, and Salesforce has two candidates where only one is correct | Per-schema watermark column |
| 5 | Grain changes | 105 of 153 target tables are joins of a header and its lines | `transform_type` in the mapping |

## 1. Identity resolution

The target model keys everything on a uniform `BIGINT`. No source system
provides one. Twelve business entities exist in more than one system and must
be resolved **before** any fact referencing them is loaded.

Registered in `common.canonical_entity`:

| Entity | Exists as |
|---|---|
| `fan` | `sfdc_crm.contact`, `tm_axs.customer_account`, `shopify.customer`, `adobe_aep.profile`, `archtics.sta_account` |
| `venue` | `archtics.building`, `tm_axs.venue_ref`, `sap_s4.t001w` |
| `fixture` | `tm_axs.event`, `archtics.event_manifest`, `hudl.game` |
| `athlete` | `sap_sfsf.per_person`, `hudl.player` |
| `franchise` | `sap_s4.t001`, `sap_s4.cepc`, `sfdc_crm.account`, `hudl.team` |
| `sponsor` | `sfdc_crm.account`, `sap_s4.kna1` |
| `supplier` | `sap_s4.lfa1`, `shopify.sales_order.vendor` |
| `product` | `sap_s4.mara`, `shopify.product_variant` |
| `seat` | `archtics.seat`, `tm_axs.ticket_inventory` |
| `media_asset` | `dalet.media_object`, `hudl.video` |
| `channel` | `dalet.channel`, `dalet.publication_target` |
| `season` | `sap_s4.t009b`, `tm_axs.season`, `archtics.plan` |

`common.entity_xref` maps `(entity_type, source_system_code, source_key)` to a
`canonical_id`, with a `match_method` (`deterministic`, `probabilistic`,
`manual`, `survivorship`), an optional confidence, and `valid_from`/`valid_to`
so a correction is auditable rather than destructive.

**Survivorship matters.** When two systems disagree about a fan's address,
`is_survivor` marks whose value wins. Without it the loaded value depends on
join order, which is to say it is arbitrary.

**The hard cases, concretely:**

- **Guest checkout.** `shopify.sales_order.customer_id` is nullable, and
  guest purchases are normal. The target `merchandise.merch_order` expects a
  fan reference, so guest orders need a synthetic identity or they fall out of
  fan-level revenue entirely.
- **Household accounts.** One `archtics.sta_account` covers four people. A
  one-to-one resolution to `fan` double- or quadruple-counts supporters.
- **Shared devices.** `adobe_aep.identity_graph_link` can be *revoked* when a
  household tablet turns out to have merged two fans. The target model has no
  concept of a disputed identity, so a revocation has to be replayed as a
  correction rather than loaded as a fact.
- **Blank-padded SAP keys.** `CHAR` columns are space-padded; an extract that
  does not trim will not join to anything.
- **Salesforce 15 versus 18 character IDs.** Both forms circulate. Mixing them
  is a standing integration bug.

## 2. Deletes

The target model has no tombstone mechanism, and the source systems delete in
four different ways:

| System | Delete behaviour | How the pipeline sees it |
|---|---|---|
| `sap_s4` | Accounting documents are never deleted — a correction is a reversing document. **But `bsid`/`bsik` really delete** when an item clears | `_change_log`; also exclude reversals from any sum |
| `sfdc_crm` | Recycle Bin: `is_deleted` true for 15 days, still queryable | Filter `is_deleted`, and tombstone those rows downstream |
| `hudl` | Real deletes: re-coding a passage removes instances | `_change_log` — otherwise phantom goals persist in `event.scoring_event` |
| `shopify` | Rare; lifecycle timestamps instead (`cancelled_at`, `archived`) | Read the timestamps |
| `workday_ap` | Routine for cells, as planners clear rows | Snapshot per version sidesteps it |
| `adobe_aep`, `tm_axs`, `archtics`, `dalet` | Soft, via status | Read the status |

`sap_s4.bsid`/`bsik` are the case that justifies the whole mechanism. They are
index tables whose key *encodes* the clearing state, and a row vanishes the
moment an invoice is paid. A high-water-mark read of `updated_at` can never
observe that, so an AR ageing built on watermark polling alone would show paid
invoices as outstanding forever.

Each `_change_log` stores the prior row **on delete only**. Inserts and updates
leave `old_row` null, because the current row is still readable in the base
table and copying it would double the write volume of the busiest tables.

## 3. Late arrival

Three tables separate when something happened from when the database learned
about it, and the distinction is load-bearing:

| Table | Occurrence | Arrival | Why they differ |
|---|---|---|---|
| `tm_axs.scan` | `scanned_at` | `uploaded_at` | Gate readers buffer when the network drops, then backfill |
| `adobe_aep.experience_event` | `timestamp` | `received_at` | Mobile SDKs buffer offline, sometimes for days |
| `adobe_aep.journey_step_event` | `occurred_at` | `created_at` | Delivery receipts arrive asynchronously |

**The watermark must be the arrival column.** Occurrence time is not monotonic,
so an extract keyed on it loses every late event permanently — and at a gate,
late events cluster exactly where attendance reconciliation needs them.

`tm_axs.scan.offline_captured` flags the affected rows, and
`ix_scan_uploaded_at` is what makes the incremental read cheap.

Both tables carry a `CHECK` that arrival is not before occurrence, which
catches clock skew on the reader rather than letting it silently reorder the
stream.

## 4. Watermark semantics per system

Not cosmetic. Three different column names, and in one case two candidates
where only one works.

| System | Column | Note |
|---|---|---|
| `sap_s4`, `tm_axs`, `archtics`, `dalet`, `shopify`, `hudl`, `workday_ap` | `updated_at` | Maintained by `common.touch_updated_at()` |
| `sfdc_crm` | `system_modstamp` | **Not `last_modified_date`** |
| `sap_sfsf` | `last_modified_on` | |
| `adobe_aep` events | `received_at` | Arrival, per §3 |

The Salesforce case is the trap. `SystemModstamp` moves on platform-driven
changes that leave `LastModifiedDate` untouched — a workflow rule firing, a
roll-up summary recalculating, a merge. An extract keyed on `LastModifiedDate`
silently misses those rows, and the loss is invisible because the row still
exists and still looks current.

`tools/gen_audit.py` takes the watermark column per schema and emits a
schema-local trigger function where it is not the default, which is why
`sfdc_crm.touch_system_modstamp()` exists.

**Every extracted table has an index on its watermark column.** Without it the
nightly extract degrades into a full scan as the table grows — a problem that
surfaces six months after go-live.

## 5. Grain changes

The mapping names a `transform_type` per target table. The distribution is
itself informative:

| Transform | Count | What it means |
|---|--:|---|
| `join` | 105 | Header and line, or master and detail, flattened to one row |
| `1:1` | 38 | Same grain |
| `derive` | 8 | No direct source row; computed from source attributes |
| `union` | 2 | Rows from several sources, deduplicated on a business key |

**105 of 153 being joins is a direct consequence of how source systems are
built.** Every
SAP document is a header plus lines (`bkpf`/`bseg`, `vbrk`/`vbrp`,
`rbkp`/`rseg`, `reguh`/`regup`), every master record is a client view plus an
organisational view (`ska1`/`skb1`, `kna1`/`knb1`, `lfa1`/`lfb1`,
`mara`/`marc`/`mard`). The target model flattens each pair, so the grain of
`finance.journal_entry` is the document *line*, not the document — a 400-line
payroll posting becomes 400 target rows repeating the header 400 times.

**The `derive` cases are the ones to watch**, because there is no row to copy:

| Target table | Derived from | Risk |
|---|---|---|
| `event.bracket` | `tm_axs.event_group` nesting | No source for bracket topology |
| `event.competition_round` | `tm_axs.event_group` levels | Round is a grouping level, not an entity |
| `broadcast.blackout_rule` | `dalet.rights_window` conditions | Must evaluate territory arrays and sellout state |
| `athlete.free_agency_status` | `sap_s4.veda` expiry dates | Depends on contract interpretation |
| `athlete.eligibility_status` | `sap_sfsf.emp_employment` status | Approximate by definition |

## Per-system extract patterns

| Pattern | Systems | Mechanics | Watch for |
|---|---|---|---|
| CDC log | `sap_s4`, `tm_axs`, `archtics`, `dalet` | Read the change stream | SAP: filter `MANDT` to one client, or get triple rows |
| API incremental | `sfdc_crm`, `sap_sfsf`, `hudl` | Poll on the watermark | SFDC: `SystemModstamp` + `IsDeleted`. SFSF: effective-dated, pick the window in force |
| Event stream + API | `adobe_aep` | Events stream, state polled | Watermark on arrival, not occurrence |
| Webhooks + sweep | `shopify` | Webhooks for latency | Delivery is at-least-once, not guaranteed; the `updated_at` sweep is the safety net |
| API snapshot | `workday_ap` | Whole version at once | Filter `is_plan_of_record`, exclude `is_calculated` cells |

### The traps worth naming

- **SAP `MANDT`.** A production system holds production, test and training
  clients in the same tables. Not filtering returns duplicate business rows.
- **SAP sign convention.** Amounts are unsigned with the direction in `shkzg`.
  Use the generated `signed_amount` and the trial balance nets to zero.
- **SAP reversals.** `bkpf.stblg` points at the reversing document. Summing
  without excluding them double-counts every correction.
- **SAP `rfbsk`.** Only billing documents with `rfbsk = 'C'` have reached the
  ledger. Revenue reporting that ignores it counts invoices that do not yet
  exist in the GL.
- **SAP time-dependent master data.** `csks` and `cepc` carry a validity date
  in the key. Joining on code alone fans out to one row per historical version.
- **Salesforce `IsDeleted`.** Fifteen days of queryable deleted records.
- **Shopify negative discounts.** A sign inversion turns a discount into a
  surcharge.
- **Shopify test transactions.** `transaction.test` rows are real rows with no
  money behind them, and including them inflates revenue.
- **Shopify platform IDs.** Client-supplied, not generated. An `IDENTITY`
  target column rejects them.
- **Hudl multiple timelines.** One game has several coding passes that
  legitimately disagree. Filter to `is_primary` or double-count every goal.
- **Adaptive sign flips and rollups.** `account.is_sign_flipped` must be
  honoured, and `level.is_rollup_only` rows must be excluded or totals double.

## Ordering

Dependencies that cannot be reordered:

```
1. common.source_system, common.canonical_entity     (registries)
2. Source extracts, all ten systems                  (independent, parallel)
3. common.entity_xref                                (resolve identity)
4. Target master tables                              (need canonical keys)
5. Target transactional tables                       (need master)
6. Target derived tables                             (need transactional)
```

Steps 4–6 matter because the target's foreign keys are informational: loading a
fact before its master row exists produces an orphan the target will not
reject, and nothing downstream will notice until a report returns a null name.

## Idempotency

Every extract must be replayable without duplicating.

| Transform | Replay strategy | Natural key |
|---|---|---|
| `1:1` | Upsert on the mapped business key | The source key |
| `join` | Upsert on the target key derived from the header key | Header key plus line number |
| `union` | Upsert with explicit precedence between sources | Shared business key |
| `derive` | Full recompute for the affected window | n/a |
| `scd2` | Close the current row, insert the new one | Business key plus `valid_from` |

Replay windows need to overlap. With late arrival in play, a 24-hour extract
should read 48 hours and rely on the upsert, because a scan uploaded two days
after the match is a real occurrence rather than an anomaly.

## Data quality gates

What to check before promoting a load, in rough order of value:

| Gate | Check | Why |
|---|---|---|
| Identity coverage | Every fact's canonical key resolves | Orphans load silently into the target |
| Reversal exclusion | `bkpf.stblg IS NULL` on summed documents | Otherwise corrections double-count |
| GL release | `vbrk.rfbsk = 'C'` for recognised revenue | Otherwise unposted invoices are counted |
| Client filter | Exactly one `MANDT` value in the extract | More than one means triple rows |
| Test exclusion | `shopify.transaction.test = false` | Otherwise revenue inflates |
| Timeline selection | One `hudl.timeline` per game | Otherwise events double |
| Plan version | One `workday_ap.version` per budget load | Otherwise a scenario loads as commitment |
| Sign sanity | Debits equal credits per document | Catches the `shkzg` mistake immediately |
| Late arrival | Rows where arrival minus occurrence exceeds the window | Signals a reader or SDK problem |
| Consent | No marketing load for `consent_state <> 'allow'` | A compliance gate, not a quality one |
| PII routing | PII satellites only to permitted targets | The satellite split is pointless if the pipeline rejoins it everywhere |
| Default partitions | `*_default` partitions empty | Rows there mean partition maintenance has fallen behind |

The last one is cheap and catches a slow failure: a default partition filling
up means nobody created next month's partitions.

## What this repository does not provide

No pipeline code, no orchestration, no Delta or DLT definitions, no synthetic
data at volume. The contract is specified; the implementation is deliberately
out of scope.
