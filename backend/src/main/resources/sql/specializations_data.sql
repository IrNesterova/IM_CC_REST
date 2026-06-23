
-- =====================================================================
-- IMPERIUM MALEDICTUM — SPECIALIZATIONS DATA
-- Source: IM Core Rulebook, pp. 93-101
-- Descriptions taken verbatim from the book.
-- Run AFTER roles_data.sql (skills must already exist).
-- =====================================================================


-- =====================================================================
-- 1. SPECIALIZATIONS
-- =====================================================================
INSERT INTO specialization (name, description)
SELECT name, description FROM (VALUES

    -- Athletics (Str)
    ('CLIMBING',
     'Practised ability to safely and efficiently traverse vertical surfaces. Frequently useful on both Feral and Hive Worlds. Valuable in combat if one has to scale the side of a servo-hauler to get the drop on a heretical demagogue.'),

    ('MIGHT',
     'Advanced capacity for moving greater encumberance, breaking physical objects, and enduring heavy loads. In appropriate circumstances, an Athletics (Might) Test can be used in place of a Presence (Intimidation) Test to achieve similar aims.'),

    ('RIDING',
     'Increased aptitude in piloting equines, or their xenos equivalents. All but essential for controlling such beasts in combat.'),

    ('RUNNING',
     'Greater capability for moving at speed over longer distances. Useful for catching fleeing foes, and escaping from dangerous opponents.'),

    ('SWIMMING',
     'Better aptitude at swimming through liquids, typically water. Essential on some worlds with planet-spanning oceans, and almost unknown on others.'),

    -- Awareness (Per)
    ('HEARING',
     'Facility for detecting and identifying unusual sounds that stand out from local ambient ones. Greater ability to determine where a sound originated from.'),

    ('SIGHT',
     'Advanced capacity for perceiving important details and training in noticing elements that seem even a little incongruous.'),

    ('SMELL',
     'Aptitude for noting and identifying particularly distinct or unusual aromas. Some rare augmentations and genetic enhancements allow those imbued with them to track others entirely by scent alone.'),

    ('TASTE',
     'Superior ability to discern various flavours, including the signs of certain poisons and drugs.'),

    ('TOUCH',
     'Capacity to feel unusual vibrations which indicate the passage of subterranean vehicles and weapon systems. Trained to discern the origin of fabrics and unusual materials by feel. Useful for detecting pickpockets.'),

    ('PSYNISCIENCE (RESTRICTED)',
     'Psykers can be trained to use their connection to the immaterium in order to discern areas where realspace is being, or has been, disrupted due to the intrusion of the warp. This allows them to detect the presence of warp entities and even locate other psykers, so long as they draw on the empyrean to use their psychic abilities. Psyniscience requires the Psyker Talent, though prolonged exposure to warp phenomena and at the GM''s discretion may allow others to take a single advance in this skill.'),

    -- Dexterity (Ag)
    ('LOCK PICKING',
     'Experience in the art of opening mechanical locks without keys. Locks sophisticated enough to have a machine spirit likely requires a Tech (Security) Test to convince them to open.'),

    ('PICKPOCKET',
     'Competence in pilfering the contents of others'' pockets, bags, backpacks, etc. without their noticing. Can also be used in reverse to place (incriminating) items within. Pickpocket is usually opposed by Awareness (Touch).'),

    ('SLEIGHT OF HAND',
     'Training in performing tricks of prestidigitation and secreting various items even while being observed. A master can conceal a weapon with the Subtle Trait even while being searched. Sleight of Hand is usually opposed by Awareness (Sight).'),

    ('DEFUSE (RESTRICTED)',
     'Practical rote instruction in the various techniques and prayers used to harmlessly deactivate explosive devices and disarm trap mechanisms. Defuse requires at least 1 Advance in the Tech Skill.'),

    -- Discipline (Wil)
    ('COMPOSURE',
     'Practised at resisting charm, intimidation, and other social pressures. Those with strong Composure are gifted at maintaining their integrity in the face of temptation.'),

    ('FEAR',
     'Mentally hardened to stand firm in the face of the unnatural fear caused by exposure to heretical and corrupt beings. Fear is often used to resist and recover from the Frightened Condition.'),

    ('PSYCHIC',
     'Advanced training in mentally resisting various psychic powers that can unduly influence or suborn one''s mind.'),

    -- Fortitude (Tgh)
    ('ENDURANCE',
     'Trained to go without sleep for significantly extended periods, pushing on through exhaustion due to greater stamina.'),

    ('PAIN',
     'Increased capability for resisting torture and doing one''s duty despite injuries, due to extensive training in withstanding pain.'),

    ('POISON',
     'Precise exposure to a variety of toxins helps build up resistance, as well as granting experience in how to focus and continue to act effectively, despite having been poisoned.'),

    -- Intuition (Per)
    ('GROUP',
     'As the Intuition skill, but for a group of people who are partly or entirely something other than Human. This includes heavily augmented Tech-priests, Space Marines, or even xenos.'),

    ('PEOPLE',
     'Extensive practice in studying patterns of Human behaviour, allowing one to notice when someone is lying, hiding something, or acting strangely. This skill is often used to oppose Rapport (Deception).'),

    ('SURROUNDINGS',
     'Training in learning to continually read the surrounding environment, noting unusual mistakes in layout, furtive steps, concealed shapes, or ominous patterns of behaviour which indicate something is wrong.'),

    -- Linguistics (Int)
    ('CIPHER',
     'Training in identifying, deciphering, and using secret writing codes. Some ciphers are clearly coded communications that may require a literary key of some kind to unlock, others are messages carefully disguised within other writings.'),

    ('HIGH GOTHIC',
     'Familiarity with the formal language of the Imperium, spoken only in rarefied circles. Knowledge of High Gothic is held within the various branches of the Imperium, the Adeptus Mechanicus, and some older noble houses. The eldest histories of the Imperium, along with its most ancient secrets, are often preserved within datavaults in formal High Gothic.'),

    ('FORBIDDEN (LINGUISTICS)',
     'Those possessed of this skill understand a language or form of communication that is either highly restricted or prohibited within the Imperium. With few exceptions, it is considered heretical to know the languages of aliens; however, the Sisters of the Orders Dialogus are frequently granted special dispensation from the Adeptus Ministorum to learn such in pursuit of their duties. Some xenos languages are unpronounceable by a Human tongue without augmentation. Each Forbidden Language requires taking a corresponding Forbidden Knowledge Talent in order to learn it.'),

    -- Logic (Int)
    ('EVALUATION',
     'The ability to assess relative worth based on perceived qualities. Useful for determining the value of practical goods and equipment, or the soundness of a given structure or device.'),

    ('INVESTIGATION',
     'Training on how to read a crime scene for clues as to what occurred, including inferring whom the parties involved might be, as well as drawing pertinent information from any corpse present. Includes some forensic knowledge, such as knowing how to assess the angle of a strike and the sort of weapons used due to the angle of blood splatters, as well as time since the attack by studying how congealed the gore is.'),

    -- Lore (Int)
    ('ACADEMICS',
     'Grants the ability to write Low Gothic along with some knowledge of arts, economics, books, and local planetary culture. Generally reserved for more connected or well-to-do members of the Imperium.'),

    ('ADEPTUS TERRA',
     'Knowledge not only of the Adeptus Terra itself, but of the many Adepta that make up the structure of the Imperium. This specialisation does not necessarily confer knowledge of any but the most well known members of any particular organisation, but it does cover knowledge of the roles and responsibilities of these organisations and their position with the Imperium at large.'),

    ('PLANET',
     'Specific knowledge about a particular planet, which must be chosen when this specialisation is first taken. For example, Lore (Voll) covers customs, governance, locations, and hazards of that world. It is possible to take this specialisation more than once — each time, choose another planet.'),

    ('SECTOR',
     'Broad knowledge about a particular Sector, which must be chosen when this specialisation is first taken. For example, Lore (Macharian Sector) covers subsectors, power structures, important figures, and the general place of the sector within the wider Imperium. It is possible to take this specialisation more than once — each time, choose another sector.'),

    ('THEOLOGY (RESTRICTED)',
     'Training in the Imperial Creed, including various sects and interpretations. Passing knowledge of the Cult Mechanicus. Only cursory knowledge at best of any heretical sects of the Imperial Creed and none whatsoever of any forbidden cults. Theology requires at least 1 Advance in Linguistics (High Gothic).'),

    ('FORBIDDEN (LORE)',
     'Knowledge and training in a specific subject that is utterly suppressed within the Imperium. Knowing information about aliens or psykers without specific dispensation can get you in serious trouble. True knowledge of daemons leads to summary execution. Any knowledge of the immaterium, beyond common myth, is typically strictly obscured within the Imperium, as is real knowledge about the Adeptus Astartes. Each Forbidden Lore requires taking a corresponding Forbidden Knowledge Talent in order to learn it.'),

    -- Medicae (Int)
    ('ANIMAL',
     'Studied in the medical arts that deal specifically with the prevention and treatment of disease and injuries to animals. Includes extensive knowledge of their anatomies, patterns of behaviour, and products derived from them.'),

    ('HUMAN',
     'Advanced training in treating disease and injuries in Humans. Used for first aid, stabilising the heavily injured, and stopping bleeding. Despite the name, it will work on Abhumans such as Ratlings, Ogryn, and Kin of the Leagues of Votann.'),

    ('FORBIDDEN (MEDICAE)',
     'Examples include knowledge of the installation and configuration of various radical Augmetics. Advanced medical training in treating disease and injuries in a specific species of xenos creature — typically used after a battle to stabilise one of them long enough for interrogation. Knowledge of diseases borne of the warp. Each Forbidden Medicae requires taking a corresponding Forbidden Knowledge Talent in order to learn it.'),

    -- Melee (WS)
    ('BRAWLING',
     'Experience in the brutal art of pugilism. Covers everything from fighting with bare hands or brass knuckles, through to inflicting devastating blows with a mighty Power Fist.'),

    ('ONE-HANDED',
     'Extensive training in the use of swords, axes, maces, and other melee weapons that can be used with a single hand.'),

    ('TWO-HANDED',
     'Extensive training in the use of larger swords, bigger axes, heavier maces, and other melee weapons that require two hands to use, along with various polearms such as spears and halberds.'),

    -- Navigation (Int)
    ('SURFACE',
     'Training in plotting and following a likely course over land or sea in order to reach a chosen destination in the most efficient way possible.'),

    ('TRACKING',
     'Extensive training in how to read the marks left by the passage of others, in order to follow them, but also to determine information such as their numbers, if they are carrying a heavy load or travelling light, if they were in a hurry, and so on.'),

    ('VOID',
     'Capacity with the unusual knowledge of how to plot and follow a course between celestial bodies within a system.'),

    ('WARP (RESTRICTED)',
     'The ability to plot a course through the uncertain eddies and currents of the immaterium. A skill based on feeling as much as knowledge, it is impossible to accurately navigate the warp without the ability to perceive it, which is why this skill is held exclusively by the mutant Navigators of the Navis Nobilite. Using this skill requires the Inheritor (Navis Nobilite) Talent.'),

    -- Piloting (Ag)
    ('AERONAUTICA',
     'Advanced training in how to operate flying vehicles, from transports to combat aircraft. This specialisation is sufficient for taking capable craft from orbit down to a planet, but not for performing complex manoeuvres outside of a planet''s atmosphere.'),

    ('CIVILIAN',
     'Advanced training in how to operate non-military ground vehicles such as cargo haulers or personal transports.'),

    ('MILITARY (RESTRICTED)',
     'Advanced training in how to operate military ground vehicles, such as tanks. Typically, training in this specialisation is given by Astra Militarum instructors, to characters of sufficient rank.'),

    ('MINOR VOIDSHIP (RESTRICTED)',
     'Advanced training in operating smaller space vessels, from void fighters to transports. Typically, training in this specialisation is given by Imperial Navy instructors, to characters of sufficient rank.'),

    ('MAJOR VOIDSHIP (RESTRICTED)',
     'Training in how to operate the truly vast ships of the Imperial Fleet — Cruisers, Destroyers, Frigates, and similar. Typically, training in this specialisation is given by Imperial Navy instructors, to characters of sufficient rank.'),

    -- Presence (Wil)
    ('INTERROGATION',
     'Aptitude in a variety of techniques designed to elicit answers out of a subject. A skilled interrogator implies pressure in many ways, subtle and not, in order to discover as much information as they can, even when a subject is cooperative. Interrogation is not physical torture, though undergoing a long interrogation may certainly feel agonising. Interrogation is opposed by the target''s Discipline (Composure) or Fortitude (Pain).'),

    ('INTIMIDATION',
     'Applying pressure through threats, subtle or blatant, that physical chastisement and other dire fates await those that fail to do as they are told or confess all they know. Intimidation is often opposed by Discipline (Composure). If one party is of a larger Size than the other, the larger creature gains Advantage on this Test.'),

    ('LEADERSHIP',
     'Trained to inspire others to put in their best efforts to achieve a desired goal. This can range anywhere from motivating a few clerks to finish a long survey in record time, to giving a group of desperate soldiers the courage to charge a fortified enemy bunker.'),

    -- Psychic Mastery (Wil) — individual descriptions on p.160
    ('BIOMANCY',
     'Psychic Discipline: mastery over the forces of life, flesh, and the body. For full details see the Psychic Disciplines chapter.'),

    ('DIVINATION',
     'Psychic Discipline: glimpsing threads of the future and reading the skein of fate. For full details see the Psychic Disciplines chapter.'),

    ('PYROMANCY',
     'Psychic Discipline: command over fire, heat, and purifying flame. For full details see the Psychic Disciplines chapter.'),

    ('TELEKINESIS',
     'Psychic Discipline: moving and manipulating objects with the power of the mind. For full details see the Psychic Disciplines chapter.'),

    ('TELEPATHY',
     'Psychic Discipline: reading, influencing, and communicating through the minds of others. For full details see the Psychic Disciplines chapter.'),

    -- Ranged (BS)
    ('LONG GUNS',
     'Extensive training in the use of longer firearms, such as lasguns, shotguns, bolters, autoguns, meltaguns, and similar ranged weapons.'),

    ('ORDNANCE',
     'Extensive training in the use of heavier ranged weaponry, such as lascannons, heavy bolters, missile launchers, and similarly devastating means of causing death and destruction.'),

    ('PISTOLS',
     'Extensive training in the use of handguns, such as laspistols, bolt pistols, autopistols, stub revolvers, and similar firearms.'),

    ('THROWN',
     'Extensive training in the use of hurled weapons, such as grenades and throwing knives.'),

    -- Rapport (Fel)
    ('ANIMALS',
     'Aptitude for gaining the friendship and affection of simple beasts, along with the knowledge of how to care for them. Useful for interacting with guardian canids to, for example, issue one a command, or get a hostile one to stop barking.'),

    ('CHARM',
     'Skilled at being exceedingly agreeable and with pleasant company, leading to increased ability to make reasonable requests of one''s new friends. Charm is often opposed by Discipline (Composure).'),

    ('DECEPTION',
     'Well-practised, or specifically trained, to deceive without flinching. Deception is often opposed by Intuition.'),

    ('HAGGLE',
     'Versed in the ancient art of bargaining for the best deal. Haggle is often opposed by either Discipline (Composure) or Logic (Evaluation).'),

    ('INQUIRY',
     'Trained, or naturally skilled, at getting answers out of others via gossip, friendly conversation, or pointed questions. Inquiry can be opposed by either Discipline (Composure) or Presence (Intimidation).'),

    -- Reflexes (Ag)
    ('ACROBATICS',
     'Training in gymnastic exercises, with increased capacity for gracefully jumping, rolling, and tumbling. Can be used to swiftly traverse otherwise difficult terrain.'),

    ('BALANCE',
     'Practice in keeping on one''s feet, despite uncertain ground, pools of slippery unguents, or treacherous walkways.'),

    ('DODGE',
     'Capacity for avoiding injury or accident through quick movements designed to sidestep the danger. Can be used to defend yourself in combat against melee and ranged attacks. While the unaugmented cannot directly dodge bullets, they can avoid being shot by swiftly removing themselves from the line of fire.'),

    -- Stealth (Ag)
    ('CONCEAL',
     'Aptitude for knowing how to obscure places and objects so that others cannot easily find them. Conceal is often opposed by either Awareness (Sight) or Intuition (Surroundings).'),

    ('HIDE',
     'Competence at becoming unseen or unremarked by others, such as when camouflaged amidst xenofoliage or tailing someone through a crowd. Hide is usually opposed by Awareness (Sight).'),

    ('MOVE SILENTLY',
     'Trained facility for moving soundlessly and avoiding drawing attention. Move Silently is usually opposed by Awareness (Hearing).'),

    -- Tech (Int)
    ('AUGMETICS (RESTRICTED)',
     'Studied in the use and repair of different types of augmetic devices. Most augmetics are mechanical or electrical augmetic substitutes for Human biological parts, many with enhanced capacities, though some offer entirely new capabilities. Augmetics requires at least 1 Advance in the Medicae Skill.'),

    ('ENGINEERING',
     'Knowledge of the construction, use, and restoration of technological and mechanical devices. Encompasses the crafting of such items, as well as weapons and explosives. Within the Imperium, the Adeptus Mechanicus considers this entire branch of knowledge to be their exclusive right and will punish those who use it, or even study it, without their sanction.'),

    ('SECURITY',
     'Knowledge of how to interact with the Machine Spirits that control security devices, along with whatever other systems have been linked to the same, such as doors, thermo-regulators, weapons systems, and so forth, in order to direct them in specific ways. Accomplished through the use of binary codes, modern and ancient, along with various techniques used to sift information from datavaults, secured or otherwise. A Specialisation known to few outside the Adeptus Mechanicus.')

) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM specialization s WHERE s.name = v.name);


-- =====================================================================
-- 2. SKILL — SPECIALIZATION LINKS (skill_specializations)
-- =====================================================================
INSERT INTO skill_specializations (skill_id, specialization_id)
SELECT s.id, sp.id
FROM (VALUES
    -- Athletics
    ('ATHLETICS',       'CLIMBING'),
    ('ATHLETICS',       'MIGHT'),
    ('ATHLETICS',       'RIDING'),
    ('ATHLETICS',       'RUNNING'),
    ('ATHLETICS',       'SWIMMING'),
    -- Awareness
    ('AWARENESS',       'HEARING'),
    ('AWARENESS',       'SIGHT'),
    ('AWARENESS',       'SMELL'),
    ('AWARENESS',       'TASTE'),
    ('AWARENESS',       'TOUCH'),
    ('AWARENESS',       'PSYNISCIENCE (RESTRICTED)'),
    -- Dexterity
    ('DEXTERITY',       'LOCK PICKING'),
    ('DEXTERITY',       'PICKPOCKET'),
    ('DEXTERITY',       'SLEIGHT OF HAND'),
    ('DEXTERITY',       'DEFUSE (RESTRICTED)'),
    -- Discipline
    ('DISCIPLINE',      'COMPOSURE'),
    ('DISCIPLINE',      'FEAR'),
    ('DISCIPLINE',      'PSYCHIC'),
    -- Fortitude
    ('FORTITUDE',       'ENDURANCE'),
    ('FORTITUDE',       'PAIN'),
    ('FORTITUDE',       'POISON'),
    -- Intuition
    ('INTUITION',       'GROUP'),
    ('INTUITION',       'PEOPLE'),
    ('INTUITION',       'SURROUNDINGS'),
    -- Linguistics
    ('LINGUISTICS',     'CIPHER'),
    ('LINGUISTICS',     'HIGH GOTHIC'),
    ('LINGUISTICS',     'FORBIDDEN (LINGUISTICS)'),
    -- Logic
    ('LOGIC',           'EVALUATION'),
    ('LOGIC',           'INVESTIGATION'),
    -- Lore
    ('LORE',            'ACADEMICS'),
    ('LORE',            'ADEPTUS TERRA'),
    ('LORE',            'PLANET'),
    ('LORE',            'SECTOR'),
    ('LORE',            'THEOLOGY (RESTRICTED)'),
    ('LORE',            'FORBIDDEN (LORE)'),
    -- Medicae
    ('MEDICAE',         'ANIMAL'),
    ('MEDICAE',         'HUMAN'),
    ('MEDICAE',         'FORBIDDEN (MEDICAE)'),
    -- Melee
    ('MELEE',           'BRAWLING'),
    ('MELEE',           'ONE-HANDED'),
    ('MELEE',           'TWO-HANDED'),
    -- Navigation
    ('NAVIGATION',      'SURFACE'),
    ('NAVIGATION',      'TRACKING'),
    ('NAVIGATION',      'VOID'),
    ('NAVIGATION',      'WARP (RESTRICTED)'),
    -- Piloting
    ('PILOTING',        'AERONAUTICA'),
    ('PILOTING',        'CIVILIAN'),
    ('PILOTING',        'MILITARY (RESTRICTED)'),
    ('PILOTING',        'MINOR VOIDSHIP (RESTRICTED)'),
    ('PILOTING',        'MAJOR VOIDSHIP (RESTRICTED)'),
    -- Presence
    ('PRESENCE',        'INTERROGATION'),
    ('PRESENCE',        'INTIMIDATION'),
    ('PRESENCE',        'LEADERSHIP'),
    -- Psychic Mastery
    ('PSYCHIC MASTERY', 'BIOMANCY'),
    ('PSYCHIC MASTERY', 'DIVINATION'),
    ('PSYCHIC MASTERY', 'PYROMANCY'),
    ('PSYCHIC MASTERY', 'TELEKINESIS'),
    ('PSYCHIC MASTERY', 'TELEPATHY'),
    -- Ranged
    ('RANGED',          'LONG GUNS'),
    ('RANGED',          'ORDNANCE'),
    ('RANGED',          'PISTOLS'),
    ('RANGED',          'THROWN'),
    -- Rapport
    ('RAPPORT',         'ANIMALS'),
    ('RAPPORT',         'CHARM'),
    ('RAPPORT',         'DECEPTION'),
    ('RAPPORT',         'HAGGLE'),
    ('RAPPORT',         'INQUIRY'),
    -- Reflexes
    ('REFLEXES',        'ACROBATICS'),
    ('REFLEXES',        'BALANCE'),
    ('REFLEXES',        'DODGE'),
    -- Stealth
    ('STEALTH',         'CONCEAL'),
    ('STEALTH',         'HIDE'),
    ('STEALTH',         'MOVE SILENTLY'),
    -- Tech
    ('TECH',            'AUGMETICS (RESTRICTED)'),
    ('TECH',            'ENGINEERING'),
    ('TECH',            'SECURITY')
) AS v(skill_name, spec_name)
JOIN skill s           ON s.name  = v.skill_name
JOIN specialization sp ON sp.name = v.spec_name
WHERE NOT EXISTS (
    SELECT 1 FROM skill_specializations ss
    WHERE ss.skill_id = s.id AND ss.specialization_id = sp.id
);