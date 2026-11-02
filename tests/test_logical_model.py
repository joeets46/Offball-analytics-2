"""The logical model is internally consistent.

Pure Python, no database. DBML has no type checker available here, so these
tests do the job a validator would: every relationship resolves to a declared
table and column, every subject area is present, and the normalization the
model claims to have done is actually there.
"""

from __future__ import annotations

import re
from pathlib import Path

import pytest

LOGICAL = Path(__file__).resolve().parent.parent / "logical"

TABLE_RE = re.compile(r"^Table\s+(\w+)\s*\{", re.M)
REF_RE = re.compile(r"^Ref:\s*(\w+)\.(\w+)\s*[<>-]\s*(\w+)\.(\w+)", re.M)

EXPECTED_FILES = (
    "01-competition-events.dbml",
    "02-venue-access.dbml",
    "03-commerce-fan.dbml",
    "04-media-rights.dbml",
    "05-corporate.dbml",
)


def _balanced_body(text: str, open_brace: int) -> str:
    """Text between ``open_brace`` and its matching close brace."""
    depth = 0
    for i in range(open_brace, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[open_brace + 1 : i]
    return text[open_brace:]


def _parse() -> tuple[dict[str, set[str]], list[tuple[str, str, str, str, str]], dict[str, int]]:
    """Return (table -> columns, refs, table -> pk marker count)."""
    tables: dict[str, set[str]] = {}
    refs: list[tuple[str, str, str, str, str]] = []
    pk_counts: dict[str, int] = {}

    for path in sorted(LOGICAL.glob("*.dbml")):
        text = path.read_text(encoding="utf-8")
        for match in TABLE_RE.finditer(text):
            name = match.group(1)
            body = _balanced_body(text, match.end() - 1)
            columns: set[str] = set()
            for line in body.splitlines():
                line = line.strip()
                # Skip comments, notes, index blocks and continuation lines.
                if not line or line.startswith(("//", "note:", "indexes", "'''", "(")):
                    continue
                token = re.match(r"^(\w+)\s+\w", line)
                if token:
                    columns.add(token.group(1))
            tables[name] = columns
            pk_counts[name] = body.count("[pk")
        for match in REF_RE.finditer(text):
            refs.append((path.name, *match.groups()))

    return tables, refs, pk_counts


@pytest.fixture(scope="module")
def model():
    return _parse()


def test_all_five_subject_areas_exist():
    present = {p.name for p in LOGICAL.glob("*.dbml")}
    missing = set(EXPECTED_FILES) - present
    assert not missing, f"missing subject area files: {sorted(missing)}"


def test_every_relationship_resolves(model):
    """No Ref points at a table or column that was never declared.

    This is the check a DBML validator would do, and the one that catches a
    renamed column leaving a dangling relationship behind.
    """
    tables, refs, _ = model
    problems: list[str] = []

    for src_file, t1, c1, t2, c2 in refs:
        for table, column in ((t1, c1), (t2, c2)):
            if table not in tables:
                problems.append(f"{src_file}: reference to undeclared table {table}")
            elif column not in tables[table]:
                problems.append(f"{src_file}: reference to undeclared column {table}.{column}")

    assert not problems, "unresolved references:\n" + "\n".join(
        f"  {p}" for p in sorted(set(problems))
    )


def test_no_duplicate_entity_names(model):
    """An entity name is unique across all five subject areas.

    Several entities are referenced across areas -- party, event, venue -- and
    a duplicate definition would mean two different things share a name.
    """
    names: list[str] = []
    for path in sorted(LOGICAL.glob("*.dbml")):
        names.extend(TABLE_RE.findall(path.read_text(encoding="utf-8")))
    duplicates = sorted({n for n in names if names.count(n) > 1})
    assert not duplicates, f"entity names defined more than once: {duplicates}"


def test_every_entity_has_an_identifier(model):
    """Every entity declares at least one `pk` column."""
    _, _, pk_counts = model
    without = sorted(t for t, n in pk_counts.items() if n == 0)
    assert not without, f"entities with no identifier: {without}"


def test_associative_entities_outnumber_the_upstream_model(model):
    """The logical model restores the many-to-many relationships upstream dropped.

    The upstream MVM keeps only 6 associative tables out of 200 by design --
    it "minimises M:N associations and relies on direct foreign key
    relationships for simplicity". That is cheap in a star schema and wrong in
    a transactional model, because it makes a multi-valued relationship
    single-valued. A composite primary key is the signature of an associative
    entity, so counting them measures whether the normalization actually
    happened.
    """
    _, _, pk_counts = model
    associative = [t for t, n in pk_counts.items() if n >= 2]
    assert len(associative) >= 25, (
        f"only {len(associative)} associative entities; the upstream model has 6, "
        "and the logical model is supposed to restore substantially more"
    )


def test_supertypes_are_present(model):
    """The four supertypes the README claims are actually declared.

    Each one exists because the upstream model either flattened genuinely
    different things into one wide table, or split one thing across several.
    """
    tables, _, _ = model
    for supertype, subtypes in {
        "party": ("person", "organisation"),
        "event": ("competitive_fixture", "performance_event"),
        "sales_order": ("order_line",),
        "agreement": ("rights_agreement", "sponsorship_agreement"),
    }.items():
        assert supertype in tables, f"supertype {supertype} is not declared"
        for subtype in subtypes:
            assert subtype in tables, f"subtype {subtype} of {supertype} is not declared"


def test_supertype_subtypes_share_the_parent_key(model):
    """A subtype is keyed on its supertype, not on a key of its own.

    That shared key is what makes it a subtype rather than a separate entity
    with a foreign key.
    """
    tables, _, _ = model
    for supertype, key, subtypes in (
        ("party", "party_id", ("person", "organisation")),
        ("event", "event_id", ("competitive_fixture", "performance_event",
                               "event_schedule", "event_outcome")),
    ):
        for subtype in subtypes:
            assert key in tables[subtype], (
                f"{subtype} does not carry {key}, so it is not keyed on {supertype}"
            )
