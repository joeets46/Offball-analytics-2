"""Tooling for the OFF-Ball source OLTP data models.

Everything in this package derives from one input: the upstream Databricks
Sports Entertainment MVM ``model.json``, vendored at ``source/mvm/``. Nothing
here invents facts about the target model -- it reads them.

Module map, in the order they depend on each other:

``scope``
    The scope boundary. Which of the 200 upstream tables are in scope, the ten
    named systems of record, and the classification helpers. Single source of
    truth, imported by everything else.

``ownership``
    The curated map from each in-scope MVM table to its owning system and the
    native source tables that feed it. The contract between the two tiers.

``extract_model``
    Walks the upstream model and writes the derived CSVs that the DDL and docs
    are written against.

``build_common_ddl``
    Generates ``models/physical/sql/01_common.sql`` -- the shared DOMAIN types, the
    source-system registry and the identity resolution tables.

``build_mapping``
    Generates the source-to-target mapping CSVs.

``gen_audit``
    Generates each schema's ``70_audit.sql``.

``ddl_introspect``
    Parses the generated DDL back out, so tooling can check itself against
    what actually exists rather than against what was intended.

``check_mapping``
    Completeness assertions tying the mapping, the scope boundary and the DDL
    together.

``build_dictionary``
    Produces the data dictionary from a loaded database.

``build_column_mapping``
    Scaffolds the column-level mapping for the key target tables.
"""

__all__ = [
    "scope",
    "ownership",
    "extract_model",
    "build_common_ddl",
    "build_mapping",
    "gen_audit",
    "ddl_introspect",
    "check_mapping",
    "build_dictionary",
    "build_column_mapping",
    "gen_schema_readme",
]
