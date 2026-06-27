-- =====================================================================
-- IMPERIUM MALEDICTUM — INQUISITION FACTIONS DATA
-- Source: IM Inquisition Player's Guide
-- Run AFTER: inquisition_roles_data.sql, inventory.sql, roles_data.sql
-- =====================================================================
ALTER TABLE skill_factions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
-- Sync the new identity sequence past the existing max id to avoid PK conflicts.
SELECT setval(pg_get_serial_sequence('skill_factions', 'id'), COALESCE(MAX(id), 0) + 1, false)
FROM skill_factions;
-- =====================================================================
-- 1. NEW INVENTORY ITEMS
-- =====================================================================
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT name, category, subcategory FROM (VALUES
    ('Shotpistol',        'RANGED_WEAPON', 'SOLID_PROJECTILE'),
    ('Soulguilt Scanner', 'TOOLS',          NULL)
) AS v(name, category, subcategory)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);

-- Soulguilt Scanner is a plain item — needs a generic_item row so Hibernate
-- can resolve the concrete subtype (Inventory is abstract/JOINED).
-- Shotpistol will get its ranged_weapon row from inquisition_ranged_weapons.sql.
INSERT INTO generic_item (id, description)
SELECT i.id, NULL FROM inventory i
WHERE i.name = 'Soulguilt Scanner'
ON CONFLICT (id) DO NOTHING;

-- =====================================================================
-- 2. FACTIONS
-- =====================================================================
INSERT INTO faction (name, source_book)
SELECT 'ORDO HERETICUS', 'IN'
WHERE NOT EXISTS (SELECT 1 FROM faction WHERE name = 'ORDO HERETICUS');

-- =====================================================================
-- 3. CHARACTERISTICS
-- Characteristics IDs: 1=WS,2=BS,3=STR,4=TGH,5=AG,6=INT,7=PER,8=WIL,9=FEL
-- ORDO HERETICUS: primary PER, secondary FEL / STR / WIL
-- =====================================================================
INSERT INTO characteristics_faction (faction_id, characteristics_id, primary_char)
SELECT f.id, v.char_id, v.is_primary
FROM faction f
CROSS JOIN (VALUES
    (7, true),   -- PER primary
    (9, false),  -- FEL secondary
    (3, false),  -- STR secondary
    (8, false)   -- WIL secondary
) AS v(char_id, is_primary)
WHERE f.name = 'ORDO HERETICUS'
AND NOT EXISTS (
    SELECT 1 FROM characteristics_faction cf
    WHERE cf.faction_id = f.id AND cf.characteristics_id = v.char_id
);

-- =====================================================================
-- 4. SKILLS (5 advances: Awareness, Intuition, Logic, Melee, Rapport, Presence)
-- =====================================================================
INSERT INTO skill_factions (faction_id, skill_id)
SELECT f.id, s.id
FROM faction f
CROSS JOIN skill s
WHERE f.name = 'ORDO HERETICUS'
AND s.name IN ('AWARENESS', 'INTUITION', 'LOGIC', 'MELEE', 'RAPPORT', 'PRESENCE')
AND NOT EXISTS (
    SELECT 1 FROM skill_factions sf WHERE sf.faction_id = f.id AND sf.skill_id = s.id
);

-- =====================================================================
-- 5. FIXED INVENTORY
-- =====================================================================
-- Armoured Bodyglove
INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, i.id, NULL
FROM faction f
JOIN inventory i ON i.name = 'Armoured Bodyglove'
WHERE f.name = 'ORDO HERETICUS'
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = i.id
);

-- 400 Solars starting money
-- NOTE: inventory id=1 is the special money placeholder used by SummaryServiceImpl.
-- Verify this is correct for your DB before running.
INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, 1, '400'
FROM faction f
WHERE f.name = 'ORDO HERETICUS'
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = 1
);

-- =====================================================================
-- 6. CHOICE GROUPS
-- =====================================================================
DO $$
DECLARE
    v_faction_id BIGINT;
    v_grp        BIGINT;
BEGIN
    SELECT id INTO v_faction_id FROM faction WHERE name = 'ORDO HERETICUS';

    IF NOT EXISTS (
        SELECT 1 FROM faction_inventory_choice_group WHERE faction_id = v_faction_id
    ) THEN

        -- Talent choice (choose 1): Ever Vigilant OR Cult Infiltrator
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_talent_choice (faction_choice_group_id, talent_id, option_id)
        SELECT v_grp, t.id, opt.option_id
        FROM (VALUES
            ('EVER VIGILANT',   1),
            ('CULT INFILTRATOR', 2)
        ) AS opt(talent_name, option_id)
        JOIN talent t ON t.name = opt.talent_name;

        -- Weapon choice (choose 1): Laspistol OR Shotpistol
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_inventory_choice (faction_choice_group_id, inventory_id)
        SELECT v_grp, i.id FROM inventory i
        WHERE i.name IN ('Laspistol', 'Shotpistol');

        -- Kit choice (choose 1): Multikey OR Power Maul OR Soulguilt Scanner
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_inventory_choice (faction_choice_group_id, inventory_id)
        SELECT v_grp, i.id FROM inventory i
        WHERE i.name IN ('Multikey', 'Power Maul', 'Soulguilt Scanner');

    END IF;
END $$;

-- =====================================================================
-- ORDO MALLEUS
-- +5 WIL, +5 to STR/TGH/PER; skills: Awareness, Discipline, Fortitude,
-- Intuition, Logic, Presence; talent: Ever Vigilant or Unwavering Will;
-- fixed: Armoured Bodyglove + 400 Solars;
-- weapon choice: Hand Flamer or Laspistol;
-- kit choice: Instrument of Divination, Psyocculum, or Signal Jammer
-- =====================================================================

-- New items
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT name, category, subcategory FROM (VALUES
    ('Instrument of Divination', 'TOOLS', NULL),
    ('Psyocculum',               'TOOLS', NULL)
) AS v(name, category, subcategory)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);

INSERT INTO generic_item (id, description)
SELECT i.id, NULL FROM inventory i
WHERE i.name IN ('Instrument of Divination', 'Psyocculum')
ON CONFLICT (id) DO NOTHING;

INSERT INTO faction (name, source_book)
SELECT 'ORDO MALLEUS', 'IN'
WHERE NOT EXISTS (SELECT 1 FROM faction WHERE name = 'ORDO MALLEUS');

-- Characteristics: WIL primary, STR/TGH/PER secondary
INSERT INTO characteristics_faction (faction_id, characteristics_id, primary_char)
SELECT f.id, v.char_id, v.is_primary
FROM faction f
CROSS JOIN (VALUES
    (8, true),   -- WIL primary
    (3, false),  -- STR secondary
    (4, false),  -- TGH secondary
    (7, false)   -- PER secondary
) AS v(char_id, is_primary)
WHERE f.name = 'ORDO MALLEUS'
AND NOT EXISTS (
    SELECT 1 FROM characteristics_faction cf
    WHERE cf.faction_id = f.id AND cf.characteristics_id = v.char_id
);

-- Skills
INSERT INTO skill_factions (faction_id, skill_id)
SELECT f.id, s.id
FROM faction f
CROSS JOIN skill s
WHERE f.name = 'ORDO MALLEUS'
AND s.name IN ('AWARENESS', 'DISCIPLINE', 'FORTITUDE', 'INTUITION', 'LOGIC', 'PRESENCE')
AND NOT EXISTS (
    SELECT 1 FROM skill_factions sf WHERE sf.faction_id = f.id AND sf.skill_id = s.id
);

-- Fixed inventory: Armoured Bodyglove + 400 Solars
INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, i.id, NULL
FROM faction f JOIN inventory i ON i.name = 'Armoured Bodyglove'
WHERE f.name = 'ORDO MALLEUS'
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = i.id
);

INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, 1, '400'
FROM faction f
WHERE f.name = 'ORDO MALLEUS'
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = 1
);

-- Choice groups
DO $$
DECLARE
    v_faction_id BIGINT;
    v_grp        BIGINT;
BEGIN
    SELECT id INTO v_faction_id FROM faction WHERE name = 'ORDO MALLEUS';

    IF NOT EXISTS (
        SELECT 1 FROM faction_inventory_choice_group WHERE faction_id = v_faction_id
    ) THEN

        -- Talent choice (choose 1): Ever Vigilant OR Unwavering Will
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_talent_choice (faction_choice_group_id, talent_id, option_id)
        SELECT v_grp, t.id, opt.option_id
        FROM (VALUES
            ('EVER VIGILANT',   1),
            ('UNWAVERING WILL', 2)
        ) AS opt(talent_name, option_id)
        JOIN talent t ON t.name = opt.talent_name;

        -- Weapon choice (choose 1): Hand Flamer OR Laspistol
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_inventory_choice (faction_choice_group_id, inventory_id)
        SELECT v_grp, i.id FROM inventory i
        WHERE i.name IN ('Hand Flamer', 'Laspistol');

        -- Kit choice (choose 1): Instrument of Divination OR Psyocculum OR Signal Jammer
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_inventory_choice (faction_choice_group_id, inventory_id)
        SELECT v_grp, i.id FROM inventory i
        WHERE i.name IN ('Instrument of Divination', 'Psyocculum', 'Signal Jammer');

    END IF;
END $$;

-- =====================================================================
-- ORDO XENOS
-- +5 FEL, +5 to TGH/INT/PER; skills: Intuition, Linguistics, Logic,
-- Lore, Rapport, Tech; talent: Ever Vigilant or Logical Liar;
-- fixed: Armoured Bodyglove + 400 Solars;
-- weapon choice: Hand Cannon or Needle Pistol;
-- kit choice: Auspex, Bio-sample Extractor, or Pict Recorder
-- =====================================================================

-- New items
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT 'Bio-sample Extractor', 'TOOLS', NULL
WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Bio-sample Extractor');

INSERT INTO generic_item (id, description)
SELECT i.id, NULL FROM inventory i
WHERE i.name = 'Bio-sample Extractor'
ON CONFLICT (id) DO NOTHING;

INSERT INTO faction (name, source_book)
SELECT 'ORDO XENOS', 'IN'
WHERE NOT EXISTS (SELECT 1 FROM faction WHERE name = 'ORDO XENOS');

-- Characteristics: FEL primary, TGH/INT/PER secondary
INSERT INTO characteristics_faction (faction_id, characteristics_id, primary_char)
SELECT f.id, v.char_id, v.is_primary
FROM faction f
CROSS JOIN (VALUES
    (9, true),   -- FEL primary
    (4, false),  -- TGH secondary
    (6, false),  -- INT secondary
    (7, false)   -- PER secondary
) AS v(char_id, is_primary)
WHERE f.name = 'ORDO XENOS'
AND NOT EXISTS (
    SELECT 1 FROM characteristics_faction cf
    WHERE cf.faction_id = f.id AND cf.characteristics_id = v.char_id
);

-- Skills
INSERT INTO skill_factions (faction_id, skill_id)
SELECT f.id, s.id
FROM faction f
CROSS JOIN skill s
WHERE f.name = 'ORDO XENOS'
AND s.name IN ('INTUITION', 'LINGUISTICS', 'LOGIC', 'LORE', 'RAPPORT', 'TECH')
AND NOT EXISTS (
    SELECT 1 FROM skill_factions sf WHERE sf.faction_id = f.id AND sf.skill_id = s.id
);

-- Fixed inventory: Armoured Bodyglove + 400 Solars
INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, i.id, NULL
FROM faction f JOIN inventory i ON i.name = 'Armoured Bodyglove'
WHERE f.name = 'ORDO XENOS'
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = i.id
);

INSERT INTO faction_inventory (faction_id, inventory_id, quantity)
SELECT f.id, 1, '400'
FROM faction f
WHERE f.name = 'ORDO XENOS'
AND NOT EXISTS (
    SELECT 1 FROM faction_inventory fi WHERE fi.faction_id = f.id AND fi.inventory_id = 1
);

-- Choice groups
DO $$
DECLARE
    v_faction_id BIGINT;
    v_grp        BIGINT;
BEGIN
    SELECT id INTO v_faction_id FROM faction WHERE name = 'ORDO XENOS';

    IF NOT EXISTS (
        SELECT 1 FROM faction_inventory_choice_group WHERE faction_id = v_faction_id
    ) THEN

        -- Talent choice (choose 1): Ever Vigilant OR Logical Liar
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_talent_choice (faction_choice_group_id, talent_id, option_id)
        SELECT v_grp, t.id, opt.option_id
        FROM (VALUES
            ('EVER VIGILANT', 1),
            ('LOGICAL LIAR',  2)
        ) AS opt(talent_name, option_id)
        JOIN talent t ON t.name = opt.talent_name;

        -- Weapon choice (choose 1): Hand Cannon OR Needle Pistol
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_inventory_choice (faction_choice_group_id, inventory_id)
        SELECT v_grp, i.id FROM inventory i
        WHERE i.name IN ('Hand Cannon', 'Needle Pistol');

        -- Kit choice (choose 1): Auspex OR Bio-sample Extractor OR Pict Recorder
        INSERT INTO faction_inventory_choice_group (faction_id, choices_required)
        VALUES (v_faction_id, 1) RETURNING id INTO v_grp;

        INSERT INTO faction_inventory_choice (faction_choice_group_id, inventory_id)
        SELECT v_grp, i.id FROM inventory i
        WHERE i.name IN ('Auspex', 'Bio-sample Extractor', 'Pict Recorder');

    END IF;
END $$;