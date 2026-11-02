# `sap_sfsf` — SAP SuccessFactors

Tier **B**. 19 base tables, owning **7** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **Effective-dated throughout.** One employee has many `emp_job` rows and only one is current; an extract that does not pick the window in force multiplies the roster by the number of job changes.
- **Person and employment are separate.** A player who returns as a coach is one person with two employments.
- **Compensation is components, not salary** -- appearance fees, bonuses, image rights. The target `athlete.contract` has one value column.
- **Tier B**: abbreviated depth by design.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `athlete.athlete_profile` | `per_person`, `per_personal`, `per_address`, `per_email`, `per_phone` | `join` | high |
| `athlete.draft_selection` | `job_application`, `candidate`, `job_requisition` | `join` | low |
| `athlete.eligibility_status` | `emp_employment` | `derive` | low |
| `athlete.roster` | `emp_employment`, `emp_job`, `position` | `join` | medium |
| `athlete.suspension_record` | `emp_time_off`, `emp_employment` | `join` | low |
| `event.officiating_assignment` | `emp_employment`, `emp_job`, `position` | `join` | low |
| `venue.staff_plan` | `position`, `emp_job`, `fo_department` | `join` | high |

### Low-confidence mappings

No real system of record exists for these; this schema models only
part of the concept.

- **`athlete.draft_selection`** — Draft is modeled as recruiting in SuccessFactors; the pick order has no named source
- **`athlete.eligibility_status`** — Derived from employment status; no eligibility system named
- **`athlete.suspension_record`** — Suspensions appear as unpaid leave; the disciplinary origin is out of scope
- **`event.officiating_assignment`** — Officials are contractors in SuccessFactors; the assignment itself has no named source

## Files

| File | Contents |
|---|---|
| `ddl/00_schema.sql` | Schema creation and the schema `COMMENT` |
| `ddl/30_master.sql` | Master data |
| `ddl/40_transaction.sql` | Transactions, partitioned where volume warrants |
| `ddl/50_constraints.sql` | Foreign keys, declared last so one ordered pass loads |
| `ddl/60_indexes.sql` | Indexes serving named access paths |
| `ddl/70_audit.sql` | **GENERATED** -- watermark triggers, change log, role grants |
| `ddl/80_comments.sql` | Table descriptions, published by the data dictionary |

Numbered to load in order. `50_constraints.sql` runs after every table in
the schema exists, so a single forward pass works without deferred
constraints.

## Loading just this schema

```bash
bash tools/load.sh sap_sfsf
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
