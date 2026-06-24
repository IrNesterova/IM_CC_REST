-- Psychic Disciplines
INSERT INTO psychic_discipline (id, name, description) VALUES
(1, 'Minor Psychic Powers', 'Minor powers are powers which all Psykers are capable of learning without training. They are typically easier to learn and wield than more specialised discipline-specific powers, and they require less contact with the Warp to manifest their effects. Regardless of any other factors, all Psykers know the Smite power.'),
(2, 'Biomancy', 'There are beings in the Warp which delight in twisting and moulding living flesh. Biomancers harness that same power, using it to transform physiologies and alter biological processes to gain new capabilities or reduce foes to screaming piles of meat. Specialisation in Biomancy applies to the Manifest Test of any power within this discipline.'),
(3, 'Divination', 'Rather than experiencing a linear flow of time as realspace does, the Warp twists time irrationally, turning it back upon itself or casting it adrift amongst a sea of roiling improbability. Divination is a psychic discipline that exploits the Warp''s loose definitions of time and space, granting its practitioners extrasensory perception to glimpse the future, perceive hidden truths from arcane perspectives, and glean insight from events as yet unrealised in the physical world. Specialisation in Divination applies to the Manifest Test of any power within this discipline.'),
(4, 'Pyromancy', 'Pyromancers translate the destructive power of the Warp into realspace as incandescent flame. Like all fire, these manifestations have substantial utility that can be used in many applications, but even the most helpful tool serves as a weapon in the right hands. Pyromancers must never lose sight of their power''s destructive potential as they invite consuming flames into the physical world. Specialisation in Pyromancy applies to the Manifest Test of any power within this discipline.'),
(5, 'Telekinesis', 'The Warp mocks mundane physics, as demonstrated by the Telekinesis discipline. Its powers translate mental impulse into motion, turning Warp energy into kinetic might. A Psyker skilled in Telekinesis fears neither bolter nor the blade because either can be turned aside with a thought. Enemies are torn asunder by invisible bolts of force, and gravity becomes merely a quaint notion. Specialisation in Telekinesis applies to the Manifest Test of any power within this discipline.'),
(6, 'Telepathy', 'The minds of all living beings — save a handful of mutant abominations — are connected to the Warp. Telepaths can reach through the immaterium to exploit those connections, touching minds to communicate, while more sinister Telepaths are able to wrench thoughts from minds, tamper with memories, or rob creatures of their free will. Specialisation in Telepathy applies to the Manifest Test of any power within this discipline.');

-- Minor Psychic Powers
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id) VALUES
('Call Vermin', 2, 'Challenging (+0)', 'Medium', 'Special', 'Sustained',
'You summon and compel simple creatures to fly or scurry at your whim. Until the start of your next turn, you gain control of vermin in the area (you don''t need to see them), amassing them as a swarm that fills one Zone within Medium Range. If the vermin crawl, the swarm''s Zone is Difficult Terrain. If the swarm flies, its Zone is Lightly Obscured. As a free action once on your turn, you can command the swarm to move to an adjacent Zone within Long Range of you.

Alternatively, you can summon and control a single vermin, which emerges within Medium Range. As a free action once on your turn, you can direct it to perform a simple task, such as fetching a keycard or gnawing through bindings.

You immediately lose control of vermin beyond Medium Range. This power does not grant you the ability to communicate with vermin, only command them.

Specialisation in Telepathy applies to this power''s Manifest Test.',
1),

('Combustion', 2, 'Routine (+20)', 'Medium', '1 Object', 'Instant',
'Your connection to the Warp momentarily manifests an intense mote of flame, seemingly from nothing. Choose a flammable object within Medium Range. The target catches fire and burns normally. If the target is held or worn by a creature, the creature must drop or remove the item before the end of its next turn or become Ablaze until it or another creature within Immediate Range uses an Action to extinguish it.

Specialisation in Pyromancy applies to this power''s Manifest Test.',
1),

('Dread Presence*', 2, 'Challenging (+0)', 'Self', 'Your Zone', 'Sustained',
'You invoke the Warp''s terrifying nature to exude a dreadful presence, inciting irrational fear in enemies near you. Until the start of your next turn, the first time an enemy enters your Zone in a round or starts its turn there, it must win a Challenging (+0) Discipline (Fear) Test Opposed by your Manifest Test or become Frightened of you until the start of its next turn. If a creature wins the Opposed Test, it is immune to this power for the next hour.

Specialisation in Telepathy applies to this power''s Manifest Test.',
1),

('Dull Pain', 2, 'Routine (+20)', 'Short', 'SL Creatures', 'Sustained',
'You disrupt a creature''s nociceptors, dulling its sensitivity to pain. Choose a number of creatures (including yourself) up to the SL of your Manifest Test within Short Range. Until the start of your next turn, the target feels no pain, and gains one point of Armour to all hit locations.

Specialisation in Biomancy applies to this power''s Manifest Test.',
1),

('Float*', 2, 'Routine (+20)', 'Self/Immediate', 'Self/1 Object', 'Sustained',
'You free yourself from gravity''s constraints, floating weightlessly. Until the start of your next turn, you float suspended in space. While floating, you can move at Slow Speed in any direction, ignoring Difficult Terrain.

Alternatively, you can touch an object within Immediate Range and reduce its Encumbrance by 1 per SL until the start of your next turn.

Specialisation in Telekinesis applies to this power''s Manifest Test.',
1),

('Ignite*', 1, 'Easy (+40)', 'Self', 'Self', 'Sustained',
'A mere thought summons a mote of flame into your hand. Until the start of your next turn, you create a small flame in one of your hands which does not burn you and cannot be extinguished by conventional means. Otherwise the flame functions as a normal flame, casting light, scorching creatures and objects, and igniting flammable materials it touches.

Specialisation in Pyromancy applies to this power''s Manifest Test.',
1),

('Ill Omen', 2, 'Challenging (+0)', 'Medium', '1 Zone', 'Sustained',
'You allow the borders of the immaterium to bleed through into reality, twisting the physical realm to unsettle, amaze, or threaten those who experience the Warp''s horrible nature. Roll on the Psychic Phenomena Table once per SL of your Manifest Test and choose one of the results. Choose a Zone within Medium Range. The chosen psychic phenomena appears in the target Zone until the start of your next turn.

Specialisation in Divination applies to this power''s Manifest Test.',
1),

('Jinx', 2, 'Challenging (+0)', 'Medium', '1 Creature', 'Instant',
'You invoke the maleficent nature of the Warp to curse your target with impending misfortune. Choose a creature within Medium Range. The first Test the target makes within the next hour is made with Disadvantage. If a target is under the effect of this power, being afflicted with it a second time extends the power''s duration but has no other effect.

Specialisation in Divination applies to this power''s Manifest Test.',
1),

('Luck', 1, 'Challenging (+0)', 'Self', 'Self', 'Instant',
'You invoke the fickle nature of the Warp to tilt probability in your favour. When you must make a Test, you can attempt to manifest this power immediately before making that Test. If you manifest it, you make the Test with Advantage. If you fail to manifest it, you make the Test with Disadvantage. This power cannot be used to augment Psychic Mastery Tests, and it cannot be used more than once per Round.

Specialisation in Divination applies to this power''s Manifest Test.',
1),

('Lull', 3, 'Difficult (−10)', 'Short', '1 Creature', 'Sustained',
'You''re able to reach inside a creature with your mind, interfering with the biochemical systems keeping them awake. Choose a creature within Short Range. The target must win a Difficult (−10) Fortitude (Endurance) Test Opposing your Manifest Test or fall Unconscious until the start of your next turn. The target has Advantage on the Test if they are actively performing a strenuous or stressful task or involved in combat. If the target suffers Damage, this power ends. The target regains consciousness immediately when this power ends.

Specialisation in Biomancy applies to this power''s Manifest Test.',
1),

('Nova*', 3, 'Difficult (−10)', 'Self', 'Your Zone', 'Instant',
'You channel the Warp''s destructive power, blasting everything around you with an expanding ring of searing energy. Each creature (excluding you) in your Zone suffers Damage equal to 4 + your Willpower Bonus + the SL from your Manifest Test, and must win a Routine (+20) Athletics (Might) Test Opposing your Manifest Test or be knocked Prone.

Specialisation in Pyromancy applies to this power''s Manifest Test.',
1),

('Preternatural Senses', 2, 'Routine (+20)', 'Self', 'Self', 'Sustained',
'You augment your biology to grant yourself enhanced senses beyond those typical of your species. Until the start of your next turn, you gain the following effects:
• You ignore penalties from Zones with the Poorly Lit and Dark Environmental Traits
• You can see the heat patterns of living creatures through solid walls up to medium range.
• You gain Advantage to Perception Tests.
Additionally, if you score at least 5 SL on your Manifest Test, you can sense creatures, objects, and movement using senses other than sight, allowing you to ignore the Blinded condition.

Specialisation in Biomancy applies to this power''s Manifest Test.',
1),

('Psychic Scrutiny', 1, 'Easy (+40)', 'Short', '1 Creature', 'Instant',
'You can scrutinise a creature''s soul, glimpsing shreds of its future and past to glean vital information about its current state of being. Choose a creature within Short Range. For each SL of your Manifest Test, you learn one of the following pieces of information about the target:
• Current and Maximum Wounds
• Highest and Lowest Characteristic
• One Characteristic''s Value (your choice)
• Most advanced Skill (GM''s choice)
• One Talent or Trait (GM''s choice)

Specialisation in Divination applies to this power''s Manifest Test.',
1),

('Psychic Static', 1, 'Easy (+40)', 'Self', 'Self', 'Sustained',
'You emanate imperceptible psychic static, shrouding you from notice and detection. Until the start of your next turn, a creature or device doesn''t perceive you unless it wins an Easy (+40) Awareness (Any) Test Opposing your Manifest Test. Those you are shrouded from look past you, do not register your voice or footsteps, and otherwise act as though you aren''t there. If a creature or device takes Damage or you interact with it, it becomes able to perceive you.

Specialisation in Telepathy applies to this power''s Manifest Test.',
1),

('Scalding Glance', 2, 'Challenging (+0)', 'Medium', 'Special', 'Sustained',
'With a simple glance, you pour pyromantic energy into a nearby liquid, causing it to spontaneously boil. Choose up to 20 gallons of liquid per SL of your Manifest Test within Medium Range. The liquid instantly boils and continues to do so until the start of your next turn. When this power ends, the boiling subsides, but the liquid still retains heat, cooling over time at a normal rate. This power can''t target liquid inside a living creature. Confined liquids may cause the container they are in to explode.

Specialisation in Pyromancy applies to this power''s Manifest Test.',
1),

('Seal Wounds*', 2, 'Routine (+20)', 'Immediate', '1 Creature', 'Instant',
'You perceive the biomantic energy in a creature''s body, bolstering it with your psychic power to speed the restoration of damaged tissue. Touch a creature (including yourself) within Immediate Range. The target heals Wounds equal to your Willpower Bonus + the target''s Toughness Bonus + the SL from your Manifest Test, and if the target is Bleeding, the Condition is removed. The influx of biomantic energy from this power taxes the target''s body, so if it receives the benefit of this power again before it Rests, it becomes Fatigued.

Specialisation in Biomancy applies to this power''s Manifest Test.',
1),

('Sear', 3, 'Difficult (−10)', 'Medium', '1 Object', 'Sustained',
'You channel psychic energy into an object until it glows with searing heat. Choose an object with an Encumbrance no greater than the SL of your Manifest Test within Medium Range. Until the start of your next turn, the object becomes burning hot and glows dimly. A creature touching the object when you manifest this power suffers Damage equal to your Willpower Bonus, and suffers the Damage again at the end of its turn if it''s still touching the object. If the object is a piece of Armour a creature is wearing, its Armour Value does not reduce the Damage. When the power ends, the heated object cools at a normal rate. At the GM''s discretion, materials that can withstand the heat may become somewhat malleable while heated, while less robust materials may simply melt.

Specialisation in Pyromancy applies to this power''s Manifest Test.',
1),

('Smite*', 2, 'Difficult (−10)', 'Medium', '1 Creature', 'Instant',
'You unleash a coruscating blast of raw psychic power against a foe, rending flesh and spirit. Choose a Creature within Medium Range. The target suffers Damage equal to 2 + your Willpower Bonus + the SL from your Manifest Test, which ignores Armour.

Specialisation in Telepathy applies to this power''s Manifest Test.',
1),

('Soulsight', 2, 'Challenging (+0)', 'Medium', 'Self', 'Sustained',
'Souls burn like flames in the darkness of the Warp, and you can attune your senses to detect them. Until the start of your next turn, you can sense the presence of living creatures within Medium Range according to the Soulsight Table. You can exclude specific creatures, such as you and your allies, from what this power detects. Additionally, you have Advantage to Psyniscience Tests to detect or identify daemons or psykers while this power is active.

Soulsight Table:
+1 SL: How many sentient creatures are within range.
+2 SL: The species of each sentient creature within range.
+3 SL: How many sentient creatures are in each Zone within range.
+4 or more SL: The exact location of each sentient creature within range.

Specialisation in Divination applies to this power''s Manifest Test.',
1),

('Spasm', 2, 'Routine (+20)', 'Short', '1 Creature', 'Sustained',
'You disrupt the neuro-muscular system of a creature, causing it to momentarily lose control of one of its limbs. Choose a creature within Short Range. The target must win a Routine (+20) Fortitude (Endurance) Test Opposing your Manifest Test or lose the use of one of its limbs (your choice) until the start of your next turn. At the end of the target''s turn, it may make another Routine (+20) Fortitude (Endurance) Test Opposing your Manifest Test, to end this power.

The affected limb cannot be used to perform any Action. If the limb is a leg, the target''s Speed decreases one step (minimum Slow). If the limb is holding an item, it drops it. If the limb is Grappling a creature, the Grapple is released.

Specialisation in Biomancy applies to this power''s Manifest Test.',
1),

('Spectral Hands', 2, 'Routine (+20)', 'Short', 'Special', 'Sustained',
'You manifest telekinetic forces to manipulate objects and move them. Choose any number of objects within Short Range with a total Encumbrance no greater than the SL of your Manifest Test. Until the start of your next turn, you can manipulate those objects as though they were held by invisible hands under your control. Fine, precise manipulation is not possible — only gross movements. The objects float in place, but as a Free Action once on your turn, you can move each of the objects within your Zone. Objects leave your control and fall to the ground if they are outside your Zone.

Additionally, you can use your Action to Attack a target within your Zone with an object manipulated by this power. Make a Psychic Mastery (Telekinesis) Test as a melee weapon attack against the target. Regardless of what the object is, it deals 1 Damage per point of Encumbrance and is treated as an Ineffective weapon.

Specialisation in Telekinesis applies to this power''s Manifest Test.',
1);

-- Biomancy
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id) VALUES
('Affliction', 3, 'Difficult (−10)', 'Short', '1 Creature', 'Sustained',
'You psychically wreak havoc with a creature''s biology to hinder and debilitate them. Choose a creature within Short Range. The target must win a Difficult (−10) Fortitude (Endurance) Test Opposing your Manifest Test or gain one of the following conditions until the start of your next turn: Blinded, Deafened, Fatigued, Poisoned, or Stunned. At the end of the target''s turn, it makes another Difficult (−10) Fortitude (Endurance) Test Opposing your Manifest Test, ending the power immediately if it wins. Once a creature wins the Opposed Test, it is immune to this power for the next hour.

The target can use an Action to make a Challenging (+20) Fortitude (Endurance) Test Opposing your Manifest Test, ending this power immediately if it wins.',
2),

('Bio-Lightning*', 3, 'Hard (−20)', 'Medium', '1 Creature', 'Instant',
'You alter your physiology to generate vast amounts of electrical current, discharging it in a devastating electrical arc. Choose a creature within Medium Range. The target and creatures within Immediate Range of the target suffer Damage equal to 4 + your Willpower Bonus + SL from your Manifest Test. A creature Damaged by this must also win a Hard (−20) Fortitude (Endurance) Test Opposing your Manifest Test or be Stunned until the beginning of your next turn.',
2),

('Cleanse*', 3, 'Difficult (−10)', 'Immediate', '1 Creature', 'Instant',
'You pour Psychic power through a creature''s body to purge it of harmful disease vectors and restore healthy function. Touch a creature within Immediate Range. If the target is Poisoned or Stunned, those Conditions end. If the target is afflicted with a disease, it adds the SL from your Manifest Test to its next Test to resist it.',
2),

('Ferrocrete Flesh*', 3, 'Challenging (+0)', 'Immediate', '1 Creature', 'Sustained',
'You rapidly modify a creature''s flesh with psychic directives, thickening its skin, increasing the density of its flesh, and fortifying its bones while increasing its bulk. Touch a creature (including yourself) within Immediate Range. Until the start of your next turn, the target gains an amount of Armour equal to its Toughness Bonus to all hit locations.

If the creature''s Toughness Bonus is greater than its Strength Bonus, the target''s Speed decreases by one step (minimum Slow), and the target makes Agility Tests with Disadvantage.',
2),

('Haemorrhage', 2, 'Challenging (+0)', 'Short', '1 Creature', 'Instant',
'You force a surge of psychic power through your victim, rupturing blood vessels and re-opening scars to cause bleeding throughout their body. Choose a creature within Short Range. The target must win a Challenging (+0) Fortitude (Endurance) Test Opposing your Manifest Test or suffer 2 Damage, ignoring Armour, and begin Bleeding (Major). The bleeding continues until it''s stopped through medicae treatment or other means.',
2),

('Iron Limb*', 1, 'Easy (+40)', 'Self', 'Self', 'Sustained',
'You fortify your musculature with an influx of psychic energy, thickening muscles and strengthening tendons, augmenting your physical prowess with the boundless power of the Warp. Until the start of your next turn, you have Advantage on Strength and Weapon Skill Tests. Additionally, whenever you reference your Strength Bonus to calculate a number (such as melee weapon Damage), you may use the SL from your Manifest Test instead of your Strength Bonus.',
2),

('Life Leech*', 4, 'Very Hard (−30)', 'Medium', '1 Creature', 'Sustained',
'Attuned to the rhythms of life, you form a psychic link to another creature''s body, latching onto it like a parasite syphoning its vitality. Choose a creature within Medium Range. The target must win a Very Hard (−30) Fortitude (Endurance) Test Opposing your Manifest Test or become linked to you until the start of your next turn.

While linked, you can use a Free Action once on your turn to deal Damage equal to 3 + your Willpower Bonus to the target, which ignores Armour. When this power deals Damage, you heal a number of Wounds equal to half the Damage dealt (rounding up).

At the end of the target''s turn, it repeats the Opposed Test, ending the power immediately if it wins. Once a target wins the Opposed Test, it is immune to this power for the next hour.',
2),

('Metabolic Overdrive*', 2, 'Challenging (+0)', 'Short', 'SL Creatures', 'Sustained',
'Pushing creatures'' endocrine systems into overdrive, you flood their bodies with potent hormones that quicken their movements and reflexes. Choose a number of creatures (including yourself) within Short Range up to the SL of your Manifest Test. Until the start of your next turn, each target''s Speed increases one step, and it makes Reflexes Tests with Advantage.',
2),

('Shape Flesh*', 1, 'Easy (+40)', 'Immediate', '1 Creature', 'Permanent',
'Psychic manipulation of flesh allows you to sculpt a creature''s body and features as you envision them. Touch a creature within Immediate Range. Over the course of 10 minutes, you psychically manipulate the target''s anatomy and appearance, permanently changing them according to the Shape Flesh Table. If the target is unwilling, it opposes your attempt with an Easy (+40) Fortitude (Endurance) Test. Willing or not, the more substantial the alterations you make, the more pain the target experiences, leaving them Stunned for 1d5 rounds.

If alterations from this power deliberately mimic the appearance of another specific creature, it can be used as part of a disguise to impersonate that creature. In that case, the Difficulty of Tests to detect the disguise is modified by −10 per SL of your Manifest Test.

Shape Flesh Table:
+1–+2 SL: Alter minor cosmetic features such as hair/eye/skin colour, facial features, or blemishes.
+3–+4 SL: Moderately alter height, weight, natural posture, and physique.
+5 or more SL: Drastically alter features and body structure. This includes rebuilding, removing, or disabling body parts such as limbs and sensory organs. You can cause or repair one Injury or Amputation.',
2),

('Wither*', 2, 'Routine (+20)', 'Self', 'Your Zone', 'Instant',
'You bathe your surroundings in the anathema of life, necrotising living creatures with entropic force that desiccates plants and renders flesh withered and ashen. Each creature in your Zone must make a Routine (+20) Fortitude (Endurance) Test Opposing your Manifest Test. If you win the Opposed Test, the victim suffers Damage equal to the difference in SL. This Damage ignores Armour. If a creature suffers Damage greater than its Toughness Bonus, it is also Poisoned until the start of your next turn.',
2);

-- Divination
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id) VALUES
('Armour Bane', 2, 'Challenging (+0)', 'Short', '1 Weapon', 'Sustained',
'You guide a weapon with psychic foresight, subtly directing it to seek weak points in armour. Choose a weapon within Short Range. Until the start of your next turn, that weapon gains the Penetrating (X) Trait where X equals the SL of your Manifest Test. If the weapon already has the Penetrating Trait, it uses whichever rating is higher (they do not stack).',
3),

('Dowsing', 3, 'Difficult (−10)', 'Special', 'Special', 'Sustained',
'If you can imagine something in your mind''s eye, you can follow the Warp''s currents to it as though they were strings tangled throughout reality, tethering everything together. Choose a specific object or creature you have observed firsthand. Until the start of your next turn, if the target is within 1 mile per SL, you know which direction and how far it is from you, allowing you to follow this power to the target.

Rather than choosing a specific quarry, you can choose a type of object, a material, or a species, such as detpacks, water, or Aeldari. Until the start of your next turn, you can sense if your quarry is within Long Range. You do not learn its location or how many instances of it are present, simply that it is in the area.',
3),

('Forewarning', 2, 'Routine (+20)', 'Self', 'Self', 'Sustained',
'Flashes of foresight warn you of impending danger, allowing you the chance to manoeuvre out of harm''s way. Until the start of your next turn, you can take the Dodge Action as a Free Action on your turn.',
3),

('Perfect Timing', 2, 'Challenging (+0)', 'Short', 'SL Allies', 'Instant',
'You alter an ally''s perception of time, stretching moments without slowing their thoughts, giving them time to consider their actions. Choose a number of allies (including you) up to the SL of your Manifest Test within Short Range. At the end of each target''s next turn, they can Seize the Initiative as a free action. Additionally, each target gains Advantage on the first Test they make before the end of their next turn.',
3),

('Prescience', 1, 'Easy (+40)', 'Self', 'Self', 'Special',
'You dare consult the Warp to gain insights into the possible futures awaiting you, preparing you for what''s to come. During a Rest, you can spend 10 minutes in a Divinatory trance to examine the possible futures presented to you by the Warp. At the end of the trance, you gain a number of Prescience Points equal to the SL from your Manifest Test.

After you make a Test, you can spend one of your Prescience Points to reroll one or both dice from the Test, using the result of the new roll to resolve the Test. Advantage and Disadvantage apply after the roll as normal. You can''t spend more than one Prescience Point on a Test.

Prescience Points do not expire, but you lose any unspent Points the next time you manifest this power.',
3),

('Question the Warp*', 1, 'Challenging (+0)', 'Self', 'Self', '1 Minute',
'You enter a minute-long trance, casting your soul into the immaterium to search for answers, but the Warp is home to manipulative forces and should never be fully trusted. Within the roiling power of the Warp lies every truth, every lie and the knowledge of past, future and present. A psyker who is desperate enough can attempt to pluck a sliver of knowledge from within the Empyrean, although whether it is a glimpse of the future, a skein of wisdom or the lies of daemonkind are anyone''s guess…

When you manifest this power, ask the GM a question you don''t know the answer to. The GM secretly rolls 1d10 and compares it to the sum of your Willpower Bonus + the SL from your Manifest Test (maximum 9). If the d10 roll is less than the sum, the GM answers truthfully. If the d10 roll is greater than or equal to the sum, the GM''s answer is false. Regardless of the veracity, once this power provides an answer, you can''t ask the same question again.',
3),

('Psychometry*', 1, 'Easy (+40)', 'Immediate', '1 Object or Zone', '1 Minute',
'Emotions experienced in the physical world boil into the Warp, but those same experiences linger where they occurred, simmering just beneath the surface of reality. This psychic residue seeps back into realspace, and properly attuned Diviners can witness these past events echoing back through time. Over the course of a minute, you enter a trance and attune your senses to an object you are touching within Immediate Range or your current Zone. You receive insight into the target''s history depending on the SL of your Manifest Test according to the Psychometry Table.

Psychometry Table:
+1 SL: You receive general, vague impressions of the most recent strong emotions creatures felt while nearby or interacting with the target.
+2 SL: You know how recently the emotions were experienced.
+3 SL: You witness a hazy memory of the events that caused the strong emotions.
+4 SL: You witness a clear, detailed memory of the events.
+5 SL: You learn the identities of the people who left emotional impressions on the target.
+6 or more SL: You gain a deep understanding of what transpired involving the target. Ask the GM a single question about the event, which they answer truthfully.',
3),

('Scrying Gaze*', 1, 'Easy (+40)', 'Special', '1 Creature', '1 Minute',
'Physical distance has little meaning in the Warp, so you can peer through that dimension to locate and observe targets anywhere. Choose a creature, object, or location you''ve observed firsthand. Over the course of a minute, you send your senses through the Warp to observe the target. You can see and hear the target. If you score 4 or more SL on your Manifest Test, you know the target''s approximate direction and distance from you and can also see and hear the Zone surrounding it.

A Psyker or daemon senses it is being observed if its Perception Bonus is higher than your Willpower Bonus. If it''s aware of your observation, it can use an Action on its turn to make an Easy (+40) Discipline (Psychic) Test Opposing your Manifest Test, ending the power immediately if it wins. If the target wins the Opposed Test, it can''t be targeted by this power again for the next hour.',
3),

('Twist Fate', 2, 'Routine (+20)', 'Short', '1 Creature', 'Instant',
'The Warp doesn''t distinguish between good and bad fortune, and you invoke that cosmic ambivalence to blur the line between them. Once during a round when a creature within Short Range (including you) makes a Test with Advantage or Disadvantage, you can attempt to manifest this power as a Reaction. If successful, the creature makes the Test with neither Advantage nor Disadvantage. If you fail your Manifest Test, you fall victim to the Warp''s fickle nature, forcing you to make Tests with Disadvantage until you have 0 Warp Charge.',
3),

('Watchward', 2, 'Routine (+20)', 'Self', 'Self', 'Sustained',
'You open your awareness to the subtle quantum changes that occur when you are observed. Until the start of your next turn, you can detect if any creature or device is currently observing you by any means, granting you information depending on the SL of your Manifest Test according to the Watchward Table. You can exclude specific creatures, such as your allies, from what this power detects.

Watchward Table:
+1 SL: You know you''re being watched by something.
+2 SL: You know how many beings or devices are watching you.
+3 SL: You know the means of observation (such as natural senses, technological, or psychic).
+4 SL: You know generally which direction and how far your observers are from you.
+5 SL: You know the exact location of your observers.
+6 or more SL: You know what your observers look like.',
3);

-- Pyromancy
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id) VALUES
('Cauterise*', 3, 'Difficult (−10)', 'Immediate', '1 Creature', 'Instant',
'You produce a momentary flash of carefully-modulated searing heat through your hand, allowing you to staunch bleeding or shock a senseless ally back into focus. Touch a creature within Immediate Range. You remove the following Conditions from the target: Bleeding, Frightened, Stunned, or Unconscious, but the target also suffers Damage to the body part you touched equal to 4 minus the SL of your Manifest Test. This Damage ignores Armour.',
4),

('Command Flames', 3, 'Difficult (−10)', 'Long', 'Special', 'Instant',
'Your thoughts shape flames, directing their course and intensity or snuffing them out at your command. As a Free Action this turn, you can manipulate fire within Long Range a number of times up to the SL of your Manifest Test. You can manipulate fire as follows:
• Extinguish all fires within one Zone. This reduces the severity of any Hazard Trait due to fire by one step, and removes any Ablaze Conditions.
• Intensify or dampen flames within one Zone to double or halve the amount of light they cast.
• Change the colour of flames within one Zone.
• Amplify isolated flames within one Zone to grant that Zone the Minor Hazard Trait.
• Spread the fire from a burning Zone to grant an adjacent, suitably flammable Zone the Minor Hazard Trait.
• Make flames within one Zone take on the appearance of figures or shapes until the start of your next turn.',
4),

('Fire Storm*', 3, 'Hard (−20)', 'Medium', '1 Zone', 'Instant',
'You focus intently on a point, invoking the power of the Warp to manifest an unstable mote of starfire that incinerates its surroundings as it explodes. Choose a Zone within Medium Range. Creatures in the Zone suffer Damage equal to 6 + the SL of your Manifest Test and must win a Hard (−20) Reflexes (Dodge) Test Opposing your Manifest Test or become Ablaze until it or another creature within Immediate Range uses an Action to extinguish it. Flammable objects in the Zone are also ignited by the flames, giving the Zone the Minor Hazard Trait at the GM''s discretion.',
4),

('Inferno*', 3, 'Hard (−20)', 'Long', 'SL Zones', 'Sustained',
'The power of the raging Empyrean courses wildly through you, superheating the air until it combusts into fiery Warp-fueled infernos. Choose a number of Zones within Long Range up to the SL of your Manifest Test. Until the start of your next turn, the target Zones become Minor Hazards. Additionally, a creature Damaged by one of these Hazards must succeed on a Hard (−20) Reflexes (Dodge) Test or become Ablaze until it or another creature within Immediate Range uses an Action to extinguish them. When this power ends, all fire within the Zones is extinguished as it is snuffed out by the receding Warp.',
4),

('Molten Beam*', 3, 'Hard (−20)', 'Long', 'One Creature or Object', 'Instant',
'You emit a coherent beam of fusion-intense heat from your eyes or hands, super-heating the air in its path with a thunderous crash as it lances through armour and flesh with pinpoint accuracy. Choose a creature or object within Long Range. The target suffers Damage equal to 7 + the SL of your Manifest Test. If the target is a creature, you can choose the location that suffers Damage. After damage is applied, any Armour on the target location has its Armour Value permanently reduced by your Willpower Bonus.',
4),

('Plasma Torch*', 2, 'Challenging (+0)', 'Self', 'Self', 'Sustained',
'Your hand becomes wreathed in a nimbus of crackling plasma, allowing you to cut and weld metal or scorch foes with a superheated touch. Until the start of your next turn, your hand manifests a cloud of plasma around it that is harmless to you. The plasma sheds bright light in your Zone and allows your hand to function as a conventional plasma torch that can cut or weld metal. Additionally, you can use your hand as a melee weapon (Specialisation: Brawling, Dam: 4+WilB, Enc: 0, Traits: Inflict (Ablaze), Loud, Rend (WilB)).',
4),

('Pyrelight*', 3, 'Hard (−20)', 'Special', 'Self', 'Sustained',
'Your flesh glows from within with psychic power, radiating incandescent light and heat. Until the start of your next turn, your skin glows with noticeable warmth, casting bright light in your Zone and dim light into adjacent Zones. As a Free Action on your turn, you can increase the intensity of the light and heat, or revert it to warm, dim light. While intensified, you cast bright light within Medium Range, and your Zone becomes a Minor Hazard (you are unaffected by the Hazard). Additionally, when a creature enters your Zone for the first time in a round or starts its turn there, it must win a Hard (−20) Fortitude (Endurance) Test Opposing your Manifest Test or be Blinded until the start of your next turn.',
4),

('Smouldercloud*', 2, 'Challenging (+0)', 'Medium', 'SL Zones', 'Sustained',
'You create smouldering heat in surfaces and substances around you, just enough to shed thick clouds of soot, smoke, or steam. Choose a number of Zones up to the SL of your Manifest Test within Medium Range. Until the start of your next turn, each Zone becomes Heavily Obscured. Additionally creatures begin to suffocate if they end their turn within the Zone.',
4),

('Sunburst*', 2, 'Challenging (+0)', 'Long', '1 Zone', 'Instant',
'Opening a pinhole-sized rift into the Warp for the merest instant, you unleash a flash of blinding light, searing retinas and damaging sensitive optics. Choose a Zone within Long Range. Creatures within the Zone must make a Challenging (+0) Fortitude (Endurance) Test Opposing your Manifest Test. If the target loses, it is Blinded. A Blinded creature repeats the Opposed Test at the end of each of its turns, removing the Condition if it wins. If a creature loses the Test more than 3 times in a row, it is permanently Blinded. Extensive medicae treatment, augmetics, or other powerful healing is required to restore sight to the permanently blind.',
4),

('Thermal Shroud*', 2, 'Routine (+20)', 'Short', 'Allies in Range', 'Sustained',
'You envelop your allies in a shimmering field of entropy that consumes flames and heat, shunting the energy into the immaterium before it reaches you. Until the start of your next turn, Damage you and your allies within Short Range suffer from fire and heat, such as Flame and Melta weapons, is reduced by your Willpower Bonus + 1 per SL of your Manifest Test. This reduction occurs before applying Armour. It also becomes impossible to detect your presence through a thermally sensitive auspex.',
4);

-- Telekinesis
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id) VALUES
('Abjuration Mechanicum', 2, 'Routine (+20)', 'Short', '1 Machine', 'Instant',
'Your thoughts sabotage a machine with minute telekinetic manipulations, tampering with its inner workings until it no longer functions correctly. Choose a machine, including those operated by servitors, within Short Range. The maximum effect you can manifest is determined by the SL of your Manifest Test, but you can choose to inflict a less severe effect.

Exceptionally large or complex machines, such as vehicles, voidships, titans, or industrial machinery may, at the GM''s discretion, be considered multiple smaller machines, in which case this power can only target a specific component within the larger construct.

Abjuration Mechanicum Table:
+1 SL: The machine becomes momentarily glitchy. Until the start of your next turn, roll 1d10 each time it should function. On a result of 6+, the machine does nothing.
+2 SL: The machine jams, unable to function until the start of your next turn.
+3 SL: The machine breaks, unable to function at all until it''s repaired.
+4 SL: The machine suffers irreparable damage and is destroyed.
+5 or more SL: The machine is destroyed and fails catastrophically, inflicting 4 Damage to everything within Immediate Range.',
5),

('Breach', 2, 'Challenging (+0)', 'Medium', '1 Object', 'Instant',
'You imagine solid matter furiously torn apart, and the Warp manifests your vision through telekinetic savagery. Choose a Large or smaller object within Medium Range. If the GM rules the object is one you can destroy (using the Breach Table as reference), the object is violently torn apart and destroyed. Alternatively, you can target a piece (one hit location) of Armour. Its Armour Value permanently decreases by 1 for each SL of your Manifest Test.

Breach Table:
+1 SL: a fragile object, such as a glass window or pict-recorder.
+2 SL: a common object, such as a plastic tray or wooden stool.
+3 SL: a rugged object, such as a Lasgun or a wooden door.
+4 SL: an exceptionally sturdy object, such as a Bolt Pistol or a compressed gas canister.
+5 SL: an object designed to withstand severe stress, such as a plasteel wall or ferrocrete pillar.
+6 or more SL: an object made from nigh-unbreakable materials like ceramite or adamantium.',
5),

('Crush', 3, 'Hard (−20)', 'Medium', '1 Creature', 'Sustained',
'You focus psychokinetic pressure on your enemy, applying force to hold them in place while you crush their flesh and bones. Choose a creature within Medium Range. The target suffers Damage equal to 3 + Willpower Bonus + the SL of your Manifest Test, and it must make a Hard (−20) Athletics (Might) Test Opposing your Manifest Test. If it loses, it becomes Restrained until the power ends. At the end of the target''s turn, it makes another Hard (−20) Athletics (Might) Test Opposing your Manifest Test, ending the power immediately if it wins.',
5),

('Deflection*', 1, 'Easy (+40)', 'Self', 'Self', 'Sustained',
'You''ve learned to swat aside weapons and projectiles with a thought, deflecting them to reduce their destructive potential. Until the start of your next turn, all your body parts gain Armour equal to the SL of your Manifest Test. This Armour is cumulative with existing Armour. Energy-based weapons ignore this additional Armour; only physical objects like melee weapons, shrapnel, and projectiles are mitigated by this power.',
5),

('Gate of Infinity*', 2, 'Challenging (+0)', '1 Mile per SL', 'Special', 'Sustained',
'In a mind-bending display of telekinetic supremacy, you tear a hole in reality, reach across the Warp, and open another rift elsewhere in realspace, connecting the two locations by a doorway with no physical distance between them. Choose a point within Immediate Range, then choose another point within 1 mile per SL of your Manifest Test. The second point must be one you can see, remember, or describe in terms of direction and distance from you.

Until the start of your next turn, a Large shimmering portal opens at both points. Anything passing through one portal emerges from the other as though passing through an open doorway. Moving and attacking with a ranged weapon from one Zone into another through the portal counts as moving or attacking from one Zone into an adjacent Zone, but nothing physically traverses the space between the Zones.',
5),

('Gravity Well*', 1, 'Easy (+40)', 'Self', 'Your Zone', 'Sustained',
'You subtly increase the gravitational attraction between your mass and that of creatures around you, drawing them closer and preventing them from leaving your orbit. Until the start of your next turn, your Zone becomes Difficult Terrain for creatures other than you, and creatures in your Zone (excluding you) can''t move into another Zone unless they win an Easy (+40) Athletics (Might) Test Opposing your Manifest Test. Additionally, if you move into another Zone while this power is active, creatures in your Zone are dragged along with you into the new Zone unless they resist by winning an Easy (+40) Athletics (Might) Test Opposing your Manifest Test.',
5),

('Impel', 2, 'Routine (+20)', 'Short', '1 Creature or Object', 'Instant',
'Your power propels objects and creatures with sudden, violent force. Choose an object within Short Range. If the object''s Encumbrance is less than or equal to the SL of your Manifest Test, the object is pushed into an adjacent Zone of your choice. If its Encumbrance is greater, it does not move.

Alternatively, you can target a creature within Short Range. The target must win a Routine (+20) Athletics (Might) Test Opposing your Manifest Test or be pushed into an adjacent Zone of your choice and knocked Prone.',
5),

('Psychic Barrier', 3, 'Difficult (−10)', 'Medium', '1 Zone', 'Sustained',
'Your will coalesces into an invisible barrier of telekinetic force that resists the passage of matter and energy, protecting your allies and containing threats. Choose a Zone within Medium Range. Until the start of your next turn, you erect an invisible wall or bubble around the Zone. Creatures can''t cross the barrier into or out of the Zone unless they use an Action to win a Difficult (−10) Athletics (Might) Test Opposing your Manifest Test.

Additionally, the barrier hinders Ranged Attacks. Ranged Attacks that cross into or out of the target Zone deal 2 less damage for each SL of your Manifest Test.',
5),

('Psychic Maelstrom*', 2, 'Routine (+20)', 'Self', 'Your Zone', 'Sustained',
'You manifest a swirling maelstrom of tangible force around you, battering everything nearby in a storm of psychokinetic energy. Until the start of your turn, your Zone becomes Difficult Terrain, and when a creature enters your Zone for the first time in a round or starts its turn there, it must win a Routine (+20) Athletics (Might) Test Opposing your Manifest Test or be knocked Prone. Creatures who Attack within or through the Zone do so with Disadvantage.

The maelstrom also buffets and knocks over unsecured objects with Encumbrance equal to or less than the SL of your Manifest Test. Unsecured objects with 0 Encumbrance are borne aloft and swirled wildly around your Zone.',
5),

('Vortex of Doom*', 4, 'Very Hard (−30)', 'Medium', '1 Zone', 'Sustained',
'You open yourself to a moment of reckless carnage, tearing a barely-contained wound through reality''s surface and exposing realspace to the hellish depredations of the Warp. Choose a Zone within Medium Range. Until the start of your next turn, the Zone becomes Difficult Terrain, Warp-Touched, and a Deadly Hazard. Additionally, when a creature takes Damage from this power, it must win a Very Hard (−30) Discipline (Psychic) Test Opposing your Manifest Test or be Stunned.

When you stop sustaining this power, roll 1d10. If the result is greater than or equal to your Willpower Bonus, you stop sustaining it, but the vortex remains, and its effects still apply to its Zone. The vortex remains open until a Psyker within Medium Range uses an Action to attempt to close the rift, requiring a successful Very Hard (−30) Psychic Mastery (Telekinesis) Test.',
5);

-- Telepathy
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id) VALUES
('Beacon', 3, 'Hard (−20)', 'Medium', '1 Creature', 'Sustained',
'Reaching out with your mind, you sink a telepathic hook into the mind of another creature, creating a beacon that constantly broadcasts its location and movements to you at the speed of thought. Choose a creature within Medium Range. Until the start of your next turn, you know the target''s exact location within a number of miles equal to the SL of your Manifest Test. Additionally, you have Advantage on Attack Tests made against the target.',
6),

('Compel', 2, 'Routine (+20)', 'Short', '1 Creature', 'Instant',
'You issue a simple psychic command to your victim, compelling them to obey against their will. Choose a creature within Short Range. The target must make a Routine (+20) Discipline (Psychic) Test Opposing your Manifest Test. If you win, you immediately declare one Action or Movement the target will take on its next turn, and the target must carry it out before it does anything else. Whether you win or lose the Opposed Test, the target is aware that you compelled them.',
6),

('Dominate', 3, 'Hard (−20)', 'Medium', '1 Creature', 'Sustained',
'Your psychic influence overrides a creature''s autonomy, subjugating it to your will. Choose a creature within Medium Range. The target must win a Hard (−20) Discipline (Psychic) Test Opposing your Manifest Test or fall under your control until the start of your next turn. While the target is under your control, you dictate its behaviour, including what it does during its turn.

Whenever the target takes Damage and at the end of its turn, it repeats the Opposed Test, ending the power immediately if it wins. Once a Creature wins the Opposed Test, it is immune to this power for the next hour. The target is aware of your attempt to control them whether you win or lose the first Opposed Test.',
6),

('Erasure', 2, 'Routine (+20)', 'Short', '1 Creature', 'Instant',
'With surgical precision or brute force, you reach into your target''s mind to excise a specific memory, leaving no trace of it. Choose a creature within Short Range. The target resists your attempts with a Routine (+20) Discipline (Psychic) Test Opposing your Manifest Test — if it fails you may permanently remove one memory from its mind. The length of the memory you erase can be up to 10 x your Willpower Bonus in minutes. This leaves a gap in the target''s memory they cannot account for, though they don''t realise it''s missing until something highlights its absence.',
6),

('Mental Interrogation', 2, 'Challenging (+0)', 'Short', '1 Creature', 'Sustained',
'You dive into your target''s mind, sifting through their memories and subconscious, uncovering their private thoughts and deepest secrets. Choose a creature within Short Range. The target must make a Challenging (+0) Discipline (Psychic) Test Opposing your Manifest Test. The target makes the Test with Disadvantage if it is unconscious, but it makes the Test with Advantage if it is hostile to you. If you win, you gain access to the target''s mind until the beginning of your next turn. If you win the Opposed Test but the target succeeds, it becomes aware of your intrusion. The difference in SL determines how deeply you penetrate according to the Mental Interrogation Table.

The power ends if the target is ever beyond Short Range from you. While you have access to the target''s mind, you can use a Free Action once on your turn to learn a number of pieces of information about it equal to your Intelligence Bonus, and memories play out in realtime, so you may need long-term access to the target to explore its mind thoroughly.

Mental Interrogation Table:
+1 SL: You can learn basic information about the target, such as name, age, mood, and general physical/mental health, as well as surface thoughts in the target''s mind, such as opinions about you, overarching motivations, immediate concerns, and conscious lies.
+2 SL: You can learn about an object, location, or creature significant to the target and the nature of its importance.
+3 SL: You can access the target''s memories of the last day from their perspective.
+4 SL: You can access the target''s memories of the last year from their perspective.
+5 SL: You can reveal the target''s innermost thoughts, feelings, motivations, fears, relationships, secrets, and agendas.
+6 or more SL: The target is an open book to you. You have full access to the target''s mind and the information within.',
6),

('Nightshroud*', 2, 'Challenging (+0)', 'Self', 'Your Zone', 'Sustained',
'Drawing on the Warp''s limitless darkness, you cast an illusion of ethereal shadows around you so your enemies see only inky darkness when they look your way. Until the start of your next turn, your Zone becomes Heavily Obscured. You and your allies can see through the Zone normally while within the Zone. A creature that notices the darkness and tries to see through it can use its Action on its turn to try to defeat the illusion. If it wins a Challenging (+0) Discipline (Psychic) Test Opposing your Manifest Test, the creature can see through the Zone normally and ignores the effects of this power for the next hour.',
6),

('Psychic Fortitude', 3, 'Hard (−20)', 'Short', 'SL Allies', 'Sustained',
'Drawing from the bottomless well of the Warp, you reach out with your mind to bolster your allies'' force of will with your own. Choose a number of allies (excluding you) up to the SL of your Manifest Test within Short Range. Until the start of your next turn, the targets may use your Willpower score in place of their own when making Willpower Tests, and they have Advantage on Willpower Tests.',
6),

('Psychic Shriek*', 3, 'Difficult (−10)', 'Medium', '2 Zones', 'Instant',
'Drawing a deep soul-breath, you unleash a scream that is silent in realspace but ripples through the underlying Warp with searing power, rending souls from bodies in an arc in front of you. Choose a Zone within Medium Range. Creatures (excluding you) in the target Zone and your Zone must make a Difficult (−10) Discipline (Psychic) Test Opposing your Manifest Test. If you win, the target suffers Damage equal to your Willpower Bonus plus the difference in SL, which ignores Armour. Daemons and Psykers suffer double Damage, but creatures without a Warp presence (such as Necrons and Nulls) are immune to this power.',
6),

('Telepathic Link', 3, 'Hard (−20)', 'Long', 'SL Allies', 'Sustained',
'You forge a telepathic link through the Warp between you and your allies, allowing you to communicate words and ideas with swift, silent efficiency. Choose a number of allies within Long Range equal to the SL of your Manifest Test. Until the start of your next turn, you and the target creatures can communicate telepathically. You can mentally share messages, emotions, and ideas instantaneously across any distance. If you and all your allies in an Encounter are telepathically linked, your Superiority can''t be less than 1.',
6),

('Terrifying Visions', 3, 'Hard (−20)', 'Medium', '1 Creature', 'Sustained',
'You turn an eldritch key to unlock your target''s deepest fears, confronting them with the most nightmarish recesses of their mind. Choose a creature within Medium Range. The target must win a Hard (−20) Discipline (Fear) Test Opposing your Manifest Test or become Terrified until the start of your next turn. Only the target can see the illusory source of their fear, and it appears within Immediate Range of the target at all times, even when the target moves. At the end of its turn, the target repeats the Opposed Test, ending the power immediately if it wins. Once a Creature wins the Opposed Test, it is immune to this power for one hour.',
6);
