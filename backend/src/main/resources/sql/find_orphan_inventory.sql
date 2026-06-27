-- Finds inventory rows that have no entry in any subtype table.
-- These cause Hibernate NPE with JOINED inheritance.
SELECT i.id, i.name, i.inventory_category, i.inventory_subcategory
FROM inventory i
WHERE NOT EXISTS (SELECT 1 FROM melee_weapon          t WHERE t.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM ranged_weapon         t WHERE t.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM armour                t WHERE t.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM generic_item          t WHERE t.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM force_field           t WHERE t.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM grenades_and_explosives t WHERE t.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM book t WHERE t.id = i.id)
  AND NOT EXISTS (SELECT 1 FROM augmetic t WHERE t.id = i.id)
ORDER BY i.id;