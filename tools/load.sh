#!/usr/bin/env bash
# Loads the OLTP model into the verification database and reports object counts.
#
#   tools/load.sh            # full rebuild: drop, recreate, load everything
#   tools/load.sh tm_axs     # rebuild common + only the named schemas
#
# This is the no-local-psql path: it runs psql inside the container, so Docker
# is the only requirement. With psql installed locally, prefer:
#
#   psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f models/physical/sql/00_create_all.sql
#
# Connection settings come from .env, falling back to the same defaults as
# docker-compose.yml.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Read .env if present, without clobbering anything already exported.
if [ -f "$ROOT/.env" ]; then
    while IFS='=' read -r key value; do
        case "$key" in ''|\#*) continue ;; esac
        key="${key// /}"
        [ -n "${!key:-}" ] || export "$key=$value"
    done < "$ROOT/.env"
fi

CONTAINER="${OFFBALL_CONTAINER:-offball-pg18}"
DB="${POSTGRES_DB:-offball}"
USER_NAME="${POSTGRES_USER:-offball}"

if ! docker inspect "$CONTAINER" >/dev/null 2>&1; then
    echo "container '$CONTAINER' not found. Start it with: docker compose up -d" >&2
    exit 1
fi

psql_run() {
    docker exec -i "$CONTAINER" \
        psql -U "$USER_NAME" -d "$DB" -v ON_ERROR_STOP=1 -q "$@"
}

# Load order within a schema. FKs land after every table exists, so a single
# ordered pass works without deferred constraints.
FILE_ORDER=(00_schema 10_domains_and_enums 20_reference 30_master 31_master_pii \
            40_transaction 50_constraints 60_indexes 70_audit 80_comments)

if [ $# -gt 0 ]; then
    SCHEMAS=("$@")
else
    # The ten systems are mutually independent by design, so this order is for
    # readability rather than dependency.
    SCHEMAS=(sap_s4 tm_axs archtics sfdc_crm shopify adobe_aep hudl dalet sap_sfsf workday_ap)
fi

echo "==> resetting database $DB"
docker exec -i "$CONTAINER" psql -U "$USER_NAME" -d postgres -q \
    -c "DROP DATABASE IF EXISTS $DB WITH (FORCE);" -c "CREATE DATABASE $DB;"

echo "==> common"
psql_run < "$ROOT/models/physical/sql/01_common.sql"
psql_run < "$ROOT/models/physical/sql/02_common_comments.sql"

for schema in "${SCHEMAS[@]}"; do
    dir="$ROOT/models/physical/$schema/ddl"
    [ -d "$dir" ] || { echo "    (skip $schema -- no ddl directory)"; continue; }
    echo "==> $schema"
    for stem in "${FILE_ORDER[@]}"; do
        f="$dir/$stem.sql"
        [ -f "$f" ] || continue
        printf '    %-24s' "$stem"
        if psql_run < "$f" 2>/tmp/load_err; then
            echo "ok"
        else
            echo "FAILED"
            sed 's/^/      /' /tmp/load_err >&2
            exit 1
        fi
    done
done

echo
echo "==> object counts"
psql_run -c "
SELECT n.nspname                                        AS schema,
       count(*) FILTER (WHERE NOT c.relispartition)     AS tables,
       count(*) FILTER (WHERE c.relispartition)         AS partitions
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname NOT IN ('pg_catalog','information_schema','pg_toast')
  AND c.relkind IN ('r','p')
GROUP BY ROLLUP (n.nspname)
ORDER BY n.nspname NULLS LAST;"
