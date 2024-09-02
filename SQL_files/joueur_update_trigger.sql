drop trigger if exists maj_statut_pari_joueur_marque_trigger ON joueur;


CREATE OR REPLACE FUNCTION maj_statut_pari_joueur_marque()
RETURNS TRIGGER AS $$
DECLARE
    joueur_id INT;
    equipe_id INT;
    buts_equipe INT;
    match_id INT;
    pari_montant DECIMAL(10,2);
    pari_gain DECIMAL(10,2);
    nb_buteurs INT;
BEGIN
    -- Récupération de l'id du joueur
    joueur_id := NEW.j_id;

    -- Vérification si ce joueur est dans l'une des équipes qui joue un match en direct
    SELECT med_id, e_id
    INTO match_id, equipe_id
    FROM match_en_direct, equipes
    WHERE (eid_equipe_1 = e_id OR eid_equipe_2 = e_id) AND temp_restant <> 0;

    IF match_id IS NOT NULL THEN
        -- Vérification si cette équipe a déjà inscrit un but
        SELECT score
        INTO buts_equipe
        FROM equipes WHERE e_id = equipe_id;
        
        --comptage du nombre de buteurs pour l'équipe
        SELECT count(j_id)
        INTO nb_buteurs
        FROM est_buteur
        WHERE e_id = equipe_id;

        IF (buts_equipe > 0 AND buts_equipe > nb_buteurs) THEN
            -- Ajout de ce joueur à la liste des buteurs pour le match en cours
            INSERT INTO est_buteur (j_id, e_id, c_id)
            VALUES (joueur_id, equipe_id, match_id);

            -- Récupération du montant du pari
            SELECT montant
            INTO pari_montant
            FROM paris_joueur_marque WHERE j_id = joueur_id;

            -- Calcul du gain du pari
            pari_gain := pari_montant * 1.5;  -- Ici, on suppose que le gain est le montant du pari multiplié par 1.5

            -- Mise à jour du gain du pari
            UPDATE paris_joueur_marque
            SET gain = pari_gain
            WHERE j_id = joueur_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER maj_statut_pari_joueur_marque_trigger
AFTER UPDATE ON joueur
FOR EACH ROW EXECUTE FUNCTION maj_statut_pari_joueur_marque();
