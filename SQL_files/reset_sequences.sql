--view sequences
\echo competition_c_id_seq
SELECT* FROM competition_c_id_seq;
ALTER SEQUENCE competition_c_id_seq RESTART WITH 1;

\echo equipes_e_id_seq
SELECT* FROM equipes_e_id_seq;
ALTER SEQUENCE equipes_e_id_seq RESTART WITH 1;

\echo match_en_direct_med_id_seq
SELECT* FROM match_en_direct_med_id_seq;
ALTER SEQUENCE match_en_direct_med_id_seq RESTART WITH 1;

\echo match_a_venir_mav_id_seq
SELECT* FROM match_a_venir_mav_id_seq;
ALTER SEQUENCE match_a_venir_mav_id_seq RESTART WITH 1;

\echo stats_rencontre_precd_mp_id_seq
SELECT* FROM stats_rencontre_precd_mp_id_seq;
ALTER SEQUENCE stats_rencontre_precd_mp_id_seq RESTART WITH 1;

\echo paris_2equipes_marquent_paris_2em_id_seq
SELECT* FROM paris_2equipes_marquent_paris_2em_id_seq;
ALTER SEQUENCE paris_2equipes_marquent_paris_2em_id_seq RESTART WITH 1;

\echo paris_1_2_paris_1_2_id_seq
SELECT* FROM paris_1_2_paris_1_2_id_seq;
ALTER SEQUENCE paris_1_2_paris_1_2_id_seq RESTART WITH 1;

\echo paris_score_exact_paris_se_id_seq
SELECT* FROM paris_score_exact_paris_se_id_seq;
ALTER SEQUENCE paris_score_exact_paris_se_id_seq RESTART WITH 1;

\echo joueur_j_id_seq
SELECT* FROM joueur_j_id_seq;
ALTER SEQUENCE joueur_j_id_seq RESTART WITH 1;

\echo paris_joueur_marque_paris_jm_id_seq
SELECT* FROM paris_joueur_marque_paris_jm_id_seq;
ALTER SEQUENCE paris_joueur_marque_paris_jm_id_seq RESTART WITH 1;
