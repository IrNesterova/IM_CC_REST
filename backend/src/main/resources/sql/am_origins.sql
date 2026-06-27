-- =====================================================================
-- ASSEMBLY OF MEANS — ADEPTUS MECHANICUS SUPPLEMENT ORIGINS
-- Source: Assembly of Means supplement
-- Run AFTER: Hibernate startup (creates origin_category, origin_talent,
--            origin_inventory_item, origin_inventory_modifier, origin_skill,
--            origin_specialization tables), inventory.sql, roles_data.sql
-- =====================================================================

-- =====================================================================
-- 1. MISSING TALENTS
-- =====================================================================
INSERT INTO talent (name, description)
SELECT v.name, v.description FROM (VALUES
    ('VOID LEGS',   'You are accustomed to life in the void and suffer no penalties in zero-gravity environments. You are not subject to space sickness.'),
    ('DATA DELVER', 'Your training allows you to rapidly sift through large data repositories. You reduce the time required for Logic Tests involving data retrieval by half.')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

-- =====================================================================
-- 2. MISSING INVENTORY ITEMS
-- =====================================================================
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT 'Void Suit', 'CLOTHING_AND_PERSONAL_GEAR', NULL
WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Void Suit');

INSERT INTO generic_item (id, description)
SELECT i.id, 'A sealed suit designed to protect the wearer in the vacuum of space for a limited duration.'
FROM inventory i WHERE i.name = 'Void Suit'
ON CONFLICT (id) DO NOTHING;

-- =====================================================================
-- 3. SHODDY MODIFIER (ensure exists)
-- =====================================================================
INSERT INTO item_modifier (name, type, description)
SELECT 'Shoddy', 'flaw', 'Shoddy items impose a -10 penalty on Tests directly involving that item.'
WHERE NOT EXISTS (SELECT 1 FROM item_modifier WHERE name = 'Shoddy');

-- =====================================================================
-- 4. ORIGINS
-- =====================================================================
INSERT INTO origin (name, description, source_book) VALUES
('ASSEMBLY OF MEANS',
 'A Goliath-class factory ship launched from the Drimor Subsector, the Assembly of Means consumes millions of tonnes of raw ore and transmutes it into plasma to fuel the reactors of the Imperium. Currently adrift on the edge of the Jade Veil and under Adeptus Mechanicus repair, the vessel risks becoming a Space Hulk. You served aboard it, learning the stewardship of knowledge and technical skills for repairing and maintaining the machine. The drifting Goliath has marked you with its strangeness — disquieted machine spirits, ghost ships, errant signals, and countless missing tech-thralls.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('DANNOCK III',
 'A dry and dusty forge world near the end of a stable Warp route in the Cytheris Subsector, Dannock III has vast flat plains of moderate-grade minerals and a higher concentration of silica crystals. The world is perpetually shrouded in static storms, the air alive with a crackle almost felt on flesh. You may have toiled in forge temples, data-temples, or the silica mines, consumed with tension and suspicion — the current Fabricator General has fallen from political favour, and rumours abound of Tech-Priests accumulating their own power. Whispers of hereteks and the Heresy of Innovation loom like a storm.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('ESKUTCHAX',
 'One of the most powerful Adeptus Mechanicus forge worlds, Eskutchax was gifted to the Mechanicus by Lord Commander Solar Macharius and quickly converted to produce equipment for the Astra Militarum. The Eskutchax pattern lasgun is renowned throughout the sector. You might have toiled in the forge-fanes, served among the Technoarcheologists, or even among the Skitarii legions. During the Noctis Aeterna, Eskutchax was besieged by a Chaos Fleet, and though the siege was lifted, corruption has taken root in a third of the world — Tech-Priests toil day after day to sanctify and purify it.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('HEXAS PANAN',
 'Located in the Andosk Subsector on the border of the Jade Veil, Hexas Panan benefits from movement of resources through Warp routes around the obfuscating Jade Veil. Its most prominent feature is a colossal Explorator compound, a venture of considerable resources and political capital among high-ranking Tech-Priests. Now that the Noctis Aeterna''s shadows dissipate, vessels gather in orbit for the launch of a new Explorator Fleet. You likely served manufacturing or installing pieces of spacefaring vessels, and may have been assigned to oversee vital vox-antenna or macrocannon batteries. Yet shadows fester — some Tech-Priests may have turned to forbidden knowledge in the dark years.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('LEVITYS',
 'Located along the periphery of the Gallosque Nebula, the forge world of Levitys — also known as a Titan foundry world — is dedicated entirely to producing God-Engines. Their manufacture is a tremendous undertaking exceeding even an Explorator Fleet launch. Much knowledge of Titan fabrication has been lost, but what little remains is held in highest reverence. You were one of thousands of faceless thralls raising a Titan from iron and alloys, imparting blessing upon blessing upon nascent machine spirits. To have risen from those numbers as an aspiring Tech-Adept, you have proven aptitude with fabrication and communion with the machine spirit.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('OPAL VII',
 'The macabre forge world of Opal VII is controlled by the Opaline Forge sect of the Adeptus Mechanicus, which performs the reverent duty of stripping bodies of bionics, logging them, and recycling them for future use. The Tech-Priests of Opal VII believe that machine spirits of augmetics absorb and retain information from the bodies they inhabit, and that recycling bionics pursues the reunification of the Omnissiah''s forgotten knowledge. You became accustomed to the dead and the rites of reclamation, more familiar with biomechanical knowledge and bionic integration than weaponry. You gain a Rare or lower Availability Augmetic of your choice, but it is inoperable and will require you to repair it.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('OSMODIA BETA',
 'Located bordering the Jade Veil in the Cytheris Subsector, Osmodia Beta produces weapons and armaments vital to the Astra Militarum, including the Osmodia Pattern Sniper Rifle. A concentration of Logi routinely gathers information from vessels passing through the system. Recently stifled by ancient treaties with the Imperium, Osmodia Beta has discovered fragmented ancient schematics that could build a new Imperial Titan, yet the Adeptus Administratum refuses to change the world''s tithe status. You might have toiled in manufactorums or served among the Logi in data-vaults, sifting through archival information.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('PORT BARBICAN',
 'An Adeptus Mechanicus-controlled Voidstation situated at the western edge of the Azynith Abyss in the Yix Subsector, Port Barbican most closely resembles a research station and listening post. Most of its Adeptus Mechanicus presence are Logi, and a sect known as the Lexio Arcani has gathered there, cogitating the mystery of the Azynith Abyss and its improbably high number of lost vessels. You may have traced your lineage to Kharmin or Barbarosk, and served maintaining the voidstation or assisting in collecting data to unravel the mysteries of the abyss.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('RECOLLECTIONS OF RUST',
 'The most significant source of power and influence among the Adeptus Mechanicus in the Macharian Sector, Recollections of Rust is an Ark Mechanicus vessel carrying the Ferric Triumvirate — a council of the highest-ranking Fabricator-Generals — on an eternal Explorator crusade. The vessel houses the capabilities of an entire forge world and is also a formidable military vessel. You were born on the Recollections of Rust or one of its flotilla, or grown in its gene-vats, and have risen to become a fully-fledged Tech-Adept with the rare experience of seeing more of the galaxy than most.',
 'AM')
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book) VALUES
('TRAN''LO',
 'The forge world of Tran''lo sits near the edge of the Andosk Subsector and unexplored regions that may once have belonged to the Imperium. Its original inhabitants, the Vo, jealously hoarded innumerable technological secrets and were destroyed resisting the Adeptus Mechanicus. The priesthood of Mars has burrowed deep into the world''s crust to uncover any relics of the Vo. Few of their technological marvels remain, and each recovered relic is jealously guarded. You may have inherited the world''s ravenous appetite for technology and discovery, trained under Explorators or Technoarcheologists, or perhaps descend from the Vo themselves.',
 'AM')
ON CONFLICT DO NOTHING;

-- =====================================================================
-- 6. CHARACTERISTICS
-- IDs: 1=WS, 2=BS, 3=STR, 4=TGH, 5=AG, 6=INT, 7=PER, 8=WIL, 9=FEL
-- =====================================================================

-- DANNOCK III: +5 PER (fixed primary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, 7, true FROM origin o WHERE o.name = 'DANNOCK III'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = 7 AND co.primary_char = true);

-- ESKUTCHAX: choose one of BS/INT/WS (secondary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, false FROM origin o
CROSS JOIN (VALUES (2), (6), (1)) AS v(char_id)
WHERE o.name = 'ESKUTCHAX'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- HEXAS PANAN: choose one of INT/PER/TGH (secondary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, false FROM origin o
CROSS JOIN (VALUES (6), (7), (4)) AS v(char_id)
WHERE o.name = 'HEXAS PANAN'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- LEVITYS: +5 TGH (fixed primary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, 4, true FROM origin o WHERE o.name = 'LEVITYS'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = 4 AND co.primary_char = true);

-- RECOLLECTIONS OF RUST: choose one of INT/PER/TGH (secondary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, false FROM origin o
CROSS JOIN (VALUES (6), (7), (4)) AS v(char_id)
WHERE o.name = 'RECOLLECTIONS OF RUST'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- TRAN'LO: choose one of INT/PER/WIL (secondary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, false FROM origin o
CROSS JOIN (VALUES (6), (7), (8)) AS v(char_id)
WHERE o.name = 'TRAN''LO'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- =====================================================================
-- 7. ORIGIN TALENTS
-- =====================================================================
INSERT INTO origin_talent (origin_id, talent_id)
SELECT o.id, t.id
FROM (VALUES
    ('ASSEMBLY OF MEANS', 'VOID LEGS'),
    ('ESKUTCHAX',         'HATRED'),
    ('LEVITYS',           'FAMILIAR TERRAIN'),
    ('PORT BARBICAN',     'DATA DELVER')
) AS v(origin_name, talent_name)
JOIN origin o ON o.name = v.origin_name
JOIN talent t ON t.name = v.talent_name
WHERE NOT EXISTS (
    SELECT 1 FROM origin_talent ot WHERE ot.origin_id = o.id AND ot.talent_id = t.id
);

-- =====================================================================
-- 8. ORIGIN INVENTORY ITEMS
-- =====================================================================
DO $$
DECLARE v_shoddy_id BIGINT;
BEGIN
    SELECT id INTO v_shoddy_id FROM item_modifier WHERE name = 'Shoddy';

    -- ASSEMBLY OF MEANS → Shoddy Void Suit
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'ASSEMBLY OF MEANS' AND i.name = 'Void Suit'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- OSMODIA BETA → Shoddy Combi-Tool
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'OSMODIA BETA' AND i.name = 'Combi-Tool'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- PORT BARBICAN → Shoddy Dataslate
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'PORT BARBICAN' AND i.name = 'Dataslate'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

END $$;

-- =====================================================================
-- 9. ORIGIN SKILL ADVANCES
-- =====================================================================

-- DANNOCK III: choose one of AWARENESS / DISCIPLINE / INTUITION (1 advance)
INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, true
FROM origin o, skill s
WHERE o.name = 'DANNOCK III' AND s.name IN ('AWARENESS', 'DISCIPLINE', 'INTUITION')
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);

-- OPAL VII: choose one of DISCIPLINE / INTUITION / MEDICAE (1 advance)
INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, true
FROM origin o, skill s
WHERE o.name = 'OPAL VII' AND s.name IN ('DISCIPLINE', 'INTUITION', 'MEDICAE')
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);

-- OSMODIA BETA: LOGIC (fixed) + TECH (fixed) (1 advance each)
INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, false
FROM origin o, skill s
WHERE o.name = 'OSMODIA BETA' AND s.name IN ('LOGIC', 'TECH')
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);

-- TRAN'LO: LOGIC (fixed) (1 advance)
INSERT INTO origin_skill (origin_id, skill_id, advances, is_choice)
SELECT o.id, s.id, 1, false
FROM origin o, skill s
WHERE o.name = 'TRAN''LO' AND s.name = 'LOGIC'
  AND NOT EXISTS (SELECT 1 FROM origin_skill os WHERE os.origin_id = o.id AND os.skill_id = s.id);

-- =====================================================================
-- 10. ORIGIN SPECIALIZATION ADVANCES
-- =====================================================================

-- HEXAS PANAN: one advance in TECH (ENGINEERING) (fixed)
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 1, false
FROM origin o, skill sk, specialization sp
WHERE o.name = 'HEXAS PANAN' AND sk.name = 'TECH' AND sp.name = 'ENGINEERING'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);

-- RECOLLECTIONS OF RUST: one advance in any Tech Specialisation (choice)
INSERT INTO origin_specialization (origin_id, skill_id, specialization_id, advances, is_choice)
SELECT o.id, sk.id, sp.id, 1, true
FROM origin o
JOIN skill sk ON sk.name = 'TECH'
JOIN skill_specializations ss ON ss.skill_id = sk.id
JOIN specialization sp ON sp.id = ss.specialization_id
WHERE o.name = 'RECOLLECTIONS OF RUST'
  AND NOT EXISTS (SELECT 1 FROM origin_specialization os WHERE os.origin_id = o.id AND os.specialization_id = sp.id);