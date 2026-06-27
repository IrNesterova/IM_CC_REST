-- Imperium Maledictum Core Rulebook pp. 222–223
-- Mutations (roll d100)
INSERT INTO mutation (name, description, mutation_type, d100_range) VALUES
('Witch-mark',
 'A small brand or mark of a specific chaos god or the eight pointed star forms upon your flesh. Roll on the Hit Location table (see page 211) to determine where it appears.',
 'mutation', '01–05'),
('Wasted Frame',
 'Your pallor becomes corpse-like and your muscles waste away. Your Toughness is permanently reduced by 10 and Advances in Athletics or Fortitude now cost you double the XP.',
 'mutation', '06–10'),
('Lashing Tentacle',
 'A tentacle sprouts from your body. Roll on the Hit Location table (page 211) to determine where it appears. If it appears on a limb, it replaces it. Unarmed attacks made with the Tentacle gain the Reach and Inflict (Restrained) Traits.',
 'mutation', '11–15'),
('Inhuman Beauty',
 'Your skin becomes uncannily flawless and people cannot help but stare. You gain +10 Fellowship whenever people can see your face, and your skin never blemishes or scars.',
 'mutation', '16–20'),
('Iron Skin',
 'Metal scales or ore deposits spread across your body. You gain +2 Armour on all locations, but your Agility is permanently reduced by 10.',
 'mutation', '21–25'),
('Extra Mouth',
 'You grow an extra mouth. Roll on the Hit Location table (page 211) to determine where it appears. The mouth seems to act of its own accord, whispering and infrequently screaming in a language you don''t know.',
 'mutation', '26–30'),
('Searing Blood',
 'Your veins carry searing acids or boiling tar in place of blood, though somehow the corrosive effects do not burn your own flesh. Whenever you take Wounds or suffer the Bleeding Condition, all creatures within Immediate Range suffer Damage equal to the Wounds lost.',
 'mutation', '31–35'),
('Living Shadow',
 'Your shadow does not match your own movements, and it looms large and visible regardless of the light. Whenever you are in darkness and cannot see it, you have the unshakeable feeling it is doing something terrible.',
 'mutation', '36–40'),
('Swollen Brute',
 'You become bloated, your muscles expanding and your form becoming excessively corpulent or disturbingly muscular (or perhaps both). You have Advantage on Opposed Athletics Tests.',
 'mutation', '41–45'),
('Extra Eye',
 'An eye appears somewhere on your body. Roll on the Hit Location table (page 211) to determine where it appears. The eye sees things you cannot. When you look through it, you count as using a Photo-Visors (see page 144).',
 'mutation', '46–50'),
('Twisted Horns',
 'Bony growths sprout from your head. Unarmed attacks made with your horns do not have the Ineffective Trait.',
 'mutation', '51–55'),
('Daemonic Visage',
 'Your appearance twists into something bestial or abhorrent. You suffer −2 SL on Fellowship Tests whenever people can see your face, with the exception of Rapport (Intimidation) Tests, which instead gain +2 SL.',
 'mutation', '56–60'),
('Digitigrade Legs',
 'Your legs twist into a muscular form that greatly enhances your agility. You have Advantage on Athletics Tests to run, leap, or otherwise use your legs.',
 'mutation', '61–65'),
('Feathers',
 'Feathers grow from your body in a spotty fashion. Roll on the Hit Location table (page 211) twice to determine where they appear. They may be of any colour, or multiple colours.',
 'mutation', '66–70'),
('Warp Claws',
 'Your fingers sprout and sharpen into horrific dark talons. Your Unarmed attacks lose the Ineffective Trait and gain Rend (1).',
 'mutation', '71–75'),
('Photonic Irregularity',
 'You do not appear in mirrors or other reflective surfaces, or in video recordings that use the visual light spectrum.',
 'mutation', '76–80'),
('Festering Wound',
 'One of your old wounds returns and refuses to heal, no matter what you do. A Critical Wound you received some time in the past returns and cannot be healed. You are considered to always have one untreated Critical Wound.',
 'mutation', '81–85'),
('Lolling Tongue',
 'Your tongue becomes unwieldy and spasms erratically. You suffer −10 to all Tests that require speech.',
 'mutation', '86–90'),
('Fleshmetal',
 'Your armour and cybernetic implants fuse with your flesh and can even regenerate. You can repair items merged with you using your Fortitude Skill. Tests to repair these items using Tech or other conventional methods have Disadvantage. You cannot change your armour or don additional armour.',
 'mutation', '91–95'),
('Warp Regeneration',
 'Corruption seethes through your flesh, sewing your body back together time and time again whether you will it or not. Your Fate is reduced to 0 and you cannot regain Fate. However, you always regenerate 1 Wound at the beginning of your turn. In addition, any lost limbs regrow after 1 day.',
 'mutation', '96–00');

-- Update existing mutation descriptions to correct rulebook text
UPDATE mutation SET description = 'A small brand or mark of a specific chaos god or the eight pointed star forms upon your flesh. Roll on the Hit Location table (see page 211) to determine where it appears.' WHERE name = 'Witch-mark';
UPDATE mutation SET description = 'Your pallor becomes corpse-like and your muscles waste away. Your Toughness is permanently reduced by 10 and Advances in Athletics or Fortitude now cost you double the XP.' WHERE name = 'Wasted Frame';
UPDATE mutation SET description = 'A tentacle sprouts from your body. Roll on the Hit Location table (page 211) to determine where it appears. If it appears on a limb, it replaces it. Unarmed attacks made with the Tentacle gain the Reach and Inflict (Restrained) Traits.' WHERE name = 'Lashing Tentacle';
UPDATE mutation SET description = 'Your skin becomes uncannily flawless and people cannot help but stare. You gain +10 Fellowship whenever people can see your face, and your skin never blemishes or scars.' WHERE name = 'Inhuman Beauty';
UPDATE mutation SET description = 'Metal scales or ore deposits spread across your body. You gain +2 Armour on all locations, but your Agility is permanently reduced by 10.' WHERE name = 'Iron Skin';
UPDATE mutation SET description = 'You grow an extra mouth. Roll on the Hit Location table (page 211) to determine where it appears. The mouth seems to act of its own accord, whispering and infrequently screaming in a language you don''t know.' WHERE name = 'Extra Mouth';
UPDATE mutation SET description = 'Your veins carry searing acids or boiling tar in place of blood, though somehow the corrosive effects do not burn your own flesh. Whenever you take Wounds or suffer the Bleeding Condition, all creatures within Immediate Range suffer Damage equal to the Wounds lost.' WHERE name = 'Searing Blood';
UPDATE mutation SET description = 'Your shadow does not match your own movements, and it looms large and visible regardless of the light. Whenever you are in darkness and cannot see it, you have the unshakeable feeling it is doing something terrible.' WHERE name = 'Living Shadow';
UPDATE mutation SET description = 'You become bloated, your muscles expanding and your form becoming excessively corpulent or disturbingly muscular (or perhaps both). You have Advantage on Opposed Athletics Tests.' WHERE name = 'Swollen Brute';
UPDATE mutation SET description = 'An eye appears somewhere on your body. Roll on the Hit Location table (page 211) to determine where it appears. The eye sees things you cannot. When you look through it, you count as using a Photo-Visors (see page 144).' WHERE name = 'Extra Eye';
UPDATE mutation SET description = 'Bony growths sprout from your head. Unarmed attacks made with your horns do not have the Ineffective Trait.' WHERE name = 'Twisted Horns';
UPDATE mutation SET description = 'Your appearance twists into something bestial or abhorrent. You suffer −2 SL on Fellowship Tests whenever people can see your face, with the exception of Rapport (Intimidation) Tests, which instead gain +2 SL.' WHERE name = 'Daemonic Visage';
UPDATE mutation SET description = 'Your legs twist into a muscular form that greatly enhances your agility. You have Advantage on Athletics Tests to run, leap, or otherwise use your legs.' WHERE name = 'Digitigrade Legs';
UPDATE mutation SET description = 'Feathers grow from your body in a spotty fashion. Roll on the Hit Location table (page 211) twice to determine where they appear. They may be of any colour, or multiple colours.' WHERE name = 'Feathers';
UPDATE mutation SET description = 'Your fingers sprout and sharpen into horrific dark talons. Your Unarmed attacks lose the Ineffective Trait and gain Rend (1).' WHERE name = 'Warp Claws';
UPDATE mutation SET description = 'You do not appear in mirrors or other reflective surfaces, or in video recordings that use the visual light spectrum.' WHERE name = 'Photonic Irregularity';
UPDATE mutation SET description = 'One of your old wounds returns and refuses to heal, no matter what you do. A Critical Wound you received some time in the past returns and cannot be healed. You are considered to always have one untreated Critical Wound.' WHERE name = 'Festering Wound';
UPDATE mutation SET description = 'Your tongue becomes unwieldy and spasms erratically. You suffer −10 to all Tests that require speech.' WHERE name = 'Lolling Tongue';
UPDATE mutation SET description = 'Your armour and cybernetic implants fuse with your flesh and can even regenerate. You can repair items merged with you using your Fortitude Skill. Tests to repair these items using Tech or other conventional methods have Disadvantage. You cannot change your armour or don additional armour.' WHERE name = 'Fleshmetal';
UPDATE mutation SET description = 'Corruption seethes through your flesh, sewing your body back together time and time again whether you will it or not. Your Fate is reduced to 0 and you cannot regain Fate. However, you always regenerate 1 Wound at the beginning of your turn. In addition, any lost limbs regrow after 1 day.' WHERE name = 'Warp Regeneration';
UPDATE mutation SET description = 'You grow increasingly cruel, callous, and vindictive. Whenever you gain Corruption, you gain 1 additional Corruption.' WHERE name = 'Dark-hearted';
UPDATE mutation SET description = 'You develop an overwhelming desire to consume an inedible or socially unacceptable substance. If you go longer than one week without sating your craving, you become Fatigued until you do so.' WHERE name = 'Awful Cravings';
UPDATE mutation SET description = 'You become obsessed with whatever caused this mutation, and struggle to focus on anything else when left alone. During downtime, you must make a Difficult (−10) Willpower (Discipline) Test to take an Endeavour.' WHERE name = 'Overwhelming Obsession';
UPDATE mutation SET description = 'Chance seems to mock you at the most crucial of opportunities. Whenever you Spend Fate, roll 1d10. On a result of 7–10, the Fate point has no effect but is spent anyway.' WHERE name = 'Ill-fortuned';
UPDATE mutation SET description = 'You feel sick at the sight, sound, or smell of something otherwise innocuous, such as prayer books and holy items, cherubs, Human laughter, or fresh food. When you encounter an object of your revulsion, you are Stunned until the end of your next turn.' WHERE name = 'Irrational Nausea';
UPDATE mutation SET description = 'You grow increasingly distrustful, expecting betrayal at any moment from even your closest allies. You can no longer use or gain the benefits of the Help action (see page 208).' WHERE name = 'Unshakable Paranoia';
UPDATE mutation SET description = 'Unintelligible alien and unnatural voices constantly mutter in your ears. You suffer Disadvantage on Awareness (Sound) Tests.' WHERE name = 'Dark Whispers';
UPDATE mutation SET description = 'You have memories of events that — according to everyone else — never happened. It is impossible for you to tell which of your memories are true and which are false.' WHERE name = 'Phantom Memories';
UPDATE mutation SET description = 'Your character feels horror and revulsion at some innocuous, even good, thing. Work with your GM to choose the object of your fear. When you encounter it, you must succeed at a Challenging (+0) Discipline (Fear) Test or become Frightened.' WHERE name = 'Irrational Fear';
UPDATE mutation SET description = 'You suffer from inexplicable blackouts. Whenever you roll a Fumble on a Test, you must make a Challenging (+0) Fortitude (Endurance) Test or become Incapacitated for 1d10 rounds.' WHERE name = 'Blackouts';
UPDATE mutation SET description = 'You become obsessed with the sight of blood and bodily harm. If a character within your Zone, including yourself, suffers a Critical Wound, you must make a Challenging (+0) Discipline Test or be Stunned until the end of your next turn.' WHERE name = 'Morbid Fascination';
UPDATE mutation SET description = 'You become hyper aware of all the subtle tics and tells that give away mortal desires. You have Advantage on all Intuition (People) Tests.' WHERE name = 'Wheels Within Wheels';
UPDATE mutation SET description = 'You constantly feel like something revolting is crawling beneath your skin.' WHERE name = 'Inescapable Itch';
UPDATE mutation SET description = 'If you close your eyes, you can see the faint skein of the immaterium simmering beneath reality. You gain 1 Advance in Awareness (Psyniscience), even if you do not have the Psyker Talent.' WHERE name = 'Warp Sense';
UPDATE mutation SET description = 'Every shadow you see appears to crawl with shimmering eyes that watch you. You must make a Difficult (−10) Discipline (Fear) Test to enter shadows or complete darkness, or become Frightened.' WHERE name = 'The Eyes';
UPDATE mutation SET description = 'The unspeakable horrors of the void shimmer across your eyes. Creatures who meet your unobstructed gaze must make a Challenging (+0) Willpower (Fear) Test or become Frightened of you.' WHERE name = 'Void Gaze';
UPDATE mutation SET description = 'Everything you eat tastes like ash, blood, or bones.' WHERE name = 'Ashen Taste';
UPDATE mutation SET description = 'You are granted brief flashes of agonies yet to come. Once per day, when you would suffer a Critical Wound as the result of an attack, you may claim that you foresaw this moment. You automatically avoid the attack and take no damage, but gain 1 Corruption as you steer closer towards a twisted fate.' WHERE name = 'Dark Prophecies';
UPDATE mutation SET description = 'You have gained the attention of a daemonic entity that seeks to manipulate your fate to their own unknowable end. You gain an additional Fate point, but whenever you Spend or Burn Fate (see page 220), you count as experiencing Minor Exposure to Corruption.' WHERE name = 'Warp Patron';
UPDATE mutation SET description = 'Your connection to the Warp is violently wrenched open. You gain the Psyker Talent (page 114) and one random Minor Psychic Power (page 160). Whenever you roll on the Perils of the Warp table (page 165) you gain 1 additional Corruption.' WHERE name = 'Psychic Awakening';

-- Malignancies (roll d100)
INSERT INTO mutation (name, description, mutation_type, d100_range) VALUES
('Dark-hearted',
 'You grow increasingly cruel, callous, and vindictive. Whenever you gain Corruption, you gain 1 additional Corruption.',
 'malignancy', '01–05'),
('Awful Cravings',
 'You develop an overwhelming desire to consume an inedible or socially unacceptable substance. If you go longer than one week without sating your craving, you become Fatigued until you do so.',
 'malignancy', '06–10'),
('Overwhelming Obsession',
 'You become obsessed with whatever caused this mutation, and struggle to focus on anything else when left alone. During downtime, you must make a Difficult (−10) Willpower (Discipline) Test to take an Endeavour.',
 'malignancy', '11–15'),
('Ill-fortuned',
 'Chance seems to mock you at the most crucial of opportunities. Whenever you Spend Fate, roll 1d10. On a result of 7–10, the Fate point has no effect but is spent anyway.',
 'malignancy', '16–20'),
('Irrational Nausea',
 'You feel sick at the sight, sound, or smell of something otherwise innocuous, such as prayer books and holy items, cherubs, Human laughter, or fresh food. When you encounter an object of your revulsion, you are Stunned until the end of your next turn.',
 'malignancy', '21–25'),
('Unshakable Paranoia',
 'You grow increasingly distrustful, expecting betrayal at any moment from even your closest allies. You can no longer use or gain the benefits of the Help action (see page 208).',
 'malignancy', '26–30'),
('Dark Whispers',
 'Unintelligible alien and unnatural voices constantly mutter in your ears. You suffer Disadvantage on Awareness (Sound) Tests.',
 'malignancy', '31–35'),
('Phantom Memories',
 'You have memories of events that — according to everyone else — never happened. It is impossible for you to tell which of your memories are true and which are false.',
 'malignancy', '36–40'),
('Irrational Fear',
 'Your character feels horror and revulsion at some innocuous, even good, thing. Work with your GM to choose the object of your fear. When you encounter it, you must succeed at a Challenging (+0) Discipline (Fear) Test or become Frightened.',
 'malignancy', '41–45'),
('Blackouts',
 'You suffer from inexplicable blackouts. Whenever you roll a Fumble on a Test, you must make a Challenging (+0) Fortitude (Endurance) Test or become Incapacitated for 1d10 rounds.',
 'malignancy', '46–50'),
('Morbid Fascination',
 'You become obsessed with the sight of blood and bodily harm. If a character within your Zone, including yourself, suffers a Critical Wound, you must make a Challenging (+0) Discipline Test or be Stunned until the end of your next turn.',
 'malignancy', '51–55'),
('Wheels Within Wheels',
 'You become hyper aware of all the subtle tics and tells that give away mortal desires. You have Advantage on all Intuition (People) Tests.',
 'malignancy', '56–60'),
('Inescapable Itch',
 'You constantly feel like something revolting is crawling beneath your skin.',
 'malignancy', '61–65'),
('Warp Sense',
 'If you close your eyes, you can see the faint skein of the immaterium simmering beneath reality. You gain 1 Advance in Awareness (Psyniscience), even if you do not have the Psyker Talent.',
 'malignancy', '66–70'),
('The Eyes',
 'Every shadow you see appears to crawl with shimmering eyes that watch you. You must make a Difficult (−10) Discipline (Fear) Test to enter shadows or complete darkness, or become Frightened.',
 'malignancy', '71–75'),
('Void Gaze',
 'The unspeakable horrors of the void shimmer across your eyes. Creatures who meet your unobstructed gaze must make a Challenging (+0) Willpower (Fear) Test or become Frightened of you.',
 'malignancy', '76–80'),
('Ashen Taste',
 'Everything you eat tastes like ash, blood, or bones.',
 'malignancy', '81–85'),
('Dark Prophecies',
 'You are granted brief flashes of agonies yet to come. Once per day, when you would suffer a Critical Wound as the result of an attack, you may claim that you foresaw this moment. You automatically avoid the attack and take no damage, but gain 1 Corruption as you steer closer towards a twisted fate.',
 'malignancy', '86–90'),
('Warp Patron',
 'You have gained the attention of a daemonic entity that seeks to manipulate your fate to their own unknowable end. You gain an additional Fate point, but whenever you Spend or Burn Fate (see page 220), you count as experiencing Minor Exposure to Corruption.',
 'malignancy', '91–95'),
('Psychic Awakening',
 'Your connection to the Warp is violently wrenched open. You gain the Psyker Talent (page 114) and one random Minor Psychic Power (page 160). Whenever you roll on the Perils of the Warp table (page 165) you gain 1 additional Corruption.',
 'malignancy', '96–00');