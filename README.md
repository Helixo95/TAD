# Projet TAD

Se connecter en tant qu'administrateur à la BDD :
* Ouvrir un terminal sur VSCode
* Cliquer sur la flèche pointant vers le bas à côté de '+'
* Sélectionner 'SQLcl'
* Entrer la commande : `connect C##NEW_SYS/passwordsys@localhost:1521/free;`
* Entrer la commande : `connect c##admin_sys_origin/password_sys_origin@localhost:1521/free;`

Pour voir les tables auxquelles l'utilisateur a accès : `SELECT TABLE_NAME FROM USER_TABLES;`
