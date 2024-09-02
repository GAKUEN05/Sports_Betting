drop trigger if exists maj_score_et_gains_trigger ON equipes;

CREATE OR REPLACE FUNCTION maj_score_et_gains()
RETURNS TRIGGER AS $$
DECLARE
	equipe_id INT;
	e_1_id INT;
	e_2_id INT;
	match_id INT;
	equipe_1_score INT;
	equipe_2_score INT;
	montant_pari REAL;
	gain_pari REAL;
	score1 INT;
	score2 INT;
	temp_rest INT;
	pari_score1 INT;
	pari_score2 INT;
	cote_1 INT;
    	cote_2 INT; 
	choix_equipe INT;
	match_nul VARCHAR(100);
BEGIN
	-- Récupération de l'id de l'équipe
	equipe_id := NEW.e_id;
    	-- Vérification si l'équipe joue dans un match en direct
	SELECT DISTINCT m.eid_equipe_1, m.eid_equipe_2, m.med_id
	INTO e_1_id, e_2_id, match_id
	FROM match_en_direct m WHERE m.temp_restant <> 0;
	
	IF (match_id IS NULL) THEN 
		RETURN NULL;
	END IF;

    	-- Si l'équipe joue dans un match en direct
    	IF (match_id IS NOT NULL) THEN
		-- recuperer les scores des équipes
		IF (NEW.e_id = e_1_id) THEN
			SELECT score
			INTO equipe_2_score
			FROM equipes WHERE e_id = e_2_id;
			
			equipe_1_score = NEW.score;
		END IF;
		
		IF (NEW.e_id = e_2_id) THEN
			SELECT score
			INTO equipe_1_score
			FROM equipes WHERE e_id = e_1_id;
			
			equipe_2_score = NEW.score;
		END IF;

		--recupérer un parieur sur le score exacte
		SELECT score_equipe_1, score_equipe_2
		INTO pari_score1, pari_score2
		FROM paris_Score_Exact
		WHERE med_id = match_id;

		--recupérer les cotes des équipes
		SELECT cote_equipe_1 , cote_equipe_2
		INTO cote_1 , cote_2
		FROM match_en_direct
		WHERE med_id = match_id;
		
		--pour un paris sur un match nul
		SELECT nom_equipe
		INTO match_nul
		FROM paris_1_2
		WHERE med_id = match_id;
		
		IF (match_nul = 'N') THEN
			IF (equipe_1_score = equipe_2_score) THEN
			    -- Mettre à jour le gain du parieur
			    UPDATE paris_1_2
			    SET gain = montant * (cote_1 + cote_2)/2
			    WHERE mav_id = match_id AND statut <> 'terminé' 
			    OR med_id = match_id AND statut <> 'terminé';
			ELSE
			    UPDATE paris_1_2
			    SET gain = montant * 0.0
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';	
			END IF;	
		END IF;
		
		--pour un paris sur le vainqueur
		SELECT e_id
		FROM equipes
		INTO choix_equipe
		WHERE nom_pays = (SELECT DISTINCT nom_equipe
		FROM paris_1_2
		WHERE med_id = match_id);
		--On vérifie que l'équipe joue le match en question
		IF (choix_equipe = e_1_id) THEN
			-- Calcul du pourcentage du gain
			IF (equipe_1_score > equipe_2_score) THEN
			    -- Mettre à jour le gain du parieur
			    UPDATE paris_1_2
			    SET gain = montant * cote_1
			    WHERE mav_id = match_id AND statut <> 'terminé' 
			    OR med_id = match_id AND statut <> 'terminé';  
			ELSE
			    UPDATE paris_1_2
			    SET gain = montant * 0.0
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';
			END IF;
			
		ELSIF (choix_equipe = e_2_id) THEN
			-- Calcul du pourcentage du gain
			IF (equipe_2_score > equipe_1_score) THEN
			    UPDATE paris_1_2
			    SET gain = montant * cote_2
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';
			ELSE
			    UPDATE paris_1_2
			    SET gain = montant * 0.0
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';
			END IF;
		END IF;

		--pour le pari sur le score exacte
			
		IF (equipe_1_score = pari_score1 AND equipe_2_score = pari_score2) THEN
			    -- Mettre à jour le gain du parieur
			    UPDATE paris_Score_Exact pse
			    SET gain = montant * 1.5
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';   
		ELSE
			    -- Mettre à jour le gain du parieur
			    UPDATE paris_Score_Exact pse
			    SET gain = montant * 0.0
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';	    	
		END IF;
		
		--pour le pari sur le deux équipes marquent ou pas
		--SELECT montant, gain
		--INTO montant_pari, gain_pari
		--FROM paris_2equipes_marquent
		--WHERE mav_id = match_id OR med_id = match_id;
		
		IF (equipe_1_score <> 0 AND equipe_2_score <> 0) THEN
			    -- Mettre à jour le gain du parieur
			    UPDATE paris_2equipes_marquent p_2em
			    SET gain = montant * 1.5
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';	    
		ELSE
			    -- Mettre à jour le gain du parieur
			    UPDATE paris_2equipes_marquent p_2em
			    SET gain = montant * 0.0
			    WHERE mav_id = match_id AND statut <> 'terminé'
			    OR med_id = match_id AND statut <> 'terminé';	    	
		END IF;
		
        RETURN NEW;
    	END IF;
    	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER maj_score_et_gains_trigger
BEFORE UPDATE ON equipes
FOR EACH ROW EXECUTE FUNCTION maj_score_et_gains();
