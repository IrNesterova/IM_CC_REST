-- Equipment Packs from Macharian Requisition (pp. 24-26)
-- Run AFTER: inventory.sql, macharian_requisition_books.sql,
--            macharian_requisition_pack_books.sql, macharian_requisition_misc_items.sql

DO $$
DECLARE
    pack_id BIGINT;
    inv_id  BIGINT;
BEGIN

-- ====================================================================
-- Ensure standalone items exist that aren't in other SQL files
-- ====================================================================

-- Ration Pack (MR p27)
SELECT id INTO inv_id FROM inventory WHERE name = 'Ration Pack' LIMIT 1;
IF inv_id IS NULL THEN
    INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
    VALUES ('Ration Pack', 'TOOLS', 'COMMON', 0, 1, 'MR')
    RETURNING id INTO inv_id;
    INSERT INTO generic_item (id, description)
    VALUES (inv_id, 'A standard Departmento Munitorum-issue ration pack containing a day''s worth of compressed nutrient blocks and water purification tablets. Palatable in the same way that survival is preferable to death.');
END IF;

-- Adeptus Administratum Sigil of Office (MR p38)
SELECT id INTO inv_id FROM inventory WHERE name = 'Adeptus Administratum Sigil of Office' LIMIT 1;
IF inv_id IS NULL THEN
    INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
    VALUES ('Adeptus Administratum Sigil of Office', 'CLOTHING_AND_PERSONAL_GEAR', 'SCARCE', 0, 75, 'MR')
    RETURNING id INTO inv_id;
    INSERT INTO generic_item (id, description)
    VALUES (inv_id, 'An official seal or badge marking the bearer as a sanctioned representative of the Adeptus Administratum. Required for conducting official Administratum business and accessing its facilities and records. Its display commands either cooperation or suspicion, depending on whose desk the bearer has arrived to inspect.');
END IF;

-- ====================================================================
-- 1. Adeptus Administratum Clerk's Pack  (MR p24)  cost: 1,800  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Adeptus Administratum Clerk''s Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Adeptus Administratum Clerk''s Pack',
        'This combat pack is issued to clerks, scribes, ordinates, and other Adeptus Administratum delegates of similar rank who are sent on missions near active war zones or to worlds far from their main office. Its contents ensure a reasonable chance that one in four adepts will return from the field reasonably intact and with properly auditable paperwork.',
        'MR', 1800, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'This combat pack is issued to clerks, scribes, ordinates, and other Adeptus Administratum delegates of similar rank who are sent on missions near active war zones or to worlds far from their main office. Its contents ensure a reasonable chance that one in four adepts will return from the field reasonably intact and with properly auditable paperwork.',
        source_book  = 'MR',
        cost         = 1800,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Laspistol',
    'Knife',
    'Robes/Light Leathers',
    'Backpack/Slings',
    'Chrono',
    'Pict Recorder',
    'Glow-Globe/Stablight',
    'Writing Kit',
    'Laspistol Manual AKR-457',
    'Munitorum Knife Manual SK43-B',
    'Adeptus Administratum Audit Procedures Manual AD444.37b',
    'Adeptus Administratum Sigil of Office'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 13 FROM inventory WHERE name = 'Ration Pack' LIMIT 1;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 1, '1 additional laspack'),
    (pack_id, NULL, 1, 'Department Expense Forms 3KTR-103b and Standard-issue Adeptus Administratum Forms CR43 to UTL784'),
    (pack_id, NULL, 1, '500 solars');

-- ====================================================================
-- 2. Battlefield Chirurgeon's Pack  (MR p25)  cost: 2,800  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Battlefield Chirurgeon''s Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Battlefield Chirurgeon''s Pack',
        'This combat kit is issued to medics and chirurgeons who are sent to battlefields or attached to frontier or exploratory missions. The pack contains everything deemed necessary to protect the medic in the field and a wide range of medical equipment and consumables to treat combatants — medics are expected to make their supplies last as long as possible.',
        'MR', 2800, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'This combat kit is issued to medics and chirurgeons who are sent to battlefields or attached to frontier or exploratory missions. The pack contains everything deemed necessary to protect the medic in the field and a wide range of medical equipment and consumables to treat combatants — medics are expected to make their supplies last as long as possible.',
        source_book  = 'MR',
        cost         = 2800,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Lasgun',
    'Stub Revolver',
    'Knife',
    'Heavy Leathers',
    'Backpack/Slings',
    'Chirurgeon''s Kit',
    'Chrono',
    'Lasgun Manual LRS-489',
    'Patrol Weapons Maintenance Manual',
    'Liber Anatomicus (Pocket Edition)',
    'Militarum Issue Medipack',
    'Adrenaline Shot',
    'De-tox',
    'Stimm'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 1, '1 additional laspack'),
    (pack_id, NULL, 1, '1 additional Stub Revolver clip'),
    (pack_id, NULL, 1, '500 solars');

-- ====================================================================
-- 3. Battlefield Tech-Priest's Pack  (MR p25)  cost: 3,100  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Battlefield Tech-Priest''s Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Battlefield Tech-Priest''s Pack',
        'This pack is issued to novitiate Tech-Priests with battlefield duties, whether they are part of an Adeptus Mechanicus war maniple or supporting the other armed forces of the Imperium. It supposedly contains everything needed to maintain most Imperial technology and the tools to repair damaged weapons and vehicles. However, the contents were tallied and arranged by Departmento Munitorum adepts, so who can be sure?',
        'MR', 3100, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'This pack is issued to novitiate Tech-Priests with battlefield duties, whether they are part of an Adeptus Mechanicus war maniple or supporting the other armed forces of the Imperium. It supposedly contains everything needed to maintain most Imperial technology and the tools to repair damaged weapons and vehicles. However, the contents were tallied and arranged by Departmento Munitorum adepts, so who can be sure?',
        source_book  = 'MR',
        cost         = 3100,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Knife',
    'Hot-Shot Laspistol',
    'Robes/Light Leathers',
    'Backpack/Slings',
    'Auspex/Scanner',
    'Combi-Tool',
    'Dataslate',
    'Holy Icon',
    'Wounded Machines and Battlefield Rites (Abridged)',
    'Sacred Unguents'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 1, '500 solars');

-- ====================================================================
-- 4. Enforcer's Standard Issue Pack  (MR p25)  cost: 2,200  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Enforcer''s Standard Issue Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Enforcer''s Standard Issue Pack',
        'This pack is issued to Adeptus Administratum enforcers and Vigilites to equip them for prolonged service with potentially limited access to their precinct''s resources. While the equipment provided is limited to ensure no major loss with the bearer''s death, it adequately arms them for any duties that fall within the standard protocol: keeping the peace with extreme prejudice.',
        'MR', 2200, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'This pack is issued to Adeptus Administratum enforcers and Vigilites to equip them for prolonged service with potentially limited access to their precinct''s resources. While the equipment provided is limited to ensure no major loss with the bearer''s death, it adequately arms them for any duties that fall within the standard protocol: keeping the peace with extreme prejudice.',
        source_book  = 'MR',
        cost         = 2200,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Stub Revolver',
    'Shock Maul',
    'Flak Jacket',
    'Backpack/Slings',
    'Chrono',
    'Glow-Globe/Stablight',
    'Pict Recorder',
    'Manacles',
    'Micro-Bead/Vox Bead',
    'Service Identity Tags',
    'Patrol Weapons Maintenance Manual',
    'Enforcer''s Illustrated Subdual Manual',
    'Adeptus Administratum Sigil of Office'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 3 FROM inventory WHERE name = 'Ration Pack' LIMIT 1;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 1, '1 additional Stub Revolver clip'),
    (pack_id, NULL, 1, '200 solars');

-- ====================================================================
-- 5. Infantryman's Pack  (MR p25)  cost: 2,600  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Infantryman''s Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Infantryman''s Pack',
        'Packs like these are issued across the Imperium to the billions of troopers who make up the main fighting body of the Astra Militarum. Its contents of arms, armour, and equipment are helpful both on the battlefield and for life on long campaigns. The infantryman''s kit is cheap to produce, easy to maintain, and, in the likelihood of the bearer''s death in battle, inconsequential if lost.',
        'MR', 2600, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'Packs like these are issued across the Imperium to the billions of troopers who make up the main fighting body of the Astra Militarum. Its contents of arms, armour, and equipment are helpful both on the battlefield and for life on long campaigns. The infantryman''s kit is cheap to produce, easy to maintain, and, in the likelihood of the bearer''s death in battle, inconsequential if lost.',
        source_book  = 'MR',
        cost         = 2600,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Lasgun',
    'Knife',
    'Astra Militarum Flak Armour',
    'Backpack/Slings',
    'Entrenching Tool',
    'Glow-Globe/Stablight',
    'Survival Gear',
    'Service Identity Tags',
    'Imperial Infantryman''s Uplifting Primer',
    'Lasgun Maintenance Kit'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 20 FROM inventory WHERE name = 'Food Supplement Tablets' LIMIT 1;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 10 FROM inventory WHERE name = 'Ration Pack' LIMIT 1;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 2, '2 additional laspacks'),
    (pack_id, NULL, 1, '300 solars');

-- ====================================================================
-- 6. Ministorum Initiate Pack  (MR p26)  cost: 1,000  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Ministorum Initiate Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Ministorum Initiate Pack',
        'This pack is supplied to inducted Clerics and Preachers of the Adeptus Ministorum, the zealous and the faithful who spread the God-Emperor''s light to the darkest corners of the Imperium''s worlds. It contains various tools useful to preachers, necessary means of defence, and essential instructionals of faith.',
        'MR', 1000, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'This pack is supplied to inducted Clerics and Preachers of the Adeptus Ministorum, the zealous and the faithful who spread the God-Emperor''s light to the darkest corners of the Imperium''s worlds. It contains various tools useful to preachers, necessary means of defence, and essential instructionals of faith.',
        source_book  = 'MR',
        cost         = 1000,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Staff',
    'Autopistol',
    'Heavy Leathers',
    'Backpack/Slings',
    'Glow-Globe/Stablight',
    'Holy Icon',
    'Laud Hailer',
    'Document Harness',
    'Litany of Sacrifice',
    'Litany of the Fallen'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 1, '400 solars');

-- ====================================================================
-- 7. Scholastica Psykana Pack  (MR p26)  cost: 8,800  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Scholastica Psykana Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Scholastica Psykana Pack',
        'Graduates of the Adeptus Astra Telepathica may find employment in many different fields, and their field packs reflect the variety of situations and environments their service to the Imperium may take them. Psykers, even sanctioned psykers, are not viewed kindly by the Imperium and are expected to commit ritual suicide rather than lose control of their powers or succumb to daemonic possession.',
        'MR', 8800, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'Graduates of the Adeptus Astra Telepathica may find employment in many different fields, and their field packs reflect the variety of situations and environments their service to the Imperium may take them. Psykers, even sanctioned psykers, are not viewed kindly by the Imperium and are expected to commit ritual suicide rather than lose control of their powers or succumb to daemonic possession.',
        source_book  = 'MR',
        cost         = 8800,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Knife',
    'Robes/Light Leathers',
    'Backpack/Slings',
    'Laspistol',
    'Instruments of Divination',
    'Psy Focus',
    'Writing Kit',
    'The Emperor''s Mercy: Proper Care and Use of the Mercy Blade',
    'Selected Meditations on Eternity'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 1, 'Any Force Weapon (player''s choice)'),
    (pack_id, NULL, 1, '100 solars');

-- ====================================================================
-- 8. Voidsman's Survival Pack  (MR p26)  cost: 5,100  avail: Scarce
-- ====================================================================

SELECT id INTO pack_id FROM equipment_pack WHERE name = 'Voidsman''s Survival Pack' LIMIT 1;
IF pack_id IS NULL THEN
    INSERT INTO equipment_pack (name, description, source_book, cost, availability)
    VALUES (
        'Voidsman''s Survival Pack',
        'This pack is issued to the voidship crews of the Imperial Navy and some merchant and civil fleets. A small merchant freighter might have one for each crew member; a kilometres-long Navy battlecruiser reserves access to only those with ship-critical functions. They provide everything required to carry out ship duties, and to survive short periods of void exposure.',
        'MR', 5100, 'SCARCE'
    )
    RETURNING id INTO pack_id;
ELSE
    UPDATE equipment_pack
    SET description  = 'This pack is issued to the voidship crews of the Imperial Navy and some merchant and civil fleets. A small merchant freighter might have one for each crew member; a kilometres-long Navy battlecruiser reserves access to only those with ship-critical functions. They provide everything required to carry out ship duties, and to survive short periods of void exposure.',
        source_book  = 'MR',
        cost         = 5100,
        availability = 'SCARCE'
    WHERE id = pack_id;
END IF;

DELETE FROM equipment_pack_item WHERE equipment_pack_id = pack_id;

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity)
SELECT pack_id, id, 1
FROM inventory
WHERE name IN (
    'Stub Revolver',
    'Knife',
    'Harjian Pattern Void Suit',
    'Robes/Light Leathers',
    'Backpack/Slings',
    'Auspex/Scanner',
    'Auspex Manual VAO-384',
    'Chrono',
    'Combi-Tool',
    'Dataslate',
    'Glow-Globe/Stablight',
    'Micro-Bead/Vox Bead',
    'Sacred Unguents',
    'Service Identity Tags'
);

INSERT INTO equipment_pack_item (equipment_pack_id, inventory_id, quantity, note) VALUES
    (pack_id, NULL, 1, '1 extra Stub Revolver clip'),
    (pack_id, NULL, 1, 'Spare air tank (included with Harjian Pattern Void Suit)'),
    (pack_id, NULL, 1, '400 solars');

END $$;
