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
    -- Test sur la vue v_eleves_tickets (sur bdd_origin)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_eleves_tickets (sur bdd_origin)
    SELECT e.nom, e.prenom, t.ticket_id, t.sujet
    FROM C##ADMIN_SYS_ORIGIN.v_eleves_tickets e
    JOIN C##ADMIN_SYS_ORIGIN.tickets t ON e.eleve_id = t.eleve_id
    WHERE t.statut = 1;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_eleves_tickets sur bdd_origin : ' || v_diff);

    -- Test sur la vue v_licences_logiciels_eleves (sur bdd_origin)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_licences_logiciels_eleves (sur bdd_origin)
    SELECT l.licence_id, l.date_attribution, s.logiciel_id, e.nom
    FROM C##ADMIN_SYS_ORIGIN.v_licences_logiciels_eleves l
    JOIN C##ADMIN_SYS_ORIGIN.logiciels s ON l.logiciel_id = s.logiciel_id
    JOIN C##ADMIN_SYS_ORIGIN.eleves e ON l.eleve_id = e.eleve_id
    WHERE e.classe = 'Terminale';

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_licences_logiciels_eleves sur bdd_origin : ' || v_diff);

    -- Test sur la vue v_ticket_logs (sur bdd_origin)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la vue v_ticket_logs (sur bdd_origin)
    SELECT t.ticket_id, t.sujet, l.action, l.date_action
    FROM C##ADMIN_SYS_ORIGIN.v_ticket_logs t
    JOIN C##ADMIN_SYS_ORIGIN.logs l ON t.ticket_id = l.ticket_id
    WHERE l.action = 'Création du ticket';

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la vue v_ticket_logs sur bdd_origin : ' || v_diff);
END;
