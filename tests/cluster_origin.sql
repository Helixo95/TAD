-- Tests de performance pour la base de données sans clusters

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
BEGIN
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête sans clusters (sur bdd_origin)
    SELECT e.nom, t.ticket_id
    FROM eleves e
    JOIN tickets t ON e.eleve_id = t.eleve_id;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la jointure élèves-tickets : ' || v_diff);

COMMIT;

--------------------------------------------------------------------------
-- Test simulation Clusters Équipement-Élève
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête sans clusters (sur bdd_origin)
    SELECT e.nom, eq.equipement_id
    FROM eleves e
    JOIN equipements eq ON e.eleve_id = eq.eleve_id;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la jointure équipement-élève : ' || v_diff);

COMMIT;
--------------------------------------------------------------------------
-- Test simulation Clusters Logiciel-Licences
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête sans clusters (sur bdd_origin)
    SELECT l.licence_id, s.logiciel_id
    FROM licences l
    JOIN logiciels s ON l.logiciel_id = s.logiciel_id;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la jointure logiciel-licences : ' || v_diff);
END;
