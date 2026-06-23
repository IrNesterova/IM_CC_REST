-- Characteristics IDs: 1=WS, 2=BS, 3=STR, 4=TGH, 5=AG, 6=INT, 7=PER, 8=WIL, 9=FEL
-- Faction IDs: 1=Adeptus Administratum, 2=Adeptus Astra Telepathica, 3=Adeptus Mechanicus,
--              4=Adeptus Ministorum, 5=Astra Militarum, 6=Imperial Fleet, 7=Infractionist,
--              8=The Inquisition, 9=Rogue Trader Dynasty
-- Source: Imperium Maledictum core rulebook, Creating Your Character III (pages 54-73)

INSERT INTO characteristics_faction (faction_id, characteristics_id, primary_char)
SELECT v.faction_id, v.characteristics_id, v.primary_char
FROM (VALUES
    -- Adeptus Administratum: primary INT, secondary PER/WIL/FEL
    (1, 6, true),
    (1, 7, false),
    (1, 8, false),
    (1, 9, false),
    -- Adeptus Astra Telepathica: primary WIL, secondary INT/PER/TGH
    (2, 8, true),
    (2, 6, false),
    (2, 7, false),
    (2, 4, false),
    -- Adeptus Mechanicus: primary INT, secondary TGH/AG/PER
    (3, 6, true),
    (3, 4, false),
    (3, 5, false),
    (3, 7, false),
    -- Adeptus Ministorum: primary WIL, secondary INT/PER/FEL
    (4, 8, true),
    (4, 6, false),
    (4, 7, false),
    (4, 9, false),
    -- Astra Militarum: primary TGH, secondary WS/BS/STR
    (5, 4, true),
    (5, 1, false),
    (5, 2, false),
    (5, 3, false),
    -- Imperial Fleet: primary AG, secondary STR/TGH/PER
    (6, 5, true),
    (6, 3, false),
    (6, 4, false),
    (6, 7, false),
    -- Infractionist: primary AG, secondary TGH/PER/FEL
    (7, 5, true),
    (7, 4, false),
    (7, 7, false),
    (7, 9, false),
    -- The Inquisition: primary PER, secondary TGH/INT/WIL
    (8, 7, true),
    (8, 4, false),
    (8, 6, false),
    (8, 8, false),
    -- Rogue Trader Dynasty: primary FEL, secondary AG/INT/PER
    (9, 9, true),
    (9, 5, false),
    (9, 6, false),
    (9, 7, false)
) AS v(faction_id, characteristics_id, primary_char)
WHERE NOT EXISTS (
    SELECT 1 FROM characteristics_faction cf
    WHERE cf.faction_id = v.faction_id AND cf.characteristics_id = v.characteristics_id
);