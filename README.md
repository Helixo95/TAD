# Projet TAD

## Sommaire
[Prérequis](#prérequis)
[Récupération de l'image Docker]()
[Lancer le conteneur]()
[Extensions VSCode recommandées]()
[Récupération du code]()
[Scripts SQL]()
[Lancer les scripts de configuration de la BDD]()
[Lancer des tests]()
[Se connecter à la BDD depuis VSCode]()


## Prérequis

### Récupération de l'image Docker
Afin de pouvoir lancer notre BDD, vous devez vous munir d'un conteneur oracle, qui simulera la base de données (BDD). \
Vous pouvez récupérer l'image depuis internet, en exécutant la commande : \
```docker pull container-registry.oracle.com/database/free:latest```. \
Pour plus d'informations, nous vous conseillons de vous référer au site officiel d'Oracle disponible [ici](https://www.oracle.com/fr/database/free/get-started/).

### Lancer le conteneur
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

Il vous faudra configurer ces extensions pour qu'elles puissent se connecter à votre conteneur.

## Récupération du code
Pour récupérer le code, il vous suffit de cloner ce repo. Une fois ce repo cloné, ouvrez le dossier avec VSCode. \
Commencez par cliquer sur la loupe dans la barre de gauche et cherchez `{path-to-change}`. Ce chemin représente le chemin vers le dossier contenant les scripts SQL.
Il faudra donc le remplacer par le chemin que vous avez partagé avec le conteneur et copier les scripts SQL clonés à cet endroit.


## Scripts SQL
Dans ce projet, vous trouverez différents scripts SQL :
* users.sql : nettoye la BDD à chaque lancement puis de recréer les utilisateurs, tables, rôles et la BDD.
* bdd_origin.sql : crée les tables et la partitions des données entre 2 sites. Il fait appel à `insertions.sql`.
* bdd_opti.sql : fais appel à `bdd_origin.sql` pour la création des tables et l'insertion des données. Il crée des vues, indexs, clusters... qui permettent d'améliorer la gestion, maintenabilité et rapidité de la BDD.
* insertions.sql : insertions de données par défaut dans la BDD (90 par table).


## Lancer les scripts de configuration de la BDD
Pour lancer les scripts de configuration de la BDD, il vous faut ouvrir `users.sql` dans VSCode. Une fois ce scrit ouvert, cliquez sur "Lancer le script" ou sur la touche "F5". \
Une fois ce script terminé, votre BDD est utilisable.


## Lancer des tests
Si vous souhaitez lancer des tests sur votre BDD, vous pouvez vous rendre dans le dossier "tests", ouvrir les scripts et les exécuter. Seul le script "test_in_terminal" ne fonctionnera pas : il s'agit de commandes que vous pouvez rentrer directement dans votre terminal (cf [Se connecter à la BDD depuis VSCode](#se-connecter-à-la-bdd-depuis-vscode)).


## Se connecter à la BDD depuis VSCode

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