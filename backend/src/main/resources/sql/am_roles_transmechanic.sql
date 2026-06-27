-- =====================================================================
-- ADEPTUS MECHANICUS SUPPLEMENT — TRANSMECHANIC ROLE
-- Source: Assembly of Means supplement
-- Run AFTER: roles_data.sql, am_roles_data.sql, am_weapons.sql,
--            specializations_data.sql
-- =====================================================================

-- =====================================================================
-- 1. NEW TALENTS
-- =====================================================================
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    ('READ LIPS', '')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

-- =====================================================================
-- 2. ROLE
-- =====================================================================
INSERT INTO role (name, source_book)
SELECT 'TRANSMECHANIC', 'AM'
WHERE NOT EXISTS (SELECT 1 FROM role r WHERE r.name = 'TRANSMECHANIC');

-- =====================================================================
-- 3. FIXED INVENTORY
-- Transonic Razor, Backpack/Slings, Survival Gear, Vox Bead
-- =====================================================================
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'TRANSMECHANIC'
  AND i.name IN ('Micro-Bead/Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- =====================================================================
-- 4. CHOICE GROUPS: TALENT, SKILL, SPECIALIZATION
-- =====================================================================

INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'TRANSMECHANIC'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT');

INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'TRANSMECHANIC'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');

INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'TRANSMECHANIC'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION');

-- =====================================================================
-- 5. INVENTORY CHOICE GROUPS
-- =====================================================================
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'TRANSMECHANIC';

    IF EXISTS (SELECT 1 FROM role_choice_group WHERE role_id = v_role_id AND choice_type = 'INVENTORY') THEN
        RETURN;
    END IF;

    -- Flechette Blaster OR Radium Pistol
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Flechette Blaster', 'Radium Pistol');

    -- Choose 2 from: Auspex/Scanner, Combi-Tool, Laud Hailer, Vox-Caster
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 2, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Auspex/Scanner', 'Combi-Tool', 'Laud Hailer', 'Vox-Caster');

END $$;

-- =====================================================================
-- 6. TALENT CHOICE OPTIONS (choose 2 from 9)
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'TRANSMECHANIC' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN (
        'AIR OF AUTHORITY', 'EXTENDED PROPRIOCEPTION', 'FAITHFUL (CULT OF MARS)',
        'FLESH IS WEAK', 'ICON BEARER', 'OVERSEER',
        'READ LIPS', 'TRANSHUMAN RAPPORT', 'VOID LEGS'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );
END $$;

-- =====================================================================
-- 7. SKILL CHOICE OPTIONS
-- Discipline, Linguistics, Logic, Piloting, Presence, Tech
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'TRANSMECHANIC' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('DISCIPLINE', 'LINGUISTICS', 'LOGIC', 'PILOTING', 'PRESENCE', 'TECH')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );
END $$;

-- =====================================================================
-- 8. SPECIALIZATION CHOICE OPTIONS
-- Linguistics: CIPHER, HIGH GOTHIC, FORBIDDEN (LINGUISTICS)
-- Logic:       EVALUATION, INVESTIGATION
-- Tech (core): AUGMETICS (RESTRICTED), ENGINEERING, SECURITY
-- Tech (AM):   AUTOMATA, BIOLOGIS, FORBIDDEN (TECH), XENOS
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'TRANSMECHANIC' AND cg.choice_type = 'SPECIALIZATION';

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        'CIPHER', 'HIGH GOTHIC', 'FORBIDDEN (LINGUISTICS)',
        'EVALUATION', 'INVESTIGATION',
        'AUGMETICS (RESTRICTED)', 'ENGINEERING', 'SECURITY',
        'AUTOMATA', 'BIOLOGIS', 'FORBIDDEN (TECH)', 'XENOS'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );
END $$;