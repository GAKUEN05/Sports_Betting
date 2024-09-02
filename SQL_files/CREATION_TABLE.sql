DROP table if exists competition cascade;
DROP table if exists offre cascade;
DROP table if exists utilisateur cascade;
DROP table if exists equipes cascade;
DROP table if exists participation cascade;
DROP table if exists match_en_direct cascade;
DROP table if exists match_a_venir cascade;
DROP table if exists stats_rencontre_precd cascade;
DROP table if exists paris_2equipes_marquent cascade;
DROP table if exists paris_1_2 cascade;
DROP table if exists paris_Score_Exact cascade;
DROP table if exists joueur cascade;
DROP table if exists paris_joueur_marque cascade;
DROP table if exists est_buteur cascade;
DROP table if exists historique_Paris cascade;



-- Table compétition
CREATE TABLE competition (
    c_Id serial PRIMARY KEY,  
    nom_competition VARCHAR(255) NOT NULL, 
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    pays VARCHAR(100) NOT NULL
);

-- Table offre
CREATE TABLE offre (
    type_bonus VARCHAR(255) PRIMARY KEY
);

-- Table utilisateur 
CREATE TABLE utilisateur (
    email VARCHAR(100) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type_bonus VARCHAR(255) NOT NULL,
    FOREIGN KEY (type_bonus) REFERENCES offre(type_bonus) ON DELETE CASCADE
);

-- Table Equipes 
CREATE TABLE equipes ( 
    e_id serial UNIQUE, 
    nom_pays VARCHAR(255) UNIQUE NOT NULL, 
    nb_tirs_cadres INT default 0, 
    nb_passes INT default 0, 
    nb_tirs INT default 0, 
    Possession DECIMAL(10,2) default 0.0, 
    score INT default 0 
);

--Table participation
CREATE TABLE participation(
    c_id INT, 
    e_id INT,
    PRIMARY KEY (c_id, e_id),
    FOREIGN KEY (c_id) REFERENCES competition(c_id) ON DELETE CASCADE,
    FOREIGN KEY (e_id) REFERENCES equipes(e_id) ON DELETE CASCADE   
);

-- Table match_en_direct 
CREATE TABLE match_en_direct (
    med_id serial PRIMARY KEY,
    c_id INT NOT NULL,
    lieu VARCHAR(255) NOT NULL,
    heure timestamp NOT NULL, 
    eid_equipe_1 INT NOT NULL,
    eid_equipe_2 INT NOT NULL,
    cote_equipe_1 INT default 0, 
    cote_equipe_2 INT default 0, 
    temp_restant INT NOT NULL,
    statut VARCHAR(100),
    FOREIGN KEY (eid_equipe_1) REFERENCES equipes(e_id) ON DELETE CASCADE,
    FOREIGN KEY (eid_equipe_2) REFERENCES equipes(e_id) ON DELETE CASCADE,
    FOREIGN KEY (c_id) REFERENCES competition(c_id) ON DELETE CASCADE,
    CONSTRAINT check_temp_restant CHECK (temp_restant>=0 AND temp_restant <=90),
    CONSTRAINT check_tatut_med CHECK (statut ='en cours' OR statut ='terminé'),
    CONSTRAINT check_equipes_id_med CHECK (eid_equipe_1 <> eid_equipe_2)
);

-- Table match_a_venir 
CREATE TABLE match_a_venir (
    mav_id serial PRIMARY KEY,
    c_id INT NOT NULL,
    lieu VARCHAR(255) NOT NULL, 
    heure timestamp NOT NULL,
    eid_equipe_1 INT NOT NULL, 
    eid_equipe_2 INT NOT NULL, 
    cote_equipe_1 INT default 0, 
    cote_equipe_2 INT default 0, 
    statut VARCHAR(100),
    temp_restant INT CHECK (temp_restant IS NULL OR temp_restant =90), 
    FOREIGN KEY (eid_equipe_1) REFERENCES equipes(e_id) ON DELETE CASCADE,
    FOREIGN KEY (eid_equipe_2) REFERENCES equipes(e_id) ON DELETE CASCADE,
    FOREIGN KEY (c_id) REFERENCES competition(c_id) ON DELETE CASCADE,
    CONSTRAINT check_tatut_mav CHECK (statut ='à venir' OR statut IS NULL),
    CONSTRAINT check_equipes_id_mav CHECK (eid_equipe_1 <> eid_equipe_2)
);

-- Table stats_rencontre_precd 
CREATE TABLE stats_rencontre_precd (
    match_id INT,
    equipe INT,
    c_id INT NOT NULL,
    lieu VARCHAR(255) NOT NULL,
    heure timestamp NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY (match_id, equipe),
    FOREIGN KEY (equipe) REFERENCES equipes(e_id) ON DELETE CASCADE,
    FOREIGN KEY (c_id) REFERENCES competition(c_id) ON DELETE CASCADE
);

-- Table paris_2equipes_marquent 
CREATE TABLE paris_2equipes_marquent (
    paris_2em_id serial PRIMARY KEY,
    choix INT NOT NULL,
    mav_id INT,
    med_id INT,
    date_paris DATE NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    gain DECIMAL(10,2),
    statut VARCHAR(100) default 'a venir',
    remise DECIMAL(10,2) default 0.0,
    FOREIGN KEY (user_email) REFERENCES utilisateur(email) ON DELETE CASCADE,
    FOREIGN KEY (mav_id) REFERENCES match_a_venir(mav_id) ON DELETE CASCADE,
    FOREIGN KEY (med_id) REFERENCES match_en_direct(med_id) ON DELETE CASCADE,
    CONSTRAINT check_un_seul_paris_2em CHECK ((mav_id IS NULL AND med_id IS NOT NULL) OR (mav_id IS NOT NULL AND med_id IS NULL)),
    CONSTRAINT check_choix CHECK (choix >=0 AND choix <=1),
    CONSTRAINT check_montant CHECK (montant >0)
);

-- Table paris_1_2 
CREATE TABLE paris_1_2 (
    paris_1_2_id serial PRIMARY KEY,
    nom_equipe VARCHAR(100) NOT NULL,
    mav_id INT,
    med_id INT,
    date_pari DATE NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    gain DECIMAL(10,2),
    statut VARCHAR(100),
    remise DECIMAL(10,2) default 0.0,
    FOREIGN KEY (user_email) REFERENCES utilisateur(email),
    FOREIGN KEY (mav_id) REFERENCES match_a_venir(mav_id) ON DELETE CASCADE,
    FOREIGN KEY (med_id) REFERENCES match_en_direct(med_id) ON DELETE CASCADE,
    CONSTRAINT check_un_seul_paris_1_2 CHECK ((mav_id IS NULL AND med_id IS NOT NULL) OR (mav_id IS NOT NULL AND med_id IS NULL))
);

-- Table paris_Score_Exact 
CREATE TABLE paris_Score_Exact (
    paris_se_id serial PRIMARY KEY,
    score_equipe_1 INT NOT NULL,
    score_equipe_2 INT NOT NULL,
    mav_id INT,
    med_id INT,
    date_pari DATE NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    gain DECIMAL(10,2) NOT NULL,
    statut VARCHAR(100),
    remise DECIMAL(10,2) default 0.0,
    FOREIGN KEY (user_email) REFERENCES utilisateur(email) ON DELETE CASCADE,
    FOREIGN KEY (mav_id) REFERENCES match_a_venir(mav_id) ON DELETE CASCADE,
    FOREIGN KEY (med_id) REFERENCES match_en_direct(med_id) ON DELETE CASCADE,
    CONSTRAINT check_un_seul_paris_se CHECK ((mav_id IS NULL AND med_id IS NOT NULL) OR (mav_id IS NOT NULL AND med_id IS NULL)),
    CONSTRAINT check_montant CHECK (montant >0)
);

-- Table joueur 
CREATE TABLE joueur (
    j_id serial PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_Naissance DATE,
    nationalite VARCHAR(100) NOT NULL,
    equipe INT NOT NULL,
    nb_buts INT,
    FOREIGN KEY (equipe) REFERENCES equipes(e_id) ON DELETE CASCADE
);

-- Table paris_joueur_marque
CREATE TABLE paris_joueur_marque (
    paris_jm_id serial PRIMARY KEY,
    j_id INT NOT NULL,
    mav_id INT,
    med_id INT,
    date_pari DATE NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    gain DECIMAL(10,2),
    FOREIGN KEY (j_id) REFERENCES joueur(j_id) ON DELETE CASCADE,
    FOREIGN KEY (user_email) REFERENCES utilisateur(email) ON DELETE CASCADE,
    FOREIGN KEY (mav_id) REFERENCES match_a_venir(mav_id) ON DELETE CASCADE,
    FOREIGN KEY (med_id) REFERENCES match_en_direct(med_id) ON DELETE CASCADE,
    CONSTRAINT check_un_seul_paris_j CHECK ((mav_id IS NULL AND med_id IS NOT NULL) OR (mav_id IS NOT NULL AND med_id IS NULL))
);

-- Table est_buteur 
CREATE TABLE est_buteur (
    j_id INT,
    e_id INT,
    c_id INT,
    PRIMARY KEY (j_id, c_id),
    FOREIGN KEY (j_id) REFERENCES joueur(j_id) ON DELETE CASCADE,
    FOREIGN KEY (c_id) REFERENCES competition(c_Id) ON DELETE CASCADE,
    FOREIGN KEY (e_id) REFERENCES equipes(e_id) ON DELETE CASCADE
);


--Table historique_Paris
CREATE TABLE historique_paris (
    id_historique serial PRIMARY KEY,
    user_email VARCHAR(100) NOT NULL,
    date_pari DATE NOT NULL,
    type_pari VARCHAR(255) NOT NULL,
    id_pari INT NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    gain_potentiel DECIMAL(10,2),
    resultat_pari VARCHAR(50),
    FOREIGN KEY (user_email) REFERENCES utilisateur(email) ON DELETE CASCADE,
    CONSTRAINT check_resultat CHECK (resultat_pari IN ('Gagné', 'Perdu', 'En cours'))
);











