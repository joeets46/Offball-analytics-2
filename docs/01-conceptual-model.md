# Conceptual model

38 business entities in five subject areas. No attributes beyond identifiers,
no keys, no foreign keys, and many-to-many relationships left unresolved.

The model itself is in [../conceptual/](../conceptual/):

- [subject-areas.md](../conceptual/subject-areas.md) — the five areas, every
  entity, and the cross-area relationships that carry the business
- [conceptual-erd.md](../conceptual/conceptual-erd.md) — six Mermaid diagrams,
  one per area plus the spine

This document explains the two decisions behind it.

## Decision 1 — five subject areas, not fourteen domains

The upstream MVM has 14 domains. Several are the same business concern split by
*who consumes the data* rather than by *what the data is*:

| Upstream split | Actually one concern |
|---|---|
| `event` + `league` | Who plays whom, when. Split because scheduling and governance are different departments |
| `ticketing` + `fan` | Who comes and what they buy. A season-ticket holder is not a different kind of thing from a fan |
| `content` + `broadcast` | What gets made and where it is shown. Split is production versus distribution |
| `security` | Not a business concern at this level — it is the access control `venue` and `event` require |

Collapsing them gives five areas that each answer one question:

| Area | Question |
|---|---|
| Competition & Events | Who plays whom, when, and what happened |
| Venue & Access | Where it happens, and who may be where |
| Commerce & Fan | Who comes, who buys, and what they buy |
| Media & Rights | What is made, who may show it, who paid to appear in it |
| Corporate | What it cost, what it earned, and what was promised |

A domain structure is a good way to *publish* a lakehouse. It is a poor way to
explain a business to someone who runs one, which is what a conceptual model is
for.

`gaming` has no area because the whole domain is out of scope — see
[08-scope-boundary.md](08-scope-boundary.md).

## Decision 2 — six entities that differ from the upstream model

Each of these is a place where the upstream model and this one disagree about
what a thing *is*. They are the decisions that propagate through the logical
and physical layers.

### Fixture covers every kind of event

A league match, a concert, a pay-per-view bout and an awards show are all *a
scheduled thing that happens at a venue on a date and that people buy tickets
for*. They differ only in whether a Result exists.

The upstream `event.fixture` already does this — with 52 columns, so a concert
carries `home_score`, `var_used` and `penalty_shootout` as nulls. The
conceptual model agrees it is one entity; the logical model subtypes it so the
competitive attributes sit where they belong.

### Franchise and Team are different things

A franchise persists through relocation, rebranding and relegation. A team is
the squad that takes the field, and one franchise fields several at once —
first team, academy, women's.

The upstream model has both `league.franchise` and `league.team` but treats
them as near-duplicates. Keeping them genuinely distinct is what lets an
athlete's engagement be with the franchise while their appearances are for a
team.

### Access Grant covers a ticket and a staff pass

Both are *permission for a person to be in a place during a period*. One is
sold, one is issued, which the logical model handles as subtypes.

The upstream model has `ticketing.access_entitlement` and
`security.credential` as unrelated tables in different domains — and both are
sourced from the same TM/AXS access-control stack, which is the evidence that
they are one concept.

### Admission is separate from Access Grant

A sold ticket and an actual arrival are different facts. The gap between them
is the no-show rate, which is one of the few numbers a venue operator checks
every single matchday.

Keeping them separate also means every *refused* presentation is retained,
which is what fraud investigation reads.

### Sales Order is one entity

A ticket order, a merchandise order, a season-ticket renewal and a subscription
are the same conceptual act: a commitment to buy.

The upstream model has four separate order tables because four separate systems
produce them. That is a source-system distinction promoted into the business
model, and it is why fan lifetime value needs a union across four tables
downstream instead of being a sum.

### Fan and Fan Account are separate

They differ in cardinality in both directions. One household account covers
four fans; one fan holds accounts in three systems.

The upstream model has `fan.fan_profile` and `fan.account` but relates them
one-to-one. Conflating them is the commonest cause of double-counted
supporters, and the logical model adds a `fan_account_member` associative
entity to resolve it.

## The spine

Stripped to what carries the business, the whole model is twelve
relationships:

```
season -> fixture -> access_grant -> admission
             |            |
             |            +-> sales_order -> payment -> financial_transaction
             |
             +-> media_asset -> rights_window
             +-> activation
venue -------+
franchise ---+
fan ---------+
```

**Every one of those twelve crosses a source-system boundary in the physical
tier.** That is the whole reason `common.entity_xref` exists, and the reason
the target model's 1,477 cross-domain foreign keys are a product of integration
rather than something any source system hands over.

## What the conceptual model deliberately does not do

- **No attributes.** If an attribute is needed to understand what an entity
  *is*, the entity is wrong.
- **No resolved many-to-many.** Resolving them is the logical model's job, and
  doing it here would hide which relationships are genuinely multi-valued.
- **No keys.** An entity is identified by what it is, not by how a database
  would find it.
- **No system names.** A business stakeholder should be able to read
  `subject-areas.md` without knowing that Archtics exists.

## Next layer

[02-logical-model.md](02-logical-model.md) — 169 entities in 3NF, with the
supertypes and the 32 associative entities the upstream model drops.
