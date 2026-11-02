# Conceptual ERD

38 entities in five subject areas. Identifying attributes only — no keys, no
types, no foreign keys. Many-to-many relationships are drawn as such and are
resolved in the [logical model](../logical/).

Read [subject-areas.md](subject-areas.md) first; it explains why the areas are
grouped as they are and where they diverge from the upstream model's 14 domains.

## Notation

Mermaid crow's-foot. Cardinality is read left to right:

| Symbol | Meaning |
|---|---|
| `||--o{` | one to zero-or-many |
| `||--|{` | one to one-or-many |
| `}o--o{` | many to many (unresolved) |
| `||--o|` | one to zero-or-one |

## 1. Competition & Events

```mermaid
erDiagram
    LEAGUE ||--o{ CONFERENCE : "is divided into"
    CONFERENCE ||--o{ DIVISION : "is divided into"
    LEAGUE ||--o{ SEASON : "runs"
    SEASON ||--o{ COMPETITION : "contains"
    DIVISION ||--o{ FRANCHISE : "admits"
    FRANCHISE ||--|{ TEAM : "fields"
    COMPETITION ||--o{ FIXTURE : "is contested through"
    TEAM }o--o{ FIXTURE : "competes in"
    FIXTURE ||--o| FIXTURE_RESULT : "concludes with"
    FIXTURE ||--o{ MATCH_EVENT : "comprises"
    ATHLETE ||--o{ ATHLETE_ENGAGEMENT : "is party to"
    FRANCHISE ||--o{ ATHLETE_ENGAGEMENT : "is party to"
    ATHLETE }o--o{ FIXTURE : "appears in"
    ATHLETE ||--o{ PERFORMANCE_MEASURE : "is assessed by"
    FIXTURE ||--o{ PERFORMANCE_MEASURE : "is the context of"
    ATHLETE ||--o{ AVAILABILITY : "is subject to"
    ATHLETE }o--o{ AGENT : "is represented by"
    AGENCY ||--|{ AGENT : "employs"
    OFFICIAL }o--o{ FIXTURE : "officiates"
    MATCH_EVENT }o--o| ATHLETE : "is attributed to"

    LEAGUE { string name }
    CONFERENCE { string name }
    DIVISION { string name }
    SEASON { string name }
    COMPETITION { string name }
    FRANCHISE { string name }
    TEAM { string name }
    FIXTURE { string name }
    FIXTURE_RESULT { string outcome }
    MATCH_EVENT { string kind }
    ATHLETE { string name }
    ATHLETE_ENGAGEMENT { string role }
    PERFORMANCE_MEASURE { string measure }
    AVAILABILITY { string status }
    AGENT { string name }
    AGENCY { string name }
    OFFICIAL { string name }
```

Two deliberate choices to notice. **Fixture covers every kind of event** — a
match, a concert, a bout, an awards night — differing only in whether a
Fixture Result exists; the logical model makes that a subtype. **Franchise and
Team are distinct**, because a franchise outlives relocation and rebranding
while fielding several teams at once.

## 2. Venue & Access

```mermaid
erDiagram
    VENUE ||--|{ SEATING_AREA : "is divided into"
    SEATING_AREA ||--o{ SEATING_AREA : "nests within"
    SEATING_AREA ||--o{ SEAT : "contains"
    VENUE ||--|{ SEATING_CONFIGURATION : "can be arranged as"
    SEATING_CONFIGURATION }o--o{ SEATING_AREA : "allocates"
    FIXTURE }o--|| SEATING_CONFIGURATION : "is staged under"
    FIXTURE }o--|| VENUE : "takes place at"
    VENUE ||--|{ ACCESS_ZONE : "is divided into"
    ACCESS_ZONE ||--|{ ACCESS_POINT : "is entered through"
    ACCESS_GRANT }o--o| SEAT : "may entitle"
    ACCESS_GRANT }o--|| FIXTURE : "is valid for"
    ACCESS_GRANT }o--o{ ACCESS_ZONE : "permits entry to"
    ACCESS_GRANT ||--o{ ADMISSION : "is presented as"
    ADMISSION }o--|| ACCESS_POINT : "occurs at"
    VENUE ||--o{ FACILITY_ASSET : "contains"
    FACILITY_ASSET ||--o{ MAINTENANCE_EVENT : "requires"

    VENUE { string name }
    SEATING_AREA { string label }
    SEAT { string label }
    SEATING_CONFIGURATION { string name }
    ACCESS_ZONE { string name }
    ACCESS_POINT { string name }
    ACCESS_GRANT { string kind }
    ADMISSION { string result }
    FACILITY_ASSET { string name }
    MAINTENANCE_EVENT { string kind }
    FIXTURE { string name }
```

**Seating Area nests within itself.** Real venues go tier → block → section →
row, and the depth differs between venues and between configurations of the
same venue. A fixed three-level hierarchy, which is what the upstream model
has, is wrong for most of them.

**Access Grant is one entity covering a ticket and a staff pass**, because both
are permission for a person to be in a place during a period. **Admission is
separate from Access Grant**, and that separation is the point: a sold ticket
and an actual arrival are different facts, and the gap between them is the
no-show rate.

## 3. Commerce & Fan

```mermaid
erDiagram
    FAN ||--o{ FAN_ACCOUNT : "holds"
    FAN ||--o{ CONSENT : "grants"
    FAN ||--o{ INTERACTION : "generates"
    FAN ||--o{ SERVICE_CASE : "raises"
    FAN }o--o{ SEGMENT : "qualifies for"
    FAN_ACCOUNT ||--o{ MEMBERSHIP : "carries"
    FAN_ACCOUNT ||--o{ SALES_ORDER : "places"
    SALES_ORDER ||--|{ ORDER_LINE : "comprises"
    SALES_ORDER ||--o{ PAYMENT : "is settled by"
    ORDER_LINE }o--|| PRODUCT : "is for"
    ORDER_LINE ||--o| ACCESS_GRANT : "may issue"
    PRODUCT ||--o{ STOCK_POSITION : "is held as"
    ORDER_LINE ||--o{ SHIPMENT : "is delivered by"
    SHIPMENT ||--o{ RETURN : "may be reversed by"
    MEMBERSHIP }o--o{ SEAT : "may reserve"
    SERVICE_CASE }o--o| SALES_ORDER : "may concern"

    FAN { string name }
    FAN_ACCOUNT { string identifier }
    MEMBERSHIP { string kind }
    SEGMENT { string name }
    CONSENT { string purpose }
    INTERACTION { string kind }
    SERVICE_CASE { string subject }
    SALES_ORDER { string reference }
    ORDER_LINE { string description }
    PAYMENT { string method }
    PRODUCT { string name }
    STOCK_POSITION { string quantity }
    SHIPMENT { string reference }
    RETURN { string reason }
    ACCESS_GRANT { string kind }
    SEAT { string label }
```

**Sales Order is one entity.** A ticket order, a merchandise order, a renewal
and a subscription are the same conceptual act, and splitting them — which the
upstream model does across four tables — is a source-system distinction
promoted into the business model. It is why fan lifetime value needs a union
downstream.

**Fan and Fan Account differ in cardinality in both directions.** One household
account covers four fans; one fan holds accounts in three systems. Conflating
them is the commonest cause of double-counted supporters.

## 4. Media & Rights

```mermaid
erDiagram
    MEDIA_ASSET ||--|{ ASSET_RENDITION : "exists as"
    MEDIA_ASSET }o--o{ COLLECTION : "is grouped into"
    MEDIA_ASSET }o--o| FIXTURE : "may cover"
    COUNTERPARTY ||--o{ RIGHTS_AGREEMENT : "is party to"
    RIGHTS_AGREEMENT ||--|{ RIGHTS_WINDOW : "grants"
    RIGHTS_WINDOW }o--o| MEDIA_ASSET : "may govern"
    RIGHTS_WINDOW }o--o| COLLECTION : "may govern"
    RIGHTS_WINDOW }o--o{ DISTRIBUTION_CHANNEL : "permits on"
    DISTRIBUTION_CHANNEL ||--o{ BROADCAST_SCHEDULE : "carries"
    BROADCAST_SCHEDULE }o--o{ MEDIA_ASSET : "places"
    BROADCAST_SCHEDULE }o--o| FIXTURE : "may cover"
    COUNTERPARTY ||--o{ SPONSORSHIP_AGREEMENT : "is party to"
    SPONSORSHIP_AGREEMENT }o--o{ SPONSORSHIP_ASSET : "commits"
    SPONSORSHIP_ASSET ||--o{ ACTIVATION : "is used through"
    ACTIVATION }o--o| FIXTURE : "may occur at"
    RIGHTS_WINDOW }o--o| SEATING_CONFIGURATION : "may be conditional on"

    MEDIA_ASSET { string title }
    ASSET_RENDITION { string format }
    COLLECTION { string name }
    DISTRIBUTION_CHANNEL { string name }
    BROADCAST_SCHEDULE { string slot }
    RIGHTS_AGREEMENT { string reference }
    RIGHTS_WINDOW { string kind }
    COUNTERPARTY { string name }
    SPONSORSHIP_AGREEMENT { string reference }
    SPONSORSHIP_ASSET { string name }
    ACTIVATION { string description }
    FIXTURE { string name }
    SEATING_CONFIGURATION { string name }
```

**Media Asset and Asset Rendition are separate because the economics differ:**
the editorial decision is made once, the storage and delivery cost is incurred
once per rendition. **Rights Agreement and Rights Window are separate because
one deal grants many** — live in one territory, delayed in another, clips
globally, each with its own period and conditions.

The dashed-looking relationship at the bottom is the one worth staring at:
`RIGHTS_WINDOW` conditional on `SEATING_CONFIGURATION` is the
blackout-until-sellout term, which couples a broadcast rights rule to live
ticketing inventory. It crosses three subject areas and, in the physical tier,
three separate databases.

## 5. Corporate

```mermaid
erDiagram
    LEGAL_ENTITY ||--o{ COST_CENTRE : "operates"
    LEGAL_ENTITY ||--o{ PROFIT_CENTRE : "operates"
    LEGAL_ENTITY ||--|{ FINANCIAL_PERIOD : "reports in"
    LEGAL_ENTITY ||--o{ ACCOUNT : "maintains"
    FINANCIAL_TRANSACTION }o--|| ACCOUNT : "posts to"
    FINANCIAL_TRANSACTION }o--|| FINANCIAL_PERIOD : "falls in"
    FINANCIAL_TRANSACTION }o--o| COST_CENTRE : "may be charged to"
    FINANCIAL_TRANSACTION }o--o| PROFIT_CENTRE : "may be credited to"
    INVOICE ||--o{ FINANCIAL_TRANSACTION : "gives rise to"
    COUNTERPARTY ||--o{ INVOICE : "is billed or bills"
    BUDGET }o--|| ACCOUNT : "is set against"
    BUDGET }o--|| FINANCIAL_PERIOD : "applies to"
    BUDGET }o--o| COST_CENTRE : "may be allocated to"
    PAYMENT }o--o| INVOICE : "may settle"
    PROCESSING_RECORD }o--o{ CONSENT : "relies on"

    LEGAL_ENTITY { string name }
    COST_CENTRE { string name }
    PROFIT_CENTRE { string name }
    ACCOUNT { string name }
    FINANCIAL_PERIOD { string label }
    FINANCIAL_TRANSACTION { string amount }
    INVOICE { string reference }
    BUDGET { string amount }
    PROCESSING_RECORD { string purpose }
    COUNTERPARTY { string name }
    PAYMENT { string method }
    CONSENT { string purpose }
```

**Budget and Financial Transaction are different kinds of thing** — an
intention and a fact. They live in different systems, are versioned
differently, and the upstream model treats budget as just another finance
table, which loses the version dimension: an approved budget and a what-if
scenario arrive indistinguishable.

## The spine

Stripped to the relationships that carry the business, the whole model is this:

```mermaid
erDiagram
    SEASON ||--o{ FIXTURE : schedules
    VENUE ||--o{ FIXTURE : hosts
    FRANCHISE }o--o{ FIXTURE : contests
    FIXTURE ||--o{ ACCESS_GRANT : "is sold as"
    FAN ||--o{ ACCESS_GRANT : acquires
    ACCESS_GRANT ||--o{ ADMISSION : "is presented as"
    FIXTURE ||--o{ MEDIA_ASSET : generates
    MEDIA_ASSET }o--o{ RIGHTS_WINDOW : "is licensed by"
    FIXTURE ||--o{ ACTIVATION : "carries sponsor"
    ACCESS_GRANT }o--o{ SALES_ORDER : "is ordered through"
    SALES_ORDER ||--o{ PAYMENT : "is settled by"
    PAYMENT ||--o{ FINANCIAL_TRANSACTION : "posts as"

    SEASON { string name }
    FIXTURE { string name }
    VENUE { string name }
    FRANCHISE { string name }
    ACCESS_GRANT { string kind }
    FAN { string name }
    ADMISSION { string result }
    MEDIA_ASSET { string title }
    RIGHTS_WINDOW { string kind }
    ACTIVATION { string description }
    SALES_ORDER { string reference }
    PAYMENT { string method }
    FINANCIAL_TRANSACTION { string amount }
```

Every one of those twelve relationships crosses a source-system boundary in the
physical tier. That is the whole reason `common.entity_xref` exists, and the
reason the target model's 1,477 cross-domain foreign keys are a product of
integration rather than something any source system hands over.
