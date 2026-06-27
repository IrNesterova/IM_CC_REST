-- =====================================================================
-- ONE-TIME FIX: run if am_roles_data.sql was already applied before
-- the Omnissian Axe split (One-Handed / Two-Handed).
-- Run BEFORE am_weapons.sql.
-- =====================================================================

-- 1. Remove old generic 'Omnissian Axe' from ENGINESEER fixed inventory
DELETE FROM role_inventory
WHERE role_id    = (SELECT id FROM role      WHERE name = 'ENGINESEER')
  AND inventory_id = (SELECT id FROM inventory WHERE name = 'Omnissian Axe');

-- 2. Remove the old generic inventory entry entirely (am_weapons.sql
--    will create the proper One-Handed / Two-Handed variants)
DELETE FROM generic_item WHERE id = (SELECT id FROM inventory WHERE name = 'Omnissian Axe');
DELETE FROM inventory    WHERE name = 'Omnissian Axe';

-- 3. Add the Omnissian Axe choice group that the old DO $$ block skipped.
--    Run AFTER am_weapons.sql has seeded the two Omnissian Axe items.
DO $$
DECLARE v_role_id BIGINT; v_grp BIGINT;
BEGIN
    SELECT id INTO v_role_id FROM role WHERE name = 'ENGINESEER';

    -- Guard: skip if already added
    IF EXISTS (
        SELECT 1
        FROM   role_choice_group rcg
        JOIN   role_inventory_choice_group ricg ON ricg.role_choice_group_id = rcg.id
        JOIN   inventory i ON i.id = ricg.inventory_id
        WHERE  rcg.role_id     = v_role_id
          AND  rcg.choice_type = 'INVENTORY'
          AND  i.name          = 'Omnissian Axe (One-Handed)'
    ) THEN RETURN; END IF;

    INSERT INTO role_choice_group (role_id, choices_required, choice_type)
    VALUES (v_role_id, 1, 'INVENTORY') RETURNING id INTO v_grp;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name IN ('Omnissian Axe (One-Handed)', 'Omnissian Axe (Two-Handed)');
END $$;