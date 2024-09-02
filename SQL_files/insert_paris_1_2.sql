--pour les tests

INSERT INTO paris_1_2 (nom_equipe, mav_id, med_id, date_pari, user_email, montant)
VALUES
('N', 2, NULL, '2024-06-15 15:00:00', 'arnold@gmail.com', 500);
--('N', 1, NULL, '2024-06-15 15:00:00', 'florent@gmail.com', 500);

\echo paris_1_2
SELECT * FROM paris_1_2;
