drop trigger if exists trigger_insert_match ON match_a_venir;

CREATE OR REPLACE FUNCTION insert_match()
RETURNS TRIGGER AS $$
DECLARE
	temp_rest INT;
	match_id INT;
	statut VARCHAR(100);
    	cote_equipe1 INT;
    	cote_equipe2 INT;
    	heure_match timestamp;
    	lieu VARCHAR(100);
BEGIN
	-- Récupération le temp restant et l'id du match à venir
	temp_rest := NEW.temp_restant;
	match_id := NEW.mav_id;
	statut := NEW.statut;

        -- Générer deux nombres aléatoires pour les cotes des équipes
        cote_equipe1 := CAST(1 + 20*RANDOM() AS INT);
        cote_equipe2 := CAST(1 + 20*RANDOM() AS INT);
	
	IF (TG_OP = 'INSERT') THEN
		IF temp_rest IS NULL THEN
			SELECT heure, mav.lieu 
			INTO heure_match, lieu
			FROM match_a_venir mav
			WHERE mav.eid_equipe_1 = NEW.eid_equipe_1
			OR mav.eid_equipe_2 = NEW.eid_equipe_1
			LIMIT 1;
			IF(NEW.heure = heure_match AND NEW.lieu = lieu) THEN
				RETURN NULL;
			END IF;
			
			UPDATE equipes
			SET score = 0
			WHERE e_id = NEW.eid_equipe_1;
			
			UPDATE equipes
			SET score = 0
			WHERE e_id = NEW.eid_equipe_2;

			NEW.statut := 'à venir';	
			NEW.cote_equipe_1 := cote_equipe1;
			NEW.cote_equipe_2 := cote_equipe2;
			RETURN NEW;
		ELSE
			RETURN NULL;
		END IF;
	END IF;
	
	IF (TG_OP = 'UPDATE') THEN
		IF (temp_rest = 90 AND statut = 'à venir') THEN
			INSERT INTO match_en_direct (c_id, lieu, heure,eid_equipe_1,eid_equipe_2,cote_equipe_1, cote_equipe_2, temp_restant, statut)
			VALUES (NEW.c_id, NEW.lieu, NEW.heure,NEW.eid_equipe_1, NEW.eid_equipe_2,NEW.cote_equipe_1, NEW.cote_equipe_2, NEW.temp_restant, 'en cours');	
			UPDATE paris_2equipes_marquent p_2em 
			SET 
			statut = 'en cours',
			mav_id = NULL, 
			med_id = (SELECT COUNT(*) FROM match_en_direct)
			WHERE p_2em.mav_id = match_id;
			
			UPDATE paris_1_2 p_1_2 
			SET 
			statut = 'en cours',
			mav_id = NULL, 
			med_id = (SELECT COUNT(*) FROM match_en_direct)
			WHERE p_1_2.mav_id = match_id;
			
			UPDATE paris_score_Exact pse 
			SET 
			statut = 'en cours',
			mav_id = NULL, 
			med_id = (SELECT COUNT(*) FROM match_en_direct)
			WHERE pse.mav_id = match_id;
			
			NEW.statut := NULL;
			
			RETURN NEW;
		ELSE
			RETURN NULL;
		END IF;
	END IF;
	
	IF (TG_OP = 'DELETE') THEN
		RETURN NULL;
	END IF;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_match
BEFORE INSERT OR UPDATE OR DELETE ON match_a_venir
FOR EACH ROW EXECUTE FUNCTION insert_match();

