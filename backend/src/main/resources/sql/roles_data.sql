-- =====================================================================
-- IMPERIUM MALEDICTUM — ROLES DATA
-- Source: IM Core Rulebook, pp. 74-80
-- Run AFTER the application has started at least once
-- (so Hibernate creates the tables and enum types).
-- =====================================================================


-- =====================================================================
-- 1. TALENTS
-- =====================================================================
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    -- Interlocutor choices
    ('AIR OF AUTHORITY',        ''),
    ('BRIBER',                  ''),
    ('DEALMAKER',               ''),
    ('DISTRACTING',             ''),
    ('GALLOWS HUMOUR',          ''),
    ('GOTHIC GIBBERISH',        ''),
    ('LICKSPITTLE',             ''),
    ('OVERSEER',                ''),
    -- Mystic (auto + choices)
    ('PSYKER',                  ''),
    ('CONDEMN THE WITCH',       ''),
    ('FATED',                   ''),
    ('FORBIDDEN KNOWLEDGE',     ''),
    ('MENTAL FORTRESS',         ''),
    ('SANCTIONED PSYKER',       ''),
    -- Penumbra choices
    ('BURGLAR',                 ''),
    ('FAMILIAR TERRAIN',        ''),
    ('READ LIPS',               ''),
    ('SECRET IDENTITY',         ''),
    ('SKULKER',                 ''),
    ('UNREMARKABLE',            ''),
    -- Savant choices
    ('ARTIST',                  ''),
    ('ATTENTIVE ASSISTANT',     ''),
    ('CHIRURGEON',              ''),
    ('DATA DELVER',             ''),
    ('EIDETIC MEMORY',          ''),
    ('LAWBRINGER',              ''),
    -- Warrior choices
    ('DEADEYE',                 ''),
    ('DISARM',                  ''),
    ('DRILLED',                 ''),
    ('DUELLIST',                ''),
    ('TACTICAL MOVEMENT',       ''),
    ('TWO-HANDED CLEAVE',       ''),
    -- Zealot choices
    ('FAITHFUL (IMPERIAL CULT)',''),
    ('FLAGELLANT',              ''),
    ('FRENZY',                  ''),
    ('HATRED',                  ''),
    ('ICON BEARER',             ''),
    ('MARTYRDOM',               '')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);


-- =====================================================================
-- 2. INVENTORY
-- =====================================================================
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT name, category, subcategory
FROM (VALUES
    -- Melee weapons
    ('Knife',               'MELEE_WEAPON',              'MUNDANE'),
    ('Staff',               'MELEE_WEAPON',              'MUNDANE'),
    ('Chainsword',          'MELEE_WEAPON',              'CHAIN'),
    ('Great Weapon',        'MELEE_WEAPON',              'MUNDANE'),
    -- Ranged weapons
    ('Laspistol',           'RANGED_WEAPON',             'LAS'),
    ('Stub Revolver',       'RANGED_WEAPON',             'SOLID_PROJECTILE'),
    ('Autopistol',          'RANGED_WEAPON',             'SOLID_PROJECTILE'),
    ('Long Las',            'RANGED_WEAPON',             'LAS'),
    ('Sniper Rifle',        'RANGED_WEAPON',             'SOLID_PROJECTILE'),
    ('Lasgun',              'RANGED_WEAPON',             'LAS'),
    ('Shotgun (Combat)',    'RANGED_WEAPON',             'SOLID_PROJECTILE'),
    ('Hand Flamer',         'RANGED_WEAPON',             'FLAME'),
    -- Grenades
    ('Frag Grenade',        'GRENADES_AND_EXPLOSIVES',   NULL),
    ('Smoke Grenade',       'GRENADES_AND_EXPLOSIVES',   NULL),
    -- Weapon mods
    ('Silencer',            'WEAPON_MODIFICATION',       'COMBAT_ATTACHMENTS'),
    -- Armour
    ('Scrap-plate',         'ARMOUR',                    'BASIC'),
    ('Flak Jacket',         'ARMOUR',                    'FLAK'),
    ('Heavy Leathers',      'ARMOUR',                    'BASIC'),
    -- Clothing / personal gear
    ('Survival Gear',       'CLOTHING_AND_PERSONAL_GEAR', NULL),
    ('Slings',              'CLOTHING_AND_PERSONAL_GEAR', NULL),
    ('Backpack',            'CLOTHING_AND_PERSONAL_GEAR', NULL),
    ('Holy Icon',           'CLOTHING_AND_PERSONAL_GEAR', NULL),
    ('Robes',               'CLOTHING_AND_PERSONAL_GEAR', NULL),
    -- Tools / equipment
    ('Vox Bead',            'TOOLS',                     NULL),
    ('Auspex',              'TOOLS',                     NULL),
    ('Comm Leech',          'TOOLS',                     NULL),
    ('Disguise Kit',        'TOOLS',                     NULL),
    ('Grapnel & Line',      'TOOLS',                     NULL),
    ('Magnoculars',         'TOOLS',                     NULL),
    ('Multikey',            'TOOLS',                     NULL),
    ('Photo-visors',        'TOOLS',                     NULL),
    ('Signal Jammer',       'TOOLS',                     NULL),
    ('Dataslate',           'TOOLS',                     NULL),
    ('Auto-quill',          'TOOLS',                     NULL),
    ('Chirurgeon''s Tools', 'TOOLS',                     NULL),
    ('Combi-Tool',          'TOOLS',                     NULL),
    ('Diagnostor',          'TOOLS',                     NULL),
    ('Multicompass',        'TOOLS',                     NULL),
    ('Writing Kit',         'TOOLS',                     NULL),
    ('Psy Focus',           'TOOLS',                     NULL),
    ('Laud Hailer',         'TOOLS',                     NULL),
    ('Pict Recorder',       'TOOLS',                     NULL),
    ('Vox-Caster',          'TOOLS',                     NULL)
) AS v(name, category, subcategory)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);


-- =====================================================================
-- 3. SKILLS
--    characteristics_id is intentionally NULL here — link manually
--    if the skills are not already in the database from faction data.
-- =====================================================================
INSERT INTO skill (name, description)
SELECT name, '' FROM (VALUES
    ('AWARENESS'),
    ('DISCIPLINE'),
    ('INTUITION'),
    ('LINGUISTICS'),
    ('PRESENCE'),
    ('RAPPORT'),
    ('LORE'),
    ('NAVIGATION'),
    ('PSYCHIC MASTERY'),
    ('ATHLETICS'),
    ('DEXTERITY'),
    ('RANGED'),
    ('REFLEXES'),
    ('STEALTH'),
    ('LOGIC'),
    ('MEDICAE'),
    ('PILOTING'),
    ('TECH'),
    ('FORTITUDE'),
    ('MELEE')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM skill s WHERE s.name = v.name);


-- =====================================================================
-- 4. ROLES
-- =====================================================================
INSERT INTO role (name)
SELECT name FROM (VALUES
    ('Interlocutor'),
    ('Mystic'),
    ('Penumbra'),
    ('Savant'),
    ('Warrior'),
    ('Zealot')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM role r WHERE r.name = v.name);


-- =====================================================================
-- 5. FIXED INVENTORY PER ROLE
-- =====================================================================

-- INTERLOCUTOR: Knife, Survival Gear, Vox Bead
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Interlocutor' AND i.name IN ('Knife', 'Survival Gear', 'Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- MYSTIC: Survival Gear, Vox Bead
-- NOTE: Psyker talent is gained automatically — no role_talent table yet.
--       Add it manually or implement a role_talent table later.
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Mystic' AND i.name IN ('Survival Gear', 'Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- PENUMBRA: 2× Knife, Silencer, Smoke Grenade, Survival Gear, Vox Bead
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Penumbra' AND i.name IN ('Knife', 'Silencer', 'Smoke Grenade', 'Survival Gear', 'Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );
-- Second knife (extra row for Penumbra's 2 knives)
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Penumbra' AND i.name = 'Knife'
  AND (SELECT COUNT(*) FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id) < 2;

-- SAVANT: Knife, Slings, Dataslate, Survival Gear, Vox Bead
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Savant' AND i.name IN ('Knife', 'Slings', 'Dataslate', 'Survival Gear', 'Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- WARRIOR: Knife, Frag Grenade, Backpack, Survival Gear, Vox Bead
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Warrior' AND i.name IN ('Knife', 'Frag Grenade', 'Backpack', 'Survival Gear', 'Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- ZEALOT: Knife, Holy Icon, Vox Bead
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Zealot' AND i.name IN ('Knife', 'Holy Icon', 'Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );


-- =====================================================================
-- 6. ROLE CHOICE GROUPS
-- =====================================================================

-- -----------------------------------------------------------------------
-- INTERLOCUTOR
-- -----------------------------------------------------------------------
-- Group A: choose 1 sidearm
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 1, 'INVENTORY' FROM role r WHERE r.name = 'Interlocutor'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'INVENTORY' AND cg.choices_required = 1
  );
-- Group B: choose 1 comms item
-- Group C: choose 4 talents
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 4, 'TALENT' FROM role r WHERE r.name = 'Interlocutor'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT'
  );
-- Group D: distribute 3 skill advances
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Interlocutor'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL'
  );

-- -----------------------------------------------------------------------
-- MYSTIC
-- -----------------------------------------------------------------------
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Mystic'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT'
  );
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Mystic'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL'
  );

-- -----------------------------------------------------------------------
-- PENUMBRA
-- -----------------------------------------------------------------------
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Penumbra'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT'
  );
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Penumbra'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL'
  );

-- -----------------------------------------------------------------------
-- SAVANT
-- -----------------------------------------------------------------------
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Savant'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT'
  );
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Savant'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL'
  );

-- -----------------------------------------------------------------------
-- WARRIOR
-- -----------------------------------------------------------------------
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Warrior'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT'
  );
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Warrior'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL'
  );

-- -----------------------------------------------------------------------
-- ZEALOT
-- -----------------------------------------------------------------------
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Zealot'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT'
  );
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Zealot'
  AND NOT EXISTS (
      SELECT 1 FROM role_choice_group cg
      WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL'
  );


-- =====================================================================
-- 7. INVENTORY CHOICE GROUPS (per role, multiple groups)
-- =====================================================================
-- We insert the groups first, then link items in section 8.
-- Each role may have multiple INVENTORY choice groups with different
-- choices_required. We use a helper comment to show which is which.

-- INTERLOCUTOR — sidearm group (choose 1): Laspistol / Stub Revolver
-- INTERLOCUTOR — comms group   (choose 1): Laud Hailer / Pict Recorder / Vox-Caster
DO $$
DECLARE v_role_id BIGINT;
        v_grp_sidearm BIGINT;
        v_grp_comms   BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Interlocutor';

    -- sidearm
    IF NOT EXISTS (
        SELECT 1 FROM role_choice_group
        WHERE role_id = v_role_id AND choice_type = 'INVENTORY' AND choices_required = 1
    ) THEN
        INSERT INTO role_choice_group (role_id, choices_required, choice_type)
        VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp_sidearm;
    ELSE
        SELECT id INTO v_grp_sidearm
        FROM role_choice_group
        WHERE role_id = v_role_id AND choice_type = 'INVENTORY' AND choices_required = 1
        LIMIT 1;
    END IF;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp_sidearm, i.id FROM inventory i
    WHERE i.name IN ('Laspistol', 'Stub Revolver')
      AND NOT EXISTS (
          SELECT 1 FROM role_inventory_choice_group x
          WHERE x.role_choice_group_id = v_grp_sidearm AND x.inventory_id = i.id
      );

    -- comms
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp_comms;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp_comms, i.id FROM inventory i
    WHERE i.name IN ('Laud Hailer', 'Pict Recorder', 'Vox-Caster')
      AND NOT EXISTS (
          SELECT 1 FROM role_inventory_choice_group x
          WHERE x.role_choice_group_id = v_grp_comms AND x.inventory_id = i.id
      );
END $$;

-- MYSTIC — weapon group (choose 1): Knife / Staff
-- MYSTIC — sidearm (choose 1): Laspistol / Stub Revolver
-- MYSTIC — focus   (choose 1): Psy Focus / Auspex
DO $$
DECLARE v_role_id BIGINT;
        v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Mystic';

    -- weapon
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Knife', 'Staff');

    -- sidearm
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Laspistol', 'Stub Revolver');

    -- focus
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Psy Focus', 'Auspex/Scanner');
END $$;

-- PENUMBRA — sidearm (choose 1): Autopistol / Laspistol
-- PENUMBRA — longarm (choose 1): Long Las / Sniper Rifle
-- PENUMBRA — kit     (choose 2): 9 options
DO $$
DECLARE v_role_id BIGINT;
        v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Penumbra';

    -- sidearm
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Autopistol', 'Laspistol');

    -- longarm
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Long Las', 'Sniper Rifle');

    -- kit (choose 2 from 9)
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 2, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Auspex', 'Comm Leech', 'Disguise Kit', 'Grapnel & Line',
                     'Magnoculars', 'Multikey', 'Pict Recorder', 'Photo-visors', 'Signal Jammer');
END $$;

-- SAVANT — sidearm  (choose 1): Laspistol / Stub Revolver
-- SAVANT — kit      (choose 2): 7 options
DO $$
DECLARE v_role_id BIGINT;
        v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Savant';

    -- sidearm
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Laspistol', 'Stub Revolver');

    -- kit (choose 2 from 7)
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 2, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Auspex', 'Auto-quill', 'Chirurgeon''s Tools',
                     'Combi-Tool', 'Diagnostor', 'Multicompass', 'Multikey');
END $$;

-- WARRIOR — melee   (choose 1): Chainsword (+ mundane melee; add more as needed)
-- WARRIOR — sidearm (choose 1): Laspistol / Stub Revolver
-- WARRIOR — longarm (choose 1): Lasgun / Shotgun (Combat)
-- WARRIOR — armour  (choose 1): Scrap-plate / Flak Jacket
DO $$
DECLARE v_role_id BIGINT;
        v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Warrior';

    -- melee weapon
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.inventory_category = 'MELEE_WEAPON'
      AND i.inventory_subcategory = 'MUNDANE'
      AND i.name NOT IN ('Unarmed', 'Improvised (One-handed)', 'Improvised (Two-handed)');

    -- sidearm
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Laspistol', 'Stub Revolver');

    -- longarm
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Lasgun', 'Shotgun (Combat)');

    -- armour
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Scrap-plate', 'Flak Jacket');
END $$;
DO $$
    DECLARE
        v_role_id BIGINT;
        v_grp     BIGINT;
    BEGIN
        SELECT id INTO v_role_id FROM role WHERE name = 'Warrior';
-- берём первую INVENTORY-группу Warrior'а (это melee)
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg
    WHERE cg.role_id = v_role_id AND cg.choice_type = 'INVENTORY'
    ORDER BY cg.id
    LIMIT 1;

    -- чистим старые опции и вставляем новые
    DELETE FROM role_inventory_choice_group WHERE role_choice_group_id = v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.inventory_category = 'MELEE_WEAPON'
      AND i.inventory_subcategory = 'MUNDANE'
      AND i.name NOT IN ('Unarmed', 'Improvised (One-handed)', 'Improvised (Two-handed)');
END $$;
-- ZEALOT — melee   (choose 1): Great Weapon / Chainsword
-- ZEALOT — sidearm (choose 1): Laspistol / Hand Flamer
-- ZEALOT — armour  (choose 1): Heavy Leathers / Robes
-- ZEALOT — misc    (choose 1): Laud Hailer / Writing Kit
DO $$
DECLARE v_role_id BIGINT;
        v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Zealot';

    -- melee
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Great Weapon', 'Chainsword');

    -- sidearm
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Laspistol', 'Hand Flamer');

    -- armour
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Heavy Leathers', 'Robes');

    -- misc
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Laud Hailer', 'Writing Kit');
END $$;


-- =====================================================================
-- 8. TALENT CHOICE GROUP OPTIONS
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN

    -- INTERLOCUTOR — choose 4 from 8
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Interlocutor' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('AIR OF AUTHORITY','BRIBER','DEALMAKER','DISTRACTING',
                     'GALLOWS HUMOUR','GOTHIC GIBBERISH','LICKSPITTLE','OVERSEER')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- MYSTIC — choose 2 from 5
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Mystic' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('CONDEMN THE WITCH','FATED','FORBIDDEN KNOWLEDGE',
                     'MENTAL FORTRESS','SANCTIONED PSYKER')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- PENUMBRA — choose 2 from 6
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Penumbra' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('BURGLAR','FAMILIAR TERRAIN','READ LIPS',
                     'SECRET IDENTITY','SKULKER','UNREMARKABLE')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- SAVANT — choose 2 from 6
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Savant' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('ARTIST','ATTENTIVE ASSISTANT','CHIRURGEON',
                     'DATA DELVER','EIDETIC MEMORY','LAWBRINGER')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- WARRIOR — choose 2 from 6
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Warrior' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('DEADEYE','DISARM','DRILLED',
                     'DUELLIST','TACTICAL MOVEMENT','TWO-HANDED CLEAVE')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- ZEALOT — choose 2 from 6
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Zealot' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('FAITHFUL (IMPERIAL CULT)','FLAGELLANT','FRENZY',
                     'HATRED','ICON BEARER','MARTYRDOM')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

END $$;


-- =====================================================================
-- 9. SKILL CHOICE GROUP OPTIONS
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN

    -- INTERLOCUTOR skills
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Interlocutor' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('AWARENESS','DISCIPLINE','INTUITION','LINGUISTICS','PRESENCE','RAPPORT')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- MYSTIC skills
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Mystic' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('AWARENESS','DISCIPLINE','INTUITION','LORE','NAVIGATION','PSYCHIC MASTERY')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- PENUMBRA skills
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Penumbra' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('ATHLETICS','AWARENESS','DEXTERITY','RANGED','REFLEXES','STEALTH')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- SAVANT skills
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Savant' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('LOGIC','LORE','MEDICAE','NAVIGATION','PILOTING','TECH')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- WARRIOR skills
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Warrior' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('ATHLETICS','FORTITUDE','MEDICAE','MELEE','RANGED','REFLEXES')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- ZEALOT skills
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Zealot' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('DISCIPLINE','FORTITUDE','LINGUISTICS','LORE','MELEE','PRESENCE')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

END $$;


-- =====================================================================
-- 10. SPECIALIZATION CHOICE GROUP OPTIONS
--     Each role gets choices_required=2, one SPECIALIZATION group.
--     Source: pp. 75-80.
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN

    -- -----------------------------------------------------------------------
    -- INTERLOCUTOR — choose 2 from Intuition / Presence / Rapport specs
    -- -----------------------------------------------------------------------
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Interlocutor'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg
          WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Interlocutor' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Intuition
        'GROUP', 'PEOPLE', 'SURROUNDINGS',
        -- Presence
        'INTERROGATION', 'INTIMIDATION', 'LEADERSHIP',
        -- Rapport
        'ANIMALS', 'CHARM', 'DECEPTION', 'HAGGLE', 'INQUIRY'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- -----------------------------------------------------------------------
    -- MYSTIC — choose 2 from Discipline(Fear) / Linguistics(Forbidden) /
    --          Lore(Forbidden) / Awareness(Psyniscience) / Psychic Mastery
    -- -----------------------------------------------------------------------
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Mystic'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg
          WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Mystic' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Discipline
        'FEAR',
        -- Linguistics
        'FORBIDDEN (LINGUISTICS)',
        -- Lore
        'FORBIDDEN (LORE)',
        -- Awareness
        'PSYNISCIENCE (RESTRICTED)',
        -- Psychic Mastery
        'BIOMANCY', 'DIVINATION', 'PYROMANCY', 'TELEKINESIS', 'TELEPATHY'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- -----------------------------------------------------------------------
    -- PENUMBRA — choose 2 from Ranged / Reflexes / Stealth specs
    -- -----------------------------------------------------------------------
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Penumbra'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg
          WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Penumbra' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Ranged
        'LONG GUNS', 'ORDNANCE', 'PISTOLS', 'THROWN',
        -- Reflexes
        'ACROBATICS', 'BALANCE', 'DODGE',
        -- Stealth
        'CONCEAL', 'HIDE', 'MOVE SILENTLY'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- -----------------------------------------------------------------------
    -- SAVANT — choose 2 from Lore / Medicae / Tech specs
    -- -----------------------------------------------------------------------
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Savant'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg
          WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Savant' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Lore
        'ACADEMICS', 'ADEPTUS TERRA', 'PLANET', 'SECTOR',
        'THEOLOGY (RESTRICTED)', 'FORBIDDEN (LORE)',
        -- Medicae
        'ANIMAL', 'HUMAN', 'FORBIDDEN (MEDICAE)',
        -- Tech
        'AUGMETICS (RESTRICTED)', 'ENGINEERING', 'SECURITY'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- -----------------------------------------------------------------------
    -- WARRIOR — choose 2 from Melee / Ranged / Reflexes specs
    -- -----------------------------------------------------------------------
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Warrior'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg
          WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Warrior' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Melee
        'BRAWLING', 'ONE-HANDED', 'TWO-HANDED',
        -- Ranged
        'LONG GUNS', 'ORDNANCE', 'PISTOLS', 'THROWN',
        -- Reflexes
        'ACROBATICS', 'BALANCE', 'DODGE'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- -----------------------------------------------------------------------
    -- ZEALOT — choose 2 from Discipline / Lore / Melee specs
    -- -----------------------------------------------------------------------
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Zealot'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg
          WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Zealot' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Discipline
        'COMPOSURE', 'FEAR', 'PSYCHIC',
        -- Lore
        'ACADEMICS', 'ADEPTUS TERRA', 'PLANET', 'SECTOR',
        'THEOLOGY (RESTRICTED)', 'FORBIDDEN (LORE)',
        -- Melee
        'BRAWLING', 'ONE-HANDED', 'TWO-HANDED'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

END $$;


-- =====================================================================
-- DONE.
-- What's NOT covered here:
--   - Mystic's automatic Psyker talent (needs a role_talent table)
--   - Warrior's full list of Mundane Melee weapons (p.127+)
--   - Skill descriptions and characteristic links (need p.91+ data)
-- =====================================================================