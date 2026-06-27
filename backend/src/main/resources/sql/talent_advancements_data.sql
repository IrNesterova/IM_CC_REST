-- =====================================================================
-- TALENT ADVANCEMENTS
-- Rows with choice=false: fixed sequential effects (advance_number required).
-- Rows with choice=true:  selectable options shown as a picker (advance_number null).
-- Run AFTER talents are seeded (roles_data.sql, inquisition_roles_data.sql).
-- =====================================================================

-- =====================================================================
-- 1. INSERT NEW TALENTS (not in core IM seed)
-- =====================================================================
INSERT INTO talent (name, description)
SELECT name, description FROM (VALUES
    ('ARTISTIC',
     'You have a natural talent for the arts. This Talent can be taken multiple times, each time choosing one of the following disciplines.'),
    ('VOID LEGS',
     'You are an experienced Void Traveller and are all but immune to any void-sickness due to the shifting of a vessel. You do not suffer Disadvantage due to environmental effects specific to the void, such as a ship rocking or zero gravity. This Talent can be taken multiple times.')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);


-- =====================================================================
-- 2. SET max_advances
-- =====================================================================
UPDATE talent SET max_advances = 4 WHERE name = 'ARTISTIC';
UPDATE talent SET max_advances = 2 WHERE name = 'DISTRACTING';
UPDATE talent SET max_advances = 2 WHERE name = 'DRILLED';
UPDATE talent SET max_advances = 3 WHERE name = 'DUELLIST';
UPDATE talent SET max_advances = 9 WHERE name = 'FAMILIAR TERRAIN';
UPDATE talent SET max_advances = 4 WHERE name = 'FRENZY';
UPDATE talent SET max_advances = 3 WHERE name = 'TWO-HANDED CLEAVE';
UPDATE talent SET max_advances = 3 WHERE name = 'VOID LEGS';


-- =====================================================================
-- 3. FIXED ADVANCES (choice = false)
-- =====================================================================
INSERT INTO talent_advancement (talent_id, advance_number, name, effect, choice)
SELECT t.id, v.advance_number, NULL, v.effect, false
FROM (VALUES
    -- DRILLED
    ('DRILLED', 1, 'You have Advantage on Tests to resist the Frightened Condition, and you gain +1 SL to Discipline Tests for every ally with the Drilled Talent in the same Zone as you.'),
    -- DISTRACTING
    ('DISTRACTING', 1, 'Once per encounter, interrupt another individual making a Test and impose Disadvantage on that Test. In combat, this Talent is used as a Reaction.'),
    -- DUELLIST
    ('DUELLIST', 1, 'You treat all One-handed melee weapons that do not have the Subtle Trait as having the Defensive Trait.'),
    -- FRENZY
    ('FRENZY', 1, 'As a Free Action, make a Challenging (+0) Willpower Test to enter a frenzied state. While frenzied your Strength Bonus increases by +1 and you are immune to the Frightened Condition. On your turn you must engage the nearest enemy in melee. You remain frenzied until all visible enemies are defeated or until you are Stunned or Unconscious.'),
    -- TWO-HANDED CLEAVE
    ('TWO-HANDED CLEAVE', 1, 'When you wield a melee weapon with the Two-handed Trait, it also gains the Spread Trait. Attacks you make with such a weapon do not strike you.'),
    -- VOID LEGS
    ('VOID LEGS', 1, 'You do not suffer Disadvantage due to environmental effects specific to the void, such as a ship rocking or zero gravity.')
) AS v(talent_name, advance_number, effect)
JOIN talent t ON t.name = v.talent_name
WHERE NOT EXISTS (
    SELECT 1 FROM talent_advancement ta
    WHERE ta.talent_id = t.id AND ta.advance_number = v.advance_number AND ta.choice = false
);


-- =====================================================================
-- 4. CHOICE OPTIONS (choice = true, advance_number = null)
-- =====================================================================
INSERT INTO talent_advancement (talent_id, advance_number, name, effect, choice)
SELECT t.id, NULL, v.opt_name, v.effect, true
FROM (VALUES
    -- DRILLED
    ('DRILLED', 'Kill Team',
     'When you are in the same Zone as another member of your party with the Drilled Talent, you can choose to act immediately after them in Initiative and gain +1 SL to all Tests.'),
    -- ARTISTIC
    ('ARTISTIC', 'Literature',
     '+2 SL to any Test related to reading or writing, such as cataloguing a persuasive evidential case or recognising which Imperial sagas are being referenced in an ingeniously coded message.'),
    ('ARTISTIC', 'Painting',
     '+2 SL to any Test related to painting or drawing, such as creating a sketch of a person of interest or identifying the artist of an Imperial fresco and that it is a forgery.'),
    ('ARTISTIC', 'Music',
     '+2 SL to any Test related to singing or performing music, such as leading a religious chorus or surmising which planet in a particular sub-sector someone is from based on the tunes they hum.'),
    ('ARTISTIC', 'Theatre',
     '+2 SL to any Test related to acting or performing, such as dramatically depicting a character or identifying whether someone is wearing a uniform that was not made for them.'),
    -- DISTRACTING
    ('DISTRACTING', 'Centre of Attention',
     'When you are within Immediate Range of an individual that isn''t your ally, you may choose to inflict Disadvantage on Tests that target makes with anyone other than you.'),
    ('DISTRACTING', 'Stunning Interjection',
     'Once per encounter when you use the Distraction Talent, your target is Stunned (Minor) until the end of their next Turn.'),
    -- DUELLIST
    ('DUELLIST', 'Duellist Feint',
     'When you successfully attack with a One-handed melee weapon, you can choose to deal no damage and instead impose Disadvantage on attacks the target makes against you until the end of your next Turn.'),
    ('DUELLIST', 'Duellist Guard',
     'When you make an attack with a One-handed melee weapon, you can choose to make that attack with Disadvantage to simultaneously make the Dodge Action.'),
    -- FAMILIAR TERRAIN
    ('FAMILIAR TERRAIN', 'Agri',
     'Farmed fields, slaughterhouses, and other locations dedicated to food or water production.'),
    ('FAMILIAR TERRAIN', 'Feudal',
     'Any Human civilisation that is not a hive city, on a Forge world, or on a Shrine World.'),
    ('FAMILIAR TERRAIN', 'Forge',
     'Manufactorums, Omnissian forge-shrines, and the streets of Forge Worlds.'),
    ('FAMILIAR TERRAIN', 'Hive',
     'Anywhere in a hive city, including the toxic sumps that often lie beneath.'),
    ('FAMILIAR TERRAIN', 'Natural',
     'Forests, mountains, grasslands, plains, and other natural biomes untouched by civilisation.'),
    ('FAMILIAR TERRAIN', 'Shrine',
     'Churches, cathedrals, tombs, and the streets of Shrine Worlds.'),
    ('FAMILIAR TERRAIN', 'War Zone',
     'Any location that is or was recently an active war zone, as well as military buildings and active encampments.'),
    ('FAMILIAR TERRAIN', 'Wasteland',
     'The irradiated wastelands beyond hive cities, tundras, deserts.'),
    ('FAMILIAR TERRAIN', 'Voidship',
     'Any void-faring vessel of Imperial design.'),
    -- FRENZY
    ('FRENZY', 'Frenzied Control',
     'You can make a Difficult (−10) Discipline (Composure) Test as an Action, to halt your Frenzied state.'),
    ('FRENZY', 'Frenzied Fearlessness',
     'Whenever you would become Frightened, you may immediately become Frenzied instead.'),
    ('FRENZY', 'Frenzied Momentum',
     'Once per Turn, when you kill an enemy whilst Frenzied, you may immediately Move or take another Action.'),
    -- TWO-HANDED CLEAVE
    ('TWO-HANDED CLEAVE', 'Two-handed Brutalist',
     'When you wield a weapon with the Two-handed Trait, it also gains the Rend (+1) Trait.'),
    ('TWO-HANDED CLEAVE', 'Two-handed Sweep',
     'When you wield a Two-handed weapon and hit a target in the leg you can choose to halve the Damage dealt to force the target to make a Hard (−20) Reflexes (Balance) Test or fall Prone.'),
    -- VOID LEGS
    ('VOID LEGS', 'Attitude Control',
     'You have mastered movement in the void, capable of quickly pushing yourself from surface to surface. You are Fast when moving in zero-gravity environments.'),
    ('VOID LEGS', 'Void Brawler',
     'You have experience fighting in the void. You have Advantage when making Melee Attacks in zero-gravity environments against characters who do not have the Void Legs Talent.')
) AS v(talent_name, opt_name, effect)
JOIN talent t ON t.name = v.talent_name
WHERE NOT EXISTS (
    SELECT 1 FROM talent_advancement ta
    WHERE ta.talent_id = t.id AND ta.name = v.opt_name AND ta.choice = true
);


-- =====================================================================
-- 5. CLEANUP: remove old-style "Choose one of:" rows if they exist
-- =====================================================================
DELETE FROM talent_advancement
WHERE choice = false
  AND effect LIKE 'Choose one%'
  AND talent_id IN (SELECT id FROM talent WHERE name IN (
      'ARTISTIC','DISTRACTING','DUELLIST','FAMILIAR TERRAIN',
      'FRENZY','TWO-HANDED CLEAVE','VOID LEGS'
  ));

DELETE FROM talent_advancement
WHERE choice = false AND advance_number = 2
  AND talent_id = (SELECT id FROM talent WHERE name = 'DRILLED');