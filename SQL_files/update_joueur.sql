--pour les tests

UPDATE joueur
SET nb_buts = 1
WHERE equipe = 2;

\echo table joueur
SELECT* FROM joueur;

\echo table est_buteur
SELECT* FROM est_buteur;
