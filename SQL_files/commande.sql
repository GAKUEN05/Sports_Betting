
\i requete_VIEW.sql

TRUNCATE competition cascade;
SELECT* FROM competition_c_id_seq;
ALTER SEQUENCE competition_c_id_seq RESTART WITH 1;
\i insert_competition.sql

TRUNCATE equipes cascade;
SELECT* FROM equipes_e_id_seq;
ALTER SEQUENCE equipes_e_id_seq RESTART WITH 1;
\i insert_equipes.sql

TRUNCATE participation cascade;
\i insert_participation.sql

TRUNCATE offre cascade;
\i insert_offre.sql

\i user_insert_trigger.sql

\i insert_user.sql

\i mav_insert_trigger.sql

\i med_update_trigger.sql

\i ajout_paris_historique_jm_trigger.sql;
\i ajout_paris_historique_2em_trigger.sql;
\i ajout_paris_historique_se_trigger.sql;
\i ajout_paris12_historique_trigger.sql;

TRUNCATE match_a_venir cascade;
SELECT* FROM match_a_venir_mav_id_seq;
ALTER SEQUENCE match_a_venir_mav_id_seq RESTART WITH 1;
TRUNCATE match_en_direct cascade;
\echo match_en_direct_med_id_seq
SELECT* FROM match_en_direct_med_id_seq;
ALTER SEQUENCE match_en_direct_med_id_seq RESTART WITH 1;
\i insert_mav.sql

\i paris_2em_insert_trigger.sql

TRUNCATE paris_2equipes_marquent cascade;
SELECT* FROM paris_2equipes_marquent_paris_2em_id_seq;
ALTER SEQUENCE paris_2equipes_marquent_paris_2em_id_seq RESTART WITH 1;
\i insert_paris_2em.sql

\i equipes_update_trigger.sql

\i paris_score_exact_trigger.sql

\i paris_1_2_trigger.sql

\echo paris_1_2_paris_1_2_id_seq
SELECT* FROM paris_1_2_paris_1_2_id_seq;
ALTER SEQUENCE paris_1_2_paris_1_2_id_seq RESTART WITH 1;
\i insert_paris_1_2.sql

\echo paris_score_exact_paris_se_id_seq
SELECT* FROM paris_score_exact_paris_se_id_seq;
ALTER SEQUENCE paris_score_exact_paris_se_id_seq RESTART WITH 1;
\i insert_pari_exact.sql

\i joueur_update_trigger.sql

\echo joueur_j_id_seq
SELECT* FROM joueur_j_id_seq;
ALTER SEQUENCE joueur_j_id_seq RESTART WITH 1;

\i insert_joueur.sql

\echo paris_joueur_marque_paris_jm_id_seq
SELECT* FROM paris_joueur_marque_paris_jm_id_seq;
ALTER SEQUENCE paris_joueur_marque_paris_jm_id_seq RESTART WITH 1;

\i insert_pari_joueur.sql







