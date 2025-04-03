-- Test de l'insertion directe de licences sur la base de données d'origine

-- Création de la séquence pour incrémentation des identifiants de licences
CREATE SEQUENCE seq_licence_id_origin_test_3
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Active l'affichage des messages de sortie
SET SERVEROUTPUT ON;

DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    v_cle_licence VARCHAR2(50);
    v_date_expiration DATE := SYSDATE + 365; -- Date d'expiration dans un an
    v_logiciel_id NUMBER;
    v_count NUMBER := 1000; -- Nombre de licences à insérer
    v_eleve_id NUMBER;
    v_nom VARCHAR2(100);
    v_prenom VARCHAR2(100);
    v_email VARCHAR2(255);
    v_password VARCHAR2(255);
    v_classe VARCHAR2(50);
    v_specialite VARCHAR2(50);
    v_filiere VARCHAR2(50);
    v_lieu VARCHAR2(5);
    v_ticket_id NUMBER;
    v_sujet VARCHAR2(255);
    v_description CLOB;
    v_statut INT;
    v_date_ouverture TIMESTAMP := CURRENT_TIMESTAMP;
    v_date_fermeture TIMESTAMP;
    v_assigne_id NUMBER;
BEGIN
-- Insertion de licences
    -- Temps de début
    v_start := SYSTIMESTAMP;

    FOR i IN 1..v_count LOOP
        -- Génération de valeurs pour les paramètres
        v_cle_licence := 'CLE' || TO_CHAR(i, 'FM0000');
        v_logiciel_id := MOD(i, 10) + 1; -- Exemple : 10 logiciels différents
        v_eleve_id := MOD(i, 50) + 1;     -- Exemple : 50 élèves différents

        -- Insertion directe dans la table licences
        INSERT INTO C##ADMIN_SYS_ORIGIN.licences (licence_id, cle_licence, date_expiration, logiciel_id, eleve_id)
        VALUES (seq_licence_id_origin_test_2.NEXTVAL, v_cle_licence, v_date_expiration, v_logiciel_id, v_eleve_id);
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution pour l''insertion de ' || v_count || ' licences : ' || v_diff);

    COMMIT;

-- Insertion d'élèves
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Insérer 3000 étudiants dans la table eleves
    FOR i IN 1201..4200 LOOP
        -- Générer des données fictives
        v_eleve_id := 10000 + i;  -- ID unique pour chaque étudiant
        v_nom := 'Nom' || i;  -- Nom générique
        v_prenom := 'Prenom' || i;  -- Prénom générique
        v_email := 'email' || i || '@example.com';  -- Email générique
        v_password := 'password' || i;  -- Password générique
        v_classe := 'Classe' || (MOD(i, 3) + 1);  -- Classe alternée (1, 2, 3)
        v_specialite := 'Specialite' || (MOD(i, 5) + 1);  -- Spécialité alternée (1 à 5)
        v_filiere := 'Filiere' || (MOD(i, 4) + 1);  -- Filière alternée (1 à 4)

        -- Alterner entre 'Cergy' et 'Pau' pour le lieu
        IF MOD(i, 2) = 0 THEN
            v_lieu := 'Cergy';
        ELSE
            v_lieu := 'Pau';
        END IF;

        -- Insertion dans la table eleves
        INSERT INTO C##ADMIN_SYS_ORIGIN.eleves (
            eleve_id, nom, prenom, email, password, classe, specialite, filiere, lieu
        )
        VALUES (
            v_eleve_id, v_nom, v_prenom, v_email, v_password, v_classe, v_specialite, v_filiere, v_lieu
        );
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution pour l''insertion de ' || 3000 || ' élèves : ' || v_diff);

    COMMIT;

-- Insertion de tickets
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Insérer 1000 tickets dans la table tickets
    FOR i IN 4101..5100 LOOP
        -- Générer des données fictives
        v_ticket_id := 1000 + i;  -- ID unique pour chaque ticket
        v_sujet := 'Ticket sujet ' || i;  -- Sujet générique
        v_description := 'Description du ticket ' || i;  -- Description générique

        -- Statut aléatoire entre 0 et 3 (0: ouvert, 1: en cours, 2: résolu, 3: fermé)
        v_statut := MOD(i, 4);

        -- Date de fermeture pour certains tickets (aléatoire)
        IF MOD(i, 2) = 0 THEN
            v_date_fermeture := v_date_ouverture + INTERVAL '5' DAY;  -- Fermeture dans 5 jours pour les tickets pairs
        ELSE
            v_date_fermeture := NULL;  -- Pas de fermeture pour les tickets impairs
        END IF;

        -- Sélectionner un élève et un administrateur existants
        -- Ici, nous prenons l'ID de l'élève comme 1 + i, en veillant à ce que l'ID existe
        v_eleve_id := 1 + MOD(i, 50);  -- ID d'élève, en utilisant des élèves de 1 à 100
        v_assigne_id := 1 + MOD(i, 10);  -- ID d'administrateur, assigner un admin parmi 10 administrateurs

        -- Insertion dans la table tickets
        INSERT INTO C##ADMIN_SYS_ORIGIN.tickets (
            ticket_id, sujet, description, statut, date_ouverture, date_fermeture, eleve_id, assigne_id
        )
        VALUES (
            v_ticket_id, v_sujet, v_description, v_statut, v_date_ouverture, v_date_fermeture, v_eleve_id, v_assigne_id
        );
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution pour l''insertion de ' || 1000 || ' tickets : ' || v_diff);
END;
