-- Training manual Books included in Equipment Packs (Macharian Requisition, pp. 24-26)
-- These are pack-specific titles not listed in the general Books table (MR p15).
-- Run AFTER macharian_requisition_books.sql

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('Laspistol Manual AKR-457',        5,   'COMMON',
             'A compact field manual detailing the maintenance, operation, and basic troubleshooting of standard-pattern laspistols. Issued to Adeptus Administratum field personnel as a precautionary measure before sending clerks anywhere near an active fire zone.',
             'Ranged (Pistols)'),

            ('Munitorum Knife Manual SK43-B',   5,   'COMMON',
             'A practical guide to the Departmento Munitorum-pattern combat knife, covering edge maintenance, field sharpening, and close-quarters technique. The section on approved regulations for when lethal force is and is not sanctioned is longer than the section on using the knife.',
             'Melee (One-handed)'),

            ('Adeptus Administratum Audit Procedures Manual AD444.37b', 10, 'SCARCE',
             'The standard reference for Adeptus Administratum audit practice in the Macharian Sector, covering record evaluation, discrepancy detection, and the correct filing of anomaly reports. Its dense columns of regulation and exception-handling are beloved by no one, yet its systematic approach has resolved more bureaucratic crises than any weapon.',
             'Logic (Evaluation)'),

            ('Lasgun Manual LRS-489',            5,   'COMMON',
             'The Departmento Munitorum standard maintenance and operation guide for the lasgun, covering power pack replacement, sight calibration, and clearing a jam under sustained fire. Statistical evidence confirms that troopers who have read it thoroughly tend to come home more often.',
             'Ranged (Long Guns)'),

            ('Patrol Weapons Maintenance Manual', 5,  'COMMON',
             'A quick-reference guide to maintaining and operating the sidearms issued to Adeptus Administratum enforcers on patrol duty. Compact enough to fit in a breast pocket, durable enough to survive the field conditions in which it is most needed.',
             'Ranged (Pistols)'),

            ('Enforcer''s Illustrated Subdual Manual', 10, 'SCARCE',
             'A heavily illustrated guide to non-lethal restraint techniques and the relevant passages of the Lex Imperialis that authorise them. The extensive use of illustration was reportedly a concession to the reading ability of the intended audience, a claim the Departmento Munitorum has declined to confirm or deny.',
             'Lore (Lex Imperialis), Melee (One-handed)'),

            ('Wounded Machines and Battlefield Rites (Abridged)', 10, 'SCARCE',
             'An abridged field reference for Tech-Priests attached to combat units, covering battlefield maintenance of Imperial technology and the consecration rites required to prevent corruption of machine spirits under duress. The unabridged edition runs to forty-three volumes.',
             'Tech (Engineering), Tech (Security)'),

            ('The Emperor''s Mercy: Proper Care and Use of the Mercy Blade', 5, 'SCARCE',
             'Issued to Scholastica Psykana graduates, this slim volume covers the proper consecration, maintenance, and use of the Psykana Mercy Blade — including the precise theological and legal circumstances under which its use is sanctioned. The prose is serene and deeply unsettling in equal measure.',
             'Melee (One-handed)'),

            ('Selected Meditations on Eternity', 20, 'SCARCE',
             'A curated anthology of sanctioned psyker writings drawn from the Scholastica Psykana''s archives, covering the disciplines of focus, warp-sight management, and the philosophical underpinnings of sanctioned psychic practice. Considered essential reading for newly sanctioned psykers entering active service.',
             'Psychic Mastery (Any Discipline)'),

            ('Auspex Manual VAO-384',            10,  'COMMON',
             'A technical reference for the operation and maintenance of standard-pattern auspex units, covering sensor calibration, battery replacement, and the interpretation of common false-positive readings. Issued to voidship crew and tech-adjacent personnel across the Macharian Sector.',
             'Tech (Engineering)')

        ) AS t(name, cost, avail, descr, related_skills)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec.name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
            VALUES (rec.name, 'BOOK', rec.avail, 1, rec.cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category = 'BOOK',
                availability       = rec.avail,
                encumbrance        = 1,
                cost               = rec.cost,
                source_book        = 'MR'
            WHERE id = inv_id;
        END IF;

        INSERT INTO book (id, description, related_skills)
        VALUES (inv_id, rec.descr, rec.related_skills)
        ON CONFLICT (id) DO UPDATE
            SET description    = EXCLUDED.description,
                related_skills = EXCLUDED.related_skills;

    END LOOP;
END $$;
