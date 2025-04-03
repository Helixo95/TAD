-- CREATION DES VUES, CLUSTERS, INDEXS... POUR OPTIMISER LA BDD ORIGINALE
@/Users/aurelienruppe/Documents/Cours/AdminBDD/DB/bdd_origin.sql
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- VUES
------------------------------------------------------------------------------
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- V_ELEVES_TICKETS : Vue simple pour la table ELEVES
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_eleves_tickets AS
SELECT 
    t.ticket_id,
    t.sujet,
    t.description,
    t.statut,
    e.eleve_id,
    e.nom            AS nom_eleve,
    e.prenom         AS prenom_eleve,
    t.assigne_id,
    a.nom            AS nom_administrateur
FROM tickets t
LEFT JOIN eleves e ON t.eleve_id = e.eleve_id
LEFT JOIN administrateurs a ON t.assigne_id = a.admin_id;



------------------------------------------------------------------------------
-- V_LICENCES_LOGICIELS_ELEVES : Vue licences logiciels associées aux élèves
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_licences_logiciels_eleves AS
SELECT 
    l.licence_id,
    l.cle_licence,
    l.date_expiration,
    lg.nom               AS nom_logiciel,
    e.nom                AS nom_eleve,
    e.prenom             AS prenom_eleve
FROM licences l
LEFT JOIN logiciels lg ON l.logiciel_id = lg.logiciel_id
LEFT JOIN eleves e ON l.eleve_id = e.eleve_id;


------------------------------------------------------------------------------
-- V_ELEVES_LOGICIELS : Vue pour les logiciels associés aux élèves
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_eleves_logiciels AS
SELECT 
    lg.logiciel_id,
    lg.nom           AS logiciel_nom,
    lg.version,
    e.nom            AS nom_eleve
FROM logiciels lg
LEFT JOIN eleves e ON lg.eleve_id = e.eleve_id;


------------------------------------------------------------------------------
-- V_ELEVES_EQUIPEMENTS : Vue pour les équipements associés aux élèves
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_eleves_equipements AS
SELECT 
    er.equip_id,
    er.type_equipement,
    er.marque,
    er.modele,
    er.numero_serie,
    e.nom                  AS nom_eleve,
    e.prenom               AS prenom_eleve
FROM equipements_reseau er
LEFT JOIN eleves e ON er.eleve_id = e.eleve_id;


------------------------------------------------------------------------------
-- V_AGG_TICKETS : Vue pour les tickets regroupés par statut, élève et administrateur
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_agg_tickets AS
  SELECT 'STATUT' AS aggregation_type,
         TO_CHAR(t.statut) AS aggregation_key,
         COUNT(*) AS nb_tickets
    FROM tickets t
   GROUP BY t.statut
UNION ALL
  SELECT 'ELEVE',
         TO_CHAR(e.eleve_id),
         COUNT(*)
    FROM tickets t
    LEFT JOIN eleves e ON t.eleve_id = e.eleve_id
   GROUP BY e.eleve_id
UNION ALL
  SELECT 'ADMIN',
         TO_CHAR(a.admin_id),
         COUNT(*)
    FROM tickets t
    LEFT JOIN administrateurs a ON t.assigne_id = a.admin_id
   GROUP BY a.admin_id;


------------------------------------------------------------------------------
-- V_LICENCES_EXPIRATION : Vue des licences en expiration ou expirées
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_licences_expiration AS
SELECT 
    l.licence_id,
    l.cle_licence,
    l.date_expiration,
    lg.nom AS nom_logiciel,
    e.nom AS nom_eleve
FROM licences l
LEFT JOIN logiciels lg ON l.logiciel_id = lg.logiciel_id
LEFT JOIN eleves e ON l.eleve_id = e.eleve_id
WHERE l.date_expiration <= SYSDATE + 30;


------------------------------------------------------------------------------
-- V_LOGS_CONSOLIDE : Vue d'historique consolidé des actions
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_logs_consolide AS
SELECT 
    l.log_id,
    l.action,
    l.date_action,
    e.eleve_id,
    e.nom AS nom_eleve,
    t.ticket_id,
    t.sujet AS ticket_sujet
FROM logs l
LEFT JOIN eleves e ON l.eleve_id = e.eleve_id
LEFT JOIN tickets t ON l.ticket_id = t.ticket_id;


------------------------------------------------------------------------------
-- V_SYNTHESE_LOGICIELS : Vue de synthèse pour la gestion des logiciels
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_synthese_logiciels AS
SELECT 
    lg.logiciel_id,
    lg.nom AS logiciel_nom,
    lg.version,
    l.licence_id,
    l.cle_licence,
    l.date_expiration,
    e.eleve_id,
    e.nom AS nom_eleve
FROM logiciels lg
LEFT JOIN licences l ON lg.logiciel_id = l.logiciel_id
LEFT JOIN eleves e ON e.eleve_id = NVL(l.eleve_id, lg.eleve_id);


------------------------------------------------------------------------------
-- V_ANALYSE_CLASSE_FILIERE : Vue d'analyse par classe et filière
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_analyse_classe_filiere AS
WITH eleves_aggr AS (
  SELECT classe, filiere, COUNT(*) AS nb_eleves
    FROM eleves
   GROUP BY classe, filiere
),
tickets_aggr AS (
  SELECT e.classe, e.filiere, COUNT(*) AS nb_tickets
    FROM eleves e 
    JOIN tickets t ON e.eleve_id = t.eleve_id
   GROUP BY e.classe, e.filiere
),
licences_aggr AS (
  SELECT e.classe, e.filiere, COUNT(*) AS nb_licences
    FROM eleves e 
    JOIN licences l ON e.eleve_id = l.eleve_id
   GROUP BY e.classe, e.filiere
),
logiciels_aggr AS (
  SELECT e.classe, e.filiere, COUNT(*) AS nb_logiciels
    FROM eleves e 
    JOIN logiciels lg ON e.eleve_id = lg.eleve_id
   GROUP BY e.classe, e.filiere
),
equipements_aggr AS (
  SELECT e.classe, e.filiere, COUNT(*) AS nb_equipements
    FROM eleves e 
    JOIN equipements_reseau er ON e.eleve_id = er.eleve_id
   GROUP BY e.classe, e.filiere
)
SELECT 
  ea.classe,
  ea.filiere,
  ea.nb_eleves,
  NVL(tg.nb_tickets, 0) AS nb_tickets,
  NVL(lg.nb_licences, 0) AS nb_licences,
  NVL(lcg.nb_logiciels, 0) AS nb_logiciels,
  NVL(eag.nb_equipements, 0) AS nb_equipements
FROM eleves_aggr ea
LEFT JOIN tickets_aggr tg ON ea.classe = tg.classe AND ea.filiere = tg.filiere
LEFT JOIN licences_aggr lg ON ea.classe = lg.classe AND ea.filiere = lg.filiere
LEFT JOIN logiciels_aggr lcg ON ea.classe = lcg.classe AND ea.filiere = lcg.filiere
LEFT JOIN equipements_aggr eag ON ea.classe = eag.classe AND ea.filiere = eag.filiere;




------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- INDEXS
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Index B-Tree sur le champ email dans la table eleves
CREATE INDEX idx_eleves_email ON eleves(email);

-- Index B-Tree sur le champ eleve_id dans la table tickets
CREATE INDEX idx_tickets_eleve_id ON tickets(eleve_id);

-- Index B-Tree sur le champ eleve_id dans la table ordinateurs
CREATE INDEX idx_ordinateurs_eleve_id ON ordinateurs(eleve_id);

-- Index B-Tree sur le champ eleve_id dans la table equipements_reseau
CREATE INDEX idx_equipements_reseau_eleve_id ON equipements_reseau(eleve_id);

-- Index BITMAP sur le champ statut dans la table tickets
CREATE BITMAP INDEX idx_tickets_statut ON tickets(statut);


------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- CLUSTERS
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Cluster eleves - tickets : Regroupement des tables tickets et eleves sur la colonne eleve_id.
CREATE CLUSTER cl_ticket_eleve (
  eleve_id NUMBER
)
SIZE 8192;

CREATE INDEX cl_ticket_eleve_idx ON CLUSTER cl_ticket_eleve;

-- Cluster equipement - eleves : Regroupement des tables equipements_reseau et eleves sur la colonne eleve_id.
CREATE CLUSTER cl_equipement_eleve (
  eleve_id NUMBER
)
SIZE 8192;

CREATE INDEX cl_equipement_eleve_idx ON CLUSTER cl_equipement_eleve;

-- cluster logiciel - licences
CREATE CLUSTER cl_logiciel_licences (
  logiciel_id NUMBER,
  eleve_id    NUMBER
)
SIZE 8192;

CREATE INDEX cl_logiciel_licences_idx ON CLUSTER cl_logiciel_licences;




------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- TRIGGERS
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Trigger pour la création automatique de tickets lors de l'insertion d'un
-- nouvel élève dans la table eleves

CREATE OR REPLACE TRIGGER trg_after_insert_eleves
AFTER INSERT ON eleves
FOR EACH ROW
DECLARE
BEGIN
  -- Création de trois tickets automatiques pour chaque élève
  INSERT INTO tickets (ticket_id, sujet, description, statut, date_ouverture, eleve_id)
  VALUES (SYS_GUID(), 'Ticket automatique 1', 'Ticket généré automatiquement lors de la création de l''élève', 0, CURRENT_TIMESTAMP, :NEW.eleve_id);

  INSERT INTO tickets (ticket_id, sujet, description, statut, date_ouverture, eleve_id)
  VALUES (SYS_GUID(), 'Ticket automatique 2', 'Ticket généré automatiquement lors de la création de l''élève', 0, CURRENT_TIMESTAMP, :NEW.eleve_id);

  INSERT INTO tickets (ticket_id, sujet, description, statut, date_ouverture, eleve_id)
  VALUES (SYS_GUID(), 'Ticket automatique 3', 'Ticket généré automatiquement lors de la création de l''élève', 0, CURRENT_TIMESTAMP, :NEW.eleve_id);

  -- Enregistrement du log de création de l'élève
  INSERT INTO logs (log_id, action, date_action, eleve_id, ticket_id)
  VALUES (SYS_GUID(), 'Création de l''élève', CURRENT_TIMESTAMP, :NEW.eleve_id, NULL);

EXCEPTION
  WHEN OTHERS THEN
    -- En cas d'erreur, afficher un message d'erreur
    DBMS_OUTPUT.PUT_LINE('Erreur lors de l''insertion des tickets ou du log pour l''élève ID : ' || :NEW.eleve_id);
END;
/


-- Trigger pour la cloture / résolution du ticket

CREATE OR REPLACE TRIGGER trg_after_update_ticket
AFTER UPDATE OF statut, date_fermeture ON tickets
FOR EACH ROW
WHEN (NEW.statut = 2 AND NEW.date_fermeture IS NOT NULL)
DECLARE
BEGIN
  INSERT INTO logs (log_id, action, date_action, eleve_id, ticket_id)
  VALUES (seq_log_id.NEXTVAL, 'Clôture/Résolution du ticket', CURRENT_TIMESTAMP, :NEW.eleve_id, :NEW.ticket_id);
END;
/


-- Trigger insertion de logs après création d'un ticket

CREATE OR REPLACE TRIGGER trg_after_insert_ticket
AFTER INSERT ON tickets
FOR EACH ROW
DECLARE
BEGIN
  INSERT INTO logs (log_id, action, date_action, eleve_id, ticket_id)
  VALUES (seq_log_id.NEXTVAL, 'Création du ticket', CURRENT_TIMESTAMP, :NEW.eleve_id, :NEW.ticket_id);
END;
/



------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- PROCEDURES ET FONCTIONS
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Création de ticket
CREATE OR REPLACE PROCEDURE create_ticket (
    p_subject      IN VARCHAR2,
    p_description  IN VARCHAR2,
    p_eleve_id     IN NUMBER
) AS
BEGIN
  INSERT INTO tickets (
      ticket_id,
      sujet,
      description,
      statut,
      date_ouverture,
      eleve_id
  )
  VALUES (
      seq_ticket_id.NEXTVAL,  -- Génération de l'identifiant du ticket
      p_subject,
      p_description,
      0,                      -- Statut initial : 0 pour "ouvert"
      CURRENT_TIMESTAMP,
      p_eleve_id
  );

  COMMIT;
END;
/


-- Clôture d'un ticket
CREATE OR REPLACE PROCEDURE close_ticket (
    p_ticket_id  IN NUMBER
) AS
BEGIN
  UPDATE tickets
  SET statut = 3,              -- Statut 3 pour "fermé"
      date_fermeture = CURRENT_TIMESTAMP
  WHERE ticket_id = p_ticket_id;

  COMMIT;
END;
/


-- Résolution d'un ticket
CREATE OR REPLACE PROCEDURE resolve_ticket (
    p_ticket_id  IN NUMBER
) AS
BEGIN
  UPDATE tickets
  SET statut = 2,              -- Statut 2 pour "résolu"
      date_fermeture = CURRENT_TIMESTAMP
  WHERE ticket_id = p_ticket_id;

  COMMIT;
END;
/


-- Attribution d'un ticket à un administrateur
CREATE OR REPLACE PROCEDURE assign_ticket (
    p_ticket_id       IN NUMBER,
    p_admin_id        IN NUMBER
) AS
BEGIN
  UPDATE tickets
  SET assigne_id = p_admin_id, 
      statut = 1              -- Statut 1 pour "en cours"
  WHERE ticket_id = p_ticket_id;

  COMMIT;
END;
/


-- Création d'une licence
CREATE OR REPLACE PROCEDURE create_licence(
    p_cle_licence     IN VARCHAR2,
    p_date_expiration IN DATE,
    p_logiciel_id     IN NUMBER,
    p_eleve_id        IN NUMBER
) IS
BEGIN
    INSERT INTO licences (licence_id, cle_licence, date_expiration, logiciel_id, eleve_id)
    VALUES (seq_licence_id.NEXTVAL, p_cle_licence, p_date_expiration, p_logiciel_id, p_eleve_id);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
       ROLLBACK;
       RAISE;
END create_licence;
/



-- Création d'un élève (fonction)
CREATE OR REPLACE FUNCTION create_eleve(
    p_nom         IN VARCHAR2,
    p_prenom      IN VARCHAR2,
    p_email       IN VARCHAR2,
    p_password    IN VARCHAR2,
    p_classe      IN VARCHAR2,
    p_specialite  IN VARCHAR2,
    p_filiere     IN VARCHAR2
) RETURN NUMBER IS
    v_count   NUMBER;
    v_eleve_id NUMBER;
BEGIN
    -- Vérification de l'unicité de l'email et du nom
    SELECT COUNT(*) INTO v_count
    FROM eleves
    WHERE email = p_email OR nom = p_nom;
    
    IF v_count > 0 THEN
       raise_application_error(-20001, 'L''email ou le nom existe déjà.');
    END IF;
    
    -- Génération du nouvel identifiant et insertion
    v_eleve_id := seq_eleve_id.NEXTVAL;
    
    INSERT INTO eleves (eleve_id, nom, prenom, email, password, classe, specialite, filiere)
    VALUES (v_eleve_id, p_nom, p_prenom, p_email, p_password, p_classe, p_specialite, p_filiere);
    
    COMMIT;
    
    RETURN v_eleve_id;
EXCEPTION
    WHEN OTHERS THEN
       ROLLBACK;
       RAISE;
END create_eleve;
/


