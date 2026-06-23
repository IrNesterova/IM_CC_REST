DO $$
DECLARE
inv_id BIGINT;
    spec_id BIGINT;
    rec RECORD;
BEGIN
FOR rec IN
SELECT * FROM (VALUES
                   ('Bolt Pistol',           'PISTOLS',    'BOLT',             8,    'MEDIUM',  2,  2, 4000,  'RARE',   'Burst, Close, Loud, Penetrating (4), Spread'),
                   ('Boltgun',               'LONG GUNS',  'BOLT',             8,    'LONG',    4,  3, 5000,  'RARE',   'Loud, Penetrating (4), Rapid Fire (2), Spread, Two-handed'),
                   ('Heavy Bolter',          'ORDNANCE',   'BOLT',             10,   'LONG',    6,  4, 9000,  'RARE',   'Heavy (4), Penetrating (5), Loud, Rapid Fire (3), Spread, Two-handed'),
                   ('Hand Flamer',           'PISTOLS',    'FLAME',            7,    'SHORT',   2,  1, 500,   'RARE',   'Close, Flamer, Inflict (Ablaze), Loud'),
                   ('Flamer',                'LONG GUNS',  'FLAME',            8,    'MEDIUM',  4,  2, 1000,  'SCARCE', 'Flamer, Inflict (Ablaze), Loud, Two-handed'),
                   ('Laspistol',             'PISTOLS',    'LAS',              5,    'MEDIUM',  4,  0, 400,   'COMMON', 'Burst, Close, Loud, Reliable'),
                   ('Lasgun',                'LONG GUNS',  'LAS',              6,    'LONG',    8,  2, 600,   'COMMON', 'Burst, Loud, Reliable, Two-handed'),
                   ('Las Carbine',           'LONG GUNS',  'LAS',              5,    'MEDIUM',  6,  1, 800,   'COMMON', 'Loud, Rapid Fire, Reliable, Two-handed'),
                   ('Long Las',              'LONG GUNS',  'LAS',              6,    'EXTREME', 4,  2, 1000,  'SCARCE', 'Burst, Loud, Penetrating (1), Reliable, Two-handed'),
                   ('Hot-Shot Laspistol',    'PISTOLS',    'LAS',              8,    'MEDIUM',  2,  1, 900,   'RARE',   'Burst, Close, Loud, Penetrating (2)'),
                   ('Hot-Shot Lasgun',       'LONG GUNS',  'LAS',              8,    'LONG',    4,  3, 1000,  'RARE',   'Burst, Loud, Penetrating (2), Two-handed'),
                   ('Lascannon',             'ORDNANCE',   'LAS',              18,   'EXTREME', 5,  4, 8000,  'RARE',   'Heavy (4), Loud, Penetrating (10), Two-handed'),
                   ('Grenade Launcher',      'ORDNANCE',   'LAUNCHER',         NULL, 'LONG',    6,  2, 1000,  'RARE',   'Loud, Two-handed'),
                   ('Portable Missile Launcher', 'ORDNANCE', 'LAUNCHER',       NULL, 'EXTREME', 1,  3, 2000,  'RARE',   'Heavy (4), Loud, Two-handed'),
                   ('Inferno Pistol',        'PISTOLS',    'MELTA',            16,   'SHORT',   3,  1, 8000,  'EXOTIC', 'Close, Loud, Rend (5)'),
                   ('Meltagun',              'LONG GUNS',  'MELTA',            16,   'MEDIUM',  5,  2, 9000,  'RARE',   'Loud, Rend (5), Two-handed'),
                   ('Plasma Pistol',         'PISTOLS',    'PLASMA',           10,   'MEDIUM',  6,  1, 7000,  'RARE',   'Close, Loud, Penetrating (6), Supercharge (4), Unstable'),
                   ('Plasma Gun',            'LONG GUNS',  'PLASMA',           10,   'LONG',    12, 2, 8000,  'RARE',   'Loud, Penetrating (6), Supercharge (4), Two-handed, Unstable'),
                   ('Autopistol',            'PISTOLS',    'SOLID_PROJECTILE', 5,    'MEDIUM',  3,  0, 400,   'COMMON', 'Close, Loud, Rapid Fire (3)'),
                   ('Autogun',               'LONG GUNS',  'SOLID_PROJECTILE', 6,    'LONG',    5,  2, 600,   'COMMON', 'Loud, Rapid Fire (3), Two-handed'),
                   ('Hand Cannon',           'PISTOLS',    'SOLID_PROJECTILE', 8,    'MEDIUM',  4,  1, 550,   'SCARCE', 'Close, Heavy (4), Loud, Penetrating (2)'),
                   ('Heavy Stubber',         'ORDNANCE',   'SOLID_PROJECTILE', 8,    'EXTREME', 8,  3, 2000,  'SCARCE', 'Heavy (4), Loud, Penetrating (3), Two-handed, Rapid Fire (4)'),
                   ('Shotgun (Combat)',      'LONG GUNS',  'SOLID_PROJECTILE', 6,    'MEDIUM',  12, 2, 600,   'SCARCE', 'Inflict (Prone), Loud, Spread, Two-handed'),
                   ('Shotgun (Pump Action)', 'LONG GUNS',  'SOLID_PROJECTILE', 6,    'MEDIUM',  8,  1, 400,   'COMMON', 'Inflict (Prone), Loud, Spread, Two-handed'),
                   ('Sniper Rifle',          'LONG GUNS',  'SOLID_PROJECTILE', 8,    'EXTREME', 6,  2, 1000,  'SCARCE', 'Loud, Two-handed'),
                   ('Stub Pistol',           'PISTOLS',    'SOLID_PROJECTILE', 6,    'MEDIUM',  2,  0, 250,   'COMMON', 'Burst, Close, Loud'),
                   ('Stub Revolver',         'PISTOLS',    'SOLID_PROJECTILE', 6,    'MEDIUM',  6,  0, 200,   'COMMON', 'Close, Loud, Reliable'),
                   ('Needle Pistol',         'PISTOLS',    'SPECIALIZED',      1,    'MEDIUM',  4,  1, 1500,  'EXOTIC', 'Close, Inflict (Poisoned), Penetrating (6), Subtle'),
                   ('Needle Rifle',          'LONG GUNS',  'SPECIALIZED',      1,    'LONG',    6,  2, 1700,  'EXOTIC', 'Inflict (Poisoned), Penetrating (6), Subtle, Two-handed'),
                   ('Web Pistol',            'PISTOLS',    'SPECIALIZED',      NULL, 'SHORT',   3,  1, 1300,  'RARE',   'Close, Inflict (Restrained)'),
                   ('Webber',                'LONG GUNS',  'SPECIALIZED',      NULL, 'MEDIUM',  6,  2, 1500,  'RARE',   'Inflict (Restrained), Two-handed')
              ) AS t(_name, _spec, _subcat, _damage, _range, _mag, _weight, _cost, _avail, _special)
    LOOP
SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;
SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost)
            VALUES (rec._name, 'RANGED_WEAPON', rec._subcat, rec._avail, rec._weight, rec._cost)
            RETURNING id INTO inv_id;
ELSE
UPDATE inventory
SET inventory_category = 'RANGED_WEAPON',
    inventory_subcategory = rec._subcat,
                availability = rec._avail,
                encumbrance = rec._weight,
                cost = rec._cost
WHERE id = inv_id;
END IF;

DELETE FROM generic_item WHERE id = inv_id;

INSERT INTO ranged_weapon (id, specialization_id, damage, range, mag_size, special)
VALUES (inv_id, spec_id, rec._damage, rec._range, rec._mag, rec._special)
    ON CONFLICT (id) DO UPDATE SET
    specialization_id = EXCLUDED.specialization_id,
                            damage = EXCLUDED.damage,
                            range = EXCLUDED.range,
                            mag_size = EXCLUDED.mag_size,
                            special = EXCLUDED.special;
END LOOP;
END $$;