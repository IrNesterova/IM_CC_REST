-- Miscellaneous items from Macharian Requisition (consumables, medicae, clothing, tools)
-- Run AFTER inventory.sql

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            -- Medicae Packs (MR p35)
            ('Officio Medicae Medipack',   'TOOLS', 600,   'SCARCE', 1,
             'A common medipack outfitted by the Departmento Munitorum for civilian distribution. Contains gauzes, bandages, vein clamps, surgical grapples, sterilising cleanse fluid, Synth-skin canisters, blessed lotions, acids, alkali, tonics, cleansing tablets, one Injector, one dose of De-tox, and one dose of Hyper-coagulant. Grants +1 SL on any Medicae Test.'),

            ('Militarum Issue Medipack',   'TOOLS', 750,   'RARE',   1,
             'The standard issue medipack of the Astra Militarum, containing the same tools as the civilian issue but with items blessed by the Ecclesiarchy: blessed gauzes, phials of morphia, and blessed tonics. Also contains Microfauna Inhibitor Spray, one Injector, and one dose each of Adrenaline Shot, De-tox, Hyper-coagulant, and Stimm. Grants +2 SL on any Medicae Test.'),

            ('Hospitaller Medipack',       'TOOLS', 1000,  'EXOTIC', 1,
             'The Departmento Munitorum-issued medipack for Sisters Hospitaller, containing prayer-inscribed bandages, blessed sterilising fluids, sacred coagulating oils, and finely-wrought surgical tools inscribed with oaths to the God-Emperor. Contains one Injector, two Adrenaline Shots, one De-tox, one Hyper-coagulant, and two Stimm shots. Grants +2 SL on any Medicae Test; treated characters gain +1 SL on Fortitude Tests for one hour.'),

            -- Medicae Drugs (MR p36-37, prices per dose)
            ('Adrenaline Shot',            'TOOLS', 10,    'COMMON', 0,
             'A potent concoction of adrenaline enhancers, neutral stimulants, and bonded anaesthetics. When administered, the recipient immediately recovers from the Stunned Condition and can ignore the Fatigued Condition for the next hour.'),

            ('De-tox',                     'TOOLS', 30,    'COMMON', 0,
             'A potent purgative used to purge the body of other drugs, toxins, and poisons. When administered, the recipient immediately recovers from the Poisoned Condition and the effects of other drugs. The recipient must pass a Challenging (+0) Toughness Test or become Stunned for 1d10 minutes.'),

            ('Hyper-coagulant',            'TOOLS', 20,    'COMMON', 0,
             'A solution of thickening agents and coagulants. When injected near the site of an injury, it slows blood flow and begins the coagulation process. When administered, the recipient immediately recovers from the Bleeding Condition, though the Condition returns within 3 hours without proper medicae attention.'),

            ('Meta-regulant',              'TOOLS', 30,    'SCARCE', 0,
             'A metabolic regulator used in first-aid treatment. Any Medicae Tests made on the recipient gain +2 SL for the next hour. However, the recipient has −2 SL on Fortitude Tests for the same duration.'),

            ('Stimm',                      'TOOLS', 40,    'COMMON', 0,
             'A potent pain-masking drug applied in the midst of firefights. When administered, the recipient ignores the effects of any Critical Wounds and Injuries for 1d10 rounds + their Toughness Bonus, after which the pain returns with a significant slump in motor function.'),

            -- Clothing & Gear (MR p18-22)
            ('Document Harness',           'CLOTHING_AND_PERSONAL_GEAR', 30,   'COMMON', 1,
             'A series of chemically treated leather satchels worn as a harness, designed to keep documents dry and clean in field conditions. Can be fitted underneath heavier clothing or most forms of armour. A Document Harness can hold up to 4 Encumbrance of documents, books, or scrolls at the cost of 1 Encumbrance.'),

            ('Service Identity Tags',      'CLOTHING_AND_PERSONAL_GEAR', 2,    'COMMON', 0,
             'Stamped metal identification tags issued to all Astra Militarum and Navis Imperialis personnel. At minimum, they record the bearer''s name, rank, regiment or voidship, and a Departmento Munitorum identification number. Not typically for sale; those in circulation are usually forgeries.'),

            ('Harjian Pattern Void Suit',  'CLOTHING_AND_PERSONAL_GEAR', 2500, 'RARE',   3,
             'A reinforced void suit designed for operations in the variable gravities and corrosive atmospheres of gas giant cloud layers. Extra rigidity, padding, and boosted micro-thrusters allow the wearer to compensate for extreme conditions. The suits often incorporate hides of cloud fauna, giving them a distinctive glittering scale texture. Grants +1 AP and Fast Speed in low or zero gravity environments.'),

            -- Tools (MR p43)
            ('Lasgun Maintenance Kit',     'TOOLS', 50,    'COMMON', 1,
             'A Departmento Munitorum-issue maintenance kit for the lasgun, containing a cleaning rod, power coupling tester, sight calibration tool, spare focusing crystals, and sanctified machine oil. Regular use prevents misfires and power pack failures. Commonly issued across Astra Militarum regiments.'),

            -- Consumables (MR p27)
            ('Food Supplement Tablets',    'TOOLS', 1,     'COMMON', 0,
             'Coin-sized tablets that dissolve in water or alcohol to produce a foul but nutritionally complete drink. Contain essential salts, trace metals, and organic compounds sufficient to sustain a Human body for up to 3 days in the absence of other food. Issued to Astra Militarum troopers as emergency rations.')

        ) AS t(name, category, cost, avail, enc, descr)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec.name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
            VALUES (rec.name, rec.category, rec.avail, rec.enc, rec.cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category = rec.category,
                availability       = rec.avail,
                encumbrance        = rec.enc,
                cost               = rec.cost,
                source_book        = 'MR'
            WHERE id = inv_id;
        END IF;

        INSERT INTO generic_item (id, description)
        VALUES (inv_id, rec.descr)
        ON CONFLICT (id) DO UPDATE SET description = EXCLUDED.description;

    END LOOP;
END $$;
