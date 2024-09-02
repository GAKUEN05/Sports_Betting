-- Trigger pour paris_joueur_marque
CREATE OR REPLACE FUNCTION ajouter_paris_historique_jm() RETURNS TRIGGER AS $$
BEGIN
    -- On Vérifie si l'utilisateur existe
    IF NOT EXISTS (SELECT 1 FROM utilisateur WHERE email = NEW.user_email) THEN
        RAISE EXCEPTION 'Utilisateur non existant : %', NEW.user_email;
    END IF;

    -- On Insére le pari dans l'historique
    INSERT INTO historique_paris(user_email, date_pari, type_pari, id_pari, montant, gain_potentiel, resultat_pari)
    VALUES (NEW.user_email, NEW.date_pari, 'paris_joueur_marque', NEW.paris_jm_id, NEW.montant, NEW.gain, 'En cours');

    -- On Met à jour le statut
    BEGIN
        UPDATE utilisateur SET type_bonus = 'Bonus utilisé' WHERE email = NEW.user_email;
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'La valeur de type_bonus n''existe pas dans la table offre.';
    END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS paris_historique_trigger_jm ON paris_joueur_marque;
CREATE TRIGGER paris_historique_trigger_jm
AFTER INSERT ON paris_joueur_marque
FOR EACH ROW EXECUTE PROCEDURE ajouter_paris_historique_jm();