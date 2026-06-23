DO $$
    DECLARE
        inv_id BIGINT;
        spec_id BIGINT;
        rec RECORD;
    BEGIN
        FOR rec IN
            SELECT * FROM (VALUES
                               ('Chainaxe',      'ONE-HANDED', 'CHAIN',   '3+StrB', 1, 600,  'RARE',   'Loud, Rend (3)'),
                               ('Chainsword',    'ONE-HANDED', 'CHAIN',   '3+StrB', 1, 500,  'SCARCE', 'Loud, Rend (2)'),
                               ('Eviscerator',   'TWO-HANDED', 'CHAIN',   '5+StrB', 3, 800,  'RARE',   'Heavy (4), Loud, Rend (4), Two-handed'),
                               ('Force Staff',   'TWO-HANDED', 'FORCE',   '1+StrB', 2, 7000, 'EXOTIC', 'Defensive, Two-handed'),
                               ('Force Sword',   'ONE-HANDED', 'FORCE',   '2+StrB', 1, 8000, 'EXOTIC', NULL),
                               ('Axe',           'ONE-HANDED', 'MUNDANE', '2+StrB', 1, 80,   'COMMON', 'Rend (1)'),
                               ('Brass Knuckles','BRAWLING',   'MUNDANE', '0+StrB', 0, 30,   'COMMON', 'Subtle'),
                               ('Flail',         'TWO-HANDED', 'MUNDANE', '3+StrB', 2, 200,  'COMMON', 'Heavy (3), Two-handed'),
                               ('Great Weapon',  'TWO-HANDED', 'MUNDANE', '4+StrB', 2, 300,  'SCARCE', 'Heavy (4), Two-handed'),
                               ('Hammer',        'ONE-HANDED', 'MUNDANE', '2+StrB', 1, 25,   'COMMON', NULL),
                               ('Improvised (One-handed)', 'ONE-HANDED', 'MUNDANE', '1+StrB', 1, NULL, NULL,   'Ineffective'),
                               ('Improvised (Two-handed)', 'TWO-HANDED', 'MUNDANE', '2+StrB', 3, NULL, NULL,   'Ineffective, Two-handed'),
                               ('Knife',         'ONE-HANDED', 'MUNDANE', '0+StrB', 0, 50,   'COMMON', 'Subtle, Thrown (Short)'),
                               ('Staff',         'TWO-HANDED', 'MUNDANE', '1+StrB', 2, 25,   'COMMON', 'Defensive, Two-handed'),
                               ('Sword',         'ONE-HANDED', 'MUNDANE', '2+StrB', 1, 150,  'COMMON', NULL),
                               ('Unarmed',       'BRAWLING',   'MUNDANE', '0+StrB', 0, NULL, NULL,   'Ineffective'),
                               ('Whip',          'ONE-HANDED', 'MUNDANE', '0+StrB', 1, 60,   'SCARCE', 'Loud, Reach'),
                               ('Electro-Flail', 'ONE-HANDED', 'SHOCK',   '0+StrB', 1, 500,  'SCARCE', 'Loud, Reach, Inflict (Stunned)'),
                               ('Shock Maul',    'ONE-HANDED', 'SHOCK',   '2+StrB', 1, 250,  'SCARCE', 'Loud, Inflict (Stunned)'),
                               ('Power Axe',     'TWO-HANDED', 'POWER',   '6+StrB', 2, 3400, 'RARE',   'Heavy (4), Penetrating (6), Two-handed'),
                               ('Power Fist',    'BRAWLING',   'POWER',   '6+StrB', 2, 4000, 'RARE',   'Heavy (4), Penetrating (6)'),
                               ('Power Knife',   'ONE-HANDED', 'POWER',   '2+StrB', 1, 2000, 'RARE',   'Penetrating (2), Subtle, Thrown (Short)'),
                               ('Power Maul',    'ONE-HANDED', 'POWER',   '5+StrB', 1, 3000, 'RARE',   'Penetrating (2)'),
                               ('Power Sword',   'ONE-HANDED', 'POWER',   '4+StrB', 1, 3000, 'RARE',   'Penetrating (4)')
                          ) AS t(_name, _spec, _subcat, _damage, _weight, _cost, _avail, _special)
            LOOP
                -- найти специализацию
                SELECT id INTO spec_id FROM specialization WHERE name = rec._spec LIMIT 1;

                -- найти или создать inventory
                SELECT id INTO inv_id FROM inventory WHERE name = rec._name LIMIT 1;

                IF inv_id IS NULL THEN
                    INSERT INTO inventory (name, inventory_category, inventory_subcategory, availability, encumbrance, cost)
                    VALUES (rec._name, 'MELEE_WEAPON', rec._subcat, rec._avail, rec._weight, rec._cost)
                    RETURNING id INTO inv_id;
                ELSE
                    UPDATE inventory
                    SET inventory_category = 'MELEE_WEAPON',
                        inventory_subcategory = rec._subcat,
                        availability = rec._avail,
                        encumbrance = rec._weight,
                        cost = rec._cost
                    WHERE id = inv_id;
                END IF;

                -- убрать из generic_item если был
                DELETE FROM generic_item WHERE id = inv_id;

                -- вставить или обновить melee_weapon
                INSERT INTO melee_weapon (id, specialization_id, damage, special)
                VALUES (inv_id, spec_id, rec._damage, rec._special)
                ON CONFLICT (id) DO UPDATE SET
                                               specialization_id = EXCLUDED.specialization_id,
                                               damage = EXCLUDED.damage,
                                               special = EXCLUDED.special;
            END LOOP;
    END $$;