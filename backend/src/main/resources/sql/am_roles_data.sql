-- =====================================================================
-- ADEPTUS MECHANICUS SUPPLEMENT — ROLES DATA
-- Source: Assembly of Means supplement
-- Run AFTER: roles_data.sql, inquisition_roles_data.sql,
--            am_talents_data.sql, am_faction_data.sql,
--            specializations_data.sql
-- =====================================================================

-- =====================================================================
-- 1. NEW TALENTS (core-book talents not yet seeded)
-- =====================================================================
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    ('EXTENDED PROPRIOCEPTION', ''),
    ('GUARDIAN',                ''),
    ('TENACIOUS',               ''),
    ('WELL-PREPARED',           '')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

-- =====================================================================
-- 2. NEW INVENTORY ITEMS
-- =====================================================================
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT name, category, subcategory FROM (VALUES
    ('Omnissian Axe (One-Handed)', 'MELEE_WEAPON',  'POWER'),
    ('Omnissian Axe (Two-Handed)', 'MELEE_WEAPON',  'POWER'),
    ('Arc Pistol',                 'RANGED_WEAPON', 'ARC'),
    ('Stubcarbine',                'RANGED_WEAPON', 'SOLID_PROJECTILE'),
    ('Tech-Adept Flak Armour',     'ARMOUR',        'FLAK')
) AS v(name, category, subcategory)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);

-- =====================================================================
-- 3. AM TECH SPECIALIZATIONS (referenced in supplement talents)
-- =====================================================================
INSERT INTO specialization (name, description)
SELECT name, '' FROM (VALUES
    ('AUTOMATA'),
    ('BIOLOGIS'),
    ('FORBIDDEN (TECH)'),
    ('XENOS')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM specialization s WHERE s.name = v.name);

INSERT INTO skill_specializations (skill_id, specialization_id)
SELECT s.id, sp.id FROM skill s, specialization sp
WHERE s.name = 'TECH'
  AND sp.name IN ('AUTOMATA', 'BIOLOGIS', 'FORBIDDEN (TECH)', 'XENOS')
  AND NOT EXISTS (
      SELECT 1 FROM skill_specializations ss
      WHERE ss.skill_id = s.id AND ss.specialization_id = sp.id
  );

-- =====================================================================
-- 4. ROLE
-- =====================================================================
INSERT INTO role (name, source_book)
SELECT 'ENGINESEER', 'AM'
WHERE NOT EXISTS (SELECT 1 FROM role r WHERE r.name = 'ENGINESEER');

-- =====================================================================
-- 5. FIXED INVENTORY
-- Tech-Adept Flak Armour, Backpack/Slings, Vox Bead
-- (Omnissian Axe is an INVENTORY choice group — see section 7)
-- =====================================================================
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'ENGINESEER'
  AND i.name IN ('Tech-Adept Flak Armour', 'Backpack/Slings', 'Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- =====================================================================
-- 6. CHOICE GROUPS: TALENT, SKILL, SPECIALIZATION
-- =====================================================================

-- choose 2 talents
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'ENGINESEER'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT');

-- 3 skill advances from pool
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'ENGINESEER'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');

-- 2 specialization advances from pool
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'ENGINESEER'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION');

-- =====================================================================
-- 7. INVENTORY CHOICE GROUPS
-- =====================================================================
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'ENGINESEER';

    IF EXISTS (SELECT 1 FROM role_choice_group WHERE role_id = v_role_id AND choice_type = 'INVENTORY') THEN
        RETURN;
    END IF;

    -- Omnissian Axe: One-Handed OR Two-Handed
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Omnissian Axe (One-Handed)', 'Omnissian Axe (Two-Handed)');

    -- Arc Pistol OR Stubcarbine
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Arc Pistol', 'Stubcarbine');

    -- Choose 2 from: Auspex/Scanner, Combi-Tool, Magnoculars, Multicompass, Multikey
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 2, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Auspex/Scanner', 'Combi-Tool', 'Magnoculars', 'Multicompass', 'Multikey');

END $$;

-- =====================================================================
-- 8. TALENT CHOICE OPTIONS (choose 2 from 9)
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'ENGINESEER' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN (
        'ATTENTIVE ASSISTANT', 'EIDETIC MEMORY', 'EXTENDED PROPRIOCEPTION',
        'FAITHFUL (CULT OF MARS)', 'GUARDIAN', 'FLESH IS WEAK',
        'NECROMECHANIC', 'TENACIOUS', 'WELL-PREPARED'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );
END $$;

-- =====================================================================
-- 9. SKILL CHOICE OPTIONS
-- Fortitude, Logic, Lore, Navigation, Piloting, Tech
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'ENGINESEER' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('FORTITUDE', 'LOGIC', 'LORE', 'NAVIGATION', 'PILOTING', 'TECH')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );
END $$;

-- =====================================================================
-- 10. SPECIALIZATION CHOICE OPTIONS
-- All specs from Fortitude, Piloting, Tech (including AM additions)
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'ENGINESEER' AND cg.choice_type = 'SPECIALIZATION';

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Fortitude
        'ENDURANCE', 'PAIN', 'POISON',
        -- Piloting
        'AERONAUTICA', 'CIVILIAN', 'MILITARY (RESTRICTED)',
        'MINOR VOIDSHIP (RESTRICTED)', 'MAJOR VOIDSHIP (RESTRICTED)',
        -- Tech (core)
        'AUGMETICS (RESTRICTED)', 'ENGINEERING', 'SECURITY',
        -- Tech (AM supplement)
        'AUTOMATA', 'BIOLOGIS', 'FORBIDDEN (TECH)', 'XENOS'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );
END $$;