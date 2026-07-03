-- Patron data: Adeptus Mechanicus
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Forge Lord',
    'Your Patron is an Artisan Magos, capable of maintaining ancient technology and overseeing the production of Omnissiah-approved patterns.',
    'Manufactorum Master',
    'Your Patron is in charge of ensuring a manufactorum, or even an entire Forge World, outputs useful equipment for the Imperium. Much of what is produced goes to fulfil requisition orders that are sometimes decades or centuries old, but more common materials can be diverted to the Characters. Choose one type of equipment such as Flak Armour, Las Weapons, or Custom Ammunition. Your Patron can always provide one item of Common or Scarce equipment of that type at the start of each mission.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus mechanicus' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Forge Lord');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Magos Biologis',
    'Your Patron is a high-ranking Tech-Priest, an experienced master Genetor specialising in the study and manipulation of biological life.',
    'Ameliorator',
    'Your Patron is obsessed with improving both your weapons and your bodies. You do not have to make an Availability Test for Weapon Modifications or Augmetics. Your Patron will arrange or perform Augmetic surgeries for free — indeed, they may demand you undergo such procedures any time the opportunity arises.',
    (SELECT id FROM faction WHERE LOWER(name) = 'adeptus mechanicus' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Magos Biologis');

-- ── Boon–Duty links: Forge Lord (d10 boon table) ─────────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Forge Lord' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Forge Lord duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Adeptus Mechanicus Instruction',
            'Administratum Training Facility',
            'Ancient Servants',
            'Augmetics Bay',
            'Cartographica Contacts',
            'Conveyance Commander',
            'Datavault Access',
            'Machine Spirit Maintenance',
            'Servitor Clade',
            'Voidport Peerage'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Forge Lord (d10 liability table) ───────────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Forge Lord' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Forge Lord duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Data Addict',
            'Draconian',
            'Enemy',
            'Honour the Machine Spirits',
            'Known Meddler',
            'Meticulous Archivist',
            'Obsolete Observer',
            'Omnissian Principles',
            'Territorial'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Magos Biologis (d10 boon table) ────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Magos Biologis' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Magos Biologis duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Adeptus Mechanicus Instruction',
            'Administratum Training Facility',
            'Ancient Servants',
            'Augmetics Bay',
            'Datavault Access',
            'Forbidden Archive',
            'Machine Spirit Maintenance',
            'Medicae Facility',
            'Servitor Clade',
            'Xenotechnician'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Magos Biologis (d10 liability table) ───────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Magos Biologis' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Magos Biologis duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Convoluted Communicae',
            'Data Addict',
            'Demands Discretion',
            'Enemy',
            'Incessant Updates',
            'Meticulous Archivist',
            'Obsolete Observer',
            'Omnissian Principles',
            'Unorthodox Beliefs'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;