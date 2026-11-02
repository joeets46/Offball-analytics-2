"""Generate the data dictionary from a loaded database.

Read from ``pg_catalog`` rather than parsed out of the DDL text, because the
catalog is the authority: it knows the resolved type behind every ``DOMAIN``,
which columns are generated, what the real defaults are, and which constraints
actually took effect. A text parse would be guessing at all four.

Requires the model to be loaded::

    docker compose up -d
    psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f sql/00_create_all.sql
    uv run offball-dictionary

Outputs to ``dictionary/``:

``oltp_tables.csv``
    One row per table: schema, name, kind, row counts of columns and
    constraints, and the description.
``oltp_columns.csv``
    One row per column: type, nullability, default, key role, the domain it
    sits on, and the description.
``oltp_constraints.csv``
    Every primary key, foreign key, unique and check constraint, with its
    definition.
``oltp_domains.csv``
    The shared scalar types and the pattern each enforces.
"""

from __future__ import annotations

import os
from pathlib import Path

from .scope import SYSTEMS, to_csv

ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "dictionary"

SCHEMAS = ("common", *(s.schema for s in SYSTEMS))


def _dsn() -> str:
    """Connection string, from DATABASE_URL or the POSTGRES_* parts."""
    if os.environ.get("DATABASE_URL"):
        return os.environ["DATABASE_URL"]
    env_path = ROOT / ".env"
    if env_path.exists():
        for line in env_path.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, _, value = line.partition("=")
                os.environ.setdefault(key.strip(), value.strip())
    if os.environ.get("DATABASE_URL"):
        return os.environ["DATABASE_URL"]
    host = os.environ.get("POSTGRES_HOST", "localhost")
    port = os.environ.get("POSTGRES_PORT", "55432")
    user = os.environ.get("POSTGRES_USER", "offball")
    password = os.environ.get("POSTGRES_PASSWORD", "offball")
    db = os.environ.get("POSTGRES_DB", "offball")
    return f"postgresql://{user}:{password}@{host}:{port}/{db}"


TABLES_SQL = """
SELECT n.nspname                                    AS schema_name,
       c.relname                                    AS table_name,
       CASE c.relkind WHEN 'p' THEN 'partitioned'
                      WHEN 'r' THEN CASE WHEN c.relispartition THEN 'partition'
                                         ELSE 'table' END
       END                                          AS table_kind,
       parent.relname                               AS partition_of,
       (SELECT count(*) FROM pg_attribute a
         WHERE a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped)
                                                    AS column_count,
       (SELECT count(*) FROM pg_constraint k
         WHERE k.conrelid = c.oid AND k.contype = 'f')  AS foreign_key_count,
       (SELECT count(*) FROM pg_constraint k
         WHERE k.conrelid = c.oid AND k.contype = 'c')  AS check_count,
       (SELECT count(*) FROM pg_index i
         WHERE i.indrelid = c.oid)                      AS index_count,
       coalesce(obj_description(c.oid, 'pg_class'), '') AS description
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_inherits inh ON inh.inhrelid = c.oid
LEFT JOIN pg_class parent ON parent.oid = inh.inhparent
WHERE c.relkind IN ('r', 'p')
  AND n.nspname = ANY(%s)
ORDER BY n.nspname, c.relname;
"""

COLUMNS_SQL = """
SELECT n.nspname                                     AS schema_name,
       c.relname                                     AS table_name,
       a.attnum                                      AS ordinal,
       a.attname                                     AS column_name,
       -- format_type resolves a DOMAIN to its own name, which is what we want
       -- in the dictionary; base_type below gives what it sits on.
       format_type(a.atttypid, a.atttypmod)          AS data_type,
       CASE WHEN t.typtype = 'd'
            THEN format_type(t.typbasetype, t.typtypmod) END AS domain_base_type,
       NOT a.attnotnull                              AS is_nullable,
       coalesce(pg_get_expr(ad.adbin, ad.adrelid), '') AS column_default,
       a.attgenerated <> ''                          AS is_generated,
       a.attidentity <> ''                           AS is_identity,
       EXISTS (SELECT 1 FROM pg_constraint k
                WHERE k.conrelid = c.oid AND k.contype = 'p'
                  AND a.attnum = ANY (k.conkey))     AS is_primary_key,
       EXISTS (SELECT 1 FROM pg_constraint k
                WHERE k.conrelid = c.oid AND k.contype = 'f'
                  AND a.attnum = ANY (k.conkey))     AS is_foreign_key,
       (SELECT string_agg(DISTINCT fn.nspname || '.' || f.relname, ' ')
          FROM pg_constraint k
          JOIN pg_class f ON f.oid = k.confrelid
          JOIN pg_namespace fn ON fn.oid = f.relnamespace
         WHERE k.conrelid = c.oid AND k.contype = 'f'
           AND a.attnum = ANY (k.conkey))            AS references_table,
       coalesce(col_description(c.oid, a.attnum), '') AS description
FROM pg_attribute a
JOIN pg_class c ON c.oid = a.attrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_type t ON t.oid = a.atttypid
LEFT JOIN pg_attrdef ad ON ad.adrelid = c.oid AND ad.adnum = a.attnum
WHERE c.relkind IN ('r', 'p')
  AND NOT c.relispartition
  AND a.attnum > 0
  AND NOT a.attisdropped
  AND n.nspname = ANY(%s)
ORDER BY n.nspname, c.relname, a.attnum;
"""

CONSTRAINTS_SQL = """
SELECT n.nspname                                AS schema_name,
       c.relname                                AS table_name,
       k.conname                                AS constraint_name,
       CASE k.contype WHEN 'p' THEN 'primary_key'
                      WHEN 'f' THEN 'foreign_key'
                      WHEN 'u' THEN 'unique'
                      WHEN 'c' THEN 'check'
                      ELSE k.contype::text END  AS constraint_type,
       pg_get_constraintdef(k.oid)              AS definition,
       coalesce(obj_description(k.oid, 'pg_constraint'), '') AS description
FROM pg_constraint k
JOIN pg_class c ON c.oid = k.conrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = ANY(%s)
  AND NOT c.relispartition
ORDER BY n.nspname, c.relname,
         CASE k.contype WHEN 'p' THEN 1 WHEN 'u' THEN 2 WHEN 'f' THEN 3 ELSE 4 END,
         k.conname;
"""

DOMAINS_SQL = """
SELECT t.typname                                AS domain_type,
       format_type(t.typbasetype, t.typtypmod)  AS base_type,
       NOT t.typnotnull                         AS is_nullable,
       (SELECT string_agg(pg_get_constraintdef(k.oid), ' AND ')
          FROM pg_constraint k WHERE k.contypid = t.oid) AS constraint_definition,
       (SELECT count(*) FROM pg_attribute a
          JOIN pg_class c ON c.oid = a.attrelid
         WHERE a.atttypid = t.oid AND a.attnum > 0 AND NOT a.attisdropped
           AND c.relkind IN ('r', 'p') AND NOT c.relispartition) AS used_by_columns,
       coalesce(obj_description(t.oid, 'pg_type'), '') AS description
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE n.nspname = 'common' AND t.typtype = 'd'
ORDER BY t.typname;
"""


def _write(name: str, content: str) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / name).write_text(content, encoding="utf-8", newline="")


def _yn(value: object) -> str:
    """Booleans as yes/blank, which reads better in a spreadsheet than True/False."""
    return "yes" if value else ""


def main(argv: list[str] | None = None) -> int:
    try:
        import psycopg
    except ImportError:
        print("psycopg is required: uv sync --extra test")
        return 1

    dsn = _dsn()
    try:
        conn = psycopg.connect(dsn, connect_timeout=5)
    except Exception as exc:  # noqa: BLE001
        print(f"cannot connect to {dsn.rsplit('@', 1)[-1]}: {exc.__class__.__name__}")
        print("start the database with: docker compose up -d")
        print("then load it with:       psql \"$DATABASE_URL\" -f sql/00_create_all.sql")
        return 1

    schemas = list(SCHEMAS)
    with conn, conn.cursor() as cur:
        cur.execute(TABLES_SQL, (schemas,))
        tables = cur.fetchall()
        cur.execute(COLUMNS_SQL, (schemas,))
        columns = cur.fetchall()
        cur.execute(CONSTRAINTS_SQL, (schemas,))
        constraints = cur.fetchall()
        cur.execute(DOMAINS_SQL)
        domains = cur.fetchall()

    if not tables:
        print("no tables found -- is the model loaded?")
        print('  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f sql/00_create_all.sql')
        return 1

    _write(
        "oltp_tables.csv",
        to_csv(
            ["schema_name", "table_name", "table_kind", "partition_of",
             "column_count", "foreign_key_count", "check_count", "index_count",
             "description"],
            [
                [r[0], r[1], r[2], r[3] or "", r[4], r[5], r[6], r[7], r[8]]
                for r in tables
            ],
        ),
    )

    _write(
        "oltp_columns.csv",
        to_csv(
            ["schema_name", "table_name", "ordinal", "column_name", "data_type",
             "domain_base_type", "is_nullable", "column_default", "is_generated",
             "is_identity", "is_primary_key", "is_foreign_key", "references_table",
             "description"],
            [
                [r[0], r[1], r[2], r[3], r[4], r[5] or "", _yn(r[6]), r[7],
                 _yn(r[8]), _yn(r[9]), _yn(r[10]), _yn(r[11]), r[12] or "", r[13]]
                for r in columns
            ],
        ),
    )

    _write(
        "oltp_constraints.csv",
        to_csv(
            ["schema_name", "table_name", "constraint_name", "constraint_type",
             "definition", "description"],
            [list(r) for r in constraints],
        ),
    )

    _write(
        "oltp_domains.csv",
        to_csv(
            ["domain_type", "base_type", "is_nullable", "constraint_definition",
             "used_by_columns", "description"],
            [
                [r[0], r[1], _yn(r[2]), r[3] or "", r[4], r[5]]
                for r in domains
            ],
        ),
    )

    # A short README so the CSVs are usable without reading this script.
    # Count like with like: partitions inherit their parent description, so
    # including them would report coverage above 100%.
    base_rows = [r for r in tables if r[2] != "partition"]
    base_tables = len(base_rows)
    documented_tables = sum(1 for r in base_rows if r[8])
    documented_columns = sum(1 for r in columns if r[13])

    _write(
        "README.md",
        f"""# Data dictionary

GENERATED by `uv run offball-dictionary` from a loaded database. Do not edit;
edit the `COMMENT ON` statements in `oltp/*/ddl/` and regenerate.

Read from `pg_catalog` rather than parsed from the DDL, so the types shown are
the ones PostgreSQL resolved -- including what each `DOMAIN` sits on, which
columns are generated, and which constraints actually took effect.

| File | Rows | What it holds |
|---|--:|---|
| `oltp_tables.csv` | {len(tables)} | Every table and partition, with column and constraint counts |
| `oltp_columns.csv` | {len(columns)} | Every column of every base table |
| `oltp_constraints.csv` | {len(constraints)} | Primary keys, foreign keys, unique and check constraints with definitions |
| `oltp_domains.csv` | {len(domains)} | Shared scalar types and the pattern each enforces |

Coverage: {documented_tables}/{base_tables} base tables carry a description,
and {documented_columns} columns do. Column descriptions are deliberately
selective -- they explain the columns where the *reason* for the design is not
obvious from the name, rather than restating every name as a sentence.

## Reading it

`oltp_columns.csv` is the one to start from. Two columns repay attention:

- **`domain_base_type`** is populated only where the column sits on a shared
  `DOMAIN`. It shows what the domain resolves to, so you can see that
  `common.dom_iso3_code` is really a `VARCHAR(3)` with a pattern check.
- **`references_table`** gives the foreign key target, and is empty for the
  business-key columns that point at another *system*. That emptiness is the
  point: those references cross a database boundary and are resolved through
  `common.entity_xref` instead.
""",
    )

    print("dictionary/ written")
    print(f"  oltp_tables.csv       {len(tables):>5} rows ({base_tables} base tables)")
    print(f"  oltp_columns.csv      {len(columns):>5} rows")
    print(f"  oltp_constraints.csv  {len(constraints):>5} rows")
    print(f"  oltp_domains.csv      {len(domains):>5} rows")
    print(f"  descriptions          {documented_tables}/{base_tables} tables, "
          f"{documented_columns} columns")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
