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
    -- Test sur la requête v_eleves_tickets (sur bdd_origin)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la table tickets, eleves et administrateurs
    FOR rec IN (
        SELECT 
            t.ticket_id,
            t.sujet,
            t.description,
            t.statut,
            e.eleve_id,
            e.nom AS nom_eleve,
            e.prenom AS prenom_eleve,
            t.assigne_id,
            a.nom AS nom_administrateur
        FROM C##ADMIN_SYS_ORIGIN.tickets t
        LEFT JOIN C##ADMIN_SYS_ORIGIN.eleves e ON t.eleve_id = e.eleve_id
        LEFT JOIN C##ADMIN_SYS_ORIGIN.administrateurs a ON t.assigne_id = a.admin_id
        WHERE t.statut = 1  -- Application du filtre sur le statut
    ) LOOP
        -- Affichage des résultats avec DBMS_OUTPUT
        DBMS_OUTPUT.PUT_LINE('Ticket ID: ' || rec.ticket_id || ', Sujet: ' || rec.sujet);
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la requête v_eleves_tickets : ' || v_diff);

    -- Test sur la requête v_licences_logiciels_eleves (sur bdd_origin)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur la table licences, logiciels, et eleves
    FOR rec IN (
        SELECT 
            l.licence_id,
            l.cle_licence,
            l.date_expiration,
            lg.nom AS nom_logiciel,
            e.nom AS nom_eleve,
            e.prenom AS prenom_eleve,
            s.logiciel_id
        FROM C##ADMIN_SYS_ORIGIN.licences l
        LEFT JOIN C##ADMIN_SYS_ORIGIN.logiciels lg ON l.logiciel_id = lg.logiciel_id
        LEFT JOIN C##ADMIN_SYS_ORIGIN.eleves e ON l.eleve_id = e.eleve_id
        JOIN C##ADMIN_SYS_ORIGIN.logiciels s ON l.logiciel_id = s.logiciel_id
        WHERE e.classe = 'Terminale'
    ) LOOP
        -- Affichage des résultats avec DBMS_OUTPUT
        DBMS_OUTPUT.PUT_LINE('Licence ID: ' || rec.licence_id || ', Logiciel: ' || rec.nom_logiciel);
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la requête v_licences_logiciels_eleves : ' || v_diff);

    -- Test sur la requête v_analyse_classe_filiere (sur bdd_origin)
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Requête complexe sur plusieurs tables pour analyser la classe et la filière
    FOR rec IN (
        SELECT 
            ea.classe,
            ea.filiere,
            ea.nb_eleves,
            NVL(tg.nb_tickets, 0) AS nb_tickets,
            NVL(lg.nb_licences, 0) AS nb_licences,
            NVL(lcg.nb_logiciels, 0) AS nb_logiciels,
            NVL(eag.nb_equipements, 0) AS nb_equipements
        FROM (
            SELECT classe, filiere, COUNT(*) AS nb_eleves
            FROM C##ADMIN_SYS_ORIGIN.eleves
            GROUP BY classe, filiere
        ) ea
        LEFT JOIN (
            SELECT e.classe, e.filiere, COUNT(*) AS nb_tickets
            FROM C##ADMIN_SYS_ORIGIN.eleves e
            JOIN C##ADMIN_SYS_ORIGIN.tickets t ON e.eleve_id = t.eleve_id
            GROUP BY e.classe, e.filiere
        ) tg ON ea.classe = tg.classe AND ea.filiere = tg.filiere
        LEFT JOIN (
            SELECT e.classe, e.filiere, COUNT(*) AS nb_licences
            FROM C##ADMIN_SYS_ORIGIN.eleves e
            JOIN C##ADMIN_SYS_ORIGIN.licences l ON e.eleve_id = l.eleve_id
            GROUP BY e.classe, e.filiere
        ) lg ON ea.classe = lg.classe AND ea.filiere = lg.filiere
        LEFT JOIN (
            SELECT e.classe, e.filiere, COUNT(*) AS nb_logiciels
            FROM C##ADMIN_SYS_ORIGIN.eleves e
            JOIN C##ADMIN_SYS_ORIGIN.logiciels lg ON e.eleve_id = lg.eleve_id
            GROUP BY e.classe, e.filiere
        ) lcg ON ea.classe = lcg.classe AND ea.filiere = lcg.filiere
        LEFT JOIN (
            SELECT e.classe, e.filiere, COUNT(*) AS nb_equipements
            FROM C##ADMIN_SYS_ORIGIN.eleves e
            JOIN C##ADMIN_SYS_ORIGIN.equipements_reseau er ON e.eleve_id = er.eleve_id
            GROUP BY e.classe, e.filiere
        ) eag ON ea.classe = eag.classe AND ea.filiere = eag.filiere
        WHERE ea.nb_eleves > 50
            AND NVL(tg.nb_tickets, 0) > 10
            AND NVL(lg.nb_licences, 0) > 5
            AND NVL(lcg.nb_logiciels, 0) > 3
            AND NVL(eag.nb_equipements, 0) > 0
        ORDER BY ea.classe, ea.filiere
    ) LOOP
        -- Affichage des résultats avec DBMS_OUTPUT
        DBMS_OUTPUT.PUT_LINE('Classe: ' || rec.classe || ', Filière: ' || rec.filiere || ', Nb Eleves: ' || rec.nb_eleves);
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d exécution pour la requête v_analyse_classe_filiere : ' || v_diff);
END;
