drop trigger if exists trigger_update_match_en_direct ON match_en_direct;

CREATE OR REPLACE FUNCTION update_match()
RETURNS TRIGGER AS $$
DECLARE
	temp_rest INT;
	match_id INT;
	statut VARCHAR(100);
BEGIN
	-- Récupération le temp restant et l'id du match à venir
	temp_rest := NEW.temp_restant;
	match_id := NEW.med_id;
	statut := NEW.statut;
	IF (TG_OP = 'INSERT') THEN
		RETURN NULL;
	END IF;
	
	IF (TG_OP = 'UPDATE') THEN
		IF (temp_rest = 0 AND statut = 'en cours') THEN
			INSERT INTO stats_rencontre_precd (match_id, equipe, c_id ,lieu, heure, score)
				VALUES (NEW.med_id, NEW.eid_equipe_1, NEW.c_id, NEW.lieu, NEW.heure, 
				(SELECT score FROM equipes WHERE e_id = NEW.eid_equipe_1));
			INSERT INTO stats_rencontre_precd (match_id, equipe, c_id ,lieu, heure, score)
				VALUES (NEW.med_id, NEW.eid_equipe_2, NEW.c_id, NEW.lieu, NEW.heure,
				(SELECT score FROM equipes WHERE e_id = NEW.eid_equipe_2));
				
			UPDATE paris_2equipes_marquent p_2em 
			SET statut = 'terminé'
			WHERE p_2em.med_id = match_id;
			
			UPDATE paris_Score_Exact pse 
			SET statut = 'terminé'
			WHERE pse.med_id = match_id;
			
			UPDATE paris_1_2 p_1_2 
			SET statut = 'terminé'
			WHERE p_1_2.med_id = match_id;
			
			WITH t1 AS
			(SELECT user_email, count(user_email) as nb_paris, count(remise) as nb_remise
			FROM paris_2equipes_marquent 
			WHERE remise = 0.0
			GROUP BY user_email)
			UPDATE paris_2equipes_marquent p_2em
			SET remise = 0.8*p_2em.montant
			WHERE p_2em.user_email 
			IN (SELECT user_email FROM t1 WHERE nb_paris = nb_remise)
			AND p_2em.gain = 0.0
			AND p_2em.statut = 'terminé';
			
			WITH t2 AS
			(SELECT user_email, count(user_email) as nb_paris, count(remise) as nb_remise
			FROM paris_Score_Exact pse
			WHERE remise = 0.0
			GROUP BY user_email)
			UPDATE paris_Score_Exact pse
			SET remise = 0.8*pse.montant
			WHERE pse.user_email 
			IN (SELECT user_email FROM t2 WHERE nb_paris = nb_remise)
			AND pse.gain = 0.0
			AND pse.statut = 'terminé';
			
			WITH t3 AS
			(SELECT user_email, count(user_email) as nb_paris, count(remise) as nb_remise
			FROM paris_1_2 p_1_2
			WHERE remise = 0.0
			GROUP BY user_email)
			UPDATE paris_1_2 p_1_2
			SET remise = 0.8*p_1_2.montant
			WHERE p_1_2.user_email 
			IN (SELECT user_email FROM t3 WHERE nb_paris = nb_remise)
			AND p_1_2.gain = 0.0
			AND p_1_2.statut = 'terminé';
			
			NEW.statut = 'terminé';
			RETURN NEW;
		ELSIF (temp_rest <> 0 AND statut = 'en cours') THEN
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

CREATE TRIGGER trigger_update_match_en_direct
BEFORE UPDATE ON match_en_direct
FOR EACH ROW EXECUTE FUNCTION update_match();
