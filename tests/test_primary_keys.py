"""Every table has a primary key.

Worth asserting rather than assuming. A table with no primary key cannot be
deduplicated on load, cannot be targeted by a CDC stream, and cannot be
referenced -- and it is easy to leave one out of a 255-table model, especially
an associative table where the key is composite and has to be written by hand.
"""

from __future__ import annotations

import pytest

pytestmark = pytest.mark.database


def test_every_base_table_has_a_primary_key(loaded_db):
    """No base table is without a primary key.

    Partition children are excluded: they inherit the parent's key rather
    than declaring their own.
    """
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT n.nspname || '.' || c.relname
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind IN ('r', 'p')
              AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
              AND NOT c.relispartition
              AND NOT EXISTS (
                  SELECT 1 FROM pg_constraint k
                  WHERE k.conrelid = c.oid AND k.contype = 'p'
              )
            ORDER BY 1
            """
        )
        missing = [row[0] for row in cur.fetchall()]

    assert not missing, "tables without a primary key:\n" + "\n".join(
        f"  {t}" for t in missing
    )


def test_partitioned_primary_keys_include_the_partition_key(loaded_db):
    """A partitioned table's primary key contains its partition key.

    PostgreSQL requires this, so the real value of the check is that it
    documents why the event tables use a composite key like
    (scan_id, scanned_at) rather than the bare surrogate.
    """
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT n.nspname || '.' || c.relname AS tbl,
                   (SELECT array_agg(a.attname ORDER BY a.attnum)
                      FROM pg_attribute a
                     WHERE a.attrelid = c.oid
                       AND a.attnum = ANY (pk.conkey)) AS pk_cols,
                   (SELECT array_agg(a.attname ORDER BY a.attnum)
                      FROM pg_attribute a
                     WHERE a.attrelid = c.oid
                       AND a.attnum = ANY (p.partattrs)) AS part_cols
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            JOIN pg_partitioned_table p ON p.partrelid = c.oid
            JOIN pg_constraint pk ON pk.conrelid = c.oid AND pk.contype = 'p'
            WHERE c.relkind = 'p'
            """
        )
        rows = cur.fetchall()

    assert rows, "expected at least one partitioned table"
    for table, pk_cols, part_cols in rows:
        assert set(part_cols) <= set(pk_cols), (
            f"{table}: partition key {part_cols} is not contained in "
            f"primary key {pk_cols}"
        )


def test_every_table_has_a_comment(loaded_db):
    """Every table is documented.

    The data dictionary is generated from these comments, so an undocumented
    table becomes an empty dictionary row. Coverage is complete, so this
    asserts exactly that and names any table that regresses.
    """
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT n.nspname || '.' || c.relname,
                   obj_description(c.oid, 'pg_class') IS NOT NULL AS has_table_comment,
                   (SELECT count(*) FROM pg_description d
                     WHERE d.objoid = c.oid AND d.objsubid > 0) AS column_comments
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind IN ('r', 'p')
              AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
              AND NOT c.relispartition
              AND c.relname NOT LIKE '\\_%'
            """
        )
        rows = cur.fetchall()

    undocumented = sorted(r[0] for r in rows if not r[1] and r[2] == 0)
    detail = "\n".join(f"  {t}" for t in undocumented)
    assert not undocumented, (
        f"{len(undocumented)} of {len(rows)} tables carry neither a table nor a "
        "column comment, so they would be blank rows in the generated "
        f"dictionary:\n{detail}"
    )


def test_every_schema_is_commented(loaded_db):
    """Each schema explains which system it represents."""
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT nspname
            FROM pg_namespace
            WHERE nspname NOT LIKE 'pg_%'
              AND nspname NOT IN ('information_schema', 'public')
              AND obj_description(oid, 'pg_namespace') IS NULL
            """
        )
        undocumented = [row[0] for row in cur.fetchall()]

    assert not undocumented, f"schemas without a COMMENT: {undocumented}"
