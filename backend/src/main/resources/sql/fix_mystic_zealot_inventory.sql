-- =====================================================================
-- Add Micro-Bead/Vox Bead to MYSTIC and ZEALOT fixed inventory
-- Add Robes/Light Leathers option to ZEALOT's armour choice group
-- =====================================================================

INSERT INTO role_inventory (role_id, inventory_id)
SELECT r.id, i.id FROM role r, inventory i
WHERE r.name IN ('MYSTIC', 'ZEALOT', 'SAVANT', 'PENUMBRA', 'WARRIOR')
  AND i.name = 'Micro-Bead/Vox Bead'
  AND NOT EXISTS (
      SELECT 1 FROM role_inventory ri WHERE ri.role_id = r.id AND ri.inventory_id = i.id
  );

-- Add Robes/Light Leathers to the ZEALOT INVENTORY choice group that contains Heavy Leathers
DO $$
DECLARE v_grp BIGINT;
BEGIN
    SELECT cg.id INTO v_grp
    FROM role_choice_group cg
    JOIN role r ON cg.role_id = r.id
    JOIN role_inventory_choice_group icg ON icg.role_choice_group_id = cg.id
    JOIN inventory i ON i.id = icg.inventory_id
    WHERE r.name = 'ZEALOT'
      AND cg.choice_type = 'INVENTORY'
      AND i.name ILIKE '%Heavy Leather%'
    LIMIT 1;

    IF v_grp IS NULL THEN
        RAISE NOTICE 'ZEALOT INVENTORY choice group with Heavy Leathers not found';
        RETURN;
    END IF;

    INSERT INTO role_inventory_choice_group (role_choice_group_id, inventory_id)
    SELECT v_grp, i.id FROM inventory i
    WHERE i.name ILIKE '%Robe%' OR i.name ILIKE '%Light Leathers%'
      AND NOT EXISTS (
          SELECT 1 FROM role_inventory_choice_group x
          WHERE x.role_choice_group_id = v_grp AND x.inventory_id = i.id
      );
END $$;