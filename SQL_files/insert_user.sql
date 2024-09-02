INSERT INTO utilisateur (email, nom, prenom, age, type_bonus)
VALUES
('florent@gmail.com', 'florent', 'florent', 26, 'rembourssement_mise'),
('arnold@gmail.com', 'arnold', 'arnold', 28, 'rembourssement_mise'),
('florent@gmail.com', 'thomas', 'thomas', 14, 'rembourssement_mise');

\echo table utilisateur
SELECT * FROM utilisateur;

