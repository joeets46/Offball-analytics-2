# Conceptual model — subject areas

Technology- and system-agnostic. No attributes beyond identifiers, no keys, no
foreign keys, and many-to-many relationships left unresolved — resolving them
is the logical model's job.

The 38 entities below are grouped into five subject areas. The grouping is not
the upstream model's 14 domains: domains are a *publishing* structure for a
lakehouse, whereas subject areas are meant to be legible to someone who runs
the business. Where the two differ, the mapping is stated.

## Why five areas and not fourteen

The upstream MVM has 14 domains. Several of them are the same business concern
split by who consumes the data rather than by what the data is:

- `event` and `league` are one concern — **who plays whom, when**. The split
  exists because scheduling and governance are different departments.
- `ticketing` and `fan` are one concern — **who comes, and what they buy**. A
  season-ticket holder is not a different kind of thing from a fan.
- `content` and `broadcast` are one concern — **what gets made and where it is
  shown**. The split is production versus distribution.
- `security` is not a business concern at all at this level; it is the access
  control that `venue` and `event` require.

Collapsing them produces five areas that each answer one question.

| # | Subject area | The question it answers | Upstream domains |
|---|---|---|---|
| 1 | **Competition & Events** | Who plays whom, when, and what happened | `event`, `league` (structure only), `athlete` |
| 2 | **Venue & Access** | Where it happens, and who may be where | `venue`, `security` |
| 3 | **Commerce & Fan** | Who comes, who buys, and what they buy | `ticketing`, `fan`, `merchandise` |
| 4 | **Media & Rights** | What is made, who may show it, and who paid to appear in it | `broadcast`, `content`, `sponsorship` |
| 5 | **Corporate** | What it cost, what it earned, and what was promised | `finance`, `compliance` (partial) |

`gaming` is absent: the whole domain is out of scope, because none of the ten
named source systems is a sportsbook or a fantasy platform. See
[docs/08-scope-boundary.md](../docs/08-scope-boundary.md).

## 1. Competition & Events

The structural spine. Everything else in the model ultimately hangs off a
Fixture.

| Entity | What it is |
|---|---|
| **League** | The competition organiser and rule-setter |
| **Conference** | A competitive grouping within a league |
| **Division** | A competitive grouping within a conference |
| **Franchise** | The club as a continuing enterprise, distinct from its current squad |
| **Team** | A squad that takes the field: first team, academy, women's |
| **Season** | A competitive and commercial cycle |
| **Competition** | A trophy or series contested within a season |
| **Fixture** | One scheduled live event — the anchor of the whole model |
| **Fixture Result** | What happened: score, outcome, how it was decided |
| **Match Event** | A single moment within a fixture — a goal, a card, a substitution |
| **Athlete** | A person who competes |
| **Athlete Engagement** | The relationship between an athlete and a franchise over a period |
| **Agent** | A person who represents athletes |
| **Agency** | The firm an agent works for |
| **Official** | A person who officiates |
| **Performance Measure** | A quantified assessment of an athlete in a fixture |
| **Availability** | Whether an athlete can play, and why not |

**Fixture and Event are deliberately one entity.** A league match, a concert, a
pay-per-view bout and an awards show are all *a scheduled thing that happens at
a venue on a date and that people buy tickets for*. They differ in whether they
have a Result, which the logical model handles as a subtype rather than as four
separate entities.

**Franchise and Team are deliberately two.** A franchise persists through
relocation, rebranding and relegation; a team is the squad that plays. The same
franchise fields several teams at once, and the upstream model conflates them.

## 2. Venue & Access

| Entity | What it is |
|---|---|
| **Venue** | A building where fixtures happen |
| **Seating Area** | A named subdivision of a venue, at any level of nesting |
| **Seat** | One physical place to sit |
| **Seating Configuration** | A reusable arrangement of a venue for a class of event |
| **Access Zone** | An area entry to which is controlled |
| **Access Point** | A place where entry is granted or refused |
| **Access Grant** | Permission for someone to be somewhere, for a period |
| **Admission** | An actual instance of someone being admitted or refused |
| **Facility Asset** | A durable thing in a venue that is maintained: a lift, a pitch, a scoreboard |
| **Maintenance Event** | Work done, or needing doing, on a facility asset |

**Seating Area is recursive on purpose.** A real venue nests to four or five
levels — tier, block, section, row — and the depth differs between venues and
even between configurations of the same venue. Fixing the hierarchy at a
particular depth, as the upstream model does with three tables, means that one
of those tables is wrong for most venues.

**Access Grant covers a ticket and a staff pass.** Both are *permission for a
person to be in a place during a period*. The logical model subtypes them,
because a ticket is sold and a pass is issued, but the conceptual entity is one.

## 3. Commerce & Fan

| Entity | What it is |
|---|---|
| **Fan** | A person who follows, attends or buys |
| **Fan Account** | A commercial relationship between a fan and the organisation |
| **Membership** | A continuing, paid entitlement: a season ticket, a club, a loyalty tier |
| **Segment** | A named group of fans, defined by a rule |
| **Consent** | What a fan has permitted, for what purpose, and when |
| **Interaction** | Something a fan did, or something the organisation did to them |
| **Service Case** | A problem a fan raised, and its resolution |
| **Sales Order** | A commitment to buy, of any kind |
| **Order Line** | One thing committed to, within an order |
| **Payment** | Money moving in, or back out |
| **Product** | Something that can be sold: a ticket, a shirt, a subscription |
| **Stock Position** | How much of a product is where |
| **Shipment** | Goods moving to a fan |
| **Return** | Goods coming back, and why |

**Sales Order is one entity, not four.** A ticket order, a merchandise order, a
season-ticket renewal and a subscription are the same conceptual act. The
upstream model has `ticketing.ticket_order`, `merchandise.merch_order` and two
more, which is a *source-system* distinction promoted into the business model —
and it is why fan lifetime value cannot be computed in the lakehouse without a
union.

**Fan and Fan Account are separate because they differ in cardinality.** One
household holds one season-ticket account but contains four fans; one fan holds
accounts in three systems. Treating them as one entity is the single biggest
cause of double-counted supporters.

## 4. Media & Rights

| Entity | What it is |
|---|---|
| **Media Asset** | A piece of content, as an editorial thing |
| **Asset Rendition** | One physical file of a media asset, at a quality and format |
| **Collection** | A curated grouping of media assets |
| **Distribution Channel** | A place content can be shown |
| **Broadcast Schedule** | What will be shown where and when |
| **Rights Agreement** | A deal granting or acquiring the right to show something |
| **Rights Window** | A specific permission: what, where, when, how |
| **Counterparty** | The other party to a commercial agreement |
| **Sponsorship Agreement** | A deal to associate a brand with the organisation |
| **Sponsorship Asset** | Something sponsorable: a shirt front, a stand, a broadcast slot |
| **Activation** | A specific use of a sponsorship asset |

**Media Asset and Asset Rendition are separate because the economics differ.**
One highlights package exists as a 4K master, a proxy and four social cutdowns.
The editorial decision is made once; the storage and delivery cost is incurred
six times. The upstream model has only the asset.

**Rights Agreement and Rights Window are separate because one deal grants
many.** A single broadcast contract grants live rights in one territory,
delayed rights in another, and clip rights globally, each with its own period
and conditions. Compliance operates on the window, not the agreement.

**Counterparty is shared across Media & Rights and Corporate.** A rights
holder, a licensee, a sponsor and a supplier are all *an organisation we have
an agreement with*. The upstream model has four separate tables, all sourced
from the same Salesforce Accounts.

## 5. Corporate

| Entity | What it is |
|---|---|
| **Legal Entity** | A company that owns, earns and reports |
| **Cost Centre** | Where money is spent |
| **Profit Centre** | Where money is earned |
| **Account** | A classification of money |
| **Financial Period** | A reporting window |
| **Financial Transaction** | A posting that moves money between accounts |
| **Invoice** | A claim for money, in either direction |
| **Budget** | An intention about future money |
| **Processing Record** | What personal data is used for, and on what basis |

**Budget and Financial Transaction are different kinds of thing.** One is an
intention and one is a fact; they live in different systems and are versioned
differently. The upstream model treats budget as another finance table, which
loses the version dimension entirely — an approved budget and a what-if
scenario arrive indistinguishable.

## Cross-area relationships that matter

These are the relationships that make the model a model rather than five lists.
Each one crosses a subject-area boundary, and each one crosses a source-system
boundary in the physical tier.

| Relationship | Why it matters |
|---|---|
| Fixture — Venue | Everything operational follows from where and when |
| Fixture — Seating Configuration | Determines what can be sold |
| Access Grant — Seat — Fixture | A ticket is permission for a seat at a fixture |
| Fan — Access Grant | Who is actually coming |
| Admission — Access Grant | Who actually came, which is not the same thing |
| Sales Order — Payment — Financial Transaction | The revenue chain, crossing three systems |
| Fixture — Media Asset — Rights Window | Whether a highlight may legally be shown |
| Sponsorship Asset — Fixture | What a sponsor actually got |
| Athlete — Athlete Engagement — Franchise | Who plays for whom, over time |
| Rights Window — Seating Configuration | Blackout-until-sellout couples a rights rule to live ticket inventory |

That last one is the sharpest illustration of why this is one model and not
five: a broadcast rights condition cannot be evaluated without reading
real-time ticketing inventory.

## Diagram

[conceptual-erd.md](conceptual-erd.md) draws all 38 entities and the
relationships above.
