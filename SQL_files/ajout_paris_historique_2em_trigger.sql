CREATE OR REPLACE FUNCTION ajouter_paris_historique_2em() RETURNS TRIGGER AS $$
BEGIN
    --On vérifie si l'utilisateur existe
    IF NOT EXISTS (SELECT 1 FROM utilisateur WHERE email = NEW.user_email) THEN
        RAISE EXCEPTION 'Utilisateur non existant : %', NEW.user_email;
    END IF;

    --On Insére le pari dans l'historique
    INSERT INTO historique_paris(user_email, date_pari, type_pari, id_pari, montant, gain_potentiel, resultat_pari)
    VALUES (NEW.user_email, CURRENT_DATE, 'paris_2equipes_marquent', NEW.paris_2em_id, NEW.montant, NEW.gain, 'En cours');

    -- On Met à jour le statut
    BEGIN
        UPDATE utilisateur SET type_bonus = 'Bonus utilisé' WHERE email = NEW.user_email;
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'La valeur de type_bonus n''existe pas dans la table offre.';
    END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS paris_historique_trigger_2em ON paris_2equipes_marquent;
CREATE TRIGGER paris_historique_trigger_2em
AFTER INSERT ON paris_2equipes_marquent
FOR EACH ROW EXECUTE PROCEDURE ajouter_paris_historique_2em();