-- Patron data: Adeptus Astra Telepathica
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Astropath',
    'Your Patron is a high-ranking Astropath, perhaps the Head of an Astropathic Choir, soul-bound to the Emperor of Mankind. Their duty is to communicate across the void of space via the tumultuous warp, projecting images into another Astropath''s mind and interpreting the response in kind.',
    'Astropathic Communication',
    'Your Patron is an Astropath, capable of communicating across the void with other Astropaths. Without this Boon, the only means of contacting your Patron may be through enigmatic vox systems or personal messengers. Additionally, your Patron gains +1 Influence with the Adeptus Astra Telepathica.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus astra telepathica' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Astropath');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Sister of Silence',
    'Your Patron is a Knight-Centura, a Sister of Silence, a ranking member of an ancient order cursed with the Pariah gene and sworn to silence. She may accompany or even command a Black Ship, hunting psykers throughout the Imperium, or otherwise protect the Imperium from psychic threats.',
    'Null Sanctum',
    'Your Patron gives you access to a base of operations that incorporates a null-prison, a room immune to psychic powers and any warp influence, typically used to imprison psykers. Additionally, your Patron gains +1 Influence with the Adeptus Astra Telepathica.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus astra telepathica' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Sister of Silence');

-- ── Boon–Duty links: Astropath (d10 boon table) ──────────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Astropath' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Astropath duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Ancient Servants',
            'Blackmailer',
            'Cartographica Contacts',
            'Contact Network',
            'Null Sanctum',
            'Oracular',
            'Psychic Protection',
            'Psyker Support',
            'Sanctum Obscurus',
            'Tentative Alliance'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Astropath (d10 liability table) ────────────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Astropath' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Astropath duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Enemy',
            'Frail Form',
            'Overextended',
            'Paranoid',
            'Pious Stipulations',
            'Shoddy Supplies',
            'Sidereal Quests',
            'Suspect',
            'Warped Visions'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Sister of Silence (d10 boon table) ─────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Sister of Silence' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Sister of Silence duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Ancient Servants',
            'Cartographica Contacts',
            'Clandestine Inquisition Training Facility',
            'Cleansing Flame',
            'Datavault Access',
            'Drop Squad',
            'Fearsome Reputation',
            'Purification Rituals',
            'Righteous Bolts',
            'Witch Hunt'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Sister of Silence (d10 liability table) ────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Sister of Silence' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Sister of Silence duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Convoluted Communicae',
            'Demands Discretion',
            'Enemy',
            'Honour the Machine Spirits',
            'Miserly',
            'Overextended',
            'Pious Stipulations',
            'Tithe Obsessed',
            'Witch Hunter'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;