-- CREATION DES USERS


-- 1. Création de l'utilisateur SYS avec tous les privilèges sur toutes les bases de données
CREATE USER c##new_sys IDENTIFIED BY password_sys;
GRANT ALL PRIVILEGES TO c##new_sys WITH GRANT OPTION;

CONNECT c##new_sys/password_sys;

-- 2. Création / importation des bases de données
@bdd_origin.sql
@bdd_opti.sql

-- 3. Création de l'utilisateur Témoin avec un accès restreint (lecture seule) sur bdd_origin
CREATE USER c##witness IDENTIFIED BY password_witness;
GRANT SELECT ON bdd_origin TO c##witness;
GRANT CONNECT TO c##witness;

-- 4. Création de l'utilisateur Amélioration avec tous les droits sur bdd_opti
CREATE USER c##improvement IDENTIFIED BY password_improvement;
GRANT ALL PRIVILEGES ON bdd_opti TO c##improvement;
GRANT CONNECT TO c##improvement;
