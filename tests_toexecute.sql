SET SERVEROUTPUT ON;

--
-- Ajout de 1000 élèves avec tickets et logs
--

DECLARE
    i INT;
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    v_lieu VARCHAR2(5);
BEGIN
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Compteur pour le nombre d'élèves insérés
    DECLARE
        l_count INT := 0;
    BEGIN
        FOR i IN 1..1000 LOOP
            -- Alterne entre Cergy et Pau
            IF MOD(i, 2) = 0 THEN
                v_lieu := 'Cergy';
            ELSE
                v_lieu := 'Pau';
            END IF;

            -- Ajout d'un élève avec des tickets et logs
            INSERT INTO eleves (eleve_id, nom, prenom, email, password, classe, specialite, filiere, lieu)
            VALUES (90 + i, 'Nom' || i, 'Prénom' || i, 'email' || i || '@example.com', 'pass' || i, 'Classe' || i, 'Spécialité' || i, 'Filière' || i, v_lieu);

            INSERT INTO tickets (ticket_id, sujet, description, statut, date_ouverture, date_fermeture, eleve_id, assigne_id)
            VALUES (i + 1000, 'Problème ' || i, 'Problème numéro ' || i, 0, CURRENT_TIMESTAMP, NULL, 90 + i, 1);

            INSERT INTO logs (log_id, action, date_action, eleve_id, ticket_id)
            VALUES (i + 2000, 'Création du ticket', CURRENT_TIMESTAMP, 90 + i, i + 1000);

            -- Afficher l'identifiant généré avec CURRVAL
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
        DBMS_OUTPUT.PUT_LINE('Temps d exécution : ' || v_diff);

        -- Afficher le nombre d'élèves insérés
        DBMS_OUTPUT.PUT_LINE('Nombre d élèves insérés : ' || l_count);
    END;
END;
