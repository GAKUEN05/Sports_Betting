drop trigger if exists trigger_insert_user ON utilisateur;

CREATE OR REPLACE FUNCTION insert_user()
RETURNS TRIGGER AS $$
DECLARE
	temp_rest INT;
	match_id INT;
	statut VARCHAR(100);
BEGIN
	-- Vérifier si l'utilisateur est majeur
	IF (New.age >= 18) THEN
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_user
BEFORE INSERT OR UPDATE ON utilisateur
FOR EACH ROW EXECUTE FUNCTION insert_user();

