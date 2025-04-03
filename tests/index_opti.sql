-- Active l'affichage des messages de sortie
SET SERVEROUTPUT ON;

------------------------------------------------------------
------------------- Tests sur les indexs -------------------
------------------------------------------------------------

-- Ajout de 1000 élèves avec tickets et logs

DECLARE
    i INT;
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    v_lieu VARCHAR2(5);
    l_count INT := 0;  -- Déclaration du compteur
    v_email1 VARCHAR2(50) := 'sarah.lemoine@example.com'; -- Changer l'email si besoin
    v_email2 VARCHAR2(50) := 'email1000@example.com'; -- Changer l'email si besoin
    v_statut INT;
    
    -- Définir le type de table pour collecter plusieurs tickets dans le schéma 'C##ADMIN_SYS_OPTI'
    TYPE ticket_table_type IS TABLE OF C##ADMIN_SYS_OPTI.tickets%ROWTYPE;
    v_tickets ticket_table_type;

    v_eleve C##ADMIN_SYS_OPTI.eleves%ROWTYPE; -- Variable pour un élève dans le schéma 'C##ADMIN_SYS_OPTI'

    v_count INTEGER := 0; -- Compteur pour les tickets
BEGIN
    -- Initialisation du générateur de nombres aléatoires
    DBMS_RANDOM.SEED(TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF'));

    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Ajout de 1000 élèves avec tickets et logs
    FOR i IN 1..1000 LOOP
        -- Alterne entre Cergy et Pau
        IF MOD(i, 2) = 0 THEN
            v_lieu := 'Cergy';
        ELSE
            v_lieu := 'Pau';
        END IF;

        -- Générer un statut aléatoire entre 0 et 3
        v_statut := TRUNC(DBMS_RANDOM.VALUE(0, 4));

        -- Ajout d'un élève avec des tickets et logs
        INSERT INTO C##ADMIN_SYS_OPTI.eleves (eleve_id, nom, prenom, email, password, classe, specialite, filiere, lieu)
        VALUES (90 + i, 'Nom' || i, 'Prénom' || i, 'email' || i || '@example.com', 'pass' || i, 'Classe' || i, 'Spécialité' || i, 'Filière' || i, v_lieu);

        INSERT INTO C##ADMIN_SYS_OPTI.tickets (ticket_id, sujet, description, statut, date_ouverture, date_fermeture, eleve_id, assigne_id)
        VALUES (i + 1000, 'Problème ' || i, 'Problème numéro ' || i, v_statut, CURRENT_TIMESTAMP, NULL, 90 + i, 1);

        INSERT INTO C##ADMIN_SYS_OPTI.logs (log_id, action, date_action, eleve_id, ticket_id)
        VALUES (i + 2000, 'Création du ticket', CURRENT_TIMESTAMP, 90 + i, i + 1000);

        -- Afficher l'identifiant généré avec l'ID calculé
        DBMS_OUTPUT.PUT_LINE('Élève inséré avec ID : ' || (90 + i));
        
        -- Compter le nombre d'élèves insérés
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    COMMIT;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution : ' || v_diff);

    -- Afficher le nombre d'élèves insérés
    DBMS_OUTPUT.PUT_LINE('Nombre d''élèves insérés : ' || l_count);

--------------------------------------------------------------------------
    -- Sélection d'un élève par son email
    -- Démarrer mesure de temps
    v_start := SYSTIMESTAMP;

    -- SELECT de l'élève par email avec INTO
    BEGIN
        SELECT * INTO v_eleve FROM C##ADMIN_SYS_OPTI.eleves WHERE email = v_email1;
        DBMS_OUTPUT.PUT_LINE('Élève trouvé : ID=' || v_eleve.eleve_id || ', Nom=' || v_eleve.nom || ', Prénom=' || v_eleve.prenom);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Aucun élève trouvé avec l''email : ' || v_email1);
    END;

    BEGIN
        SELECT * INTO v_eleve FROM C##ADMIN_SYS_OPTI.eleves WHERE email = v_email2;
        DBMS_OUTPUT.PUT_LINE('Élève trouvé : ID=' || v_eleve.eleve_id || ', Nom=' || v_eleve.nom || ', Prénom=' || v_eleve.prenom);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Aucun élève trouvé avec l''email : ' || v_email2);
    END;

    -- Fin mesure du temps
    v_end := SYSTIMESTAMP;

    -- Calcul du temps écoulé
    v_diff := v_end - v_start;

    -- Affichage des résultats
    DBMS_OUTPUT.PUT_LINE('Temps pour SELECT : ' || v_diff);

--------------------------------------------------------------------------
    -- Tester la recherche des tickets par statut
    -- Démarrer la mesure de temps
    v_start := SYSTIMESTAMP;

    -- Récupérer les tickets avec BULK COLLECT
    SELECT * 
    BULK COLLECT INTO v_tickets
    FROM C##ADMIN_SYS_OPTI.tickets
    WHERE statut = v_statut;

    -- Parcourir les tickets récupérés
    FOR i IN 1..v_tickets.COUNT LOOP
        v_count := v_count + 1;
        -- Afficher chaque ticket (optionnel)
        DBMS_OUTPUT.PUT_LINE('Ticket ID: ' || v_tickets(i).ticket_id || ' - Sujet: ' || v_tickets(i).sujet);
    END LOOP;

    -- Fin mesure du temps
    v_end := SYSTIMESTAMP;

    -- Calcul du temps écoulé
    v_diff := v_end - v_start;

    -- Affichage des résultats
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets trouvés : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('Temps total pour SELECT par statut (' || v_statut || ') : ' || v_diff);
END;
