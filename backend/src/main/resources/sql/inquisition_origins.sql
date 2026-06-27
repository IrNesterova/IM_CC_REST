-- =====================================================================
-- IMPERIUM MALEDICTUM — INQUISITION MACHARIAN ORIGINS
-- Source: IM Inquisition Player's Guide
-- Run AFTER: Hibernate startup (creates origin_category, origin_talent,
--            origin_inventory_item, origin_inventory_modifier tables),
--            inventory.sql, roles_data.sql, inquisition_roles_data.sql
-- =====================================================================

-- =====================================================================
-- 1. MISSING TALENTS
-- =====================================================================
INSERT INTO talent (name, description)
SELECT v.name, v.description FROM (VALUES
    ('BLANK',                ''),
    ('HYPNO-INDOCTRINATION', '')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE t.name = v.name);

-- =====================================================================
-- 2. MISSING INVENTORY ITEMS
-- =====================================================================
INSERT INTO inventory (name, inventory_category, inventory_subcategory)
SELECT v.name, v.category, NULL FROM (VALUES
    ('Cultist Robes', 'CLOTHING_AND_PERSONAL_GEAR'),
    ('Clothing',      'CLOTHING_AND_PERSONAL_GEAR'),
    ('Combat Gland',  'TOOLS')
) AS v(name, category)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);

INSERT INTO generic_item (id, description)
SELECT i.id, NULL FROM inventory i
WHERE i.name IN ('Cultist Robes', 'Clothing', 'Combat Gland')
ON CONFLICT (id) DO NOTHING;

-- =====================================================================
-- 3. SHODDY ITEM MODIFIER
-- =====================================================================
INSERT INTO item_modifier (name, type, description)
SELECT 'Shoddy', 'flaw', 'Shoddy items impose a -10 penalty on Tests directly involving that item.'
WHERE NOT EXISTS (SELECT 1 FROM item_modifier WHERE name = 'Shoddy');

-- =====================================================================
-- 4. ORIGIN CATEGORIES (verbatim from book)
-- =====================================================================
DO $$
BEGIN

INSERT INTO origin_category (name, description, source_book) VALUES
('DAMNED USEFUL',
 'To be damned is commonplace in the grim darkness of the Macharian Sector — to be simultaneously useful, much less so. By either luck or fate, the crux of your suffering makes you a valuable tool for the Inquisition''s needs. The circumstances of your birth or later experiences might cause respectable society to shun you or mean you are an earnest danger to anyone unfortunate enough to get close to you. Nevertheless, your misfortune comes with some unique capability that the Inquisition deems worthy of tolerating your less savoury traits to access.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('DEATH WORLD VETERAN',
 'You have survived many tours of duty as a member of a Penal Legion, Astra Militarum regiment, or even a Planetary Governor''s private militia. Your experiences in the antagonistic depths of Death Worlds, too grim to support long-term Human settlement, have been a cruel teacher, hardening you in ways that attract the attention of the Inquisition and provide valuable combat experience when their investigations stray far from the relative safety of well-populated worlds. Feral Worlds like Omyr (Imperium Maledictum, page 278) or Hrom (Imperium Maledictum, page 288) can offer the same trials by blood, xenos, and Chaos that could forge you into a veteran warrior worthy of an Inquisitor''s time.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('HEXORCIST',
 'There have always been worlds mired deeper in the clutches of heresy and the lure of the void than others. You were born on such a world; a place that languishes half-forgotten or purposefully ignored, beset relentlessly by heretics and the vile forces they invite to your very doorstep. With the Imperium so far from reach and slow to respond, your survival rested on taking matters into your own hands. But no cult infested stronghold can escape the Inquisition''s notice forever, and your experience combatting the daemonic influences has drawn their scrutiny.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('INFORMANT',
 'You grew up in one of the countless organisations established throughout the civilised space of the sector, from the bustling trade of Rogue Trader Dynasties and ambitious noble houses to the endless, careful work of adept artisans. Over time, though, you began to notice things amiss. Corruption seeps easily through any weakness of character or leadership, and its touch is bolder than ever since the Noctis Aeterna upended all order. While you initially may have thought it was a simple error, the truth of your organisation''s corruption soon became clear. Whether gnawing fear or a pious heart motivated you, you dedicated significant time to seeking the Inquisition''s attention for these ongoing crimes. When you finally gained it, they directed you to continue as if nothing was amiss and to feed them evidence that would damn your heretical peers.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('NOMAD',
 'The uncharted and lawless corners of the Macharian system breed an entirely different kind of survivor. You are a nomad, flitting from haven to haven as the need frequently arises. To put down roots is to make yourself vulnerable to attack. Only by remaining on the move, ever vigilant, can you hope to keep yourself alive. You likely hail from Feral Worlds and pockets of dark, violent space, such as the wilds of Yix beyond Terminus Iaysus (Imperium Maledictum, page 286) or the labyrinthine warrens of Arrian''s Wrath (Imperium Maledictum, page 293) or the Iron Archipelago (Imperium Maledictum, page 289).',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('PENITENT',
 'You managed to fall in with a troublesome crowd and get tangled up in numerous minor heresies... before an Inquisitorial agent caught up with you. However, for all that the Inquisition can be harsh, you were surprised at the Inquisitor''s shred of mercy. You were offered the opportunity to repent and absolve your crimes against the God-Emperor by continuing to roam the dirty underbelly in service to the Inquisition, feeding them information and performing as commanded.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('STRANGE ANOMALY',
 'Throughout the breadth of the galaxy, even the rarest and strangest twists of fate and circumstance can manifest with surprising regularity. You are one such strange anomaly. This could describe many quirks in biology, ability, augmentation, or experience that even a well-travelled Inquisitor would be surprised by. As a result of your odd traits, you find yourself in the position of being incredibly useful to the Inquisition''s needs. Perhaps you are needed for a surgically-specific role in an ongoing investigation, or maybe they see a variety of situations where you might be put to use.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('TABULA RASA',
 'You are a blank slate, your memories purposefully wiped or somehow lost — or maybe you never had any, to begin with. Your body bears scars and marks in a visible history you cannot read. Whatever the truth is, you remain utterly unaware. The Inquisition has many uses for a tool unfettered by external influences or loyalties, and thus susceptible to their indoctrination, and will utilise your skills accordingly.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('VENGEFUL RELIC',
 'Captured and held by any of the vicious enemies of the Imperium, you experienced unimaginable fear with no hope of escape. You managed to stay strong where others buckled, submitting to indoctrination or death. Eventually, a moment offered itself to your quick-thinking liberation, or you were retrieved unceremoniously as unintended collateral in an Inquisition mission. Your body still bears the ravages your captivity wrought – perhaps even to the extent of amputation that impacts your day-to-day life (Imperium Maledictum, page 217). You were hardened by what you experienced, and above all else, you have sworn vengeance against those who broke you.',
 'IN')
ON CONFLICT DO NOTHING;

INSERT INTO origin_category (name, description, source_book) VALUES
('XENOS-DIALOGUS',
 'Very few citizens of the Macharian Sector have more than passing knowledge of the xenos forces that so often threaten to disrupt their worlds and livelihoods, and even fewer can boast an intimate understanding of xenos languages, cultures, and motives. You have the rare experience of regularly dealing with xenos artefacts, communiques, and even xenos themselves; working to understand their languages and the unwritten expectations of their social and political interactions is a part of your regular life. This dangerously heretical work leaves you vulnerable to corruption, but it also means you offer the Inquisition a useful (and expendable) tool for investigating xenos driven heresies and corruption.',
 'IN')
ON CONFLICT DO NOTHING;

END $$;

-- =====================================================================
-- 5. SUB-ORIGINS (verbatim from book)
-- =====================================================================
DO $$
DECLARE v_cat_id BIGINT;
BEGIN

-- DAMNED USEFUL
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'DAMNED USEFUL';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('DAEMONIC HOST',
 'You experienced the grave misfortune of being used as a Daemonhost by a chaos cult. While you survived this gruelling ordeal via chance or Inquisitorial exorcism, you will never again be the same. You are riddled with mental and physical scars, the experience of hosting a daemonic force tore ragged holes into your soul. Properly exorcised, that daemon will never trouble you again. But you are no more or less vulnerable to other daemons, and the Inquisition considers your experiences valuable in their plans.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('NULL PERSONA',
 'You are a Human afflicted with the Pariah Gene — by an unlucky twist of fate you have been rendered soulless, with no psychic presence or connection to the Immaterium. This is an incredible boon for the Inquisition''s purposes, as you are invisible to the daemonic forces of the Warp and sever all connection between realspace and the Immaterium within your vicinity. These qualities make you prized by the Ordo Malleus but also make you intolerable to normal Humans and anathema to any psyker.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- DEATH WORLD VETERAN
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'DEATH WORLD VETERAN';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('GLAND WARRIOR',
 'Genetically modified by the Adeptus Mechanicus to better survive harsh planetary conditions and particularly vicious xenos threats, your augmentations make you a powerful combatant on the most inhospitable Macharian worlds — including the Feral World of Illisear (Imperium Maledictum, pages 273), where unknown creatures decimate Imperium forces and heretical thought runs deep amongst the local population. Many of these veterans suffer from ongoing psychosis; they may hunger for battle, or remain haunted by the threats they have encountered and survived.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('SOLE SURVIVOR',
 'Your entire regiment was destroyed by the churning maw of xenos or daemonic forces while deployed to a Death World, and you alone lived to complete your mission. You know it was damned luck that saw you win the pitched struggle for survival, but the skill and grit others saw in your victory led inevitably to promotion. Now, the Inquisition has recruited you as an asset in their most dangerous investigations, perhaps returning to the sort of worlds that forged your legacy, such as Eythlaer (Imperium Maledictum, page 286).',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- HEXORCIST
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'HEXORCIST';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('BANISHER',
 'Amidst the lurking daemonic shadows and relentless cults coaxing foulness into realspace on your homeworld, reaching adulthood was never guaranteed. More than one of your childhood playmates disappeared with little trace, or worse, returned speaking heresies and trailing dark entities in their wake. You have prevailed into maturity with your life and piety intact despite numerous encounters with daemonic creatures and their cultists, garnering knowledge and abilities uncommon amongst most low-class Humans.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('APOSTATE OF THE CREED',
 'As a former initiate of the Adeptus Ministorum, you tended the communities of your home world, conscientiously shepherding countless souls for the glory of the Emperor. This careful attention to your duties first alerted you to increasingly borderline heretical behaviour and a growing sense of shrouded corruption. But your brothers and sisters in the faith failed to see what dangers lurked in the darkness. You had no choice but to shed your vestments and strike out against the Emperor''s enemies alone. Gain: Two Specialisation advances in Forbidden (Various) or Theology (Restricted).',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- INFORMANT
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'INFORMANT';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('MANUFACTORUM OVERSEER',
 'As an overseer, you have a degree of power and responsibility that can weigh upon your shoulders. When quotas aren''t met, or defects occur, it falls squarely at your feet. It''s no surprise that you began seeking Inquisition intervention when you realised the reallocated materials and unsanctioned alterations bore the chaotic hallmarks of a Heretek.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('MERCHANT HOUSE SERVANT',
 'Servants in the employ of the various wealthy, noble families who hold so much power over trade and supply within the system are uniquely positioned to uncover lingering corruption and active heresy. Your daily tasks place you directly in the path of various mercantile machinations, be it through indiscreet conversations or suspect recordkeeping. Perhaps you served House Klaskoloff or another merchant house (Imperium Maledictum, page 255), have seen unspeakable xenos artefacts pass through their halls, or have heard increasingly unclean theology murmured in your master''s parlour.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- NOMAD
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'NOMAD';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('ILLISEAREAN FENSTALKER',
 'Fragmented whispers of the danger that lurks on Illisear (Imperium Maledictum, pages 273) sometimes reach the inner worlds. As a member of an Ilisearean tribe, you''ve survived with this ever-present shadow your entire life. You have learned of the Fiends of the Deep Night since the cradle and know the wards and rituals passed down from the Emperor to protect your people. Gain: One advance in the Lore (Forbidden) Skill Specialisation related to Illisear''s daemonic presence.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('IRON ARCHIPELAGO PIRATE',
 'You''ve spent much of your life in the unmappable and bizarre depths of the Iron Archipelago''s (Imperium Maledictum, pages 289) various void habs, and the cobbled-together culture and language of this ramshackle hulk is your native tongue and tender. You consider unexpected dangers and odd heresies a normal occurrence, but such things are rarely found in the same subsection twice. Gain: One advance in the Lore (Forbidden) Skill Specialisation related to one of the Iron Archipelago''s Xenos factions (e.g., Kroot, Aeldari).',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- PENITENT
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'PENITENT';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('CULT INFILTRATOR',
 'The dense populations throughout the Macharian Sector are a fertile breeding ground for cults of all kinds — and therein, you have the opportunity to atone for your wrongdoings. You have been tasked with worming deeper into a cult''s inner workings to report any relevant findings. The ongoing Inquisition investigations surrounding the agri world of Goros Pok (Imperium Maledictum, pages 286–287), home to several large cults, are one such place your penitence could be served.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('GANG INFILTRATOR',
 'Gangs thrived in the dark days of the Noctis Aeterna, finding new dirty methods to consolidate their wealth and networks amidst the confusion. The Silent Trade in xenos artefacts glutted itself while those who might have otherwise stood in its way were struggling with the consequences of The Blackness. Your penitence takes the form of infiltrating the webbed networks of these gangs and delivering information on their operations. Persepolis is a Hive World of continuing Inquisitorial focus for the concerning lack of religious zeal amongst its populace that allows gangs to conduct their more heretical business unharried. Gain: One advance in the Lore (Forbidden) Skill Specialisation related to one of the Iron Archipelago''s Xenos factions.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- STRANGE ANOMALY
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'STRANGE ANOMALY';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('MUTANT',
 'Whether by birth or interference, there is no doubt that you are a mutant. More often than not, this would make you an enemy of the Inquisition. You are fortunate enough that your abnormality provides utility better for hunting enemies of the Inquisition than being wasted by your extermination. You could be some strain of abhuman, a product of Warp phenomena, or the result of some Genetor sect''s ongoing experiments and manipulation.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('UNUSUAL AUGMENT',
 'You have some kind of highly unorthodox bionic that offers a particular benefit to the Inquisition. It may allow an advantage in combat with xenos or daemonic forces, or perhaps it increases your ability to seek out or identify the crawling taint of corruption at its roots. Such an item would not have come from any legitimate source — perhaps you were experimented on by or defected from a heretical group such as the Vasari (Imperium Maledictum, page 259), who conduct extensive hidden augmentations, or hail from a world like Somrot (Imperium Maledictum, pages 283–284) with the Enumerator''s willingness to spread suspect augmentation practices. Gain: Any Augmetic of your choice with either the Bulky or Ugly Trait (work with GM to decide the origins of this device).',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- TABULA RASA
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'TABULA RASA';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('SCRAPED SLATE',
 'You have experienced horrors beyond comprehension that needed to be sealed away at the cost of any memory of your past. Whether this trauma resulted from your own deeds, those of fellow Humans, or foul xenos forces is now irrelevant — the Inquisition has a use for you, so you will not be thrown away. Note: You receive no Influence from Character Creation.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('VAT GROWN',
 'You were grown from zygote to full maturity to be a perfectly malleable slab of flesh in service to the Inquisition. Where others would have a past, you have nothing but a yawning void that echoes with the Inquisition''s doctrines. Note: You receive no Influence from Character Creation.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- VENGEFUL RELIC
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'VENGEFUL RELIC';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('CULT CAPTIVE',
 'You fell awry of one of the many cults littered throughout the system. Some are relatively well-documented (Imperium Maledictum, page 259), while others continue to elude understanding as they go about their heretical business (such as the cults of Goros Pok, Imperium Maledictum, page 286). Whatever their particular beliefs or motives, they kept you as an unwilling guest — perhaps attempting to indoctrinate you or awaiting the ideal confluence of Chaotic energies to offer you up as tribute for their daemonic masters.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('XENOS CAPTIVE',
 'For all that the average Human so rarely encounters them, numerous xenos groups share the shadows of the Macharian System. By either misadventure or pure bad luck, you found yourself held captive by one of these groups and suffered all manner of atrocities. Perhaps you had business on Xenophon and were captured and offered as tribute to the secretive, vicious Drukhari who take a tithe from the planet''s population (Imperium Maledictum, pages 306–307) or were taken by a band of Orks or Kroot who boarded your unlucky vessel.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

-- XENOS-DIALOGUS
SELECT id INTO v_cat_id FROM origin_category WHERE name = 'XENOS-DIALOGUS';

INSERT INTO origin (name, description, source_book, category_id) VALUES
('AIDE TO ORDERS DIALOGUS',
 'The Orders Dialogus of the Adepta Ministorum are home to some of the most learned and respected scholars in the Imperium. You have learned well of your mentor''s work and are extensively versed in their xenos linguistic speciality. While it is rare to see a Sister removed from their datastacks to provide active support in the field, there are no such compunctions with plucking you from your duties to apply your mentor''s work in isolated, unknown, or overtly dangerous locales. Gain: One advance in the Linguistics (Forbidden) Skill Specialisation based on the xenos species you are familiar with.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

INSERT INTO origin (name, description, source_book, category_id) VALUES
('ROGUE TRADER RETINUE',
 'Your ambitions led to spending several years in the service of a Rogue Trader House, aiding their mercantile operations with nearby xenos groups with enough regularity that you became familiar with their speech and customs. Arrian''s Wrath (Imperium Maledictum, page 293) is rich with such opportunities, at a heavy price. The presence of Inquisition agents'' unforgiving eyes draw you inexorably into the Inquisition''s service. Gain: One advance in the Linguistics (Forbidden) Skill Specialisation based on the xenos species you are familiar with.',
 'IN', v_cat_id)
ON CONFLICT DO NOTHING;

END $$;

-- =====================================================================
-- 6. CHARACTERISTICS
-- IDs: 1=WS, 2=BS, 3=STR, 4=TGH, 5=AG, 6=INT, 7=PER, 8=WIL, 9=FEL
-- =====================================================================

-- GLAND WARRIOR: +5 TGH (fixed)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, 4, true FROM origin o WHERE o.name = 'GLAND WARRIOR'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = 4);

-- SOLE SURVIVOR: +5 STR (fixed) + choose one of TGH/AG/WIL
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, v.is_primary FROM origin o
CROSS JOIN (VALUES (3, true), (4, false), (5, false), (8, false)) AS v(char_id, is_primary)
WHERE o.name = 'SOLE SURVIVOR'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- BANISHER: +5 WIL (fixed) + choose one of WIL/WS/BS (Discipline/Melee/Ranged)
-- WIL appears in both primary and secondary — NOT EXISTS checks primary_char too
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, v.is_primary FROM origin o
CROSS JOIN (VALUES (8, true), (8, false), (1, false), (2, false)) AS v(char_id, is_primary)
WHERE o.name = 'BANISHER'
AND NOT EXISTS (
    SELECT 1 FROM character_origin co
    WHERE co.origin_id = o.id AND co.character_id = v.char_id AND co.primary_char = v.is_primary
);

-- MANUFACTORUM OVERSEER: +5 PER (fixed) + choose one of INT/FEL/WIL
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, v.is_primary FROM origin o
CROSS JOIN (VALUES (7, true), (6, false), (9, false), (8, false)) AS v(char_id, is_primary)
WHERE o.name = 'MANUFACTORUM OVERSEER'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- ILLISEAREAN FENSTALKER: choose one of WS/STR/PER (no fixed primary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, false FROM origin o
CROSS JOIN (VALUES (1), (3), (7)) AS v(char_id)
WHERE o.name = 'ILLISEAREAN FENSTALKER'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- CULT INFILTRATOR: +5 FEL (fixed) AND +5 AG (fixed — Stealth is AG-linked)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, v.is_primary FROM origin o
CROSS JOIN (VALUES (9, true), (5, false)) AS v(char_id, is_primary)
WHERE o.name = 'CULT INFILTRATOR'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- GANG INFILTRATOR: choose one of WS/STR/PER (no fixed primary)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, false FROM origin o
CROSS JOIN (VALUES (1), (3), (7)) AS v(char_id)
WHERE o.name = 'GANG INFILTRATOR'
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- SCRAPED SLATE + VAT GROWN: +5 to any characteristic (player chooses)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, v.char_id, false FROM origin o
CROSS JOIN (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v(char_id)
WHERE o.name IN ('SCRAPED SLATE', 'VAT GROWN')
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = v.char_id);

-- AIDE TO ORDERS DIALOGUS + ROGUE TRADER RETINUE: +5 FEL (fixed)
INSERT INTO character_origin (origin_id, character_id, primary_char)
SELECT o.id, 9, true FROM origin o
WHERE o.name IN ('AIDE TO ORDERS DIALOGUS', 'ROGUE TRADER RETINUE')
AND NOT EXISTS (SELECT 1 FROM character_origin co WHERE co.origin_id = o.id AND co.character_id = 9);

-- =====================================================================
-- 7. ORIGIN TALENTS
-- =====================================================================
INSERT INTO origin_talent (origin_id, talent_id)
SELECT o.id, t.id
FROM (VALUES
    ('DAEMONIC HOST',           'TAINTED VESSEL'),
    ('NULL PERSONA',            'BLANK'),
    ('MERCHANT HOUSE SERVANT',  'ATTENTIVE ASSISTANT'),
    ('IRON ARCHIPELAGO PIRATE', 'FAMILIAR TERRAIN'),
    ('MUTANT',                  'SUBTLE MUTATION'),
    ('SCRAPED SLATE',           'HYPNO-INDOCTRINATION'),
    ('VAT GROWN',               'HYPNO-INDOCTRINATION'),
    ('CULT CAPTIVE',            'HATRED'),
    ('XENOS CAPTIVE',           'HATRED')
) AS v(origin_name, talent_name)
JOIN origin o ON o.name = v.origin_name
JOIN talent t ON t.name = v.talent_name
WHERE NOT EXISTS (
    SELECT 1 FROM origin_talent ot WHERE ot.origin_id = o.id AND ot.talent_id = t.id
);

-- =====================================================================
-- 8. ORIGIN INVENTORY ITEMS (with Shoddy modifier via join table)
-- =====================================================================
DO $$
DECLARE
    v_shoddy_id BIGINT;
BEGIN
    SELECT id INTO v_shoddy_id FROM item_modifier WHERE name = 'Shoddy';

    -- DAEMONIC HOST → Shoddy Manacles
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'DAEMONIC HOST' AND i.name = 'Manacles'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- NULL PERSONA → Shoddy Stablight
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'NULL PERSONA' AND i.name = 'Glow-Globe/Stablight'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- GLAND WARRIOR → Combat Gland (standard quality)
    INSERT INTO origin_inventory_item (origin_id, inventory_id)
    SELECT o.id, i.id FROM origin o, inventory i
    WHERE o.name = 'GLAND WARRIOR' AND i.name = 'Combat Gland'
    AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id);

    -- BANISHER → Shoddy Holy Icon
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'BANISHER' AND i.name = 'Holy Icon'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- APOSTATE OF THE CREED → Shoddy Holy Icon
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'APOSTATE OF THE CREED' AND i.name = 'Holy Icon'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- MANUFACTORUM OVERSEER → Shoddy Dataslate
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'MANUFACTORUM OVERSEER' AND i.name = 'Dataslate'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- MERCHANT HOUSE SERVANT → Shoddy Chrono
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'MERCHANT HOUSE SERVANT' AND i.name = 'Chrono'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- ILLISEAREAN FENSTALKER → Shoddy Knife
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'ILLISEAREAN FENSTALKER' AND i.name = 'Knife'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- IRON ARCHIPELAGO PIRATE → Shoddy Vox Bead
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'IRON ARCHIPELAGO PIRATE' AND i.name = 'Micro-Bead/Vox Bead'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- CULT INFILTRATOR → Shoddy Cultist Robes
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'CULT INFILTRATOR' AND i.name = 'Cultist Robes'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- GANG INFILTRATOR → Shoddy Autopistol
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'GANG INFILTRATOR' AND i.name = 'Autopistol'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- MUTANT → Shoddy Clothing (to conceal mutations)
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'MUTANT' AND i.name = 'Clothing'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- UNUSUAL AUGMENT → Shoddy Combi-Tool (augmetic itself is GM-determined, noted in description)
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'UNUSUAL AUGMENT' AND i.name = 'Combi-Tool'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- CULT CAPTIVE → Shoddy Cultist Robes
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'CULT CAPTIVE' AND i.name = 'Cultist Robes'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- XENOS CAPTIVE → Shoddy Knife
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'XENOS CAPTIVE' AND i.name = 'Knife'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- AIDE TO ORDERS DIALOGUS → Shoddy Auto-Quill
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'AIDE TO ORDERS DIALOGUS' AND i.name = 'Auto-Quill'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

    -- ROGUE TRADER RETINUE → Shoddy Auto-Quill
    WITH ins AS (
        INSERT INTO origin_inventory_item (origin_id, inventory_id)
        SELECT o.id, i.id FROM origin o, inventory i
        WHERE o.name = 'ROGUE TRADER RETINUE' AND i.name = 'Auto-Quill'
        AND NOT EXISTS (SELECT 1 FROM origin_inventory_item x WHERE x.origin_id = o.id AND x.inventory_id = i.id)
        RETURNING id
    )
    INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
    SELECT ins.id, v_shoddy_id FROM ins;

END $$;