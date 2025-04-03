-- 1. Suppression des tables associées aux utilisateurs
BEGIN
    -- Supprimer toutes les tables des utilisateurs spécifiés
    FOR t IN (SELECT owner, table_name
              FROM all_tables
              WHERE owner IN ('C##NEW_SYS', 'C##ADMIN_SYS_ORIGIN', 'C##ADMIN_SYS_OPTI', 'C##WITNESS', 'C##IMPROVEMENT')) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.owner || '.' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/



-- 2. Supprimer les utilisateurs c##witness, c##improvement et c##new_sys ainsi que leurs objets, s'ils existent
BEGIN
    FOR rec IN (SELECT username FROM dba_users WHERE username IN ('C##NEW_SYS', 'C##ADMIN_SYS_ORIGIN', 'C##ADMIN_SYS_OPTI', 'C##WITNESS', 'C##IMPROVEMENT')) LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || rec.username || ' CASCADE';
    END LOOP;
END;
/



-- 3. Supprimer les rôles ROLE1, ROLE2 et ROLE3 ainsi que leurs objets, s'ils existent
-- Suppression des rôles
BEGIN
   FOR r IN (SELECT role 
             FROM dba_roles 
             WHERE role IN ('C##ORIGIN_READONLY', 'C##OPTI_READWRITE'))
   LOOP
      EXECUTE IMMEDIATE 'DROP ROLE ' || r.role;
   END LOOP;
END;
/



-- 4. Création de l'utilisateur SYS avec des privilèges administratifs
CREATE USER c##new_sys IDENTIFIED BY "passwordsys";
GRANT DBA TO c##new_sys;

-- Se connecter sous l'utilisateur SYS pour exécuter les scripts SQL
ALTER SESSION SET CURRENT_SCHEMA = c##new_sys;

-- Création des administrateurs
CREATE USER c##admin_sys_origin IDENTIFIED BY "password_sys_origin";
GRANT DBA TO c##admin_sys_origin;

CREATE USER c##admin_sys_opti IDENTIFIED BY "password_sys_opti";
GRANT DBA TO c##admin_sys_opti;



-- 5. Création / importation des BDD
SELECT name FROM v$database;

-- a. BDD origine
-- Importation de la BDD d'origine
ALTER SESSION SET CURRENT_SCHEMA = c##admin_sys_origin;
@/Users/aurelienruppe/Documents/Cours/AdminBDD/DB/bdd_origin.sql

-- Création de l'utilisateur témoin avec un accès lecture seule sur bdd_origin
CREATE USER c##witness IDENTIFIED BY "password_witness";
GRANT CONNECT TO c##witness;

CREATE ROLE c##origin_readOnly;

SELECT name FROM v$database;

-- Accorder des droits SELECT sur toutes les tables de bdd_origin
BEGIN
    FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'C##ADMIN_SYS_ORIGIN') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON C##ADMIN_SYS_ORIGIN.' || t.table_name || ' TO c##origin_readOnly';
    END LOOP;
END;
/

GRANT c##origin_readOnly TO c##witness;


-- -- b. BDD optimisée
-- -- Importation de la BDD optimisée
-- ALTER SESSION SET CURRENT_SCHEMA = c##admin_sys_opti;
-- @/Users/aurelienruppe/Documents/Cours/AdminBDD/DB/bdd_opti.sql

-- -- Création de l'utilisateur Amélioration avec tous les droits sur bdd_opti
-- CREATE USER c##improvement IDENTIFIED BY password_improvement;
-- GRANT CONNECT, RESOURCE TO c##improvement;

-- CREATE ROLE c##opti_readWrite;

-- -- Accorder tous les privilèges sur les tables de bdd_opti
-- BEGIN
--     FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'C##ADMIN_SYS_OPTI') LOOP
--         EXECUTE IMMEDIATE 'GRANT ALL PRIVILEGES ON C##ADMIN_SYS_OPTI.' || t.table_name || ' TO c##opti_readWrite';
--     END LOOP;
-- END;
-- /

-- GRANT c##opti_readWrite TO c##improvement;