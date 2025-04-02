

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

SELECT table_name
FROM all_tables
WHERE owner = 'C##NEW_SYS';  -- Remplacez par le nom du schéma cible


BEGIN
    FOR t IN (SELECT table_name
              FROM all_tables
              WHERE owner = 'C##NEW_SYS'  -- Remplacez par le nom du schéma cible
                AND table_name NOT LIKE 'BIN$%' -- Exclut les tables système
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE C##NEW_SYS."' || t.table_name || '" CASCADE CONSTRAINTS';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Erreur lors de la suppression de la table ' || t.table_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/


CONNECT c##new_sys/password_sys@localhost:1521/bdd_origin;

SELECT name FROM v$database;
SELECT status FROM v$instance;

SELECT INSTANCE_NAME, STATUS FROM v$instance;

SELECT username FROM all_users ORDER BY username;

SELECT PDB_NAME, STATUS FROM CDB_PDBS;
