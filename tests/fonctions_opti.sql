-- Test de la procédure de création de licences sur la base de données optimisée

-- Active l'affichage des messages de sortie
SET SERVEROUTPUT ON;

DECLARE
    v_start TIMESTAMP;
    v_end TIMESTAMP;
    v_diff INTERVAL DAY TO SECOND;
    v_cle_licence VARCHAR2(50);
    v_date_expiration DATE := SYSDATE + 365; -- Date d'expiration dans un an
    v_logiciel_id NUMBER;
    v_eleve_id NUMBER;
    v_count NUMBER := 1000; -- Nombre de licences à insérer
    v_sujet VARCHAR2(255);
    v_description VARCHAR2(4000);  -- La description est de type CLOB, donc peut être plus longue
    v_nom VARCHAR2(100);
    v_prenom VARCHAR2(100);
    v_email VARCHAR2(255);
    v_password VARCHAR2(255);
    v_classe VARCHAR2(50);
    v_specialite VARCHAR2(50);
    v_filiere VARCHAR2(50);
BEGIN
-- Insertion de licences
    -- Temps de début
    v_start := SYSTIMESTAMP;

    FOR i IN 1..v_count LOOP
        -- Génération de valeurs pour les paramètres
        v_cle_licence := 'CLE' || TO_CHAR(i, 'FM0000');
        v_logiciel_id := MOD(i, 10) + 1; -- Exemple : 10 logiciels différents
        v_eleve_id := MOD(i, 100) + 1;    -- Exemple : 100 élèves différents

        -- Appel de la procédure pour créer une licence
        C##ADMIN_SYS_OPTI.create_licence(
            p_cle_licence     => v_cle_licence,
            p_date_expiration => v_date_expiration,
            p_logiciel_id     => v_logiciel_id,
            p_eleve_id        => v_eleve_id
        );
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution pour l''insertion de ' || v_count || ' licences : ' || v_diff);

    COMMIT;

-- Insertions d'élèves
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Insérer 3000 élèves
    FOR i IN 4101..5100 LOOP
        -- Générer des données fictives pour chaque élève
        v_nom := 'Nom' || i;  -- Nom générique
        v_prenom := 'Prenom' || i;  -- Prénom générique
        v_email := 'email' || i || '@example.com';  -- Email générique
        v_password := 'password' || i;  -- Password générique
        v_classe := 'Classe' || (MOD(i, 3) + 1);  -- Classe alternée (1, 2, 3)
        v_specialite := 'Specialite' || (MOD(i, 5) + 1);  -- Spécialité alternée (1 à 5)
        v_filiere := 'Filiere' || (MOD(i, 4) + 1);  -- Filière alternée (1 à 4)

        -- Appeler la fonction pour insérer l'élève
        -- Remarque : La fonction doit déjà être créée dans la base de données
        v_eleve_id := C##ADMIN_SYS_OPTI.create_eleve(v_nom, v_prenom, v_email, v_password, v_classe, v_specialite, v_filiere);

        -- Affichage de l'ID de l'élève inséré (facultatif)
        DBMS_OUTPUT.PUT_LINE('Élève inséré avec ID : ' || v_eleve_id);
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution pour l''insertion de ' || v_count || ' élèves : ' || v_diff);

    COMMIT;

-- Insertions de tickets
    -- Temps de début
    v_start := SYSTIMESTAMP;

    -- Insérer 3000 tickets
    FOR i IN 4101..5100 LOOP
        -- Générer des données fictives pour chaque ticket
        v_sujet := 'Ticket sujet ' || i;  -- Sujet générique
        v_description := 'Description du ticket ' || i;  -- Description générique

        -- Sélectionner un élève existant
        v_eleve_id := 1 MOD(i, 100);  -- ID d'élève, en utilisant des élèves de 1 à 100

        -- Appel de la procédure pour insérer le ticket
        -- Remarque : La procédure doit déjà être créée dans la base de données
        EXECUTE IMMEDIATE 'BEGIN C##ADMIN_SYS_OPTI.create_ticket(:1, :2, :3); END;'
            USING v_sujet, v_description, v_eleve_id;

    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution pour l''insertion de ' || v_count || ' tickets : ' || v_diff);
END;
