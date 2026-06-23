-- Imperium Maledictum Core Rulebook pp. 207–210
-- Combat Actions
INSERT INTO combat_action (name, description) VALUES
('Aim',
 'A single well aimed shot is worth a hundred that miss their mark. When you use your action to Aim, you take your time to steady your hand before shooting. On your next turn, the Range of your weapon increases by one step (Medium becomes Long, Long becomes Extreme), and you may target a hit location (page 211) without any penalty. As soon as you have fired, or if you move after taking the Aim Action, this benefit is lost. You cannot combine an Aimed Shot with Rapid or Burst Fire.'),

('Attack',
 'In a galaxy of heretics, xenos, and worse, violence is to be welcomed. When you swing your Chainsword, fire your Laspistol, or hurl a Frag Grenade, you are taking the Attack Action. You make a Test to try to hit a target with a melee or ranged weapon. This is explained in detail in Making an Attack on page 211.'),

('Charge',
 'You throw your encumberance and momentum into a powerful attack. When you Charge, you can move as far as your Speed allows and make a melee attack with Advantage. You can''t Charge a target in your Zone. You have Disadvantage on Melee and Reflexes Tests to defend yourself until the start of your next turn. If you take the Charge Action while controlling a mount or a bike, you use their Speed instead of yours, but you still make the attack. Both you and your mount have Disadvantage on Melee and Reflexes Tests to defend yourselves until the start of your next turn.'),

('Defend',
 'You do everything you can to protect an ally or defend a location. When you take this Action, choose an ally in Immediate Range to Defend. Until the start of your next Turn, any attacks that target the chosen ally target you instead. If your ally is targeted by a melee attack, you roll to oppose and suffer any Damage. Any ranged attacks against your ally hit you instead. Your ally is still affected by Environmental Traits, psychic powers, and effects that target your Zone. If more than one character is defending the same ally, the players can choose which character is the target of any attacks. You can also use this Action to defend the Zone you are occupying. When you do so, you block, guard, or otherwise impede entry to the Zone from one other Zone. Tell the GM which Zone you are blocking entry from, and they will decide if it is feasible to do so. Any creature attempting to enter the Zone must use an Action to make an Athletics (Might) Test opposed by your Athletics (Might). If you are wielding a shield or an ally takes the Defend Action to help, you have Advantage on this Test. On a failure, the creature is barred from entering your Zone. On a success, you are pushed aside and the creature can enter the Zone. When you are defending a Zone, enemies in the adjacent Zone can make melee attacks against you. You oppose the attack as normal.'),

('Disengage',
 'What some call cowardice, others merely label good sense. When you attack or are attacked by a creature within Immediate Range you are Engaged with that target. If you try to move away, your opponent can make an immediate attack against you as a Reaction. When you use the Disengage Action, you carefully back away and keep your defences up. You move beyond Immediate Range of the target and are no longer Engaged. Disengaging in this way prevents enemies from getting a free attack against you when you move away from them.'),

('Dodge',
 'Some people say the best defence is a good offence. But those people are probably dead, with a combat knife embedded in them. When you Dodge, you spend your turn trying to avoid harm. Until the start of your next turn, you have Advantage on the next Melee or Reflexes (Dodge) Test you make to defend yourself. Additionally, until the start of your next turn, you may make a Reflexes (Dodge) Test to avoid ranged attacks made against you by enemies you are aware of. This does not use your Reaction.'),

('Flee',
 'Sometimes the ravages of battle can take their toll and you can simply no longer stand and fight. Rather than risk a grisly death, you can choose to Flee. To do this, you must declare at the start of your turn that you intend to Flee. You spend both your Action and Move to escape the battle. You are no longer involved in the combat and can take no further actions. You are removed from the Initiative and Superiority decreases by 1. Alternatively, the group can choose to Retreat, as detailed on page 209.'),

('Grapple',
 'To Grapple, make an Athletics (Might) or Melee (Brawling) Test, opposed by the target''s Athletics (Might), Melee (Brawling), or Reflexes (Dodge). If you succeed, the target is Restrained (Minor). You can release the Grapple at any time. On their turn, the creature can use an Action to try to escape the Grapple by repeating the Opposed Test. You can use your Action to continue the Grapple without a Test. If you suffer a Wound, or use an Action to do anything other than continue the Grapple, the target may use their Reaction immediately afterwards to attempt to break the Grapple. If one party is one size larger than the other, the larger party has Advantage on the Test. If one party is two or more sizes larger than the other, the larger party has Advantage and the smaller party has Disadvantage. If you attempt to grapple a target two or more sizes larger than you, you can only grapple a single limb or body part. The target is not Restrained, but suffers one of the following effects: Arms (or Tail) — the target has Disadvantage on attacks using that limb; Legs — the target''s Speed is reduced one step.'),

('Help',
 'To stand alone in the face of a hostile galaxy is to meet a swift death. When you take the Help Action, you assist an ally on their next Test, granting them Advantage. Getting Help is explained in detail on page 189.'),

('Hide',
 'When faced with a kill squad intent on violence scouring your base, absence may be the better part of valour. When you Hide, you make a Stealth Test and use the environment to conceal your presence. You should record the number of SL you achieve on this Test, as anyone trying to find you must gain a greater number of SL on Awareness Tests made to locate you. The Zone you are hiding in must have some feature that you can use to mask your movements, such as the Cover or Obscured Traits. When you Hide, your Speed is reduced to Slow. You can use your Move to move within your Zone, but must use the Run Action to reach an adjacent Zone. Hidden characters can''t be the target of an attack unless the attacker succeeds on an Awareness Test opposed by your Stealth. An individual can use the Search Action on a Zone to attempt to locate you. You are no longer Hidden if you take an Action that reveals your location, such as making an attack using a weapon with the Loud Trait. Every successful attack made while hidden counts as a Critical Hit.'),

('Improvise',
 'This list does not represent the limits of what you can do in combat. If you have a clever idea but don''t see an appropriate Action listed, you can Improvise. Tell your GM what you want to do. They will tell you if it''s possible and if you need to make a Test.'),

('Manifest',
 'You open your mind to the unnatural power of the warp and attempt to bend it to your will. When you take the Manifest Action, you attempt to Manifest a psychic power. Full rules for using psychic powers begin on page 158.'),

('Overwatch',
 'Knowing how and when to act is vital during the chaos of battle. When you use Overwatch, you prepare yourself to act when a specific event happens. You must declare the trigger for your Overwatch, and the Action you will take when it happens. For example, you might say "When the Ganger rounds the corner I''m going to try to shoot it with my Laspistol", or "After Kalli throws the frag I''m going to run." If the trigger for your Overwatch doesn''t happen this turn, you may take a different Action, acting last in the Initiative order for the round.'),

('Reload',
 'In combat, every bullet counts, and an empty magazine can mean certain death. When a ranged weapon is out of ammunition, you must use the Reload Action before it can be fired.'),

('Retreat',
 'Sometimes a tactical retreat is more prudent than a martyr''s glorious end. If you feel that the tide of battle has turned against you and your allies, you can call for a Retreat. When you take the Retreat Action, your turn ends as you prepare to retreat to safety along with your allies. At the start of each of your allies'' turns, the GM asks if they will Retreat. If they agree, they join you in preparing for a guarded retreat. If all of your allies agree to retreat, the group safely escapes the battle. The GM can decide to jump ahead in time to a point where you have reached a safe location or, for particularly tenacious foes, initiate a Pursuit. As you retreated as a cohesive unit, you and your allies may apply Superiority to Tests to escape your pursuers. If you call for a Retreat and any member of your party refuses, you and any allies that chose to Retreat can abandon the retreat and remain in the battle, or continue the retreat and leave your allies to their fate. Regardless of whether you remain or retreat, the disharmony in the group reduces Superiority by 2.'),

('Run',
 'Sometimes you just need to get to (or away from) your enemies as quickly as possible. The Run Action allows you to move to an adjacent Zone (any point within Medium Range). It is often combined with a Move to allow a character to reach a location up to two Zones away.'),

('Search',
 'You need to find something, be it an enemy, an object, or something else entirely. When you take the Search Action, you take time to examine your surroundings, perhaps looking for a clue or an enemy who has slipped away. The GM asks for an Awareness (Sight) Test, setting the Difficulty as required. At the GM''s discretion, you can also use Search to get a sense of your surroundings. This sometimes involves detecting an almost imperceptible disturbance in the immaterium, or trying to sense hidden danger. In this case, the GM may ask for an Awareness (Psyniscience), Intuition (Surroundings), or other such Test.'),

('Seize the Initiative',
 'Be first and be better. Sometimes foregoing an attack now can pay off later in the combat. When you Seize the Initiative, you do not act this turn but instead go to the top of the Initiative order at the start of the next round. You remain at the top of the Initiative order until someone else takes the Seize the Initiative Action to move ahead of you, or another effect causes the Initiative order to change.'),

('Shove',
 'Sometimes you might want to make a little space to give yourself some breathing room. When you take the Shove Action, you attempt to push an enemy away from you. You can attempt to Shove a creature within Immediate Range. To Shove a creature, you must make an Athletics (Might) Test opposed by the target''s Athletics (Might) or Dodge (Reflexes). If you succeed, the target is shoved a number of metres away equal to the difference in SL, and you are no longer Engaged with them. If you succeed by 3 or more SL, you can choose to Shove the target into an adjacent Zone.'),

('Take Cover',
 'When you Take Cover, you use the environment to provide protection against ranged attacks. If you enter a Zone with the Cover Trait, you can use the Take Cover Action to gain its benefit. Light Cover provides +2 Armour against ranged attacks, Medium Cover provides +4 Armour against ranged attacks, and Heavy Cover provides +6 Armour against ranged attacks. It is possible for skilled shooters to bypass cover using the Target Location Action.'),

('Target Location',
 'Many combatants in the 41st Millennium have patchwork armour, or can only afford protection in some vital spot. Aiming for unprotected areas can provide a quick route to victory. When you use the Target Location Action, you are choosing to target a particular Hit Location. Tell the GM where you are targeting and make a melee or ranged attack at Disadvantage. On a success, ignore the unit die to determine Hit Location and deal Damage to the chosen location instead. If your target is in cover, you can use this Action to ignore bonus Armour gained from cover. In most cases, you can only aim the head or arms of a target in cover, as those are the only parts of the body likely to be exposed. The GM may rule that different Hit Locations are possible depending on specific situation, the position of the target, or the type of cover.'),

('Use an Object or Feature',
 'Most of the time you don''t need to use an Action to interact with or manipulate an object, like drawing your weapon, taking something out of your pack, flicking a switch, or opening a door. However, if something requires more time or is more complex, such as activating a Zone Feature, the GM may decide it requires an Action. In this case, you take the Use an Object or Feature Action.');