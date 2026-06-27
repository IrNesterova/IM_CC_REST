-- =====================================================================
-- ADEPTUS MECHANICUS SUPPLEMENT — ELECTRO-PRIEST ROLE
-- Source: Assembly of Means supplement
-- Run AFTER: roles_data.sql, am_roles_data.sql, am_weapons.sql,
--            specializations_data.sql
-- =====================================================================

-- =====================================================================
-- 1. NEW TALENTS
-- =====================================================================
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    ('ELECTRO-PRIEST INDOCTRINATION', 'ELECTRO-PRIEST INDOCTRINATION
You are trained to capture, conserve and share the
sacred Motive Force. Indoctrinated into the Electro
Priesthood, you have gained the following abilities:
0 When your Motive Force Charges are above half
your Maximum Threshold, you have +1 Armour
(All Locations).
0 You can increase your Motive Force Charges to
your threshold by spending a minute connected
to a power source, feeding from its stored energy.
This action may potentially deactivate the machine
(consult the Motive Force and Machines Table for
reference).
0 You can reduce your Motive Force Charges to
zero by spending a minute connected to a power
source, feeding it your stored energy and potentially
powering it (consult the Motive Force and Machines
Table for reference).'),
    ('CORPUSCARII BENEDICTIONS',      'Requirement: You have no ‘Fulgurite’ named Talents
Learned in the rites of the Corpuscarii, you can anoint
a machine spirit with the Motive Force, energising it
and the device it inhabits with a simple touch. You can
touch an electronically powered device or machine as a
free action, expending 1 Motive Force Charge. For the
next round, creatures have Advantage on any Tech or
Piloting Test attempted on or while using the device.'),
    ('CORPUSCARII MASTERY',           'Requirement: You have no ‘Fulgurite’ named Talents
You can extend the Motive Force to empower
electronically powered devices and vehicles you touch,
instantly causing them to activate, bypassing startup
sequences. To do so, make a Fortitude Test as an
Action, the Difficulty of which is determined by the
size of the Target (see the Motive Force and Machines
Table). If successful, the machine activates, and you
expend Motive Force Charges determined by the
target’s size. You cannot use this Talent to activate a
device that requires a higher number of Motive Force
Charges than you currently have.'),
    ('FULGURITE HEX',                 'Requirement: You have no ‘Corpuscarii’ named Talents
Learned in the rites of the Fulgurite, you can reap the
Motive Force to usher a machine spirit and the device
it inhabits into a sluggish near-slumber, enervating it
with a simple touch. You can touch an electronically
powered device as a free action, gaining 1 Motive
Force Charge. For the next round, creatures have
Disadvantage on any Tech or Piloting Test attempted
using the device.'),
    ('FULGURITE MASTERY',             'Requirement: You have no ‘Corpuscarii’ named Talents
You can drain the Motive Force from electronically
powered devices and vehicles you touch, instantly
shutting them down. To do so, make a Fortitude
(Endurance) Test as an Action, the Difficulty of which
is determined by the target’s size (see the Motive Force
and Machines Table). If successful, the machine shuts
down, and you gain Motive Force Charges determined
by the size of the target. You cannot use this Talent to
drain Motive Force charges from a device if doing so
would take you past your maximum threshold.')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

-- =====================================================================
-- 2. NEW INVENTORY — Electoo Matrix (augmetic)
-- =====================================================================
DO $$
DECLARE v_id BIGINT;
BEGIN
    SELECT id INTO v_id FROM inventory WHERE name = 'Electoo Matrix';
    IF v_id IS NULL THEN
        INSERT INTO inventory (name, inventory_category, inventory_subcategory)
        VALUES ('Electoo Matrix', 'AUGMETIC', NULL)
        RETURNING id INTO v_id;
    END IF;

    INSERT INTO augmetic (id, description)
    VALUES (v_id, 'The Electoo Matrix forms the central augmetic to
the fanaticism of the Electro-Priests. The network of
subdermal cabling transforms the bearer’s body into
a living conduit for the Motive Force, their bodies
practically glistening with the light of its blessings. So
fundamental are the sensory effects of this change that
the bear may perceive the electric signals that surround
them, even including the bioelectric signals of living
creatures. Many Electro-Priests wear blindfolds, that
they might perceive their surroundings only through
the sensations they experience from the Motive Force.
Your Electoo Matrix allows you to sense electrical
currents in your surroundings, including any electrical
devices and the bioelectric signals of living creatures
within Short Range. While Blinded, you do not suffer
Disadvantage on Melee and Dodge (Reflexes) Tests.')
    ON CONFLICT (id) DO NOTHING;
END $$;

-- =====================================================================
-- 3. ROLE
-- =====================================================================
INSERT INTO role (name, source_book)
SELECT 'ELECTRO-PRIEST', 'AM'
WHERE NOT EXISTS (SELECT 1 FROM role r WHERE r.name = 'ELECTRO-PRIEST');

-- =====================================================================
-- 4. FIXED INVENTORY
-- Electoo Matrix, Backpack/Slings, Survival Gear, Vox Bead
-- =====================================================================
INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name = 'ELECTRO-PRIEST'
  AND i.name IN ('Micro-Bead/Vox Bead')
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- =====================================================================
-- 5. TALENT CHOICE GROUPS (two groups — use DO $$ for both)
-- Group 1: fixed — Electro-Priest Indoctrination (choose 1 of 1)
-- Group 2: optional — choose 1 from 8
-- =====================================================================
DO $$
DECLARE v_role_id BIGINT; v_grp1 BIGINT; v_grp2 BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'ELECTRO-PRIEST';

    IF EXISTS (SELECT 1 FROM role_choice_group WHERE role_id = v_role_id AND choice_type = 'TALENT') THEN
        RETURN;
    END IF;

    -- Forced: Electro-Priest Indoctrination
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'TALENT') RETURNING id INTO v_grp1;

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp1, t.id FROM talent t WHERE t.name = 'ELECTRO-PRIEST INDOCTRINATION';

    -- Optional: choose 1 from 8
    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'TALENT') RETURNING id INTO v_grp2;

    INSERT INTO role_talent_choice_group (role_choice_group_id, talent_id)
    SELECT v_grp2, t.id FROM talent t
    WHERE t.name IN (
        'DEADEYE', 'DRILLED', 'FAITHFUL (CULT OF MARS)', 'FLESH IS WEAK',
        'FLAGELLANT', 'FRENZY', 'TENACIOUS', 'TWO-HANDED CLEAVE'
    );
END $$;

-- =====================================================================
-- 6. SKILL CHOICE GROUP
-- 3 advances from: Awareness, Discipline, Fortitude, Melee, Ranged, Tech
-- =====================================================================
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 3, 'SKILL' FROM role r WHERE r.name = 'ELECTRO-PRIEST'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SKILL');

DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'ELECTRO-PRIEST' AND cg.choice_type = 'SKILL';

    INSERT INTO role_skill_choice_group (role_choice_group_id, skill_id)
    SELECT v_grp, s.id FROM skill s
    WHERE s.name IN ('AWARENESS', 'DISCIPLINE', 'FORTITUDE', 'MELEE', 'RANGED', 'TECH')
      AND NOT EXISTS (
          SELECT 1 FROM role_skill_choice_group x WHERE x.role_choice_group_id = v_grp AND x.skill_id = s.id
      );
END $$;

-- =====================================================================
-- 7. SPECIALIZATION CHOICE GROUP
-- 2 advances from Awareness, Discipline, or Fortitude specs
-- =====================================================================
INSERT INTO role_choice_group (role_id, choices_required, choice_type)
SELECT r.id, 2, 'SPECIALIZATION' FROM role r WHERE r.name = 'ELECTRO-PRIEST'
  AND NOT EXISTS (SELECT 1 FROM role_choice_group cg WHERE cg.role_id = r.id AND cg.choice_type = 'SPECIALIZATION');

DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg JOIN role r ON cg.role_id = r.id
    WHERE r.name = 'ELECTRO-PRIEST' AND cg.choice_type = 'SPECIALIZATION';

    INSERT INTO role_specialization_choice_group (role_choice_group_id, specialization_id)
    SELECT v_grp, sp.id FROM specialization sp
    WHERE sp.name IN (
        -- Awareness
        'HEARING', 'SIGHT', 'SMELL', 'TASTE', 'TOUCH', 'PSYNISCIENCE (RESTRICTED)',
        -- Discipline
        'COMPOSURE', 'FEAR', 'PSYCHIC',
        -- Fortitude
        'ENDURANCE', 'PAIN', 'POISON'
    )
      AND NOT EXISTS (
          SELECT 1 FROM role_specialization_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.specialization_id = sp.id
      );
END $$;

-- =====================================================================
-- 8. INVENTORY CHOICE GROUP
-- Electrostatic Gauntlets OR Electroleech Stave
-- =====================================================================
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'ELECTRO-PRIEST';

    IF EXISTS (SELECT 1 FROM role_choice_group WHERE role_id = v_role_id AND choice_type = 'INVENTORY') THEN
        RETURN;
    END IF;

    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Electrostatic Gauntlets', 'Electroleech Stave');
END $$;