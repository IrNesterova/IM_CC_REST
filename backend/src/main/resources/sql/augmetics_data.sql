-- =====================================================================
-- AUGMETICS DATA
-- Seeds AUGMETIC REPLACEMENTS (core IM), AUGMETICS (AM supplement),
-- and AUGMETICS (MR supplement)
-- Migrates any existing rows from generic_item to augmetic subtype table
-- Safe to re-run (idempotent)
-- =====================================================================
-- TODO: заполнить таблицу inventory для всех аугметиков:
--   - availability   (Scarce / Rare / Exotic / ...)
--   - cost           (в солярах)
--   - encumbrance
--   - source_book    (IM / AM / MR)
-- =====================================================================

-- =====================================================================
-- 1. ENSURE INVENTORY ROWS EXIST
-- =====================================================================
INSERT INTO inventory (name, inventory_category)
SELECT name, 'AUGMETIC_REPLACEMENTS' FROM (VALUES
    ('Augmetic Arm'),
    ('Augmetic Heart'),
    ('Augmetic Leg'),
    ('Augmetic Respiratory System'),
    ('Augmetic Sensory Organs (Eyes)'),
    ('Augmetic Sensory Organs (Ears)'),
    ('Augmetic Sensory Organs (Nose)'),
    ('Augmetic Tracks/Wheels'),
    ('Simple Prosthesis')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);

INSERT INTO inventory (name, inventory_category)
SELECT name, 'AUGMETIC' FROM (VALUES
    -- AM core augmetics (Imperium Maledictum)
    ('Augur Array'),
    ('Ballistic Mechadendrite'),
    ('Biomechanical Interface'),
    ('Calculus Logi Upgrade'),
    ('Manipulator Mechadendrite'),
    ('Medicae Mechadendrite'),
    ('Optical Mechadendrite'),
    ('Utility Mechadendrite'),
    ('Vocal Implant'),
    -- MR augmetics
    ('Aortic Supercharger'),
    ('Augmetic Organs'),
    ('Implanted Weapon'),
    ('Internal Compartment'),
    ('Skinplant'),
    ('Toxiphage'),
    -- AM supplement augmetics
    ('Achillan Eye'),
    ('Antigrav Core'),
    ('Autosanguine Implant'),
    ('Binary Cortex'),
    ('Cranial Circuitry (Initiation)'),
    ('Cyber Mantle (Initiation)'),
    ('Electoo Matrix'),
    ('Electoos (Initiation)'),
    ('Electro-Grafts (Initiation)'),
    ('Eye of Serberys'),
    ('Incense Exhaust'),
    ('Injector Rig'),
    ('Mechadendrite Hive'),
    ('Mechadendrite Stabilisers'),
    ('Neurostatic Generator'),
    ('Potentia Coils (Initiation)'),
    ('Pteraxii Talons'),
    ('Pteraxii Wing-pack'),
    ('Rite of Pure Thought'),
    ('Sanctus Canister'),
    ('Secutor-Class Blade Implant'),
    ('Servo Arm'),
    ('Sicarian Pattern Legs'),
    ('Vanguard Radium Core'),
    ('Voltagheist Blast Unit'),
    ('Voltagheist Field'),
    ('Weapon Arm'),
    -- Data-tethers (AM supplement)
    ('Battle-sphere Uplink'),
    ('Data-Tether'),
    ('Dataspike'),
    ('Noospheric Data-Tether')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM inventory i WHERE i.name = v.name);

-- =====================================================================
-- 2. MIGRATE ALL AUGMETIC INVENTORY ROWS INTO augmetic SUBTYPE TABLE
-- Removes from generic_item (if present), inserts into augmetic
-- =====================================================================
DO $$
DECLARE r RECORD;
BEGIN
    FOR r IN
        SELECT i.id FROM inventory i
        WHERE i.inventory_category IN ('AUGMETIC', 'AUGMETIC_REPLACEMENTS')
    LOOP
        DELETE FROM generic_item WHERE id = r.id;
        INSERT INTO augmetic (id, description) VALUES (r.id, '') ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- =====================================================================
-- 3. UPSERT DESCRIPTIONS
-- Only fills in description where it is currently empty
-- =====================================================================
WITH descriptions(name, descr) AS (VALUES
    ('Augmetic Arm',
     'Among the more common augmetic parts in the Imperium, these limbs can be seen everywhere from battlefields to manufactorums.
• The arm grants +1 Armour, which is added to any other Armour in the location.
• You gain +1 SL to all Strength-based Tests using the arm, and melee attacks with the arm deal +1 Damage.
• If you have two augmetic arms, you gain +2 SL to Strength-based Tests using both arms, and deal +2 Damage with Two-handed melee weapons.'),

    ('Augmetic Heart',
     'Augmetic hearts are rare outside of the Adeptus Mechanicus, as severe damage to the heart usually spells death too quickly for surgical replacement.
• As an Action, you can make a Challenging (+0) Fortitude Test to remove the Bleeding (Minor) Condition.
• As an Action, you can make a Hard (−20) Fortitude Test to remove the Bleeding (Major) Condition.'),

    ('Augmetic Leg',
     'Legs are sometimes lost to industrial accidents, or infections contracted in the deathworld swamps. Augmetics restore a user''s locomotion, and tend to be more robust than their owner''s original limbs.
• The leg grants +1 Armour, which is added to any other Armour in the location.
• You gain +1 SL to all Strength-based Tests using the leg, such as kicking in a door.'),

    ('Augmetic Respiratory System',
     'These artificial lungs and filtration-fibres are valued replacements that can repair organs lost due to inhaling smoke, flames, acidic gases, and other dangers.
• You gain +2 SL to Fortitude Tests to resist the effects of airborne toxins and poisonous gases.'),

    ('Augmetic Sensory Organs (Eyes)',
     'Sensory augmetics can be subtle or quite obvious — augmetic eyes are a highly regarded sign of status on many worlds. All have neurological interfaces to pass sensory information in the same manner as natural organs.
• You gain +1 SL to Awareness (Sight) Tests.
• If you have two augmetic eyes, you gain +2 SL instead.'),

    ('Augmetic Sensory Organs (Ears)',
     'Augmetic ears restore hearing lost to war or accident, with neurological interfaces to pass sensory information in the same manner as natural organs.
• You gain +1 SL to Awareness (Hearing) Tests.
• If you have two augmetic ears, you gain +2 SL instead.'),

    ('Augmetic Sensory Organs (Nose)',
     'Augmetic nasal replacements restore the sense of smell, with neurological interfaces to pass sensory information in the same manner as natural organs.
• You gain +1 SL to Awareness (Smell) Tests.'),

    ('Augmetic Tracks/Wheels',
     'Commonly seen on several forms of Servitors, track or wheel assemblies are occasionally issued to those who have lost both their legs. Your new form of locomotion grants +1 Armour, which is added to any other Armour in the location. In clear Zones suitable for tracks or wheels, your Speed is now Fast. However, the GM may rule that cluttered Zones count as Difficult Terrain for you.'),

    ('Augur Array',
     'This complex cortical implant enhances the user''s sensory detection in ways otherwise impossible for mere flesh.
The user''s senses gain the abilities of an Auspex, revealing energy, life signs, movement, and other data within Medium Range. The user also gains +5 Perception.'),

    ('Ballistic Mechadendrite',
     'Mechadendrite. The Mechadendrite is fitted with a Laspistol that never needs reloading.
Each Mechadendrite counts as a separate augmentation towards the maximum number a character can possess.'),

    ('Biomechanical Interface',
     'This implant allows its bearer to issue basic orders and commands to suitably configured systems such as cogitator arrays, basic automated industrial equipment and even some Servitors.
The user gains +1 SL to Tech Tests when operating a machine with a suitable connection, or issuing orders to a suitably equipped cybernetic servant.'),

    ('Calculus Logi Upgrade',
     'A Calculus Logi Upgrade adds cogitator mechanisms to the brain, aiding and speeding the recall and processing of information.
The user can perform simple mathematics instinctively, gaining +1 SL on any Logic (Mathematics) Tests. The user also gains +5 Intelligence.'),

    ('Manipulator Mechadendrite',
     'Mechadendrite. This hefty Mechadendrite aids in heavy lifting.
When using a Manipulator Mechadendrite, you gain +2 SL to Strength-based Tests, and −1 SL to Dexterity Tests. It can also be used as an Improvised Melee Weapon (Two-handed).'),

    ('Medicae Mechadendrite',
     'Mechadendrite. This device includes scalpels, bonesaws, and skin-sealants for surgical support.
The Mechadendrite counts as having a Chirurgeon''s Kit for Tests that require one. Unlike a standard Chirurgeon''s Kit, a Medicae Mechadendrite''s advanced tools do not have a limited number of uses and only need to be replaced if the device is broken.'),

    ('Optical Mechadendrite',
     'Mechadendrite. Optical Mechadendrites are usually a metre longer than typical mechadendrites, allowing them to pass through crowded mechanisms and cramped areas to gain visual data.
When using the Optical Mechadendrite, you gain +1 SL to Awareness (Sight) Tests and ignore the effects of Poorly Lit and Dark Zones due to the integrated Stablight. You can also use these to look around corners, over the heads of a thronging crowd, and in many other inventive ways.'),

    ('Utility Mechadendrite',
     'Mechadendrite. These are fitted with several devices for repairing and renovating machines, and are the most common form of Mechadendrite.
They count as a Standard Quality Combi-Tool, granting +2 SL to Tech Tests, and can be used in melee combat as an Improvised Melee Weapon (One-handed).'),

    ('Vocal Implant',
     'These implants allow for stentorian vocal effects and see impressive use in a variety of factions.
When using a Vocal Implant, your voice or other sounds you play or generate can be easily heard up to 100 metres away.'),

    ('Simple Prosthesis',
     'A common designation for basic prosthetic limbs issued to those who cannot afford advanced augmetics.
Functions identically to the standard augmetic counterpart (Augmetic Arm or Augmetic Leg) but does not provide +1 Armour or any bonus SL to related Tests. A character may choose to have a Simple Prosthesis as part of their starting equipment at no extra cost.'),

    ('Aortic Supercharger',
     'An augmetic reinforcement to the heart that enhances the bearer''s endurance to allow feats of stamina beyond what their body would otherwise be capable of. If installed and overused, the bearer''s circulatory system can suffer slow degradation through overworking.
Once per session, the bearer may choose to automatically pass a Test to resist becoming Fatigued.'),

    ('Augmetic Organs',
     'Commonplace among those with the power to obtain them, Augmetic Organs extend the bearer''s lifespan at a cost.
• +1 SL on Toughness Tests.
• Extends natural lifespan by 3 + 1d10 decades.
• Only function properly for around 50 years; must be replaced before they expire or they threaten the bearer''s life.
• Tests to heal the bearer in a manner related to their Augmetic Organs increase the Difficulty by one step.'),

    ('Implanted Weapon',
     'A weapon with an Encumbrance value of up to 3 can be attached as an Implanted Weapon, replacing a limb.
• Loses the Two-handed Trait, as it is wielded from its implant.
• When you take the Charge Action, you do not have Disadvantage on Melee and Reflex Tests to defend yourself in your next turn.
• If you take the Aim Action with an implanted ranged weapon, gain Advantage on the Aimed Shot.
• If the weapon replaces a limb in a hit location, that Hit Location has the same Armour value as the weapon''s Encumbrance value. You cannot have Armour applied to that location otherwise.
• The weapon''s Encumbrance does not count towards your total carry value.
• The cost of this Augmetic does not cover the cost of the weapon itself.'),

    ('Internal Compartment',
     'Small storage compartments nestled within living flesh, used to conceal weaponry or restricted goods.
Can hold an object with an Encumbrance value of 0, no bigger than the Compartment''s body area. A character can install a maximum number of Internal Compartments equal to half their Toughness Bonus, rounded down.'),

    ('Skinplant',
     'A common designation for microcrystalline intradermal implants. A Skinplant becomes visible through the skin of its bearer when subjected to a programmed stimulus, such as touch or light.
A Skinplant is installed with a trigger (touch, light, or a specific external control) and a display, which may be an image, a dim light, or a Chrono.'),

    ('Toxiphage',
     'An exceptionally advanced defensive augmetic, capable of detecting poison in its bearer''s body and releasing chemicals into the bloodstream to neutralise its effects.
A bearer of this augmetic may automatically pass the first Test to resist Poisoned once per day. If they are being poisoned surreptitiously, when the augment activates, it gives them a silent warning.'),

    -- ── AM SUPPLEMENT AUGMETICS ──────────────────────────────────────

    ('Cranial Circuitry (Initiation)',
     'Initiation augmetic. A series of implants and extensions that provide slight improvements to your brain''s functions and capabilities, and provide the framework and connectivity for all manner of further mind-expanding augmetics. Does not count towards a character''s augmetic limits.'),

    ('Cyber Mantle (Initiation)',
     'Initiation augmetic. Affixed along the length of your spine, the Cyber Mantle serves as an anchor for most augmetics implanted into your body — the means by which you can command mechadendrites and other ambulatory augmetics as additional limbs. Does not count towards a character''s augmetic limits.'),

    ('Electoos (Initiation)',
     'Initiation augmetic. Electrically stimulated subdermal synthetic inks that change in response to specific electrical conditions. Used for identification within the Adeptus Mechanicus. Does not count towards a character''s augmetic limits.'),

    ('Electro-Grafts (Initiation)',
     'Initiation augmetic. A subdermal skein of sensors, ports, and cabling through which you can more directly sense the electrical currents powering cogitators or similar devices, granting a near-communion with the machine spirit. Does not count towards a character''s augmetic limits.'),

    ('Potentia Coils (Initiation)',
     'Initiation augmetic. Connected to your Cyber Mantle, these coils store energy and power all your other augmetics. They can also be hooked into personal weapon systems. Does not count towards a character''s augmetic limits.'),

    ('Achillan Eye',
     'A scanning system mounted on a short augmetic limb, granting beyond-Human accuracy.
Targets you shoot at do not gain the benefits of Cover unless entirely obscured. In addition, you may reroll Severity Rolls when you score a Critical Hit.'),

    ('Antigrav Core',
     'An antigravitic generator allowing continuous levitation without true flight.
Allows you to hover 1–2 metres above the ground continuously unless deactivated. You ignore Difficult Terrain. Grants +2 SL on Athletics (Climbing) Tests.'),

    ('Autosanguine Implant',
     'Your blood is replaced with sanguinous medium bearing nanomachines that knit metallic shielding over torn blood vessels.
• You recover from the Bleeding Condition one round after receiving it.
• Advantage on Fortitude Tests to resist contamination of your blood (injected poisons, infectious wounds).
• Recover 1 Wound per day while the augmetic is active.'),

    ('Binary Cortex',
     'A second brain installed within your body, typically from a fellow Tech-Adept, enabling constant mental communication between two minds.
The second brain always takes the Help action on Intelligence-Based Skill Tests for Skills in which it had at least one Advance before removal. On a fumble at such a Test, gain the Stunned Condition for one round.
If struck by a Critical Wound to the head, 25% chance it hits the Binary Cortex instead. Destroyed by: Rattling Blow, Laceration, Concussive Blow, Shattered Skull.'),

    ('Eye of Serberys',
     'Grants holy vision to focus on a specific target regardless of their protective screen.
• When attacking a target protected by Cover provided by other characters, reduce the Armour they gain from Cover by 3.
• After taking the Aim or Search Action against a target, you gain Advantage on Tests to track them unless you completely lose sight of them for more than a few minutes.'),

    ('Incense Exhaust',
     'Transforms a waste-gas expulsion system into an embedded Omnissian censer, shrouding the bearer in sacred smog.
As an Action, your Zone becomes Lightly Obscured. You can continue emitting smog each turn or shut it off (no action required). Smog clears after 1d5 rounds once deactivated.'),

    ('Injector Rig',
     'Chem-phials and canisters feeding a network of hypodermic injectors. As a free action, inject one chem into yourself or a target within Immediate Range. Contains 5 doses of each chem (refill: 150 solars/dose, Scarce).
• FZ-392: +1 Strength Bonus, immune to Frightened. Lasts 1d10 rounds.
• SL-203: +1 Agility Bonus and +1 Perception Bonus, Speed becomes Fast. Lasts 1d10 rounds.
• SM-163: Ignore effects of Critical Wounds and Injuries for 1d10 + Toughness Bonus rounds.
• DT-474: Recover from Poisoned; Challenging (+0) Toughness Test or Stunned for 1d10 minutes.
20% chance of damage to rig on Critical Wound, inflicting Poisoned (Major) for 1d5 rounds.'),

    ('Mechadendrite Hive',
     'Up to four mechadendrites combined to count as only a single augmetic. Each mechadendrite is paid for individually in addition to the hive core.
Can be used as a Melee Weapon using the Eviscerator profile, so long as at least two mechadendrite limbs are free and functional.'),

    ('Mechadendrite Stabilisers',
     'A pair of sturdy clamping mechadendrites with gyroscopic sensors to compensate for gravitic shifts.
Prevent Disadvantage due to void environmental effects (ship rocking, zero gravity). As an Action, activate to stick to a ferromagnetic surface, ignoring zero/low gravity. In normal gravity: Challenging (+0) Athletics (Climbing) or Reflexes (Acrobatics) Test to walk on metallic walls and ceilings.'),

    ('Neurostatic Generator',
     'An augmetic device capable of emitting neural-disrupting static to disorient nearby enemies.'),

    ('Pteraxii Talons',
     'Taloned augmetic limbs used by the Pteraxii Skitarii, granting enhanced mobility and combat capability.'),

    ('Pteraxii Wing-pack',
     'An augmetic wing-pack granting flight capability, as used by the Pteraxii Skitarii.'),

    ('Rite of Pure Thought',
     'A rite and series of implants replacing the right hemisphere of the brain with a cogitator, purging all illogical qualities of emotion and creativity.
• Immune to the Frightened Condition.
• Advantage on all Logic Tests and Discipline (Composure) Tests.
• Disadvantage on Rapport (Charm) Tests.'),

    ('Sanctus Canister',
     'A pulsing cylinder that strengthens the bearer and inspires nearby members of the Machine Cult, emitting a blessed light when canticles are chanted.
• Advantage on Presence Tests made to affect, inspire, or command members of the Adeptus Mechanicus.
• Extends natural lifespan by d5 + 2 decades while fitted.'),

    ('Secutor-Class Blade Implant',
     'Dozens of retractable hidden blades implanted across the body, allowing surprise melee attacks.
You are always armed with implanted blades using the Knife profile with the Subtle and Penetrating (2) Traits, but without the Thrown (Short) Trait. Blades can be drawn or retracted at will.'),

    ('Servo Arm',
     'A large augmetic arm used for heavy lifting and industrial tasks, also capable of serving in combat.'),

    ('Sicarian Pattern Legs',
     'Hoofed digitigrade legs bearing advanced gyroscopic stabilisers. Must be fitted as a pair (cost is listed per pair).
• +1 Armour to each leg location.
• +1 SL to all Strength-based Tests using the legs (as a pair).
• Ignore the effects of Difficult Terrain.'),

    ('Vanguard Radium Core',
     'A radium core that constantly exudes baleful radiation, contaminating those nearby.
Non-Adeptus Mechanicus characters who share a Zone with you become Poisoned (Minor). Does not stack with other Vanguard Radium Core effects or the Rad-saturation Trait.'),

    ('Voltagheist Blast Unit',
     'Extensions to the bearer''s electoo network enabling release of stored Motive Force as a concentrated electrical burst.
As an Action, expend any number of Motive Force Charges to deal 1 Damage per charge (ignoring Armour) to each other character within Short Range. Characters can spend their Reaction to dodge as if dodging a Grenade blast.'),

    ('Voltagheist Field',
     'A defensive force field utilising the Motive Force to protect the bearer against incoming attacks.
Spend your Reaction plus any number of Motive Force Charges to gain +1 Armour per expended charge for that attack only. If you make a successful attack with Electrostatic Gauntlets or an Electroleech Stave, until the beginning of your next turn you gain +2 Armour per expended charge instead.'),

    ('Weapon Arm',
     'Replace an arm with a melee or ranged weapon (additional cost of the chosen weapon).
• Advantage on any attack or task related to your fitted weapon.
• Cannot wield two-handed weapons.
• Weapons requiring Imperial power can hook into your Potentia Coil; if the power source is affected, make a Routine (+20) Fortitude (Endurance) Test or gain Fatigued (Minor).'),

    -- ── DATA-TETHERS ─────────────────────────────────────────────────

    ('Battle-sphere Uplink',
     'Access to a macroclade''s Battle-sphere noosphere, providing perception of troop movements, enemy positions, and battlefield maps.
Grants Advantage on Awareness, Intuition (Surroundings), Logic (Investigation), and Navigation (Surface, Tracking, and Void) Tests when this information is involved.'),

    ('Data-Tether',
     'A standard data-tether providing base-level connectivity to cogitators and similar Imperial technologies. Requires physical interaction with a control unit or cogitator to have any effect.'),

    ('Dataspike',
     'A brutal data-tether spike for forcibly plugging into machines and mechanical servants.
Grants Advantage on Tech Tests when attempting to overwrite or access the functions and memories of a machine, or bypass security measures within.'),

    ('Noospheric Data-Tether',
     'The most sacred of data-tethers, required to perceive and utilise the noosphere — interacting with reality as data alone, as close as any mortal can come to perceiving the universe as the Machine God does.
Required for you to perceive and utilise the noosphere.')
)
INSERT INTO augmetic (id, description)
SELECT i.id, d.descr
FROM inventory i
JOIN descriptions d ON d.name = i.name
ON CONFLICT (id) DO UPDATE
    SET description = EXCLUDED.description
    WHERE augmetic.description IS NULL OR augmetic.description = '';