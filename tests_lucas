
--ajout de 1000 eleves
-- Active l'affichage DBMS_OUTPUT
SET SERVEROUTPUT ON;

DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    v_lieu VARCHAR2(10);
BEGIN
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Boucle d'insertion de 1000 élèves
    FOR i IN 1..1000 LOOP
        -- Alterne entre Cergy et Pau
        IF MOD(i, 2) = 0 THEN
            v_lieu := 'Cergy';
        ELSE
            v_lieu := 'Pau';
        END IF;

        -- Insertion de l'élève
        INSERT INTO eleves (eleve_id, nom, prenom, email, password, classe, specialite, filiere, lieu) 
        VALUES (eleves_seq.NEXTVAL, 'Nom'||i, 'Prenom'||i, 'user'||i||'@example.com', 'password'||i, 'Classe'||MOD(i,3), 'Specialite'||MOD(i,2), 'Filiere'||MOD(i,4), v_lieu);

        -- Afficher l'identifiant généré avec CURRVAL
        DBMS_OUTPUT.PUT_LINE('Élève inséré avec ID : ' || eleves_seq.CURRVAL);
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

COMMIT;

    -- Différence de temps
    v_diff := v_end - v_start;

    -- Affichage du temps total d'insertion
    DBMS_OUTPUT.PUT_LINE('Temps total pour insertion de 1000 utilisateurs : ' || v_diff);
END;
/


--- vérfication eleves avec son email
-- Active l'affichage
SET SERVEROUTPUT ON;

DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    v_eleve eleves%ROWTYPE;
    v_email VARCHAR2(255) := 'user5@example.com'; -- Change l'email si besoin
BEGIN
    -- Démarrer mesure de temps
    v_start := SYSTIMESTAMP;

    -- SELECT de l'élève par email
    SELECT *
    INTO v_eleve
    FROM eleves
    WHERE email = v_email;

    -- Terminer mesure de temps
    v_end := SYSTIMESTAMP;

    -- Calcul du temps écoulé
    v_diff := v_end - v_start;

    -- Affichage des résultats
    DBMS_OUTPUT.PUT_LINE('Élève trouvé : ID=' || v_eleve.eleve_id || ', Nom=' || v_eleve.nom || ', Prénom=' || v_eleve.prenom);
    DBMS_OUTPUT.PUT_LINE('Temps pour SELECT : ' || v_diff);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun élève trouvé avec l''email : ' || v_email);
END;
/

-- Active l'affichage
SET SERVEROUTPUT ON;

DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    
    -- Définir le statut recherché (0: ouvert, 1: en cours, 2: résolu, 3: fermé)
    v_statut INT := 1;
    
    -- Déclarer un curseur pour récupérer plusieurs tickets
    CURSOR cur_tickets IS
        SELECT *
        FROM tickets
        WHERE statut = v_statut;
        
    v_ticket cur_tickets%ROWTYPE;
    v_count INTEGER := 0;
BEGIN
    -- Démarrer la mesure de temps
    v_start := SYSTIMESTAMP;

    -- Ouverture et lecture du curseur
    OPEN cur_tickets;
    LOOP
        FETCH cur_tickets INTO v_ticket;
        EXIT WHEN cur_tickets%NOTFOUND;
        
        v_count := v_count + 1;
        
        -- Affiche chaque ticket (optionnel, pour vérification)
        DBMS_OUTPUT.PUT_LINE('Ticket ID: '|| v_ticket.ticket_id ||' - Sujet: '|| v_ticket.sujet);
    END LOOP;
    CLOSE cur_tickets;

    -- Fin mesure du temps
    v_end := SYSTIMESTAMP;

    -- Calcul du temps écoulé
    v_diff := v_end - v_start;

    -- Affichage des résultats
    DBMS_OUTPUT.PUT_LINE('Nombre de tickets trouvés : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('Temps total pour SELECT par statut ('||v_statut||') : ' || v_diff);
END;
/