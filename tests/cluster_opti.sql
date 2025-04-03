-- Tests de performance pour la base de données avec clusters

-- Active l'affichage des messages de sortie
SET SERVEROUTPUT ON;

------------------------------------------------------------
------------------ Tests sur les clusters ------------------
------------------------------------------------------------

-- Test simulation Clusters élèves-tickets
DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    l_count INT := 0;
BEGIN
    -- Initialiser le compteur pour les tickets
    l_count := 0;

    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête avec clusters (sur bdd_opti)
    FOR rec IN (SELECT e.nom, t.ticket_id
                FROM C##ADMIN_SYS_OPTI.eleves e
                JOIN C##ADMIN_SYS_OPTI.tickets t ON e.eleve_id = t.eleve_id)
    LOOP
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la jointure élèves-tickets : ' || v_diff);

    -- Afficher le nombre de tickets traités
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets traités : ' || l_count);

COMMIT;

--------------------------------------------------------------------------
-- Test simulation Clusters Équipement-Élève
    -- Initialiser le compteur
    l_count := 0;

    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête avec clusters (sur bdd_opti)
    FOR rec IN (SELECT e.nom, eq.equip_id
                FROM C##ADMIN_SYS_OPTI.eleves e
                JOIN C##ADMIN_SYS_OPTI.equipements_reseau eq ON e.eleve_id = eq.eleve_id)
    LOOP
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la jointure équipement-élève : ' || v_diff);

    -- Afficher le nombre d'éléments traités
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets traités : ' || l_count);

COMMIT;

--------------------------------------------------------------------------
-- Test simulation Clusters Logiciel-Licences
    -- Initialiser le compteur
    l_count := 0;
    
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête avec clusters (sur bdd_opti)
    FOR rec IN (SELECT l.licence_id, s.logiciel_id
                FROM C##ADMIN_SYS_OPTI.licences l
                JOIN C##ADMIN_SYS_OPTI.logiciels s ON l.logiciel_id = s.logiciel_id)
    LOOP
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la jointure logiciel-licences : ' || v_diff);

    -- Afficher le nombre d'éléments traités
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets traités : ' || l_count);
END;
