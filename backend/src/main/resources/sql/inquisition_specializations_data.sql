-- =====================================================================
-- INQUISITION — SKILL SPECIALISATIONS
-- Source: Inquisition Supplement
-- Run AFTER specializations_data.sql (skills must already exist).
-- =====================================================================

-- =====================================================================
-- 1. SPECIALIZATIONS
-- =====================================================================
INSERT INTO specialization (name, description)
SELECT name, description FROM (VALUES

    -- Lore (Int)
    ('MAJOR ORDOS (VARIOUS, RESTRICTED)',
     'When choosing this Specialisation, select either the Ordo Hereticus, Malleus, or Xenos. You gain knowledge of the Ordo, including famous Inquisitors, the Ordos methods, iconic wargear, and typical foes. This Specialisation allows a character to requisition, commission, or craft wargear unique to the Ordo.'),

    -- Rapport (Fel)
    ('XENO-CANT',
     'An assortment of etiquette, specific body language clues, and general knowledge of approaching and dealing with various xenos species, particularly ones that often make contact with Humanity. This Specialisation helps begin the process of conversation and interaction with xenos, guiding a character in how to approach on neutral terms.'),

    -- Stealth/Dexterity (Ag)
    ('DISGUISE',
     'Training in disguise, not merely in terms of clothes and accessories, but also in mannerisms, body language, and verbal cues. Avoiding discovery or suspicion is typically easier than attempting to mimic or assume the identity of another individual. Disguise is typically opposed by Intuition.'),

    -- Medicae (Int)
    ('CHEM-USE',
     'Knowledge and expertise in chemistry, identifying chemical samples and the signs of poisons or toxins in a creature or corpse. Including an understanding of how to better craft chemical stimulants, poisons, and toxins.')

) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM specialization s WHERE s.name = v.name);


-- =====================================================================
-- 2. SKILL — SPECIALIZATION LINKS (skill_specializations)
-- =====================================================================
INSERT INTO skill_specializations (skill_id, specialization_id)
SELECT s.id, sp.id
FROM (VALUES
    ('LORE',       'MAJOR ORDOS (VARIOUS, RESTRICTED)'),
    ('RAPPORT',    'XENO-CANT'),
    ('STEALTH',    'DISGUISE'),
    ('DEXTERITY',  'DISGUISE'),
    ('MEDICAE',    'CHEM-USE')
) AS v(skill_name, spec_name)
JOIN skill s           ON s.name  = v.skill_name
JOIN specialization sp ON sp.name = v.spec_name
WHERE NOT EXISTS (
    SELECT 1 FROM skill_specializations ss
    WHERE ss.skill_id = s.id AND ss.specialization_id = sp.id
);