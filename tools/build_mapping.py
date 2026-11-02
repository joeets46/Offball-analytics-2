"""Generate the source-to-target mapping CSVs.

Built from the curated ownership map and the upstream model, so the mapping
cannot claim a table or a grain the model does not have.

Run with::

    uv run offball-mapping

Outputs:

``mapping/table_level_mapping.csv``
    The 153 in-scope MVM tables.
``mapping/out_of_scope.csv``
    The 47 excluded MVM tables, with the reason and what would be needed.
"""

from __future__ import annotations

from pathlib import Path

from .ownership import OWNERSHIP
from .scope import (
    SYSTEMS,
    OUT_OF_SCOPE_REASON,
    is_out_of_scope,
    load_model,
    missing_system_for,
    to_csv,
)

MAPPING_DIR = Path(__file__).resolve().parent.parent / "mapping"

#: How the grain changes between the source tables and the MVM table.
#: Derived from the transform type rather than restated per row.
GRAIN_NOTE: dict[str, str] = {
    "1:1": "same grain as source",
    "join": "source header/line or master/detail flattened to one row per MVM key",
    "union": "rows unioned from multiple sources, deduplicated on a business key",
    "pivot": "source key-value rows pivoted into columns",
    "derive": "no direct source row; computed from source attributes",
    "scd2": "source current-state versioned into effective-dated history",
}


def _write(name: str, content: str) -> None:
    MAPPING_DIR.mkdir(parents=True, exist_ok=True)
    (MAPPING_DIR / name).write_text(content, encoding="utf-8", newline="")


def main() -> int:
    model = load_model()
    system_name = {s.schema: s.name for s in SYSTEMS}

    # Index the upstream model so the mapping can carry real table metadata.
    meta: dict[str, dict] = {}
    for d in model["domains"]:
        for p in d["products"]:
            meta[f"{d['name']}.{p['table_name']}"] = {
                "subdomain": p.get("subdomain"),
                "type": str(p.get("type") or "").lower(),
                "pk": p.get("primary_key"),
                "attrs": len(p.get("attributes") or []),
            }

    # ------------------------------------------------------------------
    # In-scope mapping.
    # ------------------------------------------------------------------
    in_scope_rows: list[list[object]] = []
    for domain, entries in OWNERSHIP.items():
        for entry in entries:
            table, system, src, transform, confidence = entry[:5]
            note = entry[5] if len(entry) > 5 else ""
            m = meta.get(f"{domain}.{table}")
            if m is None:
                raise SystemExit(
                    f"ownership names a table absent from the model: {domain}.{table}"
                )
            in_scope_rows.append(
                [
                    domain, m["subdomain"], table, m["type"], m["pk"], m["attrs"],
                    system, system_name[system],
                    " ".join(f"{system}.{t}" for t in src),
                    transform, GRAIN_NOTE[transform], confidence, note,
                ]
            )

    in_scope_rows.sort(key=lambda r: (str(r[0]), str(r[2])))

    _write(
        "table_level_mapping.csv",
        to_csv(
            ["mvm_domain", "mvm_subdomain", "mvm_table", "mvm_type",
             "mvm_primary_key", "mvm_attribute_count", "source_system",
             "source_system_name", "source_tables", "transform_type",
             "grain_change", "confidence", "notes"],
            in_scope_rows,
        ),
    )

    # ------------------------------------------------------------------
    # Out-of-scope register. Every excluded table is listed with its reason,
    # so the two files together account for all 200 upstream tables.
    # ------------------------------------------------------------------
    out_rows: list[list[object]] = []
    for d in model["domains"]:
        for p in d["products"]:
            if not is_out_of_scope(d["name"], p["table_name"]):
                continue
            m = meta[f"{d['name']}.{p['table_name']}"]
            out_rows.append(
                [
                    d["name"], m["subdomain"], p["table_name"], m["type"], m["attrs"],
                    OUT_OF_SCOPE_REASON.get(d["name"], "no named system of record"),
                    missing_system_for(d["name"], m["subdomain"]),
                ]
            )

    _write(
        "out_of_scope.csv",
        to_csv(
            ["mvm_domain", "mvm_subdomain", "mvm_table", "mvm_type",
             "mvm_attribute_count", "reason", "would_require"],
            out_rows,
        ),
    )

    print(f"mapping/table_level_mapping.csv  {len(in_scope_rows)} rows")
    print(f"mapping/out_of_scope.csv         {len(out_rows)} rows")
    print(f"total accounted for              {len(in_scope_rows) + len(out_rows)} / 200")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
