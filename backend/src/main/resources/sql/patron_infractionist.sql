-- Patron data: Infractionist (Faction 7)
-- All INSERTs are idempotent (WHERE NOT EXISTS).

-- ── Duties ───────────────────────────────────────────────────────────────────

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Criminal Mastermind',
    'Your Patron has thrived in the vicious criminal undergrounds of the Macharian Sector, gaining significant power and resources and a desire for more.',
    'Plausible Deniability',
    'Your Patron counts amongst their servants some few who would be willing to break the Lex Imperialis and face the consequences on their behalf. Once per mission, you can request that your Patron send some of their ''plausibly deniable'' connections to commit a crime of your choosing, such as starting a riot to distract corrupt Vigilites, kidnapping a preacher during a sermon, or shooting the custom servitor bodyguard of a Highborn noble. Additionally, your Patron gains +1 Influence with Infractionists.',
    (SELECT id FROM faction WHERE LOWER(name) IN ('infractionist', 'infractionists') LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Criminal Mastermind');

INSERT INTO patron_duty (name, description, duty_boon_name, duty_boon_description, faction_id)
SELECT
    'Guildmaster',
    'Your Patron is the master of a guild, a form of trade organisation permitted on certain worlds as a means of controlling and directing labourers. Though their authority is typically very narrow, many Guildmasters are keen to expand their influence.',
    'Registered Trader',
    'Your Patron is one of the rare few individuals bestowed with a mandate for interplanetary trade within the Imperium. Your Patron may be able to acquire trade records, secure you passage on a trading vessel, and acquire anything from the Armoury at a discount equal to 10% multiplied by their highest Influence modifier. Additionally, your Patron gains +1 Influence with either the Adeptus Administratum, the Imperial Fleet, or Rogue Trader Dynasties.',
    (SELECT id FROM faction WHERE LOWER(name) IN ('infractionist', 'infractionists') LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM patron_duty WHERE name = 'Guildmaster');

-- ── Boon–Duty links: Criminal Mastermind (d10 boon table) ───────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Criminal Mastermind' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Criminal Mastermind duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Backchannel Contacts',
            'Blackmailer',
            'Contrabandist',
            'Cover Story',
            'Forger',
            'Gang Backup',
            'Sanctum Obscurus',
            'Spy Network',
            'Strategos Extremis',
            'Tentative Alliance'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Criminal Mastermind (d10 liability table) ───────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Criminal Mastermind' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Criminal Mastermind duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Corrupt',
            'Dangerous Debt',
            'Enemy',
            'Excommunicated',
            'Paranoid',
            'Saboteur',
            'Shoddy Supplies',
            'Strange Tastes',
            'Suspect'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Boon–Duty links: Guildmaster (d10 boon table) ────────────────────────────

DO $$
DECLARE
    v_duty_id BIGINT;
    v_boon_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Guildmaster' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Guildmaster duty not found — skipping boon links.';
        RETURN;
    END IF;

    FOREACH v_boon_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_boon WHERE name IN (
            'Backchannel Contacts',
            'Blackmailer',
            'Clerk Cadre',
            'Connoisseur',
            'Forger',
            'Gang Backup',
            'Manufactorum Master',
            'Noble Blood',
            'Plausible Deniability',
            'Tentative Alliance'
        )
    )
    LOOP
        INSERT INTO patron_boon_duties (boon_id, duty_id)
        VALUES (v_boon_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ── Liability–Duty links: Guildmaster (d10 liability table) ──────────────────

DO $$
DECLARE
    v_duty_id      BIGINT;
    v_liability_id BIGINT;
BEGIN
    SELECT id INTO v_duty_id FROM patron_duty WHERE name = 'Guildmaster' LIMIT 1;
    IF v_duty_id IS NULL THEN
        RAISE NOTICE 'Guildmaster duty not found — skipping liability links.';
        RETURN;
    END IF;

    FOREACH v_liability_id IN ARRAY (
        SELECT ARRAY_AGG(id) FROM patron_liability WHERE name IN (
            'Abrupt',
            'Blackmailed',
            'Craven',
            'Dangerous Debt',
            'Enemy',
            'Frail Form',
            'Impostor',
            'Price of Life',
            'Shaky Authority',
            'Strange Tastes'
        )
    )
    LOOP
        INSERT INTO patron_liability_duties (liability_id, duty_id)
        VALUES (v_liability_id, v_duty_id)
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;
