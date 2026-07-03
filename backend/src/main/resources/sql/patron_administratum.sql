-- Patron data: Adeptus Administratum
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Departmento Munitorum Ordinate',
    'Your Patron is a high-ranking official of the Departmento Munitorum, the logistical sub-division of the Administratum responsible for ensuring the armies of the Astra Militarum are raised, armed, and armoured, then liaising with the Navis Imperialis to ferry these warriors to the battlefield.',
    'Munitorum Depot',
    'Your Patron gives you access to a base of operations within a Departmento Munitorum sanctum. You have Advantage on Availability Tests and receive additional magazines for your weapons for free.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus administratum' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Departmento Munitorum Ordinate');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Tithe Prefectus',
    'Your Patron is a high-ranking official of the Adeptus Administratum tasked with ensuring the titanic tithes of the worlds of the Macharian Sector are delivered and the Emperor is paid His due. The exact nature of the tithe varies from world to world, with some providing food or processed ores, while others provide desperately needed manufactured goods. Regardless of its form, the size of the tithe is always onerous, calculated to be nothing less than everything the planet can spare.',
    'Tithe Inspection',
    'Your Patron is capable of arranging perfectly legal ''inspections'' of people and places to ensure that the Emperor''s Tithe will be fulfilled. Once during each mission, you can request that your Patron have their Faction make an ''inspection'' of a place or person, possibly led by Administratum Adepts, Overseers, and Vigilites or the equivalent, which your group may be allowed to accompany.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus administratum' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Tithe Prefectus');

-- ── Boon–Duty links: Departmento Munitorum Ordinate (d10 boon table) ─────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Departmento Munitorum Ordinate' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Departmento Munitorum Ordinate duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Administratum Censorium',
            'Administratum Training Facility',
            'Astropathic Communication',
            'Cartographica Contacts',
            'Conveyance Commander',
            'Datavault Access',
            'Drop Squad',
            'Munitorum Surplus',
            'Recruitment Drive',
            'Seconded Troopers'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Departmento Munitorum Ordinate (d10 liability table) ─

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Departmento Munitorum Ordinate' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Departmento Munitorum Ordinate duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Corrupt',
            'Draconian',
            'Frail Form',
            'Incessant Updates',
            'Known Meddler',
            'Meticulous Archivist',
            'Overextended',
            'Sidereal Quests',
            'Tithe Obsessed'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Tithe Prefectus (d10 boon table) ───────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Tithe Prefectus' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Tithe Prefectus duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Administratum Censorium',
            'Administratum Training Facility',
            'Ancient Servants',
            'Astropathic Communication',
            'Cartographica Contacts',
            'Clerk Cadre',
            'Contact Network',
            'Conveyance Commander',
            'Datavault Access',
            'Vigilite Vanguard'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Tithe Prefectus (d10 liability table) ──────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Tithe Prefectus' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Tithe Prefectus duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Craven',
            'Draconian',
            'Frail Form',
            'Incessant Updates',
            'Meticulous Archivist',
            'Miserly',
            'Obsolete Observer',
            'Revisionist',
            'Tithe Obsessed'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;