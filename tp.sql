CREATE TABLE Professeur (
    num_prof INT PRIMARY KEY,
    nom_prof VARCHAR(100),
    prenom_prof VARCHAR(100),
    telephone VARCHAR(15),
    adresse VARCHAR(255),
    type ENUM('permanent', 'vacataire') NOT NULL
);

CREATE TABLE Module (
    num_module INT PRIMARY KEY,
    nom_module VARCHAR(100),
    masse_horaire_prevue INT,
    num_prof_enseignant INT,
    num_prof_responsable INT,
    num_classe INT,
    FOREIGN KEY (num_prof_enseignant) REFERENCES Professeur(num_prof),
    FOREIGN KEY (num_prof_responsable) REFERENCES Professeur(num_prof),
    FOREIGN KEY (num_classe) REFERENCES Classe(num_classe)
);

CREATE TABLE Precision (
    num_precision INT PRIMARY KEY,
    nom_precision VARCHAR(100),
    num_module INT,
    FOREIGN KEY (num_module) REFERENCES Module(num_module)
);

CREATE TABLE Classe (
    num_classe INT PRIMARY KEY,
    nom_classe VARCHAR(100),
    nombre_modules INT DEFAULT 0,
    motdepasse VARCHAR(50)
);

CREATE TABLE Groupe (
    num_groupe INT PRIMARY KEY,
    nom_groupe VARCHAR(100),
    num_classe INT,
    FOREIGN KEY (num_classe) REFERENCES Classe(num_classe)
);

CREATE TABLE Forme (
    num_forme INT PRIMARY KEY,
    nom_forme VARCHAR(100),
    num_groupe INT,
    FOREIGN KEY (num_groupe) REFERENCES Groupe(num_groupe)
);




3
SELECT 
    p.nom_precision,
    prof_enseignant.nom_prof AS enseignant,
    prof_responsable.nom_prof AS responsable
FROM 
    Precision p
JOIN Module m ON p.num_module = m.num_module
JOIN Professeur prof_enseignant ON m.num_prof_enseignant = prof_enseignant.num_prof
JOIN Professeur prof_responsable ON m.num_prof_responsable = prof_responsable.num_prof
WHERE 
    m.nom_module = 'SGBD';




4
DELIMITER //
CREATE PROCEDURE CompterModulesProfesseur (
      prof_id INT
)
BEGIN
    SELECT COUNT(*) as nb_modules_enseignes
    FROM Module
    WHERE num_prof_enseignant = prof_id;

     
END //
 




5
  DELIMITER //
CREATE FUNCTION TotalHeuresClasse(classe_id INT) 
RETURNS INT
BEGIN
    DECLARE total_heures INT;
    SELECT SUM(masse_horaire_prevue) INTO total_heures
    FROM Module
    WHERE num_classe = classe_id;
    RETURN total_heures;
END//



6
DELIMITER //
CREATE TRIGGER UpdateNombreModules
AFTER INSERT ON Module
FOR EACH ROW BEGIN
    UPDATE Classe
    SET nombre_modules = (SELECT COUNT(*) FROM Module WHERE num_classe = NEW.num_classe)
    WHERE num_classe = NEW.num_classe;
END //


