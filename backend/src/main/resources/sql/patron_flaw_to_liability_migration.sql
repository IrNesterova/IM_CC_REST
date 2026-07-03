-- Migration: rename patron_flaw → patron_liability
-- Run once against the existing database before restarting the app.

ALTER TABLE IF EXISTS patron_flaw RENAME TO patron_liability;

ALTER TABLE IF EXISTS patron_flaw_factions RENAME TO patron_liability_factions;
ALTER TABLE IF EXISTS patron_liability_factions
    RENAME COLUMN flaw_id TO liability_id;

ALTER TABLE IF EXISTS patron_selected_flaws RENAME TO patron_selected_liabilities;
ALTER TABLE IF EXISTS patron_selected_liabilities
    RENAME COLUMN flaw_id TO liability_id;
