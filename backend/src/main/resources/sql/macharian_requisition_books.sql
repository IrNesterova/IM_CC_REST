-- Books from Macharian Requisition Guide, pp. 15-17
-- Run AFTER inventory.sql and macharian_requisition_augmetics.sql

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('Forge World Citizen''s Safety Manual', 3,      'COMMON',
             'Distributed by tech adepts at an optimised rate of one for
every fifty citizens who serve in their manufactorums,
the Forge World Citizen’s Safety Manual is a pocket
tome of holy regulations and strictures, a combining of
Omnissian prayer and guidelines to prevent the misuse
of machinery and resulting deaths, or worse, reduced
industrial output.',
             'Intuition (Surroundings), Lore (Forge Worlds), Tech (Engineering)'),

            ('Histories of Macharia (Common)',       3,      'COMMON',
             'Macharia exports hundreds of volumes related to the
sector’s history; many get passed between pilgrims
on their way to Macharia. Many of these volumes are
naturally concerned with the Macharian Crusade, the
life of Lord Solar Macharius, and the forming of the
sector’s most prominent worlds. So many revisions
have been made to these volumous records over the
centuries that outdated volumes linger in libraries
across the sector, often contributing to widespread
inaccuracies in public knowledge.',
             'Lore (Macharian Sector), Presence (Leadership)'),

            ('Histories of Macharia (Scarce)',       15,     'SCARCE',
             'A more complete or well-preserved volume on the history of the Macharian Sector.',
             'Lore (Macharian Sector), Presence (Leadership)'),

            ('Histories of Macharia (Rare)',         3000,   'RARE',
             'A rare scholarly edition on the history of the Macharian Sector, covering topics unavailable in common printings.',
             'Lore (Macharian Sector), Presence (Leadership)'),

            ('Histories of Macharia (Exotic)',       10000,  'EXOTIC',
             'An extraordinarily rare or original manuscript on the Macharian Sector. The rarest volumes allow study of topics inaccessible in any other edition.',
             'Lore (Macharian Sector), Presence (Leadership)'),

            ('Holy Text (Scarce)',                   150,    'SCARCE',
             'An Adeptus Ministorum holy text containing commandments, laws, moral guidance, and sanctioned histories. Examples: writings of Sebastian Thor, Sermons of Goge Vandire.',
             'Discipline (Composure), Linguistics (High Gothic), Lore (Theology)'),

            ('Holy Text (Rare)',                     5000,   'RARE',
             'A rare or elaborately produced Adeptus Ministorum holy text.',
             'Discipline (Composure), Linguistics (High Gothic), Lore (Theology)'),

            ('Holy Text (Exotic)',                   150000, 'EXOTIC',
             'An extraordinarily rare or original holy text of the Adeptus Ministorum.',
             'Discipline (Composure), Linguistics (High Gothic), Lore (Theology)'),

            ('Imperial Infantryman''s Uplifting Primer', 5,  'COMMON',
             'The trusty companion of every literate Astra Militarum
trooper, the Imperial Infantryman’s Uplifting Primer
contains all that one needs to know for life in the
guard, covering in detail the assembly and disassembly
of a lasgun, field tactics, and the many misdemeanours
for which one can be summarily executed',
             'Discipline (Composure), Lore (Astra Militarum), Ranged (Long Guns)'),

            ('Imperial Munitorum Manual',            50,     'RARE',
             'The Imperial Munitorum Manual is a guide to
the vast array of equipment manufactured for the
Astra Militarum, aiding the reader (most often a
quartermaster) in understanding the unending streams
of shipping manifests parsed by the logisticians of the
Departmento Munitorum.',
             'Linguistics (Cypher), Logic (Evaluation), Lore (Imperial Arms)'),

            ('Liber Anatomicus (Pocket Edition)',    5,      'SCARCE',
             'An abridged version of a much larger anatomical tome,
this pocket guide to Human anatomy, field medicae,
and surgical procedure is in broad circulation, owing
to its distribution among the medics of the Astra
Militarum. For many, this book is the only medical
training they will ever receive.',
             'Fortitude (Pain), Medicae (Human)'),

            ('Litany of Sacrifice',                  4,      'SCARCE',
             'The faithful heed the contents of the Litany of Sacrifice,
its pages of scripture adorned with illustrations of
martyrdom, equal parts lurid and sacred, and projecting
a singular message: only in death does duty end.',             'Discipline (Composure), Fortitude (Pain), Presence (Leadership)'),

            ('Litany of the Fallen',                 5,      'SCARCE',
             'The Litany of the Fallen is a guide to identifying
heretics through their behaviour and appearance. In
the hands of a typically overzealous Ministorum priest,
its contents can drive suspicion and foment witch
hunts against any showing even the slightest deviation
from the Imperial status quo, for whom innocence is
rarely enough to earn clemency.',
             'Intuition (Human), Logic (Investigation), Presence (Interrogation)'),

            ('Tactica Imperialis',                   10,     'RARE',
             'The victorious campaigns of the Imperium’s history
detailed in Tactica Imperialis are held in near-sacred
renown and used extensively in training officers of
the Astra Militarum. Few trainees have been willing
to risk the shame of suggesting that this cultivates a
homogeneity of Imperial tactics, which their enemies
could exploit simply by reading a copy for themselves.',
             'Lore (Tactics), Presence (Leadership)'),

            ('Topographical Charts',                 25,     'RARE',
             'The charting of an Imperial planet often occurs when
the planet is first conquered. Scout regiments of the
Astra Militarum perform this duty, employing survey
equipment from light combat vehicles that range in
enemy territory. The price for the production of these
maps is almost always paid in blood.',
             'Navigation (Surface), Ranged (Ordnance), Stealth (Move Silently)'),

            ('Voidships Rising',                     10,     'SCARCE',
             'The daring adventures of a dashing voidship captain,
Darios Brackenhart, are popular among the ruling
families of Persepolis, a glamorous falsehood reflecting
nothing about the reality of life in the Imperial Navy.',
             'Rapport (Charm), Rapport (Deception)'),

            ('Xenos Research (Scarce)',              5000,   'SCARCE',
             'These forbidden volumes contain research on the
physiology and behaviours of many xenos species that
inhabit the galaxy. These restricted volumes rarely fall
into the possession of anyone save for Rogue Traders
and agents of the Inquisition, those who benefit from
extensive preparation before encountering a xenos
species head on.',            'Intuition (Xenos), Lore (Forbidden — Xenos)'),

            ('Xenos Research (Exotic)',              150000, 'EXOTIC',
             'These forbidden volumes contain research on the
physiology and behaviours of many xenos species that
inhabit the galaxy. These restricted volumes rarely fall
into the possession of anyone save for Rogue Traders
and agents of the Inquisition, those who benefit from
extensive preparation before encountering a xenos
species head on.',             'Intuition (Xenos), Lore (Forbidden — Xenos)')
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
