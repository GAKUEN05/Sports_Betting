DROP VIEW if exists view_match_a_venir;
DROP VIEW if exists view_match_en_direct;
DROP VIEW if exists view_stats_rencontre_precd;


\echo VIEW view_match_à_venir 
CREATE OR REPLACE VIEW view_match_a_venir AS
SELECT mav_id , c_id , lieu, heure, e1.nom_pays as pays1, cote_equipe_1 as cote1, cote_equipe_2 as cote2, e2.nom_pays as pays2, temp_restant as t_rest, statut
FROM match_a_venir mav
JOIN equipes e1 ON mav.eid_equipe_1 = e1.e_id
JOIN equipes e2 ON mav.eid_equipe_2 = e2.e_id;

SELECT* FROM view_match_a_venir;


\echo VIEW view_match_en_direct 
CREATE OR REPLACE VIEW view_match_en_direct AS
SELECT med_id as id , c_id, lieu, heure, e1.nom_pays as pays1, cote_equipe_1 as cote1, e1.score as score1, e2.score as score2,cote_equipe_2 as cote2, e2.nom_pays as pays2, temp_restant as t_rest, statut 
FROM match_en_direct med
JOIN equipes e1 ON med.eid_equipe_1 = e1.e_id
JOIN equipes e2 ON med.eid_equipe_2 = e2.e_id;

SELECT* FROM view_match_en_direct;

\echo VIEW view_stats_rencontre_precd 
CREATE OR REPLACE VIEW view_stats_rencontre_precd  AS
WITH new_stats AS
(SELECT match_id, c_id,lieu, heure, nom_pays, mp1.score  
FROM equipes
JOIN stats_rencontre_precd mp1 ON equipe = e_id)
SELECT s1.match_id, s1.c_id ,s1.lieu, s1.heure, s1.nom_pays as pays1, s1.score as score1, s2.score as score2, s2.nom_pays as pays2 
FROM new_stats s1
JOIN new_stats s2 ON s1.nom_pays<>s2.nom_pays
LIMIT 1;

SELECT* FROM view_stats_rencontre_precd;





