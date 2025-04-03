-- Tests de performance pour la base de données sans clusters

-- Active l'affichage des messages de sortie
SET SERVEROUTPUT ON;

DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    v_lieu VARCHAR2(5);
    l_count INT := 0;  -- Compteur pour les élèves
    TYPE ticket_record IS RECORD (
        ticket_id NUMBER,
        sujet VARCHAR2(255),
        description VARCHAR2(255),
        statut NUMBER,
        date_ouverture TIMESTAMP,
        date_fermeture TIMESTAMP,
        eleve_id NUMBER,
        assigne_id NUMBER
    );
    TYPE ticket_table_type IS TABLE OF ticket_record;
    v_tickets ticket_table_type;
BEGIN
    -- Initialiser le compteur pour les tickets
    l_count := 0;

    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Tester la jointure élèves-tickets
    FOR ticket_rec IN (
        SELECT e.nom, t.ticket_id
        FROM C##ADMIN_SYS_ORIGIN.eleves e
        JOIN C##ADMIN_SYS_ORIGIN.tickets t ON e.eleve_id = t.eleve_id
    ) LOOP
        -- Afficher les résultats
        -- DBMS_OUTPUT.PUT_LINE('Élève : ' || ticket_rec.nom || ', Ticket ID : ' || ticket_rec.ticket_id);
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    COMMIT;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution : ' || v_diff);

    -- Afficher le nombre de tickets traités
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets traités : ' || l_count);

---------------------------------------------------------------------------------------
    -- Réinitialiser le compteur pour la prochaine jointure
    l_count := 0;

    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Tester la jointure équipement-élève
    FOR equip_rec IN (
        SELECT e.nom, eq.equip_id
        FROM C##ADMIN_SYS_ORIGIN.eleves e
        JOIN C##ADMIN_SYS_ORIGIN.equipements_reseau eq ON e.eleve_id = eq.eleve_id
    ) LOOP
        -- Afficher les résultats
        -- DBMS_OUTPUT.PUT_LINE('Élève : ' || equip_rec.nom || ', Équipement ID : ' || equip_rec.equip_id);
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    COMMIT;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution : ' || v_diff);

    -- Afficher le nombre d'équipements traités
    DBMS_OUTPUT.PUT_LINE('Nombre d''équipements traités : ' || l_count);

---------------------------------------------------------------------------------------
    -- Réinitialiser le compteur pour la prochaine jointure
    l_count := 0;

    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Tester la jointure logiciel-licences
    FOR licence_rec IN (
        SELECT l.licence_id, s.logiciel_id
        FROM C##ADMIN_SYS_ORIGIN.licences l
        JOIN C##ADMIN_SYS_ORIGIN.logiciels s ON l.logiciel_id = s.logiciel_id
    ) LOOP
        -- Afficher les résultats
        -- DBMS_OUTPUT.PUT_LINE('Licence ID : ' || licence_rec.licence_id || ', Logiciel ID : ' || licence_rec.logiciel_id);
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    COMMIT;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution : ' || v_diff);

    -- Afficher le nombre de licences traitées
    DBMS_OUTPUT.PUT_LINE('Nombre de licences traitées : ' || l_count);

END;
/
