-- =========================================================================
-- sfdc_crm -- Salesforce CRM
--
-- Named in the upstream model as "Salesforce CRM (Fan and Sponsor
-- Relationship Management)".
--
-- Owns 26 of the 153 in-scope MVM tables: the known-customer side of `fan`,
-- all of `sponsorship` deal management, the commercial side of broadcast
-- rights, and the agent/agency records in `athlete`.
--
-- Native idiom modeled here:
--   * CHAR(18) record IDs. A Salesforce ID is 15 case-sensitive characters
--     plus a 3-character checksum suffix; both forms circulate, and mixing
--     them is a standing integration bug. Fixed-width CHAR, not an integer.
--   * The audit quintet on every object: CreatedDate, CreatedById,
--     LastModifiedDate, LastModifiedById, SystemModstamp. SystemModstamp is
--     the one that matters -- it moves on system-driven changes that leave
--     LastModifiedDate alone, and it is what the Replication API watermarks on.
--   * IsDeleted, not deletion. Records go to the Recycle Bin for 15 days and
--     remain queryable. An extract that ignores IsDeleted loads records the
--     business considers gone.
--   * RecordTypeId. One object serves several business entities, distinguished
--     only by record type -- which is exactly how one `account` table becomes
--     target sponsorship.sponsor, athlete.agency, broadcast.rights_holder and
--     broadcast.licensee.
--   * Custom fields carry the __c suffix, as they do in a real org. Keeping
--     the suffix makes it obvious which attributes are configuration rather
--     than part of the platform.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS sfdc_crm;

COMMENT ON SCHEMA sfdc_crm IS
    'Salesforce CRM -- accounts, contacts, opportunities, contracts, campaigns '
    'and cases. System of record for fan identity, sponsorship deals and '
    'commercial counterparties. Extract pattern: API incremental on '
    'SystemModstamp, with IsDeleted filtered.';
