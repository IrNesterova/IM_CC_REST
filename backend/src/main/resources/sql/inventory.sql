-- ====================================================================
-- GRENADES AND EXPLOSIVES
-- ====================================================================

DO $$
DECLARE
inv_id BIGINT;
    spec_id BIGINT;
    rec RECORD;
BEGIN
FOR rec IN
SELECT * FROM (VALUES
                   ('Blasting Charge',      'THROWN',              10,   0, 40,   'COMMON', 'Loud, Spread, Thrown (Medium), Unstable'),
                   ('Choke Grenade',        'THROWN,ORDNANCE',     NULL, 0, 40,   'SCARCE', 'Inflict (Stunned), Thrown (Medium), Unstable'),
                   ('Demolition Charge',    'ENGINEERING',         16,   2, 50,   'COMMON', 'Loud, Spread, Unstable'),
                   ('Fire Bomb',            'THROWN',              NULL, 1, 10,   'COMMON', 'Blast, Loud, Inflict (Ablaze), Thrown (Medium), Unstable'),
                   ('Frag Grenade',         'THROWN,ORDNANCE',     6,    0, 50,   'COMMON', 'Blast, Loud, Thrown (Medium), Unstable'),
                   ('Frag Missile',         'ORDNANCE',            8,    1, 200,  'SCARCE', 'Blast, Loud, Unstable'),
                   ('Krak Grenade',         'THROWN,ORDNANCE',     12,   0, 60,   'SCARCE', 'Loud, Penetrating (4), Spread, Thrown (Medium), Unstable'),
                   ('Krak Missile',         'ORDNANCE',            16,   1, 400,  'SCARCE', 'Loud, Penetrating (6), Spread, Unstable'),
                   ('Melta Bomb',           'ENGINEERING',         16,   2, 1000, 'EXOTIC', 'Rend (12), Spread, Unstable'),
                   ('Photon Flash Grenade', 'THROWN,ORDNANCE',     NULL, 0, 200,  'RARE',   'Blast, Loud, Inflict (Blinded), Thrown (Medium), Unstable'),
                   ('Smoke Grenade',        'THROWN,ORDNANCE',     NULL, 0, 30,   'COMMON', 'Blast, Thrown (Medium), Unstable'),
                   ('Web Grenade',          'THROWN',              NULL, 0, 150,  'RARE',   'Loud, Blast, Inflict (Restrained), Thrown (Medium), Unstable')
              ) AS t(_name, _specs, _damage, _enc, _cost, _avail, _special)
    LOOP
-- найти или создать inventory
SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost)
            VALUES (rec._name, 'GRENADES_AND_EXPLOSIVES', rec._avail, rec._enc, rec._cost)
            RETURNING id INTO inv_id;
ELSE
UPDATE inventory
SET inventory_category = 'GRENADES_AND_EXPLOSIVES',
    availability = rec._avail,
    encumbrance = rec._enc,
    cost = rec._cost
WHERE id = inv_id;
END IF;

DELETE FROM generic_item WHERE id = inv_id;

-- granade itself
INSERT INTO grenades_and_explosives (id, damage, special, description)
VALUES (inv_id, rec._damage, rec._special, NULL)
    ON CONFLICT (id) DO UPDATE SET
    damage = EXCLUDED.damage,
                            special = EXCLUDED.special;

-- specializations: разбить строку и для каждой добавить связь
DELETE FROM grenade_specializations WHERE grenade_id = inv_id;

FOR spec_id IN
SELECT s.id FROM specialization s
WHERE s.name = ANY(string_to_array(rec._specs, ','))
    LOOP
INSERT INTO grenade_specializations (grenade_id, specialization_id)
VALUES (inv_id, spec_id);
END LOOP;
END LOOP;
END $$;
-- ====================================================================
-- ARMOUR
-- ====================================================================

DO $$
    DECLARE
        inv_id BIGINT;
        loc TEXT;
        rec RECORD;
    BEGIN
        FOR rec IN
            SELECT * FROM (VALUES
                               ('Robes/Light Leathers',        'ARMS,BODY,LEGS',     'BASIC',    1,    1, 2, 10,      'COMMON', 'Subtle'),
                               ('Heavy Leathers',              'ARMS,BODY,LEGS',     'BASIC',    2,    2, 3, 60,      'COMMON', NULL),
                               ('Armoured Bodyglove',          'ARMS,BODY,LEGS',     'BASIC',    2,    1, 2, 1200,    'RARE',   'Subtle'),
                               ('Armoured Greatcoat',          'ARMS,BODY,LEGS',     'BASIC',    2,    2, 3, 500,     'RARE',   'Subtle'),
                               ('Scrap-plate',                 'BODY',               'BASIC',    3,    4, 5, 300,     'RARE',   'Heavy (3)'),
                               ('Scrap-shield',                'SPECIAL',            'BASIC',    NULL, 1, 1, 50,      'COMMON', 'Shield (1)'),
                               ('Combat Shield',               'SPECIAL',            'BASIC',    NULL, 1, 1, 300,     'COMMON', 'Shield (2)'),
                               ('Boarding Shield',             'SPECIAL',            'BASIC',    NULL, 2, 2, 800,     'RARE',   'Shield (4)'),
                               ('Xenos Hide Vest',             'BODY',               'BASIC',    6,    1, 2, 5000,    'EXOTIC', NULL),
                               ('Flak Boots',                  'LEGS',               'FLAK',     2,    1, 2, 100,     'COMMON', NULL),
                               ('Flak Helmet',                 'HEAD',               'FLAK',     2,    1, 2, 150,     'COMMON', NULL),
                               ('Flak Gauntlets',              'ARMS',               'FLAK',     2,    0, 1, 100,     'COMMON', NULL),
                               ('Flak Vest',                   'BODY',               'FLAK',     3,    2, 3, 500,     'COMMON', NULL),
                               ('Flak Jacket',                 'ARMS,BODY',          'FLAK',     3,    2, 3, 800,     'SCARCE', NULL),
                               ('Astra Militarum Flak Armour', 'HEAD,ARMS,BODY,LEGS','FLAK',     4,    4, 5, 1000,    'RARE',   'Loud'),
                               ('Mesh Boots',                  'LEGS',               'MESH',     3,    1, 2, 600,     'RARE',   NULL),
                               ('Mesh Cowl',                   'HEAD',               'MESH',     3,    1, 2, 800,     'RARE',   NULL),
                               ('Mesh Gauntlets',              'ARMS',               'MESH',     3,    0, 1, 600,     'RARE',   NULL),
                               ('Mesh Vest',                   'BODY',               'MESH',     4,    1, 2, 500,     'RARE',   NULL),
                               ('Xenos Mesh',                  'ARMS,BODY,LEGS',     'MESH',     4,    2, 3, 5000,    'EXOTIC', NULL),
                               ('Carapace Helm',               'HEAD',               'CARAPACE', 5,    1, 2, 400,     'RARE',   NULL),
                               ('Carapace Gauntlets',          'ARMS',               'CARAPACE', 5,    1, 2, 300,     'RARE',   NULL),
                               ('Carapace Greaves',            'LEGS',               'CARAPACE', 5,    1, 2, 300,     'RARE',   NULL),
                               ('Carapace Chestplate',         'BODY',               'CARAPACE', 6,    3, 4, 800,     'RARE',   'Heavy (4), Loud'),
                               ('Enforcer Carapace',           'HEAD,ARMS,BODY,LEGS','CARAPACE', 5,    4, 5, 1800,    'RARE',   'Heavy (4), Loud'),
                               ('Tempestus Carapace',          'HEAD,ARMS,BODY,LEGS','CARAPACE', 6,    5, 6, 4000,    'EXOTIC', 'Heavy (4), Loud'),
                               ('Light Power Armour',          'HEAD,ARMS,BODY,LEGS','POWER',    8,    7, 8, 500000,  'EXOTIC', 'Loud'),
                               ('Power Armour',                'HEAD,ARMS,BODY,LEGS','POWER',    10,   9, 10, 1000000,'EXOTIC', 'Loud')
                          ) AS t(_name, _locations, _subcat, _ap, _worn, _enc, _cost, _avail, _special)
            LOOP
                SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

                IF inv_id IS NULL THEN
                    INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost)
                    VALUES (rec._name, 'ARMOUR', rec._subcat, rec._avail, rec._enc, rec._cost)
                    RETURNING id INTO inv_id;
                ELSE
                    UPDATE inventory
                    SET inventory_category = 'ARMOUR',
                        inventory_subcategory = rec._subcat,
                        availability = rec._avail,
                        encumbrance = rec._enc,
                        cost = rec._cost
                    WHERE id = inv_id;
                END IF;

                DELETE FROM generic_item WHERE id = inv_id;

                INSERT INTO armour (id, armor_points, weight_worn, special)
                VALUES (inv_id, rec._ap, rec._worn, rec._special)
                ON CONFLICT (id) DO UPDATE SET
                                               armor_points = EXCLUDED.armor_points,
                                               weight_worn = EXCLUDED.weight_worn,
                                               special = EXCLUDED.special;

                -- locations: разбить и добавить
                DELETE FROM armour_locations WHERE armour_id = inv_id;
                FOREACH loc IN ARRAY string_to_array(rec._locations, ',')
                    LOOP
                        INSERT INTO armour_locations (armour_id, location) VALUES (inv_id, loc);
                    END LOOP;
            END LOOP;
    END $$;
-- ====================================================================
-- FORCE FIELDS
-- ====================================================================

DO $$
    DECLARE
        inv_id BIGINT;
        rec RECORD;
    BEGIN
        FOR rec IN
            SELECT * FROM (VALUES
                               ('Refractor Field',  '1d10', 10, 0, 1000, 'EXOTIC', NULL),
                               ('Conversion Field', '2d10', 20, 0, 6000, 'EXOTIC', NULL)
                          ) AS t(_name, _protection, _overload, _enc, _cost, _avail, _special)
            LOOP
                SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

                IF inv_id IS NULL THEN
                    INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost)
                    VALUES (rec._name, 'FORCE_FIELDS', rec._avail, rec._enc, rec._cost)
                    RETURNING id INTO inv_id;
                ELSE
                    UPDATE inventory
                    SET inventory_category = 'FORCE_FIELDS',
                        availability = rec._avail,
                        encumbrance = rec._enc,
                        cost = rec._cost
                    WHERE id = inv_id;
                END IF;

                DELETE FROM generic_item WHERE id = inv_id;

                INSERT INTO force_field (id, protection, overload, special)
                VALUES (inv_id, rec._protection, rec._overload, rec._special)
                ON CONFLICT (id) DO UPDATE SET
                                               protection = EXCLUDED.protection,
                                               overload = EXCLUDED.overload,
                                               special = EXCLUDED.special;
            END LOOP;
    END $$;
-- ====================================================================
-- GENERIC ITEMS (clothing, tools, augmetics, replacements, ammo, weapon mods)
-- ====================================================================

DO $$
    DECLARE
        inv_id BIGINT;
        rec RECORD;
    BEGIN
        FOR rec IN
            SELECT * FROM (VALUES
                               -- CLOTHING AND PERSONAL GEAR
                               ('Backpack/Slings',          'CLOTHING_AND_PERSONAL_GEAR', NULL,                      20,    'COMMON', 1),
                               ('Cameleoline Cloak',        'CLOTHING_AND_PERSONAL_GEAR', NULL,                      500,   'RARE',   0),
                               ('Explosive Collar',         'CLOTHING_AND_PERSONAL_GEAR', NULL,                      150,   'SCARCE', 0),
                               ('Filtration Plugs',         'CLOTHING_AND_PERSONAL_GEAR', NULL,                      20,    'COMMON', 0),
                               ('Photo-Visors/Contacts',    'CLOTHING_AND_PERSONAL_GEAR', NULL,                      300,   'SCARCE', 0),
                               ('Rebreather',               'CLOTHING_AND_PERSONAL_GEAR', NULL,                      200,   'SCARCE', 1),
                               ('Respirator/Gas Mask',      'CLOTHING_AND_PERSONAL_GEAR', NULL,                      50,    'COMMON', 0),
                               ('Survival Gear',            'CLOTHING_AND_PERSONAL_GEAR', NULL,                      50,    'COMMON', 3),
                               ('Synskin',                  'CLOTHING_AND_PERSONAL_GEAR', NULL,                      3000,  'EXOTIC', 0),
                               ('Void Suit',                'CLOTHING_AND_PERSONAL_GEAR', NULL,                      2000,  'SCARCE', 5),

                               -- TOOLS
                               ('Auspex/Scanner',           'TOOLS', NULL, 1000,  'SCARCE', 1),
                               ('Auto-Quill',               'TOOLS', NULL, 150,   'SCARCE', 2),
                               ('Chirurgeon''s Kit',        'TOOLS', NULL, 500,   'RARE',   1),
                               ('Chrono',                   'TOOLS', NULL, 20,    'COMMON', 0),
                               ('Climbing Harness',         'TOOLS', NULL, 100,   'COMMON', 0),
                               ('Combi-Tool',               'TOOLS', NULL, 300,   'RARE',   0),
                               ('Comm Leech',               'TOOLS', NULL, 1000,  'RARE',   1),
                               ('Diagnostor',               'TOOLS', NULL, 2000,  'RARE',   1),
                               ('Disguise Kit',             'TOOLS', NULL, 100,   'EXOTIC', 1),
                               ('Emperor''s Tarot',         'TOOLS', NULL, 10000, 'RARE',   0),
                               ('Entrenching Tool',         'TOOLS', NULL, 20,    'COMMON', 1),
                               ('Excruciator Kit',          'TOOLS', NULL, 500,   'EXOTIC', 1),
                               ('Glow-Globe/Stablight',     'TOOLS', NULL, 30,    'COMMON', 0),
                               ('Grapnel Launcher',         'TOOLS', NULL, 550,   'COMMON', 0),
                               ('Grav Chute',               'TOOLS', NULL, 2000,  'RARE',   2),
                               ('Holy Icon',                'TOOLS', NULL, 10,    'COMMON', 0),
                               ('Inhaler/Injector',         'TOOLS', NULL, 65,    'COMMON', 0),
                               ('Instruments of Divination','TOOLS', NULL, 200,   'RARE',   0),
                               ('Lascutter',                'TOOLS', NULL, 170,   'COMMON', 2),
                               ('Laud Hailer',              'TOOLS', NULL, 100,   'SCARCE', 1),
                               ('Mag Boots',                'TOOLS', NULL, 400,   'RARE',   0),
                               ('Magnoculars',              'TOOLS', NULL, 30,    'COMMON', 0),
                               ('Manacles',                 'TOOLS', NULL, 50,    'COMMON', 0),
                               ('Micro-Bead/Vox Bead',      'TOOLS', NULL, 150,   'COMMON', 0),
                               ('Monotask Servo-Skull',     'TOOLS', NULL, 2000,  'RARE',   0),
                               ('Multicompass',             'TOOLS', NULL, 400,   'EXOTIC', 0),
                               ('Multikey',                 'TOOLS', NULL, 200,   'SCARCE', 0),
                               ('Pict Recorder',            'TOOLS', NULL, 200,   'COMMON', 0),
                               ('Psy Focus',                'TOOLS', NULL, 100,   'EXOTIC', 0),
                               ('Regicide Set',             'TOOLS', NULL, 40,    'COMMON', 0),
                               ('Sacred Unguents',          'TOOLS', NULL, 100,   'RARE',   0),
                               ('Screamer',                 'TOOLS', NULL, 170,   'SCARCE', 1),
                               ('Signal Jammer',            'TOOLS', NULL, 250,   'RARE',   1),
                               ('Stummer',                  'TOOLS', NULL, 1000,  'COMMON', 1),
                               ('Vox-Caster',               'TOOLS', NULL, 1000,  'SCARCE', 0),
                               ('Writing Kit',              'TOOLS', NULL, 20,    'COMMON', 1),
                               ('Dataslate',                'TOOLS', NULL, 100,   'COMMON', 0),

                               -- AUGMETICS
                               ('Augur Array',                  'AUGMETIC', NULL, 6000,  'RARE', 0),
                               ('Ballistic Mechadendrite',      'AUGMETIC', NULL, 2000,  'RARE', 0),
                               ('Biomechanical Interface',      'AUGMETIC', NULL, 10000, 'RARE', 0),
                               ('Calculus Logi Upgrade',        'AUGMETIC', NULL, 10000, 'RARE', 0),
                               ('Manipulator Mechadendrite',    'AUGMETIC', NULL, 1400,  'RARE', 0),
                               ('Medicae Mechadendrite',        'AUGMETIC', NULL, 1400,  'RARE', 0),
                               ('Optical Mechadendrite',        'AUGMETIC', NULL, 1200,  'RARE', 0),
                               ('Utility Mechadendrite',        'AUGMETIC', NULL, 1000,  'RARE', 0),
                               ('Vocal Implant',                'AUGMETIC', NULL, 400,   'RARE', 0),

                               -- AUGMETIC REPLACEMENTS
                               ('Augmetic Arm',                 'AUGMETIC_REPLACEMENTS', NULL, 1000, 'SCARCE', 0),
                               ('Augmetic Heart',               'AUGMETIC_REPLACEMENTS', NULL, 3000, 'RARE',   0),
                               ('Augmetic Leg',                 'AUGMETIC_REPLACEMENTS', NULL, 1000, 'SCARCE', 0),
                               ('Augmetic Respiratory System',  'AUGMETIC_REPLACEMENTS', NULL, 2000, 'RARE',   0),
                               ('Augmetic Sensory Organs',      'AUGMETIC_REPLACEMENTS', NULL, 4000, 'RARE',   0),
                               ('Augmetic Tracks/Wheels',       'AUGMETIC_REPLACEMENTS', NULL, 1500, 'SCARCE', 0),

                               -- CUSTOM AMMUNITION (cost = NULL because it's a multiplier of base weapon cost)
                               ('Bleeder Rounds',         'CUSTOM_AMMUNITION', NULL, NULL, 'RARE',   0),
                               ('Executioner Rounds',     'CUSTOM_AMMUNITION', NULL, NULL, 'RARE',   0),
                               ('Hot-Shot Las Pack',      'CUSTOM_AMMUNITION', NULL, NULL, 'SCARCE', 0),
                               ('Inferno Shells',         'CUSTOM_AMMUNITION', NULL, NULL, 'RARE',   0),
                               ('Man-Stopper Bullets',    'CUSTOM_AMMUNITION', NULL, NULL, 'SCARCE', 0),
                               ('Tox Rounds',             'CUSTOM_AMMUNITION', NULL, NULL, 'SCARCE', 0),

                               -- WEAPON MODIFICATIONS
                               ('Exterminator Cartridge', 'WEAPON_MODIFICATION', 'COMBAT_ATTACHMENTS',  100,  'COMMON', 0),
                               ('Melee Attachment',       'WEAPON_MODIFICATION', 'COMBAT_ATTACHMENTS',  50,   'SCARCE', 0),
                               ('Mono-edge',              'WEAPON_MODIFICATION', 'COMBAT_ATTACHMENTS',  250,  'RARE',   0),
                               ('Laser Sight',            'WEAPON_MODIFICATION', 'SIGHTS',              50,   'SCARCE', 0),
                               ('Omnispex',               'WEAPON_MODIFICATION', 'SIGHTS',              200,  'RARE',   0),
                               ('Omniscope',              'WEAPON_MODIFICATION', 'SIGHTS',              50,   'COMMON', 0),
                               ('Backpack Ammo Supply',   'WEAPON_MODIFICATION', 'SUPPORT_ATTACHMENTS', NULL, NULL,     1),
                               ('Bipod',                  'WEAPON_MODIFICATION', 'SUPPORT_ATTACHMENTS', 30,   'COMMON', 0),
                               ('Fire Selector',          'WEAPON_MODIFICATION', 'SUPPORT_ATTACHMENTS', 140,  'RARE',   0),
                               ('Silencer',               'WEAPON_MODIFICATION', 'SUPPORT_ATTACHMENTS', 400,  'COMMON', 0)
                          ) AS t(_name, _cat, _subcat, _cost, _avail, _enc)
            LOOP
                SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

                IF inv_id IS NULL THEN
                    INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost)
                    VALUES (
                               rec._name,
                               rec._cat::inventorycategory,
                               CASE WHEN rec._subcat IS NULL THEN NULL ELSE rec._subcat::inventorysubcategory END,
                               rec._avail,
                               rec._enc,
                               rec._cost
                           )
                    RETURNING id INTO inv_id;
                ELSE
                    UPDATE inventory
                    SET inventory_category = rec._cat::inventorycategory,
                        inventory_subcategory = CASE WHEN rec._subcat IS NULL THEN NULL ELSE rec._subcat::inventorysubcategory END,
                        availability = rec._avail,
                        encumbrance = rec._enc,
                        cost = rec._cost
                    WHERE id = inv_id;
                END IF;

                -- удалить из всех subclass-таблиц, оставить только в generic_item
                DELETE FROM melee_weapon WHERE id = inv_id;
                DELETE FROM ranged_weapon WHERE id = inv_id;
                DELETE FROM armour WHERE id = inv_id;
                DELETE FROM armour_locations WHERE armour_id = inv_id;
                DELETE FROM grenades_and_explosives WHERE id = inv_id;
                DELETE FROM grenade_specializations WHERE grenade_id = inv_id;
                DELETE FROM force_field WHERE id = inv_id;

                INSERT INTO generic_item (id, description)
                VALUES (inv_id, NULL)
                ON CONFLICT (id) DO NOTHING;
            END LOOP;
    END $$;
