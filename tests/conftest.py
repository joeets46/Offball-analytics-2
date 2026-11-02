"""Shared pytest fixtures.

The database-backed tests need a live PostgreSQL 18. Start one with::

    docker compose up -d

If it is not reachable, those tests skip rather than fail: the mapping and
scope tests are pure-Python and should still run in an environment with no
Docker.
"""

from __future__ import annotations

import os
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent

#: Load order within a schema, matching tools/load.sh and sql/00_create_all.sql.
FILE_ORDER = (
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

#: `common` first, then the ten systems. The systems are mutually independent
#: by design, so their relative order does not matter.
SCHEMA_ORDER = (
    "sap_s4", "tm_axs", "archtics", "sfdc_crm", "shopify",
    "adobe_aep", "hudl", "dalet", "sap_sfsf", "workday_ap",
)


def _load_dotenv() -> None:
    """Read .env into the environment if present, without adding a dependency."""
    env_path = ROOT / ".env"
    if not env_path.exists():
        return
    for line in env_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        os.environ.setdefault(key.strip(), value.strip())


_load_dotenv()


def _dsn(database: str | None = None) -> str:
    host = os.environ.get("POSTGRES_HOST", "localhost")
    port = os.environ.get("POSTGRES_PORT", "55432")
    user = os.environ.get("POSTGRES_USER", "offball")
    password = os.environ.get("POSTGRES_PASSWORD", "offball")
    db = database or os.environ.get("POSTGRES_DB", "offball")
    return f"postgresql://{user}:{password}@{host}:{port}/{db}"


@pytest.fixture(scope="session")
def psycopg():
    """The psycopg module, or skip the test if it is not installed."""
    return pytest.importorskip("psycopg", reason="install with: uv sync --extra test")


@pytest.fixture(scope="session")
def ddl_files() -> list[tuple[str, Path]]:
    """Every DDL file, in load order, as ``(schema, path)``."""
    files: list[tuple[str, Path]] = [
        ("common", ROOT / "sql" / "01_common.sql"),
        ("common", ROOT / "sql" / "02_common_comments.sql"),
    ]
    for schema in SCHEMA_ORDER:
        ddl_dir = ROOT / "oltp" / schema / "ddl"
        for name in FILE_ORDER:
            path = ddl_dir / name
            if path.exists():
                files.append((schema, path))
    return files


@pytest.fixture(scope="session")
def loaded_db(psycopg, ddl_files):
    """A database with the whole model loaded.

    Builds into a dedicated ``offball_model_test`` database so a developer's
    working database is never dropped by a test run. The build happens once
    per session; the tests that follow only read.
    """
    admin_dsn = _dsn("postgres")
    test_db = "offball_model_test"

    try:
        admin = psycopg.connect(admin_dsn, autocommit=True, connect_timeout=5)
    except Exception as exc:  # noqa: BLE001 - any connection problem means skip
        pytest.skip(
            f"PostgreSQL not reachable at {_dsn('postgres')} ({exc.__class__.__name__}). "
            "Start it with: docker compose up -d"
        )

    with admin:
        with admin.cursor() as cur:
            cur.execute(f"DROP DATABASE IF EXISTS {test_db} WITH (FORCE)")
            cur.execute(f"CREATE DATABASE {test_db}")

    conn = psycopg.connect(_dsn(test_db), autocommit=True)
    failures: list[str] = []
    with conn.cursor() as cur:
        for schema, path in ddl_files:
            sql = path.read_text(encoding="utf-8")
            try:
                cur.execute(sql)
            except Exception as exc:  # noqa: BLE001 - reported, not raised
                rel = path.relative_to(ROOT).as_posix()
                failures.append(f"{rel}: {exc}")

    conn.load_failures = failures  # type: ignore[attr-defined]
    yield conn
    conn.close()
