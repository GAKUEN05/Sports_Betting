drop trigger if exists maj_gains_paris_trigger ON paris_2equipes_marquent;

-- Création de la fonction
CREATE OR REPLACE FUNCTION maj_gains_paris()
RETURNS TRIGGER AS $$
DECLARE
    equipe1_marque INT;
    equipe2_marque INT;
    resultat INT;
    pourcentage_gain DECIMAL;
    equipe_1 INT;
    equipe_2 INT;
    statut VARCHAR(100);
BEGIN
    
    --On ne peut pas faire un paris 2em sur un match en direct
    IF (NEW.med_id IS NOT NULL) THEN
    	RETURN NULL;
    END IF;
    
    SELECT mav.statut 
    INTO statut
    FROM match_a_venir mav
    WHERE mav_id = NEW.mav_id;
    
    IF (NEW.med_id IS NULL AND  statut IS NULL) THEN
    	RETURN NULL;
    END IF;
    
    RETURN NEW;	
END;
$$ LANGUAGE plpgsql;

-- Création du déclencheur (trigger)
CREATE TRIGGER maj_gains_paris_trigger
BEFORE INSERT ON paris_2equipes_marquent
FOR EACH ROW EXECUTE FUNCTION maj_gains_paris();
