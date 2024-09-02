drop trigger if exists maj_gains_paris_1_2_trigger ON paris_1_2;

-- Création de la fonction
CREATE OR REPLACE FUNCTION maj_gains_1_2_Exact()
RETURNS TRIGGER AS $$
DECLARE
    score_equipe1 INT;
    score_equipe2 INT;
    resultat INT;
    pourcentage_gain DECIMAL;
    equipe_1 INT;
    equipe_2 INT;
    cote1 INT;
    cote2 INT;
    t_restant INT;
    equipe_id INT;
    statut VARCHAR(100);
BEGIN  
    
    --récupération du temp_restant
    SELECT temp_restant 
    INTO t_restant
    FROM match_en_direct m 
    WHERE m.med_id = NEW.med_id;
      
    --pour un match_en_direct on ne peut pas parier après la fin de la prémière périod
    IF (NEW.med_id IS NOT NULL AND t_restant < 45) THEN
    	RETURN NULL;
    END IF;
    
    SELECT mav.statut 
    INTO statut
    FROM match_a_venir mav
    WHERE mav_id = NEW.mav_id;
    
    IF (NEW.med_id IS NULL AND  statut IS NULL) THEN
    	RETURN NULL;
    END IF;
    
    -- Récupération des identifiants des équipes à partir du match en direct
    IF (NEW.med_id IS NOT NULL) THEN
	    SELECT
		med.eid_equipe_1, med.eid_equipe_2
	    INTO
		equipe_1,
		equipe_2
	    FROM match_en_direct med
	    WHERE med.med_id = NEW.med_id;
	    SELECT
	    cote_equipe_1, cote_equipe_2
	    INTO
	    	cote1,
		cote2
	    FROM match_en_direct med
	    WHERE med.med_id = NEW.med_id;
    END IF;
    
    IF (NEW.mav_id IS NOT NULL) THEN
	    SELECT
		mav.eid_equipe_1, mav.eid_equipe_2
	    INTO
		equipe_1,
		equipe_2
	    FROM match_a_venir mav
	    WHERE mav.mav_id = NEW.mav_id;
	    SELECT
	    cote_equipe_1, cote_equipe_2
	    INTO
	    	cote1,
		cote2
	    FROM match_a_venir mav
	    WHERE mav.mav_id = NEW.mav_id;
    END IF;
    

    -- récupération des scores
    SELECT score 
    INTO
    	score_equipe1
    FROM equipes WHERE equipes.e_id = equipe_1;
    SELECT score 
    INTO
    	score_equipe2
    FROM equipes WHERE equipes.e_id = equipe_2;
    
    --si le parieur a miser sur le match nul
    IF (NEW.nom_equipe = 'N') THEN
    	IF (score_equipe1 = score_equipe2) THEN
    		pourcentage_gain := (cote1 + cote2)/2; 
    	ELSE
    		pourcentage_gain := 0.0; 
    	END IF;
	-- Calcul de la mise gagnée
	NEW.gain := NEW.montant * pourcentage_gain;
	IF (NEW.med_id IS NOT NULL) THEN
		NEW.statut = 'en cours';
	END IF;
   	RETURN NEW;
    END IF;
       
    --sinon si le parieur a miser sur une équipe alors on récupère l'identifiant de l'équipe
    SELECT e_id
    INTO equipe_id
    FROM equipes
    WHERE lower(NEW.nom_equipe) = lower(nom_pays);
    
    --On vérifie que l'équipe joue le match en question
    IF (equipe_id = equipe_1) THEN
	    -- Calcul du pourcentage du gain
	    IF (score_equipe1 > score_equipe2) THEN
		pourcentage_gain := cote1; 
	    ELSE
		pourcentage_gain := 0.0; 
	    END IF;
	    -- Calcul de la mise gagnée
	    NEW.gain := NEW.montant * pourcentage_gain;
	    --si le match est en directe le statut du pari est encours
	    IF (NEW.med_id IS NOT NULL) THEN
		    NEW.statut = 'en cours';
	    END IF;
	    RETURN NEW;
     ELSIF (equipe_id = equipe_2) THEN
	    -- Calcul du pourcentage du gain
	    IF (score_equipe2 > score_equipe1) THEN
		pourcentage_gain := cote2; 
	    ELSE
		pourcentage_gain := 0.0; 
	    END IF;
	    -- Calcul de la mise gagnée
	    NEW.gain := NEW.montant * pourcentage_gain;
	    --si le match est en directe le statut du pari est encours
	    IF (NEW.med_id IS NOT NULL) THEN
		    NEW.statut = 'en cours';
	    END IF;
   	    RETURN NEW;
     END IF;
   RETURN NULL;	
END;
$$ LANGUAGE plpgsql;

-- Création du déclencheur (trigger)
CREATE TRIGGER maj_gains_paris_1_2_trigger
BEFORE INSERT ON paris_1_2
FOR EACH ROW EXECUTE FUNCTION maj_gains_1_2_Exact();
