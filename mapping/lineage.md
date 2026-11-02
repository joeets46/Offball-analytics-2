# Lineage

What the mapping says, what it does not, and every place it is uncertain.

## The files

| File | Rows | Coverage |
|---|--:|---|
| [table_level_mapping.csv](table_level_mapping.csv) | 153 | Every in-scope target table |
| [out_of_scope.csv](out_of_scope.csv) | 47 | Every excluded target table, with the reason |
| [column_level_key_tables.csv](column_level_key_tables.csv) | 1,438 | Every column of 31 key tables |

The first two together account for exactly 200 tables, which
`offball-check` and `tests/test_mapping_coverage.py` both assert.

## Table-level: the shape of it

| Transform | Count | Meaning |
|---|--:|---|
| `join` | 105 | Source header and line, or master and organisational view, flattened to one target row |
| `1:1` | 38 | Same grain |
| `derive` | 8 | No direct source row; computed from source attributes |
| `union` | 2 | Rows from several sources, deduplicated on a business key |

**105 joins out of 153 is not a modelling choice — it is what source systems
are.** Every SAP document is a header plus lines (`bkpf`/`bseg`,
`vbrk`/`vbrp`, `rbkp`/`rseg`, `reguh`/`regup`); every SAP master record is a
client view plus an organisational view (`ska1`/`skb1`, `kna1`/`knb1`,
`lfa1`/`lfb1`, `mara`/`marc`/`mard`). Salesforce splits object and line item
four times over. The target model flattens each pair, so the grain of
`finance.journal_entry` is the document *line*: a 400-line payroll posting
becomes 400 target rows repeating the header 400 times.

Ownership by system:

| System | Target tables |
|---|--:|
| `sap_s4` | 33 |
| `tm_axs` | 30 |
| `sfdc_crm` | 26 |
| `dalet` | 20 |
| `archtics` | 14 |
| `adobe_aep` | 8 |
| `shopify` | 8 |
| `sap_sfsf` | 7 |
| `hudl` | 5 |
| `workday_ap` | 2 |

## Confidence, and the 15 low-confidence calls

**93 high, 45 medium, 15 low.**

`low` means there is no real system of record for the concept and the assigned
owner models only part of it. Every one carries a note in the mapping saying
what is missing, and a test enforces that — an unexplained `low` is
indistinguishable from carelessness.

| Target table | Owner | What is actually missing |
|---|---|---|
| `event.tournament` | `tm_axs` | TM/AXS models tournaments as event *groupings*, not competition structures |
| `event.bracket` | `tm_axs` | No source for bracket topology; derived from group nesting |
| `event.competition_round` | `tm_axs` | A round is a grouping level, not a first-class entity |
| `event.officiating_assignment` | `sap_sfsf` | Officials are contractors in HCM; the assignment itself has no source |
| `venue.safety_incident` | `tm_axs` | Overlaps the security incident log; no EHS system exists |
| `athlete.draft_selection` | `sap_sfsf` | Modeled as recruiting; pick order and traded picks have no source |
| `athlete.eligibility_status` | `sap_sfsf` | Derived from employment status; no eligibility system |
| `athlete.suspension_record` | `sap_sfsf` | Appears as unpaid leave; the disciplinary origin is out of scope |
| `fan.club_membership` | `sfdc_crm` | Minimal signal; modeled as an account-contact relation |
| `broadcast.audience_rating` | `adobe_aep` | Panel ratings come from Nielsen-style providers; AEP has only owned-platform viewing |
| `merchandise.supplier_category_authorization` | `sap_s4` | Derived from vendor material groups |
| `league.league` | `sap_s4` | A league is a competition, not a company code |
| `league.conference` | `sap_s4` | Modeled as a profit-centre grouping; genuinely a competition structure |
| `league.division` | `sap_s4` | Same |
| `league.team` | `sap_s4` | No affinity signal; Hudl has the operational record but no commercial attributes |

The four `league.*` entries are one decision, argued at length in
[../docs/08-scope-boundary.md](../docs/08-scope-boundary.md). Short version:
**the structure is sourced, the competition semantics are not** — and dropping
them would strand 157 foreign key columns from eight other domains.

## The 8 derived mappings

No source row exists; the target row is computed. These are the ones a pipeline
has to implement rather than copy, and the ones most likely to be wrong.

| Target table | Derived from | What could go wrong |
|---|---|---|
| `event.bracket` | `tm_axs.event_group` nesting | Bracket topology is inferred from a hierarchy that was not built to express it |
| `event.competition_round` | `tm_axs.event_group` levels, `event` | Round boundaries are a grouping convention, not data |
| `broadcast.blackout_rule` | `dalet.rights_window` conditions | Must evaluate territory arrays *and* live sellout state — see below |
| `athlete.free_agency_status` | `sap_s4.veda` expiry dates | Depends on contract interpretation, including options and notice periods |
| `athlete.eligibility_status` | `sap_sfsf.emp_employment` | Approximate by definition |
| `merchandise.supplier_category_authorization` | `sap_s4.lfa1`, `mara` | Inferred from material groups |
| `sponsorship.performance_metric` | `sfdc_crm.campaign`, rolled up from AEP and Dalet | Three-system roll-up with no single owner |
| `fan.loyalty_transaction` | `sfdc_crm.sales_order` by order class | Point movements recorded as orders |

### The hardest one

`broadcast.blackout_rule` is derived from
`dalet.rights_window.blackout_until_sellout` and `blackout_radius_km`. The
first of those is the classic local-blackout term: **no local broadcast until
the venue sells out.**

Evaluating it requires reading live ticketing inventory —
`archtics.event_manifest.seats_sold` against
`archtics.manifest.sellable_capacity` — from inside a broadcast rights
decision. That is a dependency spanning two source systems and three
conceptual subject areas, and it is the single clearest demonstration that
this is one model rather than ten unrelated databases.

## The 2 union mappings

| Target table | Unions | Deduplicated on |
|---|---|---|
| `event.event_incident` | `tm_axs.security_incident`, `tm_axs.event_day_log` | Incident number; the two sources record different kinds of event-day problem |
| `fan.payment_method` | `tm_axs.payment_method`, `shopify.payment_method` | Processor token — the same card tokenized by the same processor is one instrument |

That second one is worth noting: deduplicating on the token rather than on card
last-four plus expiry is what stops one person's card appearing as two
instruments. Tokens are processor-specific, so the union key is
`(processor_name, processor_token)`.

## The 213 unresolved foreign keys

213 in-scope columns declare a foreign key to a table that is **out of scope**.
They are kept as nullable columns with no `REFERENCES` clause.

Full list: [../tools/derived/unresolved_fks.csv](../tools/derived/unresolved_fks.csv).

Heaviest targets:

| Out-of-scope target | Inbound FK columns |
|---|--:|
| `compliance.governing_body` | 30 |
| `league.standing`, `league_schedule`, `game_result` and the rest of competitive operations | ~95 combined |
| `league.salary_cap`, `draft`, `draft_pick`, `trade_transaction`, `transaction_window` | ~45 combined |
| `compliance.policy`, `obligation`, `regulatory_filing` | ~25 combined |
| `gaming.*` | ~15 combined |

This is deliberate and it is the honest representation. The target model
declares the relationship; the source tier genuinely cannot populate it,
because the table at the other end has no source system. Dropping the columns
would misrepresent the target; fabricating values would misrepresent reality.

**A pipeline should load these as null and not treat it as an error.**

## Column-level mapping: read the status column

1,438 rows across 31 key tables. Everything derivable from the upstream model
is populated — type, primary key, FK target, value domain, classification, PII
tags, owning system, source tables, transform, and the upstream `references`
text.

The `mapping_status` column says how much to trust the `source_column` value:

| Status | Rows | Meaning |
|---|--:|---|
| `needs_review` | 625 | Name does not follow a derivable convention. **A starting point, not a mapping.** |
| `derived` | 451 | Name follows a reliable convention and the source column is almost certainly the same |
| `identity_resolution` | 353 | A surrogate key. Does **not** come across directly — it is minted during identity resolution via `common.entity_xref` |
| `pipeline_assigned` | 9 | Set by the pipeline, e.g. `source_system_code` |

**The 353 `identity_resolution` rows are the most important thing the column
mapping says.** Nearly a quarter of the columns in the key tables are
surrogate keys that no source system provides. They are not mapped; they are
*created*, and creating them correctly is the single largest piece of work in
building the pipeline.

The 625 `needs_review` rows are labelled rather than guessed because a guess
presented as a mapping is worse than a blank. Resolving them is per-column
work against the real source systems, and it is explicitly out of scope here.

## Reproducing all of it

```bash
uv run offball-extract          # derive from model.json
uv run offball-mapping          # table level + out of scope
uv run offball-column-mapping   # column level for the key tables
uv run offball-check            # assert completeness
uv run pytest                   # the same assertions plus the DDL cross-check
```

`offball-check` is the one that matters. It has already caught two phantom
tables — `dalet.placeholder` and `dalet.title` — that existed in the mapping
and nowhere in the DDL, because the physical model had modeled both as
attributes of `media_object` instead. That is exactly the kind of drift a
mapping accumulates when nothing verifies it.
