-- =========================================================================
-- common -- table comments
--
-- Separate from 01_common.sql because that file is generated. This one is
-- hand-written and loads after it.
-- =========================================================================

COMMENT ON TABLE common.source_system IS
    'Registry of the ten operational systems of record. The target model constrains its own source_system_code to five values while naming ten systems, so this table is the full list.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE common.entity_xref IS
    'Maps each system-local key to the canonical surrogate the lakehouse will use. The mechanism that replaces 1,397 cross-domain foreign keys the source tier cannot enforce.';
