-- Conditions reference — IM Core Rulebook
DO $$
DECLARE rec RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES

            ('Ablaze',
             'You are on fire. You automatically fail all Stealth Tests while Ablaze.',
             'You suffer 1d5 Damage at the start of your turn, which ignores Armour.',
             'You suffer 1d10 Damage at the start of your turn, which ignores Armour.',
             'Drop Prone and use your Action to make a successful Challenging (+0) Athletics Test.'),

            ('Bleeding',
             'You are losing blood. If you exceed your Wound Maximum because of Bleeding, you suffer a Critical Wound as normal. Once this occurs, you no longer suffer damage from Bleeding but can''t recover Wounds until it is treated.',
             'You suffer 1 Damage at the end of your turn, which ignores Armour.',
             'You suffer 3 Damage at the end of your turn, which ignores Armour.',
             'Challenging (+0) Medicae Test, or use of a Chirurgeon''s Kit.'),

            ('Blinded',
             'You can''t see. You can only succeed on Tests that rely on sight (Awareness (Sight), Ranged Tests) by rolling 01–05. You have Disadvantage on Melee and Reflexes (Dodge) Tests.',
             NULL,
             NULL,
             'Lost after 1d10 rounds. Those with appropriate augmetic sensory organs may spend an Action on a power-cycle.'),

            ('Deafened',
             'You can''t hear. You can only succeed on Tests that rely on hearing (Awareness (Hearing)) by rolling 01–05.',
             NULL,
             NULL,
             'Lost after 1d10 minutes. Those with appropriate augmetic sensory organs may spend an Action on a power-cycle.'),

            ('Fatigued',
             'You are exhausted and stressed, desperately in need of rest. If you gain Fatigued again while under Major Effect, you may act for minutes equal to your Toughness Bonus before falling Unconscious.',
             'You have Disadvantage on all Tests.',
             'All Tests have their difficulty increased to Very Hard (−30).',
             'Six hours of rest.'),

            ('Frightened',
             'You are Frightened.',
             'Due to heightened senses you have Advantage on Awareness and Intuition Tests. However, you have Disadvantage on all Tests relating to confronting the source of your fear.',
             'You are terrified. You must run from the source of your fear in the most direct route possible, stopping only to open doors or otherwise free yourself from your situation.',
             'At the end of each round, make a Challenging (+0) Disciplinе (Fear) Test to remove this Condition.'),

            ('Incapacitated',
             'You can''t Move or take Actions. You can''t defend yourself — Melee attacks against you automatically score a Critical Hit.',
             NULL,
             NULL,
             'Determined by what caused the Condition.'),

            ('Overburdened',
             'You have Disadvantage on all Agility Tests and your Speed is reduced one step.',
             NULL,
             NULL,
             'Reduce your carried Encumbrance to within your limit.'),

            ('Poisoned',
             'You are sick or unwell. If the duration is not specified, it lasts for 1d5 hours. Most poisons can be treated with a Challenging (+0) Medicae Test and a Chirurgeon''s Kit.',
             'You have Disadvantage on Strength and Toughness Tests. The maximum SL you can achieve on any Test is equal to your Toughness Bonus.',
             'You become Prone and Incapacitated.',
             'Challenging (+0) Medicae Test and use of a Chirurgeon''s Kit. Dangerous substances may require Difficult (−10) or harder.'),

            ('Prone',
             'A Prone creature can only move by crawling, unless they use their Move to stand up. You have Disadvantage on Melee Tests. Creatures attacking you from within Immediate Range have Advantage; creatures attacking from outside Immediate Range have Disadvantage.',
             NULL,
             NULL,
             'Use your Move action to stand up.'),

            ('Restrained',
             'You are unable to move normally.',
             'You cannot take Move actions. You have Disadvantage on Tests involving movement: Athletics, Dexterity, Melee, Reflexes, and Ranged Tests.',
             'You become Incapacitated.',
             'Usually requires a Test appropriate to the situation, such as a Dexterity (Lockpicking) Test.'),

            ('Stunned',
             'You are dazed and disoriented. If duration is not specified, lasts 1d5 rounds.',
             'You can take either a Move or an Action, but not both.',
             'Additionally, you have Disadvantage on all Tests.',
             '1d5 rounds, or an ally spends an Action to rouse you (Challenging (+0) Fortitude (Pain) Test).'),

            ('Unconscious',
             'You have fallen Unconscious. You immediately drop anything you are holding, fall Prone, and become Incapacitated. Anyone within Immediate Range with a weapon that does not have the Ineffective Trait can kill you without needing to make a Test.',
             NULL,
             NULL,
             'Determined by what caused the Condition.')

        ) AS t(_name, _description, _minor, _major, _removal)
    LOOP
        INSERT INTO game_condition (name, description, minor_effect, major_effect, removal)
        VALUES (rec._name, rec._description, rec._minor, rec._major, rec._removal)
        ON CONFLICT (name) DO UPDATE SET
            description  = EXCLUDED.description,
            minor_effect = EXCLUDED.minor_effect,
            major_effect = EXCLUDED.major_effect,
            removal      = EXCLUDED.removal;
    END LOOP;
END $$;