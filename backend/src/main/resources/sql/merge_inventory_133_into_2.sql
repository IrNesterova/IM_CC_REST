-- =====================================================================
-- Merges inventory id=133 into id=2
-- All FK references to 133 are re-pointed to 2, then 133 is deleted
-- =====================================================================

BEGIN;

-- Junction tables: copy rows pointing to 133 → 2 (skip if 2 already exists),
-- then delete the 133 rows

INSERT INTO role_inventory (role_id, inventory_id)
SELECT role_id, 2 FROM role_inventory WHERE inventory_id = 133
ON CONFLICT DO NOTHING;
DELETE FROM role_inventory WHERE inventory_id = 133;

INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
SELECT role_choice_group_id, 2 FROM role_inventory_choice_group WHERE inventory_id = 133
ON CONFLICT DO NOTHING;
DELETE FROM role_inventory_choice_group WHERE inventory_id = 133;

UPDATE faction_inventory SET inventory_id = 2 WHERE inventory_id = 133;

UPDATE faction_inventory_choice SET inventory_id = 2 WHERE inventory_id = 133;

UPDATE origin_inventory_item SET inventory_id = 2 WHERE inventory_id = 133;

UPDATE equipment_pack_item SET inventory_id = 2 WHERE inventory_id = 133;

UPDATE faction_grade_inventory SET inventory_id = 2 WHERE inventory_id = 133;

UPDATE faction_grade_inventory_choice SET inventory_id = 2 WHERE inventory_id = 133;

-- Subtype tables (only one should match — all others are no-ops)
DELETE FROM generic_item            WHERE id = 133;
DELETE FROM melee_weapon            WHERE id = 133;
DELETE FROM ranged_weapon           WHERE id = 133;
DELETE FROM armour                  WHERE id = 133;
DELETE FROM armour_locations        WHERE armour_id = 133;
DELETE FROM force_field             WHERE id = 133;
DELETE FROM grenades_and_explosives WHERE id = 133;
DELETE FROM book                    WHERE id = 133;
DELETE FROM augmetic                WHERE id = 133;

-- Finally remove the duplicate inventory row
DELETE FROM inventory WHERE id = 133;

COMMIT;