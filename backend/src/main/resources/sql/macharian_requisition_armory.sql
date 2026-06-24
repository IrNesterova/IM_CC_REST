-- Armory chapter from Macharian Requisition (pp. 45-65)
-- Includes: melee weapons, ranged weapons, custom ammo,
--           grenades & explosives, weapon mods, armour & armour mods
-- Run AFTER melee_weapon.sql, ranged_weapon.sql, inventory.sql

-- ====================================================================
-- MELEE WEAPONS
-- ====================================================================

DO $$
DECLARE
    inv_id  BIGINT;
    spec_id BIGINT;
    rec     RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            -- Chain Weapons
            ('Tran''lo ''Burnout'' Chainsword', 'ONE-HANDED', 'CHAIN',   '3+StrB', 1, 650,    'RARE',   'Loud, Rend (2)'),
            ('Viridan Mk II Chain Halberd',      'TWO-HANDED', 'CHAIN',   '5+StrB', 4, 1200,   'RARE',   'Heavy (4), Loud, Reach, Rend (4), Two-handed'),
            -- Mundane Weapons
            ('Death World Combat Blade (One-handed)', 'ONE-HANDED', 'MUNDANE', '2+StrB', 1, 150,  'SCARCE', 'Penetrating (1), Reliable'),
            ('Death World Combat Blade (Two-handed)', 'TWO-HANDED', 'MUNDANE', '3+StrB', 1, 150,  'SCARCE', 'Penetrating (2), Reliable, Two-handed'),
            ('Heavy Rock Cutter',                'TWO-HANDED', 'MUNDANE', '6+StrB', 5, 5000,   'SCARCE', 'Heavy (4), Loud, Penetrating (5), Rend (3), Two-handed'),
            ('Heavy Rock Drill',                 'TWO-HANDED', 'MUNDANE', '6+StrB', 5, 4000,   'SCARCE', 'Heavy (4), Loud, Rend (5), Two-handed'),
            ('Heavy Rock Saw',                   'TWO-HANDED', 'MUNDANE', '4+StrB', 3, 3500,   'SCARCE', 'Bulky, Heavy (4), Loud, Rend (4), Two-handed'),
            ('Lascutter',                        'TWO-HANDED', 'MUNDANE', '6+StrB', 3, 3000,   'RARE',   'Heavy (4), Loud, Penetrating (4), Two-handed'),
            ('Servo Claw',                       'ONE-HANDED', 'MUNDANE', '5+StrB', 2, 3000,   'SCARCE', 'Heavy (4)'),
            ('Staff of Office',                  'TWO-HANDED', 'MUNDANE', '2+StrB', 2, 8000,   'EXOTIC', 'Defensive, Ornamental, Two-handed'),
            -- Power Weapons
            ('Compliance Pattern Power Maul',    'ONE-HANDED', 'POWER',   '5+StrB', 1, 5000,   'RARE',   'Heavy (4), Penetrating (3), Two-Handed'),
            ('Macharian Regimental Power Sword', 'ONE-HANDED', 'POWER',   '4+StrB', 1, 10000,  'EXOTIC', 'Master-crafted, Ornamental, Penetrating (4)'),
            ('Mortis Alpha Ceremonial Blade',    'TWO-HANDED', 'POWER',   '6+StrB', 2, 11000,  'EXOTIC', 'Durable, Master-crafted, Ornamental, Penetrating (4)'),
            -- Shock Weapons
            ('Shock Knuckles',                   'BRAWLING',   'SHOCK',   'StrB',   0, 1000,   'RARE',   'Inflict (Stunned), Loud, Subtle'),
            ('Shock Staff',                      'TWO-HANDED', 'SHOCK',   '1+StrB', 2, 150,    'SCARCE', 'Defensive, Inflict (Stunned), Loud, Two-handed')
        ) AS t(_name, _spec, _subcat, _damage, _weight, _cost, _avail, _special)
    LOOP
        SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;

        SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost, source_book)
            VALUES (rec._name, 'MELEE_WEAPON', rec._subcat, rec._avail, rec._weight, rec._cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category    = 'MELEE_WEAPON',
                inventory_subcategory = rec._subcat,
                availability          = rec._avail,
                encumbrance           = rec._weight,
                cost                  = rec._cost,
                source_book           = 'MR'
            WHERE id = inv_id;
        END IF;

        DELETE FROM generic_item WHERE id = inv_id;

        INSERT INTO melee_weapon (id, specialization_id, damage, special)
        VALUES (inv_id, spec_id, rec._damage, rec._special)
        ON CONFLICT (id) DO UPDATE SET
            specialization_id = EXCLUDED.specialization_id,
            damage            = EXCLUDED.damage,
            special           = EXCLUDED.special;
    END LOOP;
END $$;


-- ====================================================================
-- RANGED WEAPONS
-- ====================================================================

DO $$
DECLARE
    inv_id  BIGINT;
    spec_id BIGINT;
    rec     RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            -- Bolt Weapons
            ('Ajax Pattern Boltgun',                        'LONG GUNS', 'BOLT',             8,  'LONG',    4,  3, 6500,  'EXOTIC', 'Loud, Penetrating (4), Rapid Fire (2), Reliable, Spread, Two-handed'),
            ('Supremus Pattern Bolt Pistol',                'PISTOLS',   'BOLT',             8,  'MEDIUM',  4,  3, 5500,  'RARE',   'Burst, Close, Loud, Penetrating (4), Reliable, Spread'),
            -- Las Weapons
            ('Accatran Pattern ''Spearhead'' Recon Lasgun', 'LONG GUNS', 'LAS',              5,  'LONG',    8,  2, 700,   'RARE',   'Loud, Rapid Fire (1), Reliable, Spread, Two-handed'),
            ('Eskutchax Pattern Mark III ''Fury'' Lasgun',  'LONG GUNS', 'LAS',              6,  'MEDIUM',  8,  2, 700,   'RARE',   'Loud, Rapid Fire (2), Reliable, Two-handed'),
            ('Lucius Mk I Helbore Pattern Lasgun',          'LONG GUNS', 'LAS',              6,  'LONG',    4,  2, 700,   'RARE',   'Loud, Reliable, Supercharge (3), Two-handed'),
            ('Mining Laser',                                'ORDNANCE',  'LAS',              18, 'LONG',    8,  5, 6000,  'RARE',   'Heavy (5), Loud, Penetrating (8), Two-handed, Unstable'),
            -- Melta Weapons
            ('Multi-melta',                                 'ORDNANCE',  'MELTA',            16, 'LONG',    6,  3, 13500, 'RARE',   'Blast, Heavy (4), Loud, Rend (5), Two-handed'),
            -- Solid Projectile Weapons
            ('Autocannon',                                  'ORDNANCE',  'SOLID_PROJECTILE', 9,  'EXTREME', 6,  3, 9000,  'RARE',   'Heavy (4), Rapid Fire (3), Rend (5), Two-handed'),
            ('Charcaros Pattern Autogun',                   'LONG GUNS', 'SOLID_PROJECTILE', 6,  'LONG',    5,  2, 650,   'RARE',   'Defensive, Loud, Rapid Fire (3), Two-handed'),
            ('Desperion Enforcer Shotgun',                  'LONG GUNS', 'SOLID_PROJECTILE', 6,  'MEDIUM',  12, 3, 950,   'RARE',   'Inflict (Prone), Loud, Spread, Two-handed'),
            ('Kallastin Pattern ''Deadstop'' Mk III Autogun','LONG GUNS','SOLID_PROJECTILE', 7,  'LONG',    5,  2, 700,   'RARE',   'Burst, Loud, Penetrating (1), Two-handed'),
            ('Macharian ''Sinbreaker'' Shrine Shotgun',     'LONG GUNS', 'SOLID_PROJECTILE', 6,  'MEDIUM',  10, 1, 600,   'SCARCE', 'Inflict (Prone), Loud, Reliable, Spread, Two-handed'),
            ('Osmodia Pattern Sniper Rifle',                'LONG GUNS', 'SOLID_PROJECTILE', 8,  'EXTREME', 6,  2, 1200,  'SCARCE', 'Reliable, Two-handed'),
            ('RX-9 Rivet Gun',                              'LONG GUNS', 'SOLID_PROJECTILE', 12, 'SHORT',   10, 3, 1700,  'SCARCE', 'Heavy (3), Loud, Penetrating (4), Two-handed'),
            ('RX-9 ''Forgestamp'' Pattern Rivet Gun',       'LONG GUNS', 'SOLID_PROJECTILE', 12, 'SHORT',   10, 3, 3400,  'RARE',   'Heavy (4), Inflict (Ablaze), Loud, Penetrating (2), Rapid Fire (2), Two-handed'),
            ('Skarthius Pattern ''Last Word'' Shotgun',     'LONG GUNS', 'SOLID_PROJECTILE', 9,  'MEDIUM',  2,  2, 800,   'SCARCE', 'Close, Inflict (Prone), Loud, Spread, Two-handed'),
            ('Skarthius Pattern Mk IV Autogun',             'LONG GUNS', 'SOLID_PROJECTILE', 5,  'LONG',    7,  1, 700,   'SCARCE', 'Close, Loud, Rapid Fire (3), Two-handed'),
            -- Specialized Ranged Weapons
            ('Deluge Fluid Cannon (High Pressure)',         'ORDNANCE',  'SPECIALIZED',      8,  'LONG',    5,  4, 2500,  'SCARCE', 'Flamer, Heavy (4), Ineffective, Two-handed'),
            ('Deluge Fluid Cannon (High Volume)',           'ORDNANCE',  'SPECIALIZED',      5,  'MEDIUM',  5,  4, 2500,  'SCARCE', 'Flamer, Heavy (4), Ineffective, Inflict (Stunned), Two-handed'),
            ('Seismic Cannon (Long Wave Pattern)',          'ORDNANCE',  'SPECIALIZED',      8,  'LONG',    4,  5, 6000,  'SCARCE', 'Heavy (5), Loud, Penetrating (10), Two-handed'),
            ('Seismic Cannon (Short Wave Pattern)',         'ORDNANCE',  'SPECIALIZED',      12, 'SHORT',   4,  5, 6000,  'SCARCE', 'Heavy (5), Loud, Penetrating (10), Two-handed'),
            ('VT-3F Storm Welder',                         'ORDNANCE',  'SPECIALIZED',      10, 'MEDIUM',  9,  3, 1900,  'SCARCE', 'Rapid Fire (3), Spread, Two-handed, Unstable')
        ) AS t(_name, _spec, _subcat, _damage, _range, _mag, _weight, _cost, _avail, _special)
    LOOP
        SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;

        SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost, source_book)
            VALUES (rec._name, 'RANGED_WEAPON', rec._subcat, rec._avail, rec._weight, rec._cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category    = 'RANGED_WEAPON',
                inventory_subcategory = rec._subcat,
                availability          = rec._avail,
                encumbrance           = rec._weight,
                cost                  = rec._cost,
                source_book           = 'MR'
            WHERE id = inv_id;
        END IF;

        DELETE FROM generic_item WHERE id = inv_id;

        INSERT INTO ranged_weapon (id, specialization_id, damage, range, mag_size, special)
        VALUES (inv_id, spec_id, rec._damage, rec._range, rec._mag, rec._special)
        ON CONFLICT (id) DO UPDATE SET
            specialization_id = EXCLUDED.specialization_id,
            damage            = EXCLUDED.damage,
            range             = EXCLUDED.range,
            mag_size          = EXCLUDED.mag_size,
            special           = EXCLUDED.special;
    END LOOP;
END $$;


-- ====================================================================
-- CUSTOM AMMUNITION
-- ====================================================================

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('Amputator Rounds',   'CUSTOM_AMMUNITION', NULL, 'RARE',   0,
             'Vicious explosive rounds hard-packed with razor-sharp microscopic shrapnel, designed to shred flesh and bone upon impact and detonation. Cost multiplier: x3 base ammo cost. Used with: Solid Projectile Weapons. Traits: Penetrating (1). Special: If an attack causes a Critical Hit to a Head, Arm, or Leg, roll twice on the Critical Wounds Table and pick the higher result.'),
            ('CX-19 Web Agent',    'CUSTOM_AMMUNITION', NULL, 'RARE',   0,
             'A chemical developed to enhance web weaponry. Adding a small tank to a web gun''s feed mechanism causes an effervescent reaction in the webbing when exposed to air, spraying it over a significantly wider area. Cost multiplier: x2 base ammo cost. Used with: Web Guns. Traits: Inflict (Restrained). Special: Once per mission, the web gun can fire a shot that gains the Spread Trait.'),
            ('Promethium Rounds',  'CUSTOM_AMMUNITION', NULL, 'SCARCE', 0,
             'Incendiary rounds that cast a spray of burning promethium over targets around the point of impact. Cost multiplier: x2 base ammo cost. Used with: Solid Projectile Weapons (excluding Shotguns). Traits: Inflict (Ablaze), Spread. Special: When used to target a Zone, creates a Minor Hazard that lasts for 1d10+5 rounds or until doused.')
        ) AS t(name, category, cost, avail, enc, descr)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec.name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
            VALUES (rec.name, rec.category, rec.avail, rec.enc, rec.cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category = rec.category,
                availability       = rec.avail,
                encumbrance        = rec.enc,
                cost               = rec.cost,
                source_book        = 'MR'
            WHERE id = inv_id;
        END IF;

        INSERT INTO generic_item (id, description)
        VALUES (inv_id, rec.descr)
        ON CONFLICT (id) DO UPDATE SET description = EXCLUDED.description;
    END LOOP;
END $$;


-- ====================================================================
-- GRENADES AND EXPLOSIVES
-- ====================================================================

DO $$
DECLARE
    inv_id  BIGINT;
    spec_id BIGINT;
    rec     RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('Breaching Charge',   'ORDNANCE',            12,  1, 150, 'SCARCE', 'Loud, Spread, Unstable'),
            ('Incendiary Charge',  'ENGINEERING',         6,   1, 100, 'SCARCE', 'Blast, Inflict (Ablaze), Loud, Spread, Unstable'),
            ('Emergency Flare',    'ENGINEERING',         4,   1, 30,  'SCARCE', 'Ineffective, Inflict (Ablaze)'),
            ('Mines',              'ENGINEERING',         12,  1, 50,  'COMMON', 'Blast, Loud, Penetrating (2), Unstable'),
            ('Scare Gas Grenade',  'THROWN',              NULL,0, 200, 'RARE',   'Inflict (Frightened), Loud, Thrown (Medium), Unstable')
        ) AS t(_name, _specs, _damage, _enc, _cost, _avail, _special)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
            VALUES (rec._name, 'GRENADES_AND_EXPLOSIVES', rec._avail, rec._enc, rec._cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category = 'GRENADES_AND_EXPLOSIVES',
                availability       = rec._avail,
                encumbrance        = rec._enc,
                cost               = rec._cost,
                source_book        = 'MR'
            WHERE id = inv_id;
        END IF;

        DELETE FROM generic_item WHERE id = inv_id;

        INSERT INTO grenades_and_explosives (id, damage, special, description)
        VALUES (inv_id, rec._damage, rec._special, NULL)
        ON CONFLICT (id) DO UPDATE SET
            damage  = EXCLUDED.damage,
            special = EXCLUDED.special;

        DELETE FROM grenade_specializations WHERE grenade_id = inv_id;

        FOR spec_id IN
            SELECT s.id FROM specialization s
            WHERE s.name = ANY(string_to_array(rec._specs, ','))
        LOOP
            INSERT INTO grenade_specializations (grenade_id, specialization_id)
            VALUES (inv_id, spec_id)
            ON CONFLICT DO NOTHING;
        END LOOP;
    END LOOP;
END $$;


-- ====================================================================
-- WEAPON MODIFICATIONS
-- ====================================================================

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('Black Market Focusing Crystal', 'COMBAT_ATTACHMENTS', NULL, 'RARE',   0,
             'A non-standard focusing crystal fitted to a las weapon, forming a more precise beam. Grants Penetrating (2) and Unstable Traits to the las weapon. Cost: 20% of the base weapon cost. Used with: Any Las Weapon. Cannot be used with sanctioned permission from the Adeptus Mechanicus.'),
            ('Collapsible Stock',             'SUPPORT_ATTACHMENTS', 100, 'SCARCE', 0,
             'A folding or collapsible stock fitted to a long gun. Reduces Encumbrance by 1 while the stock is folded. Awareness (Sight) Tests to spot the weapon have −1 SL while folded. Folding/unfolding is an Action. Ranged attacks made with the stock folded have −1 SL. Used with: Any Ranged Weapon with the Two-handed Trait.'),
            ('Foregrip',                      'SUPPORT_ATTACHMENTS', 150, 'RARE',   0,
             'A secondary grip fitted under the barrel for stability. The weapon gains the Close Trait, and characters gain +1 SL when firing at a target within Close or Short Range. Used with: Any Ranged Weapon with the Two-handed Trait and base Enc. of 2 or less.'),
            ('Infrascope',                    'SIGHTS',              200, 'RARE',   0,
             'A thermal imaging scope that displays a heat-map of the environment. Grants +1 SL on successful Ranged Tests to hit heat-emitting targets. The wielder ignores the Dark and Poorly Lit Environmental Traits when using the scope. Used with: Any Ranged Weapon.'),
            ('Strobing Phosphor-lumen',        'COMBAT_ATTACHMENTS',  80, 'SCARCE', 0,
             'A strobing light unit mounted on a weapon. As a Free Action: the Zone loses the Dark or Poorly Lit condition; any hostile creature in the Zone must pass a Hard (−20) Reflexes Test or suffer the Blinded Condition until end of their next turn. Used with: Any Ranged Weapon with the Two-handed Trait.'),
            ('Suspensor',                     'SUPPORT_ATTACHMENTS', 500, 'EXOTIC', 0,
             'Limited anti-grav technology fitted to a weapon to lighten the load and stabilise it while firing. The weapon gains the Reliable Trait, and weapons with the Heavy Trait reduce the Heavy value by 2. Used with: Any Ranged Weapon.')
        ) AS t(name, subcat, cost, avail, enc, descr)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec.name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost, source_book)
            VALUES (rec.name, 'WEAPON_MODIFICATION', rec.subcat, rec.avail, rec.enc, rec.cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category    = 'WEAPON_MODIFICATION',
                inventory_subcategory = rec.subcat,
                availability          = rec.avail,
                encumbrance           = rec.enc,
                cost                  = rec.cost,
                source_book           = 'MR'
            WHERE id = inv_id;
        END IF;

        INSERT INTO generic_item (id, description)
        VALUES (inv_id, rec.descr)
        ON CONFLICT (id) DO UPDATE SET description = EXCLUDED.description;
    END LOOP;
END $$;


-- ====================================================================
-- ARMOUR
-- ====================================================================

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            -- name,                              subcat,     ap, enc, cost,  avail,    weight_worn, locations,                  special
            -- Enc column from PDF is stored enc; weight_worn is enc when equipped (shown in parentheses)
            ('''Darkshroud'' Flak Armour',         'FLAK',     3,  3,  2000,  'EXOTIC', 4,           ARRAY['ALL'],               NULL),
            ('Flak-weave Greatcoat',               'FLAK',     3,  2,  1000,  'SCARCE', 3,           ARRAY['ARMS','BODY','LEGS'], NULL),
            ('Macharian Honour Guard Armour',       'CARAPACE', 6,  3,  10000, 'EXOTIC', 4,           ARRAY['ALL'],               'Heavy (4); 6 AP front / 3 AP back'),
            ('Void Armour',                        'CARAPACE', 5,  5,  4000,  'RARE',   6,           ARRAY['ALL'],               'Heavy (4), Loud'),
            -- Industrial Protection Suits
            ('Light Industrial Protection Suit',   'BASIC',    2,  1,  200,   'COMMON', 3,           ARRAY['ARMS','BODY','LEGS'], NULL),
            ('Medium Industrial Protection Suit',  'BASIC',    3,  2,  500,   'COMMON', 4,           ARRAY['ARMS','BODY','LEGS'], NULL),
            ('Heavy Industrial Protection Suit',   'BASIC',    4,  3,  1000,  'SCARCE', 5,           ARRAY['ARMS','BODY','LEGS'], 'Heavy (4), Loud')
        ) AS t(_name, _subcat, _ap, _enc, _cost, _avail, _weight_worn, _locations, _special)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost, source_book)
            VALUES (rec._name, 'ARMOUR', rec._subcat, rec._avail, rec._enc, rec._cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category    = 'ARMOUR',
                inventory_subcategory = rec._subcat,
                availability          = rec._avail,
                encumbrance           = rec._enc,
                cost                  = rec._cost,
                source_book           = 'MR'
            WHERE id = inv_id;
        END IF;

        DELETE FROM generic_item WHERE id = inv_id;

        INSERT INTO armour (id, armor_points, weight_worn, special)
        VALUES (inv_id, rec._ap, rec._weight_worn, rec._special)
        ON CONFLICT (id) DO UPDATE SET
            armor_points = EXCLUDED.armor_points,
            weight_worn  = EXCLUDED.weight_worn,
            special      = EXCLUDED.special;

        DELETE FROM armour_locations WHERE armour_id = inv_id;

        INSERT INTO armour_locations (armour_id, location)
        SELECT inv_id, unnest(rec._locations);
    END LOOP;
END $$;


-- ====================================================================
-- ARMOUR MODIFICATIONS
-- ====================================================================

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('Additional Armour Plating', NULL, 'SCARCE', 0,
             'Affixes additional ceramic plates to flak or carapace armour, increasing Armour Value by 1. Prevents further Modifications. Non-Mesh armour gains the Loud Trait. Cost: half the price of the base armour.'),
            ('Auspex Helmet Array',       1200, 'RARE',   0,
             'A helmet-mounted auspex array. Grants Advantage on Tests to avoid being ambushed. As an Action during combat, reveals energy emissions, life signs, and movement up to Medium Range. The GM may call for a Tech Test to overcome interference or analyse complex information.'),
            ('Ceramite Plating & Coating', NULL,'RARE',   0,
             'Ceramite plating added to an armour piece, granting +1 Armour against Damage from Flamer and Spread weapons. Adds the Loud Trait. Prevents further Modifications to the piece. Cost: equal to the base armour price.'),
            ('Mounted Pict Recorder',     1200, 'RARE',   0,
             'A pict-recorder with back unit (power supply and data storage) mounted to an armour piece. Records everything visible from the front for 10 hours. Storage can be connected to a cogitator or viewscreen to review footage.'),
            ('Reinforced Mirror-visor',   1000, 'RARE',   0,
             'A mirror-visor fitted to a helmet that protects against blinding effects. While wearing this helmet, gain Advantage on Tests to resist effects that cause the Blinded Condition.')
        ) AS t(name, cost, avail, enc, descr)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec.name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
            VALUES (rec.name, 'WEAPON_MODIFICATION', rec.avail, rec.enc, rec.cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category = 'WEAPON_MODIFICATION',
                availability       = rec.avail,
                encumbrance        = rec.enc,
                cost               = rec.cost,
                source_book        = 'MR'
            WHERE id = inv_id;
        END IF;

        INSERT INTO generic_item (id, description)
        VALUES (inv_id, rec.descr)
        ON CONFLICT (id) DO UPDATE SET description = EXCLUDED.description;
    END LOOP;
END $$;