"""Generate a README for each OLTP schema directory.

Ten near-identical documents is exactly the kind of thing that drifts when
written by hand. The content that varies -- which target tables a schema owns,
how many source tables it has, what its distinctive idiom is -- is either
already in the ownership map or is one curated sentence per schema.

Run with::

    uv run offball-schema-readme
"""

from __future__ import annotations

from pathlib import Path

from . import ddl_introspect
from .ownership import ownership_rows
from .scope import SYSTEMS

ROOT = Path(__file__).resolve().parent.parent

#: The one thing worth knowing about each schema, and why it is modeled that way.
IDIOM: dict[str, list[str]] = {
    "sap_s4": [
        "**Real SAP table names.** `bkpf` and `bseg`, not `journal_header` and "
        "`journal_line`. Anyone building the extract will be reading SAP "
        "documentation, so the names have to match.",
        "**`MANDT` leads every primary key.** A production system also holds "
        "test and training clients in the same tables, so an extract that does "
        "not filter on `MANDT` returns duplicate business rows.",
        "**Amounts are unsigned**, with the debit/credit direction in a "
        "separate character (`shkzg`). A generated `signed_amount` column "
        "exists so no extract has to remember the rule.",
        "**Four relationships cannot be declared as foreign keys** -- time-"
        "dependent master data and index-table keys make them structurally "
        "impossible. `50_constraints.sql` explains each one.",
    ],
    "tm_axs": [
        "**The scan stream is the highest-volume table in the estate.** One "
        "row per barcode or credential presentation, including every "
        "rejection, partitioned monthly.",
        "**Offline-captured scans arrive late.** Gate readers buffer when the "
        "network drops, so the extraction watermark is `uploaded_at`, not "
        "`scanned_at`.",
        "**`venue_ref` is deliberately a separate record** from "
        "`archtics.building` and `sap_s4.t001w`. All three describe the same "
        "building and none shares a key.",
        "**PII satellites** split identifying attributes from "
        "`customer_account` and `credential`, with separate grants.",
    ],
    "sfdc_crm": [
        "**`CHAR(18)` record IDs** -- 15 case-sensitive characters plus a "
        "3-character checksum. Both forms circulate, and mixing them is a "
        "standing integration bug.",
        "**Replication is on `SystemModstamp`, not `LastModifiedDate`.** The "
        "former moves on platform-driven changes the latter misses, so an "
        "extract keyed on the wrong column silently loses rows.",
        "**`IsDeleted` is the Recycle Bin**, not a deletion. Records stay "
        "queryable for 15 days.",
        "**`RecordTypeId` is load-bearing.** Six target tables are "
        "`account` filtered by record type; the seed rows in `record_type` "
        "are not illustrative, the mapping depends on them.",
    ],
    "archtics": [
        "**A five-level seating hierarchy**: building, level, section, row, "
        "seat. The target model flattens it to three.",
        "**Manifests are reusable.** One configuration serves many events; "
        "`event_manifest` applies it to one. The target "
        "`venue.capacity_config` collapses both, losing the reuse.",
        "**Personal seat licences** are a property right in a seat, separable "
        "from any season ticket. No target table corresponds.",
        "**Capacity is a stated figure, not a count** -- it is signed off by "
        "the fire authority, which is why an approved manifest must carry a "
        "valid certificate.",
    ],
    "shopify": [
        "**IDs are platform-assigned, not `IDENTITY`.** It is SaaS: the "
        "replica receives ids it did not mint. A target column declaring "
        "`GENERATED ALWAYS AS IDENTITY` would reject the data.",
        "**Discount values are negative** by convention. A sign inversion on "
        "load turns a discount into a surcharge.",
        "**Three independent order lifecycles** -- financial, fulfilment and "
        "cancellation -- which move separately. The target has one status "
        "column.",
        "**Metafields** are the extension mechanism, and where every retailer "
        "puts what the platform does not model.",
    ],
    "adobe_aep": [
        "**Identity is namespaced and plural.** A person has no single key; "
        "the target `fan.fan_profile` reduces all of it to one `BIGINT`.",
        "**Graph links are pairwise, probabilistic and revocable.** The "
        "target model has no concept of a disputed identity.",
        "**Experience events carry no foreign key to identity**, "
        "deliberately: events arrive before identities are registered, and a "
        "per-row check on the hottest write path is not viable.",
        "**Consent has three states** -- allow, deny, unknown -- because "
        "\"not asked\" is not \"declined\".",
    ],
    "hudl": [
        "**Client-generated UUIDs**, because an analyst codes a match offline "
        "and syncs later. A sequence cannot survive that.",
        "**The coded instance is the native unit.** Statistics are derived "
        "from instances, not entered.",
        "**`instance_label` has no target equivalent at all.** It is what a "
        "coded event means, and the target `scoring_event` has fixed columns.",
        "**One game has several timelines.** Different analysts disagree, so "
        "the extract must pick the primary one or double-count every goal.",
    ],
    "dalet": [
        "**`media_object` / `essence` split.** The object is editorial; an "
        "essence is one rendition. Six renditions are six rows here and one "
        "row in the target model.",
        "**Placeholders are normal.** An asset with no essence is created by "
        "the production order before anything is shot.",
        "**Metadata is data, not columns** -- fields, vocabularies and typed "
        "values, because a broadcaster extends its model monthly.",
        "**Rights windows carry territory arrays**, so the compliance "
        "question is a containment test and the columns are GIN-indexed.",
    ],
    "sap_sfsf": [
        "**Effective-dated throughout.** One employee has many `emp_job` "
        "rows and only one is current; an extract that does not pick the "
        "window in force multiplies the roster by the number of job changes.",
        "**Person and employment are separate.** A player who returns as a "
        "coach is one person with two employments.",
        "**Compensation is components, not salary** -- appearance fees, "
        "bonuses, image rights. The target `athlete.contract` has one value "
        "column.",
        "**Tier B**: abbreviated depth by design.",
    ],
    "workday_ap": [
        "**It is a cube, not a set of entities.** One fact table addressed by "
        "six dimensions; nothing corresponds to a business document.",
        "**Versions are first-class.** Actuals, budget, forecast and "
        "scenarios coexist for the same intersection, and the target "
        "`finance.budget` has one amount column.",
        "**Values are signed by convention per account.** Revenue is negative "
        "in many Adaptive models, and missing the flip inverts the P&L.",
        "**Tier B**: abbreviated depth by design.",
    ],
}

FILE_PURPOSE: dict[str, str] = {
    "00_schema.sql": "Schema creation and the schema `COMMENT`",
    "10_domains_and_enums.sql": "Local value domains restored as reference tables",
    "20_reference.sql": "Configuration and reference data",
    "30_master.sql": "Master data",
    "31_master_pii.sql": "One-to-one PII satellites, with separate grants",
    "40_transaction.sql": "Transactions, partitioned where volume warrants",
    "50_constraints.sql": "Foreign keys, declared last so one ordered pass loads",
    "60_indexes.sql": "Indexes serving named access paths",
    "70_audit.sql": "**GENERATED** -- watermark triggers, change log, role grants",
    "80_comments.sql": "Table descriptions, published by the data dictionary",
}


def main(argv: list[str] | None = None) -> int:
    rows = ownership_rows()
    ddl = ddl_introspect.read_all()

    for system in SYSTEMS:
        schema = system.schema
        owned = sorted(
            (r for r in rows if r.system == schema),
            key=lambda r: (r.domain, r.table),
        )
        info = ddl.get(schema)
        if info is None:
            print(f"  skip {schema}: no DDL directory")
            continue

        out: list[str] = []
        w = out.append

        w(f"# `{schema}` — {system.name}")
        w("")
        w(f"Tier **{system.tier}**. "
          f"{len(info.tables)} base tables"
          + (f" plus {len(info.partitions)} partitions" if info.partitions else "")
          + f", owning **{len(owned)}** of the 153 in-scope target tables.")
        w("")
        w("Named in the upstream model's `operational_systems_of_records`. See")
        w("[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how")
        w("ownership was assigned.")
        w("")

        w("## Native idiom modeled here")
        w("")
        for point in IDIOM.get(schema, []):
            w(f"- {point}")
        w("")

        w("## Target tables it owns")
        w("")
        w("| Target table | Source tables | Transform | Confidence |")
        w("|---|---|---|:--:|")
        for r in owned:
            src = ", ".join(f"`{t}`" for t in r.src)
            w(f"| `{r.domain}.{r.table}` | {src} | `{r.transform}` | {r.confidence} |")
        w("")

        low = [r for r in owned if r.confidence == "low"]
        if low:
            w("### Low-confidence mappings")
            w("")
            w("No real system of record exists for these; this schema models only")
            w("part of the concept.")
            w("")
            for r in low:
                w(f"- **`{r.domain}.{r.table}`** — {r.note}")
            w("")

        w("## Files")
        w("")
        w("| File | Contents |")
        w("|---|---|")
        for name in ddl_introspect.DDL_FILES:
            if name in info.files:
                w(f"| `ddl/{name}` | {FILE_PURPOSE[name]} |")
        w("")
        w("Numbered to load in order. `50_constraints.sql` runs after every table in")
        w("the schema exists, so a single forward pass works without deferred")
        w("constraints.")
        w("")

        w("## Loading just this schema")
        w("")
        w("```bash")
        w(f"bash tools/load.sh {schema}")
        w("```")
        w("")
        w("Cross-system references in this schema are business-key columns with no")
        w("`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key")
        w("here crosses a schema boundary, which `offball-check` enforces.")
        w("")

        target = ROOT / "oltp" / schema / "README.md"
        target.write_text("\n".join(out), encoding="utf-8")
        print(f"  {schema:<12} {len(owned):>2} target tables, "
              f"{len(info.tables):>2} source tables, {len(low)} low-confidence")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
