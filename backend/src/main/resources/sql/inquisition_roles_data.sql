-- =====================================================================
-- IMPERIUM MALEDICTUM — INQUISITION ROLES DATA
-- Source: IM Inquisition Player's Guide (pp. 55–67)
-- Run AFTER roles_data.sql and specializations_data.sql
-- =====================================================================


-- =====================================================================
-- 1. SUPPLEMENT TALENTS (22 new talents from this supplement)
-- =====================================================================
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    ('AMALATHIAN APPRENTICE',    ''),
    ('APOSTLE OF THE LEX',       ''),
    ('BALLISTIC FORENSICS',      ''),
    ('BLUNT FORCE AUTHORITY',    ''),
    ('CLANDESTINE',              ''),
    ('CONDEMNOR''S BOON',        ''),
    ('CULT INFILTRATOR',         ''),
    ('CYPHERIST',                ''),
    ('FAMILIAR BONDED',          ''),
    ('GUT INSTINCT',             ''),
    ('HARDENED SUSPICION',       ''),
    ('INSPIRED DEFIANCE',        ''),
    ('LOGICAL LIAR',             ''),
    ('MANY MASKS',               ''),
    ('SECURITY AUGUR',           ''),
    ('SHADOW OPERATIVE',         ''),
    ('SUBTLE INFLUENCER',        ''),
    ('SUBTLE MUTATION',          'Something lies in your genetics that isn''t quite Human, twisting you physically or mentally farther away from the average Imperial citizen. Your Patron may know about your mutation, letting it slide, or be oblivious to it. On face value, you can pass unremarked. But if anyone knew the truth, they''d likely treat you as another abomination. When you gain this Talent, roll for a Positive Mutation and a Negative Mutation on the Subtle Mutations Table, and consult the entries on the Mutations and Malignancies Tables (Imperium Maledictum, pages 222–223) to see their effects. Additionally, whenever you gain a Mutation or Malignancy in the future due to Corruption, you may choose to roll on the Subtle Mutations Table instead, but you must roll for both a Positive and Negative Mutation (roll again if you would gain a duplicate).'),
    ('SUBTLE PSYKER',            ''),
    ('TAINTED VESSEL',           ''),
    ('UNWAVERING WILL',          ''),
    ('YOU DIDN''T SEE ANYTHING', '')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

UPDATE talent
SET description = 'Something lies in your genetics that isn''t quite Human, twisting you physically or mentally farther away from the average Imperial citizen. Your Patron may know about your mutation, letting it slide, or be oblivious to it. On face value, you can pass unremarked. But if anyone knew the truth, they''d likely treat you as another abomination. When you gain this Talent, roll for a Positive Mutation and a Negative Mutation on the Subtle Mutations Table, and consult the entries on the Mutations and Malignancies Tables (Imperium Maledictum, pages 222–223) to see their effects. Additionally, whenever you gain a Mutation or Malignancy in the future due to Corruption, you may choose to roll on the Subtle Mutations Table instead, but you must roll for both a Positive and Negative Mutation (roll again if you would gain a duplicate).'
WHERE name = 'SUBTLE MUTATION' AND (description IS NULL OR description = '');

-- Core-book talents referenced in Inquisition roles but not yet in DB
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    ('AIM TRAINING',     ''),
    ('EVER VIGILANT',    ''),
    ('HIT AND RUN',      ''),
    ('APPLIED ANATOMY',  ''),
    ('BONE BREAKER',     ''),
    ('FIELD MEDICAE',    ''),
    ('MEDICAE MAVERICK', ''),
    ('PHLEBOTOMIST',     ''),
    ('I AM THE LAW',     ''),
    ('DIRTY FIGHTING',   '')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);


-- =====================================================================
-- 2. NEW INVENTORY ITEMS
-- =====================================================================
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT name, category, subcategory
FROM (VALUES
    -- Weapon modifications
    ('Mono-edge',             'WEAPON_MODIFICATION',        'COMBAT_ATTACHMENTS'),
    ('Omnispex',              'WEAPON_MODIFICATION',        'COMBAT_ATTACHMENTS'),
    -- Ranged weapons
    ('Web Pistol',            'RANGED_WEAPON',              'EXOTIC'),
    ('Hand Cannon',           'RANGED_WEAPON',              'SOLID_PROJECTILE'),
    ('Shotgun (Pump Action)', 'RANGED_WEAPON',              'SOLID_PROJECTILE'),
    -- Armour
    ('Light Leathers',        'ARMOUR',                     'BASIC'),
    ('Armoured Greatcoat',    'ARMOUR',                     'BASIC'),
    -- Tools / equipment
    ('Respirator',            'TOOLS',                      NULL),
    ('Chirurgeon''s Kit',     'TOOLS',                      NULL),
    ('Chrono',                'TOOLS',                      NULL),
    ('Monotask Servo-Skull',  'TOOLS',                      NULL),
    ('Excruciator Kit',       'TOOLS',                      NULL),
    ('Manacles',              'TOOLS',                      NULL)
) AS v(name, category, subcategory)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);


-- =====================================================================
-- 3. NEW SPECIALIZATION: Disguise (Stealth) — referenced in Many Masks
-- =====================================================================
INSERT INTO specialization (name, description)
SELECT 'DISGUISE',
       'Training in adopting convincing disguises and alternate personas, including physical alteration of appearance.'
WHERE NOT EXISTS (SELECT 1 FROM specialization s WHERE s.name = 'DISGUISE');

INSERT INTO skill_specializations (skill_id, specialization_id)
SELECT s.id, sp.id FROM skill s, specialization sp
WHERE s.name = 'STEALTH' AND sp.name = 'DISGUISE'
  AND NOT EXISTS (
      SELECT 1 FROM skill_specializations ss
      WHERE ss.skill_id = s.id AND ss.specialization_id = sp.id
  );


-- =====================================================================
-- 4. ROLES
-- =====================================================================
INSERT INTO role (name)
SELECT name FROM (VALUES
    ('Assassin'),
    ('Cruciator'),
    ('Explicator'),
    ('Seeker')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM role r WHERE r.name = v.name);


-- =====================================================================
-- 5. FIXED INVENTORY PER ROLE
-- =====================================================================

-- ASSASSIN: Knife, Mono-edge, Heavy Leathers, Magnoculars, Survival Gear
-- Note: pistol choice also comes with Omnispex (Laspistol) or Silencer (Autopistol)
--       both mods are added as fixed so the player applies whichever fits their choice.
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Assassin'
  AND i.name IN ('Knife', 'Mono-edge', 'Omnispex', 'Silencer',
                 'Heavy Leathers', 'Magnoculars', 'Survival Gear')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- CRUCIATOR: Knife, Respirator, Chirurgeon's Kit, Chrono, Writing Kit
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Cruciator'
  AND i.name IN ('Knife', 'Respirator', 'Chirurgeon''s Kit', 'Chrono', 'Writing Kit')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- EXPLICATOR: Knife, Monotask Servo-Skull, Writing Kit, Chrono, Dataslate, Pict Recorder
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Explicator'
  AND i.name IN ('Knife', 'Monotask Servo-Skull', 'Writing Kit',
                 'Chrono', 'Dataslate', 'Pict Recorder')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- SEEKER: Knife, Shotgun (Pump Action), Magnoculars, Armoured Greatcoat, Manacles, Vox Bead, Writing Kit
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'Seeker'
  AND i.name IN ('Knife', 'Shotgun (Pump Action)', 'Magnoculars',
                 'Armoured Greatcoat', 'Manacles', 'Vox Bead', 'Writing Kit')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );


-- =====================================================================
-- 6. ROLE CHOICE GROUPS (talent, skill — without specialization yet)
-- =====================================================================

-- ASSASSIN — choose 2 talents, 3 skill advances
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Assassin'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT');

INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Assassin'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');

-- CRUCIATOR — choose 2 talents, 3 skill advances
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Cruciator'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT');

INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Cruciator'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');

-- EXPLICATOR — choose 2 talents, 3 skill advances
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Explicator'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT');

INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Explicator'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');

-- SEEKER — choose 2 talents, 3 skill advances
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'TALENT' FROM role r WHERE r.name = 'Seeker'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'TALENT');

INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'Seeker'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');


-- =====================================================================
-- 7. INVENTORY CHOICE GROUPS + OPTIONS
-- =====================================================================

-- ASSASSIN: melee, pistol, longarm
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Assassin';

    -- melee: Great Weapon OR Chainsword
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Great Weapon', 'Chainsword');

    -- pistol: Laspistol OR Autopistol
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Laspistol', 'Autopistol');

    -- longarm: Sniper Rifle OR Long Las
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Sniper Rifle', 'Long Las');
END $$;

-- CRUCIATOR: sidearm, secondary, armour, record device
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Cruciator';

    -- sidearm: Laspistol OR Stub Revolver
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Laspistol', 'Stub Revolver');

    -- secondary: Web Pistol OR Hand Flamer
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Web Pistol', 'Hand Flamer');

    -- armour: Robes OR Light Leathers
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Robes', 'Light Leathers');

    -- record device: Dataslate OR Pict Recorder
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Dataslate', 'Pict Recorder');
END $$;

-- EXPLICATOR: sidearm only
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Explicator';

    -- sidearm: Autopistol OR Stub Revolver
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Autopistol', 'Stub Revolver');
END $$;

-- SEEKER: melee, secondary, kit item
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'Seeker';

    -- melee: Any Mundane Melee OR Chainsword
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE (
        (i.inventory_category = 'MELEE_WEAPON' AND i.inventory_subcategory = 'MUNDANE')
        OR i.name = 'Chainsword'
    )
    AND i.name NOT IN ('Unarmed', 'Improvised (One-handed)', 'Improvised (Two-handed)');

    -- secondary: Hand Cannon OR Hand Flamer
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Hand Cannon', 'Hand Flamer');

    -- kit: Multicompass OR Excruciator Kit
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;
    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i WHERE i.name IN ('Multicompass', 'Excruciator Kit');
END $$;


-- =====================================================================
-- 8. TALENT CHOICE GROUP OPTIONS
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN

    -- ASSASSIN: choose 2 from 8
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Assassin' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('AIM TRAINING', 'BURGLAR', 'EVER VIGILANT', 'HIT AND RUN',
                     'SECRET IDENTITY', 'SHADOW OPERATIVE', 'SKULKER', 'UNWAVERING WILL')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- CRUCIATOR: choose 2 from 8
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Cruciator' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('APPLIED ANATOMY', 'BALLISTIC FORENSICS', 'BONE BREAKER', 'CHIRURGEON',
                     'FIELD MEDICAE', 'GUT INSTINCT', 'MEDICAE MAVERICK', 'PHLEBOTOMIST')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- EXPLICATOR: choose 2 from 8
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Explicator' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('ARTIST', 'CYPHERIST', 'DATA DELVER', 'EIDETIC MEMORY',
                     'FORBIDDEN KNOWLEDGE', 'GOTHIC GIBBERISH', 'I AM THE LAW', 'LAWBRINGER')
      AND NOT EXISTS (
          SELECT 1 FROM role_talent_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.talent_id = t.id
      );

    -- SEEKER: choose 2 from 8
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Seeker' AND cg.choice_type = 'TALENT';

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp, t.id FROM talent t
    WHERE t.name IN ('AIR OF AUTHORITY', 'ATTENTIVE ASSISTANT', 'BLUNT FORCE AUTHORITY',
                     'CONDEMN THE WITCH', 'DIRTY FIGHTING', 'EVER VIGILANT',
                     'GUT INSTINCT', 'LAWBRINGER')
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

    -- ASSASSIN: Awareness, Dexterity, Intuition, Logic, Reflexes, Stealth
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Assassin' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('AWARENESS', 'DEXTERITY', 'INTUITION', 'LOGIC', 'REFLEXES', 'STEALTH')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- CRUCIATOR: Medicae, Logic, Dexterity, Discipline, Intuition, Fortitude
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Cruciator' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('MEDICAE', 'LOGIC', 'DEXTERITY', 'DISCIPLINE', 'INTUITION', 'FORTITUDE')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- EXPLICATOR: Lore, Logic, Linguistics, Discipline, Intuition, Fortitude
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Explicator' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('LORE', 'LOGIC', 'LINGUISTICS', 'DISCIPLINE', 'INTUITION', 'FORTITUDE')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

    -- SEEKER: Awareness, Discipline, Fortitude, Logic, Navigation, Presence
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'Seeker' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('AWARENESS', 'DISCIPLINE', 'FORTITUDE', 'LOGIC', 'NAVIGATION', 'PRESENCE')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );

END $$;


-- =====================================================================
-- 10. SPECIALIZATION CHOICE GROUPS + OPTIONS
-- =====================================================================
DO $$
DECLARE v_grp BIGINT;
BEGIN

    -- ASSASSIN: choose 2 from Awareness / Reflexes / Stealth specs
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Assassin'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Assassin' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        'HEARING', 'SIGHT', 'SMELL', 'TASTE', 'TOUCH',
        'ACROBATICS', 'BALANCE', 'DODGE',
        'CONCEAL', 'DISGUISE', 'HIDE', 'MOVE SILENTLY'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- CRUCIATOR: choose 2 from Medicae / Dexterity / Fortitude specs
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Cruciator'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Cruciator' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        'ANIMAL', 'HUMAN', 'FORBIDDEN (MEDICAE)',
        'LOCK PICKING', 'PICKPOCKET', 'SLEIGHT OF HAND', 'DEFUSE (RESTRICTED)',
        'ENDURANCE', 'PAIN', 'POISON'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- EXPLICATOR: choose 2 from Lore / Linguistics / Intuition specs
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Explicator'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Explicator' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        'ACADEMICS', 'ADEPTUS TERRA', 'PLANET', 'SECTOR',
        'THEOLOGY (RESTRICTED)', 'FORBIDDEN (LORE)',
        'CIPHER', 'HIGH GOTHIC', 'FORBIDDEN (LINGUISTICS)',
        'GROUP', 'PEOPLE', 'SURROUNDINGS'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

    -- SEEKER: choose 2 from Fortitude / Navigation / Presence specs
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'Seeker'
      AND NOT EXISTS (
          SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION'
      )
    RETURNING id INTO v_grp;

    IF v_grp IS NULL THEN
        SELECT cg.id INTO v_grp FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
        WHERE r.name = 'Seeker' AND cg.choice_type = 'SPECIALIZATION' LIMIT 1;
    END IF;

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        'ENDURANCE', 'PAIN', 'POISON',
        'SURFACE', 'TRACKING', 'VOID',
        'INTERROGATION', 'INTIMIDATION', 'LEADERSHIP'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );

END $$;


-- =====================================================================
-- DONE.
-- What's NOT covered here (may need manual review):
--   - "I AM THE LAW" talent — no asterisk in book; description left empty
--   - Assassin pistol+mod bundles: Omnispex/Silencer added as fixed items;
--     player applies whichever matches their Laspistol/Autopistol choice
--   - Chirurgeon's Kit added as new item; may be same as "Chirurgeon's Tools" in DB
-- =====================================================================