--pour les tests

UPDATE match_en_direct SET temp_restant = 35
WHERE med_id = 2;

\echo match_en_direct
SELECT* FROM view_match_en_direct;

\echo stats_rencontre_precd
SELECT* FROM view_stats_rencontre_precd;

