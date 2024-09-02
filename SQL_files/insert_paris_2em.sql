--pour les tests

INSERT INTO paris_2equipes_marquent (choix, mav_id, med_id, date_paris, user_email, montant)
VALUES
(1, 2, NULL, '2024-06-15 15:00:00', 'arnold@gmail.com', 500),
(1, 1, NULL, '2024-06-15 15:00:00', 'florent@gmail.com', 500);
--(1, 2, NULL, '2024-06-15 15:00:00', 'florent@gmail.com', 500);

\echo table paris_2equipes_marquent
SELECT* FROM paris_2equipes_marquent;
