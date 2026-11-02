-- =========================================================================
-- archtics -- transactions
--
-- Seat assignment, renewal and parking activation. The season-ticket book is
-- rebuilt every year, and these are the records of that cycle.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Account seat assignment. Which account holds which seat on which plan for
-- which season. Feeds target ticketing.season_ticket_account.
--
-- This is the central fact of season-ticket administration and a genuine
-- four-way relationship. The target model flattens it onto a single
-- season_ticket_account row, which cannot represent an account holding seats
-- across two different plans -- common for a corporate holder.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.account_seat_assignment (
    account_seat_assignment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sta_account_id      BIGINT       NOT NULL,
    plan_id             INTEGER      NOT NULL,
    seat_id             BIGINT       NOT NULL,
    season_year         SMALLINT     NOT NULL CHECK (season_year BETWEEN 1850 AND 2200),
    psl_id              BIGINT,

    -- Realised price after account-level discount, distinct from the plan list
    -- price. Season-ticket pricing is negotiated per account.
    assigned_price      NUMERIC(18,4) NOT NULL CHECK (assigned_price >= 0),
    discount_percent    NUMERIC(5,2) NOT NULL DEFAULT 0
        CHECK (discount_percent BETWEEN 0 AND 100),
    currency_code       common.dom_iso3_code NOT NULL,

    assignment_status   VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (assignment_status IN ('pending', 'active', 'relocated', 'released', 'forfeited', 'cancelled')),
    assigned_on         DATE         NOT NULL DEFAULT CURRENT_DATE,
    released_on         DATE,
    -- Where the seat went on relocation, so a move can be traced in both
    -- directions.
    relocated_to_assignment_id BIGINT,

    payment_plan_status VARCHAR(20)  NOT NULL DEFAULT 'current'
        CHECK (payment_plan_status IN ('current', 'arrears', 'paid_in_full', 'defaulted', 'refunded')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    -- A seat is held by one account per season.
    UNIQUE (seat_id, season_year),
    CONSTRAINT ck_assignment_released_date
        CHECK (released_on IS NULL OR released_on >= assigned_on),
    CONSTRAINT ck_assignment_relocation_target_differs
        CHECK (relocated_to_assignment_id IS NULL
               OR relocated_to_assignment_id <> account_seat_assignment_id),
    CONSTRAINT ck_assignment_relocated_has_target
        CHECK (assignment_status <> 'relocated' OR relocated_to_assignment_id IS NOT NULL)
);

COMMENT ON CONSTRAINT ck_assignment_relocated_has_target ON archtics.account_seat_assignment IS
    'A relocation must say where the account went. Without this the seat '
    'history has holes, and relocation disputes are settled on that history.';

-- -------------------------------------------------------------------------
-- Renewal. The annual decision, tracked as its own record because the
-- campaign is managed and reported on independently of the resulting
-- assignment. Feeds target fan.membership.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.renewal (
    renewal_id          BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sta_account_id      BIGINT       NOT NULL,
    plan_id             INTEGER      NOT NULL,
    from_season_year    SMALLINT     NOT NULL CHECK (from_season_year BETWEEN 1850 AND 2200),
    to_season_year      SMALLINT     NOT NULL CHECK (to_season_year BETWEEN 1850 AND 2200),

    renewal_status      VARCHAR(20)  NOT NULL DEFAULT 'invited'
        CHECK (renewal_status IN
            ('invited', 'reminded', 'renewed', 'declined', 'lapsed', 'relocated', 'upgraded', 'downgraded')),
    invited_on          DATE         NOT NULL,
    deadline_on         DATE         NOT NULL,
    responded_on        DATE,
    -- Seat count can change on renewal, which is the churn signal that
    -- matters more than the binary renew/lapse.
    prior_seat_count    SMALLINT     NOT NULL CHECK (prior_seat_count >= 0),
    renewed_seat_count  SMALLINT     CHECK (renewed_seat_count IS NULL OR renewed_seat_count >= 0),
    prior_total_value   NUMERIC(18,4) CHECK (prior_total_value IS NULL OR prior_total_value >= 0),
    renewed_total_value NUMERIC(18,4) CHECK (renewed_total_value IS NULL OR renewed_total_value >= 0),
    decline_reason      VARCHAR(30)
        CHECK (decline_reason IS NULL OR decline_reason IN
            ('price', 'relocation', 'team_performance', 'schedule', 'personal',
             'relocated_away', 'service', 'unspecified')),
    reminder_count      SMALLINT     NOT NULL DEFAULT 0 CHECK (reminder_count >= 0),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (sta_account_id, plan_id, to_season_year),
    CONSTRAINT ck_renewal_season_order CHECK (to_season_year > from_season_year),
    CONSTRAINT ck_renewal_deadline_after_invite CHECK (deadline_on >= invited_on),
    CONSTRAINT ck_renewal_declined_has_reason
        CHECK (renewal_status <> 'declined' OR decline_reason IS NOT NULL),
    CONSTRAINT ck_renewal_responded_when_decided
        CHECK (renewal_status IN ('invited', 'reminded') OR responded_on IS NOT NULL)
);

COMMENT ON COLUMN archtics.renewal.renewed_seat_count IS
    'Retained alongside prior_seat_count so partial churn is visible. An '
    'account dropping from six seats to two is a renewal in the target model.';

-- -------------------------------------------------------------------------
-- Parking inventory and activation. Feeds target venue.parking_activation.
--
-- Inventory is the standing allocation of a lot into sellable buckets;
-- activation is that allocation opened for one event.
-- -------------------------------------------------------------------------
CREATE TABLE archtics.parking_inventory (
    parking_inventory_id INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    parking_lot_id      INTEGER      NOT NULL,
    inventory_code      VARCHAR(20)  NOT NULL,
    inventory_name      VARCHAR(60)  NOT NULL,
    allocation_type     VARCHAR(20)  NOT NULL
        CHECK (allocation_type IN
            ('general', 'season', 'suite', 'staff', 'media', 'team', 'accessible', 'bus', 'rideshare')),
    allocated_spaces    INTEGER      NOT NULL CHECK (allocated_spaces >= 0),
    is_prepaid          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (parking_lot_id, inventory_code)
);

CREATE TABLE archtics.parking_activation (
    parking_activation_id BIGINT     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_manifest_id   BIGINT       NOT NULL,
    parking_inventory_id INTEGER     NOT NULL,
    spaces_available    INTEGER      NOT NULL CHECK (spaces_available >= 0),
    spaces_sold         INTEGER      NOT NULL DEFAULT 0 CHECK (spaces_sold >= 0),
    price_per_space     NUMERIC(18,4) NOT NULL DEFAULT 0 CHECK (price_per_space >= 0),
    currency_code       common.dom_iso3_code NOT NULL,
    gates_open_at       TIMESTAMPTZ,
    activation_status   VARCHAR(20)  NOT NULL DEFAULT 'planned'
        CHECK (activation_status IN ('planned', 'on_sale', 'sold_out', 'closed', 'cancelled')),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),

    UNIQUE (event_manifest_id, parking_inventory_id),
    CONSTRAINT ck_parking_activation_not_oversold
        CHECK (spaces_sold <= spaces_available)
);
