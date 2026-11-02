# Scope boundary

**153 of the 200 upstream MVM tables are in scope. 47 are not.**

The exclusions are not arbitrary and they are not a shortcut. This project
models exactly the ten operational systems the upstream model names as its own
systems of record, and the parts of the target model that no named system can
plausibly source are out of scope rather than invented.

The complete register is [mapping/out_of_scope.csv](../mapping/out_of_scope.csv),
which carries every excluded table with its reason and the class of system that
would bring it in. `offball-check` and `tests/test_mapping_coverage.py` both
assert that the in-scope mapping and the exclusion register together account
for exactly 200 tables, with nothing missing and nothing invented.

## How the boundary was determined

Measured first, reviewed second.

Every one of the 9,102 upstream columns carries a `references` field naming the
system or standard it came from. Scanning that text for each of the ten named
systems gives a per-table affinity score — how often each system is named in a
table's own metadata. The raw measurement is in
[tools/derived/mvm_tables.csv](../tools/derived/mvm_tables.csv), column
`system_affinity`.

Per domain, the share of tables with any named-system reference at all:

```
ticketing   15/15      merchandise 14/14      compliance   7/14  <-- thin
fan         15/16      content     10/12      gaming       8/18  <-- thin
venue       14/16      broadcast   10/12      league      14/18  <-- incidental only
event       13/14      sponsorship 10/12      security    10/11
athlete     12/14      finance     12/14
```

The text scan alone overstates the gap, because pure reference and associative
tables rarely cite a system even when their owner is obvious — 36 tables score
zero, including `finance.fiscal_period` (plainly SAP) and `athlete.agent`
(plainly a Salesforce Contact). So the scan was reviewed by hand, and the
final boundary is a judgement informed by the measurement rather than the
measurement applied mechanically.

## The 47 excluded tables

| Domain | Excluded | # | Why no named system can source it |
|---|---|--:|---|
| `gaming` | the entire domain, all 4 subdomains | 18 | No sportsbook and no daily-fantasy platform among the ten |
| `compliance` | `athlete_integrity` (4), `audit_investigations` (4), `regulatory_obligations` (4), `privacy_request` | 13 | No WADA ADAMS, no GRC or case-management system, no DSAR intake portal |
| `league` | `competitive_operations` except `season` (7), all of `roster_transactions` (5) | 12 | No league competition-management system |
| `security` | `emergency_management` (3) | 3 | No emergency-management or mass-notification system |
| `venue` | `safety_inspection` | 1 | No CMMS or EHS system |

### gaming — all 18 tables

`betting_market`, `odds_feed`, `wager`, `prop_bet`, `selection`,
`bettor_account`, `wallet`, `responsible_gaming_limit`, `self_exclusion`,
`fantasy_league`, `fantasy_team`, `fantasy_roster`, `contest`, `contest_entry`,
`payout`, `jurisdiction`, `regulatory_report`, `operator`.

The AEP, SAP and Salesforce references that appear in this domain are about
fan-profile linkage and payment settlement, not about wagering. Nothing in the
ten systems accepts a bet, prices a market, or administers a self-exclusion.

**What would bring it in:** a sportsbook or wagering engine, and a
daily-fantasy contest platform. Both are substantial systems in their own
right, and `gaming` is 18 tables — the second-largest domain in the model — so
this is the single biggest exclusion.

### compliance — 13 of 14 tables

Three different missing systems, not one:

- **`athlete_integrity`** (`doping_test`, `doping_violation`,
  `whereabouts_filing`, `eligibility_certification`) needs **WADA ADAMS**, the
  anti-doping test and whereabouts system. It is operated by the anti-doping
  authority, not the club, and no club system holds its data.
- **`audit_investigations`** (`audit_engagement`, `audit_finding`,
  `arbitration_case`, `investigation`) needs a **GRC or investigation
  case-management system**.
- **`regulatory_obligations`** (`regulatory_filing`, `governing_body`,
  `obligation`, `policy`) needs a **policy and obligation register**.
- **`privacy_request`** needs a **DSAR intake portal**.

`compliance.data_processing_record` is the one table that survives, sourced
from Adobe Experience Platform's data-use labels, consent policies and privacy
jobs. That distinction is worth noticing: AEP *executes* a privacy request that
arrived from somewhere else, so the execution side exists and the intake side
does not.

### league — 12 of 18 tables

Excluded: `league_schedule`, `standing`, `playoff_bracket`, `game_result`,
`official`, `disciplinary_action`, `official_assignment`, `salary_cap`,
`draft`, `draft_pick`, `trade_transaction`, `transaction_window`.

No league competition-management system is among the ten. The SAP and TM/AXS
references that appear against these tables are incidental — a cost centre
here, an event code there — not evidence that either system administers a
draft or computes a standings table.

`league.game_result` is additionally redundant with `event.match_result`, which
Hudl genuinely does source. Keeping both would mean two sources of truth for
the same score.

### security — 3 of 11 tables

Excluded: `emergency_response_plan`, `emergency_activation`,
`plan_zone_designation`.

The other eight security tables stay, sourced from the TM/AXS and Archtics
access-control stack, which genuinely does issue credentials, define zones and
record scans. Emergency management is a different system class — mass
notification, incident command — and none of the ten is one.

### venue — 1 of 16 tables

Excluded: `safety_inspection`.

`venue.maintenance_work_order` **stays**, because SAP Plant Maintenance is
legitimately where a work order lives and SAP S/4HANA is a named system.
Scheduled safety inspection as a compliance regime is a CMMS or EHS concern,
which is not.

## League structure stays in scope — a documented compromise

This is the one call in the whole boundary that deserves to be argued rather
than stated.

`league`, `conference`, `division`, `franchise`, `team` and `season` are **in
scope**, sourced from SAP S/4HANA organisational structures — `t001` company
code, `cepc` profit centre — plus the Salesforce Account hierarchy.

**Why that is defensible.** A franchise genuinely is a legal entity, so company
code plus profit centre is a fair fit. Plenty of real estates do represent club
structure this way, because the finance system is the only place that has to
know about every entity. The `cepc.structure_level` and `t001.entity_role`
columns in the physical model exist precisely to make the distinction explicit
rather than inferred from naming.

**Why it is a compromise anyway.** A league is a competition, not a company
code. A conference is a competitive grouping, not a profit-centre node. The fit
is adequate for the structure and poor for the semantics, which is why
`league.league`, `conference`, `division` and `team` all carry
**`confidence: low`** in the mapping, and `franchise` and `season` carry
`medium`.

**Why not exclude them instead.** Because nearly every other domain references
them. Dropping these six would strand foreign keys from `event`, `athlete`,
`ticketing`, `fan`, `merchandise`, `sponsorship`, `broadcast` and `content` —
157 FK columns in total — and leave a model that could not be loaded
meaningfully. Scaling the model down to the point of uselessness in the name of
purity would be the wrong trade.

The honest summary: **the structure is sourced, the competition semantics are
not.**

## 213 unresolved foreign keys

213 in-scope FK columns point at tables that are out of scope. They are kept as
nullable columns with **no `REFERENCES` clause**, and
[mapping/lineage.md](../mapping/lineage.md) lists every one.

This is deliberate and it is the honest representation. The target model
declares the relationship; the source tier genuinely cannot populate it,
because the table at the other end has no source system. Silently dropping the
columns would misrepresent the target model; fabricating values would
misrepresent reality.

The full list is in
[tools/derived/unresolved_fks.csv](../tools/derived/unresolved_fks.csv). The
heaviest concentrations point at `league.*` competitive operations and
`compliance.governing_body`.

## What this means for anyone deploying the model

Three practical consequences:

1. **`gaming.*` will be empty.** Not under-populated — absent. If wagering
   matters, a sportsbook has to be added as an eleventh source, and the
   `ownership` map plus one new schema directory is where that goes.
2. **Standings, drafts and trades cannot be computed** from this source tier.
   Match results can (via Hudl), so standings are derivable in the lakehouse
   even though `league.standing` has no source.
3. **Anti-doping and audit data has no path in.** Those are the tables most
   likely to be wanted for a governance dashboard, and they are exactly the
   ones that need a system nobody named.

## Reproducing the boundary

The boundary lives in one place — `OUT_OF_SCOPE` in
[tools/scope.py](../tools/scope.py) — and every artifact derives from it:

```bash
uv run offball-extract    # recomputes in/out-of-scope counts
uv run offball-mapping    # regenerates both mapping files
uv run offball-check      # asserts the two together cover 200 tables
uv run pytest             # the same assertions, plus the DDL cross-check
```

Changing the boundary means editing that one dictionary and re-running the
four commands. Nothing else hard-codes which tables are in scope.
