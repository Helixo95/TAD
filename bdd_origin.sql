-- CREATION DE LA BDD


------------------------------------------------------------------------------
-- Table : ELEVES
-- Stocke les informations des élèves (nom, email, classe, spécialité, filière)
------------------------------------------------------------------------------
CREATE TABLE eleves (
    eleve_id    NUMBER PRIMARY KEY,
    nom         VARCHAR2(100) NOT NULL,
    prenom      VARCHAR2(100),
    email       VARCHAR2(255) NOT NULL,
    password    VARCHAR2(255) NOT NULL,
    classe      VARCHAR2(50),
    specialite  VARCHAR2(50),
    filiere     VARCHAR2(50),
    lieu        VARCHAR2(5)
);

------------------------------------------------------------------------------
-- Table : ADMINISTRATEURS
-- Stocke les informations des administrateurs (nom, email, rôle)
------------------------------------------------------------------------------
CREATE TABLE administrateurs (
    admin_id    NUMBER PRIMARY KEY,
    nom         VARCHAR2(100) NOT NULL,
    prenom      VARCHAR2(100),
    email       VARCHAR2(255) NOT NULL,
    password    VARCHAR2(255) NOT NULL,
    role        VARCHAR2(50)
);

------------------------------------------------------------------------------
-- Table : TICKETS
-- Contient les tickets d’assistance, liés à l’élève qui crée/utilise le ticket
------------------------------------------------------------------------------
CREATE TABLE tickets (
    ticket_id       NUMBER PRIMARY KEY,
    sujet           VARCHAR2(255) NOT NULL,
    description     CLOB,
    statut          INT, -- 0: ouvert, 1: en cours, 2: résolu, 3: fermé
    date_ouverture  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_fermeture  TIMESTAMP,
    eleve_id        NUMBER,
    assigne_id      NUMBER,
    CONSTRAINT fk_tickets_eleves
        FOREIGN KEY (eleve_id)
        REFERENCES eleves(eleve_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_tickets_administrateurs
        FOREIGN KEY (assigne_id)
        REFERENCES administrateurs(admin_id)
        ON DELETE SET NULL
);

------------------------------------------------------------------------------
-- Table : ORDINATEURS
-- Liste des ordinateurs attribués aux élèves
------------------------------------------------------------------------------
CREATE TABLE ordinateurs (
    ordinateur_id   NUMBER PRIMARY KEY,
    marque          VARCHAR2(255) NOT NULL,
    modele          VARCHAR2(255) NOT NULL,
    numero_serie    VARCHAR2(100),
    eleve_id        NUMBER,
    CONSTRAINT fk_ordinateurs_eleves
        FOREIGN KEY (eleve_id)
        REFERENCES eleves(eleve_id)
        ON DELETE SET NULL
);

------------------------------------------------------------------------------
-- Table : EQUIPEMENTS_RESEAU
-- Matériel réseau (switch, routeur, borne Wi-Fi, etc.)
------------------------------------------------------------------------------
CREATE TABLE equipements_reseau (
    equip_id         NUMBER PRIMARY KEY,
    type_equipement  VARCHAR2(100),
    marque           VARCHAR2(100),
    modele           VARCHAR2(100),
    numero_serie     VARCHAR2(100),
    adresse_ip       VARCHAR2(15),
    eleve_id         NUMBER,
    CONSTRAINT fk_equipements_eleves
        FOREIGN KEY (eleve_id)
        REFERENCES eleves(eleve_id)
        ON DELETE SET NULL
);

------------------------------------------------------------------------------
-- Table : LOGICIELS
-- Référencement des logiciels installés
------------------------------------------------------------------------------
CREATE TABLE logiciels (
    logiciel_id  NUMBER PRIMARY KEY,
    nom          VARCHAR2(100) NOT NULL,
    version      VARCHAR2(50),
    eleve_id     NUMBER,
    CONSTRAINT fk_logiciels_eleves
        FOREIGN KEY (eleve_id)
        REFERENCES eleves(eleve_id)
        ON DELETE SET NULL
);

------------------------------------------------------------------------------
-- Table : LICENCES
-- Suivi des licences logicielles (clé, date expiration) liées à un logiciel
------------------------------------------------------------------------------
CREATE TABLE licences (
    licence_id      NUMBER PRIMARY KEY,
    cle_licence     VARCHAR2(100) NOT NULL,
    date_expiration DATE,
    logiciel_id     NUMBER,
    eleve_id        NUMBER,
    CONSTRAINT fk_licences_logiciels
        FOREIGN KEY (logiciel_id)
        REFERENCES logiciels(logiciel_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_licences_eleves
        FOREIGN KEY (eleve_id)
        REFERENCES eleves(eleve_id)
        ON DELETE SET NULL
);

------------------------------------------------------------------------------
-- Table : LOGS
-- Historique des actions (par exemple, liées aux tickets ou aux élèves)
------------------------------------------------------------------------------
CREATE TABLE logs (
    log_id      NUMBER PRIMARY KEY,
    action      VARCHAR2(255),
    date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    eleve_id    NUMBER,
    ticket_id   NUMBER,
    CONSTRAINT fk_logs_eleves
        FOREIGN KEY (eleve_id)
        REFERENCES eleves(eleve_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_logs_tickets
        FOREIGN KEY (ticket_id)
        REFERENCES tickets(ticket_id)
        ON DELETE CASCADE
);


------------------------------------------------------------------------------
-- Insertions des données dans la BDD
@/Users/aurelienruppe/Documents/Cours/AdminBDD/DB/insertions.sql
