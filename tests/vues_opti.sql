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
    l_count INT := 0;
BEGIN
-- Test sur la vue v_eleves_tickets (sur bdd_opti)
    -- Initialiser le compteur
    l_count := 0;
    
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_eleves_tickets
    FOR rec IN (SELECT *
                FROM C##ADMIN_SYS_OPTI.v_eleves_tickets v
                WHERE v.statut = 1)
    LOOP
        l_count := l_count + 1;
    END LOOP;



    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_eleves_tickets sur bdd_opti : ' || v_diff);

    -- Afficher le nombre d'éléments traités
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets traités : ' || l_count);

-- Test sur la vue v_licences_logiciels_eleves (sur bdd_opti)
    -- Initialiser le compteur
    l_count := 0;
    
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_licences_logiciels_eleves
    FOR rec IN (SELECT 
                    v.licence_id,
                    v.cle_licence,
                    v.date_expiration,
                    v.nom_logiciel,
                    v.nom_eleve,
                    v.prenom_eleve
                FROM C##ADMIN_SYS_OPTI.v_licences_logiciels_eleves v
                JOIN C##ADMIN_SYS_OPTI.logiciels s ON v.nom_logiciel = s.nom
                WHERE v.nom_eleve IS NOT NULL
                AND v.classe = 'Terminale')
    LOOP
        l_count := l_count + 1;
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_licences_logiciels_eleves sur bdd_opti : ' || v_diff);

    -- Afficher le nombre d'éléments traités
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets traités : ' || l_count);

-- Test sur la vue v_analyse_classe_filiere (sur bdd_opti)
    -- Initialiser le compteur
    l_count := 0;
    
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_analyse_classe_filiere
    FOR rec IN (SELECT 
                    v.classe,
                    v.filiere,
                    v.nb_eleves,
                    v.nb_tickets,
                    v.nb_licences,
                    v.nb_logiciels,
                    v.nb_equipements
                FROM C##ADMIN_SYS_OPTI.v_analyse_classe_filiere v
                WHERE v.nb_eleves > 50  -- Condition sur le nombre d'élèves
                    AND v.nb_tickets > 10  -- Condition sur le nombre de tickets
                    AND v.nb_licences > 5  -- Condition sur le nombre de licences
                    AND v.nb_logiciels > 3  -- Condition sur le nombre de logiciels
                    AND v.nb_equipements > 0  -- Condition sur le nombre d'équipements
                ORDER BY v.classe, v.filiere)
    LOOP
        l_count := l_count + 1;
    END LOOP;


    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_analyse_classe_filiere sur bdd_opti : ' || v_diff);

    -- Afficher le nombre d'éléments traités
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets traités : ' || l_count);
END;
