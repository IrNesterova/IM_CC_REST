-- =====================================================================
-- IMPERIUM MALEDICTUM — CORE FACTIONS (rulebook p. 55-73, 14.06.2023 update)
-- Creates the 9 core factions with their characteristic bonuses, skill pools
-- (5 Advances to spend), fixed talents and talent choices. Also creates the
-- 20 core skills (rulebook p. 93) if they are missing.
--
-- Starting equipment and solars are NOT included yet: they need the inventory
-- catalogue, which is currently empty on Render (inventory.sql must be fixed first).
--
-- The core factions always get ids 1-9 in rulebook order (1 = Adeptus Administratum ...
-- 9 = Rogue Trader Dynasty); core factions created earlier under other ids are moved there.
-- Factions are matched by name AND source_book, because the AM supplement has
-- its own 'ADEPTUS MECHANICUS'. Safe to run more than once.
-- Run AFTER: characteristics.sql and the talent seeds.
-- =====================================================================

-- Ids: older databases have tables whose id column has no default (the entity used assigned
-- ids before), newer ones use identity columns or Hibernate sequences. next_id() works for all:
-- the column's own sequence, else Hibernate's <table>_seq for SEQUENCE entities, else a session
-- counter starting at max(id) + 1.
CREATE OR REPLACE FUNCTION pg_temp.next_id(p_table text) RETURNS bigint LANGUAGE plpgsql AS $fn$
DECLARE
    v_seq text := pg_get_serial_sequence(p_table, 'id');
    v_tmp text := 'next_id_' || p_table;
    v_max bigint;
BEGIN
    -- Only entities still on GenerationType.SEQUENCE take ids from Hibernate's <table>_seq. A leftover
    -- sequence of an entity now on IDENTITY steps by 50 and would give ids 1, 51, 101, ...
    IF v_seq IS NULL AND p_table IN ('faction_talent') AND to_regclass(p_table || '_seq') IS NOT NULL THEN
        v_seq := p_table || '_seq';
    END IF;
    IF v_seq IS NOT NULL THEN
        RETURN nextval(v_seq);
    END IF;
    IF to_regclass('pg_temp.' || v_tmp) IS NULL THEN
        EXECUTE format('SELECT COALESCE(max(id), 0) FROM %I', p_table) INTO v_max;
        EXECUTE format('CREATE TEMP SEQUENCE %I START %s', v_tmp, v_max + 1);
    END IF;
    RETURN nextval('pg_temp.' || quote_ident(v_tmp));
END $fn$;

-- ---------------------------------------------------------------------
-- 1. CORE SKILLS (name, governing characteristic)
-- ---------------------------------------------------------------------
INSERT INTO skill (id, name, description, characteristics_id)
SELECT pg_temp.next_id('skill'), v.name, '', c.id
FROM (VALUES
    ('ATHLETICS', 'STR'), ('AWARENESS', 'PER'), ('DEXTERITY', 'AG'), ('DISCIPLINE', 'WIL'),
    ('FORTITUDE', 'TGH'), ('INTUITION', 'PER'), ('LINGUISTICS', 'INT'), ('LOGIC', 'INT'),
    ('LORE', 'INT'), ('MEDICAE', 'INT'), ('MELEE', 'WS'), ('NAVIGATION', 'INT'),
    ('PILOTING', 'AG'), ('PRESENCE', 'WIL'), ('PSYCHIC MASTERY', 'WIL'), ('RANGED', 'BS'),
    ('RAPPORT', 'FEL'), ('REFLEXES', 'AG'), ('STEALTH', 'AG'), ('TECH', 'INT')
) AS v(name, char_name)
JOIN characteristics c ON c.name = v.char_name
WHERE NOT EXISTS (SELECT 1 FROM skill s WHERE upper(s.name) = v.name);

-- Skills created elsewhere without a characteristic (e.g. roles_data.sql) get one.
UPDATE skill s SET characteristics_id = c.id
FROM (VALUES
    ('ATHLETICS', 'STR'), ('AWARENESS', 'PER'), ('DEXTERITY', 'AG'), ('DISCIPLINE', 'WIL'),
    ('FORTITUDE', 'TGH'), ('INTUITION', 'PER'), ('LINGUISTICS', 'INT'), ('LOGIC', 'INT'),
    ('LORE', 'INT'), ('MEDICAE', 'INT'), ('MELEE', 'WS'), ('NAVIGATION', 'INT'),
    ('PILOTING', 'AG'), ('PRESENCE', 'WIL'), ('PSYCHIC MASTERY', 'WIL'), ('RANGED', 'BS'),
    ('RAPPORT', 'FEL'), ('REFLEXES', 'AG'), ('STEALTH', 'AG'), ('TECH', 'INT')
) AS v(name, char_name)
JOIN characteristics c ON c.name = v.char_name
WHERE upper(s.name) = v.name AND s.characteristics_id IS NULL;

-- ---------------------------------------------------------------------
-- 2. FACTIONS with fixed ids 1-9, in rulebook order
--    Core factions created earlier under other ids (for example 1, 51, 101, ...) are moved
--    to these ids together with every reference to them, including "factionId" in saved
--    characters. Stops without changes if a supplement faction holds one of these ids.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS pg_temp.core_faction_ids;
CREATE TEMP TABLE core_faction_ids (id bigint PRIMARY KEY, name text NOT NULL, influence text NOT NULL);
INSERT INTO core_faction_ids (id, name, influence) VALUES
    (1, 'ADEPTUS ADMINISTRATUM',     '+1 Influence with the Administratum, and a Contact (Personal Influence, page 193).'),
    (2, 'ADEPTUS ASTRA TELEPATHICA', '+1 Influence with the Adeptus Astra Telepathica. At the GM''s discretion, +1 Influence with a Faction of your choice instead.'),
    (3, 'ADEPTUS MECHANICUS',        '+1 Influence with the Adeptus Mechanicus.'),
    (4, 'ADEPTUS MINISTORUM',        '+1 Influence with the Ministorum.'),
    (5, 'ASTRA MILITARUM',           '+1 Influence with the Astra Militarum.'),
    (6, 'IMPERIAL FLEET',            '+1 Influence with the Navis Imperialis.'),
    (7, 'INFRACTIONIST',             '+1 Influence with Infractionists.'),
    (8, 'THE INQUISITION',           '+1 Influence with the Inquisition.'),
    (9, 'ROGUE TRADER DYNASTY',      '+1 Influence with Rogue Trader Dynasties.');

-- Moves one faction row to a new id: copies the row, repoints every reference, deletes the old row.
-- References are columns with a foreign key to faction(id), plus faction_id columns without any
-- foreign key (patron_duty has one). A faction_id column whose foreign key points elsewhere is skipped.
CREATE OR REPLACE FUNCTION pg_temp.move_faction(p_old bigint, p_new bigint) RETURNS void LANGUAGE plpgsql AS $fn$
DECLARE
    v_cols text;
    fk     record;
    s      record;
    j      jsonb;
BEGIN
    SELECT string_agg(quote_ident(column_name), ', ' ORDER BY ordinal_position) INTO v_cols
    FROM information_schema.columns
    WHERE table_schema = current_schema() AND table_name = 'faction' AND column_name <> 'id';
    EXECUTE format('INSERT INTO faction (id, %s) SELECT $1, %s FROM faction WHERE id = $2', v_cols, v_cols)
    USING p_new, p_old;

    FOR fk IN
        SELECT cl.relname::text AS tbl, att.attname::text AS col
        FROM pg_constraint con
        JOIN pg_class cl ON cl.oid = con.conrelid
        JOIN pg_attribute att ON att.attrelid = con.conrelid AND att.attnum = con.conkey[1]
        WHERE con.contype = 'f' AND con.confrelid = 'faction'::regclass
        UNION
        SELECT c.table_name::text, c.column_name::text
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON t.table_schema = c.table_schema AND t.table_name = c.table_name AND t.table_type = 'BASE TABLE'
        WHERE c.table_schema = current_schema()
          AND c.column_name = 'faction_id'
          AND c.table_name <> 'faction'
          AND NOT EXISTS (
              SELECT 1 FROM pg_constraint con
              JOIN pg_attribute att ON att.attrelid = con.conrelid AND att.attnum = con.conkey[1]
              WHERE con.contype = 'f'
                AND con.conrelid = format('%I', c.table_name)::regclass
                AND att.attname = c.column_name)
    LOOP
        EXECUTE format('UPDATE %I SET %I = $1 WHERE %I = $2', fk.tbl, fk.col, fk.col) USING p_new, p_old;
    END LOOP;

    DELETE FROM faction WHERE id = p_old;

    -- Saved characters keep the faction id inside their JSON. Rows that are not valid JSON are left alone.
    IF to_regclass('character_save') IS NOT NULL THEN
        FOR s IN SELECT id, data FROM character_save WHERE data LIKE '%factionId%' LOOP
            BEGIN
                j := s.data::jsonb;
            EXCEPTION WHEN others THEN
                CONTINUE;
            END;
            IF jsonb_typeof(j -> 'ccm' -> 'factionId') = 'number'
               AND (j -> 'ccm' ->> 'factionId')::numeric = p_old THEN
                UPDATE character_save SET data = jsonb_set(j, '{ccm,factionId}', to_jsonb(p_new))::text
                WHERE id = s.id;
            END IF;
        END LOOP;
    END IF;
END $fn$;

DO $$
DECLARE
    v_blocker text;
    v_parking bigint;
    m         record;
BEGIN
    SELECT string_agg(f.name || ' (' || COALESCE(f.source_book, 'no book') || ') holds id ' || f.id, '; ')
    INTO v_blocker
    FROM faction f
    JOIN core_faction_ids c ON c.id = f.id
    WHERE NOT EXISTS (SELECT 1 FROM core_faction_ids x WHERE x.name = f.name AND f.source_book = 'IM');
    IF v_blocker IS NOT NULL THEN
        RAISE EXCEPTION 'Core faction ids 1-9 are taken by other factions: %', v_blocker;
    END IF;

    -- Two steps, so factions that sit on each other's ids can swap: park every misplaced core
    -- faction above all existing ids first, then move each one to its final id.
    SELECT COALESCE(max(id), 0) + 1000 INTO v_parking FROM faction;
    FOR m IN
        SELECT f.id AS old_id, c.id AS new_id
        FROM faction f JOIN core_faction_ids c ON c.name = f.name AND f.source_book = 'IM'
        WHERE f.id <> c.id
    LOOP
        PERFORM pg_temp.move_faction(m.old_id, v_parking + m.new_id);
    END LOOP;

    FOR m IN
        SELECT c.id AS new_id, c.name
        FROM core_faction_ids c
        JOIN faction f ON f.id = v_parking + c.id AND f.name = c.name AND f.source_book = 'IM'
        ORDER BY c.id
    LOOP
        PERFORM pg_temp.move_faction(v_parking + m.new_id, m.new_id);
        RAISE NOTICE '% now has id %', m.name, m.new_id;
    END LOOP;
END $$;

INSERT INTO faction (id, name, influence_description, source_book)
SELECT c.id, c.name, c.influence, 'IM'
FROM core_faction_ids c
WHERE NOT EXISTS (SELECT 1 FROM faction f WHERE f.name = c.name AND f.source_book = 'IM');

-- The Faction entity uses IDENTITY: make sure faction.id has one and that it continues after the
-- highest id, so factions added later get 10, 11, ...
DO $$
DECLARE
    v_next bigint := (SELECT COALESCE(max(id), 0) + 1 FROM faction);
BEGIN
    IF pg_get_serial_sequence('faction', 'id') IS NOT NULL THEN
        PERFORM setval(pg_get_serial_sequence('faction', 'id'), v_next, false);
    ELSIF (SELECT column_default FROM information_schema.columns
           WHERE table_schema = current_schema() AND table_name = 'faction' AND column_name = 'id') IS NULL THEN
        EXECUTE format('ALTER TABLE faction ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (START WITH %s)', v_next);
    END IF;
END $$;

-- ---------------------------------------------------------------------
-- 3. CHARACTERISTICS: +5 primary, and +5 to one secondary of the player's choice
-- ---------------------------------------------------------------------
INSERT INTO characteristics_faction (id, faction_id, characteristics_id, primary_char)
SELECT pg_temp.next_id('characteristics_faction'), f.id, c.id, v.primary_char
FROM (VALUES
    ('ADEPTUS ADMINISTRATUM',     'INT', true), ('ADEPTUS ADMINISTRATUM',     'PER', false), ('ADEPTUS ADMINISTRATUM',     'WIL', false), ('ADEPTUS ADMINISTRATUM',     'FEL', false),
    ('ADEPTUS ASTRA TELEPATHICA', 'WIL', true), ('ADEPTUS ASTRA TELEPATHICA', 'INT', false), ('ADEPTUS ASTRA TELEPATHICA', 'PER', false), ('ADEPTUS ASTRA TELEPATHICA', 'TGH', false),
    ('ADEPTUS MECHANICUS',        'INT', true), ('ADEPTUS MECHANICUS',        'TGH', false), ('ADEPTUS MECHANICUS',        'AG',  false), ('ADEPTUS MECHANICUS',        'PER', false),
    ('ADEPTUS MINISTORUM',        'WIL', true), ('ADEPTUS MINISTORUM',        'INT', false), ('ADEPTUS MINISTORUM',        'PER', false), ('ADEPTUS MINISTORUM',        'FEL', false),
    ('ASTRA MILITARUM',           'TGH', true), ('ASTRA MILITARUM',           'WS',  false), ('ASTRA MILITARUM',           'BS',  false), ('ASTRA MILITARUM',           'STR', false),
    ('IMPERIAL FLEET',            'AG',  true), ('IMPERIAL FLEET',            'STR', false), ('IMPERIAL FLEET',            'TGH', false), ('IMPERIAL FLEET',            'PER', false),
    ('INFRACTIONIST',             'AG',  true), ('INFRACTIONIST',             'TGH', false), ('INFRACTIONIST',             'PER', false), ('INFRACTIONIST',             'FEL', false),
    ('THE INQUISITION',           'PER', true), ('THE INQUISITION',           'TGH', false), ('THE INQUISITION',           'INT', false), ('THE INQUISITION',           'WIL', false),
    ('ROGUE TRADER DYNASTY',      'FEL', true), ('ROGUE TRADER DYNASTY',      'AG',  false), ('ROGUE TRADER DYNASTY',      'INT', false), ('ROGUE TRADER DYNASTY',      'PER', false)
) AS v(faction_name, char_name, primary_char)
JOIN faction f ON f.name = v.faction_name AND f.source_book = 'IM'
JOIN characteristics c ON c.name = v.char_name
WHERE NOT EXISTS (
    SELECT 1 FROM characteristics_faction cf
    WHERE cf.faction_id = f.id AND cf.characteristics_id = c.id
);

-- ---------------------------------------------------------------------
-- 4. SKILL POOLS: 5 Advances to spend among these skills
-- ---------------------------------------------------------------------
INSERT INTO skill_factions (id, faction_id, skill_id)
SELECT pg_temp.next_id('skill_factions'), f.id, s.id
FROM (VALUES
    ('ADEPTUS ADMINISTRATUM', 'DEXTERITY'), ('ADEPTUS ADMINISTRATUM', 'LINGUISTICS'), ('ADEPTUS ADMINISTRATUM', 'LOGIC'),
    ('ADEPTUS ADMINISTRATUM', 'LORE'), ('ADEPTUS ADMINISTRATUM', 'MEDICAE'), ('ADEPTUS ADMINISTRATUM', 'NAVIGATION'),
    ('ADEPTUS ASTRA TELEPATHICA', 'AWARENESS'), ('ADEPTUS ASTRA TELEPATHICA', 'DISCIPLINE'), ('ADEPTUS ASTRA TELEPATHICA', 'INTUITION'),
    ('ADEPTUS ASTRA TELEPATHICA', 'LINGUISTICS'), ('ADEPTUS ASTRA TELEPATHICA', 'NAVIGATION'), ('ADEPTUS ASTRA TELEPATHICA', 'PSYCHIC MASTERY'),
    ('ADEPTUS MECHANICUS', 'DEXTERITY'), ('ADEPTUS MECHANICUS', 'LOGIC'), ('ADEPTUS MECHANICUS', 'LORE'),
    ('ADEPTUS MECHANICUS', 'MEDICAE'), ('ADEPTUS MECHANICUS', 'PILOTING'), ('ADEPTUS MECHANICUS', 'TECH'),
    ('ADEPTUS MINISTORUM', 'DISCIPLINE'), ('ADEPTUS MINISTORUM', 'INTUITION'), ('ADEPTUS MINISTORUM', 'LORE'),
    ('ADEPTUS MINISTORUM', 'MEDICAE'), ('ADEPTUS MINISTORUM', 'PRESENCE'), ('ADEPTUS MINISTORUM', 'RAPPORT'),
    ('ASTRA MILITARUM', 'ATHLETICS'), ('ASTRA MILITARUM', 'DISCIPLINE'), ('ASTRA MILITARUM', 'FORTITUDE'),
    ('ASTRA MILITARUM', 'MELEE'), ('ASTRA MILITARUM', 'RANGED'), ('ASTRA MILITARUM', 'STEALTH'),
    ('IMPERIAL FLEET', 'AWARENESS'), ('IMPERIAL FLEET', 'LOGIC'), ('IMPERIAL FLEET', 'NAVIGATION'),
    ('IMPERIAL FLEET', 'PILOTING'), ('IMPERIAL FLEET', 'REFLEXES'), ('IMPERIAL FLEET', 'TECH'),
    ('INFRACTIONIST', 'ATHLETICS'), ('INFRACTIONIST', 'DEXTERITY'), ('INFRACTIONIST', 'FORTITUDE'),
    ('INFRACTIONIST', 'RAPPORT'), ('INFRACTIONIST', 'REFLEXES'), ('INFRACTIONIST', 'STEALTH'),
    ('THE INQUISITION', 'AWARENESS'), ('THE INQUISITION', 'DISCIPLINE'), ('THE INQUISITION', 'INTUITION'),
    ('THE INQUISITION', 'LOGIC'), ('THE INQUISITION', 'LORE'), ('THE INQUISITION', 'PRESENCE'),
    ('ROGUE TRADER DYNASTY', 'INTUITION'), ('ROGUE TRADER DYNASTY', 'LINGUISTICS'), ('ROGUE TRADER DYNASTY', 'NAVIGATION'),
    ('ROGUE TRADER DYNASTY', 'PRESENCE'), ('ROGUE TRADER DYNASTY', 'PILOTING'), ('ROGUE TRADER DYNASTY', 'RAPPORT')
) AS v(faction_name, skill_name)
JOIN faction f ON f.name = v.faction_name AND f.source_book = 'IM'
JOIN skill s ON upper(s.name) = v.skill_name
WHERE NOT EXISTS (
    SELECT 1 FROM skill_factions sf WHERE sf.faction_id = f.id AND sf.skill_id = s.id
);

-- ---------------------------------------------------------------------
-- 5. FIXED TALENTS (Adeptus Mechanicus has none)
-- ---------------------------------------------------------------------
INSERT INTO faction_talent (id, faction_id, talent_id)
SELECT pg_temp.next_id('faction_talent'), f.id, t.id
FROM (VALUES
    ('ADEPTUS ADMINISTRATUM', 'DATA DELVER'),
    ('ADEPTUS MINISTORUM',    'FAITHFUL (IMPERIAL CULT)'),
    ('ASTRA MILITARUM',       'DRILLED'),
    ('IMPERIAL FLEET',        'VOID LEGS'),
    ('INFRACTIONIST',         'WELL-PREPARED'),
    ('THE INQUISITION',       'EVER VIGILANT'),
    ('ROGUE TRADER DYNASTY',  'DEALMAKER')
) AS v(faction_name, talent_name)
JOIN faction f ON f.name = v.faction_name AND f.source_book = 'IM'
JOIN talent t ON upper(t.name) = v.talent_name
WHERE NOT EXISTS (
    SELECT 1 FROM faction_talent ft WHERE ft.faction_id = f.id AND ft.talent_id = t.id
);

-- ---------------------------------------------------------------------
-- 6. TALENT CHOICE: Adeptus Astra Telepathica gains ONE of these options
--    1: Psyker + Sanctioned Psyker   2: Blank   3: Condemn the Witch + Mental Fortress
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_faction_id BIGINT;
    v_grp        BIGINT;
BEGIN
    SELECT id INTO v_faction_id FROM faction
    WHERE name = 'ADEPTUS ASTRA TELEPATHICA' AND source_book = 'IM';
    IF v_faction_id IS NULL THEN
        RETURN;
    END IF;
    -- An empty choice group would show up as a choice with no options, so wait for the talents.
    IF (SELECT count(*) FROM talent WHERE upper(name) IN
            ('PSYKER', 'SANCTIONED PSYKER', 'BLANK', 'CONDEMN THE WITCH', 'MENTAL FORTRESS')) < 5 THEN
        RAISE WARNING 'core_factions.sql: Astra Telepathica talent choice skipped, its talents are missing';
        RETURN;
    END IF;
    IF EXISTS (
        SELECT 1 FROM faction_talent_choice tc
        JOIN faction_inventory_choice_group g ON g.id = tc.faction_choice_group_id
        WHERE g.faction_id = v_faction_id
    ) THEN
        RETURN;
    END IF;

    INSERT INTO faction_inventory_choice_group (id, faction_id, choices_required)
    VALUES (pg_temp.next_id('faction_inventory_choice_group'), v_faction_id, 1) RETURNING id INTO v_grp;

    INSERT INTO faction_talent_choice (id, faction_choice_group_id, talent_id, option_id)
    SELECT pg_temp.next_id('faction_talent_choice'), v_grp, t.id, opt.option_id
    FROM (VALUES
        ('PSYKER',            1),
        ('SANCTIONED PSYKER', 1),
        ('BLANK',             2),
        ('CONDEMN THE WITCH', 3),
        ('MENTAL FORTRESS',   3)
    ) AS opt(talent_name, option_id)
    JOIN talent t ON upper(t.name) = opt.talent_name;
END $$;

-- ---------------------------------------------------------------------
-- 7. REPORT what is still missing (talents or skills absent from this database)
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_missing TEXT;
BEGIN
    SELECT string_agg(n, ', ') INTO v_missing
    FROM unnest(ARRAY['DATA DELVER', 'FAITHFUL (IMPERIAL CULT)', 'DRILLED', 'VOID LEGS', 'WELL-PREPARED',
                      'EVER VIGILANT', 'DEALMAKER', 'PSYKER', 'SANCTIONED PSYKER', 'BLANK',
                      'CONDEMN THE WITCH', 'MENTAL FORTRESS']) AS n
    WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE upper(t.name) = n);
    IF v_missing IS NOT NULL THEN
        RAISE WARNING 'core_factions.sql: talents not found, so not linked: %', v_missing;
    END IF;
END $$;
