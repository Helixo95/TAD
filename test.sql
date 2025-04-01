

SELECT owner, table_name
FROM all_tables
WHERE owner = 'C##NEW_SYS' OR 
      owner = 'C##WITNESS' OR
      owner = 'C##IMPROVEMENT'
ORDER BY owner, table_name
;


SELECT * 
FROM (SELECT table_name
        FROM all_tables) 
WHERE table_name = 'ORDINATEURS';

SELECT column_name, data_type, data_length
FROM all_tab_columns
WHERE table_name = 'ORDINATEURS'
ORDER BY column_id;


DESCRIBE ORDINATEURS;

SELECT name FROM v$database;


BEGIN
    -- Boucle sur toutes les tables de bdd_opti et suppression
    FOR t IN (SELECT table_name
              FROM all_tables
              WHERE owner = 'C##NEW_SYS'  -- C##NEW_SYS est l'utilisateur propriétaire de bdd_opti
                AND table_name NOT LIKE 'BIN$%' -- Optionnel : Exclut les tables système
    ) LOOP
        -- Exécuter la suppression de chaque table dans bdd_opti
        EXECUTE IMMEDIATE 'DROP TABLE C##NEW_SYS.' || t.table_name || ' CASCADE';
    END LOOP;
END;
/
