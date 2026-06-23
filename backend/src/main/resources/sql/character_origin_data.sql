-- Characteristics IDs: 1=WS, 2=BS, 3=STR, 4=TGH, 5=AG, 6=INT, 7=PER, 8=WIL, 9=FEL
-- Origin IDs: 1=Agri World, 2=Feudal World, 3=Feral World, 4=Forge World,
--             5=Hive World, 6=Shrine World, 7=Schola Progenium, 8=Voidborn

INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT v.origin_id, v.character_id, v.primary_char
FROM (VALUES
    -- Agri World: primary STR, secondary TGH/AG/WIL
    (1, 3, true),
    (1, 4, false),
    (1, 5, false),
    (1, 8, false),
    -- Feudal World: primary WS, secondary STR/WIL/FEL
    (2, 1, true),
    (2, 3, false),
    (2, 8, false),
    (2, 9, false),
    -- Feral World: primary TGH, secondary WS/STR/PER
    (3, 4, true),
    (3, 1, false),
    (3, 3, false),
    (3, 7, false),
    -- Forge World: primary INT, secondary BS/TGH/AG
    (4, 6, true),
    (4, 2, false),
    (4, 4, false),
    (4, 5, false),
    -- Hive World: primary AG, secondary BS/PER/FEL
    (5, 5, true),
    (5, 2, false),
    (5, 7, false),
    (5, 9, false),
    -- Shrine World: primary WIL, secondary INT/PER/FEL
    (6, 8, true),
    (6, 6, false),
    (6, 7, false),
    (6, 9, false),
    -- Schola Progenium: primary FEL, secondary WS/BS/TGH
    (7, 9, true),
    (7, 1, false),
    (7, 2, false),
    (7, 4, false),
    -- Voidborn: primary PER, secondary AG/INT/WIL
    (8, 7, true),
    (8, 5, false),
    (8, 6, false),
    (8, 8, false)
) AS v(origin_id, character_id, primary_char)
WHERE NOT EXISTS (
    SELECT 1 FROM character_origin co
    WHERE co.origin_id = v.origin_id AND co.character_id = v.character_id
);
