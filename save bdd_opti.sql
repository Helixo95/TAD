-- SAVE


------------------------------------------------------------------------------
-- V_ELEVES : Vue simple pour la table ELEVES
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_eleves AS
SELECT *
  FROM eleves;

------------------------------------------------------------------------------
-- V_TICKETS : Vue simple pour la table TICKETS
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_tickets AS
SELECT *
  FROM tickets;

------------------------------------------------------------------------------
-- V_ORDINATEURS : Vue simple pour la table ORDINATEURS
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_ordinateurs AS
SELECT *
  FROM ordinateurs;

------------------------------------------------------------------------------
-- V_EQUIPEMENTS_RESEAU : Vue simple pour la table EQUIPEMENTS_RESEAU
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_equipements_reseau AS
SELECT *
  FROM equipements_reseau;

------------------------------------------------------------------------------
-- V_LOGICIELS : Vue simple pour la table LOGICIELS
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_logiciels AS
SELECT *
  FROM logiciels;

------------------------------------------------------------------------------
-- V_LICENCES : Vue simple pour la table LICENCES
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_licences AS
SELECT *
  FROM licences;

------------------------------------------------------------------------------
-- V_LOGS : Vue simple pour la table LOGS
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_logs AS
SELECT *
  FROM logs;


------------------------------------------------------------------------------
-- V_ELEVES_TICKETS : Vue pour les tickets associés aux élèves
------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_eleves_tickets AS
SELECT e.eleve_id,
       e.nom             AS eleve_nom,
       e.prenom          AS eleve_prenom,
       e.email,
       t.ticket_id,
       t.titre,
       t.description,
       t.statut,
       t.date_ouverture,
       t.date_fermeture
  FROM eleves   e
  JOIN tickets  t
    ON e.eleve_id = t.eleve_id;


------------------------------------------------------------------------------
-- V_LICENCES_LOGICIELS_ELEVES : Vue licences logiciels associées aux élèves
------------------------------------------------------------------------------

-- Permet de consulter les licences logicielles attribuées aux élèves, en 
-- reliant les tables eleves, licences, logiciels et une table de liaison 
-- pour la relation plusieurs-à-plusieurs.

-- Table de liaison entre licences, logiciels et élèves
CREATE TABLE licences_logiciels_eleves (
    lle_id        NUMBER GENERATED ALWAYS AS IDENTITY,
    licence_id    NUMBER NOT NULL,
    logiciel_id   NUMBER NOT NULL,
    eleve_id      NUMBER NOT NULL,

    CONSTRAINT licences_logiciels_eleves_pk
        PRIMARY KEY (lle_id),

    CONSTRAINT fk_lle_licence
        FOREIGN KEY (licence_id)
        REFERENCES licences(licence_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_lle_logiciel
        FOREIGN KEY (logiciel_id)
        REFERENCES logiciels(logiciel_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_lle_eleve
        FOREIGN KEY (eleve_id)
        REFERENCES eleves(eleve_id)
        ON DELETE CASCADE
);


CREATE OR REPLACE VIEW v_licences_logiciels_eleves AS
SELECT e.eleve_id,
       e.nom              AS eleve_nom,
       e.prenom           AS eleve_prenom,
       e.email,
       li.licence_id,
       li.cle_licence,
       li.date_expiration,
       lo.logiciel_id,
       lo.nom             AS logiciel_nom,
       lo.version         AS logiciel_version
  FROM eleves                    e
  JOIN licences_logiciels_eleves lle  ON e.eleve_id   = lle.eleve_id
  JOIN licences                  li   ON li.licence_id = lle.licence_id
  JOIN logiciels                 lo   ON lo.logiciel_id = li.logiciel_id;


------------------------------------------------------------------------------
-- V_ELEVES_EQUIPEMENTS : Vue pour les équipements associés aux élèves
------------------------------------------------------------------------------

-- Permet de visualiser, dans une même vue, tous les équipements (ordinateurs 
-- ou équipements réseau) attribués à chaque élève.
-- On utilise un UNION ALL pour fusionner deux requêtes :
-- La première joint eleves et ordinateurs.
-- La seconde joint eleves et equipements_reseau.

CREATE OR REPLACE VIEW v_eleves_equipements AS
SELECT e.eleve_id,
       e.nom              AS eleve_nom,
       e.prenom           AS eleve_prenom,
       e.email,
       'Ordinateur'       AS type_equipement,
       o.ordinateur_id    AS equipement_id,
       o.nom              AS equipement_nom,
       o.numero_serie     AS details
  FROM eleves      e
  JOIN ordinateurs o
    ON e.eleve_id = o.eleve_id

UNION ALL

SELECT e.eleve_id,
       e.nom              AS eleve_nom,
       e.prenom           AS eleve_prenom,
       e.email,
       'Réseau'           AS type_equipement,
       er.equip_id        AS equipement_id,
       er.type_equipement AS equipement_nom,
       er.adresse_ip      AS details
  FROM eleves            e
  JOIN equipements_reseau er
    ON e.eleve_id = er.eleve_id;

------------------------------------------------------------------------------
-- V_ELEVES_LOGICIELS : Vue pour les logiciels associés aux élèves
------------------------------------------------------------------------------

-- Permet aux élèves de consulter la liste des logiciels auxquels ils ont 
-- accès.
-- Ici encore, on suppose l’existence d’une table de liaison (par exemple 
-- eleves_logiciels) entre eleves et logiciels.

CREATE OR REPLACE VIEW v_eleves_logiciels AS
SELECT e.eleve_id,
       e.nom        AS eleve_nom,
       e.prenom     AS eleve_prenom,
       e.email,
       lo.logiciel_id,
       lo.nom       AS logiciel_nom,
       lo.version   AS logiciel_version
  FROM eleves           e
  JOIN eleves_logiciels el  ON e.eleve_id    = el.eleve_id
  JOIN logiciels        lo  ON lo.logiciel_id = el.logiciel_id;