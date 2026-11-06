-- Repairs the 8 core Imperium Maledictum origins on a database that was only partly seeded.
-- Sets source_book, fills in missing characteristic bonuses (rulebook p. 51) and moves the
-- origin id sequence past existing rows. Safe to run more than once.

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

UPDATE origin SET source_book = 'IM'
WHERE source_book IS NULL
  AND upper(name) IN ('AGRI WORLD', 'FERAL WORLD', 'FEUDAL WORLD', 'FORGE WORLD',
                      'HIVE WORLD', 'SCHOLA PROGENIUM', 'SHRINE WORLD', 'VOIDBORN');

UPDATE origin SET examples = 'Illisear, Omyr'
WHERE upper(name) = 'FERAL WORLD' AND examples = 'Goros Pok, Illisear';

-- +5 to the primary characteristic, and +5 to one secondary of the player's choice.
INSERT INTO character_origin (id, origin_id, character_id, primary_char)
SELECT pg_temp.next_id('character_origin'), o.id, c.id, v.primary_char
FROM (VALUES
    ('AGRI WORLD',       'STR', true),  ('AGRI WORLD',       'TGH', false), ('AGRI WORLD',       'AG',  false), ('AGRI WORLD',       'WIL', false),
    ('FERAL WORLD',      'TGH', true),  ('FERAL WORLD',      'WS',  false), ('FERAL WORLD',      'STR', false), ('FERAL WORLD',      'PER', false),
    ('FEUDAL WORLD',     'WS',  true),  ('FEUDAL WORLD',     'STR', false), ('FEUDAL WORLD',     'WIL', false), ('FEUDAL WORLD',     'FEL', false),
    ('FORGE WORLD',      'INT', true),  ('FORGE WORLD',      'BS',  false), ('FORGE WORLD',      'TGH', false), ('FORGE WORLD',      'AG',  false),
    ('HIVE WORLD',       'AG',  true),  ('HIVE WORLD',       'BS',  false), ('HIVE WORLD',       'PER', false), ('HIVE WORLD',       'FEL', false),
    ('SCHOLA PROGENIUM', 'FEL', true),  ('SCHOLA PROGENIUM', 'WS',  false), ('SCHOLA PROGENIUM', 'BS',  false), ('SCHOLA PROGENIUM', 'TGH', false),
    ('SHRINE WORLD',     'WIL', true),  ('SHRINE WORLD',     'INT', false), ('SHRINE WORLD',     'PER', false), ('SHRINE WORLD',     'FEL', false),
    ('VOIDBORN',         'PER', true),  ('VOIDBORN',         'AG',  false), ('VOIDBORN',         'INT', false), ('VOIDBORN',         'WIL', false)
) AS v(origin_name, char_name, primary_char)
JOIN origin o ON upper(o.name) = v.origin_name AND o.source_book = 'IM'
JOIN characteristics c ON c.name = v.char_name
WHERE NOT EXISTS (
    SELECT 1 FROM character_origin co
    WHERE co.origin_id = o.id AND co.character_id = c.id
);

SELECT setval(pg_get_serial_sequence('origin', 'id'), (SELECT COALESCE(MAX(id), 0) + 1 FROM origin), false);
