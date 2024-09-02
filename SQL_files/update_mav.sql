--pour les tests

UPDATE match_a_venir SET temp_restant = 90
WHERE mav_id =1;

\echo match_a_venir
SELECT* FROM view_match_a_venir;

\echo match_en_direct
SELECT* FROM view_match_en_direct;

