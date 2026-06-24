-- Линкует critical_wound.injury_id на injury.id по тексту поля injury.
-- Запускать ПОСЛЕ critical_wounds_data.sql и injuries_data.sql.
-- Повторный запуск безопасен (WHERE injury_id IS NULL / DO UPDATE не меняет уже проставленные).

DO $$
BEGIN

-- ================================================================
-- Сначала — Major Broken Bones (более тяжёлые, приоритет выше)
-- ================================================================

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Major) — Head (Jaw)')
WHERE injury ILIKE '%Broken Bone (Major)%' AND (injury ILIKE '%jaw%' OR injury ILIKE '%jaws%') AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Major) — Head (Eye)')
WHERE injury ILIKE '%Broken Bone (Major)%' AND injury ILIKE '%eye%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Major) — Head (Nose)')
WHERE injury ILIKE '%Broken Bone (Major)%' AND injury ILIKE '%nose%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Major) — Arm')
WHERE injury ILIKE '%Broken Bone (Major)%' AND (injury ILIKE '%arm%' OR injury ILIKE '%hand%') AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Major) — Torso')
WHERE injury ILIKE '%Broken Bone (Major)%' AND (injury ILIKE '%torso%' OR injury ILIKE '%spine%' OR injury ILIKE '%rib%') AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Major) — Leg')
WHERE injury ILIKE '%Broken Bone (Major)%' AND (injury ILIKE '%leg%' OR injury ILIKE '%foot%' OR injury ILIKE '%hip%') AND injury_id IS NULL;

-- ================================================================
-- Minor Broken Bones
-- ================================================================

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Minor) — Head (Jaw)')
WHERE injury ILIKE '%Broken Bone (Minor)%' AND injury ILIKE '%jaw%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Minor) — Head (Eye)')
WHERE injury ILIKE '%Broken Bone (Minor)%' AND injury ILIKE '%eye%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Minor) — Head (Nose)')
WHERE injury ILIKE '%Broken Bone (Minor)%' AND injury ILIKE '%nose%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Minor) — Arm')
WHERE injury ILIKE '%Broken Bone (Minor)%' AND (injury ILIKE '%arm%' OR injury ILIKE '%hand%' OR injury ILIKE '%collarbone%') AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Minor) — Torso')
WHERE injury ILIKE '%Broken Bone (Minor)%' AND (injury ILIKE '%torso%' OR injury ILIKE '%rib%') AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Broken Bone (Minor) — Leg')
WHERE injury ILIKE '%Broken Bone (Minor)%' AND (injury ILIKE '%leg%' OR injury ILIKE '%hip%') AND injury_id IS NULL;

-- ================================================================
-- Amputations (после Broken Bones — меньший приоритет)
-- ================================================================

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Ear)')
WHERE injury ILIKE '%Amputation (Ear)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Eye)')
WHERE injury ILIKE '%Amputation (Eye)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Teeth)')
WHERE injury ILIKE '%Amputation (Teeth)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Nose)')
WHERE injury ILIKE '%Amputation (Nose)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Tongue)')
WHERE injury ILIKE '%Amputation (Tongue)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Finger)')
WHERE injury ILIKE '%Amputation (Finger)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Hand)')
WHERE injury ILIKE '%Amputation (Hand)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Arm)')
WHERE injury ILIKE '%Amputation (Arm)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Toe)')
WHERE injury ILIKE '%Amputation (Toe)%' AND injury NOT ILIKE '%Amputation (Toes)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Toes)')
WHERE injury ILIKE '%Amputation (Toes)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Foot)')
WHERE injury ILIKE '%Amputation (Foot)%' AND injury_id IS NULL;

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Amputation (Leg)')
WHERE injury ILIKE '%Amputation (Leg)%' AND injury_id IS NULL;

-- ================================================================
-- Other
-- ================================================================

UPDATE critical_wound SET injury_id = (SELECT id FROM injury WHERE name = 'Concussion')
WHERE injury ILIKE '%Concussion%' AND injury_id IS NULL;

END $$;