# Logical model

Platform-neutral third normal form. No vendor types, no physical keys, no
partitioning, no indexes — those belong to [oltp/](../oltp/). What is here is
the structure the business has, independent of which system happens to hold it.

Five files, one per conceptual subject area:

| File | Subject area |
|---|---|
| [01-competition-events.dbml](01-competition-events.dbml) | Competition & Events |
| [02-venue-access.dbml](02-venue-access.dbml) | Venue & Access |
| [03-commerce-fan.dbml](03-commerce-fan.dbml) | Commerce & Fan |
| [04-media-rights.dbml](04-media-rights.dbml) | Media & Rights |
| [05-corporate.dbml](05-corporate.dbml) | Corporate |

[logical-erd.md](logical-erd.md) renders them as diagrams.

Written in [DBML](https://dbml.dbdiagram.io/). Validate or render with:

```bash
npx @dbml/cli validate logical/*.dbml      # or paste into dbdiagram.io
```

## What normalization actually changed

This is the layer where the work is visible. Four kinds of change, each one
undoing something the upstream model did for analytical convenience.

### 1. Many-to-many relationships put back

The upstream MVM states plainly that it "minimises M:N associations and relies
on direct foreign key relationships for simplicity" — only **6 of its 200
tables** are associative. That simplification is cheap in a star schema and
wrong in a transactional model, because it makes the relationship
single-valued when it is not.

| Associative entity restored | What the upstream model does instead | What breaks |
|---|---|---|
| `fixture_team` | `fixture.franchise_id` plus `fixture.fixture_franchise_id` | Two columns for home and away means a three-way race or a tournament group cannot be represented |
| `fixture_athlete` | `event.participant` with one fixture per row | Workable, but the upstream table also carries non-athlete participants, so the grain is ambiguous |
| `fixture_official` | `event.officiating_assignment` | Workable |
| `athlete_agent` | `athlete.agent_relationship` | Workable, though it cannot express joint representation |
| `seat_attribute_assignment` | Booleans and STRING columns on `venue.seat` | Attribute history is lost, and adding an attribute needs a schema change |
| `configuration_area` | `venue.config_section_allocation` | Retained upstream |
| `fan_segment` | `fan.segment_assignment` | Retained upstream |
| `asset_collection` | `content.collection_item` | Retained upstream |
| `rights_window_channel` | — | No upstream equivalent; a window permitting three channels cannot be stated |
| `agreement_asset` | `sponsorship.inventory_allocation` | Retained upstream |
| `access_grant_zone` | — | No upstream equivalent; a credential reaching four zones needs four rows or a list |
| `instance_label` | — | No upstream equivalent at all. This is the one that costs most: it is what a coded match event *means* |

### 2. Supertypes introduced

Two places where the upstream model flattened genuinely different things into
one wide table with mostly-null columns, and two where it split one thing
across several.

**`party` supertype** over Fan, Athlete, Agent, Official, Employee,
Counterparty. All six carry the same name, address, contact and identifier
structure, and the upstream model repeats that structure across 7+ tables.
More importantly, **the same human is often two of them**: an academy coach who
is also a season-ticket holder, a retired athlete who becomes an agent. With
separate tables that person is two unrelated rows.

**`event` supertype** over Competitive Fixture, Concert, Pay-Per-View,
Ceremony. The upstream `event.fixture` has 52 columns handling all four, so a
concert carries `home_score`, `var_used` and `penalty_shootout` as nulls, and a
match carries nothing to describe a support act. The subtype split puts the
competitive attributes where they belong.

**`sales_order` supertype** over Ticket Order, Merchandise Order, Subscription,
Membership Renewal. This is the reverse case — the upstream model has four
separate order tables because four separate systems produce them. One supertype
with four subtypes is what lets fan lifetime value be a sum rather than a
union.

**`agreement` supertype** over Rights Agreement, Sponsorship Agreement,
Licensing Agreement, Playing Contract, Suite Lease. All five are *a dated
commitment between two parties with financial terms*, and in the physical tier
all five genuinely do come from one SAP table (`veda`), which is the clearest
possible evidence that the supertype is real rather than an abstraction for its
own sake.

### 3. Value domains normalized

The extractor finds **684 columns carrying an enumerated value domain** and
**278 explicitly flagged `ENUM-REF-CANDIDATE`** by the upstream generator —
which is the generator recording what it discarded. All of them are stored
upstream as bare `STRING`.

In the logical model each becomes a reference entity where the list is
business-meaningful and shared, and an attribute domain where it is a protocol
the application branches on. The rule and the counts are in
[docs/06-conventions.md](../docs/06-conventions.md).

### 4. Fat tables split by lifecycle

The upstream model averages 45.5 columns per table, and its widest tables mix
facts with different lifecycles, different writers and different trust levels.
Splitting them is 3NF doing its job: a column that is null until a later,
different process fills it is a fact about a different entity.

`event.fixture` (52 columns) becomes four entities:

| Entity | What it holds | Who writes it | When |
|---|---|---|---|
| `event` | Identity, type, naming | Scheduling | At announcement |
| `event_schedule` | Planned and actual times, venue, configuration | Operations | Confirmed, then revised |
| `event_outcome` | Score, result, how decided | Match officials and analysis | After the event |
| `event_reconciliation` | Attendance, revenue posting, cost centre | Finance | Days later |

The same treatment applies to `fan.membership` (66 columns), `gaming.contest`
(61) — out of scope — `content.license` (61), `sponsorship.activation` (64) and
`sponsorship.deal` (58).

## What the logical model deliberately does *not* do

It does not resolve the cross-system identity problem. `party` is one entity
here, and in the physical tier the same person exists as five unrelated records
in five systems. That is not a modelling failure — it is the actual state of
the world, and pretending otherwise at this layer would hide the work that
[common.entity_xref](../sql/01_common.sql) has to do.

It also does not pick physical types. `money` is a domain here, not
`NUMERIC(18,4)`; whether a key is `BIGINT`, `CHAR(18)` or `UUID` is decided per
system in the physical tier, and the fact that those choices differ is the
point of modelling ten systems separately.
