-- Subtle Mutations Table (Inquisition Supplement)
-- Maps d100 ranges to positive/negative mutations for the MUTANT origin's Subtle Mutation talent.
-- Run AFTER mutations_data.sql has been seeded.
INSERT INTO subtle_mutation_table (d100_min, d100_max, positive_mutation_id, negative_mutation_id)
SELECT e.d100_min, e.d100_max, pos.id, neg.id
FROM (VALUES
    (1,   10,  'Dark Prophecies',       'Ashen Taste'),
    (11,  20,  'Fleshmetal',            'Awful Cravings'),
    (21,  30,  'Inhuman Beauty',        'Blackouts'),
    (31,  40,  'Iron Skin',             'Inescapable Itch'),
    (41,  50,  'Photonic Irregularity', 'Irrational Nausea'),
    (51,  60,  'Psychic Awakening',     'Lolling Tongue'),
    (61,  70,  'Swollen Brute',         'Morbid Fascination'),
    (71,  80,  'Warp Regeneration',     'Searing Blood'),
    (81,  90,  'Warp Sense',            'Unshakable Paranoia'),
    (91,  100, 'Wheels Within Wheels',  'Wasted Frame')
) AS e(d100_min, d100_max, pos_name, neg_name)
JOIN mutation pos ON pos.name = e.pos_name
JOIN mutation neg ON neg.name = e.neg_name
WHERE NOT EXISTS (
    SELECT 1 FROM subtle_mutation_table WHERE d100_min = e.d100_min
);