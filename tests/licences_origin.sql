-- Test de l'insertion directe de licences sur la base de données d'origine

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
BEGIN
    -- Temps de début
    v_start := SYSTIMESTAMP;

    FOR i IN 1..v_count LOOP
        -- Génération de valeurs pour les paramètres
        v_cle_licence := 'CLE' || TO_CHAR(i, 'FM0000');
        v_logiciel_id := MOD(i, 10) + 1; -- Exemple : 10 logiciels différents
        v_eleve_id := MOD(i, 100) + 1;    -- Exemple : 100 élèves différents

        -- Insertion directe dans la table licences
        INSERT INTO C##ADMIN_SYS_ORIGIN.licences (licence_id, cle_licence, date_expiration, logiciel_id, eleve_id)
        VALUES (seq_licence_id.NEXTVAL, v_cle_licence, v_date_expiration, v_logiciel_id, v_eleve_id);
    END LOOP;

    -- Temps de fin
    v_end := SYSTIMESTAMP;

    -- Calculer la différence de temps
    v_diff := v_end - v_start;

    -- Afficher le temps d'exécution
    DBMS_OUTPUT.PUT_LINE('Temps d''exécution pour l''insertion de ' || v_count || ' licences : ' || v_diff);

    COMMIT;
END;
