-- Migration: add source_book column to patron_boon and patron_liability.
-- Run AFTER the app has started at least once (so Hibernate creates the column),
-- OR run this manually to add the column with DEFAULT before starting the app.

ALTER TABLE patron_boon
    ADD COLUMN IF NOT EXISTS source_book VARCHAR(10) DEFAULT 'IM';

ALTER TABLE patron_liability
    ADD COLUMN IF NOT EXISTS source_book VARCHAR(10) DEFAULT 'IM';

UPDATE patron_boon    SET source_book = 'IM' WHERE source_book IS NULL;
UPDATE patron_liability SET source_book = 'IM' WHERE source_book IS NULL;
