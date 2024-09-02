--pour les tests

UPDATE equipes 
SET 
score = 3
WHERE nom_pays = 'Allemagne';

UPDATE equipes 
SET 
score = 2
WHERE nom_pays = 'France';

\echo equipes
SELECT* FROM equipes;

\echo match_en_direct
SELECT* FROM view_match_en_direct;

\echo table paris_2equipes_marquent
SELECT* FROM paris_2equipes_marquent;

\echo paris_score_Exact
SELECT* FROM paris_score_Exact;

\echo paris_1_2
SELECT * FROM paris_1_2;

\echo table paris_joueur_marque
SELECT* FROM paris_joueur_marque;

