# Projet TAD

Se connecter en tant qu'administrateur à la BDD :
* Ouvrir un terminal sur VSCode
* Cliquer sur la flèche pointant vers le bas à côté de '+'
* Sélectionner 'SQLcl'
* Entrer la commande : `connect C##NEW_SYS/passwordsys@localhost:1521/free;`

Se connecter à la BDD originale :
* Entrer la commande : `connect c##admin_sys_origin/password_sys_origin@localhost:1521/free;`

Se connecter à la BDD optimisée :
* Entrer la commande : `connect c##admin_sys_opti/password_sys_opti@localhost:1521/free;`

Pour voir les tables auxquelles l'utilisateur a accès : `SELECT TABLE_NAME FROM USER_TABLES;`

Vérifier si la création des utilisateurs a fonctionné : `connect c##witness/password_witness@localhost:1521/free;`
Vérifier si la création des utilisateurs a fonctionné : `connect c##improvement/password_improvement@localhost:1521/free;`

Accéder aux tables avec les comptes de service : `SELECT * FROM C##ADMIN_SYS{opti | origin}.{nom de la table souhaitée}`