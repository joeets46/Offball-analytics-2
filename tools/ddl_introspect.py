"""Parse the generated DDL back out of the ``oltp/`` tree.

The point is self-checking. The ownership map names source tables, the
mapping CSV publishes them, and the docs quote counts -- all of which can
drift from the DDL that actually exists. Reading the SQL back and comparing is
what makes the drift impossible to miss.

This is deliberately a text parse rather than a database query, so the checks
run without a live PostgreSQL. The database-backed checks live in ``tests/``
and go further: they can see constraints, indexes and comments.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path

OLTP = Path(__file__).resolve().parent.parent / "oltp"

#: Files that define tables, in load order. ``70_audit.sql`` is included
#: because it creates the ``_change_log`` table.
DDL_FILES = (
    "00_schema.sql",
    "10_domains_and_enums.sql",
    "20_reference.sql",
    "30_master.sql",
    "31_master_pii.sql",
    "40_transaction.sql",
    "50_constraints.sql",
    "60_indexes.sql",
    "70_audit.sql",
    "80_comments.sql",
)

_CREATE_TABLE = re.compile(
    r"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\.(\w+)", re.IGNORECASE
)
_PARTITION_OF = re.compile(
    r"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\.(\w+)\s+PARTITION\s+OF",
    re.IGNORECASE,
)
_FK_REF = re.compile(r"REFERENCES\s+(\w+)\.(\w+)\s*\(", re.IGNORECASE)
_DOMAIN_USE = re.compile(r"\bcommon\.(dom_\w+)")


@dataclass
class SchemaDdl:
    """What one schema's DDL declares."""

    schema: str
    #: Base tables, excluding partition children.
    tables: set[str] = field(default_factory=set)
    #: Partition children, which are tables but not independent ones.
    partitions: set[str] = field(default_factory=set)
    #: ``common.dom_*`` types referenced anywhere in the schema.
    domains_used: set[str] = field(default_factory=set)
    #: Targets of REFERENCES clauses, as ``schema.table``.
    fk_targets: set[str] = field(default_factory=set)
    #: Files that were present on disk.
    files: tuple[str, ...] = ()

    @property
    def all_tables(self) -> set[str]:
        return self.tables | self.partitions


def read_schema(schema: str) -> SchemaDdl:
    """Parse one schema's DDL directory."""
    ddl_dir = OLTP / schema / "ddl"
    result = SchemaDdl(schema=schema)
    present: list[str] = []

    for name in DDL_FILES:
        path = ddl_dir / name
        if not path.exists():
            continue
        present.append(name)
        sql = path.read_text(encoding="utf-8")
        # Strip line comments so prose mentioning a table name is not mistaken
        # for a declaration. This matters: the comments here name target tables
        # constantly.
        sql_code = re.sub(r"--[^\n]*", "", sql)

        partitions = {m.group(2) for m in _PARTITION_OF.finditer(sql_code)}
        result.partitions |= partitions
        for m in _CREATE_TABLE.finditer(sql_code):
            table = m.group(2)
            if table not in partitions:
                result.tables.add(table)

        result.domains_used |= set(_DOMAIN_USE.findall(sql_code))
        result.fk_targets |= {
            f"{m.group(1)}.{m.group(2)}" for m in _FK_REF.finditer(sql_code)
        }

    # A partition child can be matched by both patterns depending on ordering;
    # make the two sets strictly disjoint.
    result.tables -= result.partitions
    result.files = tuple(present)
    return result


def read_all() -> dict[str, SchemaDdl]:
    """Parse every schema directory under ``oltp/``."""
    schemas = sorted(d.name for d in OLTP.iterdir() if (d / "ddl").is_dir())
    return {s: read_schema(s) for s in schemas}


def declared_domains() -> set[str]:
    """The ``common.dom_*`` types that ``sql/01_common.sql`` actually creates."""
    path = Path(__file__).resolve().parent.parent / "sql" / "01_common.sql"
    sql = path.read_text(encoding="utf-8")
    return set(re.findall(r"CREATE DOMAIN common\.(dom_\w+)", sql))
