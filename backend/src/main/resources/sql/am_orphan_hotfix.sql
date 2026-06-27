-- =====================================================================
-- HOTFIX: inventory rows inserted by am_roles_data.sql had no subtype
-- entry, causing Hibernate NPE on EntityPersister lookup.
--
-- Run order:
--   1. THIS FILE (am_orphan_hotfix.sql)
--   2. am_roles_fix.sql   — removes old Omnissian Axe, adds choice group
--   3. am_weapons.sql     — properly seeds Arc Pistol, Stubcarbine, etc.
-- =====================================================================

-- Arc Pistol and Stubcarbine: park in generic_item temporarily.
-- am_weapons.sql will DELETE from generic_item and INSERT into ranged_weapon.
INSERT INTO generic_item (id, description)
SELECT i.id, NULL FROM inventory i
WHERE i.name IN ('Stubcarbine')
  AND NOT EXISTS (SELECT 1 FROM generic_item    g WHERE g.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM ranged_weapon   r WHERE r.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM melee_weapon    m WHERE m.id = i.id);

-- Omnissian Axe (old generic): park in generic_item.
-- am_roles_fix.sql will delete it from role_inventory + inventory entirely.
INSERT INTO generic_item (id, description)
SELECT i.id, NULL FROM inventory i
WHERE i.name = 'Omnissian Axe'
  AND NOT EXISTS (SELECT 1 FROM generic_item g WHERE g.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM melee_weapon m WHERE m.id = i.id);

-- Tech-Adept Flak Armour: insert as proper armour (same stats as
-- Astra Militarum Flak Armour — AP 4, locations HEAD/ARMS/BODY/LEGS).
DO $$
DECLARE v_id BIGINT; loc TEXT;
BEGIN
    SELECT id INTO v_id FROM inventory WHERE name = 'Tech-Adept Flak Armour';
    IF v_id IS NULL THEN RETURN; END IF;

    -- remove from generic_item if it ended up there
    DELETE FROM generic_item WHERE id = v_id;

    INSERT INTO armour (id, armor_points, weight_worn, special)
    VALUES (v_id, 4, 4, 'Loud')
    ON CONFLICT (id) DO UPDATE SET armor_points = 4, weight_worn = 4, special = 'Loud';

    DELETE FROM armour_locations WHERE armour_id = v_id;
    FOREACH loc IN ARRAY ARRAY['HEAD','ARMS','BODY','LEGS'] LOOP
        INSERT INTO armour_locations (armour_id, location) VALUES (v_id, loc);
    END LOOP;
END $$;