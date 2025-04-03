# Projet TAD

## Sommaire
[Prérequis](#prérequis)


## Prérequis

### Récupération de l'image Docker
Afin de pouvoir lancer notre BDD, vous devez vous munir d'un conteneur oracle, qui simulera la base de données (BDD). \
Vous pouvez récupérer l'image depuis internet, en exécutant la commande : `docker pull container-registry.oracle.com/database/free:latest`. \
Pour plus d'informations, nous vous conseillons de vous référer au site officiel d'Oracle : `https://www.oracle.com/fr/database/free/get-started/`.

### Lancement du conteneur
Une fois l'image récupérée, il faut lancer le conteneur. Vous pouvez utiliser la commande suivante :
```
docker run --name oracle-db \
            -p 1521:1521 \
            -e ORACLE_PWD={mdp de votre choix} \
            -e ENABLE_ARCHIVELOG=true \
            -e ENABLE_FORCE_LOGGING=true \
            -v {chemin vers un dossier partagé avec votre conteneur} \
            container-registry.oracle.com/database/free:latest
```

### Extensions VSCode recommandées
Pour vous faciliter l'usage d'Oracle SQL et la connexion à la BDD, nous vous conseillons d'installer les extensions suivantes :
* SQL Developer
* SQL Server
* SQL Database Projects


## Récupération du code
Pour récupérer le code, il vous suffit de cloner ce repo. Une fois ce repo cloné, ouvrez le dossier avec VSCode. \
Commencez par cliquer sur la loupe dans la barre de gauche et cherchez `{path-to-change}`. Ce chemin représente le chemin vers le dossier contenant les scripts SQL.
Il faudra donc le remplacer par le chemin que vous avez partagé avec le conteneur et copier les scripts SQL clonés à cet endroit.


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