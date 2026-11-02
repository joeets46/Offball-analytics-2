"""Completeness assertions tying the mapping, the scope boundary and the DDL together.

This is the check most likely to catch hand-waving, which is why it exists as
a standalone command rather than only as a test. It asserts:

1. ``table_level_mapping.csv`` and ``out_of_scope.csv`` together account for
   exactly the 200 upstream MVM tables, with no duplicates and nothing
   invented.
2. Every in-scope row names a source system and at least one source table.
3. Every source table named in the mapping actually exists in the generated
   DDL. This is the one that keeps the mapping honest -- it is easy to write a
   plausible table name into a spreadsheet and never build it.
4. Every ``common.dom_*`` type referenced by a schema is actually created by
   ``models/physical/sql/01_common.sql``.
5. The ownership map covers the in-scope set exactly.

Run with::

    uv run offball-check

Exits non-zero on any failure, so it works in CI.
"""

from __future__ import annotations

import csv
from pathlib import Path

from . import ddl_introspect
from .ownership import ownership_rows
from .scope import SYSTEMS, is_out_of_scope, load_model

ROOT = Path(__file__).resolve().parent.parent
MAPPING_DIR = ROOT / "mapping"


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def main(argv: list[str] | None = None) -> int:
    failures: list[str] = []
    notes: list[str] = []

    def check(label: str, ok: bool, detail: str = "") -> None:
        if ok:
            notes.append(f"  PASS  {label}")
        else:
            failures.append(f"  FAIL  {label}" + (f"\n        {detail}" if detail else ""))

    model = load_model()

    # ------------------------------------------------------------------
    # 1. Coverage of all 200 upstream tables.
    # ------------------------------------------------------------------
    upstream: set[str] = set()
    upstream_in_scope: set[str] = set()
    for d in model["domains"]:
        for p in d["products"]:
            key = f"{d['name']}.{p['table_name']}"
            upstream.add(key)
            if not is_out_of_scope(d["name"], p["table_name"]):
                upstream_in_scope.add(key)

    in_scope_csv = _read_csv(MAPPING_DIR / "table_level_mapping.csv")
    out_csv = _read_csv(MAPPING_DIR / "out_of_scope.csv")

    mapped = [f"{r['mvm_domain']}.{r['mvm_table']}" for r in in_scope_csv]
    excluded = [f"{r['mvm_domain']}.{r['mvm_table']}" for r in out_csv]
    combined = mapped + excluded

    check(
        f"mapping + out_of_scope account for all {len(upstream)} upstream tables "
        f"(got {len(combined)})",
        set(combined) == upstream and len(combined) == len(upstream),
        f"missing: {sorted(upstream - set(combined))[:5]} "
        f"| invented: {sorted(set(combined) - upstream)[:5]}",
    )
    check(
        "no duplicate rows across the two mapping files",
        len(combined) == len(set(combined)),
        f"duplicates: {sorted({k for k in combined if combined.count(k) > 1})[:5]}",
    )
    check(
        f"in-scope row count matches the scope boundary ({len(upstream_in_scope)})",
        set(mapped) == upstream_in_scope,
        f"mismatch: {sorted(set(mapped) ^ upstream_in_scope)[:5]}",
    )

    # ------------------------------------------------------------------
    # 2. Every in-scope row is actually mapped.
    # ------------------------------------------------------------------
    blank_system = [r["mvm_table"] for r in in_scope_csv if not r["source_system"].strip()]
    check("every in-scope row names a source system", not blank_system,
          f"blank: {blank_system[:5]}")

    blank_src = [r["mvm_table"] for r in in_scope_csv if not r["source_tables"].strip()]
    check("every in-scope row names at least one source table", not blank_src,
          f"blank: {blank_src[:5]}")

    known_schemas = {s.schema for s in SYSTEMS}
    unknown_system = sorted(
        {r["source_system"] for r in in_scope_csv if r["source_system"] not in known_schemas}
    )
    check("every source_system is one of the ten named systems", not unknown_system,
          f"unknown: {unknown_system}")

    valid_confidence = {"high", "medium", "low"}
    bad_confidence = sorted(
        {r["confidence"] for r in in_scope_csv if r["confidence"] not in valid_confidence}
    )
    check("every confidence value is high/medium/low", not bad_confidence,
          f"unexpected: {bad_confidence}")

    # ------------------------------------------------------------------
    # 3. Every named source table exists in the DDL. The important one.
    # ------------------------------------------------------------------
    ddl = ddl_introspect.read_all()
    existing = {
        f"{schema}.{table}"
        for schema, info in ddl.items()
        for table in info.all_tables
    }

    referenced: set[str] = set()
    for row in in_scope_csv:
        referenced.update(row["source_tables"].split())

    phantom = sorted(referenced - existing)
    check(
        f"all {len(referenced)} source tables named in the mapping exist in models/physical/ DDL",
        not phantom,
        f"not found in DDL: {phantom}",
    )

    # Every schema in the mapping has a DDL directory.
    missing_schema = sorted({r["source_system"] for r in in_scope_csv} - set(ddl))
    check("every source system has a DDL directory", not missing_schema,
          f"missing: {missing_schema}")

    # ------------------------------------------------------------------
    # 4. Domain types referenced exist.
    # ------------------------------------------------------------------
    declared = ddl_introspect.declared_domains()
    used: set[str] = set()
    for info in ddl.values():
        used |= info.domains_used
    undeclared = sorted(used - declared)
    check(
        f"all {len(used)} common.dom_* types referenced by schemas are declared",
        not undeclared,
        f"referenced but never created: {undeclared}",
    )

    # ------------------------------------------------------------------
    # 5. Ownership map agrees with the scope boundary.
    # ------------------------------------------------------------------
    rows = ownership_rows()
    owned = {f"{r.domain}.{r.table}" for r in rows}
    check(
        f"ownership map covers the in-scope set exactly ({len(upstream_in_scope)})",
        owned == upstream_in_scope,
        f"missing: {sorted(upstream_in_scope - owned)[:5]} "
        f"| stray: {sorted(owned - upstream_in_scope)[:5]}",
    )
    check(
        "ownership map has no duplicate tables",
        len(owned) == len(rows),
        f"{len(rows)} rows but {len(owned)} distinct tables",
    )

    # ------------------------------------------------------------------
    # 6. Cross-schema foreign keys do not exist. The whole premise of the
    #    per-system design is that nothing enforces a reference across a
    #    database boundary, so a stray one would be a real modelling error.
    # ------------------------------------------------------------------
    cross_schema: list[str] = []
    for schema, info in ddl.items():
        for target in info.fk_targets:
            target_schema = target.split(".", 1)[0]
            if target_schema not in (schema, "common"):
                cross_schema.append(f"{schema} -> {target}")
    check(
        "no foreign key crosses a system schema boundary",
        not cross_schema,
        f"found: {sorted(cross_schema)[:5]}",
    )

    # ------------------------------------------------------------------
    # Report.
    # ------------------------------------------------------------------
    print("check_mapping")
    print()
    for line in notes:
        print(line)
    for line in failures:
        print(line)
    print()

    if failures:
        print(f"{len(failures)} check(s) FAILED, {len(notes)} passed")
        return 1

    print(f"all {len(notes)} checks passed")
    print()
    print(f"  upstream tables       {len(upstream)}")
    print(f"  in scope              {len(mapped)}")
    print(f"  out of scope          {len(excluded)}")
    print(f"  OLTP tables in DDL    {len(existing)}")
    print(f"  source tables mapped  {len(referenced)}")
    print(f"  shared domain types   {len(declared)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
