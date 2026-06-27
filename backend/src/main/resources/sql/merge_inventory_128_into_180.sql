-- =====================================================================
-- Merges inventory id=128 into id=180
-- All FK references to 128 are re-pointed to 180, then 128 is deleted
-- =====================================================================

BEGIN;

INSERT INTO role_inventory (role_id, inventory_id)
SELECT role_id, 180 FROM role_inventory WHERE inventory_id = 128
ON CONFLICT DO NOTHING;
DELETE FROM role_inventory WHERE inventory_id = 128;

INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
SELECT role_choice_group_id, 180 FROM role_inventory_choice_group WHERE inventory_id = 128
ON CONFLICT DO NOTHING;
DELETE FROM role_inventory_choice_group WHERE inventory_id = 128;

UPDATE faction_inventory SET inventory_id = 180 WHERE inventory_id = 128;

UPDATE faction_inventory_choice SET inventory_id = 180 WHERE inventory_id = 128;

UPDATE origin_inventory_item SET inventory_id = 180 WHERE inventory_id = 128;

UPDATE equipment_pack_item SET inventory_id = 180 WHERE inventory_id = 128;

UPDATE faction_grade_inventory SET inventory_id = 180 WHERE inventory_id = 128;

UPDATE faction_grade_inventory_choice SET inventory_id = 180 WHERE inventory_id = 128;

DELETE FROM generic_item            WHERE id = 128;
DELETE FROM melee_weapon            WHERE id = 128;
DELETE FROM ranged_weapon           WHERE id = 128;
DELETE FROM armour                  WHERE id = 128;
DELETE FROM armour_locations        WHERE armour_id = 128;
DELETE FROM force_field             WHERE id = 128;
DELETE FROM grenades_and_explosives WHERE id = 128;
DELETE FROM book                    WHERE id = 128;
DELETE FROM augmetic                WHERE id = 128;

DELETE FROM inventory WHERE id = 128;

COMMIT;