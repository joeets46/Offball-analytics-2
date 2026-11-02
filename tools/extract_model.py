"""Derive working CSVs from the upstream Databricks MVM ``model.json``.

The source OLTP model is derived from the published model rather than
invented: every MVM column carries a ``references`` field naming the system or
standard it came from, and 1,122 in-scope columns carry a declared value
domain. This script extracts all of that into flat files the DDL and the docs
are then written against.

Run with::

    uv run offball-extract

Outputs to ``tools/derived/``. No third-party dependencies.
"""

from __future__ import annotations

import json
from pathlib import Path

from .scope import (
    SYSTEMS,
    OUT_OF_SCOPE_REASON,
    classify_tags,
    classify_value_domain,
    is_enum_ref_candidate,
    is_out_of_scope,
    load_model,
    strictest_classification,
    to_csv,
)

OUT_DIR = Path(__file__).resolve().parent / "derived"


def _write(name: str, content: str) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    # newline="" so Python does not translate \n to \r\n on Windows; the CSVs
    # must be byte-identical regardless of platform.
    (OUT_DIR / name).write_text(content, encoding="utf-8", newline="")


def main() -> int:
    model = load_model()

    tables: list[dict] = []          # one row per MVM table
    columns: list[dict] = []         # one row per in-scope MVM column
    unresolved_fks: list[dict] = []  # in-scope FK -> out-of-scope target
    enum_usage: dict[str, list[dict]] = {}   # value domain -> usages
    regex_usage: dict[str, list[dict]] = {}  # regex pattern -> usages

    # ------------------------------------------------------------------
    # Walk the model once, collecting everything.
    # ------------------------------------------------------------------
    for domain in model["domains"]:
        for product in domain["products"]:
            attrs = product.get("attributes") or []
            out_of_scope = is_out_of_scope(domain["name"], product["table_name"])

            # Which named systems does this table's metadata cite, and how often?
            affinity: dict[str, int] = {}
            for attr in attrs:
                haystack = f"{attr.get('references') or ''} {attr.get('description') or ''}"
                for system in SYSTEMS:
                    if system.pattern.search(haystack):
                        affinity[system.schema] = affinity.get(system.schema, 0) + 1
            ranked = sorted(affinity.items(), key=lambda kv: -kv[1])

            tables.append(
                {
                    "domain": domain["name"],
                    "division": domain.get("division"),
                    "subdomain": product.get("subdomain"),
                    "table": product["table_name"],
                    # The upstream model is inconsistent about case
                    # ('Master' vs 'master').
                    "type": str(product.get("type") or "").lower(),
                    "pk": product.get("primary_key"),
                    "attr_count": len(attrs),
                    "in_scope": "no" if out_of_scope else "yes",
                    "scope_reason": OUT_OF_SCOPE_REASON.get(domain["name"], "")
                    if out_of_scope
                    else "",
                    "affinity_ranked": " ".join(f"{s}:{n}" for s, n in ranked),
                    "affinity_top": ranked[0][0] if ranked else "",
                }
            )

            if out_of_scope:
                continue

            for attr in attrs:
                vd = classify_value_domain(attr.get("value_regex"))
                key = {
                    "domain": domain["name"],
                    "table": product["table_name"],
                    "column": attr.get("column_name") or attr.get("name"),
                }

                if vd.kind == "enum":
                    enum_usage.setdefault(vd.value, []).append(key)
                elif vd.kind == "regex":
                    regex_usage.setdefault(vd.value, []).append(key)

                fk = attr.get("foreign_key_to") or ""
                fk_status = ""
                if fk:
                    target_domain, target_table = fk.split(".")[0], fk.split(".")[1]
                    if is_out_of_scope(target_domain, target_table):
                        fk_status = "unresolved"
                        unresolved_fks.append(
                            {
                                **key,
                                "fk_to": fk,
                                "target_domain": target_domain,
                                "target_table": target_table,
                                "reason": OUT_OF_SCOPE_REASON.get(
                                    target_domain, "target table out of scope"
                                ),
                            }
                        )
                    else:
                        fk_status = "resolved"

                tag = classify_tags(attr.get("tags"))

                columns.append(
                    {
                        **key,
                        "type": attr.get("type"),
                        "is_pk": "yes" if tag.is_pk else "",
                        "self_ref_fk": "yes" if tag.is_self_ref_fk else "",
                        "fk_to": fk,
                        "fk_status": fk_status,
                        "value_domain_kind": "" if vd.kind == "none" else vd.kind,
                        "value_domain": vd.value,
                        "enum_ref_candidate": "yes"
                        if is_enum_ref_candidate(attr.get("description"))
                        else "",
                        "classification": tag.classification,
                        "pii_kinds": " ".join(tag.pii_kinds),
                        "sensitive": "yes" if tag.is_sensitive else "",
                        "references": attr.get("references") or "",
                    }
                )

    # ------------------------------------------------------------------
    # Value domains -> reference table or CHECK constraint.
    #
    # Rule from the plan: promote to a reference table if the owning MVM table
    # is a Reference table, or if 2+ tables share the domain. Otherwise inline
    # CHECK.
    # ------------------------------------------------------------------
    table_type = {f"{t['domain']}.{t['table']}": t["type"] for t in tables}

    enum_rows = []
    for values, uses in enum_usage.items():
        distinct_tables = {f"{u['domain']}.{u['table']}" for u in uses}
        any_reference_table = any(table_type.get(k) == "reference" for k in distinct_tables)
        promote = len(distinct_tables) >= 2 or any_reference_table
        # Name the reference table after the most common column name using
        # this domain. Ties resolve to first-seen, matching JS object order.
        freq: dict[str, int] = {}
        for u in uses:
            freq[u["column"]] = freq.get(u["column"], 0) + 1
        col_name = max(freq.items(), key=lambda kv: kv[1])[0]
        enum_rows.append(
            {
                "suggested_name": col_name,
                "value_count": len(values.split("|")),
                "values": values,
                "used_by_columns": len(uses),
                "used_by_tables": len(distinct_tables),
                "disposition": "reference_table" if promote else "check_constraint",
                "usage": " ".join(sorted(distinct_tables)),
            }
        )
    enum_rows.sort(key=lambda r: (-r["used_by_tables"], -r["used_by_columns"]))

    # ------------------------------------------------------------------
    # Regex patterns -> Postgres DOMAIN types, defined once and reused.
    # ------------------------------------------------------------------
    regex_rows = []
    for pattern, uses in regex_usage.items():
        distinct_tables = {f"{u['domain']}.{u['table']}" for u in uses}
        regex_rows.append(
            {
                "domain_type": _domain_type_name(pattern, uses),
                "pattern": pattern,
                "used_by_columns": len(uses),
                "used_by_tables": len(distinct_tables),
                "usage": " ".join(sorted(distinct_tables)[:12]),
            }
        )
    regex_rows.sort(key=lambda r: -r["used_by_columns"])

    # Collapse DOMAIN name collisions (two patterns deriving the same name).
    seen: dict[str, int] = {}
    for r in regex_rows:
        n = seen.get(r["domain_type"], 0)
        seen[r["domain_type"]] = n + 1
        if n > 0:
            r["domain_type"] = f"{r['domain_type']}_{n + 1}"

    # ------------------------------------------------------------------
    # Emit.
    # ------------------------------------------------------------------
    _write(
        "mvm_tables.csv",
        to_csv(
            ["mvm_domain", "division", "mvm_subdomain", "mvm_table", "mvm_type",
             "primary_key", "attribute_count", "in_scope", "scope_reason",
             "system_affinity", "affinity_top"],
            [
                [t["domain"], t["division"], t["subdomain"], t["table"], t["type"],
                 t["pk"], t["attr_count"], t["in_scope"], t["scope_reason"],
                 t["affinity_ranked"], t["affinity_top"]]
                for t in tables
            ],
        ),
    )

    _write(
        "mvm_columns.csv",
        to_csv(
            ["mvm_domain", "mvm_table", "column_name", "data_type", "is_pk",
             "self_ref_fk", "fk_to", "fk_status", "value_domain_kind",
             "value_domain", "enum_ref_candidate", "classification", "pii_kinds",
             "sensitive", "references"],
            [
                [c["domain"], c["table"], c["column"], c["type"], c["is_pk"],
                 c["self_ref_fk"], c["fk_to"], c["fk_status"], c["value_domain_kind"],
                 c["value_domain"], c["enum_ref_candidate"], c["classification"],
                 c["pii_kinds"], c["sensitive"], c["references"]]
                for c in columns
            ],
        ),
    )

    _write(
        "value_domains.csv",
        to_csv(
            ["suggested_name", "value_count", "values", "used_by_columns",
             "used_by_tables", "disposition", "used_in"],
            [
                [e["suggested_name"], e["value_count"], e["values"],
                 e["used_by_columns"], e["used_by_tables"], e["disposition"], e["usage"]]
                for e in enum_rows
            ],
        ),
    )

    _write(
        "regex_domains.csv",
        to_csv(
            ["domain_type", "pattern", "used_by_columns", "used_by_tables", "used_in"],
            [
                [r["domain_type"], r["pattern"], r["used_by_columns"],
                 r["used_by_tables"], r["usage"]]
                for r in regex_rows
            ],
        ),
    )

    _write(
        "enum_ref_candidates.csv",
        to_csv(
            ["mvm_domain", "mvm_table", "column_name", "value_domain"],
            [
                [c["domain"], c["table"], c["column"], c["value_domain"]]
                for c in columns
                if c["enum_ref_candidate"]
            ],
        ),
    )

    # Drives the privacy design: which tables need a PII satellite with
    # separate grants, and which columns are encryption candidates.
    _write(
        "sensitive_columns.csv",
        to_csv(
            ["mvm_domain", "mvm_table", "column_name", "data_type",
             "classification", "pii_kinds", "references"],
            [
                [c["domain"], c["table"], c["column"], c["type"],
                 c["classification"], c["pii_kinds"], c["references"]]
                for c in columns
                if c["sensitive"]
            ],
        ),
    )

    # Per-table privacy posture: a table with any pii_* column gets a satellite.
    by_table: dict[str, dict] = {}
    for c in columns:
        k = f"{c['domain']}.{c['table']}"
        entry = by_table.setdefault(k, {"pii": [], "levels": [], "cols": 0})
        entry["cols"] += 1
        if c["pii_kinds"]:
            entry["pii"].append(c["column"])
        if c["classification"]:
            entry["levels"].append(c["classification"])

    posture_rows = sorted(
        (
            [k, e["cols"], len(e["pii"]), strictest_classification(e["levels"]),
             "yes" if e["pii"] else "", " ".join(e["pii"])]
            for k, e in by_table.items()
        ),
        key=lambda r: (-r[2], str(r[0])),
    )
    _write(
        "table_privacy_posture.csv",
        to_csv(
            ["mvm_table", "total_columns", "pii_columns", "strictest_classification",
             "needs_pii_satellite", "pii_column_names"],
            posture_rows,
        ),
    )

    _write(
        "unresolved_fks.csv",
        to_csv(
            ["mvm_domain", "mvm_table", "column_name", "fk_to", "target_domain",
             "target_table", "reason"],
            [
                [f["domain"], f["table"], f["column"], f["fk_to"],
                 f["target_domain"], f["target_table"], f["reason"]]
                for f in unresolved_fks
            ],
        ),
    )

    # ------------------------------------------------------------------
    # Summary, so the numbers in the docs are never hand-typed.
    # ------------------------------------------------------------------
    in_scope = [t for t in tables if t["in_scope"] == "yes"]
    promoted = [e for e in enum_rows if e["disposition"] == "reference_table"]

    pii_kind_counts: dict[str, int] = {}
    for c in columns:
        for kind in c["pii_kinds"].split():
            pii_kind_counts[kind] = pii_kind_counts.get(kind, 0) + 1

    summary = {
        "upstream": {
            "domains": len(model["domains"]),
            "tables": len(tables),
            "columns": sum(
                len(p.get("attributes") or [])
                for d in model["domains"]
                for p in d["products"]
            ),
        },
        "scope": {
            "in_scope_tables": len(in_scope),
            "out_of_scope_tables": len(tables) - len(in_scope),
            "in_scope_columns": len(columns),
        },
        "value_domains": {
            "enum_columns": sum(len(u) for u in enum_usage.values()),
            "distinct_enum_domains": len(enum_rows),
            "promoted_to_reference_table": len(promoted),
            "inline_check_constraint": len(enum_rows) - len(promoted),
            "regex_columns": sum(len(u) for u in regex_usage.values()),
            "distinct_postgres_domain_types": len(regex_rows),
        },
        "flags": {
            "enum_ref_candidates": sum(1 for c in columns if c["enum_ref_candidate"]),
            "self_referencing_fks": sum(1 for c in columns if c["self_ref_fk"]),
        },
        "classification": {
            "sensitive_columns": sum(1 for c in columns if c["sensitive"]),
            "restricted": sum(1 for c in columns if c["classification"] == "restricted"),
            "confidential": sum(1 for c in columns if c["classification"] == "confidential"),
            "internal": sum(1 for c in columns if c["classification"] == "internal"),
            "pii_columns": sum(1 for c in columns if c["pii_kinds"]),
            "pii_kinds": dict(sorted(pii_kind_counts.items(), key=lambda kv: -kv[1])),
            "tables_needing_pii_satellite": sum(1 for e in by_table.values() if e["pii"]),
        },
        "foreign_keys": {
            "resolved_in_scope": sum(1 for c in columns if c["fk_status"] == "resolved"),
            "unresolved_out_of_scope": len(unresolved_fks),
        },
    }

    _write("summary.json", json.dumps(summary, indent=2) + "\n")

    print(json.dumps(summary, indent=2))
    print("\nwrote 9 files to tools/derived/")
    return 0


def _domain_type_name(pattern: str, uses: list[dict]) -> str:
    """Derive a stable, readable DOMAIN type name from the columns using a pattern.

    Without the canonical list, a widely shared type ends up named after
    whichever column happened to use it most -- ``dom_primary_contact_email``
    for every email in the model, for instance.
    """
    freq: dict[str, int] = {}
    for u in uses:
        freq[u["column"]] = freq.get(u["column"], 0) + 1
    col = max(freq.items(), key=lambda kv: kv[1])[0]

    canonical: list[tuple[str, str]] = [
        (r"^\^\[A-Z\]\{3\}\$$", "iso3_code"),
        (r"^\^\[A-Z\]\{2\}\$$", "iso2_code"),
        (r"^\^\[A-Za-z\]\+/\[A-Za-z_\]\+\$$", "iana_timezone"),
        # Contains an @ but does not start with one: `^[...]+@[...]` is an
        # address, whereas `^@[A-Za-z0-9_]{1,50}$` is a social handle.
        (r"^(?!\^@).*@", "email"),
        (r"^\^@", "social_handle"),
        (r"^\^https\?", "url"),
    ]
    import re as _re

    for expr, name in canonical:
        if _re.search(expr, pattern):
            return f"dom_{name}"
    return f"dom_{col}"


if __name__ == "__main__":
    raise SystemExit(main())
