-- Starting item granted by each core Imperium Maledictum origin (rulebook p. 52-54, 14.06.2023 update).
-- Run AFTER origins.sql and inventory.sql. Safe to run more than once.

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

-- Quality flaws used below. Other seed scripts may already have created them with a full description.
INSERT INTO item_modifier (id, name, type, description)
SELECT pg_temp.next_id('item_modifier'), 'Shoddy', 'flaw', 'Shoddy items impose a -10 penalty on Tests directly involving that item.'
WHERE NOT EXISTS (SELECT 1 FROM item_modifier WHERE name = 'Shoddy');

INSERT INTO item_modifier (id, name, type, description)
SELECT pg_temp.next_id('item_modifier'), 'Ugly', 'flaw', 'Item Flaw: see Item Flaws in the core rulebook.'
WHERE NOT EXISTS (SELECT 1 FROM item_modifier WHERE name = 'Ugly');

DO $$
DECLARE
    r record;
    v_origin_id bigint;
    v_inventory_id bigint;
    v_link_id bigint;
BEGIN
    FOR r IN
        SELECT * FROM (VALUES
            ('AGRI WORLD',       'Entrenching Tool', 'Shoddy'),
            ('FERAL WORLD',      'Survival Gear',    'Shoddy'),
            ('FEUDAL WORLD',     'Writing Kit',      'Shoddy'),
            ('FORGE WORLD',      'Sacred Unguents',  NULL),
            ('HIVE WORLD',       'Filtration Plugs', 'Ugly'),
            ('SCHOLA PROGENIUM', 'Chrono',           NULL),
            ('SHRINE WORLD',     'Holy Icon',        NULL),
            ('VOIDBORN',         'Mag Boots',        'Shoddy')
        ) AS t(origin_name, item_name, modifier_name)
    LOOP
        SELECT id INTO v_origin_id FROM origin
        WHERE upper(name) = r.origin_name AND (source_book = 'IM' OR source_book IS NULL)
        ORDER BY id LIMIT 1;
        SELECT min(id) INTO v_inventory_id FROM inventory WHERE name = r.item_name;

        IF v_origin_id IS NULL OR v_inventory_id IS NULL THEN
            RAISE WARNING 'Skipped %: origin or item "%" not found', r.origin_name, r.item_name;
            CONTINUE;
        END IF;
        IF EXISTS (SELECT 1 FROM origin_inventory_item
                   WHERE origin_id = v_origin_id AND inventory_id = v_inventory_id) THEN
            CONTINUE;
        END IF;

        INSERT INTO origin_inventory_item (id, origin_id, inventory_id)
        VALUES (pg_temp.next_id('origin_inventory_item'), v_origin_id, v_inventory_id)
        RETURNING id INTO v_link_id;

        IF r.modifier_name IS NOT NULL THEN
            INSERT INTO origin_inventory_modifier (origin_inventory_id, modifier_id)
            SELECT v_link_id, id FROM item_modifier WHERE name = r.modifier_name;
        END IF;
    END LOOP;
END $$;
