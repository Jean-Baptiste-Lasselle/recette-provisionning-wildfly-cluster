# Résumé

Ce repo est une recette d'installation / configuration / test pour un cluster jee [wildfly](http://wildfly.org/).



En vous guidant de cette page de documentation, vous crééerez 2 machines virtuelles, exécuterez
des opérations sur ces 2 VMs, pour obtenir un cluster wildfly prêt à recevoir des déploiement de modules jee.

Dans toute la documentation de cette recette, je désignerai par:
* "`wildfly-master`": la première VM, dans laquelle nous installerons et configurerons l'instance wildfly  maître du cluster
* "`wildfly-slave`": la seconde VM, dans laquelle nous installerons et configurerons une instance wildfly esclave du cluster

À l'issue de ces opérations, vous trouverez:
* dans `wildfly-master`: une instance wildfly en exécution, maître du cluster wildfly,
* dans `wildfly-slave`: une instance wildfly en exécution, esclave du cluster wildfly,
* dans `wildfly-slave`: un conteneur docker en exécution, contenant une instance mariaDB, de nom "`sgbdr-mariadb`".
* dans `wildfly-slave`: un conteneur docker de nom "`oleoduc`" (non-démarré), qui peut être utilisé pour déployer les applications exemples. Dans ce conteneur: git 2.x, jdk 8.x, maven 3.x.

Toutes les instances d'applications web déployées dans le cluster, accèderont à une unique instance de BDD, gérée
par mariaDB dans le conteneur docker présent dans `wildfly-slave`.

Chaque release de ce repo référence une recette de déploiement d'un cluster wildfly.
Les release à venir sont:
* [v1.0.0](#résumé) [[2 machines]](#résumé): cette recette livrera un cluster Wildfly sur 2 VMs (1 "master", et 1 "slave"), et a été écrit en analysant en détail la [documentation officielle redhat](https://docs.jboss.org/author/display/WFLY/High+Availability+Guide), en particulier [cette section](https://docs.jboss.org/author/display/WFLY/Clustering+and+Domain+Setup+Walkthrough).
* [v1.0.1](#résumé) [[3 machines]](#résumé): cette recette livrera un cluster Wildfly sur 3 VMs (1 "master", et 2 "slave"). Cette recette comprendra de plus des scripts de tests, qui permettront de vérifier l'effectivité du "failover", d'un "slave", vers l'autre.
* [v1.0.2](#résumé) [[4 machines]](#résumé): cette recette livrera un cluster Wildfly sur 3 VMs (1 "master", et 2 "slave"). Cette recette livrera de plus, dans une 4ième VM "`VMtestantLeCluster`": une instance Jenkins, une instance JMeter ("en mode serveur" .bin\jmeter-server.sh ...) + PerfMonplugin, et une instance [Taurus](https://gettaurus.org/). Cette receette livrera `VMtestantLeCluster` dans un état tel que des tests JMeter, et leur reporting, sont automatisés et lançables à la demande, qui permettront de vérifier l'effectivité du "load balancing", d'un "slave", vers l'autre.
* [v2.0.0](#résumé) [[8 machines]](#résumé): cette recette livrera les mêmes éléments que la version [1.0.2], mais cette fois MariaDB sera "clusterisé": MariaDB sera installé sans conteneurs Docker, dans 3 VMs. [3 machines pour le cluster wildfly, 3 machines pour le cluster MariaDB, 2 machines pour l'outillage de tests/reporting tests (Jenkins, JMeter + PerfMonplugin, Taurus)]
* [v3.0.0](#résumé) [[6 + N machines]](#résumé): cette fois on déploiera les applications jee dans wildfly, wildfly étant installé dans Kuberntes. Ces applications feront usage d'une BDD dans un cluster MariaDB. 3 machines Kubernetes + 3 machines cluster MariaDB + N machines usine logicielle




# IMPORTANT

Ce repo n'est pas encore (19/02/2018) utilisable:

* Le repo est en cours de développement
* la doc que vous lisez et l'état du repo ne sont pas encore synchrones

# Comment utiliser ce repo?

## I. Provisionnez les machines

Il s'agira de provisionner 2 machines virtuelles.  


### Ma configuration de travail pour les tester cette recette.

J'ai simplement utilisé VirtualBox sur un PC 16 Go RAM. Notons ma machine "`PCtravail`".
* `PCtravail` est branché à un switch, et le switch est directement branché à ma box FAI.
* L'OS de `PCtravail` a une configuration IP en DHCP.

Dans la box que mon fournisseur d'accès internet m'a fournie, un serveur DHCP est isntallé en tant que service.
C'est sans doute le cas du routeur/wifi que vous a fournit votre FAI.

Etant donné que mon PC `PCtravail` est branché directement à ma box, c'est
ma box qui fait office de serveur DHCP, et attribue donc une configuration IP à `PCtravail`.
En effet, 

Dans cette situation, une VM créée avec VirtualBox dans `PCtravail`, avec une
carte réseau en "Accès par pont", pourra se voir aussi attribuer une configuration IP par ma box:
Une telle VM est comme elle même physiquement branchée à ma box.
C'est un peu comme si "PCtravail" et la MV étaient totue deux branchée à un switch, et le switch branché à ma box

### Configuration hardware à apppliquer

* Pour chaque VM, il vous faudra au moins une carte réseau virtuelle, configurée en mode "Accès par pont" ("Bridged Network", pour les installations anglophones).
* Pour chaque VM, je recommande 4096 Go de RAM aux 2 VMs
* Pour chaque VM, je recommande 2 vCPUs


### pré-requis

Afin de pouvoir exécutr les opérations de cette recette, les conditions suivantes doivent être remplies:

* Vous devrez pouvoir avoir accès en SSH à vos 2 VMs, depuis votre machine de travail.
* Vos deux VMs doivent pouvoir accéder à internet.


## II. Installez CentOS 7 dans vos 2 VM.

Vous trouverez facilement quelque aide sur internet. Si vous avez déjà installé un linux, vous n'aurez aucune difficulté, sinon, si
vous en êtes à vouloir mettre en place un cluster, c'est un bon moment dans votre vie professionnelle pour apprendre à faire une
installation Linux, s'il le faut.


## III. Vérifiez que vos 2 VMs ont accès au réseau.

À l'issue de mon installation de CentOS dans mes 2 VMs, un interface résau linux a
été créée (comme d'habitude avec les linux), et son nom est: `enp0s3`.

Pour vérifier vous même le nom de l'interface réseau linux qui a été créé dans votre cas, exécutez la commande: `ip addr`.
Notez donc le nom de votre interface réseau.

Dans mon cas, toujours à l'issue de l'installation de CentOS, le fichier `/etc/sysconfig/network-scripts/ifcfg-enp0s3` contient :

`ONBOOT=no`

Mon système ne fait donc pas usage de la carte réseau que j'ai configuré en "Accès par pont", avec VitualBox.
Et comme dans mon cas il s'agit de la seule carte réseau, je n'ai donc en l'état, accès à aucun réseau.

Pour permettre à ma VM d'accéder à au moins un réseau, et être accessible depuis d'autres machines, j'ai exécuté les commandes:

`sudo sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3`

`sudo systemctl restart network`

Ce qui remplace la chaîne de caractères `ONBOOT=no`, par la chaîne de caractères `ONBOOT=yes` dans
le fichier:

 `/etc/sysconfig/network-scripts/ifcfg-enp0s3` 
 
(et redémarre le service réseau, pour lancer la séquence DHCP).

## IV. Procédez aux opérations.

Les opérations se déroulent de la manière suivante, pour s'abstraire de l'automatisation sur le poste client et l'OS que vous utilisez:
* On exécute une recette dans la VM "wildfly-master", puis dans  la VM "wildfly-slave": on 
* On déploie une première application Jee dans le cluster: Cette application est une application Web simple, et on vérifiera avec l'admin wildfly web que l'application a bien été déployée à la fois dans la VM "wildfly-master" et dans la VM "wildfly-slave". On vérifiera le bon fonctionneement de cette application, qui a un fonctionneemtn minimal: la page par défaut de cette applicationa ffiche les données insérées préalablement dans une BDD. Le test consistera à charger l'application une première fois, insérer des données avec un script SQL, puis charger à nouveau l'application et constater l'afficahge correct sans erreurs ou exception, des données avant et après insertion.
* [Bientôt dans ce repo] On déploie une deuxième application Web Jee dans le cluster: cette application est simple, fait usage de sessions HTTP, de sessions Hibernate, et on vérifie la réplication InfiniSpan des sessions HTTP et Hibernate en lançant un deuxième "slave", pour le tuer en pleine exécution. L'application est basée sur une authentification, et un panier d'achats stocké en session HTTP.
* [Bientôt dans ce repo] On déploie une troisième application Web Jee dans le cluster: cette application est simple, fait usage de sessions HTTP, de sessions Hibernate, mais surtout aussi de sessions EJB Stateful Session Bean ("SFSB's"), on fait les vérificatiosn de réplication InfiniSpan
* [Bientôt dans ce repo] Les deux cas précédents ont permis de tester le "fail-over". Un dernier volet de ce tutoriel consistera à arriver à déclencher le load balancing dans le cas d'un cluster à 1 maître/ 2 esclaves. On utilisera JMeter pour fournir la charge. Et on utilisera l'utilitaire "VBoxManage": `VBoxManage modifyvm "wildfly-slave2" --nictrace1 on --nictracefile1 log-reseau-wildfly-slave-a-lire-ac-wireshark.pcap` pour constater le load balancing dans les trames réseau. 

### 1. Exécution des opérations dans les VMs

Copiez dans la VM "wildfly-slave" le répertoire "./slave" , et exécutez les commandes:

 `# resp. "cd ./master"...`
 
 `cd ./slave`
 
 `sudo chmod +x ./operations.sh`
 
 `sudo ./operations.sh`
 
Copiez dans la VM "wildfly-master" le répertoire "./master" , et exécutez les commandes:

 `cd ./master`
 
 `sudo chmod +x ./operations.sh`
 
 `sudo ./operations.sh`


### 2. Déploiement des applications Jee dans le cluster
 
 ...TODO....
 
Lorsque vous avez terrminé les opérations, 3 applications exemple peuvent être déployées dans le cluster wildfly provisionnés. 
Pour déployer ces applications web exemples, un outil a été installé: un "pseudo-pipeline" réduit à un simple conteneur docker.
Exécutez 
* `sudo docker ps -a` :  vous constaterez qu'un conteneur  nommé "`oleoduc`" est "UP'N RUNNING". C'est notre "pseudo-pipeline".

Les applications jee exemple peuvent être déployées de la manière suivante, à l'aide de ce "pseudo-pipeline":

* `sudo docker exec -it oleoduc /deployer-appli-exemple-1` :  pour déployer l'application exemple no.1
* `sudo docker exec -it oleoduc /deployer-appli-exemple-2` :  pour déployer l'application exemple no.2
* `sudo docker exec -it oleoduc /deployer-appli-exemple-3` :  pour déployer l'application exemple no.3
* `sudo docker exec -it oleoduc /deployer-appli-web-jee /chemin/vers/le/fichier/une-appli-que-vous-developpez.war` :  pour déployer un module jee web que vous développez
* `sudo docker exec -it oleoduc /deployer-appli-web-jee /chemin/vers/le/fichier/une-appli-que-vous-developpez.ear` :  pour déployer un module jee "d'entreprise" que vous développez
* `sudo docker exec -it oleoduc /deployer-appli-web-jee /chemin/vers/le/fichier/une-appli-que-vous-developpez.jar` :  pour déployer un composant java (que vous développez, ou non, ex. un driver JDBC) en tant que module dans wildfly

Ce "pseudo-pipeline" contient l'outillage: curl, git, jdk8 et maven, aussi les applications que vous
développerez et/ou modifierez, sont déployables dans le cluster avec le plugin maven ["wildfly-maven-plugin"](https://docs.jboss.org/wildfly/plugins/maven/latest/)
Notons que le côté intéressant du le plugin maven ["wildfly-maven-plugin"](https://docs.jboss.org/wildfly/plugins/maven/latest/), est à la fois sa
nature de plugin (modulaire), et le fait qu'il constitue un packaging possible pour utiliser le client "jboss-cli" en "standalone":
Sous cette forme il est possible d'utiliser le client jboss-cli indépendamment de tout autre, on peut l'tuilsier "seul" (ou presque, il y a MAVEN).
Ce qui le rends très agile, ou tout du moins au plus, aussi agile que la moins agile de ses dépendances. La seule dépendance étant MAVEN3, on peut considérer que 
ce composant est une distribution du client "jboss-cli" aussi agile que MAVEN3. (Si le client jboss-cli dégradait significativement l'agilité de MAVEN3, cela se
serait remarqué...).



# V. Testez votre Cluster
 
 ...TODO....
 la distribution fournira un petit outillage permettant d'exécuter et visualiser les résultats de tests:
 * D'abord élémentaires 
 * Puis intégrés dans une usine logicielle (avec du Jenkins, ELK, JMeter)
 
# ANNEXE: référence structure du repo

* system-setup.sh: Ce script n'est pas exécuté par la recette. Il s'agit du script de tests des instructions données dans le paragraphe "3. Vérifiez que vos 2 VMs ont accès au réseau." 
* master/resolution-dependances.sh: ce script exécute la résolution des dépendances de la recette d'installation dans la VM qui contiendra l'insatance wildfly "maître", dans le cluster.
* slave/resolution-dependances.sh: ce script exécute la résolution des dépendances de la recette d'installation dans la VM qui contiendra l'insatance wildfly "esclave", dans le cluster.
* master/operations.sh: ce script exécute les opérations dans la VM "wildfly-master"
* slave/operations.sh: ce script exécute la résolution des dépendances de la recette d'installation dans la VM qui contiendra l'insatance wildfly "esclave", dans le cluster.
* deploiement-appli/

# ANNEXE: Dépendances

## Meta dépendances 
(les opérations pourraient provisionner exactement le même résultat au byte prêt, tout en utilisant des alternatives aux méta dépendances):
* me, myself, and I: le repo github de cette recette (je dépends de moi-même.../réflexivité)
* docker-ce
* unzip

## Dépendances:

### de cette recette
* L'archive [zip d'installation de wildfly](http://download.jboss.org/wildfly/11.0.0.Final/wildfly-11.0.0.Final.zip).
* l'[image docker du conteneur mariaDB](https://hub.docker.com/_/mariadb/) qui sera utilisé pour exploiter la base de données.

### des déploiements jee
* le driver jdbc à déployer dans le cluster jee.
* l'application exemple no.1 à déployer (sera très proche de [l'application versionnée par ce repo](https://github.com/Jean-Baptiste-Lasselle/lauriane-deployeur-test) )



