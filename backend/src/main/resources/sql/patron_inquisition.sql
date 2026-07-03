-- Patron data: The Inquisition (Faction 8)
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────
-- Both Ordo duties share the same Duty Boon: Limitless Authority.

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Ordo Hereticus Inquisitor',
    'Your Patron serves the Ordo Hereticus, rooting out heresy in all its forms. Rogue Psykers, heretical preachers, and secretive cultists have all met a grisly end at the hands of an Ordo Hereticus Inquisitor. For every traitor they have uncovered, however, a dozen more worm their way ever closer to the heart of the Imperium.',
    'Limitless Authority',
    'Your Patron is an Inquisitor, empowered with theoretically limitless authority over the other Factions of the Imperium. When you use your Patron''s Influence, you may choose to use their Influence with the Inquisition instead of the target''s Faction. There is a chance that your target might find this insulting, find your particular Patron unimpressive, or even be outright heretical — ultimately, the Gamemaster determines the results.',
    (SELECT id FROM faction WHERE LOWER(name) IN ('the inquisition', 'inquisition') LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Ordo Hereticus Inquisitor');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Ordo Xenos Inquisitor',
    'Your Patron is a servant of the Ordo Xenos, concerned with locating and purging inhuman taint wherever it is found. Many an Ork Waaagh! or Drukhari incursion has been averted by the subtle work of an Inquisitor and their acolytes. Some make use of xenos weaponry, turning the tools of their hated foes back upon them. Others view all technology conceived by inhuman minds as indelibly corrupt.',
    'Limitless Authority',
    'Your Patron is an Inquisitor, empowered with theoretically limitless authority over the other Factions of the Imperium. When you use your Patron''s Influence, you may choose to use their Influence with the Inquisition instead of the target''s Faction. There is a chance that your target might find this insulting, find your particular Patron unimpressive, or even be outright heretical — ultimately, the Gamemaster determines the results.',
    (SELECT id FROM faction WHERE LOWER(name) IN ('the inquisition', 'inquisition') LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Ordo Xenos Inquisitor');

-- ── Boon–Duty links: Ordo Hereticus Inquisitor (d10 boon table) ──────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Ordo Hereticus Inquisitor' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Ordo Hereticus Inquisitor duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Clandestine Inquisition Training Facility',
            'Contact Network',
            'Cover Story',
            'Datavault Access',
            'Fearsome Reputation',
            'Psychic Protection',
            'Sanctum Obscurus',
            'Spy Network',
            'Strategos Extremis',
            'Witch Hunt'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Ordo Hereticus Inquisitor (d10 liability table) ────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Ordo Hereticus Inquisitor' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Ordo Hereticus Inquisitor duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Be Ever Vigilant',
            'Convoluted Communicae',
            'Demands Discretion',
            'Enemy',
            'Nemesis',
            'Paranoid',
            'Psyker Slayer',
            'Sidereal Quests',
            'Witch Hunter'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Ordo Xenos Inquisitor (d10 boon table) ─────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Ordo Xenos Inquisitor' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Ordo Xenos Inquisitor duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Clandestine Inquisition Training Facility',
            'Contact Network',
            'Cover Story',
            'Fearsome Reputation',
            'Oracular',
            'Psychic Protection',
            'Sanctum Obscurus',
            'Spy Network',
            'Strategos Extremis',
            'Xenotechnician'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Ordo Xenos Inquisitor (d10 liability table) ────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Ordo Xenos Inquisitor' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Ordo Xenos Inquisitor duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Demands Discretion',
            'Enemy',
            'Excommunicated',
            'Nemesis',
            'Offended the Omnissiah',
            'Paranoid',
            'Rumoured Dead',
            'Unorthodox Beliefs',
            'Warped Visions'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;
