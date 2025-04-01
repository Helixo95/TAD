-- 1. Supprimer les utilisateurs c##witness, c##improvement et c##new_sys ainsi que leurs objets, s'ils existent
BEGIN
    FOR rec IN (SELECT username FROM dba_users WHERE username IN ('C##WITNESS', 'C##IMPROVEMENT', 'C##NEW_SYS')) LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || rec.username || ' CASCADE';
    END LOOP;
END;
/

-- 2. Création de l'utilisateur SYS avec des privilèges administratifs
CREATE USER c##new_sys IDENTIFIED BY password_sys;
GRANT DBA TO c##new_sys;

-- Se connecter sous l'utilisateur SYS pour exécuter les scripts SQL
ALTER SESSION SET CURRENT_SCHEMA = c##new_sys;

-- 3. Création / importation des bases de données
SELECT name FROM v$database;

@/Users/aurelienruppe/Documents/Cours/AdminBDD/DB/bdd_origin.sql
-- @/Users/aurelienruppe/Documents/Cours/AdminBDD/DB/bdd_opti.sql

-- 4. Création de l'utilisateur Témoin avec un accès lecture seule sur bdd_origin
CREATE USER c##witness IDENTIFIED BY password_witness;
GRANT CONNECT TO c##witness;

SELECT name FROM v$database;

-- Accorder des droits SELECT sur toutes les tables de bdd_origin
BEGIN
    FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'C##NEW_SYS') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON C##NEW_SYS.' || t.table_name || ' TO c##witness';
    END LOOP;
END;
/

-- 5. Création de l'utilisateur Amélioration avec tous les droits sur bdd_opti
CREATE USER c##improvement IDENTIFIED BY password_improvement;
GRANT CONNECT, RESOURCE TO c##improvement;

-- Accorder tous les privilèges sur les tables de bdd_opti
BEGIN
    FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'C##NEW_SYS') LOOP
        EXECUTE IMMEDIATE 'GRANT ALL PRIVILEGES ON C##NEW_SYS.' || t.table_name || ' TO c##improvement';
    END LOOP;
END;
/