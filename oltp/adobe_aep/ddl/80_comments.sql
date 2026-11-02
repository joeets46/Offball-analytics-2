-- =========================================================================
-- adobe_aep -- table comments
-- =========================================================================

COMMENT ON TABLE adobe_aep.dataset IS
    'Where ingested data lands, and the unit of governance. Record datasets hold profile attributes; time-series datasets hold experience events, and the distinction governs retention and merge behaviour.';
COMMENT ON TABLE adobe_aep.event_type_ref IS
    'The XDM eventType vocabulary. Feeds the type dimension of target fan.engagement_event; the conversion flag is what attribution counts.';
COMMENT ON TABLE adobe_aep.data_use_label IS
    'Data-use labels and the lawful basis each asserts. With dataset and privacy_job, the only named source for target compliance.data_processing_record.';
COMMENT ON TABLE adobe_aep.identity_graph_link IS
    'Pairwise, revocable, probabilistic links between identities. The target model has no concept of a disputed identity, so a mis-merge is invisible downstream.';
COMMENT ON TABLE adobe_aep.identity_map IS
    'Which identities belong to which profile. The table that would let the lakehouse explain why two orders from different systems belong to the same fan.';
COMMENT ON TABLE adobe_aep.consent_record IS
    'Consent state per profile and policy, with provenance. Three states rather than two: not-asked is distinct from declined, and conflating them is the commonest consent bug.';
COMMENT ON TABLE adobe_aep.audience IS
    'Audiences, whether platform segments or externally imported lists.';
COMMENT ON TABLE adobe_aep.journey IS
    'Orchestration definitions. Feeds nothing directly: target fan.communication is the step event, so which branch a fan took is not reconstructable.';
COMMENT ON TABLE adobe_aep.journey_step IS
    'Steps in a journey graph, including branches. A step sends on a channel only if it is an action step.';
COMMENT ON TABLE adobe_aep.destination IS
    'Activation destinations with the data-use labels they enforce, which is what stops health or special-category data reaching an ad platform.';
COMMENT ON TABLE adobe_aep.destination_activation IS
    'Audience-to-destination activations. A blocked activation is a governance refusal, and the reason is the evidence that policy was enforced.';

-- Table-level descriptions for tables documented so far only at column level.
COMMENT ON TABLE adobe_aep.identity_namespace IS
    'The vocabulary of identity. A person is not identified by one key but by several, each in its own namespace from a different system -- which is what target fan.fan_profile reduces to a single BIGINT.';
COMMENT ON TABLE adobe_aep.profile IS
    'The resolved person. A view over sources that disagree, where the merge policy rather than the data decides which value wins.';
COMMENT ON TABLE adobe_aep.consent_policy IS
    'What a marketing action requires. GDPR default-deny and CCPA default-allow are genuinely different, and a boolean consent column cannot express the difference.';
COMMENT ON TABLE adobe_aep.segment_definition IS
    'Segment rules in Adobe query language. The rule is the definition; the target model keeps only a name, so what a segment means is not recoverable downstream.';
COMMENT ON TABLE adobe_aep.segment_membership IS
    'Membership with a status rather than a flag. Exiting is the actionable state -- a fan who has just dropped out is the one worth calling -- and it has no target equivalent.';
COMMENT ON TABLE adobe_aep.journey_step_event IS
    'One person reaching one journey step. Append-only and partitioned; the suppression reason is a compliance record showing an opt-out was honoured.';
