-- Inquisition Supplement — Psychic Powers
-- Powers are added to existing disciplines (discipline_id matches psychic_powers_data.sql):
--   1 = Minor Psychic Powers, 2 = Biomancy, 3 = Divination, 4 = Pyromancy, 5 = Telekinesis, 6 = Telepathy

-- Minor Psychic Powers (IN)
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
SELECT name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book
FROM (VALUES

('Auditory Manipulation', 3, 'Difficult (−10)', 'Long', '1 Creature', 'Sustained',
'You stimulate a creature''s auditory system, generating subtle vibrations within that register as sound. Choose a creature within Long Range. Until the start of your next turn, you cause the target to hear any series of sounds you wish. Only the target hears these sounds. You can effectively speak to the target by forming specific words if you generate a voice.

If you generate an overwhelming noise, the target must make a Difficult (−10) Fortitude (Endurance) Test Opposing your Manifest Test, ending the power immediately if it wins. If it loses, it becomes Deafened until the power ends.

Specialisation in Biomancy applies to this power''s Manifest Test.', 1, 'IN'),

('Cipher Seed', 1, 'Easy (+40)', 'Immediate', '1 Creature', 'Permanent',
'You speak a short message, burying it deep within a creature''s subconscious until the intended recipient''s presence triggers the messenger to recite it unwittingly. Choose a creature within Immediate Range and speak up to 5 words per SL of your Manifest Test. The creature must be capable of speech and hear you speak to be a valid target. The target''s mind stores the memory subconsciously; it doesn''t remember what you spoke or that you implanted a message at all.

When you implant the message, you must also choose a specific name or discernable type of creature as the recipient, which remains unknown to the target. The next time the target is within Immediate Range of the recipient, it recites your implanted message aloud, exactly as you spoke it, though in its own voice. The target doesn''t remember what it speaks, nor does it remember the delivery.

Specialisation in Telepathy applies to this power''s Manifest Test.', 1, 'IN'),

('Force Bolt', 3, 'Hard (−20)', 'Long', '1 Creature or Object', 'Instant',
'With a glance, you hurl a bolt of telekinetic force at your target, smashing it with an unseen blow. Choose a creature or object within Long Range. The target suffers Damage equal to 3 + your Willpower Bonus + the SL of your Manifest Test. If the target is a creature, you choose the location that suffers the Damage.

Specialisation in Telekinesis applies to this power''s Manifest Test.', 1, 'IN'),

('Immolation Directive', 2, 'Challenging (+0)', 'Immediate/1 metre per SL', '1 Object', 'Permanent',
'You impart a small object with a smouldering mote of the Warp''s destructive power. Touch an object with Encumbrance 0 and choose a triggering condition. If that condition occurs, the object disintegrates in warp-fuelled flame, destroying it instantly, leaving only ashes or slag.

For example, you could cause a parchment or dataslate to combust once someone reads the message on it. A small cog within a larger device could melt when any person passes near it, sabotaging the machine. A bauble in your hand could burn when a specific person or object comes within range, indicating they are near when you might otherwise be unaware. A placard near a door could melt when someone circumvents the door''s lock, evidencing the crime. You could also simply have the target destroy itself after a set amount of time passes.

The trigger must be simple and unambiguous. The condition must occur near the target (within 1 metre per SL of your Manifest Test) to activate the effect.

Specialisation in Pyromancy applies to this power''s Manifest Test.', 1, 'IN'),

('Mark*', 2, 'Average (+20)', 'Immediate', '1 Creature or Object', '1 Day per SL',
'You mark a surface with a physical symbol of your psychic power that is impossible to remove or deface. Touch a creature or object within Immediate Range. When you withdraw your hand, you leave behind an arcane symbol lasting for 1 day per SL of your Manifest Test. The symbol is physically visible and, therefore, can be physically obscured. However, psykers or those psychically attuned can see the mark within Medium Range through any barrier or means to obstruct it physically.

Applying the mark is evident under normal circumstances, but you can attempt to apply it undetected with a Challenging (+0) Dexterity (Sleight of Hand) Test.

Specialisation in Divination applies to this power''s Manifest Test.', 1, 'IN')

) AS v(name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
WHERE NOT EXISTS (SELECT 1 FROM psychic_power p WHERE p.name = v.name);

-- Biomancy (IN)
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
SELECT name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book
FROM (VALUES

('Induce Panic', 3, 'Hard (−20)', 'Medium', '1 Creature', 'Sustained',
'You assail a creature''s biochemistry, sending its nervous system into a state of acute stress, resulting in a chemically-induced panic that circumvents training and mental discipline. Choose a creature within Short Range. The target must make a Hard (−20) Fortitude (Endurance) Test Opposing your Manifest Test. If it wins, the power ends immediately. If it loses, the target becomes Frightened of every other creature it sees, including its allies, until the start of your next turn.

If the target begins its turn within Immediate Range of a creature it fears, it must use its Action to make a melee attack against that creature, lashing out in panic. If there is more than one applicable target, determine the target randomly (including allies).

At the end of the target''s turn, it repeats the Opposed Test. Once a target wins the Opposed Test, it is immune to this power for the next hour.', 2, 'IN'),

('Ossify', 3, 'Hard (−20)', 'Medium', '1 Creature', 'Sustained',
'Hijacking an enemy''s biochemistry, you force their joints and muscles to stiffen beneath a rampant overproduction of calcified tissue. Choose a creature within Medium Range. The target must win a Hard (−20) Fortitude (Pain) Test Opposing your Manifest Test or become Overburdened until the start of your next turn.

At the end of the target''s turn, it repeats the Opposed Test, ending the power immediately if it wins. If you win the initial Opposed Test or any subsequent ones by a number of SLs greater than the target''s Toughness Bonus, the target also becomes Restrained. Once the target wins the Opposed Test, it is immune to this power for the next hour.', 2, 'IN'),

('Stimulating Jolt*', 3, 'Difficult (−10)', 'Immediate', '1 Creature', '1 Round/SL',
'You flood a creature''s nervous system with a jolt of psychic energy, briefly bolstering it against fatigue and rendering it incapable of losing consciousness. Touch a creature (including yourself) within Immediate Range. For a number of Rounds equal to the SL of your Manifest Test, the target ignores the effects of the Fatigued and Unconscious Conditions. Though this power suppresses their effects, it doesn''t remove the Conditions. If a Condition''s duration outstrips the duration of this power, the Condition''s effects resume when the power ends.

The stimulation this power generates is intensely traumatic to nervous systems, so if the target benefits from this Power again before it Rests, it takes 1d10 Damage, ignoring Armour. This damage can''t be prevented or reduced.', 2, 'IN')

) AS v(name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
WHERE NOT EXISTS (SELECT 1 FROM psychic_power p WHERE p.name = v.name);

-- Divination (IN)
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
SELECT name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book
FROM (VALUES

('Discern Falsehoods*', 1, 'Challenging (+0)', 'Self', 'Your Zone', 'Sustained',
'You enter an extremely receptive state, attuning your senses to detect the subtle ripples false words leave amongst the Warp''s undulating currents. You remain in this state until the start of your next turn. While in this state, you receive information about words spoken within your Zone depending on the SL of your Manifest Test: +1 to +2 SL — when someone speaks an outright lie; +3 to +4 SL — when someone speaks something technically true, or with deceptive intent; +5 or more SL — a general idea of the speaker''s motivation for speaking a falsehood (greed, duress, malice, etc.).

You need not understand the words spoken, but you must hear them and they must be spoken in person — recordings or vox transmissions do not carry the weight of the lies they bear.

This power is painful to your hyper-receptive senses. Each time you use this power, the first time you detect a falsehood in the encounter, you bleed from the ears and gain the Bleeding Condition, which ends when this power ends.', 3, 'IN'),

('Pathfinder', 2, 'Challenging (+0)', 'Short/Self', 'Self', 'Sustained',
'You peer into a creature''s past, examining the Immaterium to see the path their soul has taken through physical reality. Choose a creature within Short Range. Until the start of your next turn, you can see the target''s past location every moment for the last 1 minute per SL of your Manifest Test. You don''t actually see the target or what it was doing; you perceive a trail you can follow to learn the target''s recent whereabouts.

You continue to see the path wherever it leads until the power ends, even if the target is no longer in your Zone. You don''t see the target''s location at any point after you activated this power; you only perceive the trail from that point backwards.', 3, 'IN'),

('Piercing Sight*', 3, 'Difficult (−10)', 'Self', 'Self', 'Sustained',
'Your eyes shine brightly with baleful light as your sight adjusts to recognise hidden details and patterns while transcending the limitations of conventional sight. Until the start of your next turn, you have Advantage on Awareness, Intuition, and Linguistics (Cypher) Tests, providing the Test relies on sight. Additionally, you can see through solid objects (up to 1 metre per SL of your Manifest Test) as though they were transparent, and you can see in total darkness. Your eyes cast light throughout your Zone, suppressing the Dark and Poorly Lit Environmental Traits.', 3, 'IN')

) AS v(name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
WHERE NOT EXISTS (SELECT 1 FROM psychic_power p WHERE p.name = v.name);

-- Pyromancy (IN)
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
SELECT name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book
FROM (VALUES

('Impart Flame*', 2, 'Challenging (+0)', 'Special', '1 Object', '1 Hour per SL',
'With careful focus, you impart a spark of the Warp''s roiling, destructive nature into an object. Touch an object with Encumbrance 0 within Immediate Range while concentrating for 1 minute. When finished, the object holds a mote of pyrokinetic potential for a number of hours equal to the SL of your Manifest Test. The charged object can be left in place, thrown, or given away as normal, but you sense its presence within Long Range.

While you can detect the object, you can use an Action to release the power stored within. You can make the object emit a small, illuminating flame for the remainder of its duration, or you can destroy it instantly, either in an explosion or a momentary gout of roaring flames.

If used as an explosive: Damage 3 + WilB, Enc 0, Traits: Blast, Loud. For the purposes of the Blast Trait, creatures make Reflexes (Dodge) Tests Opposing your Manifest Test. If used to make a fiery eruption: Traits: Inflict (Ablaze), Spread. Charging the object is an Overt use of psychic power, but releasing the charge isn''t.', 4, 'IN'),

('Pass Through Fire*', 2, 'Challenging (+0)', '1 Zone per SL', 'Special', 'Instant',
'From the perspective of a creature in the Immaterium, one fire in realspace is fundamentally the same as another, and exploiting that commonality allows you to step into one fire and emerge from another, eliminating the space in between. You can sense fires large enough for you to stand in within a number of Zones equal to the SL of your Manifest Test. If you are within Immediate Range of such a fire, you can enter the flames, teleporting within Immediate Range of another fire you can sense. If you would take damage from entering the flames, reduce the damage by an amount equal to double your Willpower Bonus.', 4, 'IN'),

('Circle of Fire*', 3, 'Difficult (−10)', 'Medium', 'Zone', 'Sustained',
'You carve a ringlike rent in realspace, allowing the Warp to pour through as an encircling wall of intense flames. Choose a Zone within Medium Range. Until the start of your next turn, a 3-metre tall, 1-metre wide wall of fire appears along the entire border of the target Zone. Each creature or object crossing into or out of your Zone through the flames suffers Damage equal to 3 + your Willpower Bonus + the SL of your Manifest Test.

Additionally, creatures have Disadvantage on Awareness (Sight) Tests and Ranged Tests when looking through the flames into or out of the Zone.', 4, 'IN')

) AS v(name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
WHERE NOT EXISTS (SELECT 1 FROM psychic_power p WHERE p.name = v.name);

-- Telekinesis (IN)
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
SELECT name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book
FROM (VALUES

('Burden', 4, 'Very Hard (−30)', 'Medium', 'WpB Creatures', 'Sustained',
'You channel the Warp to amplify gravity''s pull on your foes, burdening them beneath the magnified weight of their own mass. Choose a number of creatures within Medium Range up to your Willpower Bonus. Each target must make a Very Hard (−30) Athletics (Might) Test Opposing your Manifest Test. Each target that loses the Opposed Test is Overburdened until the start of your next turn.

At the end of each target''s turn, it repeats the Opposed Test, losing the Overburdened Condition immediately if it wins. Once a target wins the Opposed Test, it is immune to this power for the next hour.', 5, 'IN'),

('Psychic Blade*', 2, 'Average (+20)', 'Self', 'Self', 'Sustained',
'With a flourish of your outstretched hand, you conjure a sword of coruscating force into your grasp. Until the start of your next turn, you can wield the sword in either hand as a weapon with the following profile: Name: Psychic Blade, Specialisation: One-Handed, Damage: 3 + WilB, Enc: 0, Traits: Penetrating (X).

With sufficient mastery you can hone the plane of force comprising the blade''s edge to impossible sharpness. The X of the sword''s Penetrating Trait equals the SL on your Manifest Test. The sword disappears if it leaves your hand, ending this power immediately.', 5, 'IN'),

('Tether', 3, 'Difficult (−10)', 'Medium', '1 Creature and 1 Object', 'Sustained',
'You manifest an intangible strand of telekinetic force to bind an object to a creature, preventing them from being separated. Choose an object and a creature within Medium Range. Both targets must be within Immediate Range of each other. Until the start of your next turn, the object and creature must remain within Immediate Range of each other. If the creature tries to move beyond this range, it must use an Action to win a Difficult (−10) Athletics (Might) Test Opposing your Manifest Test to sever the bond and end this power. If it loses, it can''t move beyond Immediate Range of the object.

If another creature tries to move one of the targets beyond Immediate Range of the other, it must use an Action to win a Difficult (−10) Athletics (Might) Test Opposing your Manifest Test to sever the bond and end this power.', 5, 'IN')

) AS v(name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
WHERE NOT EXISTS (SELECT 1 FROM psychic_power p WHERE p.name = v.name);

-- Telepathy (IN)
INSERT INTO psychic_power (name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
SELECT name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book
FROM (VALUES

('Hallucinate', 4, 'Very Hard (−30)', 'Medium', '1 Creature per WilB', 'Sustained',
'You flood creatures'' minds with insidious power, causing them to hallucinate illusory situations fabricated at your whim. Choose a number of creatures up to your Willpower Bonus within Medium Range. Each target must make a Very Hard (−30) Intuition (Surroundings) Test Opposing your Manifest Test. Until the start of your next turn, each target that loses the Test perceives an illusory phenomenon of your choosing. The hallucination appears within a Zone of your choice within Medium Range, and each target perceives the same phenomenon simultaneously.

When you use your Action to manifest this power, you can alter the illusion during the Round. You must use your Action each subsequent turn to continue altering the hallucination. If you don''t concentrate on updating the hallucination, it remains convincing but repeats the previous round''s details.

Because the hallucination seems real to the targets, physical interaction cannot expose the illusion as false. At the GM''s discretion, a target may repeat the Opposed Test at the end of its turn if the hallucination presents a suspicious or unbelievable situation. Once the target wins the Opposed Test, it is immune to this power for the next hour.', 6, 'IN'),

('Insinuate', 3, 'Difficult (−10)', 'Short', '1 Creature', 'Sustained',
'Draping skeins of subtle empyrean influence over a creature''s mind, you instil it with feelings of familiarity and trust toward you. Choose a creature within Short Range. The target must win a Difficult (−10) Discipline (Psychic) Test Opposing your Manifest Test or be forced to regard you as a trusted friend until the start of your next turn. Whether you win or lose the initial Test, the target is unaware of your attempt.

Whenever the target takes Damage, and at the end of its turn, it repeats the Opposed Test. If it wins, the power ends immediately, and the target realises you tampered with its mind. Once the target wins any of the Opposed Tests, it is immune to this power for the next hour.', 6, 'IN'),

('Pacify', 3, 'Difficult (−10)', 'Medium', '1 Creature per WilB', 'Instant',
'You momentarily disconnect creatures from their emotions, interrupting their feelings as though turning off a switch. Choose a number of creatures up to your Willpower Bonus within Medium Range. Each target must win a Difficult (−10) Discipline (Psychic) Test Opposing your Manifest Test or succumb to this power. A target can choose not to Oppose if it''s aware you''re using this power. Each affected target loses the Frightened Condition and instantly stops experiencing any emotion it currently feels. If circumstances cause a target to feel emotions later, they experience them normally.

For example, you can snap a Frightened ally back to their senses, but they could become Frightened again later. You could cause a furious creature to stop attacking by removing its anger, but it might resume hostilities if you provoke it later.', 6, 'IN')

) AS v(name, warp_rating, difficulty, range, target, duration, effect, discipline_id, source_book)
WHERE NOT EXISTS (SELECT 1 FROM psychic_power p WHERE p.name = v.name);