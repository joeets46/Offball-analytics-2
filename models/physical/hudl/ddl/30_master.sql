-- =========================================================================
-- hudl -- organisations, people, competition and the label vocabulary
--
-- Every key is a UUID generated client-side. That is not decoration: analysts
-- code matches offline and sync afterwards, so ids must be mintable without
-- talking to a server.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Organization. The club or federation account.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.organization (
    organization_id     UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(160) NOT NULL,
    short_name          VARCHAR(40),
    sport               VARCHAR(40)  NOT NULL,
    country_code        common.dom_iso3_code,
    -- Business key into the SAP company code that represents the club.
    sap_bukrs           CHAR(4),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON COLUMN hudl.organization.organization_id IS
    'UUID, generated client-side. Analysts code matches offline and sync '
    'later, so identifiers cannot depend on server coordination.';

-- -------------------------------------------------------------------------
-- Team. Feeds target event.participant alongside player.
--
-- Note this is the team as the analysis system knows it, which is a different
-- record from sap_s4.cepc (the profit centre doing duty as league.team).
-- Reconciling the two is what common.entity_xref is for.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.team (
    team_id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id     UUID         NOT NULL,
    name                VARCHAR(160) NOT NULL,
    short_name          VARCHAR(40),
    -- Squad level, because a club's analysis covers first team, academy and
    -- women's teams under one organisation.
    squad_level         VARCHAR(20)  NOT NULL DEFAULT 'first_team'
        CHECK (squad_level IN ('first_team', 'reserves', 'academy', 'under_21',
                               'under_18', 'womens', 'development')),
    gender_category     VARCHAR(20)
        CHECK (gender_category IS NULL OR gender_category IN ('mens', 'womens', 'mixed', 'open')),
    -- Business key to the league structure standing in for a team.
    sap_prctr           CHAR(10),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Player. Feeds target athlete.performance_stat and event.participant.
--
-- Hudl knows the athlete as a performer. SuccessFactors knows the same person
-- as an employee, and that is the authoritative identity record -- so
-- external_person_ref is the reconciliation key, and `athlete` is a canonical
-- entity.
--
-- Deliberately minimal personal data: an analysis platform needs a name, a
-- shirt number and a position, not an address. Modeling more would overstate
-- what the system holds.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.player (
    player_id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id     UUID         NOT NULL,
    display_name        VARCHAR(160) NOT NULL,
    known_as            VARCHAR(80),
    -- Business key into SuccessFactors, which holds the employment record.
    external_person_ref VARCHAR(40),
    primary_position    VARCHAR(40),
    secondary_position  VARCHAR(40),
    dominant_side       VARCHAR(10)
        CHECK (dominant_side IS NULL OR dominant_side IN ('left', 'right', 'both')),
    date_of_birth       DATE,
    height_cm           SMALLINT     CHECK (height_cm IS NULL OR height_cm BETWEEN 100 AND 250),
    -- Weight changes through a season and is measured repeatedly; this is the
    -- current reading, not a history.
    weight_kg           NUMERIC(5,2) CHECK (weight_kg IS NULL OR weight_kg BETWEEN 30 AND 250),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_player_dob_past CHECK (date_of_birth IS NULL OR date_of_birth < CURRENT_DATE)
);

COMMENT ON TABLE hudl.player IS
    'The athlete as performer. Deliberately holds no address or contact data: '
    'an analysis platform does not need it, and modeling it would overstate '
    'the system. sap_sfsf.per_person is the identity record.';

-- -------------------------------------------------------------------------
-- Season and competition.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.season (
    season_id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id     UUID         NOT NULL,
    name                VARCHAR(80)  NOT NULL,
    starts_on           DATE         NOT NULL,
    ends_on             DATE         NOT NULL,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT ck_hudl_season_dates CHECK (ends_on > starts_on)
);

CREATE TABLE hudl.competition (
    competition_id      UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    season_id           UUID         NOT NULL,
    name                VARCHAR(120) NOT NULL,
    competition_type    VARCHAR(20)  NOT NULL
        CHECK (competition_type IN ('league', 'cup', 'friendly', 'tournament', 'playoff', 'training')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------------------
-- Label group and label. The coding vocabulary.
--
-- An analyst's code window is built from label groups -- Outcome, Body Part,
-- Pitch Zone, Pressure -- each with a fixed set of labels. This is the
-- vocabulary that makes instances queryable, and it is entirely absent from
-- the target model: target event.scoring_event has fixed columns, so whatever
-- labels the mapping anticipates get promoted and the rest are dropped.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.label_group (
    label_group_id      UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id     UUID         NOT NULL,
    name                VARCHAR(80)  NOT NULL,
    -- Exclusive groups permit one label per instance (Outcome); inclusive
    -- groups permit several (Qualities).
    is_exclusive        BOOLEAN      NOT NULL DEFAULT TRUE,
    display_order       SMALLINT     NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (organization_id, name)
);

COMMENT ON COLUMN hudl.label_group.is_exclusive IS
    'Exclusive groups allow one label per instance, inclusive groups several. '
    'The distinction is what makes a label set queryable rather than a bag of '
    'tags, and the target model has no equivalent.';

CREATE TABLE hudl.label (
    label_id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    label_group_id      UUID         NOT NULL,
    name                VARCHAR(80)  NOT NULL,
    short_code          VARCHAR(20),
    display_order       SMALLINT     NOT NULL DEFAULT 0,
    display_colour      common.dom_color_code,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (label_group_id, name)
);

-- -------------------------------------------------------------------------
-- Metric definition. How a statistic is computed from instances.
--
-- This is the table that explains target athlete.performance_stat. The target
-- carries the number; this carries the rule that produced it, and without the
-- rule the number is not reproducible.
-- -------------------------------------------------------------------------
CREATE TABLE hudl.metric_definition (
    metric_definition_id UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id     UUID         NOT NULL,
    metric_code         VARCHAR(40)  NOT NULL,
    display_name        VARCHAR(120) NOT NULL,
    -- How the metric is produced: a count of matching instances, a rate
    -- between two counts, a sum of a measure, or an externally supplied value.
    computation_type    VARCHAR(20)  NOT NULL
        CHECK (computation_type IN ('instance_count', 'rate', 'sum', 'average', 'external')),
    -- The instance filter, as the stored query the platform evaluates.
    instance_filter     JSONB,
    unit_of_measure     VARCHAR(20),
    -- Higher-is-better matters for any ranking or percentile display, and
    -- getting it backwards silently inverts every leaderboard.
    higher_is_better    BOOLEAN,
    decimal_places      SMALLINT     NOT NULL DEFAULT 0
        CHECK (decimal_places BETWEEN 0 AND 6),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (organization_id, metric_code),
    -- A derived metric must say how it is derived; an external one must not
    -- pretend to.
    CONSTRAINT ck_metric_filter_required
        CHECK ((computation_type = 'external') = (instance_filter IS NULL))
);

COMMENT ON TABLE hudl.metric_definition IS
    'The rule that turns coded instances into a statistic. Target '
    'athlete.performance_stat receives the resulting number, so without this '
    'table the figure is not reproducible or auditable.';
