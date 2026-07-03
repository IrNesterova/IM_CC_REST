-- Patron reference data (Imperium Maledictum core rulebook, Chapter II)
-- All INSERTs are idempotent (WHERE NOT EXISTS on name).

-- ── Motivations ──────────────────────────────────────────────────────────────
INSERT INTO patron_motivation (name, description)
SELECT 'Conflict',
       'Strife creates strength. Competition between allies is desirable. Eliminate the weak. '
       'Your Patron achieves their goals through violence, directly or indirectly. They might '
       'assign you to assassinate a particular target, or purge a cell of suspected heretics. '
       'You might be required to conduct misinformation campaigns to agitate conflict between two groups.'
WHERE NOT EXISTS (SELECT 1 FROM patron_motivation WHERE name = 'Conflict');

INSERT INTO patron_motivation (name, description)
SELECT 'Information',
       'Knowledge is power. The best way to destroy one''s enemies is to understand them. '
       'Your Patron collects and applies information to achieve their goals. They might send you '
       'far afield to explore a newly re-discovered archeotech hoard, or to go undercover and '
       'gather intelligence on a rival Inquisitor.'
WHERE NOT EXISTS (SELECT 1 FROM patron_motivation WHERE name = 'Information');

INSERT INTO patron_motivation (name, description)
SELECT 'Material',
       'Protecting one''s assets is of utmost import. A fortress is only as strong as its foundation. '
       'Your Patron is focused on the acquisition and protection of material property. They might '
       'send you far afield to uncover lost relics, or to secure territory in their name. Even '
       'gathering new recruits to a cause or hunting psykers to supply the Emperor''s Tithe fit '
       'the motivation of a Patron focused on material.'
WHERE NOT EXISTS (SELECT 1 FROM patron_motivation WHERE name = 'Material');

INSERT INTO patron_motivation (name, description)
SELECT 'Reputation',
       'Adoration, faith, fear. Long after every solar is spent and every bullet fired, these things endure. '
       'Your Patron seeks to build their status in the Imperium. They may require you to undertake '
       'acts of heroism to spread the good word of their name, or to blacken the names of a rival '
       'so that your Patron may ascend in their place.'
WHERE NOT EXISTS (SELECT 1 FROM patron_motivation WHERE name = 'Reputation');

INSERT INTO patron_motivation (name, description)
SELECT 'Unity',
       'The Imperium is strongest when all its servants cooperate. By word or by bolt, ensure they do so. '
       'Your Patron believes that discord between Factions is the biggest threat to the Emperor''s realm, '
       'and seeks to unify the Imperium. You will likely operate as problem solvers, brokering deals and '
       'completing diplomatic missions. Your Patron might ask you to defend an individual or a location '
       'to ensure the peace is kept, or send you to uncover and foil a plot to agitate conflict before '
       'it blossoms into all-out war.'
WHERE NOT EXISTS (SELECT 1 FROM patron_motivation WHERE name = 'Unity');

-- ── Payment Grades ───────────────────────────────────────────────────────────
INSERT INTO patron_payment_grade (name, pay_per_day)
SELECT 'Poor', 50
WHERE NOT EXISTS (SELECT 1 FROM patron_payment_grade WHERE name = 'Poor');

INSERT INTO patron_payment_grade (name, pay_per_day)
SELECT 'Standard', 100
WHERE NOT EXISTS (SELECT 1 FROM patron_payment_grade WHERE name = 'Standard');

INSERT INTO patron_payment_grade (name, pay_per_day)
SELECT 'Good', 200
WHERE NOT EXISTS (SELECT 1 FROM patron_payment_grade WHERE name = 'Good');

INSERT INTO patron_payment_grade (name, pay_per_day)
SELECT 'Excellent', 600
WHERE NOT EXISTS (SELECT 1 FROM patron_payment_grade WHERE name = 'Excellent');

-- ── Demeanours (d10 table, IM core rulebook) ─────────────────────────────────
INSERT INTO patron_demeanour (name, description, roll_min, roll_max)
SELECT 'Wrathful',
       'Your Patron is ambitious and decisive. They are quick to act. They demand results and accept '
       'no excuses. They may also be vengeful or quick to anger.',
       1, 2
WHERE NOT EXISTS (SELECT 1 FROM patron_demeanour WHERE name = 'Wrathful');

INSERT INTO patron_demeanour (name, description, roll_min, roll_max)
SELECT 'Sombre',
       'Your Patron is thoughtful and analytical. They are slow to act, and consider the ramifications '
       'of each decision. They expect perfection in their servants as much as themself.',
       3, 4
WHERE NOT EXISTS (SELECT 1 FROM patron_demeanour WHERE name = 'Sombre');

INSERT INTO patron_demeanour (name, description, roll_min, roll_max)
SELECT 'Pragmatic',
       'Your Patron is serene and quiet. They have a knack for seeing other perspectives and recognize '
       'the necessity of compromise more so than most leaders of the Imperium.',
       5, 6
WHERE NOT EXISTS (SELECT 1 FROM patron_demeanour WHERE name = 'Pragmatic');

INSERT INTO patron_demeanour (name, description, roll_min, roll_max)
SELECT 'Zealous',
       'Your Patron is loquacious, active, and enthusiastic. They surround themself with servants and '
       'allies. They despise idleness but may act rashly.',
       7, 8
WHERE NOT EXISTS (SELECT 1 FROM patron_demeanour WHERE name = 'Zealous');

INSERT INTO patron_demeanour (name, description, roll_min, roll_max)
SELECT 'Inscrutable',
       'Your Patron conceals their personality behind a veneer of stoic professionalism or smooth geniality.',
       9, 10
WHERE NOT EXISTS (SELECT 1 FROM patron_demeanour WHERE name = 'Inscrutable');

-- ── Boons ────────────────────────────────────────────────────────────────────
-- Faction junction data (patron_boon_factions) to be seeded separately.

INSERT INTO patron_boon (name, description) SELECT 'Administratum Censorium', 'Your Patron gives you access to a base of operations within one of the massive Archiviums used to store the endless, growing tide of the Imperium''s official records. You can use the Censorium to access information on virtually any location, organisation, or family — though the Imperium frequently revises its historical records to bring them in line with the official version of events.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Administratum Censorium');

INSERT INTO patron_boon (name, description) SELECT 'Administratum Training Facility', 'Adeptus Administratum: +1 Patron Influence. Your Patron grants you the use of an Adeptus Administratum training facility. Whilst at this facility, the XP cost of the following Specialisations is reduced by 20: Intuition (People), Linguistics (High Gothic), Logic (Evaluation) & (Investigation), Lore (Academics) & (Common), Medicae (Human), Rapport (Inquiry).' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Administratum Training Facility');

INSERT INTO patron_boon (name, description) SELECT 'Adeptus Mechanicus Instruction', 'Adeptus Mechanicus: +1 Patron Influence. Your Patron trains Tech-Adepts of the Mechanicus, or has a staunch alliance with someone who does. Whilst being trained, the XP cost of the following Specialisations is reduced by 20: Logic (All), Lore (All), Tech (All).' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Adeptus Mechanicus Instruction');

INSERT INTO patron_boon (name, description) SELECT 'Adeptus Ministorum Training Facility', 'Adeptus Ministorum: +1 Patron Influence. Your Patron grants you the use of an Adeptus Ministorum training facility. Whilst at this facility, the XP cost of the following Specialisations is reduced by 20: Intuition (People), Linguistics (High Gothic), Lore (Theology), Presence (All), Rapport (Charm).' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Adeptus Ministorum Training Facility');

INSERT INTO patron_boon (name, description) SELECT 'Air Support', 'Imperial Fleet: +1 Patron Influence. Your Patron can always secure you Good Quality Planetary travel on atmospheric craft. Additionally, once during a mission, you can call in a focused air strike or close air support, which can be resolved as three attacks of either Frag or Krak Missiles with a Ranged skill of 60.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Air Support');

INSERT INTO patron_boon (name, description) SELECT 'Ameliorator', 'Your Patron is obsessed with improving both your weapons and your bodies. You do not have to make an Availability Test for Weapon Modifications or Augmetics. Your Patron will arrange or perform Augmetic surgeries for free — indeed, they may demand you undergo such procedures any time the opportunity arises.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Ameliorator');

INSERT INTO patron_boon (name, description) SELECT 'Ancient Servants', 'Adeptus Mechanicus or Adeptus Administratum: +1 Patron Influence. Your Patron has access to a cache of ancient Servo-Skulls pledged to a duty beyond death. Your Patron can furnish each member of your party with a single Monotask Servo-Skull.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Ancient Servants');

INSERT INTO patron_boon (name, description) SELECT 'Astropathic Communication', 'Adeptus Astra Telepathica: +1 Patron Influence. Your Patron is or has access to an Astropath, capable of communicating across the void with other Astropaths. Without this Boon, the only means of contacting your Patron may be through vox systems or personal messengers.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Astropathic Communication');

INSERT INTO patron_boon (name, description) SELECT 'Augmetics Bay', 'Your Patron gives you access to a base of operations within an augmetic installation facility. You do not have to make an Availability Test for Augmetics. Your Patron will arrange Augmetic surgeries for free, and ensures any Augmetics you procure have one item Quality.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Augmetics Bay');

INSERT INTO patron_boon (name, description) SELECT 'Backchannel Contacts', 'Your Patron has a secret alliance with a member of another Faction. The group may select a suitable Faction, and the Gamemaster will select or create a non-player character in that Faction. This Backchannel Contact confers +3 Influence with their Faction. However, this relationship is a two way street, and the Contact will require the Characters to sometimes act on their behalf.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Backchannel Contacts');

INSERT INTO patron_boon (name, description) SELECT 'Blackmailer', 'Infractionists: +1 Patron Influence. Your Patron uses their power to seize secret information that others would prefer remain private. Before each mission, your Patron may provide you with leverage on a particular individual, granting you +1 Superiority when you interact with them.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Blackmailer');

INSERT INTO patron_boon (name, description) SELECT 'Cartographica Contacts', 'Imperial Fleet or Rogue Trader Dynasties: +1 Patron Influence. Your Patron is a member of, or has dependable contacts in, the Astra Cartographica. Your Patron can furnish you with void maps and may be able to arrange reduced cost, or even free, void travel.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Cartographica Contacts');

INSERT INTO patron_boon (name, description) SELECT 'Ceremonialist', 'Adeptus Ministorum: +1 Patron Influence. Your Patron has the passion and power to organise worshipful ceremonies in the God-Emperor''s name. Once per mission, you may ask your Patron to organise a ceremony, such as a pious parade or a mandatory prayer session.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Ceremonialist');

INSERT INTO patron_boon (name, description) SELECT 'Clandestine Inquisition Training Facility', 'Inquisition: +1 Patron Influence. Your Patron grants you the use of a specialised training facility for agents of the Inquisition. Whilst at this facility, the XP cost of the following Specialisations is reduced by 20: Awareness (Sight) & (Hearing), Discipline (All), Intuition (All), Logic (Investigation), Navigation (Tracking), Presence (Interrogation), Rapport (Inquiry).' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Clandestine Inquisition Training Facility');

INSERT INTO patron_boon (name, description) SELECT 'Cleansing Flame', 'Your Patron has a passion for purgation through holy flame. At the start of each mission, each character may gain one of the following that they do not already possess: a Hand Flamer, a Flamer, a magazine of Inferno Shells, 3 Fire Bombs, or an Exterminator Cartridge.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Cleansing Flame');

INSERT INTO patron_boon (name, description) SELECT 'Clerk Cadre', 'Adeptus Administratum: +1 Patron Influence. Your Patron can exert their power to deploy a cadre of low-ranking Administratum Clerks. Once per mission, your Patron can put a pair of Administratum Adepts under the party''s command for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Clerk Cadre');

INSERT INTO patron_boon (name, description) SELECT 'Connoisseur', 'Your Patron likes the finer things in life. When interacting with your Patron, you have Advantage on Availability Tests, and always have the option to acquire equipment with either the Master Crafted or Ornamental Quality.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Connoisseur');

INSERT INTO patron_boon (name, description) SELECT 'Contact Network', 'Your Patron has a network of informants across the Macharian Sector. These informants are allies that can furnish you with information, giving you Advantage on Rapport (Inquiry) Tests in the local area.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Contact Network');

INSERT INTO patron_boon (name, description) SELECT 'Contrabandist', 'Infractionists: +1 Patron Influence. Your Patron has connections throughout the underworld of the Imperium, and is capable of getting their hands on anything you might need. Before any mission, you may ask your Patron to secure any item regardless of Availability, for half the cost.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Contrabandist');

INSERT INTO patron_boon (name, description) SELECT 'Conveyance Commander', 'Imperial Fleet: +1 Patron Influence. Your Patron holds sway over multiple forms of transportation. Your Patron can organise any form of Good Quality transportation for free, and is capable of acquiring shipping records and crew manifests on request.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Conveyance Commander');

INSERT INTO patron_boon (name, description) SELECT 'Cover Story', 'Once per mission, your Patron is capable of constructing false identities for your party. Your new identity has +1 Influence with a specific Faction and has the correct uniform. It is up to you to maintain your false identity with Challenging (+0) Rapport (Deception) Tests.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Cover Story');

INSERT INTO patron_boon (name, description) SELECT 'Datavault Access', 'Your Patron has the power to grant you access to any repository of knowledge related to their Faction. For example, an Adeptus Administratum Patron might give you access to boundless tithe records, or an Adeptus Mechanicus Patron might grant you the liberty to view their cache of esoteric technological knowledge.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Datavault Access');

INSERT INTO patron_boon (name, description) SELECT 'Deploy Devout', 'Adeptus Ministorum: +1 Patron Influence. Your Patron can exert their power to deploy a group of fanatical worshippers of the God-Emperor. Once per mission, your Patron can put a number of Devout equal to the number of characters in the party under the party''s command for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Deploy Devout');

INSERT INTO patron_boon (name, description) SELECT 'Drop Squad', 'Imperial Fleet: +1 Patron Influence. Your Patron can exert their power to deploy a squad of Navis Imperialis security. Once per mission, your Patron can put a number of Armsmen equal to the number of characters in the party in their command for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Drop Squad');

INSERT INTO patron_boon (name, description) SELECT 'Ecclesiarchal Shrine', 'Your Patron gives you access to a base of operations within some kind of shrine, church, or cathedrum. The Difficulty of all Lore (Theology) Tests is reduced by 20 when you use the shrine''s library, and each character receives a Holy Icon for free.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Ecclesiarchal Shrine');

INSERT INTO patron_boon (name, description) SELECT 'Fearsome Reputation', 'The mere mention of your Patron''s name is enough to strike terror into the hearts of any who know of them. When you invoke your Patron''s name, you can choose to force anyone who is aware of their reputation to make a Hard (–20) Discipline (Fear) Test or become Frightened.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Fearsome Reputation');

INSERT INTO patron_boon (name, description) SELECT 'Forbidden Archive', 'Your Patron has collected strange and heretical knowledge. They are willing to give you access to this forbidden archive, potentially giving you information on your targets and enemies, and giving Advantage on Lore (Forbidden) Tests.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Forbidden Archive');

INSERT INTO patron_boon (name, description) SELECT 'Forger', 'Your Patron can create or acquire counterfeit documentation. You can request any kind of documentation from your Patron that they could conceivably fabricate, and they will supply you with it in 1 week. Your forgery can only be detected with a Very Hard (–30) Logic (Evaluation) Test.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Forger');

INSERT INTO patron_boon (name, description) SELECT 'Gang Backup', 'Infractionists: +1 Patron Influence. Your Patron can exert their power to deploy a band of rough Infractionist toughs. Once per mission, your Patron can put a number of Gangers equal to the number of characters in the party under the party''s command for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Gang Backup');

INSERT INTO patron_boon (name, description) SELECT 'Ideologue Crusader', 'Your Patron is known for taking up arms to wage wars of faith. When you invoke your Patron''s name, you have Advantage on Tests to convince people to take up arms in the name of the God-Emperor. If your Patron is a member of the Astra Militarum, Imperial Fleet, or Rogue Trader Dynasty, they gain +1 Influence with the Adeptus Ministorum. If your Patron is a member of the Adeptus Ministorum, they gain +1 Influence with the Astra Militarum or the Imperial Fleet.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Ideologue Crusader');

INSERT INTO patron_boon (name, description) SELECT 'Limitless Authority', 'Your Patron is an Inquisitor, empowered with theoretically limitless authority over the other Factions of the Imperium. When you use your Patron''s Influence, you may choose to use their Influence with the Inquisition instead of the target''s Faction.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Limitless Authority');

INSERT INTO patron_boon (name, description) SELECT 'Machine Spirit Maintenance', 'Adeptus Mechanicus: +1 Patron Influence. The Adeptus Mechanicus has sole purview over the sacred maintenance of machinery in the Imperium. Once per mission, your Patron can declare maintenance is necessary on a particular machine and send you to conduct the sacred rites, affording you access to a location you may not otherwise have.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Machine Spirit Maintenance');

INSERT INTO patron_boon (name, description) SELECT 'Manufactorum Master', 'Your Patron is in charge of ensuring a manufactorum outputs useful equipment for the Imperium. Choose one type of equipment such as Flak Armour, Las Weapons, or Custom Ammunition. Your Patron can always provide one item of Common or Scarce equipment of that type at the start of each mission.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Manufactorum Master');

INSERT INTO patron_boon (name, description) SELECT 'Martial Training Facility', 'Your Patron grants you the use of a training facility designed to forge elite fighting forces. Whilst at this facility, the XP cost of the following Specialisations is reduced by 20: Athletics (All), Discipline (Fear), Fortitude (All), Medicae (Human), Melee (One-handed), Navigation (Surface), Ranged (All).' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Martial Training Facility');

INSERT INTO patron_boon (name, description) SELECT 'Medicae Facility', 'Your Patron gives you access to a base of operations within a medicae facility. You can use the sanctum to access medical records and Good Quality Medical Care.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Medicae Facility');

INSERT INTO patron_boon (name, description) SELECT 'Munitorum Depot', 'Your Patron gives you access to a base of operations within a Departmento Munitorum sanctum. You have Advantage on Availability Tests and receive additional magazines for your weapons for free.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Munitorum Depot');

INSERT INTO patron_boon (name, description) SELECT 'Munitorum Surplus', 'Astra Militarum: +1 Patron Influence. Your Patron has access to surplus Astra Militarum supplies. Each character may start play with any one option: a Laspistol, Lasgun, or Long Las; 3 Frag or Krak Grenades; any one piece of Flak Armour; or one piece of standard field equipment.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Munitorum Surplus');

INSERT INTO patron_boon (name, description) SELECT 'Noble Blood', 'Once per mission, your Patron gives you a writ of introduction, granting you the right to an audience with a member of the Imperial nobility on any world.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Noble Blood');

INSERT INTO patron_boon (name, description) SELECT 'Null Sanctum', 'Your Patron gives you access to a base of operations that incorporates a null-prison, a room immune to psychic powers and any warp influence, typically used to imprison psykers.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Null Sanctum');

INSERT INTO patron_boon (name, description) SELECT 'Opulent', 'Your Patron is wealthy and generous. Increase your Patron''s Payment Grade 1 step.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Opulent');

INSERT INTO patron_boon (name, description) SELECT 'Oracular', 'Adeptus Astra Telepathica: +1 Patron Influence. Your Patron (or perhaps a psyker in their service) receives brief portents of events yet to pass. Once during each mission you can ask your Patron to use any Divination Psychic Power.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Oracular');

INSERT INTO patron_boon (name, description) SELECT 'Planetary Domination', 'Your Patron is the official ruler of an Imperial world. On the planet your Patron controls, their Influence with all Factions is increased by +1.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Planetary Domination');

INSERT INTO patron_boon (name, description) SELECT 'Plausible Deniability', 'Infractionists: +1 Patron Influence. Your Patron counts amongst their servants some few who would be willing to break the Lex Imperialis and face the consequences on their behalf. Once per mission, you can request that your Patron send some of their connections to commit a crime of your choosing.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Plausible Deniability');

INSERT INTO patron_boon (name, description) SELECT 'Psychic Protection', 'At the start of each mission, your Patron wards you against Psychic Powers. You are granted Advantage on Discipline (Psychic) Tests until you fail a Discipline (Psychic) Test.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Psychic Protection');

INSERT INTO patron_boon (name, description) SELECT 'Psyker Support', 'Adeptus Astra Telepathica: +1 Patron Influence. Your Patron can exert their power to deploy a Sanctioned Psyker to assist you. Once per mission, they can dispatch a Primaris Psyker to aid the party for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Psyker Support');

INSERT INTO patron_boon (name, description) SELECT 'Purification Rituals', 'Before each mission, your Patron conducts a ritual to protect you from the warp, granting Advantage on the first Test you make to resist Corruption. At the end of each mission, your Patron conducts a ritual to purify your soul, halving your current Corruption Points.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Purification Rituals');

INSERT INTO patron_boon (name, description) SELECT 'Recruitment Drive', 'Astra Militarum, Adeptus Administratum, or Imperial Fleet: +1 Patron Influence. Your Patron has the power to press-gang Imperial citizens. Once per mission, you can request that your Patron make a recruitment drive, interrupting the usual activities of the area and forcing all unranked workers into one place.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Recruitment Drive');

INSERT INTO patron_boon (name, description) SELECT 'Refined Panoply', 'Your Patron takes pride in armouring their agents. While interacting with your Patron, you have Advantage on Availability Tests made to find Armour, and the cost of Armour is halved.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Refined Panoply');

INSERT INTO patron_boon (name, description) SELECT 'Registered Trader', 'Adeptus Administratum, Imperial Fleet, or Rogue Trader Dynasties: +1 Patron Influence. Your Patron is one of the rare few individuals licensed to trade in the Macharian Sector. Your Patron may acquire anything from the Armoury at a discount equal to 10% multiplied by their highest Influence modifier.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Registered Trader');

INSERT INTO patron_boon (name, description) SELECT 'Righteous Bolts', 'Your Patron reveres the awe-inspiring power of bolt weaponry. Your Patron provides each character with either a Bolt Pistol or a Bolter. Your Patron may also provide you with bolt ammunition at the end of each mission depending on your performance.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Righteous Bolts');

INSERT INTO patron_boon (name, description) SELECT 'Sanctum Obscurus', 'Your Patron gives you access to a secret safehouse hidden from the rest of the Imperium, festooned with equipment for clandestine activities. It is stocked with: a Cameleoline Cloak, Photo-visors, an Auspex, a Climbing Harness, a Comm Leech, a Disguise Kit, 3 Magnoculars, a Pict Recorder, a Signal Jammer, and a Vox-caster.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Sanctum Obscurus');

INSERT INTO patron_boon (name, description) SELECT 'Seconded Troopers', 'Astra Militarum: +1 Patron Influence. Your Patron can exert their power to deploy a small squad of Imperial Guard infantry. Once per mission, your Patron can put a number of Astra Militarum Troopers equal to the number of characters in the party under the party''s command for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Seconded Troopers');

INSERT INTO patron_boon (name, description) SELECT 'Servitor Clade', 'Adeptus Mechanicus: +1 Patron Influence. Your Patron can exert their power to deploy a squad of monotask servitors. Once per mission, your Patron can slave a Servitor to each member of the party for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Servitor Clade');

INSERT INTO patron_boon (name, description) SELECT 'Spy Network', 'Your Patron maintains a cohort of insider informants in every Imperial Faction. If you can make contact with an informant, they may have useful information on the Faction''s current activities.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Spy Network');

INSERT INTO patron_boon (name, description) SELECT 'Strategos Extremis', 'Your Patron is an expert tactician and strategist, and can be called upon to offer advice in dire situations. Once in each mission, you can attempt to contact your Patron for guidance, likely resulting in your party gaining +1 Superiority.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Strategos Extremis');

INSERT INTO patron_boon (name, description) SELECT 'Summon Sermoniser', 'Adeptus Ministorum: +1 Patron Influence. Your Patron can exert their power to deploy a preacher of the Ecclesiarchy. Once per mission, your Patron can put a Ministorum Priest under the party''s command for a day.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Summon Sermoniser');

INSERT INTO patron_boon (name, description) SELECT 'Tentative Alliance', 'Your Patron is a political mastermind, adroit at forming short treaties with other Factions. Before each mission, you can choose a Faction you are aware of. Your Patron has +1 Influence with that Faction until the end of the mission.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Tentative Alliance');

INSERT INTO patron_boon (name, description) SELECT 'Tithe Inspection', 'Your Patron is capable of arranging perfectly legal inspections of people and places to ensure that the Emperor''s Tithe will be fulfilled. Once during each mission, you can request that your Patron have their Faction make an inspection of a place or person, which your group may be allowed to accompany.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Tithe Inspection');

INSERT INTO patron_boon (name, description) SELECT 'Vigilite Vanguard', 'Your Patron can exert their power to deploy a partnership of local law-enforcing Macharian Vigilites. Once per mission, your Patron can have two Vigilites accompany the party for a day, instructed to aid the party whilst upholding and enforcing Lex Imperialis.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Vigilite Vanguard');

INSERT INTO patron_boon (name, description) SELECT 'Voidship', 'Your Patron gives you access to a voidship, part of which you can use as a base of operations. Whilst aboard the voidship, you have free accommodation and meals at a minimum of Standard Quality, and have free System and Interplanetary (Warp) travel.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Voidship');

INSERT INTO patron_boon (name, description) SELECT 'Voidsman Training Facility', 'Imperial Fleet: +1 Patron Influence. Your Patron grants you the use of an Imperial Fleet training facility. Whilst at this facility, the XP cost of the following Specialisations is reduced by 20: Awareness (Sight), Discipline (Fear), Intuition (Surroundings), Navigation (All), Piloting (All), Ranged (Long Guns) & (Pistols), Reflexes (Balance) & (Dodge).' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Voidsman Training Facility');

INSERT INTO patron_boon (name, description) SELECT 'Voidport Peerage', 'Imperial Fleet: +1 Patron Influence. Your Patron is the ultimate authority of one or more voidports. You can request: access to shipping manifests and docking reports; an official inspection of a voidship and/or its cargo; a temporary full lockdown of the voidport; or secure transport to and from the voidport for 50% of the normal cost.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Voidport Peerage');

INSERT INTO patron_boon (name, description) SELECT 'Weapon Specialist', 'Your Patron believes that the special weaponry of the Imperium is a blessing from the Emperor. Your Patron can always find someone willing to sell you a Launcher, Melta, or Plasma weapon, and may secure you a 10% discount.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Weapon Specialist');

INSERT INTO patron_boon (name, description) SELECT 'Witch Hunt', 'Your Patron has the power to agitate a hunt for one or more individuals suspected of being psykers. Once per mission, your Patron can instigate a witch hunt involving crowds of press-ganged Imperial Citizens and Devout overseen by local law enforcement.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Witch Hunt');

INSERT INTO patron_boon (name, description) SELECT 'Xenotechnician', 'Your Patron has an interest in proscribed xenos technology, and the power to keep these forbidden curiosities without being executed. Your Patron has no issue with your group looting and using xenos weaponry and other technology, and will reward you for bringing these outlawed items to their private collection.' WHERE NOT EXISTS (SELECT 1 FROM patron_boon WHERE name = 'Xenotechnician');

-- ── Liabilities ──────────────────────────────────────────────────────────────
-- Faction junction data (patron_liability_factions) to be seeded separately once boon/liability tables are filled.

INSERT INTO patron_liability (name, description) SELECT 'Abrupt',
'Any three Factions: −1 Patron Influence. Your Patron is brusque and abrasive in their dealings with other Factions. Your Patron has −1 Influence with three Factions as a consequence of this behaviour.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Abrupt');

INSERT INTO patron_liability (name, description) SELECT 'Argumentative',
'Your Patron is politically active amongst multiple Imperial Factions, but constantly quarrels with them. At the start of each mission, the Patron gains −1 Influence with a Faction determined by the Gamemaster. By the end of each mission the Patron has repaired the relationship, but has likely ruined another.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Argumentative');

INSERT INTO patron_liability (name, description) SELECT 'Be Ever Vigilant',
'Your Patron believes in keeping you on your toes. They may arrange for ambushes, combat drills, examinations, or other surprise challenges to ensure you are the best of the best.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Be Ever Vigilant');

INSERT INTO patron_liability (name, description) SELECT 'Blackmailed',
'Your Patron is being blackmailed. They may request you take on additional tasks for the blackmailer, or have less supplies or solars to give you. Your Patron may task you with retrieving whatever sensitive material the blackmailer has — or simply making sure the blackmailer disappears. Your Patron has −2 Influence with the Faction blackmailing them.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Blackmailed');

INSERT INTO patron_liability (name, description) SELECT 'Boastful',
'Your Patron makes no secret of their successes and future goals, or their satisfaction with your performance. They tell allies within and without their own organisation of your deeds, and may take the step of reaching out to local authorities to facilitate cooperation. All this tends to draw plenty of unwanted attention at all stages of a mission. As word spreads and information leaks, your enemies might be expecting you well before you arrive.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Boastful');

INSERT INTO patron_liability (name, description) SELECT 'Convoluted Communiqae',
'Your Patron insists on using only coded communications, with ciphers that change regularly and may obscure the message they are trying to convey.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Convoluted Communiqae');

INSERT INTO patron_liability (name, description) SELECT 'Corrupt',
'Your Patron secretly serves some other force than the God-Emperor. This may be as simple as succumbing to their own self-interest, exercising a criminal greed, or may be as villainous as falling to the predations of one of the Ruinous Powers.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Corrupt');

INSERT INTO patron_liability (name, description) SELECT 'Craven',
'Astra Militarum: −2 Patron Influence. Your Patron has a history of shameful cowardice, and will never expose themself to potential danger.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Craven');

INSERT INTO patron_liability (name, description) SELECT 'Dangerous Debt',
'Your Patron owes someone a dangerous debt, and may require you to perform some service for them to ensure they do not disappear under unfortunate circumstances. Until the debt is paid, your Patron has −2 Influence with the creditor''s Faction.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Dangerous Debt');

INSERT INTO patron_liability (name, description) SELECT 'Data Addict',
'Your Patron suffers from a strange condition known as data addiction, an unnatural craving for knowledge that some quietly speculate is the result of neural augmetics. Your Patron will make overwhelming requests for specific informative minutiae, often only tangentially related to your mission. Refusing or failing to produce the data your Patron craves will negatively impact their opinion of your character and capability, and may lead to docked pay.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Data Addict');

INSERT INTO patron_liability (name, description) SELECT 'Dealbreaker',
'Your Patron failed terribly to complete an important trade with another Faction. Their reputation as a trader with one Faction is irreparably stained. This may make securing certain items more difficult at the Gamemaster''s discretion. Your Patron has −2 Influence with the Faction their failed trade deal involves.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Dealbreaker');

INSERT INTO patron_liability (name, description) SELECT 'Demands Discretion',
'Your Patron insists on keeping their involvement in your missions private, allowing you to use the sway of their name only when absolutely necessary. Your Patron may inflict punishment, or even disappear a character entirely, should they ignore this edict. In certain areas of the Imperium such secrecy can be akin to a damning admission of guilt.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Demands Discretion');

INSERT INTO patron_liability (name, description) SELECT 'Dogmatic',
'Your Patron has neither tolerance nor patience for any deviation from the Imperial Creed. Even the slightest expression of blasphemy against the God-Emperor or His Ecclesiarchy will be punished, typically with docked pay or electro-flagellation.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Dogmatic');

INSERT INTO patron_liability (name, description) SELECT 'Draconian',
'Infractionists: −2 Patron Influence. Your Patron has a history of harsh treatment of lawbreakers, and will not tolerate the slightest infraction against the Lex Imperialis, under penalty of docked pay, excruciation, or worse. They will also expect you to follow a stringent operating procedure during each mission, potentially including informing local authorities of your presence and activities.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Draconian');

INSERT INTO patron_liability (name, description) SELECT 'Enemy',
'Enemy''s Faction: −2 Patron Influence. Your Patron has made an enemy of another high-ranking member of a Faction. The rival may interfere with your missions, hire their own agents to accomplish the same goals before you can, or even try to bribe or coerce you into their employment.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Enemy');

INSERT INTO patron_liability (name, description) SELECT 'Excommunicated',
'Your Patron has been accused of crimes against the Imperium or even declared Excommunicate Traitoris by the Inquisition. You must be very careful as to when, where, and with whom you invoke your Patron''s name or authority. Your Patron has −3 Influence with the Adeptus Astra Telepathica, the Adeptus Mechanicus, the Adeptus Administratum, the Astra Militarum, the Adeptus Ministorum, the Inquisition, and the Imperial Fleet.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Excommunicated');

INSERT INTO patron_liability (name, description) SELECT 'Frail Form',
'Your Patron clings desperately to the mortal coil though they are physically weak and ailing. Your Patron may be dependent on rejuvenat treatments or some other mysterious medicine. Your Patron will require frequent requisitions of whatever chemical they need to continue their existence, and even when fully stocked may be unavailable to you at a crucial moment due to their frailty.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Frail Form');

INSERT INTO patron_liability (name, description) SELECT 'Hallowed Ignorance',
'Your Patron believes that ignorance is a virtue, particularly for their underlings. Your Patron will not share any details they believe to be unnecessary for you to complete your mission, and may work to actively suppress your attempts to gather information.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Hallowed Ignorance');

INSERT INTO patron_liability (name, description) SELECT 'Honour the Machine Spirits',
'Your Patron expects you to maintain your equipment to an exacting standard. Your Patron will inspect your equipment after each mission and will dock your pay if it is not up to their specifications.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Honour the Machine Spirits');

INSERT INTO patron_liability (name, description) SELECT 'Impostor',
'Your Patron is not who they say they are, but they can seemingly impersonate them quite well. Your Patron may be unable to get you any supplies or resources they are supposed to, but their Influence still works… for now.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Impostor');

INSERT INTO patron_liability (name, description) SELECT 'Incessant Updates',
'Your Patron is a micromanager, requiring frequent updates through vox or writing. Their constant requests may take up time or expose both your plans and position.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Incessant Updates');

INSERT INTO patron_liability (name, description) SELECT 'Known Meddler',
'Your Patron has a reputation for interfering in the affairs of other Factions. Whenever you attempt to use your Patron''s Influence, the party''s next Fellowship Test is made at Disadvantage. Additionally, your Patron''s past meddlings have earned them −1 Influence with two Factions, chosen by the Gamemaster.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Known Meddler');

INSERT INTO patron_liability (name, description) SELECT 'Loose Cannon',
'Adeptus Administratum: −2 Patron Influence. Your Patron is known for flaunting the conventions of the Imperium and Lex Imperialis to get things done — always in the Emperor''s name, of course, and with undeniable results. Your Patron will expect you to bend and break the rules to see their will done.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Loose Cannon');

INSERT INTO patron_liability (name, description) SELECT 'Meticulous Archivist',
'Your Patron is a stickler for records. At the end of every mission, your Patron expects a full report of your activities, including what you did, when, and why. If you do not supply these records, your Patron may dock your pay.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Meticulous Archivist');

INSERT INTO patron_liability (name, description) SELECT 'Miserly',
'Your Patron either has few resources, or does not want to give them to you. Decrease your Patron''s Payment Grade by 1 step.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Miserly');

INSERT INTO patron_liability (name, description) SELECT 'Missionary Mandate',
'Your Patron demands that you disseminate the word of the God-Emperor wherever they send you, playing a vital role in protecting the masses by ensuring their piety. Your Patron will assess your success at this ongoing goal whenever they meet with you, and may punish or reward you according to their judgement of your efforts.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Missionary Mandate');

INSERT INTO patron_liability (name, description) SELECT 'Nemesis',
'Your Patron has an arch-enemy beyond the Factions of the Imperium, a traitorous heretic, horrific daemon, or vile xenos that wants them dead. This enmity will likely spill over onto the party, interrupting both missions and the time between them as they assail both the Patron and their sworn followers.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Nemesis');

INSERT INTO patron_liability (name, description) SELECT 'Obsolete Observer',
'Your Patron wants to know exactly how you operate, and has entrusted a Servo-Skull or Servitor to acquire that information. Your Patron deploys either a Servo-Skull or Servitor equipped with only a Pict Recorder to document your exploits. These obsolete observers will occasionally hinder progress in missions by getting in the way, making noise, or otherwise bumbling around.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Obsolete Observer');

INSERT INTO patron_liability (name, description) SELECT 'Offended the Omnissiah',
'Adeptus Mechanicus: −2 Patron Influence. Your Patron has angered the Tech-Priests of the Adeptus Mechanicus, and whether intentional or otherwise, has earned their enmity. Whatever your Patron did has been recorded in the vast data-vaults of the nearest forge world, and is unlikely to be forgotten within the next ten millennia. This may mean that your Patron is simply unable to furnish you with any newer equipment, relying only on items of Common Availability from other suppliers or Shoddy equivalents.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Offended the Omnissiah');

INSERT INTO patron_liability (name, description) SELECT 'Omnissian Principles',
'Your Patron is a devout worshipper of the Machine God, and expects you to uphold the sanctified strictures of the Cult Mechanicus. You will be required to appease any machine spirit you encounter; any damage or destruction of the Omnissiah''s sacred technology is a punishable waste that must be corrected through docked pay.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Omnissian Principles');

INSERT INTO patron_liability (name, description) SELECT 'Overextended',
'Your Patron is constantly occupied with numerous plots, missions, and assignments. Despite the importance of your own missions, they seldom make themself available to you. Attempts to get more information, equipment, or money from your Patron during a mission are near impossible.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Overextended');

INSERT INTO patron_liability (name, description) SELECT 'Paranoid',
'Your Patron trusts no one — including you. They doubt your loyalty and might show it by questioning your reports, spying on you, or even dispatching you on missions that mean certain death.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Paranoid');

INSERT INTO patron_liability (name, description) SELECT 'Pious Stipulations',
'Your Patron demands displays of faith from their agents. This may take the form of daily prayer sessions, attending specific religious services, or performing rituals of faith. These stipulations may interfere with your missions, and cut into any time between them.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Pious Stipulations');

INSERT INTO patron_liability (name, description) SELECT 'Price of Life',
'Your Patron holds the unorthodox belief that every Human life is precious, and only the Emperor can decide when one should die without justification. Your Patron will demand that you justify every life you take, and dock your pay for every unnecessary killing.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Price of Life');

INSERT INTO patron_liability (name, description) SELECT 'Psyker Slayer',
'Adeptus Astra Telepathica: −2 Patron Influence. Your Patron has succumbed to a semi-heretical superstition that all unsanctioned psykers must be slain, rather than captured. If your Patron gains any information that would suggest there is an unsanctioned psyker in the vicinity of your mission, they will demand you bring them their head.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Psyker Slayer');

INSERT INTO patron_liability (name, description) SELECT 'Required Recruitment',
'Your Patron understands the value of boots on the ground and an army of bodies to drown the enemy in. On each of your missions, your Patron will request that you recruit a number of new individuals to their cause, and will dock your pay if this responsibility is not fulfilled.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Required Recruitment');

INSERT INTO patron_liability (name, description) SELECT 'Revisionist',
'Your Patron believes that those who control history control the future. They will doctor reports, distort the truth, and effectively live their own version of reality that they expect you to keep in tune with.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Revisionist');

INSERT INTO patron_liability (name, description) SELECT 'Rumoured Dead',
'Tales of your Patron''s grisly demise abound. Whenever you attempt to use your Patron''s Influence, the Gamemaster may rule that you must make a Rapport (Charm) Test of variable difficulty to convince the target that your Patron is, indeed, alive.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Rumoured Dead');

INSERT INTO patron_liability (name, description) SELECT 'Saboteur',
'Your Patron''s enmity with rival Factions has grown so extreme that they will task you with undermining their adversary''s efforts. The GM chooses two Factions that the Patron has come to loathe. If you are likely to deal with either of these during your mission, your Patron will order you to sabotage them in some non-lethal way. Your Patron''s past attempts at sabotage have already earned them −1 Influence with both of these Factions.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Saboteur');

INSERT INTO patron_liability (name, description) SELECT 'Shaky Authority',
'Your Patron''s sway over others is constantly questioned. Whenever you attempt to use your Patron''s Influence, roll a d10. If the result is 0, your Patron''s positive Influence is ignored.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Shaky Authority');

INSERT INTO patron_liability (name, description) SELECT 'Shoddy Supplies',
'Your Patron relies on scavengers and shady back-channels to arm and armour their agents at a lower cost. All of the equipment supplied by your Patron has the Shoddy Flaw.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Shoddy Supplies');

INSERT INTO patron_liability (name, description) SELECT 'Sidereal Quests',
'On every world and in each city you visit, your Patron owes someone a favour and offers up your group to repay it. These odd jobs might include bodyguard duties, vital negotiations, simple courier jobs, and nearly anything else. Completing these tasks might take valuable time away from your primary mission, but shirking them might earn a new enemy as well as the ire of your Patron.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Sidereal Quests');

INSERT INTO patron_liability (name, description) SELECT 'Strange Tastes',
'Your Patron has a desire for something, and requires your help to get it clandestinely, without asking questions. The Gamemaster determines exactly what your Patron craves, but it is doubtless reasonably rare, and likely not condoned by the Lex Imperialis.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Strange Tastes');

INSERT INTO patron_liability (name, description) SELECT 'Suspect',
'Your Patron is distrusted by one or more Factions that have circumstantially linked them to crime or heresy. If you reveal your affiliation with your Patron, these Factions may follow you, surveil you, and potentially even interfere with your mission in an attempt to gather evidence. Your Patron has −2 Influence with a Faction that suspects them, typically the Inquisition.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Suspect');

INSERT INTO patron_liability (name, description) SELECT 'Territorial',
'Your Patron believes in the fundamental powers of land and property. Your Patron will ask you to secure territory and set up bases of operations whenever possible. Though this may be useful when returning to a location, it will undoubtedly take up time during, and potentially between, missions.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Territorial');

INSERT INTO patron_liability (name, description) SELECT 'Tithe Obsessed',
'Your Patron understands that the Imperium operates on a knife''s edge, and will not tolerate wanton destruction of potential resources. Your Patron will dock your pay for any kind of collateral damage you cannot justify.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Tithe Obsessed');

INSERT INTO patron_liability (name, description) SELECT 'Unorthodox Beliefs',
'Your Patron has a lamentable reputation for flaunting their somewhat unorthodox beliefs, be they part of a mildly divergent Death Cult or closer to outright heresy. Your Patron may ask you to indulge them in their beliefs, joining them in rituals that may reduce your time between missions. Your Patron''s Unorthodox Beliefs have earned them −2 Influence with the Adeptus Ministorum.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Unorthodox Beliefs');

INSERT INTO patron_liability (name, description) SELECT 'Warped Visions',
'Your Patron is an unwilling voyeur of warp-spawned nightmares, or perhaps they experience divine, Emperor-sent foresight afforded only to the most faithful. In either case, the visions your Patron receives send you on wild goose chases. They will give you clues and objectives connected only to their spectral hallucinations, confusing your efforts to fulfil their will.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Warped Visions');

INSERT INTO patron_liability (name, description) SELECT 'Witch Hunter',
'Your Patron requires you to be ever-vigilant of sorcery, and demands you aid in capturing psykers to fulfil the Tithes of the Black Ships. If your Patron gains any information that would suggest there is a psyker in the vicinity of your mission who has not been corrupted by the Ruinous Powers, they will demand you capture them. If there is a Rogue Psyker, they will demand you bring them their head.'
WHERE NOT EXISTS (SELECT 1 FROM patron_liability WHERE name = 'Witch Hunter');
