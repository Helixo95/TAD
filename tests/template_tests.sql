
-- vues_origin.sql
-- Tests de performance pour les vues dans la base de données d'origine (sans clusters)

-- Active l'affichage des messages de sortie
SET SERVEROUTPUT ON;

------------------------------------------------------------
------------------- Tests sur les vues -------------------
------------------------------------------------------------

DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
BEGIN
    -- Test sur la vue {nom tâche}
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- requete de tests ici

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution {nom tâche} : ' || v_diff);


    -- Test sur la vue {nom tâche}
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- requete de tests ici

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution {nom tâche} : ' || v_diff);


    -- Test sur la vue {nom tâche}
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- requete de tests ici

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution {nom tâche} : ' || v_diff);


END;
