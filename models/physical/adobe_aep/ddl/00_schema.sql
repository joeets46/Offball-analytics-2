-- =========================================================================
-- adobe_aep -- Adobe Experience Platform
--
-- Named in the upstream model as "Adobe Experience Platform (Fan Engagement;
-- Personalization; Analytics)".
--
-- Owns 8 of the 153 in-scope MVM tables, but two of them --
-- fan.engagement_event and fan.communication -- are the highest-volume tables
-- in the entire target model. AEP is also the identity resolution point: it is
-- where the TM/AXS customer, the Salesforce contact, the Shopify customer and
-- the Archtics season-ticket account become one person.
--
-- Native idiom modeled here:
--   * XDM. Adobe's schema language is a JSON structure, not a relational one.
--     Experience events carry a deep, sparsely-populated XDM payload, and
--     flattening it into columns would be a lie about the source. The stable
--     fields are columns; the rest is JSONB.
--   * Namespaced identities. A profile has no single key -- it has a map of
--     (namespace, id) pairs: ECID, email, CRMID, phone, loyalty number. The
--     target fan.fan_profile has one BIGINT, so the collapse happens here.
--   * Identity graph links, which are pairwise and probabilistic. Two
--     identities are linked with a confidence, and links are revocable. The
--     target model has no concept of a disputed identity.
--   * Segment membership as a status, not a boolean: realized, existing,
--     exiting. A fan leaving a segment is a distinct state, and it is the one
--     marketing acts on.
--   * Experience events are append-only, immutable and time-partitioned. They
--     are never updated, which is why they carry no watermark column at all.
-- =========================================================================

CREATE SCHEMA IF NOT EXISTS adobe_aep;

COMMENT ON SCHEMA adobe_aep IS
    'Adobe Experience Platform -- unified profile, identity graph, experience '
    'events, segments, consent and journeys. System of record for fan '
    'behaviour and the identity resolution point across the other systems. '
    'Extract pattern: event stream for experience events, API for profile and '
    'segment state.';
