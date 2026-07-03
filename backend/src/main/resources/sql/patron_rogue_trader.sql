-- Patron data: Rogue Trader Dynasty (Faction 9)
-- Both duties share the same Duty Boon: Voidship.
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Diplomat',
    'Your Patron is a Rogue Trader devoted to negotiating with societies within and beyond the Imperium, bridging the gaps between Factions (and even Species in rare circumstances) in the name of profit.',
    'Voidship',
    'Your Patron gives you access to a voidship, part of which you can use as a base of operations. Whilst aboard the voidship, you have free accommodation and meals at a minimum of Standard Quality, and have free System and Interplanetary (Warp) travel.',
    (SELECT id FROM faction WHERE LOWER(name) IN ('rogue trader dynasty', 'rogue trader dynasties') LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Diplomat');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Trader Militant',
    'Your Patron is a Trader Militant, willing and even eager to exploit the military allowances within their warrant of trade to the fullest. They are a minor military force onto themselves, often overthrowing whole worlds to bring their populace — and their resources — into the Imperium.',
    'Voidship',
    'Your Patron gives you access to a voidship, part of which you can use as a base of operations. Whilst aboard the voidship, you have free accommodation and meals at a minimum of Standard Quality, and have free System and Interplanetary (Warp) travel.',
    (SELECT id FROM faction WHERE LOWER(name) IN ('rogue trader dynasty', 'rogue trader dynasties') LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Trader Militant');

-- ── Boon–Duty links: Diplomat (d10 boon table) ───────────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Diplomat' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Diplomat duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Astropathic Communication',
            'Backchannel Contacts',
            'Blackmailer',
            'Cartographica Contacts',
            'Contrabandist',
            'Forbidden Archive',
            'Opulent',
            'Registered Trader',
            'Tentative Alliance',
            'Xenotechnician'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Diplomat (d10 liability table) ─────────────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Diplomat' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Diplomat duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Boastful',
            'Craven',
            'Dealbreaker',
            'Enemy',
            'Loose Cannon',
            'Missionary Mandate',
            'Paranoid',
            'Price of Life',
            'Rumoured Dead'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Trader Militant (d10 boon table) ────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Trader Militant' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Trader Militant duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Air Support',
            'Cartographica Contacts',
            'Connoisseur',
            'Contrabandist',
            'Drop Squad',
            'Ideologue Crusader',
            'Martial Training Facility',
            'Opulent',
            'Refined Panoply',
            'Registered Trader'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Trader Militant (d10 liability table) ──────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Trader Militant' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Trader Militant duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Argumentative',
            'Boastful',
            'Dangerous Debt',
            'Enemy',
            'Loose Cannon',
            'Rumoured Dead',
            'Strange Tastes',
            'Territorial',
            'Unorthodox Beliefs'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;
