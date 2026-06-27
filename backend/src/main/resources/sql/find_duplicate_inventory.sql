SELECT name, COUNT(*) AS count, array_agg(id ORDER BY id) AS ids
FROM inventory
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY name;