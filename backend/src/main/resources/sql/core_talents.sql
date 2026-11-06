-- =====================================================================
-- IMPERIUM MALEDICTUM — CORE TALENTS (rulebook p. 102-117, 14.06.2023 update)
-- 93 core talents. This script:
--   1. fixes misspelled names found on the Render database, so seeds that use
--      the rulebook spelling (roles, talent advancements) can find them;
--   2. adds core talents that are missing, with a short summary of the rule;
--   3. marks core talents as source_book 'IM' and gives max_advances a default.
-- Repeatable talents get their real maximum from talent_advancements_data.sql,
-- which should run AFTER this script. Requirements are not seeded: nothing in
-- the app reads them yet. Safe to run more than once.
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
-- 1. MISSPELLED NAMES -> rulebook spelling (skipped if the correct name already exists)
-- ---------------------------------------------------------------------
UPDATE talent t SET name = v.correct
FROM (VALUES
    ('AMBIDEXTEROUS',            'AMBIDEXTROUS'),
    ('CLOSE QUARTER DISCIPLINE', 'CLOSE QUARTERS DISCIPLINE'),
    ('DUELIST',                  'DUELLIST'),
    ('FLEBOTOMIST',              'PHLEBOTOMIST'),
    ('HYPNO-INDOCRINATION',      'HYPNO-INDOCTRINATION'),
    ('LAW BRINGER',              'LAWBRINGER')
) AS v(wrong, correct)
WHERE upper(t.name) = v.wrong
  AND NOT EXISTS (SELECT 1 FROM talent x WHERE upper(x.name) = v.correct);

-- ---------------------------------------------------------------------
-- 2. MISSING CORE TALENTS (summaries, see the rulebook for the full text)
-- ---------------------------------------------------------------------
INSERT INTO talent (id, name, description, max_advances, source_book)
SELECT pg_temp.next_id('talent'), v.name, v.description, 1, 'IM'
FROM (VALUES
    ('ACUTE SENSE',
     'One of your five senses is exceptionally keen. With it you may make Perception Tests to notice details that would normally be imperceptible, as the GM decides.'),
    ('ADRENALINE ACCELERATION',
     'You find extra speed when your life is in danger. While you have a Critical Wound, your Speed increases by one step until the end of the Encounter, and you have Advantage on Athletics Tests during a Pursuit or while Fleeing.')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM talent t WHERE upper(t.name) = v.name);

-- ---------------------------------------------------------------------
-- 3. SOURCE BOOK AND DEFAULT MAX ADVANCES FOR CORE TALENTS
-- ---------------------------------------------------------------------
WITH core(name) AS (VALUES
    ('ACUTE SENSE'), ('ADRENALINE ACCELERATION'), ('AGILE ATTACKS'), ('AIR OF AUTHORITY'), ('AMBIDEXTROUS'),
    ('APPLIED ANATOMY'), ('ARTISTIC'), ('ATTENTIVE ASSISTANT'), ('BLANK'), ('BONE BREAKER'), ('BRIBER'),
    ('BULWARK'), ('BURGLAR'), ('CHIRURGEON'), ('CLOSE QUARTERS DISCIPLINE'), ('COMBAT MASTER'),
    ('CONDEMN THE WITCH'), ('CONTORTIONIST'), ('COUNTER ATTACK'), ('COUP DE GRACE'), ('DATA DELVER'),
    ('DEADEYE'), ('DEALMAKER'), ('DEMOLITION SPECIALIST'), ('DEVOTED SERVANT'), ('DIRECTED STRIKES'),
    ('DIRTY FIGHTING'), ('DISARM'), ('DISTRACTING'), ('DISTURBING VOICE'), ('DRILLED'), ('DUAL WIELDER'),
    ('DUELLIST'), ('EIDETIC MEMORY'), ('EVER VIGILANT'), ('EXPLOIT VULNERABILITY'), ('EXTENDED PROPRIOCEPTION'),
    ('FAITHFUL (IMPERIAL CULT)'), ('FALSE RETREAT'), ('FAMILIAR TERRAIN'), ('FATED'), ('FIELD MEDICAE'),
    ('FLAGELLANT'), ('FLANKING FIRE'), ('FLESH IS WEAK'), ('FORBIDDEN KNOWLEDGE'), ('FORGER'), ('FRENZY'),
    ('FULL-AUTO FANATIC'), ('GALLOWS HUMOUR'), ('GOTHIC GIBBERISH'), ('GUARDIAN'), ('GUNSLINGER'), ('HATRED'),
    ('HIT AND RUN'), ('HOLDOUT EXPERT'), ('HYPNO-INDOCTRINATION'), ('ICON BEARER'), ('IGNORANCE IS MY SHIELD'),
    ('INHERITOR'), ('INSPIRING PRESENCE'), ('LAWBRINGER'), ('LICKSPITTLE'), ('MARTYRDOM'), ('MEDICAE MAVERICK'),
    ('MENTAL FORTRESS'), ('MIMIC'), ('OVERSEER'), ('PATHOLOGIST'), ('PHLEBOTOMIST'), ('PORTER'),
    ('PSYCHIC CASTIGATION'), ('PSYCHIC FLOOD'), ('PSYKER'), ('QUICKDRAW'), ('RAPID RELOAD'), ('READ LIPS'),
    ('REGISTERED TRADER'), ('SANCTIONED PSYKER'), ('SECRET IDENTITY'), ('SHOCK ASSAULT'), ('SKULKER'),
    ('SLIPPERY'), ('SUPERIOR COMMANDER'), ('SUPPRESSING FIRE'), ('SURE-FOOTED'), ('TACTICAL MOVEMENT'),
    ('TENACIOUS'), ('TWO-HANDED CLEAVE'), ('UNFLINCHING PRESENCE'), ('UNREMARKABLE'), ('VOID LEGS'),
    ('WELL-PREPARED')
)
UPDATE talent t
SET source_book  = COALESCE(t.source_book, 'IM'),
    max_advances = COALESCE(t.max_advances, 1)
FROM core
WHERE upper(t.name) = core.name
  AND (t.source_book IS NULL OR t.max_advances IS NULL);

-- ---------------------------------------------------------------------
-- 4. REPORT leftovers that need a human look
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_dupes TEXT;
    v_typos TEXT;
BEGIN
    SELECT string_agg(n || ' x' || c, ', ') INTO v_dupes
    FROM (SELECT upper(name) n, count(*) c FROM talent GROUP BY upper(name) HAVING count(*) > 1) d;
    IF v_dupes IS NOT NULL THEN
        RAISE WARNING 'core_talents.sql: duplicate talent names: %', v_dupes;
    END IF;

    SELECT string_agg(name, ', ') INTO v_typos FROM talent
    WHERE upper(name) IN ('AMBIDEXTEROUS', 'CLOSE QUARTER DISCIPLINE', 'DUELIST', 'FLEBOTOMIST',
                          'HYPNO-INDOCRINATION', 'LAW BRINGER');
    IF v_typos IS NOT NULL THEN
        RAISE WARNING 'core_talents.sql: misspelled talents kept because the correct name also exists: %', v_typos;
    END IF;
END $$;
