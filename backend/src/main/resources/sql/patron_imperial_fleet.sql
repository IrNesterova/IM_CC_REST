-- Patron data: Imperial Fleet (Faction 6)
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Voidship Captain',
    'Your Patron is the commander of a voidship and its innumerable crew, the ruler of a vessel that can travel between worlds. They may be a Chartist Captain, transferring titanic cargoes of crucial resources, or they may be part of the Navis Imperialis, ferrying troopers to war zones whilst wielding titanic arsenals capable of scorching whole worlds.',
    'Voidship',
    'Your Patron gives you access to a voidship, part of which you can use as a base of operations. Whilst aboard the voidship, you have free accommodation and meals at a minimum of Standard Quality, and have free System and Interplanetary (Warp) travel.',
    (SELECT id FROM faction WHERE LOWER(name) = 'imperial fleet' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Voidship Captain');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Port Commander',
    'Your Patron is the sovereign ruler of a voidport, the absolute authority of an invaluable transport hub of the Macharian Sector. They may be responsible for a planetside spaceport or a stellar void station, but in either case their word is law. A Port Commander is wholly responsible for their voidport, and is invested with the power to gather information and search or even detain ships in pursuit of the Emperor''s enemies.',
    'Voidport Peerage',
    'Your Patron is the ultimate authority of one or more voidports. On their authority you may: access shipping and travel manifests; inspect any voidship or its cargo; initiate a lockdown of the voidport; travel to and from a voidport at 50% cost. Additionally, your Patron gains +1 Influence with the Imperial Fleet.',
    (SELECT id FROM faction WHERE LOWER(name) = 'imperial fleet' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Port Commander');

-- ── Boon–Duty links: Voidship Captain (d10 boon table) ──────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Voidship Captain' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Voidship Captain duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Air Support',
            'Astropathic Communication',
            'Cartographica Contacts',
            'Conveyance Commander',
            'Drop Squad',
            'Ideologue Crusader',
            'Munitorum Depot',
            'Noble Blood',
            'Recruitment Drive',
            'Voidsman Training Facility'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Voidship Captain (d10 liability table) ─────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Voidship Captain' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Voidship Captain duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Argumentative',
            'Dealbreaker',
            'Dogmatic',
            'Enemy',
            'Overextended',
            'Paranoid',
            'Pious Stipulations',
            'Required Recruitment',
            'Sidereal Quests'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Port Commander (d10 boon table) ────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Port Commander' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Port Commander duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Astropathic Communication',
            'Connoisseur',
            'Contrabandist',
            'Conveyance Commander',
            'Drop Squad',
            'Ideologue Crusader',
            'Null Sanctum',
            'Recruitment Drive',
            'Tithe Inspection',
            'Voidsman Training Facility'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Port Commander (d10 liability table) ───────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Port Commander' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Port Commander duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Argumentative',
            'Blackmailed',
            'Dealbreaker',
            'Enemy',
            'Overextended',
            'Required Recruitment',
            'Revisionist',
            'Shaky Authority',
            'Strange Tastes'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;
