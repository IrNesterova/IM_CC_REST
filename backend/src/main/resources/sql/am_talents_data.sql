-- =====================================================================
-- ASSEMBLY OF MEANS — ADEPTUS MECHANICUS SUPPLEMENT TALENTS
-- Source: Assembly of Means supplement
-- Run AFTER: Hibernate startup (creates talent table)
-- =====================================================================

INSERT INTO talent (name, description, source_book)
SELECT name, description, 'AM' FROM (VALUES

    ('ARCHITECTURAL MIND',
     'Requirement: 2 Advances in Tech (Engineering). You have spent much of your life poring over schematics for city-sized architecture and infrastructure, from generatorum grids down to clusters of waste utilities. Within machine-heavy environments, like hive cities, manufactorums, forge fanes, and voidships, you can use your Tech (Engineering) Skill instead of Navigation (Surface or Tracking). Additionally, when searching through architectural schematics or maps of these locations, you can use your Tech (Engineering) Skill instead of any Lore or Logic Test.'),

    ('BATTLE PROTOCOLS',
     'Requirement: 2 Advances in Tech (Automata). Members of the Legio Cybernetica optimise the programming of their robotic charges, employing rituals and binharic hymns to bless the doctrina wafers through which they alter the robots'' protocols to better serve them in battle. You can spend an action to alter a friendly Construct creature''s protocols. Choose a friendly Construct within immediate range and make a Challenging (+0) Tech (Automata) Test. If successful, choose one of the following protocols, which remains active for a number of turns equal to SL. Only one protocol can be active on a target at once. Aegis Protocol: the creature gains Advantage on Tests related to taking the Defend or Overwatch action. Conqueror Protocol: the creature gains Advantage on melee attacks. Protector Protocol: the creature gains Advantage on ranged attacks.'),

    ('BURDEN OF KNOWLEDGE',
     'Requirement: 2 Advances in Tech (Forbidden). Your knowledge of the forbidden has painfully broadened your understanding of technological possibility. When you make any Tech Test, after you roll but before any results are described, you may gain 1 Corruption to add your advances in Tech (Forbidden) to the Skill you are rolling against. You can do this multiple times in the same instance, for the same cost. At the end of any mission, your Patron may confront you about anything they find, and you may face appropriate punishments for your actions against Adeptus Mechanicus doctrine.'),

    ('CARTOGRAMMETRIST',
     'Requirement: 2 Advances in Navigation (Surface). Through augmetic databanks and rote memorisation, you have become an expert at collating and interpreting geophysical data. Rarely do you set foot on a planet without a detailed record that stretches from orbiting bodies and void stations to the depths of geological strata. As an Endeavour, you can inload the geophysical data for a single world. This data grants you Advantage on the following Tests: Navigation Test regarding the world. Lore Tests regarding the world''s physical features. Piloting Tests when moving through the world''s atmosphere or across its surface. You can only ever inload the data for a single planet; whenever you spend an Endeavour inloading data for a new planet, all previous planetary data is scrubbed to clear space for new records.'),

    ('COGNIS COMMUNION',
     'Requirement: 2 Advances in Tech (Security). Your capacity to bond with the machine spirits of the tools you use and weapons you wield does not go unrewarded. When forced into the forge of battle, those devices under your care will protect you in turn. You can use your Tech Skill instead of Weapon Skill if wielding a weapon with the Secrets of Mars Trait.'),

    ('EMOTIONLESS CLARITY',
     'Requirement: Rite of Pure Thought Augmetic. Freed from the shackles of illogical emotion, you are rendered all but immune to manipulations that would garner sympathies from less-augmented beings. When seeking to learn something in conversation with another character, you can use your Logic Skill instead of Intuition or Rapport.'),

    ('FAITHFUL (CULT OF MARS)',
     'Requirement: Member of the Adeptus Mechanicus, or +2 Adeptus Mechanicus Influence, or 2 Advances in Lore (Theology — Cult Mechanicus). You are a true believer of the Cult of Mars, unwavering in your faith in the sacred trinity of Machine God, Omnissiah, and Motive Force. Once per session, you may add your Willpower Bonus as SL when you are making a Test related to your faith — such as activating a device of sacred significance, striking down a heretek, or accessing a reliquary-datavault.'),

    ('FIELD BIOLOGIS',
     'Requirement: 2 Advances in Tech (Biologis). You have a deep understanding of the inner biological workings of constructs. You can use your Tech (Biologis) Skill to heal Construct creatures with biological components. The Difficulty of these Tests cannot be harder than Challenging (+0). If you Crit on this Test, the construct gains Advantage on any Tests it makes until the end of the scene.'),

    ('MARTIAN PISTOLEER',
     'Requirement: 2 Advances in Ranged (Pistol). You are a honed specialist at wielding pistols, able to wield them deftly at both close quarters and beyond their expected operational range. You do not suffer Disadvantage for attacking with a Pistol at Immediate Range. You increase the range of Pistols you wield by one step.'),

    ('NECROMECHANIC',
     'Requirement: 2 Advances in Tech (Augmetics). Your capabilities with the maintenance and repair of augmetics go beyond simply elevating the living — you know there are secrets to uncover in the augmetics of the dead. Provided that cranial augmetics remain intact, their inbuilt databanks can outlast the flesh decaying around them, maintaining readings or even pict-recordings of the bearer''s final moments. You can perform a necromechanical autopsy on the augmetics of the deceased or a destroyed machine. Make a Challenging (+0) Tech (Augmetics) Test. On success, you learn one piece of information about the subject''s demise. With 3 SL or more, you can access an audio, sensory, or visual recording of the subject''s demise.'),

    ('OPUS MACHINA',
     'Requirement: 2 Advances in Lore (Cult Mechanicus). You practice prayers of the Cult of Mars each dawn, enacting ancient rites of bionic reboot, self-purification, and supplication of the machine spirits that inhabit each piece of your equipment. At the start of each in-game day, roll d100 and record the result. You can use this result to replace the result of any d100 Tech Test during that day — either a Tech Test you are making, or of a creature within medium range. You can decide to replace the rolled value after the initial roll is made, but before any results are described.'),

    ('SKITARII COMPLIANCE PROTOCOLS',
     'Requirement: Transhuman Ideal Talent. You have sworn an oath in High Gothic and binharic to your Legion''s Maniple, and accepted their holy command protocols as your own. You have Advantage on all Discipline and Fortitude Tests. However, your conditioning causes you to have Disadvantage on any Test that would resist the orders of a superior Skitarii, Tech-Priest, or your Patron.'),

    ('SKIT-CODE DISCIPLINE',
     'Requirement: Transhuman Ideal Talent, 1 Advance in Discipline. You have been trained with the capacity to use skit-code, a tactical dialect of Binharic Cant. You have Advantage on Tests to resist the Frightened Condition, and you gain +1 SL to Discipline Tests for every ally with the Skit-Code Discipline Talent in the same Zone as you. Your combat communications cannot be understood by those outside the Adeptus Mechanicus. Can be taken a second time to gain the Hunter Clade benefit: when in the same Zone as another ally with this Talent, you can act immediately after them in Initiative and gain +1 SL to all Tests.'),

    ('TECHSORCIST',
     'Requirement: 1 Influence or more with the Inquisition. Your relationship with the Inquisition has steeled your mind against tech-heresy. You gain access to the Tech (Forbidden) Skill Specialisation, and can ward augmetics and machines against the influence of the Warp by creating Hexagrammic wards (typically cost 1000 solars per ward; installing requires an hour of engraving, prayer, and unguent-fumigation). While worn or affixed to an object, the first time a creature attempts to manifest a Psychic Power targeting whatever bears the ward, they have Disadvantage on their Test. The ward then burns out until restored by an hour of binharic prayer. In addition, your own augmetics are thoroughly warded — you do not risk Corruption if using mechadendrites to handle a minor source of corruption.'),

    ('THE STRENGTH AND CERTAINTY OF STEEL',
     'Requirement: Have at least 6 Augments installed. You are disgusted by the weakness of flesh and have aspired to the purity of the Blessed Machine. You have Disadvantage on Intuition (People), Presence, and Rapport Tests against non-Adeptus Mechanicus characters. However, the extent of your augmentations inspires your fellow Tech-Adepts and garners respect from your superiors. You have Advantage on Group (Adeptus Mechanicus), Intuition (People), Presence, and Rapport Tests against Adeptus Mechanicus characters or similarly technologically imbued characters.'),

    ('TRANSHUMAN IDEAL',
     'Requirement: Flesh is Weak Talent, or pick at Character Creation. You seek to transcend your weak flesh as far as possible in your pursuit to become a true scion of the Omnissiah. The number of augmetics you can take is equal to triple your Toughness Bonus.'),

    ('TRANSHUMAN RAPPORT',
     'Requirement: Intelligence 45, 2 Advances in Logic. Few among the Adeptus Mechanicus care for the subtleties of social interaction. Despite this, adepts and Tech-Priests make persuasive arguments couched in the veil of logic. When you would make a roll using Rapport against another member of the Adeptus Mechanicus, you can instead use your Logic Skill or appropriate Specialisation.'),

    ('WASTELAND STALKER',
     'Requirement: 1 Advance in Stealth. Your stealth capabilities were honed among twisting labyrinths of forge-fanes and manufactorums. With the clang of augmetic limbs against metal gantryways robbing you of silence, you instead mastered visual obscuration. You gain +2 Armour whilst benefiting from Cover.'),

    ('XENOTECHNICIAN''S BENEVOLENCE',
     'Requirement: 2 Advances in Tech (Xenos). As an Endeavour, you can spend time researching the technology of a particular xenos species. Choose a xenos species. During the preceding mission, any Corruption you receive from interacting with that kind of xenos technology is halved (rounded down). Furthermore, if you believe you know the true function of a xenos machine (the GM will verify), you can spend an action and a Fate Point to activate, disrupt, or shut down that machine without a Test.')

) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

-- =====================================================================
-- max_advances overrides
-- =====================================================================
UPDATE talent SET max_advances = 2 WHERE name = 'SKIT-CODE DISCIPLINE';


-- =====================================================================
-- TALENT ADVANCEMENTS
-- =====================================================================
INSERT INTO talent_advancement (talent_id, advance_number, name, effect, choice)
SELECT t.id, NULL, v.opt_name, v.effect, true
FROM (VALUES
    ('SKIT-CODE DISCIPLINE', 'Hunter Clade',
     'When you are in the same Zone as another member of your party with the Skit-Code Discipline Talent, you can choose to act immediately after them in Initiative and gain +1 SL to all Tests.')
) AS v(talent_name, opt_name, effect)
JOIN talent t ON t.name = v.talent_name
WHERE NOT EXISTS (
    SELECT 1 FROM talent_advancement ta
    WHERE ta.talent_id = t.id AND ta.name = v.opt_name AND ta.choice = true
);