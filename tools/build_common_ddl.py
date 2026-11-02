"""Generate ``sql/01_common.sql`` -- the shared ``common`` schema.

It holds three things every system schema depends on:

1. Validated scalar ``DOMAIN`` types, generated from the regex patterns the
   upstream model declares in ``value_regex``. Only patterns reused by 2+
   columns become DOMAIN types; single-use patterns stay as inline ``CHECK``
   constraints on their own column.
2. The source-system registry, which ``source_system_code`` in the target
   model resolves against.
3. The cross-system identity resolution tables. These are the mechanism that
   replaces the 1,397 in-scope cross-domain foreign keys: in a per-system OLTP
   tier those references cross a database boundary and cannot be enforced, so
   they become a business key plus a resolution row.

A note on realism: a real Archtics install does not share a type library with
a real SAP install. ``common`` is a convenience of this reference
implementation so that 329 columns' worth of constraints are declared once
instead of ten times. It is not a claim that the real systems share anything.

Run with::

    uv run offball-common
"""

from __future__ import annotations

import csv
import re
from pathlib import Path

from .scope import SYSTEMS

DERIVED = Path(__file__).resolve().parent / "derived"
OUT_PATH = Path(__file__).resolve().parent.parent / "sql" / "01_common.sql"

#: Patterns the upstream model validates on only one column, but which are
#: structurally shared once the model is normalized into ten source schemas.
#: A timezone, for example, is validated once upstream (event.fixture) yet
#: every venue record in this tier needs it.
CURATED = {"dom_iana_timezone"}

CATEGORY = {
    "sap_s4": "erp", "tm_axs": "ticketing", "sfdc_crm": "crm", "sap_sfsf": "hcm",
    "dalet": "mam", "adobe_aep": "cdp", "archtics": "ticketing",
    "shopify": "ecommerce", "workday_ap": "fpa", "hudl": "sports_analytics",
}
EXTRACT = {
    "sap_s4": "cdc_log", "tm_axs": "cdc_log", "sfdc_crm": "api_incremental",
    "sap_sfsf": "api_incremental", "dalet": "cdc_log", "adobe_aep": "event_stream",
    "archtics": "cdc_log", "shopify": "webhook_plus_api",
    "workday_ap": "api_snapshot", "hudl": "api_incremental",
}
CODE = {
    "sap_s4": "SAP_S4", "tm_axs": "TICKETMASTER", "sfdc_crm": "SALESFORCE",
    "sap_sfsf": "SUCCESSFACTORS", "dalet": "DALET", "adobe_aep": "ADOBE_AEP",
    "archtics": "ARCHTICS", "shopify": "SHOPIFY", "workday_ap": "WORKDAY_AP",
    "hudl": "HUDL",
}

#: The business entities that exist in more than one source system and so need
#: identity resolution before load.
CANONICAL: list[tuple[str, str, str, str, str]] = [
    ("fan", "fan", "fan_profile", "fan_profile_id",
     "The same person exists as a Salesforce Contact, a TM/AXS customer_account, "
     "a Shopify customer and an AEP profile"),
    ("venue", "venue", "venue", "venue_id",
     "Archtics building, TM/AXS venue_ref and SAP t001w plant all describe the same building"),
    ("fixture", "event", "fixture", "fixture_id",
     "TM/AXS event, Archtics event_manifest and Hudl game are the same fixture"),
    ("athlete", "athlete", "athlete_profile", "athlete_profile_id",
     "SuccessFactors per_person and Hudl player are the same athlete"),
    ("franchise", "league", "franchise", "franchise_id",
     "SAP company code, SAP profit centre, Salesforce Account and Hudl team are the same club"),
    ("sponsor", "sponsorship", "sponsor", "sponsor_id",
     "Salesforce Account and SAP customer (kna1) are the same commercial counterparty"),
    ("supplier", "merchandise", "supplier", "supplier_id",
     "SAP vendor (lfa1) and Shopify vendor string are the same supplier"),
    ("product", "merchandise", "sku_catalog", "sku_catalog_id",
     "SAP material (mara) and Shopify product_variant are the same sellable item"),
    ("seat", "venue", "seat", "seat_id",
     "Archtics seat and the TM/AXS ticket seat coordinates are the same physical seat"),
    ("media_asset", "broadcast", "media_asset", "media_asset_id",
     "Dalet media_object and the content.asset record are the same asset"),
    ("channel", "broadcast", "channel", "channel_id",
     "Dalet channel and publication_target overlap for owned OTT destinations"),
    ("season", "league", "season", "season_id",
     "SAP fiscal year variant, TM/AXS season and Archtics plan period describe the same season"),
]


def length_cap(pattern: str) -> int | None:
    """Infer a length cap from a regex so a DOMAIN can sit on VARCHAR, not TEXT.

    Only safe for patterns that are anchored and bounded.
    """
    if not pattern.startswith("^") or not pattern.endswith("$"):
        return None
    # A single bounded quantifier covering the whole pattern body.
    one = re.match(r"^\^[^{}]*\{(\d+)(?:,(\d+))?\}\$$", pattern)
    if one:
        return int(one.group(2) or one.group(1))
    # Sum of bounded quantifiers plus literal characters, when nothing is
    # unbounded.
    if re.search(r"[*+]", pattern):
        return None
    total = 0
    body = pattern[1:-1]
    for token in re.findall(r"\[[^\]]+\](?:\{\d+(?:,\d+)?\})?|\\.|.", body):
        q = re.search(r"\{(\d+)(?:,(\d+))?\}$", token)
        total += int(q.group(2) or q.group(1)) if q else 1
    return total if 0 < total <= 512 else None


def main() -> int:
    with (DERIVED / "regex_domains.csv").open(encoding="utf-8", newline="") as handle:
        regex_domains = list(csv.DictReader(handle))

    reused = [
        r for r in regex_domains
        if int(r["used_by_columns"]) >= 2 or r["domain_type"] in CURATED
    ]
    covered = sum(int(r["used_by_columns"]) for r in reused)

    lines: list[str] = []
    p = lines.append

    p("-- =========================================================================")
    p("-- common -- shared scalar domains, source-system registry, identity resolution")
    p("--")
    p("-- Generated by tools/build_common_ddl.py. Do not edit by hand.")
    p("--")
    p("-- The DOMAIN types below are derived from the `value_regex` metadata the")
    p("-- upstream Databricks MVM declares on its own columns, so the constraints in")
    p("-- this source model are the ones the target model says it expects.")
    p("-- =========================================================================")
    p("")
    p("CREATE SCHEMA IF NOT EXISTS common;")
    p("")
    p("COMMENT ON SCHEMA common IS")
    p("    'Shared scalar domains, the source-system registry and the cross-system '")
    p("    'identity resolution tables. A convenience of this reference '")
    p("    'implementation: the real systems of record share no type library.';")
    p("")
    p("-- citext gives case-insensitive natural keys (emails, external codes) without")
    p("-- scattering lower() through every unique index.")
    p("CREATE EXTENSION IF NOT EXISTS citext;")
    p("")

    # ------------------------------------------------------------------
    # Scalar domains.
    # ------------------------------------------------------------------
    p("-- -------------------------------------------------------------------------")
    p(f"-- Validated scalar domains: {len(reused)} types covering")
    p(f"-- {covered} columns -- every pattern the upstream model reuses across 2+")
    p(f"-- columns, plus {len(CURATED)} curated type(s) that are shared in this tier even though")
    p("-- upstream validates them once. The remaining single-use patterns stay as")
    p("-- inline CHECK constraints on their own column.")
    p("-- -------------------------------------------------------------------------")
    p("")

    for r in sorted(reused, key=lambda r: r["domain_type"]):
        cap = length_cap(r["pattern"])
        base = f"VARCHAR({cap})" if cap else "TEXT"
        lit = r["pattern"].replace("'", "''")
        p(f"CREATE DOMAIN common.{r['domain_type']} AS {base}")
        p(f"    CHECK (VALUE ~ '{lit}');")
        p(f"COMMENT ON DOMAIN common.{r['domain_type']} IS")
        p(f"    'Pattern {lit.replace(chr(39), chr(39) * 2)} -- "
          f"{r['used_by_columns']} columns in {r['used_by_tables']} target tables.';")
        p("")

    # ------------------------------------------------------------------
    # Source-system registry.
    # ------------------------------------------------------------------
    p("-- -------------------------------------------------------------------------")
    p("-- Source-system registry.")
    p("--")
    p("-- The target model's `source_system_code` column is constrained to")
    p("-- 'TICKETMASTER|ARCHTICS|SAP_SD|MANUAL|LEAGUE_FEED' -- a five-value list that")
    p("-- does not cover the ten systems the same model names as its systems of")
    p("-- record. This table is the full registry; the narrower target enum is")
    p("-- recorded as a known gap in docs/04-physical-model-target.md.")
    p("-- -------------------------------------------------------------------------")
    p("")
    p("CREATE TABLE common.source_system (")
    p("    source_system_code  VARCHAR(20)  PRIMARY KEY,")
    p("    schema_name         VARCHAR(30)  NOT NULL UNIQUE,")
    p("    system_name         VARCHAR(120) NOT NULL,")
    p("    vendor_category     VARCHAR(40)  NOT NULL,")
    p("    model_tier          CHAR(1)      NOT NULL CHECK (model_tier IN ('A', 'B')),")
    p("    extract_pattern     VARCHAR(20)  NOT NULL,")
    p("    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,")
    p("    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),")
    p("    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()")
    p(");")
    p("")
    p("INSERT INTO common.source_system")
    p("    (source_system_code, schema_name, system_name, vendor_category, model_tier, extract_pattern)")
    p("VALUES")
    p(",\n".join(
        f"    ('{CODE[s.schema]}', '{s.schema}', '{s.name.replace(chr(39), chr(39) * 2)}', "
        f"'{CATEGORY[s.schema]}', '{s.tier}', '{EXTRACT[s.schema]}')"
        for s in SYSTEMS
    ) + ";")
    p("")

    # ------------------------------------------------------------------
    # Cross-system identity resolution.
    # ------------------------------------------------------------------
    p("-- -------------------------------------------------------------------------")
    p("-- Cross-system identity resolution.")
    p("--")
    p("-- The target model carries 1,477 cross-domain foreign keys, all typed BIGINT")
    p("-- against a uniform surrogate key. In this tier those references cross a")
    p("-- database boundary: a TM/AXS order cannot hold an enforced foreign key into")
    p("-- an SAP customer, and the two systems key customers differently (integer")
    p("-- identity vs. a 10-character CHAR business key).")
    p("--")
    p("-- So a cross-system reference is modeled as what it actually is: a business")
    p("-- key plus a resolution row. entity_xref maps each system-local key to the")
    p("-- canonical surrogate the lakehouse will use, and is the single place the")
    p("-- ingestion layer resolves keys.")
    p("-- -------------------------------------------------------------------------")
    p("")
    p("CREATE TABLE common.canonical_entity (")
    p("    entity_type      VARCHAR(40)  PRIMARY KEY,")
    p("    target_domain    VARCHAR(20)  NOT NULL,")
    p("    target_table     VARCHAR(60)  NOT NULL,")
    p("    target_key       VARCHAR(60)  NOT NULL,")
    p("    description      TEXT,")
    p("    UNIQUE (target_domain, target_table)")
    p(");")
    p("")
    p("COMMENT ON TABLE common.canonical_entity IS")
    p("    'The business entities that exist in more than one source system and so '")
    p("    'need identity resolution before load. One row per target master table.';")
    p("")
    p("CREATE TABLE common.entity_xref (")
    p("    entity_xref_id     BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,")
    p("    entity_type        VARCHAR(40)  NOT NULL REFERENCES common.canonical_entity(entity_type),")
    p("    source_system_code VARCHAR(20)  NOT NULL REFERENCES common.source_system(source_system_code),")
    p("    source_key         VARCHAR(120) NOT NULL,")
    p("    canonical_id       BIGINT       NOT NULL,")
    p("    match_method       VARCHAR(20)  NOT NULL")
    p("        CHECK (match_method IN ('deterministic', 'probabilistic', 'manual', 'survivorship')),")
    p("    match_confidence   NUMERIC(5,4)")
    p("        CHECK (match_confidence IS NULL OR match_confidence BETWEEN 0 AND 1),")
    p("    is_survivor        BOOLEAN      NOT NULL DEFAULT FALSE,")
    p("    valid_from         TIMESTAMPTZ  NOT NULL DEFAULT now(),")
    p("    valid_to           TIMESTAMPTZ,")
    p("    created_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),")
    p("    updated_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),")
    p("    -- One live mapping per (entity, system, source key).")
    p("    UNIQUE (entity_type, source_system_code, source_key, valid_from)")
    p(");")
    p("")
    p("CREATE INDEX ix_entity_xref_canonical")
    p("    ON common.entity_xref (entity_type, canonical_id);")
    p("CREATE INDEX ix_entity_xref_lookup")
    p("    ON common.entity_xref (entity_type, source_system_code, source_key)")
    p("    WHERE valid_to IS NULL;")
    p("")
    p("COMMENT ON COLUMN common.entity_xref.is_survivor IS")
    p("    'Marks the record that wins survivorship for this canonical_id, i.e. the '")
    p("    'system whose attribute values are kept when two sources disagree.';")
    p("")
    p("INSERT INTO common.canonical_entity (entity_type, target_domain, target_table, target_key, description)")
    p("VALUES")
    p(",\n".join(
        f"    ('{t}', '{d}', '{tbl}', '{k}', '{desc.replace(chr(39), chr(39) * 2)}')"
        for t, d, tbl, k, desc in CANONICAL
    ) + ";")
    p("")

    # ------------------------------------------------------------------
    # Shared audit helper.
    # ------------------------------------------------------------------
    p("-- -------------------------------------------------------------------------")
    p("-- Shared audit trigger. Every table in every system schema carries")
    p("-- created_at / updated_at; this keeps updated_at honest without ten copies.")
    p("-- -------------------------------------------------------------------------")
    p("")
    p("CREATE OR REPLACE FUNCTION common.touch_updated_at()")
    p("RETURNS trigger")
    p("LANGUAGE plpgsql")
    p("AS $$")
    p("BEGIN")
    p("    NEW.updated_at := now();")
    p("    RETURN NEW;")
    p("END;")
    p("$$;")
    p("")
    p("COMMENT ON FUNCTION common.touch_updated_at() IS")
    p("    'BEFORE UPDATE trigger function. Each system schema attaches it in 70_audit.sql.';")
    p("")

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="")

    print("sql/01_common.sql written")
    print(f"  domain types : {len(reused)}")
    print(f"  columns covered: {covered}")
    print(f"  canonical entities: {len(CANONICAL)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
