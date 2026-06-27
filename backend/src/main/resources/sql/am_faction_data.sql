-- =====================================================================
-- ASSEMBLY OF MEANS — ADEPTUS MECHANICUS FACTION (source_book = AM)
-- Overwrites core IM faction benefits; players may choose either version.
-- Run AFTER: inventory.sql, am_talents_data.sql
-- =====================================================================
-- Characteristics IDs: 1=WS, 2=BS, 3=STR, 4=TGH, 5=AG, 6=INT, 7=PER, 8=WIL, 9=FEL

-- =====================================================================
-- 1. NEW INVENTORY ITEMS
-- =====================================================================
INSERT INTO inventory (name, inventory_category)
SELECT name, category FROM (VALUES
    ('Mechanicus Robes', 'CLOTHING_AND_PERSONAL_GEAR'),
    ('Opus Machina',     'TOOLS')
) AS v(name, category)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);

INSERT INTO generic_item (id, description)
SELECT i.id, NULL FROM inventory i
WHERE i.name IN ('Mechanicus Robes', 'Opus Machina')
ON CONFLICT (id) DO NOTHING;

-- =====================================================================
-- 1b. CORE TALENT (not yet seeded elsewhere)
-- =====================================================================
INSERT INTO talent (name, description)
SELECT 'FLESH IS WEAK',
       'Requirement: Member of the Adeptus Mechanicus, or pick at Character Creation. You have undergone the Rite of Sanctioned Augmentation, the first step in replacing your mortal shell with the gifts of the Machine God. You gain +1 Armour to all Hit Locations from your augmetics, and the number of augmetics you can have installed is equal to double your Toughness Bonus.'
WHERE NOT EXISTS (SELECT 1 FROM talent WHERE name = 'FLESH IS WEAK');

-- =====================================================================
-- 2. FACTION
-- =====================================================================
INSERT INTO faction (name, source_book)
SELECT 'ADEPTUS MECHANICUS', 'AM'
WHERE NOT EXISTS (
    SELECT 1 FROM faction WHERE name = 'ADEPTUS MECHANICUS' AND source_book = 'AM'
);

-- =====================================================================
-- 3. GENERAL FACTION BENEFITS (fixed inventory, shared across all grades)
-- =====================================================================
INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, i.id, NULL
FROM faction f
CROSS JOIN inventory i
WHERE f.name = 'ADEPTUS MECHANICUS' AND f.source_book = 'AM'
AND i.name IN ('Mechanicus Robes', 'Opus Machina', 'Dataslate', 'Sacred Unguents (5 uses)')
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = i.id
);

-- 100 solars (inventory id=1 is the money placeholder)
INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, 1, '100'
FROM faction f
WHERE f.name = 'ADEPTUS MECHANICUS' AND f.source_book = 'AM'
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = 1
);

-- =====================================================================
-- 4. GRADES
-- =====================================================================
DO $$
DECLARE
    v_faction_id   BIGINT;
    v_grade1_id    BIGINT;
    v_grade2_id    BIGINT;
    v_grade3_id    BIGINT;
    v_grp          BIGINT;
BEGIN
    SELECT id INTO v_faction_id
    FROM faction WHERE name = 'ADEPTUS MECHANICUS' AND source_book = 'AM';

    IF EXISTS (SELECT 1 FROM faction_grade WHERE faction_id = v_faction_id) THEN
        RETURN;
    END IF;

    -- ── GRADE I ──────────────────────────────────────────────────────
    INSERT INTO faction_grade (faction_id, grade_number, name, description, skill_pool_size, fixed_char_id, fixed_char_amount)
    VALUES (v_faction_id, 1, 'Augmented Grade I',
        'You have started on the path to bionic perfection. Your weak or damaged limbs are replaced immediately. +5 Intelligence and +5 to either Toughness, Agility or Perception. 5 advances distributed among Dexterity, Linguistics, Logic, Lore, Medicae, Rapport, and Tech.',
        5, 6, 5)
    RETURNING id INTO v_grade1_id;

    -- Char choices: TGH, AG, PER
    INSERT INTO faction_grade_char_choice (grade_id, characteristics_id)
    SELECT v_grade1_id, id FROM characteristics WHERE id IN (4, 5, 7);

    -- Allowed skills
    INSERT INTO faction_grade_skill (grade_id, skill_id)
    SELECT v_grade1_id, s.id FROM skill s
    WHERE s.name IN ('DEXTERITY', 'LINGUISTICS', 'LOGIC', 'LORE', 'MEDICAE', 'RAPPORT', 'TECH');

    -- Fixed items: Augmetic Sensory Organs (cosmetic choice: Eyes/Nose/Ears)
    INSERT INTO faction_grade_inventory (grade_id, inventory_id, quantity)
    SELECT v_grade1_id, i.id, 1 FROM inventory i WHERE i.name = 'Augmetic Sensory Organs';

    -- Choice group: Augmetic Arm OR Augmetic Leg
    INSERT INTO faction_grade_choice_group (grade_id, choices_required, choice_type)
    VALUES (v_grade1_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO faction_grade_inventory_choice (choice_group_id, inventory_id, quantity)
    SELECT v_grp, i.id, 1 FROM inventory i WHERE i.name IN ('Augmetic Arm', 'Augmetic Leg');

    -- ── GRADE II ─────────────────────────────────────────────────────
    INSERT INTO faction_grade (faction_id, grade_number, name, description, skill_pool_size, fixed_char_id, fixed_char_amount)
    VALUES (v_faction_id, 2, 'Augmented Grade II',
        'You are now half-Human, half-machine. +10 Toughness and +5 to either Intelligence, Perception or Willpower. 3 advances distributed among Dexterity, Discipline, Linguistics, Medicae, and Tech. Gain the Flesh is Weak Talent.',
        3, 4, 10)
    RETURNING id INTO v_grade2_id;

    -- Char choices: INT, PER, WIL
    INSERT INTO faction_grade_char_choice (grade_id, characteristics_id)
    SELECT v_grade2_id, id FROM characteristics WHERE id IN (6, 7, 8);

    -- Allowed skills
    INSERT INTO faction_grade_skill (grade_id, skill_id)
    SELECT v_grade2_id, s.id FROM skill s
    WHERE s.name IN ('DEXTERITY', 'DISCIPLINE', 'LINGUISTICS', 'MEDICAE', 'TECH');

    -- Fixed talent: Flesh is Weak
    INSERT INTO faction_grade_talent (grade_id, talent_id)
    SELECT v_grade2_id, t.id FROM talent t WHERE t.name = 'FLESH IS WEAK';

    -- Fixed items: Augmetic Arm, Augmetic Leg, Augmetic Sensory Organs
    INSERT INTO faction_grade_inventory (grade_id, inventory_id, quantity)
    SELECT v_grade2_id, i.id, 1 FROM inventory i
    WHERE i.name IN ('Augmetic Arm', 'Augmetic Leg', 'Augmetic Sensory Organs');

    -- Choice group: Mechadendrite type
    INSERT INTO faction_grade_choice_group (grade_id, choices_required, choice_type)
    VALUES (v_grade2_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO faction_grade_inventory_choice (choice_group_id, inventory_id, quantity)
    SELECT v_grp, i.id, 1 FROM inventory i
    WHERE i.name IN (
        'Ballistic Mechadendrite',
        'Manipulator Mechadendrite',
        'Medicae Mechadendrite',
        'Optical Mechadendrite',
        'Utility Mechadendrite'
    );

    -- ── GRADE III ────────────────────────────────────────────────────
    INSERT INTO faction_grade (faction_id, grade_number, name, description, skill_pool_size, fixed_char_id, fixed_char_amount)
    VALUES (v_faction_id, 3, 'Augmented Grade III',
        'You stand on the precipice of biomechanical perfection. +10 Toughness and +5 to either Ballistic Skill, Weapon Skill or Intelligence. 1 advance distributed among Discipline, Fortitude, Logic, Navigation, or Tech. Gain Transhuman Ideal and choose Skitarii Compliance Protocols or The Strength and Certainty of Steel.',
        1, 4, 10)
    RETURNING id INTO v_grade3_id;

    -- Char choices: BS, WS, INT
    INSERT INTO faction_grade_char_choice (grade_id, characteristics_id)
    SELECT v_grade3_id, id FROM characteristics WHERE id IN (1, 2, 6);

    -- Allowed skills
    INSERT INTO faction_grade_skill (grade_id, skill_id)
    SELECT v_grade3_id, s.id FROM skill s
    WHERE s.name IN ('DISCIPLINE', 'FORTITUDE', 'LOGIC', 'NAVIGATION', 'TECH');

    -- Fixed talents: Transhuman Ideal
    INSERT INTO faction_grade_talent (grade_id, talent_id)
    SELECT v_grade3_id, t.id FROM talent t WHERE t.name = 'TRANSHUMAN IDEAL';

    -- Fixed items: 2x Augmetic Arms, 2x Augmetic Sensory Organs
    INSERT INTO faction_grade_inventory (grade_id, inventory_id, quantity)
    SELECT v_grade3_id, i.id, 2 FROM inventory i WHERE i.name = 'Augmetic Arm';

    INSERT INTO faction_grade_inventory (grade_id, inventory_id, quantity)
    SELECT v_grade3_id, i.id, 2 FROM inventory i WHERE i.name = 'Augmetic Sensory Organs';

    -- Choice group 1: 2x Augmetic Legs OR Augmetic Tracks/Wheels
    INSERT INTO faction_grade_choice_group (grade_id, choices_required, choice_type)
    VALUES (v_grade3_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO faction_grade_inventory_choice (choice_group_id, inventory_id, quantity)
    SELECT v_grp, i.id,
           CASE i.name WHEN 'Augmetic Leg' THEN 2 ELSE 1 END
    FROM inventory i WHERE i.name IN ('Augmetic Leg', 'Augmetic Tracks/Wheels');

    -- Choice group 2: Augmetic Heart OR Augmetic Respiratory System
    INSERT INTO faction_grade_choice_group (grade_id, choices_required, choice_type)
    VALUES (v_grade3_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO faction_grade_inventory_choice (choice_group_id, inventory_id, quantity)
    SELECT v_grp, i.id, 1 FROM inventory i
    WHERE i.name IN ('Augmetic Heart', 'Augmetic Respiratory System');

    -- Choice group 3 (TALENT): Skitarii Compliance Protocols OR The Strength and Certainty of Steel
    INSERT INTO faction_grade_choice_group (grade_id, choices_required, choice_type)
    VALUES (v_grade3_id, 1, 'TALENT') RETURNING id INTO v_grp;

    INSERT INTO faction_grade_talent_choice (choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('SKITARII COMPLIANCE PROTOCOLS', 'THE STRENGTH AND CERTAINTY OF STEEL');

END $$;