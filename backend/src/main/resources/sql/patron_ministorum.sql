-- Patron data: Adeptus Ministorum (Faction 4)
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Arch-Confessor',
    'Your Patron is a zealous priest of the Adeptus Ministorum, an exemplar of fervent faith in the Emperor. They are dedicated to uncovering any trace of heresy that lurks within the Imperium, and may have authority over the citizens of a single hive, a whole world, or even an entire subsector.',
    'Ecclesiarchal Shrine',
    'Your Patron gives you access to a base of operations within some kind of shrine, church, or cathedrum. The Difficulty of all Lore (Theology) Tests is reduced by 20 when you use the shrine''s library, and each character receives a Holy Icon for free.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus ministorum' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Arch-Confessor');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Canoness',
    'Your Patron is a ranking commander amongst the Adepta Sororitas, a military master of the Adeptus Ministorum. She has authority over Sisters of Battle, though others often fall under her sway — Preachers, Crusaders, and Death Cult Assassins to name but a few.',
    'Purification Rituals',
    'Before each mission, your Patron conducts a ritual to protect you from the warp, granting Advantage on the first Test you make to resist Corruption. At the end of each mission, your Patron conducts a ritual to purify your soul, halving your current Corruption Points.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus ministorum' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Canoness');

-- ── Boon–Duty links: Arch-Confessor (d10 boon table) ────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Arch-Confessor' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Arch-Confessor duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Adeptus Ministorum Training Facility',
            'Ceremonialist',
            'Cleansing Flame',
            'Deploy Devout',
            'Ideologue Crusader',
            'Noble Blood',
            'Opulent',
            'Purification Rituals',
            'Summon Sermoniser',
            'Witch Hunt'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Arch-Confessor (d10 liability table) ───────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Arch-Confessor' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Arch-Confessor duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Boastful',
            'Dogmatic',
            'Enemy',
            'Frail Form',
            'Hallowed Ignorance',
            'Known Meddler',
            'Missionary Mandate',
            'Offended the Omnissiah',
            'Pious Stipulations'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Canoness (d10 boon table) ───────────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Canoness' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Canoness duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Adeptus Ministorum Training Facility',
            'Clandestine Inquisition Training Facility',
            'Cleansing Flame',
            'Ecclesiarchal Shrine',
            'Fearsome Reputation',
            'Martial Training Facility',
            'Medicae Facility',
            'Righteous Bolts',
            'Summon Sermoniser',
            'Witch Hunt'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Canoness (d10 liability table) ─────────────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Canoness' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Canoness duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Dogmatic',
            'Draconian',
            'Enemy',
            'Hallowed Ignorance',
            'Miserly',
            'Missionary Mandate',
            'Nemesis',
            'Pious Stipulations',
            'Psyker Slayer'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;
