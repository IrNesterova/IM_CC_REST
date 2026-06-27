-- =====================================================================
-- INQUISITION TALENTS (source_book = IN)
-- =====================================================================

-- =====================================================================
-- 1. INSERT TALENTS
-- =====================================================================
INSERT INTO talent (name, description, source_book)
SELECT name, description, 'IN' FROM (VALUES
    ('AMALATHIAN APPRENTICE',
     'Requirement: 2 Advances in Rapport. Following the Amalathian philosophy of the Inquisition, you believe that the Imperium is strongest when all its elements work together. At the end of any positive interaction with the representative of another Imperial Faction, you can spend a Fate point to make a Rapport Test (Difficulty determined by the GM). On a success, that representative becomes a Contact.'),
    ('APOSTLE OF THE LEX',
     'Through extensive study and memorisation, you know the Lex Imperialis, the labyrinthine codes of law upon which the Imperium runs.'),
    ('CULT INFILTRATOR',
     'Requirement: 2 Advances in both Discipline and Rapport. Through a combination of hypno-indoctrination and specialised training, you are prepared to infiltrate various cults and organisations at the behest of the Inquisition. Each time you take this Talent, you also gain 2 Corruption Points.'),
    ('MANY MASKS',
     'Requirement: 2 Advances in Stealth, at least one in Stealth (Disguise). You are trained in adopting disguises and creating personas. You have Advantage on any Test to apply a Disguise Kit and adopt a new identity or persona.'),
    ('HYPNO-INDOCTRINATION',
     'Someone spent a great deal of time and effort hypnotically imparting you with specific training you could not consciously recall as it dwelt in your subconscious. Now it has revealed itself to you. Roll twice on the Random Talents Table. You now have those Talents. Can only be taken once.')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);


-- =====================================================================
-- 2. SET max_advances
-- =====================================================================
UPDATE talent SET max_advances = 4 WHERE name = 'AMALATHIAN APPRENTICE';
UPDATE talent SET max_advances = 3 WHERE name = 'APOSTLE OF THE LEX';
UPDATE talent SET max_advances = 4 WHERE name = 'CULT INFILTRATOR';
UPDATE talent SET max_advances = 3 WHERE name = 'MANY MASKS';


-- =====================================================================
-- 3. FIXED ADVANCES (choice = false)
-- Talents that give a base effect on the first purchase.
-- =====================================================================
INSERT INTO talent_advancement (talent_id, advance_number, name, effect, choice)
SELECT t.id, v.advance_number, NULL, v.effect, false
FROM (VALUES
    ('AMALATHIAN APPRENTICE', 1,
     'At the end of any positive interaction with the representative of another Imperial Faction, you can spend a Fate point to make a Rapport Test. On a success, that representative becomes a Contact.'),
    ('MANY MASKS', 1,
     'You have Advantage on any Test to apply a Disguise Kit and adopt a new identity or persona.')
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
    -- AMALATHIAN APPRENTICE
    ('AMALATHIAN APPRENTICE', 'Coercive Favour',
     'When you seek to use Inquisitorial Requisitions, you gain +1 SL on a Rapport Test made to find who can aid you, and +1 SL on a Rapport Test when requisitioning the aid.'),
    ('AMALATHIAN APPRENTICE', 'Cooperative Spirit',
     'Once per mission, when you would lose Influence with a faithful Faction of the Imperium, you can attempt a Rapport Test to smooth over issues and prevent that loss. On a success, the amount of Influence lost is reduced by 1 (minimum loss of 1).'),
    ('AMALATHIAN APPRENTICE', 'Suppression Orders',
     'You gain +1 SL on any Tests made to enlist the aid of, or convince, local authorities to suppress information, block communications, and shut down any investigations that might implicate or reveal the identities of you and your fellow acolytes.'),
    -- APOSTLE OF THE LEX
    ('APOSTLE OF THE LEX', 'Imperial Law',
     'You have +2 SL on Lore Tests to recall law and law processes.'),
    ('APOSTLE OF THE LEX', 'Judgement',
     'You have +2 SL on Presence (Interrogation) or Presence (Intimidation) Tests to interrogate or intimidate an individual who might fear the consequences of Imperial Law.'),
    ('APOSTLE OF THE LEX', 'Enforcer',
     'You gain +2 SL on Rapport Tests to work with, or gain the help of, enforcers, Vigilites, or Adeptus Arbites.'),
    -- CULT INFILTRATOR
    ('CULT INFILTRATOR', 'Heretek',
     'You have adopted a disguise including a prosthetic augmetic that passes as genuine until inspected up close by a member of the Cult Mechanicus. You have meme-coded technical secrets into your mind, granting you +2 SL on Tech Tests.'),
    ('CULT INFILTRATOR', 'Aristocrat',
     'Psycho-linguistic and memetic routines have trained you to recall names and interconnected details useful for interacting with nobility and the upper echelons of Imperial society. You have +2 SL on Rapport Tests when interacting with characters you are knowledgeable about.'),
    ('CULT INFILTRATOR', 'Tolerant',
     'Surgical alteration and biological conditioning have given you a surprising tolerance for toxins and intoxicants. You have Advantage on Tests to resist intoxication, drugs, poisons, and contact with filth or pestilence that conveys disease.'),
    ('CULT INFILTRATOR', 'Tainted',
     'Prosthetics and temporary surgery allow you to disguise yourself with the tainted marks of Chaos. You can adopt a disguise appropriately marked by Chaos to infiltrate the ranks of a cult dedicated to the Ruinous Powers.'),
    -- MANY MASKS
    ('MANY MASKS', 'Fall Guy',
     'You can choose to ''burn'' a disguise or identity, sacrificing their persona by implicating them to reduce the loss of Subtlety by 1 Rating. This does not immediately end suspicion, as the former identity is implicated.'),
    ('MANY MASKS', 'Unmasked',
     'As a Reaction before combat begins, you can dramatically unmask or reveal yourself as an agent of the Inquisition, to gain Surprise.')
) AS v(talent_name, opt_name, effect)
JOIN talent t ON t.name = v.talent_name
WHERE NOT EXISTS (
    SELECT 1 FROM talent_advancement ta
    WHERE ta.talent_id = t.id AND ta.name = v.opt_name AND ta.choice = true
);