"""The mapping accounts for all 200 upstream MVM tables.

Pure Python: no database needed, so these run anywhere. They are the tests
that stop the mapping drifting away from either the upstream model or the DDL
that was actually built.
"""

from __future__ import annotations

import csv
from pathlib import Path

import pytest

from tools import ddl_introspect
from tools.ownership import ownership_rows
from tools.scope import SYSTEMS, is_out_of_scope, load_model

ROOT = Path(__file__).resolve().parent.parent
MAPPING_DIR = ROOT / "mapping"


def _read_csv(name: str) -> list[dict[str, str]]:
    path = MAPPING_DIR / name
    if not path.exists():
        pytest.skip(f"{name} not generated yet; run: uv run offball-mapping")
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


@pytest.fixture(scope="module")
def upstream() -> tuple[set[str], set[str]]:
    """``(all_tables, in_scope_tables)`` from the cached upstream model."""
    try:
        model = load_model()
    except FileNotFoundError:
        pytest.skip(
            "tools/.cache/mvm_model.json missing; see the curl command in README.md"
        )
    every: set[str] = set()
    in_scope: set[str] = set()
    for domain in model["domains"]:
        for product in domain["products"]:
            key = f"{domain['name']}.{product['table_name']}"
            every.add(key)
            if not is_out_of_scope(domain["name"], product["table_name"]):
                in_scope.add(key)
    return every, in_scope


@pytest.fixture(scope="module")
def in_scope_rows() -> list[dict[str, str]]:
    return _read_csv("table_level_mapping.csv")


@pytest.fixture(scope="module")
def out_of_scope_rows() -> list[dict[str, str]]:
    return _read_csv("out_of_scope.csv")


def test_upstream_model_has_200_tables(upstream):
    """The premise. If this changes, the upstream model was revised."""
    every, _ = upstream
    assert len(every) == 200, f"expected 200 upstream tables, found {len(every)}"


def test_mapping_and_exclusions_cover_every_upstream_table(
    upstream, in_scope_rows, out_of_scope_rows
):
    """All 200 tables are either mapped or explicitly excluded. Nothing is silent."""
    every, _ = upstream
    mapped = {f"{r['mvm_domain']}.{r['mvm_table']}" for r in in_scope_rows}
    excluded = {f"{r['mvm_domain']}.{r['mvm_table']}" for r in out_of_scope_rows}

    unaccounted = every - mapped - excluded
    invented = (mapped | excluded) - every

    assert not unaccounted, f"upstream tables neither mapped nor excluded: {sorted(unaccounted)}"
    assert not invented, f"mapping names tables absent from the model: {sorted(invented)}"


def test_no_table_is_both_mapped_and_excluded(in_scope_rows, out_of_scope_rows):
    mapped = {f"{r['mvm_domain']}.{r['mvm_table']}" for r in in_scope_rows}
    excluded = {f"{r['mvm_domain']}.{r['mvm_table']}" for r in out_of_scope_rows}
    both = mapped & excluded
    assert not both, f"tables listed as both in and out of scope: {sorted(both)}"


def test_row_counts_match_the_scope_boundary(upstream, in_scope_rows, out_of_scope_rows):
    _, in_scope = upstream
    assert len(in_scope_rows) == len(in_scope) == 153
    assert len(out_of_scope_rows) == 200 - len(in_scope) == 47


def test_no_duplicate_rows(in_scope_rows, out_of_scope_rows):
    for label, rows in (("in-scope", in_scope_rows), ("out-of-scope", out_of_scope_rows)):
        keys = [f"{r['mvm_domain']}.{r['mvm_table']}" for r in rows]
        dupes = sorted({k for k in keys if keys.count(k) > 1})
        assert not dupes, f"duplicate {label} rows: {dupes}"


def test_every_mapped_row_is_complete(in_scope_rows):
    """A mapped row names a system, a source table, a transform and a confidence."""
    known_systems = {s.schema for s in SYSTEMS}
    valid_transforms = {"1:1", "join", "union", "pivot", "derive", "scd2"}
    valid_confidence = {"high", "medium", "low"}

    for row in in_scope_rows:
        where = f"{row['mvm_domain']}.{row['mvm_table']}"
        assert row["source_system"] in known_systems, (
            f"{where}: unknown source system {row['source_system']!r}"
        )
        assert row["source_tables"].strip(), f"{where}: no source tables named"
        assert row["transform_type"] in valid_transforms, (
            f"{where}: unexpected transform {row['transform_type']!r}"
        )
        assert row["confidence"] in valid_confidence, (
            f"{where}: unexpected confidence {row['confidence']!r}"
        )
        assert row["grain_change"].strip(), f"{where}: grain change not described"


def test_low_confidence_rows_explain_themselves(in_scope_rows):
    """A low-confidence mapping has to say why.

    Low confidence means there is no real system of record for the concept.
    That is an honest answer, but only if the reason is written down -- an
    unexplained `low` is indistinguishable from carelessness.
    """
    unexplained = [
        f"{r['mvm_domain']}.{r['mvm_table']}"
        for r in in_scope_rows
        if r["confidence"] == "low" and not r["notes"].strip()
    ]
    assert not unexplained, f"low-confidence rows with no explanation: {unexplained}"


def test_every_source_table_exists_in_the_ddl(in_scope_rows):
    """The mapping cannot name a table that was never built.

    This is the check that keeps the mapping honest. It is easy to write a
    plausible source table name into a spreadsheet; it is harder to notice
    that nothing was ever created for it.
    """
    ddl = ddl_introspect.read_all()
    existing = {
        f"{schema}.{table}"
        for schema, info in ddl.items()
        for table in info.all_tables
    }

    referenced: set[str] = set()
    for row in in_scope_rows:
        referenced.update(row["source_tables"].split())

    phantom = sorted(referenced - existing)
    assert not phantom, f"source tables named in the mapping but absent from oltp/: {phantom}"


def test_ownership_map_matches_the_scope_boundary(upstream):
    """The curated ownership map covers exactly the in-scope set."""
    _, in_scope = upstream
    owned = {f"{r.domain}.{r.table}" for r in ownership_rows()}

    assert owned == in_scope, (
        f"missing from ownership: {sorted(in_scope - owned)} | "
        f"stray in ownership: {sorted(owned - in_scope)}"
    )


def test_all_ten_systems_own_something(in_scope_rows):
    """Every named system is actually used.

    A system named in the upstream model but owning no target table would mean
    either the ownership review missed something or the system does not belong
    in the model.
    """
    used = {r["source_system"] for r in in_scope_rows}
    expected = {s.schema for s in SYSTEMS}
    assert used == expected, f"systems owning nothing: {sorted(expected - used)}"


def test_excluded_rows_state_what_would_be_needed(out_of_scope_rows):
    """Each exclusion names the class of system that would bring it in scope."""
    for row in out_of_scope_rows:
        where = f"{row['mvm_domain']}.{row['mvm_table']}"
        assert row["reason"].strip(), f"{where}: no exclusion reason"
        assert row["would_require"].strip(), f"{where}: does not say what would be needed"


def test_referenced_domain_types_are_declared():
    """Every ``common.dom_*`` used by a schema is created by sql/01_common.sql."""
    declared = ddl_introspect.declared_domains()
    used: set[str] = set()
    for info in ddl_introspect.read_all().values():
        used |= info.domains_used

    undeclared = sorted(used - declared)
    assert not undeclared, f"domain types referenced but never created: {undeclared}"
