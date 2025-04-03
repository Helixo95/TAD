-- vues_opti.sql
-- Tests de performance pour les vues dans la base de données optimisée (avec clusters)

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
    -- Test sur la vue v_eleves_tickets (sur bdd_opti)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_eleves_tickets (sur bdd_opti)
    SELECT *
    FROM C##ADMIN_SYS_OPTI.v_eleves_tickets
    WHERE t.statut = 1;
    -- à refaire

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_eleves_tickets sur bdd_opti : ' || v_diff);

    -- Test sur la vue v_licences_logiciels_eleves (sur bdd_opti)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_licences_logiciels_eleves (sur bdd_opti)
    SELECT l.licence_id, l.date_attribution, s.logiciel_id, e.nom
    FROM C##ADMIN_SYS_OPTI.v_licences_logiciels_eleves l
    JOIN C##ADMIN_SYS_OPTI.logiciels s ON l.logiciel_id = s.logiciel_id
    JOIN C##ADMIN_SYS_OPTI.eleves e ON l.eleve_id = e.eleve_id
    WHERE e.classe = 'Terminale';

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_licences_logiciels_eleves sur bdd_opti : ' || v_diff);

    -- Test sur la vue v_ticket_logs (sur bdd_opti)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_ticket_logs (sur bdd_opti)
    SELECT t.ticket_id, t.sujet, l.action, l.date_action
    FROM C##ADMIN_SYS_OPTI.v_ticket_logs t
    JOIN C##ADMIN_SYS_OPTI.logs l ON t.ticket_id = l.ticket_id
    WHERE l.action = 'Création du ticket';

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_ticket_logs sur bdd_opti : ' || v_diff);
END;



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
    -- Test sur la vue v_eleves_tickets (sur bdd_opti)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_eleves_tickets
    SELECT 
        v.ticket_id,
        v.sujet,
        v.description,
        v.statut,
        v.eleve_id,
        v.nom_eleve,
        v.prenom_eleve,
        v.assigne_id,
        v.nom_administrateur
    FROM C##ADMIN_SYS_OPTI.v_eleves_tickets v
    WHERE v.statut = 1;  -- Application du filtre sur le statut



    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_eleves_tickets sur bdd_opti : ' || v_diff);

    -- Test sur la vue v_licences_logiciels_eleves (sur bdd_opti)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_licences_logiciels_eleves
    SELECT 
        v.licence_id,
        v.cle_licence,
        v.date_expiration,
        v.nom_logiciel,
        v.nom_eleve,
        v.prenom_eleve
    FROM C##ADMIN_SYS_OPTI.v_licences_logiciels_eleves v
    JOIN C##ADMIN_SYS_OPTI.logiciels s ON v.nom_logiciel = s.nom
    WHERE v.nom_eleve IS NOT NULL  -- Filtrage des résultats où l'élève existe
    AND v.classe = 'Terminale';

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_licences_logiciels_eleves sur bdd_opti : ' || v_diff);

    -- Test sur la vue v_analyse_classe_filiere (sur bdd_opti)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_analyse_classe_filiere
    SELECT 
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
    ORDER BY v.classe, v.filiere;


    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_analyse_classe_filiere sur bdd_opti : ' || v_diff);
END;
