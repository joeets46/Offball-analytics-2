# Logical model

169 entities in third normal form, platform-neutral. No vendor types, no
physical keys, no indexes.

The model is in [../logical/](../logical/), five files by subject area, with
[README.md](../logical/README.md) explaining what normalization changed and
[logical-erd.md](../logical/logical-erd.md) rendering it.

| Subject area | Entities | Relationships |
|---|--:|--:|
| Competition & Events | 37 | 54 |
| Venue & Access | 26 | 35 |
| Commerce & Fan | 44 | 64 |
| Media & Rights | 28 | 37 |
| Corporate | 34 | 61 |
| **Total** | **169** | **251** |

`tests/test_logical_model.py` verifies every relationship resolves to a
declared table and column, every entity has an identifier, and the supertypes
are present with their subtypes keyed on the parent.

## The four things normalization changed

### 1. 32 associative entities, against the upstream model's 6

The upstream readme is explicit that the MVM "minimises M:N associations and
relies on direct foreign key relationships for simplicity". Only 6 of its 200
tables are associative.

That is a sound choice for a star schema and the wrong one for a transactional
model, because it makes a multi-valued relationship single-valued. Three
examples of what it costs:

- **`fixture.franchise_id` plus `fixture.fixture_franchise_id`** is two columns
  for home and away. A three-way race, a tournament group or a relay cannot be
  represented at all. The logical model has `event_participant_team`.
- **`rights_window`** has one channel column. A window permitting three
  channels needs three rows, so the logical model has
  `rights_window_channel`, `rights_window_territory` and
  `rights_window_language` — because a right is never a single value on any of
  those axes.
- **`match_event_qualifier`** has no upstream equivalent at any point. It is
  what a coded match event *means*: "shot, right foot, inside box, on target"
  is four rows. Without it the lakehouse receives the aggregate number and none
  of the semantics.

### 2. Four supertypes

Two cases where the upstream model flattened different things into one wide
table, and two where it split one thing across several.

| Supertype | Subtypes | Why |
|---|---|---|
| `party` | person, organisation, and 8 roles | The same human is often two roles — an academy coach who holds a season ticket. The upstream model repeats name/address/contact across 7+ tables, so that person is several unrelated rows |
| `event` | competitive_fixture, performance_event, plus schedule and outcome split out | 52 upstream columns handling matches and concerts at once |
| `sales_order` | ticket, merchandise, subscription, renewal | Four upstream order tables because four systems produce them |
| `agreement` | playing contract, rights, sponsorship, licence, lease | **Nine upstream agreement types all resolve to one SAP table (`veda`)** in the physical tier |

That last row is the strongest evidence in the project that a supertype is real
rather than an abstraction imposed for tidiness: the source system already
treats them as one thing.

`party_role` is the load-bearing piece. One party holds several roles,
concurrently or over time, and modelling roles as separate top-level tables
makes that impossible to state.

### 3. Value domains normalized

684 columns carry an enumerated value domain upstream, all stored as bare
`STRING`, and 278 are explicitly flagged `ENUM-REF-CANDIDATE` by the upstream
generator — which is the generator recording what it discarded.

Each becomes a reference entity where the list is business-meaningful and
shared, or an attribute domain where it is a protocol the application branches
on. The rule and the counts are in [06-conventions.md](06-conventions.md).

### 4. Fat tables split by lifecycle

The upstream model averages 45.5 columns per table, and its widest tables mix
facts with different lifecycles, different writers and different trust levels.
A column that stays null until a later, different process fills it is a fact
about a different entity.

`event.fixture` (52 columns) becomes four:

| Entity | Holds | Written by | When |
|---|---|---|---|
| `event` | Identity, type, naming | Scheduling | At announcement |
| `event_schedule` | Times, venue, configuration | Operations | Confirmed, then revised |
| `event_outcome` | Score, result, how decided | Officials and analysis | After the event |
| `event_configuration` | Attendance, seats sold and held | Ticketing and finance | Days later |

The same treatment applies to `fan.membership` (66 columns),
`sponsorship.activation` (64), `content.license` (61) and
`sponsorship.deal` (58).

## What the logical model deliberately does not do

**It does not resolve the cross-system identity problem.** `party` is one
entity here; in the physical tier the same person exists as five unrelated
records in five systems. That is not a modelling failure — it is the actual
state of the world, and pretending otherwise at this layer would hide the work
`common.entity_xref` has to do.

**It does not pick physical types.** `money` is a domain, not
`NUMERIC(18,4)`. Whether a key is `BIGINT`, `CHAR(18)` or `UUID` is decided per
system in the physical tier, and the fact that those choices differ is the
point of modelling ten systems separately.

## Next layer

[03-physical-model-oltp.md](03-physical-model-oltp.md) — ten PostgreSQL 18
schemas, each in its own system idiom.
