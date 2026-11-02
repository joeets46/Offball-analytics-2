"""Scope boundary for the OLTP source model.

Only the 10 operational systems of record named in the upstream Databricks MVM
(``model.operational_systems_of_records``) are modeled. MVM tables that no
named system can plausibly source are out of scope.

This module is the single source of truth for that boundary. Everything else
imports it, so the docs, the derived CSVs, the generated DDL and the
completeness assertions can never disagree.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from io import StringIO
from pathlib import Path
from typing import Iterable, Sequence

ROOT = Path(__file__).resolve().parent.parent

#: The vendored upstream model. Committed under ``source/mvm/`` so the project
#: is self-contained: every derived artifact can be regenerated from the repo
#: alone, with no network access.
MODEL_PATH = ROOT / "source" / "mvm" / "model.json"

#: Where the model used to be fetched to. Still honoured as a fallback so an
#: existing working copy keeps working, but it is no longer the input of record.
CACHE_PATH = Path(__file__).resolve().parent / ".cache" / "mvm_model.json"


@dataclass(frozen=True)
class SourceSystem:
    """One of the ten named operational systems of record."""

    schema: str
    name: str
    tier: str
    #: Matched against each column's `references` and `description` text to
    #: measure how strongly a target table is associated with this system.
    pattern: re.Pattern[str]


#: The 10 systems of record, in the order the upstream model lists them.
SYSTEMS: tuple[SourceSystem, ...] = (
    SourceSystem("sap_s4", "SAP S/4HANA (FI/CO/MM/SD)", "A", re.compile(r"SAP S/4HANA", re.I)),
    SourceSystem("tm_axs", "Ticketmaster / AXS", "A", re.compile(r"Ticketmaster|AXS", re.I)),
    SourceSystem("sfdc_crm", "Salesforce CRM", "A", re.compile(r"Salesforce", re.I)),
    SourceSystem("sap_sfsf", "SAP SuccessFactors", "B", re.compile(r"SuccessFactors", re.I)),
    # Promoted to tier A: the ownership map assigns it 20 MVM tables
    # (content 12 + broadcast 8), more than archtics, shopify, adobe_aep or hudl.
    SourceSystem("dalet", "Dalet Galaxy", "A", re.compile(r"Dalet", re.I)),
    SourceSystem("adobe_aep", "Adobe Experience Platform", "A", re.compile(r"Adobe Experience", re.I)),
    SourceSystem("archtics", "Archtics", "A", re.compile(r"Archtics", re.I)),
    SourceSystem("shopify", "Shopify Plus", "A", re.compile(r"Shopify", re.I)),
    SourceSystem("workday_ap", "Workday Adaptive Planning", "B", re.compile(r"Workday", re.I)),
    SourceSystem("hudl", "SportsCode / Hudl", "A", re.compile(r"Hudl|SportsCode", re.I)),
)

#: MVM tables excluded because no named system of record can source them.
#: ``"*"`` excludes the whole domain. Keyed by MVM domain.
OUT_OF_SCOPE: dict[str, str | tuple[str, ...]] = {
    "gaming": "*",
    "compliance": (
        # athlete_integrity -- would need WADA ADAMS
        "doping_test", "doping_violation", "whereabouts_filing", "eligibility_certification",
        # audit_investigations -- would need a GRC / case management system
        "audit_engagement", "audit_finding", "arbitration_case", "investigation",
        # regulatory_obligations -- would need a policy / obligation register
        "regulatory_filing", "governing_body", "obligation", "policy",
        # data_privacy -- would need a DSAR portal; data_processing_record stays
        # in scope via the AEP consent and data-use-label tables.
        "privacy_request",
    ),
    "league": (
        # competitive_operations, except `season` which SAP/Archtics/TM do source
        "league_schedule", "standing", "playoff_bracket", "game_result",
        "official", "disciplinary_action", "official_assignment",
        # roster_transactions -- would need a league competition-management system
        "salary_cap", "draft", "draft_pick", "trade_transaction", "transaction_window",
    ),
    "security": (
        # emergency_management -- would need an emergency management system
        "emergency_response_plan", "emergency_activation", "plan_zone_designation",
    ),
    "venue": (
        # would need a CMMS / EHS system; maintenance_work_order stays (SAP PM/MM)
        "safety_inspection",
    ),
}

#: Human-readable reason per out-of-scope domain, for docs and out_of_scope.csv.
OUT_OF_SCOPE_REASON: dict[str, str] = {
    "gaming": "No sportsbook or DFS platform among the 10 named systems",
    "compliance": "No WADA ADAMS, GRC/policy register, or DSAR portal among the 10 named systems",
    "league": "No league competition-management system among the 10 named systems",
    "security": "No emergency-management system among the 10 named systems",
    "venue": "No CMMS/EHS system among the 10 named systems",
}

#: The class of system that would be needed to bring an excluded area in scope.
#: Keyed by ``domain`` or ``domain/subdomain`` where a domain splits several ways.
_MISSING_SYSTEM: dict[str, str] = {
    "gaming": "a sportsbook / wagering engine and a daily-fantasy contest platform",
    "compliance/athlete_integrity": "WADA ADAMS (anti-doping test and whereabouts management)",
    "compliance/audit_investigations": "a GRC or investigation case-management system",
    "compliance/regulatory_obligations": "a policy and regulatory-obligation register",
    "compliance/data_privacy": "a DSAR / privacy request portal",
    "league/competitive_operations":
        "a league competition-management system (scheduling, standings, officiating, discipline)",
    "league/roster_transactions":
        "a league transaction system (draft, trades, salary cap administration)",
    "security/emergency_management": "an emergency management / mass-notification system",
    "venue/venue_operations": "a CMMS or EHS system for inspection scheduling",
}


def missing_system_for(domain: str, subdomain: str) -> str:
    """What class of system an excluded table would need."""
    return (
        _MISSING_SYSTEM.get(f"{domain}/{subdomain}")
        or _MISSING_SYSTEM.get(domain)
        or "a system not named in the upstream model"
    )


def is_out_of_scope(domain: str, table: str) -> bool:
    """True if ``domain.table`` is excluded from the source model."""
    rule = OUT_OF_SCOPE.get(domain)
    if rule == "*":
        return True
    return isinstance(rule, tuple) and table in rule


#: A pipe-delimited value domain, e.g. ``announced|confirmed|completed``.
_ENUM_PATTERN = re.compile(r"^[a-z0-9_]+(\|[a-z0-9_]+)+$", re.I)


@dataclass(frozen=True)
class ValueDomain:
    """Classification of a ``value_regex`` entry."""

    kind: str  # "enum" | "regex" | "none"
    value: str


def classify_value_domain(value_regex: str | None) -> ValueDomain:
    """Classify a ``value_regex`` entry.

    The upstream model overloads this one field for two different things:
    enumerated value domains and true regex patterns.
    """
    if not value_regex:
        return ValueDomain("none", "")
    if _ENUM_PATTERN.match(value_regex):
        return ValueDomain("enum", value_regex)
    return ValueDomain("regex", value_regex)


def is_enum_ref_candidate(description: str | None) -> bool:
    """The upstream generator flags columns whose enum values it stripped."""
    return "ENUM-REF-CANDIDATE" in (description or "")


#: Data classification levels, per
#: ``model.model_conventions.data_classification_levels``, ordered least to
#: most sensitive. Used to pick the strictest level on a table.
CLASSIFICATION_ORDER: tuple[str, ...] = ("public", "internal", "confidential", "restricted")


@dataclass(frozen=True)
class TagInfo:
    """Parsed `tags` field."""

    tokens: tuple[str, ...]
    classification: str
    pii_kinds: tuple[str, ...]
    is_pii: bool
    is_pk: bool
    is_self_ref_fk: bool
    is_sensitive: bool


def classify_tags(tags: str | None) -> TagInfo:
    """Parse the structured ``tags`` field.

    The upstream model uses ``tags`` as a real vocabulary rather than free
    text: a classification level, zero or more ``pii_*`` subtypes, and
    structural markers. Reading it directly is both accurate and cheaper than
    pattern-matching the prose description -- prose matching also silently
    misses rows where the only signal is the tag.
    """
    tokens = tuple(
        t.strip().lower() for t in re.split(r"[,;|]", str(tags or "")) if t.strip()
    )
    pii_kinds = tuple(t for t in tokens if t == "pii" or t.startswith("pii_"))
    levels = [level for level in CLASSIFICATION_ORDER if level in tokens]
    classification = levels[-1] if levels else ""

    return TagInfo(
        tokens=tokens,
        classification=classification,
        pii_kinds=pii_kinds,
        is_pii=bool(pii_kinds),
        is_pk="primary_key" in tokens,
        is_self_ref_fk="self_ref_fk" in tokens,
        # Anything above `internal`, or any PII, needs restricted grants in
        # the OLTP tier.
        is_sensitive=bool(pii_kinds) or classification in ("confidential", "restricted"),
    )


def strictest_classification(levels: Iterable[str]) -> str:
    """Pick the strictest classification across a set of levels."""
    present = set(levels)
    found = [level for level in CLASSIFICATION_ORDER if level in present]
    return found[-1] if found else ""


def load_model(path: Path | None = None) -> dict:
    """Load the vendored upstream model.

    Reads ``source/mvm/model.json``, falling back to the old download cache so
    a working copy from before the model was vendored still resolves.
    """
    target = path or (MODEL_PATH if MODEL_PATH.is_file() else CACHE_PATH)
    if not target.is_file():
        raise SystemExit(
            f"upstream model not found at {target}. It is committed at "
            "source/mvm/model.json; see source/mvm/README.md to restore it."
        )
    with target.open(encoding="utf-8") as handle:
        return json.load(handle)["model"]


def to_csv(header: Sequence[str], rows: Iterable[Sequence[object]]) -> str:
    """Minimal RFC 4180 CSV writer.

    Hand-rolled rather than using :mod:`csv` so the output is byte-identical
    to the Node implementation this was ported from: ``csv`` writes CRLF line
    endings by default and quotes on a slightly different rule set.
    """
    out = StringIO()

    def esc(value: object) -> str:
        text = "" if value is None else str(value)
        if re.search(r'["\r\n,]', text):
            return '"' + text.replace('"', '""') + '"'
        return text

    for row in [list(header), *(list(r) for r in rows)]:
        out.write(",".join(esc(v) for v in row))
        out.write("\n")
    return out.getvalue()
