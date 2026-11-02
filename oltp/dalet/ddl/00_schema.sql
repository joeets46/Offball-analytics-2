-- =========================================================================
-- dalet -- Dalet Galaxy
--
-- Named in the upstream model as "Dalet Galaxy (Media Asset Management and
-- Broadcast Workflow)".
--
-- Owns 20 of the 153 in-scope MVM tables -- all 12 of `content` plus the
-- production and scheduling half of `broadcast`. Second only to SAP in
-- breadth.
--
-- Native idiom modeled here:
--   * The media_object / essence split. A media object is the editorial
--     thing -- "Match Highlights, Round 12" -- and an essence is one physical
--     rendition of it: the 4K master, the 1080p proxy, the social cutdown.
--     One object has many essences. Target content.asset and
--     broadcast.media_asset are both the object, so the renditions collapse
--     and storage reporting becomes impossible downstream.
--   * The placeholder. A media object is created BEFORE any media exists --
--     the production order reserves it, the camera fills it later. A
--     placeholder with no essence is a normal, intended state, not a broken
--     row.
--   * Metadata as field/value pairs against a controlled vocabulary, not as
--     columns. Broadcasters extend their metadata model constantly, and a MAM
--     that required a schema change per field would be unusable.
--   * Rights windows as time ranges per territory and platform. A right is
--     never global and never permanent, and the overlap rules are where
--     compliance lives.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS dalet;

COMMENT ON SCHEMA dalet IS
    'Dalet Galaxy -- media asset management, metadata, production workflow, '
    'rights windows and broadcast scheduling. System of record for content.* '
    'and broadcast production. Extract pattern: CDC log.';
