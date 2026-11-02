"""Generate the per-schema 70_audit.sql files.

Every one of the ten source schemas needs the same three things, and writing
them by hand ten times is how they drift:

  1. An ``updated_at`` BEFORE UPDATE trigger on each table that has the column.
     The ingestion contract in docs/07-integration-contract.md treats
     ``updated_at`` as the extraction watermark, so it has to be maintained by
     the database rather than trusted to the application.

  2. A ``_change_log`` table and trigger function. Deletes are the reason it
     exists: a high-water-mark read of ``updated_at`` cannot observe a row that
     is gone. The upstream model says its own timestamp pair is "required for
     incremental data pipeline processing in the Databricks Silver Layer" but
     offers no way to see a deletion.

  3. Role grants, including the REVOKEs on the PII satellites that make the
     satellite split an actual access control rather than just a layout.

The table list is read back out of each schema's own DDL, so this cannot fall
out of step with the tables that exist. Only the per-schema choices -- which
tables warrant change capture, which hold PII -- are configured here.

Usage::

    uv run offball-audit            # all configured schemas
    uv run offball-audit tm_axs     # just one
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OLTP = ROOT / "models" / "physical"

# Files to scan for table definitions, in load order. 70_audit.sql is excluded
# because that is what we are generating.
SCAN_FILES = (
    "10_domains_and_enums.sql",
    "20_reference.sql",
    "30_master.sql",
    "31_master_pii.sql",
    "40_transaction.sql",
)

CREATE_TABLE_RE = re.compile(
    r"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\.(\w+)\s*\(", re.IGNORECASE
)
PARTITION_OF_RE = re.compile(
    r"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\.(\w+)\s+PARTITION\s+OF", re.IGNORECASE
)


@dataclass
class SchemaConfig:
    """Per-schema choices the DDL itself cannot tell us."""

    system_name: str
    description: str
    #: The column this system maintains as its modification watermark. Each
    #: vendor names it differently and the extract depends on the real one:
    #: Salesforce replicates on SystemModstamp, not on a generic updated_at.
    touch_column: str = "updated_at"
    #: table -> primary key column, for tables that get change capture.
    #: Master and financial records, where a missed delete orphans the target.
    cdc_tables: dict[str, str] = field(default_factory=dict)
    #: Tables holding identifying PII. Denied to the analyst role.
    pii_tables: tuple[str, ...] = ()
    #: Append-only tables, noted in a comment so their lack of a trigger reads
    #: as deliberate.
    append_only: tuple[str, ...] = ()


CONFIG: dict[str, SchemaConfig] = {
    "tm_axs": SchemaConfig(
        system_name="Ticketmaster / AXS",
        description=(
            "Ticketmaster / AXS -- primary ticketing, payment capture and venue "
            "access control. System of record for ticketing.* and security access "
            "control in the target model. Extract pattern: CDC log."
        ),
        cdc_tables={
            "event": "event_id",
            "customer_account": "customer_account_id",
            "sales_order": "sales_order_id",
            "order_line": "order_line_id",
            "ticket": "ticket_id",
            "payment": "payment_id",
            "refund": "refund_id",
            "credential": "credential_id",
        },
        pii_tables=("customer_account_pii", "credential_pii"),
        append_only=("scan", "screening_event", "payment_transaction"),
    ),
    "sap_s4": SchemaConfig(
        system_name="SAP S/4HANA (FI/CO/MM/SD)",
        description=(
            "SAP S/4HANA FI/CO/MM/SD -- general ledger, receivables, payables, "
            "assets, materials, stock, pricing, contracts and plant maintenance. "
            "System of record for finance.* and the league org structure. Extract "
            "pattern: CDC log. Every table is keyed on MANDT; extracts must filter "
            "to one client."
        ),
        # BSID and BSIK matter most here. They are index tables: a row is
        # DELETED the moment the item clears, which is routine business rather
        # than an anomaly. A watermark read of updated_at would never observe an
        # invoice being paid, so the change log is the only way to see it.
        cdc_tables={
            "t001": "bukrs",
            "cepc": "prctr",
            "csks": "kostl",
            "ska1": "saknr",
            "kna1": "kunnr",
            "lfa1": "lifnr",
            "mara": "matnr",
            "mard": "matnr",
            "veda": "vbeln",
            "bkpf": "belnr",
            "vbrk": "vbeln",
            "rbkp": "belnr",
            "bsid": "belnr",
            "bsik": "belnr",
            "aufk": "aufnr",
        },
        # No PII satellite: SAP holds company and vendor data, not fan or
        # athlete identity. Athlete personal data sits in SuccessFactors.
        pii_tables=(),
    ),
    "sfdc_crm": SchemaConfig(
        system_name="Salesforce CRM",
        description=(
            "Salesforce CRM -- accounts, contacts, opportunities, contracts, "
            "campaigns and cases. System of record for fan identity, sponsorship "
            "deals and commercial counterparties. Extract pattern: API incremental "
            "on SystemModstamp, with IsDeleted filtered."
        ),
        # Salesforce replicates on SystemModstamp. It moves on platform-driven
        # changes that leave LastModifiedDate alone, so an extract keyed on
        # LastModifiedDate silently misses rows.
        touch_column="system_modstamp",
        # Salesforce soft-deletes to the Recycle Bin, so the change log here is
        # less about deletes than about the 15-day window in which a "deleted"
        # record is still queryable and must be tombstoned downstream.
        cdc_tables={
            "account": "id",
            "contact": "id",
            "opportunity": "id",
            "contract": "id",
            "contract_line_item": "id",
            "service_case": "id",
            "campaign": "id",
            "sales_order": "id",
        },
        pii_tables=("contact_pii",),
    ),
    "shopify": SchemaConfig(
        system_name="Shopify Plus",
        description=(
            "Shopify Plus -- storefront catalog, orders, fulfilment and returns. "
            "System of record for the sellable side of merchandise.*; SAP owns "
            "stock and costing. Extract pattern: webhooks for near-real-time plus "
            "a reconciling API sweep on updated_at."
        ),
        # Shopify rarely deletes, but it does: a product removed from the
        # catalog, an abandoned draft order. The change log also covers the
        # webhook gap -- deliveries are at-least-once, not guaranteed.
        cdc_tables={
            "product": "id",
            "product_variant": "id",
            "customer": "id",
            "sales_order": "id",
            "line_item": "id",
            "fulfillment": "id",
            "refund": "id",
            "return_request": "id",
        },
        # Customer identity is inline on shopify.customer rather than split:
        # the platform is SaaS and does not offer the separation, so modeling a
        # satellite here would misrepresent it. Grants restrict the table.
        pii_tables=(),
    ),
    "adobe_aep": SchemaConfig(
        system_name="Adobe Experience Platform",
        description=(
            "Adobe Experience Platform -- unified profile, identity graph, "
            "experience events, segments, consent and journeys. System of record "
            "for fan behaviour and the identity resolution point across the other "
            "systems. Extract pattern: event stream for experience events, API for "
            "profile and segment state."
        ),
        # Only the record-style tables. The event tables are immutable and
        # append-only, so a change log over them would double the highest write
        # volume in the estate to record changes that never happen.
        cdc_tables={
            "profile": "profile_id",
            "identity": "identity_id",
            "identity_graph_link": "identity_graph_link_id",
            "consent_record": "consent_record_id",
            "segment_membership": "profile_id",
            "privacy_job": "privacy_job_id",
        },
        # Profile attributes are the PII, but they are inherently inline on the
        # profile -- AEP's whole purpose is the unified record. Grants restrict
        # it instead.
        pii_tables=(),
        append_only=("experience_event", "journey_step_event"),
    ),
    "hudl": SchemaConfig(
        system_name="SportsCode / Hudl",
        description=(
            "SportsCode / Hudl -- video analysis, coded instances and derived "
            "performance metrics. The only named source for match events and "
            "athlete performance. Extract pattern: API incremental on updated_at."
        ),
        # Instances really are deleted: an analyst re-codes a passage and the
        # old instances go. Since target event.scoring_event is built from
        # them, a missed delete leaves phantom goals in the lakehouse.
        cdc_tables={
            "game": "game_id",
            "timeline": "timeline_id",
            "instance": "instance_id",
            "player_game_metric": "player_game_metric_id",
            "player": "player_id",
            "injury_note": "injury_note_id",
        },
        pii_tables=(),
        append_only=("instance_label", "playlist_instance"),
    ),
    "dalet": SchemaConfig(
        system_name="Dalet Galaxy",
        description=(
            "Dalet Galaxy -- media asset management, metadata, production "
            "workflow, rights windows and broadcast scheduling. System of record "
            "for content.* and broadcast production. Extract pattern: CDC log."
        ),
        cdc_tables={
            "media_object": "media_object_id",
            "essence": "essence_id",
            "metadata_value": "metadata_value_id",
            "collection": "collection_id",
            "job": "job_id",
            "rights_contract": "rights_contract_id",
            "rights_window": "rights_window_id",
            "publication": "publication_id",
            "schedule_item": "schedule_item_id",
        },
        pii_tables=(),
    ),
    "sap_sfsf": SchemaConfig(
        system_name="SAP SuccessFactors",
        description=(
            "SAP SuccessFactors Employee Central -- person, employment, job, "
            "position and compensation, plus recruiting. System of record for "
            "athlete identity and workforce planning. Effective-dated throughout. "
            "Extract pattern: API incremental on last_modified_on. TIER B: "
            "abbreviated depth."
        ),
        # SuccessFactors names its watermark last_modified_on.
        touch_column="last_modified_on",
        cdc_tables={
            "per_person": "person_id_external",
            "per_personal": "person_id_external",
            "emp_employment": "user_id",
            "emp_job": "user_id",
            "emp_compensation": "user_id",
            "emp_time_off": "time_off_id",
            "position": "position_code",
        },
        # The whole schema is person data. per_person and its per_* detail
        # tables are the restricted set; emp_compensation is restricted for a
        # different reason -- it is salary.
        pii_tables=(
            "per_person", "per_personal", "per_email", "per_phone", "per_address",
            "emp_compensation", "emp_pay_component", "candidate",
        ),
    ),
    "workday_ap": SchemaConfig(
        system_name="Workday Adaptive Planning",
        description=(
            "Workday Adaptive Planning -- planning cube: versions, accounts, "
            "levels, dimensions, time periods and cell values. System of record "
            "for budget and forward-looking plans. Extract pattern: API snapshot "
            "per version. TIER B: abbreviated depth."
        ),
        # Cell values are deleted routinely -- a planner clearing a row, a
        # dimension member being retired. Since the extract is a snapshot per
        # version rather than a watermark read, the change log matters less
        # here than anywhere else, but it still records the clears.
        cdc_tables={
            "cell_value": "cell_value_id",
            "version": "version_id",
            "account": "account_id",
            "plan": "plan_id",
        },
        pii_tables=(),
    ),
    "archtics": SchemaConfig(
        system_name="Archtics",
        description=(
            "Archtics -- seating manifest, physical seat inventory and "
            "season-ticket administration. Authoritative for seat existence and "
            "capacity; TM/AXS mirrors availability. Extract pattern: CDC log."
        ),
        cdc_tables={
            "building": "building_id",
            "seat": "seat_id",
            "manifest": "manifest_id",
            "event_manifest": "event_manifest_id",
            "sta_account": "sta_account_id",
            "account_seat_assignment": "account_seat_assignment_id",
            "psl": "psl_id",
            "suite_lease": "suite_lease_id",
        },
        pii_tables=(),
    ),
}


def discover_tables(
    schema: str, touch_column: str = "updated_at"
) -> tuple[list[tuple[str, bool]], set[str]]:
    """Return ``[(table, has_watermark_column)]`` plus the set of partition children.

    Partitions are collected separately: a trigger on the partitioned parent
    already covers them, and adding one per child would fire twice.
    """
    ddl_dir = OLTP / schema / "ddl"
    tables: list[tuple[str, bool]] = []
    partitions: set[str] = set()

    for name in SCAN_FILES:
        path = ddl_dir / name
        if not path.exists():
            continue
        sql = path.read_text(encoding="utf-8")

        for match in PARTITION_OF_RE.finditer(sql):
            partitions.add(match.group(2))

        for match in CREATE_TABLE_RE.finditer(sql):
            table = match.group(2)
            # Slice from the opening paren to the matching close, so the
            # watermark test only sees this table's own column list.
            body = _balanced_body(sql, match.end() - 1)
            tables.append((table, touch_column in body))

    return tables, partitions


def _balanced_body(sql: str, open_paren: int) -> str:
    """Extract the text between ``open_paren`` and its matching close paren."""
    depth = 0
    for i in range(open_paren, len(sql)):
        if sql[i] == "(":
            depth += 1
        elif sql[i] == ")":
            depth -= 1
            if depth == 0:
                return sql[open_paren + 1 : i]
    return sql[open_paren:]


def render(schema: str, cfg: SchemaConfig) -> str:
    tables, partitions = discover_tables(schema, cfg.touch_column)
    touchable = [t for t, has_ts in tables if has_ts and t not in partitions]

    # Schemas on the default column share common.touch_updated_at(); the others
    # get a schema-local function, because the column name is baked into it.
    if cfg.touch_column == "updated_at":
        touch_fn = "common.touch_updated_at()"
    else:
        touch_fn = f"{schema}.touch_{cfg.touch_column}()"

    out: list[str] = []
    w = out.append

    w("-- =========================================================================")
    w(f"-- {schema} -- audit and change capture")
    w("--")
    w("-- GENERATED by tools/gen_audit.py. Do not edit by hand; edit the generator.")
    w("--")
    w("-- Three things live here:")
    w("--")
    w("--   1. updated_at triggers, so the incremental-extraction watermark is")
    w("--      maintained by the database rather than trusted to the application.")
    w("--      An application-maintained timestamp is missed on exactly the UPDATE")
    w("--      paths nobody remembers.")
    w("--")
    w("--   2. A change log, which is what makes CDC extraction modelable. A")
    w("--      high-water-mark read of updated_at cannot observe a deleted row --")
    w("--      the row is simply gone -- so deletes are recorded with their prior")
    w("--      contents for the lakehouse to tombstone.")
    w("--")
    w("--   3. Role grants, including the REVOKEs that make the PII satellite split")
    w("--      an access control rather than merely a layout.")
    w("-- =========================================================================")
    w("")
    w("-- -------------------------------------------------------------------------")
    w(f"-- {cfg.touch_column} maintenance: {len(touchable)} tables.")
    if cfg.touch_column == "updated_at":
        w("-- common.touch_updated_at() is shared by every schema using the default")
        w("-- watermark column name.")
    else:
        w(f"-- This system names its watermark {cfg.touch_column} rather than updated_at,")
        w("-- so it needs its own trigger function. The name is not cosmetic: the")
        w("-- extract replicates on this column, and on no other.")
    w("-- -------------------------------------------------------------------------")
    if cfg.touch_column != "updated_at":
        w(f"CREATE OR REPLACE FUNCTION {schema}.touch_{cfg.touch_column}()")
        w("RETURNS trigger")
        w("LANGUAGE plpgsql")
        w("AS $$")
        w("BEGIN")
        w(f"    NEW.{cfg.touch_column} := now();")
        w("    RETURN NEW;")
        w("END;")
        w("$$;")
        w("")
    for table in touchable:
        # Trigger names are capped at 63 bytes like any PostgreSQL identifier.
        w(f"CREATE TRIGGER trg_{table}_touch BEFORE UPDATE ON {schema}.{table}")
        w(f"    FOR EACH ROW EXECUTE FUNCTION {touch_fn};")
    w("")

    if cfg.append_only:
        listed = ", ".join(f"{schema}.{t}" for t in cfg.append_only)
        w(f"-- {listed}")
        w(f"-- are append-only and carry no {cfg.touch_column}, so they take no trigger.")
        w("")

    if partitions:
        w(f"-- {len(partitions)} partition children take no trigger of their own: a trigger on")
        w("-- the partitioned parent already fires for rows routed into them.")
        w("")

    w("-- -------------------------------------------------------------------------")
    w("-- Change log.")
    w("-- -------------------------------------------------------------------------")
    w(f"CREATE TABLE {schema}._change_log (")
    w("    change_log_id   BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,")
    w("    table_name      VARCHAR(63)  NOT NULL,")
    w("    operation       CHAR(1)      NOT NULL CHECK (operation IN ('I', 'U', 'D')),")
    w("    -- Text, not BIGINT: one log serves tables keyed by integer, bigint and")
    w("    -- composite business keys alike.")
    w("    row_key         VARCHAR(200) NOT NULL,")
    w("    changed_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),")
    w("    changed_by      TEXT         NOT NULL DEFAULT current_user,")
    w("    -- Populated on delete only. Inserts and updates leave it null because")
    w("    -- the current row remains readable in the base table, and copying it")
    w("    -- would double the write volume of the busiest tables.")
    w("    old_row         JSONB")
    w(");")
    w("")
    w(f"CREATE INDEX ix_{schema}_change_log_changed_at")
    w(f"    ON {schema}._change_log (changed_at);")
    w(f"CREATE INDEX ix_{schema}_change_log_table")
    w(f"    ON {schema}._change_log (table_name, changed_at);")
    w("")
    w(f"COMMENT ON TABLE {schema}._change_log IS")
    w("    'Change capture for incremental extraction. Deletes are the reason this '")
    w("    'exists: a high-water-mark read of updated_at cannot see a removed row.';")
    w("")
    w(f"CREATE OR REPLACE FUNCTION {schema}.log_change()")
    w("RETURNS trigger")
    w("LANGUAGE plpgsql")
    w("AS $$")
    w("DECLARE")
    w("    -- TG_ARGV[0] names the key column, so one function serves every table.")
    w("    key_column TEXT := TG_ARGV[0];")
    w("    source_row JSONB;")
    w("BEGIN")
    w("    source_row := to_jsonb(COALESCE(OLD, NEW));")
    w("")
    w(f"    INSERT INTO {schema}._change_log (table_name, operation, row_key, old_row)")
    w("    VALUES (")
    w("        TG_TABLE_NAME,")
    w("        CASE TG_OP WHEN 'INSERT' THEN 'I' WHEN 'UPDATE' THEN 'U' ELSE 'D' END,")
    w("        COALESCE(source_row ->> key_column, '(unknown)'),")
    w("        CASE WHEN TG_OP = 'DELETE' THEN source_row ELSE NULL END")
    w("    );")
    w("")
    w("    RETURN COALESCE(NEW, OLD);")
    w("END;")
    w("$$;")
    w("")
    w(f"COMMENT ON FUNCTION {schema}.log_change() IS")
    w("    'Generic change logger. Pass the key column name as the trigger argument.';")
    w("")

    if cfg.cdc_tables:
        w("-- Applied to the master and financial tables, where a missed delete would")
        w("-- leave an orphan in the target model. Deliberately not applied to")
        w("-- append-only high-volume tables: the write volume would double for no")
        w("-- benefit, since nothing ever deletes from them.")
        for table, key in cfg.cdc_tables.items():
            w(f"CREATE TRIGGER trg_{table}_change")
            w(f"    AFTER INSERT OR UPDATE OR DELETE ON {schema}.{table}")
            w(f"    FOR EACH ROW EXECUTE FUNCTION {schema}.log_change('{key}');")
        w("")

    w("-- -------------------------------------------------------------------------")
    w("-- Role separation.")
    w("--")
    w("-- The roles are created defensively because every schema grants to the same")
    w("-- three and the load order across schemas is not guaranteed.")
    w("-- -------------------------------------------------------------------------")
    w("DO $$")
    w("BEGIN")
    w("    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'offball_app') THEN")
    w("        CREATE ROLE offball_app NOLOGIN;")
    w("    END IF;")
    w("    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'offball_analyst') THEN")
    w("        CREATE ROLE offball_analyst NOLOGIN;")
    w("    END IF;")
    w("    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'offball_ingest') THEN")
    w("        CREATE ROLE offball_ingest NOLOGIN;")
    w("    END IF;")
    w("END;")
    w("$$;")
    w("")
    w(f"GRANT USAGE ON SCHEMA {schema} TO offball_app, offball_analyst, offball_ingest;")
    w("")
    w("-- The application needs everything.")
    w(f"GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA {schema}")
    w("    TO offball_app;")
    w("")
    w("-- Analysts and the ingestion job read.")
    w(f"GRANT SELECT ON ALL TABLES IN SCHEMA {schema}")
    w("    TO offball_analyst, offball_ingest;")

    if cfg.pii_tables:
        w("")
        w("-- The satellite split only means something if the grants differ. The")
        w("-- ingestion role keeps access because the target model rejoins these")
        w("-- columns; the analyst role does not.")
        for table in cfg.pii_tables:
            w(f"REVOKE SELECT ON {schema}.{table} FROM offball_analyst;")

    w("")
    w(f"COMMENT ON SCHEMA {schema} IS")
    for line in _sql_string_lines(cfg.description):
        w(f"    {line}")
    w("")

    return "\n".join(out)


def _sql_string_lines(text: str, width: int = 68) -> list[str]:
    """Wrap text into adjacent single-quoted SQL string literals."""
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        candidate = f"{current} {word}".strip()
        if len(candidate) > width and current:
            lines.append(f"'{current} '")
            current = word
        else:
            current = candidate
    if current:
        lines.append(f"'{current}'")
    lines[-1] = lines[-1] + ";"
    return lines


def main(argv: list[str] | None = None) -> int:
    """Entry point. Takes schema names, or regenerates every configured schema."""
    args = list(sys.argv[1:] if argv is None else argv)
    requested = args or sorted(CONFIG)
    unknown = [s for s in requested if s not in CONFIG]
    if unknown:
        print(f"no audit config for: {', '.join(unknown)}", file=sys.stderr)
        return 1

    for schema in requested:
        ddl_dir = OLTP / schema / "ddl"
        if not ddl_dir.is_dir():
            print(f"  skip {schema}: no ddl directory", file=sys.stderr)
            continue
        sql = render(schema, CONFIG[schema])
        target = ddl_dir / "70_audit.sql"
        # newline="" so the file is LF on every platform, matching
        # .gitattributes and the other generators.
        target.write_text(sql, encoding="utf-8", newline="")
        tables, partitions = discover_tables(schema, CONFIG[schema].touch_column)
        touch_count = sum(
            1 for t, has in tables if has and t not in partitions
        )
        print(
            f"  {schema:<12} {target.relative_to(ROOT).as_posix():<36} "
            f"{touch_count:>3} touch triggers, "
            f"{len(CONFIG[schema].cdc_tables):>2} cdc, "
            f"{len(CONFIG[schema].pii_tables):>2} pii"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
