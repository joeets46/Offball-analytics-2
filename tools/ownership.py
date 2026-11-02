"""Curated source-system ownership for every in-scope MVM table.

This is the contract between the two tiers. For each of the 153 in-scope MVM
tables it records the owning system of record, the native source tables that
feed it, how the grain changes, and how much to trust the assignment.

Assignments start from the measured ``system_affinity`` in
``tools/derived/mvm_tables.csv`` (how often each system is named in a table's
own column metadata) and are then reviewed by hand. 14 tables carry no
affinity signal at all -- almost all of them reference or associative tables
whose owner is obvious from context -- and are assigned here explicitly.

``check_mapping`` asserts that every ``src`` table named below actually exists
in the generated DDL, so this file cannot drift from ``oltp/``.

Row shape: ``[mvm_table, system, src, transform, confidence, note?]``

transform
    ``1:1`` | ``join`` | ``union`` | ``pivot`` | ``derive`` | ``scd2``

confidence
    ``high``   -- strong affinity, unambiguous owner.
    ``medium`` -- plausible owner, some attributes come from elsewhere.
    ``low``    -- no real system of record; the owner models only part of the
    concept. Called out in ``mapping/lineage.md``.
"""

from __future__ import annotations

from dataclasses import dataclass

OWNERSHIP: dict[str, list[list]] = {
  # -------------------------------------------------------------------------
  # event -- the fixture is the anchor entity the whole model hangs off.
  # -------------------------------------------------------------------------
  "event": [
    ['fixture', 'tm_axs', ['event', 'event_type', 'venue_ref'], 'join', 'high',
      'TM/AXS event is the operational event record; Archtics event_manifest and Hudl game contribute actuals'],
    ['calendar', 'tm_axs', ['season', 'event_group'], 'join', 'medium',
      'Season/programming cycle; SAP t009b fiscal periods align the finance view'],
    ['tournament', 'tm_axs', ['event_group'], '1:1', 'low',
      'TM/AXS models tournaments only as event groupings, not as competition structures'],
    ['bracket', 'tm_axs', ['event_group'], 'derive', 'low',
      'No system of record for bracket topology; derived from event_group nesting'],
    ['competition_round', 'tm_axs', ['event_group', 'event'], 'derive', 'low',
      'Round/matchday is an event_group level in TM/AXS, not a first-class entity'],
    ['broadcast_window', 'dalet', ['schedule_item', 'channel'], 'join', 'high'],
    ['type', 'tm_axs', ['event_type'], '1:1', 'medium', 'Reference data; TM/AXS event_type is the configured list'],
    ['match_result', 'hudl', ['game', 'game_participant'], 'join', 'high'],
    ['scoring_event', 'hudl', ['instance', 'instance_label', 'timeline'], 'join', 'high',
      'A scoring event is a coded instance on the game timeline'],
    ['production_schedule', 'dalet', ['job', 'job_task', 'running_order'], 'join', 'high'],
    ['participant', 'hudl', ['game_participant', 'player', 'team'], 'join', 'medium',
      'Non-athlete participants (performers, officials) have no named source'],
    ['officiating_assignment', 'sap_sfsf', ['emp_employment', 'emp_job', 'position'], 'join', 'low',
      'Officials are contractors in SuccessFactors; the assignment itself has no named source'],
    ['event_incident', 'tm_axs', ['security_incident', 'event_day_log'], 'union', 'medium'],
    ['venue_assignment', 'archtics', ['event_manifest', 'building'], 'join', 'high'],
  ],

  # -------------------------------------------------------------------------
  # venue -- Archtics owns the seating manifest; SAP owns the physical plant.
  # -------------------------------------------------------------------------
  "venue": [
    ['venue', 'archtics', ['building'], '1:1', 'high',
      'SAP t001w plant and TM/AXS venue_ref carry duplicate venue records; Archtics building is authoritative for seating'],
    ['facility', 'sap_s4', ['t001w', 'anla'], 'join', 'medium'],
    ['seating_section', 'archtics', ['section', 'level'], 'join', 'high'],
    ['seat', 'archtics', ['seat', 'seat_row', 'seat_attribute_assignment'], 'join', 'high'],
    ['capacity_config', 'archtics', ['manifest', 'manifest_section'], 'join', 'high'],
    ['config_section_allocation', 'archtics', ['manifest_section'], '1:1', 'high'],
    ['parking_lot', 'archtics', ['parking_lot'], '1:1', 'high'],
    ['parking_activation', 'archtics', ['parking_activation', 'parking_inventory'], 'join', 'medium',
      'No affinity signal; Archtics owns parking inventory so activation per event sits there'],
    ['concession_stand', 'sap_s4', ['t001w', 'mara'], 'join', 'medium'],
    ['suite', 'archtics', ['suite', 'suite_lease'], 'join', 'high',
      'SAP veda carries the lease financials; Archtics owns the physical suite'],
    ['accessibility_feature', 'archtics', ['accessibility_feature', 'seat_attribute'], 'join', 'medium'],
    ['maintenance_work_order', 'sap_s4', ['aufk', 'afih', 'qmel'], 'join', 'high',
      'SAP PM: order master, maintenance header, notification'],
    ['safety_incident', 'tm_axs', ['security_incident'], '1:1', 'low',
      'Venue safety incidents overlap the TM/AXS security incident log; no EHS system named'],
    ['event_day_ops', 'tm_axs', ['event_day_log'], '1:1', 'medium'],
    ['staff_plan', 'sap_sfsf', ['position', 'emp_job', 'fo_department'], 'join', 'high'],
  ],

  # -------------------------------------------------------------------------
  # athlete -- SuccessFactors holds the person, SAP holds the money.
  # -------------------------------------------------------------------------
  "athlete": [
    ['athlete_profile', 'sap_sfsf', ['per_person', 'per_personal', 'per_address', 'per_email', 'per_phone'], 'join', 'high',
      'Hudl player carries the performance identity and must be reconciled on external_player_id'],
    ['roster', 'sap_sfsf', ['emp_employment', 'emp_job', 'position'], 'join', 'medium',
      'Hudl team membership is the operational roster; SuccessFactors is the employment record'],
    ['contract', 'sap_s4', ['veda', 'vbak'], 'join', 'high',
      'SAP contract data + SuccessFactors emp_compensation for pay components'],
    ['nil_agreement', 'sap_s4', ['veda', 'lfa1'], 'join', 'high'],
    ['agent_relationship', 'sfdc_crm', ['account_contact_relation', 'contact'], 'join', 'high'],
    ['agent', 'sfdc_crm', ['contact'], '1:1', 'medium',
      'No affinity signal; agents are Salesforce Contacts under an agency Account'],
    ['agency', 'sfdc_crm', ['account'], '1:1', 'medium',
      'No affinity signal; agencies are Salesforce Accounts with a record type'],
    ['salary_cap_entry', 'workday_ap', ['cell_value', 'account', 'dimension_value'], 'join', 'medium',
      'Cap accounting is planning data in Adaptive, not a transactional ledger'],
    ['draft_selection', 'sap_sfsf', ['job_application', 'candidate', 'job_requisition'], 'join', 'low',
      'Draft is modeled as recruiting in SuccessFactors; the pick order has no named source'],
    ['eligibility_status', 'sap_sfsf', ['emp_employment'], 'derive', 'low',
      'Derived from employment status; no eligibility system named'],
    ['free_agency_status', 'sap_s4', ['veda'], 'derive', 'medium',
      'Derived from contract expiry dates in SAP contract data'],
    ['suspension_record', 'sap_sfsf', ['emp_time_off', 'emp_employment'], 'join', 'low',
      'Suspensions appear as unpaid leave; the disciplinary origin is out of scope'],
    ['performance_stat', 'hudl', ['player_game_metric', 'metric_definition', 'game'], 'join', 'high'],
    ['injury_record', 'hudl', ['injury_note', 'wearable_session'], 'join', 'medium',
      'Hudl carries availability notes; clinical records would need an EMR, which is not named'],
  ],

  # -------------------------------------------------------------------------
  # fan -- Salesforce owns the known customer, AEP owns behaviour and identity.
  # -------------------------------------------------------------------------
  "fan": [
    ['fan_profile', 'adobe_aep', ['profile', 'identity', 'identity_map'], 'join', 'high',
      'AEP is the identity resolution point across Salesforce, TM/AXS and Shopify customers'],
    ['account', 'sfdc_crm', ['account', 'contact'], 'join', 'high'],
    ['segment', 'adobe_aep', ['segment_definition', 'audience'], 'join', 'high'],
    ['segment_assignment', 'adobe_aep', ['segment_membership'], '1:1', 'high'],
    ['consent_preference', 'adobe_aep', ['consent_record', 'consent_policy'], 'join', 'high'],
    ['payment_method', 'tm_axs', ['payment_method'], 'union', 'medium',
      'Tokenized cards exist separately in TM/AXS and Shopify; union then dedupe on token'],
    ['loyalty_program', 'sfdc_crm', ['product2', 'pricebook_entry'], 'join', 'medium',
      'Loyalty programs are configured as Salesforce products'],
    ['loyalty_enrollment', 'sfdc_crm', ['contract', 'contract_line_item'], 'join', 'medium'],
    ['loyalty_transaction', 'sfdc_crm', ['sales_order', 'sales_order_item'], 'join', 'medium',
      'Point accrual and redemption as Salesforce order lines'],
    ['membership', 'archtics', ['sta_account', 'plan', 'renewal'], 'join', 'medium',
      'Season-ticket membership; SAP carries the billing side'],
    ['club', 'sfdc_crm', ['account', 'product2'], 'join', 'medium'],
    ['club_membership', 'sfdc_crm', ['account_contact_relation'], '1:1', 'low',
      'Minimal affinity signal; modeled as a Salesforce account-contact relation'],
    ['campaign', 'sfdc_crm', ['campaign'], '1:1', 'medium',
      'No affinity signal; Salesforce Campaign with AEP journey as the execution layer'],
    ['engagement_event', 'adobe_aep', ['experience_event', 'event_type_ref'], 'join', 'high',
      'Highest-volume table in the model; partitioned by event timestamp'],
    ['communication', 'adobe_aep', ['journey', 'journey_step', 'journey_step_event'], 'join', 'high',
      'Salesforce task/activity covers human-initiated outbound'],
    ['service_case', 'sfdc_crm', ['service_case', 'service_case_comment', 'task'], 'join', 'high'],
  ],

  # -------------------------------------------------------------------------
  # ticketing -- the cleanest lineage in the model. TM/AXS sells, Archtics
  # holds the inventory those sales consume.
  # -------------------------------------------------------------------------
  "ticketing": [
    ['ticket_inventory', 'archtics', ['event_manifest', 'manifest_section', 'seat'], 'join', 'high',
      'Archtics holds the per-event manifest; TM/AXS ticket_inventory mirrors availability'],
    ['price_tier', 'tm_axs', ['price_scale', 'price_level'], 'join', 'high'],
    ['price_zone', 'tm_axs', ['price_zone'], '1:1', 'medium'],
    ['hold_allocation', 'tm_axs', ['inventory_hold', 'hold_code'], 'join', 'high'],
    ['season_ticket_package', 'archtics', ['plan', 'plan_seat'], 'join', 'high'],
    ['season_ticket_account', 'archtics', ['sta_account', 'account_seat_assignment', 'psl'], 'join', 'high'],
    ['group_sale', 'tm_axs', ['group_sale', 'sales_order'], 'join', 'high'],
    ['ticket_order', 'tm_axs', ['sales_order', 'customer_account'], 'join', 'high'],
    ['ticket_order_line', 'tm_axs', ['order_line', 'ticket'], 'join', 'high'],
    ['resale', 'tm_axs', ['resale_listing', 'resale_transaction'], 'join', 'high'],
    ['ticket_payment', 'tm_axs', ['payment', 'payment_transaction'], 'join', 'high',
      'SAP bsid/vbrk carry the posted revenue; TM/AXS is the capture point'],
    ['refund', 'tm_axs', ['refund', 'payment_transaction'], 'join', 'high'],
    ['access_entitlement', 'tm_axs', ['ticket', 'barcode', 'delivery'], 'join', 'high'],
    ['gate_scan', 'tm_axs', ['scan', 'access_point'], 'join', 'high',
      'Highest-volume ticketing table; partitioned by scan timestamp'],
    ['ticket_transfer', 'tm_axs', ['ticket_transfer', 'ticket'], 'join', 'high'],
  ],

  # -------------------------------------------------------------------------
  # broadcast -- Dalet runs production; rights deals live as CRM contracts.
  # -------------------------------------------------------------------------
  "broadcast": [
    ['media_rights_deal', 'sfdc_crm', ['contract', 'contract_line_item', 'account'], 'join', 'high',
      'Dalet rights_contract holds the operational windows; Salesforce holds the commercial deal'],
    ['rights_window', 'dalet', ['rights_window', 'rights_contract'], 'join', 'high'],
    ['rights_holder', 'sfdc_crm', ['account'], '1:1', 'medium',
      'No affinity signal; counterparties are Salesforce Accounts'],
    ['licensee', 'sfdc_crm', ['account'], '1:1', 'medium',
      'No affinity signal; counterparties are Salesforce Accounts'],
    ['blackout_rule', 'dalet', ['rights_window', 'publication_target'], 'derive', 'medium'],
    ['broadcast_schedule', 'dalet', ['schedule_item', 'running_order', 'channel'], 'join', 'high'],
    ['channel', 'dalet', ['channel'], '1:1', 'high'],
    ['live_feed', 'dalet', ['feed', 'essence'], 'join', 'high'],
    ['production', 'dalet', ['job', 'job_task'], 'join', 'high'],
    ['media_asset', 'dalet', ['media_object', 'essence'], 'join', 'high',
      'A Dalet title is a column on media_object here, not a separate entity; essence carries the renditions the target model collapses'],
    ['audience_rating', 'adobe_aep', ['experience_event', 'dataset'], 'derive', 'low',
      'Panel ratings come from Nielsen-style providers; AEP only has owned-platform viewing'],
    ['streaming_subscription', 'sfdc_crm', ['contract', 'sales_order', 'sales_order_item'], 'join', 'medium',
      'AEP profile carries entitlement state; Salesforce carries the subscription contract'],
  ],

  # -------------------------------------------------------------------------
  # sponsorship -- Salesforce sells it, SAP bills it.
  # -------------------------------------------------------------------------
  "sponsorship": [
    ['sponsor', 'sfdc_crm', ['account'], '1:1', 'high'],
    ['deal', 'sfdc_crm', ['opportunity', 'contract'], 'join', 'high'],
    ['deal_term', 'sfdc_crm', ['contract_line_item', 'opportunity_line_item'], 'join', 'high'],
    ['naming_right', 'sfdc_crm', ['contract', 'contract_line_item'], 'join', 'medium',
      'SAP veda carries the long-dated financial terms'],
    ['payment_schedule', 'sap_s4', ['veda', 'bsid', 'vbrk'], 'join', 'high'],
    ['property', 'sfdc_crm', ['product2'], '1:1', 'medium',
      'No affinity signal; sponsorable properties are Salesforce Products'],
    ['inventory_unit', 'sfdc_crm', ['product2', 'pricebook_entry'], 'join', 'medium',
      'No affinity signal; sellable units are Products with pricebook entries'],
    ['ad_inventory', 'sfdc_crm', ['product2', 'pricebook_entry', 'asset'], 'join', 'medium'],
    ['inventory_allocation', 'sfdc_crm', ['opportunity_line_item', 'asset'], 'join', 'high'],
    ['activation', 'sfdc_crm', ['campaign', 'asset'], 'join', 'high'],
    ['activation_fulfillment', 'sfdc_crm', ['campaign_member', 'task'], 'join', 'high'],
    ['performance_metric', 'sfdc_crm', ['campaign'], 'derive', 'medium',
      'Delivery metrics are rolled up from AEP experience_event and Dalet publication'],
  ],

  # -------------------------------------------------------------------------
  # merchandise -- Shopify is the storefront, SAP is the ledger and the stock.
  # -------------------------------------------------------------------------
  "merchandise": [
    ['sku_catalog', 'shopify', ['product', 'product_variant', 'metafield'], 'join', 'high',
      'SAP mara is the authoritative material master; Shopify is the sellable catalog'],
    ['product_category', 'shopify', ['collection'], '1:1', 'medium'],
    ['inventory_position', 'sap_s4', ['mard', 'marc', 't001l'], 'join', 'high',
      'Shopify inventory_level mirrors a subset for the storefront'],
    ['retail_location', 'shopify', ['location'], '1:1', 'medium',
      'SAP t001w is the plant equivalent for owned stores'],
    ['price_list', 'sap_s4', ['a004', 'konp'], 'join', 'high',
      'SAP pricing conditions; Shopify price_rule covers storefront overrides'],
    ['promotion', 'shopify', ['price_rule', 'discount_code'], 'join', 'high'],
    ['merch_order', 'shopify', ['sales_order', 'customer', 'customer_address'], 'join', 'high'],
    ['order_line', 'shopify', ['line_item', 'discount_application'], 'join', 'high'],
    ['fulfillment_shipment', 'shopify', ['fulfillment', 'fulfillment_line_item', 'shipping_line'], 'join', 'high'],
    ['return_request', 'shopify', ['return_request', 'return_line_item', 'refund'], 'join', 'high'],
    ['supplier', 'sap_s4', ['lfa1', 'lfb1'], 'join', 'high'],
    ['supplier_category_authorization', 'sap_s4', ['lfa1', 'mara'], 'derive', 'low',
      'Minimal signal; derived from vendor material groups'],
    ['licensing_agreement', 'sap_s4', ['veda', 'lfa1'], 'join', 'high'],
    ['royalty_payment', 'sap_s4', ['rbkp', 'rseg', 'reguh'], 'join', 'high'],
  ],

  # -------------------------------------------------------------------------
  # content -- Dalet Galaxy end to end.
  # -------------------------------------------------------------------------
  "content": [
    ['asset', 'dalet', ['media_object', 'essence', 'metadata_value'], 'join', 'high',
      'Metadata arrives through metadata_value against metadata_field, which is why target content.asset is a three-table join'],
    ['metadata_tag', 'dalet', ['metadata_field', 'vocabulary', 'vocabulary_term'], 'join', 'high'],
    ['category', 'dalet', ['folder'], '1:1', 'medium'],
    ['collection', 'dalet', ['collection'], '1:1', 'high'],
    ['collection_item', 'dalet', ['collection_member'], '1:1', 'medium',
      'No affinity signal; Dalet collection membership'],
    ['asset_tag', 'dalet', ['tag_assignment', 'metadata_value'], 'join', 'medium',
      'No affinity signal; Dalet metadata value assignment'],
    ['production_order', 'dalet', ['job', 'job_task', 'media_object'], 'join', 'high',
      'A production order reserves a placeholder media_object (media_object.is_placeholder) before any essence exists'],
    ['ingest_job', 'dalet', ['job', 'transfer', 'media_object'], 'join', 'high',
      'Ingest fills a placeholder media_object; transfer carries the byte movement'],
    ['publish_event', 'dalet', ['publication', 'publication_target'], 'join', 'high'],
    ['license', 'sap_s4', ['veda'], '1:1', 'medium',
      'Content licences are SAP contracts; Dalet rights_contract mirrors the usable window'],
    ['editorial_brief', 'dalet', ['editorial_brief'], '1:1', 'high'],
    ['platform_channel', 'dalet', ['publication_target', 'channel'], 'join', 'high'],
  ],

  # -------------------------------------------------------------------------
  # league -- structure only. Competitive operations and roster transactions
  # are out of scope; see docs/08-scope-boundary.md.
  # -------------------------------------------------------------------------
  "league": [
    ['league', 'sap_s4', ['t001'], '1:1', 'low',
      'No league system named; the league appears as an SAP company code with a Salesforce Account'],
    ['conference', 'sap_s4', ['cepc'], '1:1', 'low',
      'Modeled as a profit-centre grouping; genuinely a competition structure'],
    ['division', 'sap_s4', ['cepc'], '1:1', 'low',
      'Modeled as a profit-centre grouping; genuinely a competition structure'],
    ['franchise', 'sap_s4', ['t001', 'cepc'], 'join', 'medium',
      'Franchises are real legal entities, so company code + profit centre is a fair fit'],
    ['team', 'sap_s4', ['cepc'], '1:1', 'low',
      'No affinity signal; Hudl team is the operational record but carries no commercial attributes'],
    ['season', 'sap_s4', ['t009', 't009b'], 'join', 'medium',
      'Fiscal year variant and periods; TM/AXS season and Archtics plan align the commercial view'],
  ],

  # -------------------------------------------------------------------------
  # finance -- SAP S/4HANA, with Adaptive Planning for anything forward-looking.
  # -------------------------------------------------------------------------
  "finance": [
    ['company_code', 'sap_s4', ['t001'], '1:1', 'high'],
    ['gl_account', 'sap_s4', ['ska1', 'skb1'], 'join', 'high'],
    ['cost_center', 'sap_s4', ['csks'], '1:1', 'high'],
    ['profit_center', 'sap_s4', ['cepc'], '1:1', 'high'],
    ['fiscal_period', 'sap_s4', ['t009', 't009b'], 'join', 'high',
      'No affinity signal; SAP fiscal year variant and period definitions'],
    ['ledger', 'sap_s4', ['t881'], '1:1', 'high'],
    ['journal_entry', 'sap_s4', ['bkpf', 'bseg', 'faglflexa'], 'join', 'high',
      'Header/line join; the grain of the MVM table is the document line'],
    ['ar_invoice', 'sap_s4', ['vbrk', 'vbrp', 'bsid'], 'join', 'high'],
    ['ap_invoice', 'sap_s4', ['rbkp', 'rseg', 'bsik'], 'join', 'high'],
    ['payment', 'sap_s4', ['reguh', 'regup', 'bkpf'], 'join', 'high'],
    ['payment_run', 'sap_s4', ['reguh'], '1:1', 'high',
      'No affinity signal; SAP automatic payment run header'],
    ['fixed_asset', 'sap_s4', ['anla', 'anlc'], 'join', 'high'],
    ['budget', 'workday_ap', ['model', 'version', 'cell_value', 'account', 'time_period'], 'join', 'high',
      'SAP bpja holds the posted budget; Adaptive holds the plan it came from'],
    ['revenue_recognition_schedule', 'sap_s4', ['veda', 'vbrk', 'bkpf'], 'join', 'medium'],
  ],

  # -------------------------------------------------------------------------
  # compliance -- one surviving table; the rest is out of scope.
  # -------------------------------------------------------------------------
  "compliance": [
    ['data_processing_record', 'adobe_aep', ['data_use_label', 'consent_policy', 'dataset', 'privacy_job'], 'join', 'medium',
      'AEP data governance labels are the only named source for processing records'],
  ],

  # -------------------------------------------------------------------------
  # security -- access control via the ticketing stack. Emergency management
  # is out of scope.
  # -------------------------------------------------------------------------
  "security": [
    ['credential', 'tm_axs', ['credential'], '1:1', 'high'],
    ['credential_assignment', 'tm_axs', ['credential_assignment'], '1:1', 'medium'],
    ['access_zone', 'tm_axs', ['access_zone', 'access_point'], 'join', 'high'],
    ['access_event', 'tm_axs', ['scan', 'access_point'], 'join', 'high',
      'Same physical scan stream as ticketing.gate_scan, filtered to credentialed access'],
    ['screening_checkpoint', 'tm_axs', ['screening_checkpoint', 'access_point'], 'join', 'medium'],
    ['screening_event', 'tm_axs', ['screening_event'], '1:1', 'medium'],
    ['security_incident', 'tm_axs', ['security_incident'], '1:1', 'high'],
    ['ejection_record', 'tm_axs', ['ejection', 'security_incident'], 'join', 'high'],
  ],
};

@dataclass(frozen=True)
class OwnershipRow:
    """One in-scope MVM table and where it comes from."""

    domain: str
    table: str
    system: str
    src: tuple[str, ...]
    transform: str
    confidence: str
    note: str = ""

    @property
    def qualified_src(self) -> tuple[str, ...]:
        """Source tables as ``schema.table``, which is how the mapping prints them."""
        return tuple(f"{self.system}.{t}" for t in self.src)


def ownership_rows() -> list[OwnershipRow]:
    """Flatten OWNERSHIP into rows, for CSV generation and assertions."""
    rows: list[OwnershipRow] = []
    for domain, entries in OWNERSHIP.items():
        for entry in entries:
            table, system, src, transform, confidence = entry[:5]
            note = entry[5] if len(entry) > 5 else ""
            rows.append(
                OwnershipRow(
                    domain=domain,
                    table=table,
                    system=system,
                    src=tuple(src),
                    transform=transform,
                    confidence=confidence,
                    note=note,
                )
            )
    return rows
