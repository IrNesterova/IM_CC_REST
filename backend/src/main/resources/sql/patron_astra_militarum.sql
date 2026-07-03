-- Patron data: Astra Militarum (Faction 5)
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Lord-Commissar',
    'Your Patron is a high-ranking member of the Commissariat, a political officer of such legendary stature and achievement that they have risen to a powerful position, responsible for ensuring morale is maintained at the highest levels. This includes watching for corruption, incompetence, and outright heresy among the officers of the regiment.',
    'Fearsome Reputation',
    'The mere mention of your Patron''s name is enough to strike terror into the hearts of any who know of them. When you invoke your Patron''s name, you can choose to force anyone who is aware of their reputation to make a Hard (–20) Discipline (Fear) Test or become Frightened. You may assume that anyone who shares a Faction with your Patron knows of their reputation, while it is up to the GM who else is aware of it.',
    (SELECT id FROM faction WHERE LOWER(name) = 'astra militarum' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Lord-Commissar');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Senior Officer',
    'Your Patron is a high-ranking executive officer of the Astra Militarum, assuming command of an entire regiment of troops and war machines.',
    'Seconded Troopers',
    'Your Patron can exert their power to deploy a small squad of Imperial Guard infantry. Once per mission, your Patron can put a number of Astra Militarum Troopers equal to the number of characters in the party under the party''s command for a day. The Astra Militarum Troopers are under the control of the Gamemaster, and have been instructed to aid the party. Additionally, your Patron gains +1 Influence with the Astra Militarum.',
    (SELECT id FROM faction WHERE LOWER(name) = 'astra militarum' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Senior Officer');

-- ── Boon–Duty links: Lord-Commissar (d10 boon table) ────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Lord-Commissar' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Lord-Commissar duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Adeptus Ministorum Training Facility',
            'Ceremonialist',
            'Ecclesiarchal Shrine',
            'Martial Training Facility',
            'Munitorum Depot',
            'Psyker Support',
            'Recruitment Drive',
            'Righteous Bolts',
            'Seconded Troopers',
            'Weapon Specialist'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Lord-Commissar (d10 liability table) ───────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Lord-Commissar' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Lord-Commissar duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Argumentative',
            'Be Ever Vigilant',
            'Boastful',
            'Dogmatic',
            'Draconian',
            'Enemy',
            'Honour the Machine Spirits',
            'Loose Cannon',
            'Nemesis'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Senior Officer (d10 boon table) ────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Senior Officer' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Senior Officer duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Air Support',
            'Astropathic Communication',
            'Ideologue Crusader',
            'Martial Training Facility',
            'Medicae Facility',
            'Munitorum Depot',
            'Munitorum Surplus',
            'Recruitment Drive',
            'Strategos Extremis',
            'Weapon Specialist'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Senior Officer (d10 liability table) ───────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Senior Officer' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Senior Officer duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Enemy',
            'Hallowed Ignorance',
            'Honour the Machine Spirits',
            'Known Meddler',
            'Offended the Omnissiah',
            'Overextended',
            'Psyker Slayer',
            'Required Recruitment',
            'Territorial'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;
