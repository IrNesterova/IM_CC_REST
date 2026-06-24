-- Injuries reference table — IM Core Rulebook (Injuries chapter)
-- Broken Bone хранится отдельной строкой на каждую часть тела,
-- т.к. эффект различается. Имя включает часть тела для уникальности.

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES

            -- ================================================================
            -- AMPUTATION
            -- ================================================================

            ('Amputation (Ear)', 'AMPUTATION', 'Ear',
             'Losing an ear is painful, but you can learn to live without it. However, if you are unfortunate enough to lose both ears, you suffer Disadvantage on Awareness (Hearing) Tests.',
             NULL),

            ('Amputation (Eye)', 'AMPUTATION', 'Eye',
             'When you lose an eye, you have Disadvantage on Awareness (Sight) Tests until you adjust to the loss, which takes 5d10 weeks. If you lose both eyes, you are permanently Blinded.',
             NULL),

            ('Amputation (Finger)', 'AMPUTATION', 'Finger',
             'For the first finger lost, any failed Test using that hand that results in a 1 on the units die counts as a Fumble. For the second finger, any failed Test with a 1 or 2 on the units die counts as a Fumble, and so on. When you lose 4 or more fingers on one hand, use the rules for an amputated hand.',
             NULL),

            ('Amputation (Teeth)', 'AMPUTATION', 'Teeth',
             'For every two teeth lost, reduce your Rapport Skill by 1. If you lose more than half your teeth (16), eating can take longer and you may not be able to consume certain foods.',
             NULL),

            ('Amputation (Tongue)', 'AMPUTATION', 'Tongue',
             'You have Disadvantage on Rapport Tests, and can only succeed on Tests that rely on speech by rolling 01–05.',
             NULL),

            ('Amputation (Nose)', 'AMPUTATION', 'Nose',
             'You have Disadvantage on Awareness (Smell) Tests.',
             NULL),

            ('Amputation (Toes)', 'AMPUTATION', 'Toes',
             'For each toe lost, suffer a permanent –1 to your Agility and Weapon Skill Characteristics.',
             NULL),

            ('Amputation (Hand)', 'AMPUTATION', 'Hand',
             'You have Disadvantage on all Tests that require the use of two hands, and can''t wield weapons with the Two-handed Trait. You can still strap a shield to the arm to gain the shield''s benefit. If the lost hand is your dominant hand, you suffer Disadvantage on all Tests using your other hand until you take the Ambidextrous Talent.',
             NULL),

            ('Amputation (Arm)', 'AMPUTATION', 'Arm',
             'You have Disadvantage on all Tests that require the use of two hands, and can''t wield weapons with the Two-handed Trait.',
             NULL),

            ('Amputation (Foot)', 'AMPUTATION', 'Foot',
            'Your Speed is reduced one step, to a minimum of Slow. Additionally, you have Disadvantage on Tests that rely on mobility, such as Reflexes and Athletics Tests. ',
             NULL),

            ('Amputation (Leg)', 'AMPUTATION', 'Leg',
             'Your Speed is reduced one step, to a minimum of Slow. Additionally, you have Disadvantage on Tests that rely on mobility, such as Reflexes and Athletics Tests, and the minimum Difficulty of such Tests is Hard (−20).',
             NULL),

            ('Amputation (Toe)', 'AMPUTATION', 'Toe',
             'For each toe lost, suffer a permanent –1 to your Agility and Weapon Skill Characteristics.',
             NULL),

            -- ================================================================
            -- BROKEN BONE (MINOR) — отдельная строка на каждую часть тела
            -- ================================================================

            ('Broken Bone (Minor) — Head (Eye)', 'BROKEN_BONE', 'Head (Eye)',
             'Your orbital bone is cracked, swelling obstructs your sight. You have Disadvantage on Awareness (Sight) Tests.',
             'Heals of its own accord without medical attention over time.'),

            ('Broken Bone (Minor) — Head (Jaw)', 'BROKEN_BONE', 'Head (Jaw)',
             'Your ability to communicate is hampered. You have Disadvantage on Rapport Tests and Tests that rely on speech.',
             'Heals of its own accord without medical attention over time.'),

            ('Broken Bone (Minor) — Head (Nose)', 'BROKEN_BONE', 'Head (Nose)',
             'Your nose is crushed, a swollen mass of blood and cartilage. You have Disadvantage on Awareness (Smell) Tests.',
             'Heals of its own accord without medical attention over time.'),

            ('Broken Bone (Minor) — Torso', 'BROKEN_BONE', 'Torso',
             'Your strength and mobility are severely limited. You have Disadvantage on Strength and Agility Tests, and your Speed is reduced one step, to a minimum of Slow.',
             'Heals of its own accord without medical attention over time.'),

            ('Broken Bone (Minor) — Arm', 'BROKEN_BONE', 'Arm',
             'It is almost too painful to use your arm. You have Disadvantage on all Tests using the arm, such as swinging a weapon, steadying a rifle, or climbing.',
             'Heals of its own accord without medical attention over time.'),

            ('Broken Bone (Minor) — Leg', 'BROKEN_BONE', 'Leg',
             'Staying mobile is incredibly painful. You have Disadvantage on Tests that rely on mobility, such as Reflexes and Athletics Tests, and your Speed is reduced one step, to a minimum of Slow.',
             'Heals of its own accord without medical attention over time.'),

            -- ================================================================
            -- BROKEN BONE (MAJOR) — отдельная строка на каждую часть тела
            -- ================================================================

            ('Broken Bone (Major) — Head (Eye)', 'BROKEN_BONE', 'Head (Eye)',
             'Your orbital bone is shattered, causing severe swelling and loss of vision. You have Disadvantage on Awareness (Sight) Tests and can''t see out of the injured eye.',
             'Will not heal properly without medical attention.'),

            ('Broken Bone (Major) — Head (Nose)', 'BROKEN_BONE', 'Head (Nose)',
             'Your nose is completely shattered. You have no sense of smell.',
             'Will not heal properly without medical attention.'),

            ('Broken Bone (Major) — Head (Jaw)', 'BROKEN_BONE', 'Head (Jaw)',
             'Your jaw is ruined. You cannot speak and will need to survive on a liquid diet for a few weeks.',
             'Will not heal properly without medical attention.'),

            ('Broken Bone (Major) — Torso', 'BROKEN_BONE', 'Torso',
             'You have suffered internal damage, leading to an almost total loss of mobility. You must make a Challenging (+0) Endurance (Pain) Test when attempting any physical activity. On a failure, you are Incapacitated and can''t attempt any other physical activity until the next day or until treated with a Challenging (+0) Medicae Test. On a success, you can attempt the activity but have Disadvantage on the Test.',
             'Will not heal properly without medical attention.'),

            ('Broken Bone (Major) — Arm', 'BROKEN_BONE', 'Arm',
             'The arm is completely unusable and you must use your other hand. You have Disadvantage on all Tests that require the use of two hands, and can''t wield weapons with the Two-handed Trait. If you suffer a broken hand, you can still strap a shield to your arm but otherwise suffer the same penalties.',
             'Will not heal properly without medical attention.'),

            ('Broken Bone (Major) — Leg', 'BROKEN_BONE', 'Leg',
             'As Minor Break. Additionally, the minimum Difficulty of Tests relying on mobility is Hard (−20).',
             'Will not heal properly without medical attention.'),

            -- ================================================================
            -- OTHER
            -- ================================================================

            ('Concussion', 'OTHER', NULL,
             'You are Fatigued for 1d10 days regardless of how much rest you take.',
             NULL)

        ) AS t(_name, _type, _part, _effect, _treatment)
    LOOP
        INSERT INTO injury (name, injury_type, affected_part, effect, treatment)
        VALUES (rec._name, rec._type, rec._part, rec._effect, rec._treatment)
        ON CONFLICT (name) DO UPDATE SET
            injury_type   = EXCLUDED.injury_type,
            affected_part = EXCLUDED.affected_part,
            effect        = COALESCE(EXCLUDED.effect, injury.effect),
            treatment     = COALESCE(EXCLUDED.treatment, injury.treatment);
    END LOOP;
END $$;