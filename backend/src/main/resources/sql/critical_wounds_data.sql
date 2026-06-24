 -- Critical Wounds Table — IM Core Rulebook
-- roll_max = 99 означает «и выше» (15+, 18+, 20+)

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES

            -- ================================================================
            -- HEAD (1–15+)
            -- ================================================================
            ('HEAD',  1,  1,  'Black Eye',
             'You are struck in the eye. You have Disadvantage on Awareness (Sight) and Ranged Tests for 1 hour.',
             NULL,
             'None required.',
             false),

            ('HEAD',  2,  2,  'Rattling Blow',
             'The blow floods your vision with flashing lights. You are Stunned until the end of your next turn.',
             NULL,
             'None required.',
             false),

            ('HEAD',  3,  3,  'Laceration',
             'You suffer a laceration to the cheek. You are Bleeding.',
             NULL,
             'A Routine (+20) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('HEAD',  4,  4,  'Sliced Ear',
             'The attack slices your ear, leaving your ears ringing. You are Deafened until the end of your next turn, and are Bleeding.',
             NULL,
             'A Challenging (+0) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('HEAD',  5,  5,  'Dislocated Jaw',
             'The blow strikes you in the face, dislocating your jaw. You are Stunned until the end of your next turn, and have Disadvantage on Rapport Tests and Tests that rely on speech.',
             'Your jaw is cracked. You suffer a Broken Bone (Minor) Injury to your jaw.',
             'A Challenging (+0) Medicae Test to relocate the jaw.',
             false),

            ('HEAD',  6,  6,  'Struck Forehead',
             'You are struck in the head, causing blood to run down your face and impair your vision. You are Blinded and Bleeding.',
             NULL,
             'A Challenging (+0) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('HEAD',  7,  7,  'Major Eye Wound',
             'You are hit in the eye, causing serious damage. You are Bleeding, and have Disadvantage on Awareness (Sight) Tests. If you only have one eye, you are Blinded.',
             'Your orbital bone is shattered. You suffer a Broken Bone (Major) Injury to your eye.',
             'A Difficult (−10) Medicae Test to treat the eye and stop the Bleeding.',
             false),

            ('HEAD',  8,  8,  'Major Ear Wound',
             'The blow strikes you in the ear or otherwise damages your ear drums. You are Deafened. If you suffer this result again, your hearing is permanently lost.',
             NULL,
             'A Difficult (−10) Medicae Test, usually using drugs to reduce swelling and inflammation in the ear.',
             false),

            ('HEAD',  9,  9,  'Smashed Mouth',
             'The blow smashes out several teeth. You are Bleeding and must make a Challenging (+0) Fortitude (Pain) Test or also fall Prone.',
             'You lose 1d10 teeth. You suffer the Amputation (Teeth) Injury.',
             'A Hard (−20) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('HEAD', 10, 10,  'Broken Nose',
             'You are struck in the nose, shattering the bone and filling your eyes with tears. You also gain the Bleeding (Major) Condition. Additionally, you are Blinded until the end of your next turn, and must make a Challenging (+0) Fortitude (Pain) Test or become Stunned until the end of your next turn.',
             'Your nose is shattered. You suffer a Broken Bone (Major) Injury to your nose.',
             'A Hard (−20) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('HEAD', 11, 11,  'Mangled Ear',
             'The blow tears your ear apart. You are Deafened and Bleeding (Major). You must make a Challenging (+0) Fortitude (Pain) Test or also gain the Stunned Condition until the end of your next turn.',
             'Your ear is torn off. You suffer the Amputation (Ear) Injury.',
             'A Hard (−20) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('HEAD', 12, 12,  'Concussive Blow',
             'You take a concussive blow to the head. You are Deafened and Stunned for 1 minute, and are Bleeding.',
             'You are concussed, and are Fatigued for 1d10 days regardless of how much rest you take.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('HEAD', 13, 13,  'Devastated Eye',
             'A strike to your eye causes it to burst. You are Bleeding (Major), and have Disadvantage on Awareness (Sight) Tests. If you only have one eye, you are Blinded.',
             'You lose your eye. You suffer the Amputation (Eye) Injury.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('HEAD', 14, 14,  'Mangled Jaw',
             'The blow shatters your jaw and destroys your tongue, sending teeth flying. You are Bleeding (Major). You must make a Challenging (+0) Fortitude (Pain) Test. On a success you are Stunned until the end of your next turn; on a failure you are Incapacitated until the end of your next turn and fall Prone.',
             'You lose 1d10 teeth, and suffer the Amputation (Teeth) Injury. Additionally, your jaw is shattered, and you suffer the Broken Bone (Major) Injury to your jaw.',
             'A Difficult (−10) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('HEAD', 15, 99,  'Shattered Skull',
             'Your head is caved in or erupts in a shower of bone and gore. You are dead.',
             NULL,
             NULL,
             true),

            -- ================================================================
            -- ARMS (1–20+)
            -- ================================================================
            ('ARMS',  1,  1,  'Jolted Wrist',
             'You are struck in the wrist, jarring your hand. Drop any item held in the hand.',
             NULL,
             'None required.',
             false),

            ('ARMS',  2,  2,  'Dead Arm',
             'You are struck by a rattling blow in your arm, causing it to temporarily go numb. You have Disadvantage on all Tests using the arm for 1 minute.',
             NULL,
             'None required.',
             false),

            ('ARMS',  3,  3,  'Laceration',
             'You suffer a laceration to the arm. You are Bleeding.',
             NULL,
             'A Routine (+20) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('ARMS',  4,  4,  'Sliced Hand',
             'Your hand is sliced open, sending jolts of pain through your arm. You are Bleeding and drop any item held in the hand.',
             NULL,
             'A Challenging (+0) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('ARMS',  5,  5,  'Dislocated Shoulder',
             'The strike dislocates your shoulder from the socket. The arm is useless until popped back into place. At the start of each turn while you have a dislocated shoulder you must make a Challenging (+0) Fortitude (Pain) Test. On a failure, you are Stunned until the start of your next turn.',
             NULL,
             'A Challenging (+0) Medicae Test to pop the shoulder back into place.',
             false),

            ('ARMS',  6,  6,  'Severed Finger',
             'The attack tears off one of your fingers. You are Bleeding (Major).',
             'One of your fingers is torn off. You suffer the Amputation (Finger) Injury.',
             'A Challenging (+0) Medicae Test performed by someone with the Chirurgeon Talent.',
             false),

            ('ARMS',  7,  7,  'Clean Break',
             'The attack fractures a bone in your arm. Your arm is completely useless, and you drop any item held. You must make a Challenging (+0) Fortitude (Pain) Test or be Stunned for one minute.',
             'Your arm is broken. You suffer the Broken Bone (Minor) Injury to your arm.',
             'A Difficult (−10) Medicae Test to treat shock. This Test does not treat the break.',
             false),

            ('ARMS',  8,  8,  'Deep Cut',
             'You suffer a deep gash on your arm, reducing your effectiveness. You are Bleeding (Major) and have Disadvantage on all Tests using the arm.',
             NULL,
             'A Difficult (−10) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('ARMS',  9,  9,  'Mangled Hand',
             'The blow devastates your hand, breaking bones and potentially severing fingers. You are Bleeding (Major) and immediately drop any item held.',
             'Your hand is crushed. You suffer the Broken Bone (Major) Injury to your hand. Additionally, you lose 1d10 − 5 fingers. If your result is 0, you manage to keep all of your digits. Otherwise, you suffer the Amputation (Fingers) Injury.',
             'A Difficult (−10) Medicae Test performed by someone with the Chirurgeon Talent.',
             false),

            ('ARMS', 10, 10,  'Shattered Elbow',
             'The attack shatters the bones in your elbow. Your arm is completely useless, and you immediately drop any item held in the hand. Additionally, you must make a Difficult (−10) Fortitude (Pain) Test or be Stunned for one minute.',
             'Your arm is broken. You suffer the Broken Bone (Major) Injury to your arm.',
             'A Hard (−20) Medicae Test to treat shock. This Test does not count as treating the broken bone.',
             false),

            ('ARMS', 11, 12,  'Cleft Hand',
             'Your hand is splayed apart, causing a major injury and severing fingers. You are Bleeding (Major) and immediately drop any item held in the hand. Additionally, you must make a Difficult (−10) Fortitude (Pain) Test or be Stunned for one minute.',
             'You lose a finger. You suffer the Amputation (Finger) Injury. For each minute the Critical Wound is untreated, you lose an additional finger. If you lose all fingers on the hand, you instead gain the Amputation (Hand) Injury.',
             'A Hard (−20) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('ARMS', 13, 14,  'Sliced Artery',
             'You suffer a serious wound to a major artery. You are Bleeding (Major), Fatigued from blood loss, your arm is completely useless, and you immediately drop any item held in the hand.',
             'Due to blood loss, you are Fatigued for 1d10 days regardless of how much rest you take.',
             'A Hard (−20) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('ARMS', 15, 16,  'Severed Hand',
             'Your hand is taken clean off. You are Bleeding (Major) and Stunned for 1 hour.',
             'You lose a hand. You suffer the Amputation (Hand) Injury.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('ARMS', 17, 19,  'Ruined Arm',
             'Your arm is mangled and torn apart, with only the barest piece of flesh attaching it to your body. Your arm is completely useless, and you immediately drop any item held in the hand. You are Bleeding (Major) and Stunned for 1 hour. If you suffer any further Damage to the arm, you automatically suffer the Brutal Dismemberment Critical Wound and die.',
             'Your arm is hanging on by a thread and must be amputated. You suffer the Amputation (Arm) Injury.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise to fully remove the arm.',
             false),

            ('ARMS', 20, 99,  'Brutal Dismemberment',
             'Your arm is completely destroyed and torn from your body, causing shock and catastrophic blood loss. You are dead.',
             NULL,
             NULL,
             true),

            -- ================================================================
            -- BODY (1–18+)
            -- ================================================================
            ('BODY',  1,  1,  'Winded',
             'The blow knocks the wind out of you. You are Stunned until the end of your next turn.',
             NULL,
             'None required.',
             false),

            ('BODY',  2,  2,  'Low Blow',
             'You are struck in a sensitive area. You must make a Challenging (+0) Fortitude (Pain) Test or fall Prone.',
             NULL,
             'None required.',
             false),

            ('BODY',  3,  3,  'Laceration',
             'You suffer a laceration to the body. You are Bleeding.',
             NULL,
             'A Routine (+20) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('BODY',  4,  4,  'Gut Shot',
             'You are hit hard in the stomach. You are Bleeding and knocked Prone.',
             NULL,
             'A Challenging (+0) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('BODY',  5,  5,  'Cracked Rib',
             'The attack cracks one of your ribs. You have Disadvantage on Strength and Agility Tests, and your Move is reduced one step.',
             'You have a cracked rib. You suffer the Broken Bone (Minor) Injury to your torso.',
             'None required.',
             false),

            ('BODY',  6,  6,  'Hammering Blow',
             'You are thrown back by the force of the blow. You are Stunned for 1 minute and are Bleeding.',
             NULL,
             'A Challenging (+0) Medicae Test performed by someone with the Chirurgeon Talent.',
             false),

            ('BODY',  7,  7,  'Broken Collarbone',
             'You suffer a crunching blow to your collarbone — determine randomly if this is on your left or right. You drop any item held in the hand on that side and have Disadvantage on all Tests using the arm. Additionally, you must make a Challenging (+0) Fortitude (Pain) Test or be Stunned for one minute.',
             'Your collarbone is broken. You suffer the Broken Bone (Minor) Injury to your collarbone, which is treated as a broken arm.',
             'A Difficult (−10) Medicae Test to treat shock. This Test does not count as treating the broken bone.',
             false),

            ('BODY',  8,  8,  'Deep Cut',
             'You suffer a deep cut on your lower abdomen, which makes it difficult to move. You are Bleeding (Major), and your Speed is reduced one step.',
             NULL,
             'A Difficult (−10) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('BODY',  9,  9,  'Fractured Hip',
             'You are hit in the hip, causing the bone to fracture. You are knocked Prone, have Disadvantage on Tests that rely on mobility, and your Move is reduced one step. Additionally, you must make a Challenging (+0) Fortitude (Pain) Test or be Stunned for one minute.',
             'Your hip is fractured. You suffer the Broken Bone (Minor) Injury to your hip, which is treated as a broken leg.',
             'A Difficult (−10) Medicae Test to treat shock. This Test does not count as treating the broken bone.',
             false),

            ('BODY', 10, 10,  'Shattered Ribs',
             'The attack shatters multiple ribs, leaving shards of bone peppered throughout your flesh. You have Disadvantage on any physical Test, and your Move is reduced two steps to a minimum of Slow.',
             'You suffer a Broken Bone (Major) Injury to your torso.',
             'A Difficult (−10) Medicae Test to treat shock. This Test does not count as treating the broken bone.',
             false),

            ('BODY', 11, 11,  'Punctured Lung',
             'The attack punctures your lung, perhaps embedding shrapnel, a bullet, or a fragment of your own bone. You gain a Fatigued Condition and a Bleeding (Minor) Condition.',
             'Your lung is badly damaged and partially filled with fluids. A Difficult (−10) Medicae Test performed by someone with the Chirurgeon Talent is required to repair the damaged tissue and remove the Fatigued Condition.',
             'A Difficult (−10) Medicae Test to patch up the wound and remove the Bleeding Condition.',
             false),

            ('BODY', 12, 13,  'Sliced Artery',
             'You suffer a serious wound to a major artery. You are Bleeding (Major), Fatigued from blood loss, have Disadvantage on Tests that rely on mobility, your Move is reduced one step, and you fall Prone.',
             'Due to blood loss, you are Fatigued for 1d10 days regardless of how much rest you take.',
             'A Hard (−20) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('BODY', 14, 15,  'Flayed Flesh',
             'A chunk of the flesh of your torso is blasted away, leaving an ugly, open wound that exposes the bones and organs beneath. You are Bleeding (Major) and Prone. Additionally, you are Stunned for 1 hour.',
             'A Difficult (−10) Medicae Test performed by someone with the Chirurgeon Talent is required to repair the damaged tissue.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('BODY', 16, 17,  'Injured Spine',
             'You suffer a substantial injury to your spine, making it difficult to stand and leaves you in terrible pain. You are Bleeding (Major) and Prone.',
             'Your spine is cracked or broken. You suffer the Broken Bone (Major) Injury to your torso.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('BODY', 18, 99,  'Torn Apart',
             'You are split in two or otherwise torn apart. Creatures within Short Range are showered in blood and gore. You are dead.',
             NULL,
             NULL,
             true),

            -- ================================================================
            -- LEGS (1–20+)
            -- ================================================================
            ('LEGS',  1,  1,  'Twisted Ankle',
             'You twist your ankle, causing you to stumble. You fall Prone.',
             NULL,
             'None required.',
             false),

            ('LEGS',  2,  2,  'Dead Leg',
             'You are struck by a rattling blow in your leg, causing it to temporarily go numb. Your Speed is reduced one step for 1 minute.',
             NULL,
             'None required.',
             false),

            ('LEGS',  3,  3,  'Laceration',
             'You suffer a laceration to the leg. You are Bleeding.',
             NULL,
             'A Routine (+20) Medicae Test to stop the Bleeding; application of bandages; or the laceration will close naturally after 1 hour.',
             false),

            ('LEGS',  4,  4,  'Sliced Calf',
             'Your calf is sliced open, sending jolts of pain through your leg. You are Bleeding and fall Prone.',
             NULL,
             'A Challenging (+0) Medicae Test to stop the Bleeding; apply bandages; or wait 1 hour.',
             false),

            ('LEGS',  5,  5,  'Dislocated Knee',
             'The strike dislocates your knee. You have Disadvantage on Tests that rely on mobility, and your Move is reduced one step. At the start of each turn while you have a dislocated knee you must make a Challenging (+0) Fortitude (Pain) Test. On a failure, you are Stunned until the start of your next turn.',
             NULL,
             'A Challenging (+0) Medicae Test to pop the knee back into place.',
             false),

            ('LEGS',  6,  6,  'Severed Toe',
             'The attack tears off one of your toes. You are Bleeding (Major).',
             'One of your toes is torn off. You suffer the Amputation (Toe) Injury.',
             'A Challenging (+0) Medicae Test performed by someone with the Chirurgeon Talent.',
             false),

            ('LEGS',  7,  7,  'Clean Break',
             'The attack fractures a bone in your leg. Your leg is completely useless, you immediately fall Prone, you have Disadvantage on Tests that rely on mobility, and your Move is reduced one step. Additionally, you must make a Challenging (+0) Fortitude (Pain) Test or be Stunned for one minute.',
             'Your leg is broken. You suffer the Broken Bone (Minor) Injury to your leg.',
             'A Difficult (−10) Medicae Test to treat shock. This Test does not count as treating the broken bone.',
             false),

            ('LEGS',  8,  8,  'Deep Cut',
             'You suffer a deep gash on your leg, reducing your effectiveness. You are Bleeding (Major) and have Disadvantage on all Tests using the leg, such as jumping or climbing.',
             NULL,
             'A Difficult (−10) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('LEGS',  9,  9,  'Mangled Foot',
             'The blow devastates your foot, breaking bones and potentially severing toes. You are Bleeding (Major), immediately fall Prone, and your Move is reduced one step.',
             'Your foot is crushed. You suffer the Broken Bone (Major) Injury to your foot. Additionally, you lose 1d10 − 5 toes. If your result is 0, you manage to keep all of your digits. Otherwise, you suffer the Amputation (Toes) Injury.',
             'A Difficult (−10) Medicae Test performed by someone with the Chirurgeon Talent.',
             false),

            ('LEGS', 10, 10,  'Shattered Knee',
             'The attack shatters the bones in your knee. Your leg is completely useless, you immediately fall Prone, your Move is reduced one step, you have Disadvantage on Tests that rely on mobility. You must make a Difficult (−10) Fortitude (Pain) Test or be Stunned for one minute.',
             'Your leg is broken. You suffer the Broken Bone (Major) Injury to your leg.',
             'A Hard (−20) Medicae Test to treat shock. This Test does not count as treating the broken bone.',
             false),

            ('LEGS', 11, 12,  'Cleft Foot',
             'Your foot is splayed apart, causing a major injury and severing toes. You are Bleeding (Major) and immediately fall Prone. Additionally, you must make a Difficult (−10) Fortitude (Pain) Test or be Stunned for one minute.',
             'You lose a toe. You suffer the Amputation (Toe) Injury. For each minute the Critical Wound is untreated, you lose an additional toe. If you lose all toes on the foot, you instead gain the Amputation (Foot) Injury.',
             'A Hard (−20) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise.',
             false),

            ('LEGS', 13, 14,  'Sliced Artery',
             'You suffer a serious wound to a major artery. You are Bleeding (Major), Fatigued from blood loss, have Disadvantage on Tests that rely on mobility, your Move is reduced one step, and you fall Prone.',
             'Due to blood loss, you are Fatigued for 1d10 days regardless of how much rest you take.',
             'A Hard (−20) Medicae Test using a chirurgeon''s kit to stop the Bleeding.',
             false),

            ('LEGS', 15, 16,  'Severed Foot',
             'Your foot is taken clean off. You are Bleeding (Major) and Prone. Additionally, you are Stunned for 1 hour.',
             'You lose a foot. You suffer the Amputation (Foot) Injury.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent.',
             false),

            ('LEGS', 17, 19,  'Ruined Leg',
             'Your leg is mangled and torn apart, with only the barest piece of flesh attaching it to your body. Your leg is completely useless, you fall Prone, your Move is reduced one step, and have Disadvantage on Tests that rely on mobility. You are Bleeding (Major) and Stunned for 1 hour. If you suffer any further Damage to the leg, you automatically suffer the Brutal Dismemberment Critical Wound and die.',
             'Your leg is hanging on by a thread and must be amputated. You suffer the Amputation (Leg) Injury.',
             'A Very Hard (−30) Medicae Test performed by someone with the Chirurgeon Talent or similar expertise to fully remove the leg.',
             false),

            ('LEGS', 20, 99,  'Brutal Dismemberment',
             'Your leg is completely destroyed and torn from your body, causing shock and catastrophic blood loss. You are dead.',
             NULL,
             NULL,
             true)

        ) AS t(_location, _roll_min, _roll_max, _title, _effect, _injury, _treatment, _fatal)
    LOOP
        INSERT INTO critical_wound (location, roll_min, roll_max, title, effect, injury, treatment, fatal)
        VALUES (rec._location, rec._roll_min, rec._roll_max, rec._title, rec._effect, rec._injury, rec._treatment, rec._fatal)
        ON CONFLICT (location, roll_min) DO UPDATE SET
            roll_max  = EXCLUDED.roll_max,
            title     = EXCLUDED.title,
            effect    = EXCLUDED.effect,
            injury    = EXCLUDED.injury,
            treatment = EXCLUDED.treatment,
            fatal     = EXCLUDED.fatal;
    END LOOP;
END $$;