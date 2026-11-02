"""Every schema loads into a clean PostgreSQL 18 without errors."""

from __future__ import annotations

import pytest

from tests.conftest import SCHEMA_ORDER

pytestmark = pytest.mark.database


def test_all_ddl_files_load_without_error(loaded_db):
    """A clean, ordered load produces no errors at all.

    This is the headline check. The 50_constraints.sql split exists precisely
    so a single forward pass works without deferred constraints, so any error
    here means either a genuine SQL fault or a dependency the load order does
    not respect.
    """
    failures = loaded_db.load_failures
    assert not failures, "DDL failed to load:\n" + "\n".join(f"  {f}" for f in failures)


def test_every_schema_exists(loaded_db):
    """All ten system schemas plus `common` are present after the load."""
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT nspname FROM pg_namespace
            WHERE nspname NOT LIKE 'pg_%' AND nspname <> 'information_schema'
            """
        )
        present = {row[0] for row in cur.fetchall()}

    expected = {"common", *SCHEMA_ORDER}
    assert expected <= present, f"missing schemas: {sorted(expected - present)}"


def test_shared_domain_types_created(loaded_db):
    """The generated DOMAIN types exist and carry their CHECK constraints.

    A DOMAIN without its constraint would load silently and validate nothing,
    which is the failure mode worth guarding against.
    """
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT count(*) FROM pg_type t
            JOIN pg_namespace n ON n.oid = t.typnamespace
            WHERE n.nspname = 'common' AND t.typtype = 'd'
            """
        )
        domain_count = cur.fetchone()[0]

        cur.execute(
            """
            SELECT count(DISTINCT c.contypid) FROM pg_constraint c
            JOIN pg_type t ON t.oid = c.contypid
            JOIN pg_namespace n ON n.oid = t.typnamespace
            WHERE n.nspname = 'common' AND c.contype = 'c'
            """
        )
        constrained = cur.fetchone()[0]

    assert domain_count >= 50, f"expected ~55 domain types, found {domain_count}"
    assert constrained == domain_count, (
        f"{domain_count - constrained} domain type(s) have no CHECK constraint, "
        "so they validate nothing"
    )


def test_no_foreign_key_crosses_a_system_schema(loaded_db):
    """The per-system premise: no enforced reference spans two source systems.

    Cross-system references are business keys resolved through
    common.entity_xref. A real foreign key between two system schemas would
    mean the model is quietly assuming one database.
    """
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT child_ns.nspname || '.' || child.relname || ' -> '
                   || parent_ns.nspname || '.' || parent.relname
            FROM pg_constraint c
            JOIN pg_class child       ON child.oid = c.conrelid
            JOIN pg_namespace child_ns  ON child_ns.oid = child.relnamespace
            JOIN pg_class parent      ON parent.oid = c.confrelid
            JOIN pg_namespace parent_ns ON parent_ns.oid = parent.relnamespace
            WHERE c.contype = 'f'
              AND child_ns.nspname <> parent_ns.nspname
              AND parent_ns.nspname <> 'common'
            """
        )
        offenders = [row[0] for row in cur.fetchall()]

    assert not offenders, "foreign keys crossing a system boundary:\n" + "\n".join(
        f"  {o}" for o in offenders
    )


def test_every_foreign_key_resolves(loaded_db):
    """No foreign key points at a table that does not exist."""
    with loaded_db.cursor() as cur:
        cur.execute("SELECT conname FROM pg_constraint WHERE contype = 'f' AND confrelid = 0")
        unresolved = [row[0] for row in cur.fetchall()]

    assert not unresolved, f"unresolved foreign keys: {unresolved}"


def test_partitioned_tables_have_a_default_partition(loaded_db):
    """Every partitioned table has a catch-all, so an out-of-range insert fails loudly.

    Without a DEFAULT partition an insert outside every range is rejected
    outright. With one, the row lands somewhere visible and the operator can
    see that partition maintenance has fallen behind.
    """
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT n.nspname || '.' || c.relname
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind = 'p'
              AND NOT EXISTS (
                  SELECT 1 FROM pg_inherits i
                  JOIN pg_class child ON child.oid = i.inhrelid
                  WHERE i.inhparent = c.oid
                    AND pg_get_expr(child.relpartbound, child.oid) = 'DEFAULT'
              )
            """
        )
        missing = [row[0] for row in cur.fetchall()]

    assert not missing, f"partitioned tables without a DEFAULT partition: {missing}"


def test_watermark_triggers_exist_on_every_schema(loaded_db):
    """Each schema maintains its own modification watermark by trigger.

    The ingestion contract treats the watermark column as truthful. An
    application-maintained timestamp is missed on exactly the UPDATE paths
    nobody remembers, so it has to be a trigger.
    """
    with loaded_db.cursor() as cur:
        cur.execute(
            """
            SELECT n.nspname, count(*)
            FROM pg_trigger t
            JOIN pg_class c ON c.oid = t.tgrelid
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE NOT t.tgisinternal AND t.tgname LIKE '%_touch'
            GROUP BY n.nspname
            """
        )
        counts = dict(cur.fetchall())

    for schema in SCHEMA_ORDER:
        assert counts.get(schema, 0) > 0, f"{schema} has no watermark triggers"
