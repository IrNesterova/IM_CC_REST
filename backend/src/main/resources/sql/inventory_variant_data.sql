-- =====================================================================
-- INVENTORY VARIANTS
-- Items that offer a choice of ability/function at character creation
-- =====================================================================


INSERT INTO inventory_variant (inventory_id, name, description)
SELECT i.id, v.name, v.description
FROM inventory i
CROSS JOIN (VALUES
    ('Illuminator', 'The Skull has electric candles, burning torches, or other light sources mounted to its form and acts as a glow globe or stablight.'),
    ('Laud Hailer',  'The Servo-Skull has a laud hailer which can amplify pre-recorded sounds or the voice of anyone at Immediate range.'),
    ('Medicae',      'The Skull is fitted with devices to aid in medical efforts, and grants +10 to Medicae Tests made within Immediate range.'),
    ('Scanner',      'This Servo-Skull is fitted with an auspex and allows a character at Short range to gain the benefits of that device.'),
    ('Utility',      'The Servo-Skull has a mix of tools to aid in mechanical tasks, which acts as a Combi-Tool for a character at Immediate range.')
) AS v(name, description)
WHERE i.name = 'Monotask Servo-Skull'
  AND NOT EXISTS (
      SELECT 1 FROM inventory_variant iv
      WHERE iv.inventory_id = i.id AND iv.name = v.name
  );