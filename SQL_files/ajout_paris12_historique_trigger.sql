CREATE OR REPLACE FUNCTION ajouter_paris_historique() RETURNS TRIGGER AS $$
BEGIN
    -- On Vérifie si l'utilisateur existe
    IF NOT EXISTS (SELECT 1 FROM utilisateur WHERE email = NEW.user_email) THEN
        RAISE EXCEPTION 'Utilisateur non existant : %', NEW.user_email;
    END IF;

    -- On Insére le pari dans l'historique
    INSERT INTO historique_paris(user_email, date_pari, type_pari, id_pari, montant, gain_potentiel, resultat_pari)
    VALUES (NEW.user_email, NEW.date_pari, 'paris_1_2', NEW.paris_1_2_id, NEW.montant, NEW.gain, 'En cours');

    -- On met à jour le statut
    BEGIN
        UPDATE utilisateur SET type_bonus = 'Bonus utilisé' WHERE email = NEW.user_email;
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'La valeur de type_bonus n''existe pas dans la table offre.';
    END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS paris_historique_trigger ON paris_1_2;
CREATE TRIGGER paris_historique_trigger
AFTER INSERT ON paris_1_2
FOR EACH ROW EXECUTE PROCEDURE ajouter_paris_historique();