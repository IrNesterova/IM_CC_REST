-- =====================================================================
-- INQUISITION SUPPLEMENT — ORIGIN SKILL & SPECIALIZATION ADVANCES
-- Run AFTER Hibernate creates origin_skill / origin_specialization tables
-- and AFTER inquisition_origins.sql has been executed.
-- =====================================================================

-- =====================================================================
-- 1. FIX BANISHER — remove wrong secondary characteristics
--    "+5 to either Discipline, Melee, or Ranged" is a SKILL advance,
--    not a characteristic bonus. The WIL/WS/BS secondary rows are wrong.
-- =====================================================================
DELETE FROM character_origin
WHERE origin_id = (SELECT id FROM origin WHERE name = 'BANISHER')
  AND primary_char = false;


-- =====================================================================
-- 2. ORIGIN SKILL ADVANCES (origin_skill)
-- =====================================================================

-- BANISHER: choose one of DISCIPLINE / MELEE / RANGED (1 advance each)
INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, true
FROM origin o, skill s
WHERE o.name = 'BANISHER' AND s.name = 'DISCIPLINE'
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);

INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, true
FROM origin o, skill s
WHERE o.name = 'BANISHER' AND s.name = 'MELEE'
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);

INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, true
FROM origin o, skill s
WHERE o.name = 'BANISHER' AND s.name = 'RANGED'
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);


-- =====================================================================
-- 3. ORIGIN SPECIALIZATION ADVANCES (origin_specialization)
-- =====================================================================

-- APOSTATE OF THE CREED: choose FORBIDDEN (LORE) or THEOLOGY (RESTRICTED) — 2 advances each
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 2, true
FROM origin o, skill sk, specialization sp
WHERE o.name = 'APOSTATE OF THE CREED' AND sk.name = 'LORE' AND sp.name = 'FORBIDDEN (LORE)'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);

INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 2, true
FROM origin o, skill sk, specialization sp
WHERE o.name = 'APOSTATE OF THE CREED' AND sk.name = 'LORE' AND sp.name = 'THEOLOGY (RESTRICTED)'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);

-- ILLISEAREAN FENSTALKER: Lore (Forbidden) — 1 advance (auto-granted)
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 1, false
FROM origin o, skill sk, specialization sp
WHERE o.name = 'ILLISEAREAN FENSTALKER' AND sk.name = 'LORE' AND sp.name = 'FORBIDDEN (LORE)'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);

-- IRON ARCHIPELAGO PIRATE: Lore (Forbidden) — 1 advance (auto-granted)
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 1, false
FROM origin o, skill sk, specialization sp
WHERE o.name = 'IRON ARCHIPELAGO PIRATE' AND sk.name = 'LORE' AND sp.name = 'FORBIDDEN (LORE)'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);

-- GANG INFILTRATOR: Lore (Forbidden) — 1 advance (auto-granted)
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 1, false
FROM origin o, skill sk, specialization sp
WHERE o.name = 'GANG INFILTRATOR' AND sk.name = 'LORE' AND sp.name = 'FORBIDDEN (LORE)'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);

-- AIDE TO ORDERS DIALOGUS: Linguistics (Forbidden) — 1 advance (auto-granted)
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 1, false
FROM origin o, skill sk, specialization sp
WHERE o.name = 'AIDE TO ORDERS DIALOGUS' AND sk.name = 'LINGUISTICS' AND sp.name = 'FORBIDDEN (LINGUISTICS)'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);

-- ROGUE TRADER RETINUE: Linguistics (Forbidden) — 1 advance (auto-granted)
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 1, false
FROM origin o, skill sk, specialization sp
WHERE o.name = 'ROGUE TRADER RETINUE' AND sk.name = 'LINGUISTICS' AND sp.name = 'FORBIDDEN (LINGUISTICS)'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);


-- =====================================================================
-- 4. FIX CULT INFILTRATOR
--    "+5 Stealth" is a SKILL advance, not characteristic bonus.
--    Also: inventory was Cultist Robes → should be Shoddy Vox Bead.
--    And talent Familiar Terrain was missing.
-- =====================================================================

-- Remove wrong AG secondary characteristic
DELETE FROM character_origin
WHERE origin_id = (SELECT id FROM origin WHERE name = 'CULT INFILTRATOR')
  AND primary_char = false;

-- Add STEALTH skill advance (auto-granted, no choice)
INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, false
FROM origin o, skill s
WHERE o.name = 'CULT INFILTRATOR' AND s.name = 'STEALTH'
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);

-- Add Familiar Terrain talent (if not in talent table yet)
INSERT INTO talent (name, description)
SELECT 'FAMILIAR TERRAIN', 'You have extensive familiarity with a particular type of terrain. Choose an appropriate world option when taking this Talent (e.g. Hive World, Feral World, Void). You gain various advantages when operating in that environment (IM Core, p.108).'
WHERE NOT EXISTS (SELECT 1 FROM talent WHERE name = 'FAMILIAR TERRAIN');

-- Link Familiar Terrain to CULT INFILTRATOR
INSERT INTO origin_talent (origin_id, talent_id)
SELECT o.id, t.id FROM origin o, talent t
WHERE o.name = 'CULT INFILTRATOR' AND t.name = 'FAMILIAR TERRAIN'
  AND NOT EXISTS (SELECT 1 FROM origin_talent ot WHERE ot.origin_id = o.id AND ot.talent_id = t.id);

-- Remove wrong inventory entry (Cultist Robes + Shoddy modifier)
DELETE FROM origin_inventory_modifier
WHERE origin_inventory_id IN (
    SELECT oi.id FROM origin_inventory_item oi
    JOIN origin o ON o.id = oi.origin_id
    JOIN inventory i ON i.id = oi.inventory_id
    WHERE o.name = 'CULT INFILTRATOR' AND i.name = 'Cultist Robes'
);

DELETE FROM origin_inventory_item
WHERE origin_id = (SELECT id FROM origin WHERE name = 'CULT INFILTRATOR')
  AND inventory_id = (SELECT id FROM inventory WHERE name = 'Cultist Robes');

-- Add Shoddy Vox Bead
DO $$
DECLARE v_shoddy_id BIGINT;
BEGIN
    SELECT id INTO v_shoddy_id FROM item_modifier WHERE name = 'Shoddy';

    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'CULT INFILTRATOR' AND i.name = 'Vox Bead'
          AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;
END $$;


-- =====================================================================
-- 5. FIX UNUSUAL AUGMENT
--    Starting item is "Any Augmetic of your choice, with either Bulky
--    or Ugly Trait" — not a Shoddy Combi-Tool.
-- =====================================================================

-- Add Bulky and Ugly as trait modifiers (if missing)
INSERT INTO item_modifier (name, type, description)
SELECT 'Bulky', 'trait', 'This item is large and cumbersome. The wearer suffers a -10 penalty to Reflexes Tests and cannot benefit from the Dodge Specialisation.'
WHERE NOT EXISTS (SELECT 1 FROM item_modifier WHERE name = 'Bulky');

INSERT INTO item_modifier (name, type, description)
SELECT 'Ugly', 'trait', 'This augmetic is hideous or unsettling in appearance. The wearer suffers a -10 penalty to Fellowship-based Tests when the augmetic is visible, unless the target is already aware of it.'
WHERE NOT EXISTS (SELECT 1 FROM item_modifier WHERE name = 'Ugly');

-- Remove wrong inventory entry (Shoddy Combi-Tool) — augmetic is now player-chosen via UI
DELETE FROM origin_inventory_modifier
WHERE origin_inventory_id IN (
    SELECT oi.id FROM origin_inventory_item oi
    JOIN origin o ON o.id = oi.origin_id
    JOIN inventory i ON i.id = oi.inventory_id
    WHERE o.name = 'UNUSUAL AUGMENT' AND i.name = 'Combi-Tool'
);

DELETE FROM origin_inventory_item
WHERE origin_id = (SELECT id FROM origin WHERE name = 'UNUSUAL AUGMENT')
  AND inventory_id = (SELECT id FROM inventory WHERE name = 'Combi-Tool');