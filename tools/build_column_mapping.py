"""Scaffold the column-level mapping for the key target tables.

Table-level mapping covers all 153 in-scope tables and is fully generated.
Column level is deliberately selective: the approved scope was "table-level for
all, column-level for the key tables", because 6,981 in-scope columns of
hand-curated mapping would be a different project.

The 31 tables chosen are the ones carrying the money and the joins. This script
emits one row per column of each, pre-filled with everything derivable from the
upstream model -- type, nullability, value domain, PII tag, FK target, the
owning system and the transform -- plus a derived `source_column` guess and a
`mapping_status` saying how much to trust it.

The guess is explicitly labelled. Columns whose source name matches a known
convention are marked ``derived``; the rest are ``needs_review``, so a reader
can see at a glance which rows are evidence and which are a starting point.

Run with::

    uv run python -m tools.build_column_mapping
"""

from __future__ import annotations

from pathlib import Path

from .ownership import ownership_rows
from .scope import classify_tags, classify_value_domain, load_model, to_csv

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "mapping" / "column_level_key_tables.csv"

#: The tables that carry the money and the joins. Chosen, not computed.
KEY_TABLES: tuple[str, ...] = (
    # The anchor and what happened
    "event.fixture",
    "event.match_result",
    "event.scoring_event",
    # Competition structure
    "league.season",
    "league.franchise",
    "league.team",
    # Where it happens
    "venue.venue",
    "venue.seat",
    "venue.seating_section",
    "venue.capacity_config",
    # The money path, ticketing
    "ticketing.ticket_order",
    "ticketing.ticket_order_line",
    "ticketing.access_entitlement",
    "ticketing.gate_scan",
    "ticketing.ticket_payment",
    "ticketing.season_ticket_account",
    # Who buys
    "fan.fan_profile",
    "fan.account",
    "fan.loyalty_enrollment",
    "fan.engagement_event",
    # Who plays
    "athlete.athlete_profile",
    "athlete.contract",
    "athlete.performance_stat",
    "athlete.roster",
    # The ledger
    "finance.gl_account",
    "finance.journal_entry",
    "finance.ar_invoice",
    "finance.payment",
    # Retail and commercial
    "merchandise.merch_order",
    "merchandise.order_line",
    "sponsorship.deal",
)

#: Column-name suffixes whose source counterpart follows a reliable convention.
#: Anything matching gets `derived`; everything else gets `needs_review`.
_DERIVABLE_SUFFIXES = (
    "_id", "_code", "_status", "_timestamp", "_at", "_date", "_on",
    "_amount", "_count", "_name", "_flag",
)


def _source_column_guess(column: str) -> tuple[str, str]:
    """Return ``(source_column, mapping_status)``.

    Deliberately conservative. A guess that is labelled as a guess is useful;
    a guess presented as a mapping is worse than a blank.
    """
    if column.endswith("_id") and column not in ("source_system_id",):
        # Surrogate keys never come across directly -- they are minted during
        # identity resolution, which is the single most important thing the
        # column mapping has to say.
        return ("(resolved via common.entity_xref)", "identity_resolution")
    if column in ("created_timestamp", "created_at"):
        return ("created_at", "derived")
    if column in ("updated_timestamp", "updated_at"):
        return ("updated_at / system_modstamp / last_modified_on", "derived")
    if column == "source_system_code":
        return ("(set by the pipeline from common.source_system)", "pipeline_assigned")
    if column.endswith(_DERIVABLE_SUFFIXES):
        return (column, "derived")
    return (column, "needs_review")


def main(argv: list[str] | None = None) -> int:
    model = load_model()
    owner = {f"{r.domain}.{r.table}": r for r in ownership_rows()}

    # Index the upstream columns for the chosen tables.
    wanted = set(KEY_TABLES)
    rows: list[list[object]] = []
    seen: set[str] = set()

    for domain in model["domains"]:
        for product in domain["products"]:
            key = f"{domain['name']}.{product['table_name']}"
            if key not in wanted:
                continue
            seen.add(key)
            own = owner.get(key)
            if own is None:
                raise SystemExit(f"{key} is in KEY_TABLES but not in the ownership map")

            for attr in product.get("attributes") or []:
                column = attr.get("column_name") or attr.get("name")
                tag = classify_tags(attr.get("tags"))
                vd = classify_value_domain(attr.get("value_regex"))
                source_column, status = _source_column_guess(column)

                rows.append([
                    domain["name"],
                    product["table_name"],
                    column,
                    attr.get("type"),
                    "yes" if tag.is_pk else "",
                    attr.get("foreign_key_to") or "",
                    vd.kind if vd.kind != "none" else "",
                    vd.value,
                    tag.classification,
                    " ".join(tag.pii_kinds),
                    own.system,
                    " ".join(own.qualified_src),
                    source_column,
                    own.transform,
                    status,
                    own.confidence,
                    (attr.get("references") or "")[:200],
                ])

    missing = wanted - seen
    if missing:
        raise SystemExit(f"KEY_TABLES names tables absent from the model: {sorted(missing)}")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(
        to_csv(
            ["mvm_domain", "mvm_table", "mvm_column", "mvm_type", "is_primary_key",
             "mvm_fk_to", "value_domain_kind", "value_domain", "classification",
             "pii_kinds", "source_system", "source_tables", "source_column",
             "transform_type", "mapping_status", "table_confidence",
             "upstream_references"],
            rows,
        ),
        encoding="utf-8",
        newline="",
    )

    # Report the composition, because the status breakdown is the honest summary.
    status_counts: dict[str, int] = {}
    for r in rows:
        status_counts[str(r[14])] = status_counts.get(str(r[14]), 0) + 1

    print(f"mapping/column_level_key_tables.csv  {len(rows)} rows "
          f"across {len(seen)} key tables")
    for status, count in sorted(status_counts.items(), key=lambda kv: -kv[1]):
        print(f"  {status:<22} {count:>5}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
