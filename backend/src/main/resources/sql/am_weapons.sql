-- =====================================================================
-- ADEPTUS MECHANICUS SUPPLEMENT — WEAPONS
-- Source: Assembly of Means supplement
-- Note: All specialised melee and specialised ranged weapons listed
--       have the "Secrets of Mars" Trait appended to their specials.
-- Run AFTER: melee_weapon.sql, ranged_weapon.sql,
--            specializations_data.sql, am_roles_data.sql
-- =====================================================================

-- =====================================================================
-- MELEE WEAPONS
-- Columns: _name, _spec, _subcat, _damage, _enc, _cost, _avail, _special
-- _spec: 'ONE-HANDED' | 'TWO-HANDED' | 'BRAWLING'
-- =====================================================================
DO $$
DECLARE
    inv_id  BIGINT;
    spec_id BIGINT;
    rec     RECORD;
BEGIN
FOR rec IN
SELECT * FROM (VALUES

    -- CAVALRY WEAPONS
    ('Cavalry Sabre',              'ONE-HANDED', 'MUNDANE',     '5+StrB', 1, 3000,  'SCARCE', 'Penetrating (3)'),
    ('Cavalry Arc Maul',           'ONE-HANDED', 'SHOCK',       '3+StrB', 1, 5000,  'RARE',   'Inflict (Stunned)'),
    ('Taser Lance',                'TWO-HANDED', 'SHOCK',       '4+StrB', 2, 5000,  'RARE',   'Inflict (Stunned), Reach'),

    -- ELECTRO-PRIEST WEAPONS
    ('Electrostatic Gauntlets',    'BRAWLING',   'SHOCK',       '4+StrB', 2, 4000,  'EXOTIC', 'Inflict (Stunned), Reach'),
    ('Electroleech Stave',         'TWO-HANDED', 'SHOCK',       '2+StrB', 3, 4000,  'EXOTIC', 'Inflict (Stunned), Defensive'),

    -- OMNISSIAN WEAPONS
    ('Omnissian Axe (One-Handed)', 'ONE-HANDED', 'POWER',       '2+StrB', 1, 4000,  'EXOTIC', 'Master-crafted, Ornamental, Rend (1)'),
    ('Omnissian Axe (Two-Handed)', 'TWO-HANDED', 'POWER',       '4+StrB', 3, 6000,  'EXOTIC', 'Heavy (3), Master-crafted, Ornamental, Rend (2), Two-handed'),
    ('Omnissian Glaive',           'TWO-HANDED', 'POWER',       '4+StrB', 3, 6000,  'EXOTIC', 'Heavy (4), Master-crafted, Ornamental, Penetrating (2), Two-handed'),
    ('Omnissian Rod',              'TWO-HANDED', 'POWER',       '3+StrB', 3, 10000, 'EXOTIC', 'Master-crafted, Ornamental, Two-handed'),

    -- TRANSONIC WEAPONS
    ('Transonic Blade',            'ONE-HANDED', 'EXOTIC_MELEE','3+StrB', 2, 5000,  'RARE',   'Lightweight'),
    ('Transonic Chordclaw',        'BRAWLING',   'EXOTIC_MELEE','3+StrB', 2, 5000,  'RARE',   'Lightweight'),
    ('Transonic Razor',            'ONE-HANDED', 'EXOTIC_MELEE','2+StrB', 1, 4000,  'RARE',   'Lightweight'),

    -- SPECIALISED WEAPONS (all gain Secrets of Mars trait)
    ('Breacher',                   'ONE-HANDED', 'EXOTIC_MELEE','5+StrB', 3, 7000,  'SCARCE', 'Heavy (2), Loud, Rend (4), Secrets of Mars'),
    ('Control Stave',              'ONE-HANDED', 'SHOCK',       '3+StrB', 1, 2000,  'EXOTIC', 'Inflict (Stunned), Defensive, Ornamental, Secrets of Mars'),
    ('Pteraxii Talons',            'BRAWLING',   'EXOTIC_MELEE','3+StrB', 1, 2000,  'RARE',   'Rend (4), Inflict (Bleeding), Secrets of Mars'),
    ('Rod of Office',              'ONE-HANDED', 'EXOTIC_MELEE','1+StrB', 1, 3000,  'EXOTIC', 'Defensive, Ornamental, Secrets of Mars'),
    ('Servo Arm',                  'BRAWLING',   'EXOTIC_MELEE','4+StrB', 2, 4000,  'RARE',   'Heavy (4), Penetrating (2), Secrets of Mars'),
    ('Taser Goad',                 'ONE-HANDED', 'SHOCK',       '2+StrB', 1, 900,   'RARE',   'Inflict (Stunned), Loud, Defensive, Secrets of Mars'),
    ('Vivisector',                 'BRAWLING',   'EXOTIC_MELEE','2+StrB', 1, 10000, 'RARE',   'Master-crafted, Secrets of Mars')

) AS t(_name, _spec, _subcat, _damage, _enc, _cost, _avail, _special)
LOOP
    SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;
    SELECT id INTO inv_id  FROM inventory        WHERE name = rec._name LIMIT 1;

    IF inv_id IS NULL THEN
        INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost)
        VALUES (rec._name, 'MELEE_WEAPON', rec._subcat, rec._avail, rec._enc, rec._cost)
        RETURNING id INTO inv_id;
    ELSE
        UPDATE inventory
        SET inventory_category    = 'MELEE_WEAPON',
            inventory_subcategory = rec._subcat,
            availability          = rec._avail,
            encumbrance           = rec._enc,
            cost                  = rec._cost
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


-- =====================================================================
-- RANGED WEAPONS
-- Columns: _name, _spec, _subcat, _damage, _range, _mag, _enc, _cost, _avail, _special
-- _spec: 'PISTOLS' | 'LONG GUNS' | 'ORDNANCE'
-- =====================================================================
DO $$
DECLARE
    inv_id  BIGINT;
    spec_id BIGINT;
    rec     RECORD;
BEGIN
FOR rec IN
SELECT * FROM (VALUES

    -- ARC WEAPONS
    ('Heavy Arc Rifle',       'ORDNANCE',   'ARC',             14, 'LONG',    5, 4, 8000,  'EXOTIC', 'Loud, Heavy (4), Burst, Two-handed'),
    ('Arc Pistol',            'PISTOLS',    'ARC',             10, 'MEDIUM',  3, 2, 3000,  'RARE',   'Close, Loud, Burst'),
    ('Arc Rifle',             'LONG GUNS',  'ARC',             12, 'LONG',    3, 3, 5000,  'RARE',   'Loud, Two-handed, Burst'),

    -- FLECHETTE WEAPONS
    ('Flechette Blaster',     'PISTOLS',    'FLECHETTE',        5, 'MEDIUM',  6, 1, 2500,  'SCARCE', 'Close, Loud, Rapid Fire (3), Two-handed'),
    ('Flechette Carbine',     'LONG GUNS',  'FLECHETTE',        5, 'MEDIUM',  8, 2, 4500,  'SCARCE', 'Loud, Rapid Fire (4), Two-handed'),

    -- GALVANIC WEAPONS
    ('Galvanic Carbine',      'LONG GUNS',  'GALVANIC',         7, 'MEDIUM',  4, 2, 2000,  'RARE',   'Loud, Two-handed, Penetrating (1)'),
    ('Galvanic Rifle',        'LONG GUNS',  'GALVANIC',         7, 'LONG',    4, 3, 4000,  'RARE',   'Loud, Two-handed, Penetrating (1)'),

    -- PHOSPHOR WEAPONS
    ('Phosphor Pistol',       'PISTOLS',    'PHOSPHOR',         7, 'MEDIUM',  4, 1, 2500,  'RARE',   'Close, Loud, Rend (1)'),
    ('Phosphor Blast Carbine','LONG GUNS',  'PHOSPHOR',         8, 'MEDIUM',  5, 2, 4500,  'RARE',   'Loud, Two-handed, Blast, Rend (1)'),
    ('Phosphor Serpenta',     'PISTOLS',    'PHOSPHOR',         8, 'MEDIUM',  5, 2, 3500,  'EXOTIC', 'Close, Loud, Heavy (3), Rend (2)'),
    ('Phosphor Torch',        'LONG GUNS',  'PHOSPHOR',         8, 'MEDIUM',  6, 3, 5500,  'RARE',   'Flamer, Loud, Rend (1), Two-handed'),

    -- RADIUM WEAPONS
    ('Radium Pistol',         'PISTOLS',    'RADIUM',           6, 'SHORT',   5, 1, 4000,  'RARE',   'Close, Loud'),
    ('Radium Carbine',        'LONG GUNS',  'RADIUM',           6, 'MEDIUM',  6, 2, 5000,  'RARE',   'Loud, Two-handed'),
    ('Radium Serpenta',       'PISTOLS',    'RADIUM',           8, 'MEDIUM',  6, 2, 7000,  'EXOTIC', 'Close, Loud, Heavy (3)'),
    ('Radium Jezzail',        'ORDNANCE',   'RADIUM',           9, 'LONG',    4, 3, 9000,  'EXOTIC', 'Loud, Heavy (4), Penetrating (3), Two-handed'),

    -- SOLID PROJECTILE (AM supplement additions)
    ('Cognis Heavy Stubber',  'ORDNANCE',   'SOLID_PROJECTILE', 8, 'EXTREME', 7, 3, 8000,  'RARE',   'Heavy (4), Loud, Penetrating (3), Rapid Fire (4), Two-handed'),
    ('Macrostubber',          'LONG GUNS',  'SOLID_PROJECTILE', 8, 'MEDIUM',  7, 2, 6000,  'RARE',   'Heavy (4), Loud, Penetrating (3), Rapid Fire (2)'),
    ('Stubcarbine',           'PISTOLS',    'SOLID_PROJECTILE', 7, 'SHORT',   4, 2, 4000,  'RARE',   'Heavy (3), Loud, Penetrating (3), Two-handed, Rapid Fire (4)'),

    -- SPECIALISED RANGED (all gain Secrets of Mars trait)
    ('Eradication Pistol',    'PISTOLS',    'SPECIALIZED',     10, 'SHORT',   5, 2, 8000,  'EXOTIC', 'Close, Loud, Penetrating (3), Rend (2), Secrets of Mars'),
    ('Eradication Ray',       'ORDNANCE',   'SPECIALIZED',     10, 'MEDIUM',  6, 3, 10000, 'EXOTIC', 'Loud, Heavy (4), Penetrating (3), Rend (2), Secrets of Mars'),
    ('Gamma Pistol',          'PISTOLS',    'SPECIALIZED',      9, 'SHORT',   5, 2, 7500,  'EXOTIC', 'Close, Loud, Inflict (Poison), Penetrating (4), Secrets of Mars'),
    ('Magnarail Lance',       'ORDNANCE',   'SPECIALIZED',     12, 'LONG',    6, 3, 10000, 'EXOTIC', 'Loud, Heavy (4), Penetrating (5), Secrets of Mars'),
    ('Plasma Caliver',        'LONG GUNS',  'SPECIALIZED',     10, 'LONG',   10, 3, 10000, 'EXOTIC', 'Burst, Loud, Penetrating (5), Supercharge (4), Two-handed, Unstable, Secrets of Mars'),
    ('Transonic Cannon',      'LONG GUNS',  'SPECIALIZED',      8, 'MEDIUM',  4, 3, 5500,  'EXOTIC', 'Loud, Flamer, Inflict (Bleeding), Heavy (4), Secrets of Mars'),
    ('Transuranic Arquebus',  'ORDNANCE',   'SPECIALIZED',      8, 'EXTREME', 3, 4, 6500,  'EXOTIC', 'Loud, Heavy (4), Penetrating (6), Two-handed, Secrets of Mars'),
    ('Volkite Blaster',       'ORDNANCE',   'SPECIALIZED',      9, 'MEDIUM',  8, 3, 7500,  'EXOTIC', 'Loud, Inflict (Ablaze), Heavy (4), Rend (3), Secrets of Mars')

) AS t(_name, _spec, _subcat, _damage, _range, _mag, _enc, _cost, _avail, _special)
LOOP
    SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;
    SELECT id INTO inv_id  FROM inventory        WHERE name = rec._name LIMIT 1;

    IF inv_id IS NULL THEN
        INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost)
        VALUES (rec._name, 'RANGED_WEAPON', rec._subcat, rec._avail, rec._enc, rec._cost)
        RETURNING id INTO inv_id;
    ELSE
        UPDATE inventory
        SET inventory_category    = 'RANGED_WEAPON',
            inventory_subcategory = rec._subcat,
            availability          = rec._avail,
            encumbrance           = rec._enc,
            cost                  = rec._cost
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