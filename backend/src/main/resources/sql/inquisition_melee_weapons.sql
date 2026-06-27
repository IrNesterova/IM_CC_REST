-- =====================================================================
-- IMPERIUM MALEDICTUM — INQUISITION MELEE WEAPONS
-- Source: IM Inquisition Player's Guide
-- Run AFTER: melee_weapon.sql
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
            -- name,                               spec,          subcat,        damage,    enc, cost,   avail,    special
            -- EXOTIC MELEE WEAPONS
            ('Blink-Blade',                    'ONE-HANDED', 'EXOTIC_MELEE', '3+StrB',  1,   4000,  'EXOTIC', 'Penetrating (2)'),
            ('Scythian Venom Talon',           'ONE-HANDED', 'EXOTIC_MELEE', '2+StrB',  1,   2000,  'EXOTIC', 'Inflict (Poisoned)'),
            ('Duelling Glaive',                'TWO-HANDED', 'EXOTIC_MELEE', '5+StrB',  2,   1000,  'RARE',   'Defensive, Reach, Two-handed'),

            -- NEMESIS WEAPONS
            ('Daemonhammer (One-handed)',       'ONE-HANDED', 'NEMESIS',     '5+StrB',  1,   5000,  'EXOTIC', 'Penetrating (2)'),
            ('Daemonhammer (Two-handed)',       'TWO-HANDED', 'NEMESIS',     '6+StrB',  2,   6000,  'EXOTIC', 'Heavy (4), Inflict (Stunned), Penetrating (2), Two-handed'),
            ('Nemesis Daemonhammer (One-handed)', 'ONE-HANDED', 'NEMESIS',   '5+StrB',  1,   8000,  'EXOTIC', 'Penetrating (2)'),
            ('Nemesis Daemonhammer (Two-handed)', 'TWO-HANDED', 'NEMESIS',   '6+StrB',  2,  10000,  'EXOTIC', 'Heavy (4), Inflict (Stunned), Penetrating (2), Two-handed'),
            ('Truename Staff',                 'TWO-HANDED', 'NEMESIS',     '2+StrB',  2,  10000,  'EXOTIC', 'Defensive, Two-handed'),

            -- NULL WEAPONS
            ('Null Rod',                       'TWO-HANDED', 'NULL_WEAPON', '1+StrB',  2,   1000,  'RARE',   'Defensive, Two-handed'),

            -- POWER WEAPONS
            ('Aeldari Power Sword',            'ONE-HANDED', 'POWER',       '4+StrB',  1,   5000,  'RARE',   'Penetrating (4)'),
            ('Executioner Greatblade',         'TWO-HANDED', 'POWER',       '5+StrB',  2,   1500,  'EXOTIC', 'Defensive, Heavy (4), Two-handed, Penetrating (4)'),
            ('Power Stake',                    'TWO-HANDED', 'POWER',       '4+StrB',  2,   3500,  'RARE',   'Two-handed, Penetrating (4)'),
            ('Xenophase Blade',                'ONE-HANDED', 'POWER',       '4+StrB',  1,   4000,  'EXOTIC', 'Penetrating (4 or X)'),

            -- TAINTED WEAPONS
            ('Daemonblade',                    'TWO-HANDED', 'TAINTED',     '5+StrB',  2,  10000,  'EXOTIC', '*'),
            ('Tainted Blade',                  'ONE-HANDED', 'TAINTED',     '4+StrB',  1,  10000,  'EXOTIC', 'Rend (4)')

        ) AS t(_name, _spec, _subcat, _damage, _weight, _cost, _avail, _special)
    LOOP
        SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;
        SELECT id INTO inv_id  FROM inventory       WHERE name = rec._name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost, source_book)
            VALUES (rec._name, 'MELEE_WEAPON', rec._subcat, rec._avail, rec._weight, rec._cost, 'IN')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category    = 'MELEE_WEAPON',
                inventory_subcategory = rec._subcat,
                availability          = rec._avail,
                encumbrance           = rec._weight,
                cost                  = rec._cost,
                source_book           = 'IN'
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