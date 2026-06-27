-- =====================================================================
-- ADEPTUS MECHANICUS SUPPLEMENT — LEXMECHANIC ROLE
-- Source: Assembly of Means supplement
-- Run AFTER: roles_data.sql, am_roles_data.sql, am_weapons.sql,
--            specializations_data.sql
-- =====================================================================

-- =====================================================================
-- 1. NEW TALENTS
-- =====================================================================
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    ('PATHOLOGIST', '')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

-- =====================================================================
-- 2. ROLE
-- =====================================================================
INSERT INTO role (name, source_book)
SELECT 'LEXMECHANIC', 'AM'
WHERE NOT EXISTS (SELECT 1 FROM role r WHERE r.name = 'LEXMECHANIC');

-- =====================================================================
-- 3. FIXED INVENTORY
-- Taser Goad, Backpack/Slings, Survival Gear, Vox Bead
-- =====================================================================
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'LEXMECHANIC'
  AND i.name IN ('Micro-Bead/Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- =====================================================================
-- 4. CHOICE GROUPS: TALENT, SKILL, SPECIALIZATION
-- =====================================================================

-- choose 2 talents
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'LEXMECHANIC'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT');

-- 3 skill advances from pool
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'LEXMECHANIC'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');

-- 2 specialization advances from pool
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'LEXMECHANIC'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION');

-- =====================================================================
-- 5. INVENTORY CHOICE GROUPS
-- =====================================================================
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'LEXMECHANIC';

    IF EXISTS (SELECT 1 FROM role_choice_group WHERE role_id = v_role_id AND choice_type = 'INVENTORY') THEN
        RETURN;
    END IF;

    -- Arc Pistol OR Radium Pistol
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Arc Pistol', 'Radium Pistol');

    -- Choose 2 from: Auspex/Scanner, Auto-Quill, Chirurgeon's Kit, Combi-Tool, Diagnostor, Writing Kit
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 2, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Auspex/Scanner', 'Auto-Quill', 'Chirurgeon''s Kit', 'Combi-Tool', 'Diagnostor', 'Writing Kit');

END $$;

-- =====================================================================
-- 6. TALENT CHOICE OPTIONS (choose 2 from 10)
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'LEXMECHANIC' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN (
        'CHIRURGEON', 'DATA DELVER', 'EIDETIC MEMORY',
        'FAITHFUL (CULT OF MARS)', 'FLESH IS WEAK', 'GOTHIC GIBBERISH',
        'NECROMECHANIC', 'PATHOLOGIST', 'UNREMARKABLE', 'WELL-PREPARED'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );
END $$;

-- =====================================================================
-- 7. SKILL CHOICE OPTIONS
-- Fortitude, Logic, Lore, Medicae, Ranged, Tech
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'LEXMECHANIC' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('FORTITUDE', 'LOGIC', 'LORE', 'MEDICAE', 'RANGED', 'TECH')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );
END $$;

-- =====================================================================
-- 8. SPECIALIZATION CHOICE OPTIONS
-- Logic: EVALUATION, INVESTIGATION
-- Lore: ACADEMICS, ADEPTUS TERRA, PLANET, SECTOR, THEOLOGY (RESTRICTED), FORBIDDEN (LORE)
-- Tech (core): AUGMETICS (RESTRICTED), ENGINEERING, SECURITY
-- Tech (AM):   AUTOMATA, BIOLOGIS, FORBIDDEN (TECH), XENOS
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'LEXMECHANIC' AND cg.choice_type = 'SPECIALIZATION';

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        'EVALUATION', 'INVESTIGATION',
        'ACADEMICS', 'ADEPTUS TERRA', 'PLANET', 'SECTOR',
        'THEOLOGY (RESTRICTED)', 'FORBIDDEN (LORE)',
        'AUGMETICS (RESTRICTED)', 'ENGINEERING', 'SECURITY',
        'AUTOMATA', 'BIOLOGIS', 'FORBIDDEN (TECH)', 'XENOS'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );
END $$;