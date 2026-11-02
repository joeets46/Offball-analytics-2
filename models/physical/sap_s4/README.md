# `sap_s4` — SAP S/4HANA (FI/CO/MM/SD)

Tier **A**. 39 base tables, owning **33** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../../docs/05-source-systems.md](../../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **Real SAP table names.** `bkpf` and `bseg`, not `journal_header` and `journal_line`. Anyone building the extract will be reading SAP documentation, so the names have to match.
- **`MANDT` leads every primary key.** A production system also holds test and training clients in the same tables, so an extract that does not filter on `MANDT` returns duplicate business rows.
- **Amounts are unsigned**, with the debit/credit direction in a separate character (`shkzg`). A generated `signed_amount` column exists so no extract has to remember the rule.
- **Four relationships cannot be declared as foreign keys** -- time-dependent master data and index-table keys make them structurally impossible. `50_constraints.sql` explains each one.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `athlete.contract` | `veda`, `vbak` | `join` | high |
| `athlete.free_agency_status` | `veda` | `derive` | medium |
| `athlete.nil_agreement` | `veda`, `lfa1` | `join` | high |
| `content.license` | `veda` | `1:1` | medium |
| `finance.ap_invoice` | `rbkp`, `rseg`, `bsik` | `join` | high |
| `finance.ar_invoice` | `vbrk`, `vbrp`, `bsid` | `join` | high |
| `finance.company_code` | `t001` | `1:1` | high |
| `finance.cost_center` | `csks` | `1:1` | high |
| `finance.fiscal_period` | `t009`, `t009b` | `join` | high |
| `finance.fixed_asset` | `anla`, `anlc` | `join` | high |
| `finance.gl_account` | `ska1`, `skb1` | `join` | high |
| `finance.journal_entry` | `bkpf`, `bseg`, `faglflexa` | `join` | high |
| `finance.ledger` | `t881` | `1:1` | high |
| `finance.payment` | `reguh`, `regup`, `bkpf` | `join` | high |
| `finance.payment_run` | `reguh` | `1:1` | high |
| `finance.profit_center` | `cepc` | `1:1` | high |
| `finance.revenue_recognition_schedule` | `veda`, `vbrk`, `bkpf` | `join` | medium |
| `league.conference` | `cepc` | `1:1` | low |
| `league.division` | `cepc` | `1:1` | low |
| `league.franchise` | `t001`, `cepc` | `join` | medium |
| `league.league` | `t001` | `1:1` | low |
| `league.season` | `t009`, `t009b` | `join` | medium |
| `league.team` | `cepc` | `1:1` | low |
| `merchandise.inventory_position` | `mard`, `marc`, `t001l` | `join` | high |
| `merchandise.licensing_agreement` | `veda`, `lfa1` | `join` | high |
| `merchandise.price_list` | `a004`, `konp` | `join` | high |
| `merchandise.royalty_payment` | `rbkp`, `rseg`, `reguh` | `join` | high |
| `merchandise.supplier` | `lfa1`, `lfb1` | `join` | high |
| `merchandise.supplier_category_authorization` | `lfa1`, `mara` | `derive` | low |
| `sponsorship.payment_schedule` | `veda`, `bsid`, `vbrk` | `join` | high |
| `venue.concession_stand` | `t001w`, `mara` | `join` | medium |
| `venue.facility` | `t001w`, `anla` | `join` | medium |
| `venue.maintenance_work_order` | `aufk`, `afih`, `qmel` | `join` | high |

### Low-confidence mappings

No real system of record exists for these; this schema models only
part of the concept.

- **`league.conference`** — Modeled as a profit-centre grouping; genuinely a competition structure
- **`league.division`** — Modeled as a profit-centre grouping; genuinely a competition structure
- **`league.league`** — No league system named; the league appears as an SAP company code with a Salesforce Account
- **`league.team`** — No affinity signal; Hudl team is the operational record but carries no commercial attributes
- **`merchandise.supplier_category_authorization`** — Minimal signal; derived from vendor material groups

## Files

| File | Contents |
|---|---|
| `ddl/00_schema.sql` | Schema creation and the schema `COMMENT` |
| `ddl/20_reference.sql` | Configuration and reference data |
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
bash tools/load.sh sap_s4
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
