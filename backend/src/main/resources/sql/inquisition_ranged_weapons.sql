-- =====================================================================
-- IMPERIUM MALEDICTUM — INQUISITION RANGED WEAPONS
-- Source: IM Inquisition Player's Guide
-- Run AFTER: ranged_weapon.sql
-- =====================================================================

-- Drop the subcategory check constraint so new enum values are accepted.
-- Hibernate will recreate it with updated values on next app startup.
ALTER TABLE inventory DROP CONSTRAINT IF EXISTS inventory_inventory_subcategory_check;

DO $$
DECLARE
    inv_id  BIGINT;
    spec_id BIGINT;
    rec     RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            -- name,                           spec,          subcat,             dam,  range,     mag, enc,  cost,   avail,    special
            -- BOLT WEAPONS
            ('Psycannon',                  'LONG GUNS',  'BOLT',             12,   'LONG',    6,   3,   24000, 'EXOTIC', 'Loud, Penetrating (5), Rapid Fire (3), Spread, Two-handed'),
            ('Condemnor Boltgun',          'LONG GUNS',  'BOLT',             8,    'LONG',    4,   2,   10000, 'EXOTIC', 'Loud, Penetrating (4), Rapid Fire (2), Spread, Two-handed'),
            ('Condemnor Boltgun (Stake)',  'ORDNANCE',   'BOLT',             6,    'LONG',    1,   0,   10000, 'EXOTIC', 'Penetrating (4), Two-handed'),

            -- CROSSBOW WEAPONS
            ('Handbow',                    'PISTOLS',    'CROSSBOW',         5,    'SHORT',   1,   0,   500,   'RARE',   'Close, Penetrating (2), Subtle'),
            ('Purgatus Crossbow',          'LONG GUNS',  'CROSSBOW',         7,    'LONG',    1,   1,   900,   'EXOTIC', 'Penetrating (4), Reliable'),
            ('Stake Crossbow',             'LONG GUNS',  'CROSSBOW',         6,    'LONG',    1,   1,   700,   'RARE',   'Penetrating (2)'),

            -- FLAME WEAPONS
            ('Incinerator',                'LONG GUNS',  'FLAME',            9,    'MEDIUM',  4,   2,   4000,  'RARE',   'Flamer, Inflict (Ablaze), Loud, Two-handed'),

            -- GRAVITON WEAPONS
            ('Graviton Pistol',            'PISTOLS',    'GRAVITON',         4,    'SHORT',   3,   0,   1000,  'EXOTIC', 'Blast, Close'),
            ('Graviton Gun',               'LONG GUNS',  'GRAVITON',         5,    'LONG',    5,   1,   1500,  'EXOTIC', 'Blast'),

            -- KROOT WEAPONS
            ('Kroot Gun',                  'ORDNANCE',   'KROOT',            8,    'LONG',    8,   3,   1500,  'EXOTIC', 'Heavy (4), Loud, Penetrating (2), Rapid Fire (4), Two-handed'),
            ('Kroot Pistol',               'PISTOLS',    'KROOT',            6,    'SHORT',   6,   0,   800,   'EXOTIC', 'Close, Loud, Penetrating (2)'),
            ('Kroot Rifle',                'LONG GUNS',  'KROOT',            7,    'LONG',    4,   1,   1000,  'EXOTIC', 'Loud, Penetrating (2), Two-handed'),
            ('Kroot Sniper Rifle',         'LONG GUNS',  'KROOT',            8,    'EXTREME', 3,   2,   1200,  'EXOTIC', 'Loud, Heavy (4), Penetrating (2), Rapid Fire (2), Two-handed'),

            -- MALEFIC WEAPONS
            ('Hell Rifle',                 'LONG GUNS',  'MALEFIC',          10,   'EXTREME', 6,   2,   10000, 'EXOTIC', 'Loud, Rend (4), Two-handed'),

            -- PULSE WEAPONS
            ('Pulse Pistol',               'PISTOLS',    'PULSE',            6,    'SHORT',   6,   0,   800,   'EXOTIC', 'Close, Loud, Penetrating (6), Subtle'),
            ('Pulse Carbine',              'LONG GUNS',  'PULSE',            7,    'MEDIUM',  4,   1,   1000,  'EXOTIC', 'Close, Loud, Burst, Penetrating (6)'),
            ('Pulse Rifle',                'LONG GUNS',  'PULSE',            7,    'LONG',    8,   1,   1200,  'EXOTIC', 'Penetrating (6), Rapid Fire (2), Two-handed'),

            -- SHURIKEN WEAPONS
            ('Shuriken Pistol',            'PISTOLS',    'SHURIKEN',         6,    'MEDIUM',  4,   0,   800,   'EXOTIC', 'Burst, Close, Penetrating (4), Reliable'),
            ('Shuriken Rifle',             'LONG GUNS',  'SHURIKEN',         8,    'LONG',    6,   1,   1200,  'EXOTIC', 'Penetrating (4), Rapid Fire (3), Reliable, Two-handed'),

            -- SOLID PROJECTILE WEAPONS
            ('Arbites Shotgun',            'LONG GUNS',  'SOLID_PROJECTILE', 8,    'LONG',    8,   1,   1000,  'RARE',   'Inflict (Prone), Loud, Reliable, Two-handed'),
            ('Shotpistol',                 'PISTOLS',    'SOLID_PROJECTILE', 7,    'MEDIUM',  4,   0,   800,   'RARE',   'Close, Inflict (Prone), Loud, Reliable'),

            -- SPECIALISED WEAPONS
            ('Digital Weapons',            'PISTOLS',    'SPECIALIZED',      NULL, 'SHORT',   1,   0,   5000,  'EXOTIC', 'Close, Subtle'),
            ('Neuro Disruptor',            'PISTOLS',    'SPECIALIZED',      8,    'SHORT',   3,   2,   2000,  'EXOTIC', 'Close, Inflict (Stunned), Penetrating (6)'),

            -- SPLINTER WEAPONS
            ('Splinter Pistol',            'PISTOLS',    'SPLINTER',         5,    'SHORT',   4,   0,   1000,  'EXOTIC', 'Burst, Close, Inflict (Poisoned), Penetrating (2)'),
            ('Splinter Rifle',             'LONG GUNS',  'SPLINTER',         6,    'LONG',    6,   1,   1500,  'EXOTIC', 'Inflict (Poisoned), Penetrating (2), Rapid Fire (3), Two-handed')

        ) AS t(_name, _spec, _subcat, _damage, _range, _mag, _enc, _cost, _avail, _special)
    LOOP
        SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;
        SELECT id INTO inv_id  FROM inventory       WHERE name = rec._name LIMIT 1;

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