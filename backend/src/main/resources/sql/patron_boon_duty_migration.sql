-- Migration: link boons and liabilities to duties (not factions).
-- Boon/liability pools are per-duty (d10 tables), not per-faction.
-- The old patron_boon_factions / patron_liability_factions tables are left in
-- place but are no longer used by the application.

CREATE TABLE IF NOT EXISTS patron_boon_duties (
    boon_id    BIGINT NOT NULL REFERENCES patron_boon(id),
    duty_id    BIGINT NOT NULL REFERENCES patron_duty(id),
    PRIMARY KEY (boon_id, duty_id)
);

CREATE TABLE IF NOT EXISTS patron_liability_duties (
    liability_id BIGINT NOT NULL REFERENCES patron_liability(id),
    duty_id      BIGINT NOT NULL REFERENCES patron_duty(id),
    PRIMARY KEY (liability_id, duty_id)
);