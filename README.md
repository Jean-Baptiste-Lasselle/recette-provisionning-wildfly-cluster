# Résumé

Ce repo est une recette d'installation / configuration pour mettre en place un cluster jee, avec [wildfly](http://wildfly.org/).

En vous guidant de cette page de documentation, vous crééerez 2 machines virtuelles, exécuterez
des opératiosn sur ces 2 VMs en vous guidant avec cette page de documentation, et obtiendrez:
* dans une VM, le "master" du cluster wildfly 
* dans l'autre VM, le "slave" du cluster wildfly, docker, et un seul conteneur docker contenant mariaDB.
* toutes les instances d'applications web, qu'elles soient dans une VM ou l'autre, accèderont à une unique instance de BDD, dans le conteneur mariaDB de la VM contenant le "slave".

# IMPORTANT
Ce repo n'est pas encore (19/02/2018) utilisable:
* Le repo est en cours de développement
* la doc que vous lisez et l'état du repo ne sont pas encore synchrones

# Comment utilsier ce repo?

## I. créez 2 VM 

J'ai appelé, et appelerai dans toute la docuemntation présente dans ce repo:
* "wildfly-master": la première VM, dans laquelle nous installerons et configurerons l'insztance wildfly  maître du cluster
* "wildfly-slave": la première VM, dans laquelle nous installerons et configurerons une instance wildfly esclave du cluster

### Ma configuration de travail pour les tests.

J'ai simplement utilisé VirtualBox sur un PC 16 Go RAM. Notons ma machien "PCtravail".
"PCtravail" est branché à un switch, et le switch est directement branché à ma box.
"PCtravail" est configuré en DHCP.

Ayant fait cela, et étant donné que mon PC "PCtravail" est branché directement à ma box, c'est
ma box qui fait office de serveur DHCP, et attribue donc une configuration IP à "PCtravail".

Dans cette situation, une VM créée avec VirtualBox dans "PCtravail", avec une
carte réseau en "Accès par pont", pourra se voir aussi attribuer une configuration IP par ma box:
Une telle VM est comme elle même physiquement branchée à ma box.
C'est un peu comme si "PCtravail" et la MV étaient totue deux branchée à un switch, et le switch branché à ma box

### Configuration hardware à apppliquer

Pour chaque VM, il vous faudra au moins une carte réseau virtuelle, configurée en mode "Accès par pont" ("Bridged Network", pour les installations anglophones).

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
* On déploie une première application Jee dans le cluster: Cette application est uen application Web simple, et on vérifiera avec l'admin wildfly web que l'application a bien été déployée à la fois dans la VM "wildfly-master" et dans la VM "wildfly-slave". On vérifiera le bon fonctionneement de cette application, qui a un fonctionneemtn minimal: la page par défaut de cette applicationa ffiche les données insérées préalablement dans une BDD. Le test consistera à charger l'application une première fois, insérer des données avec un script SQL, puis charger à nouveau l'application et constater l'afficahge correct sans erreurs ou exception, des données avant et après insertion.
* [Bientôt dans ce tutoriel] On déploie une deuxième application Web Jee dans le cluster: cette application est simple, fait usage de sessions HTTP, de sessions Hibernate, et on vérifie la réplication InfiniSpan des sessions HTTP et Hibernate en lançant un deuxième "slave", pour le tuer en pleine exécution. L'application est basée sur une auth classique email/pwd, et un panier de shopping stockée session HTTP.
* [Bientôt dans ce tutoriel] On déploie une troisième application Web Jee dans le cluster: cette application est simple, fait usage de sessions HTTP, de sessions Hibernate, mais surtout aussi de sessions EJB Stateful Session Bean ("SFSB's"), on fait les vérificatiosn de réplication InfiniSpan
* [Bientôt dans ce tutoriel] Les deux cas précédents ont permis de tester le "fail-over". Un dernier volet de ce tutoriel consistera à arriver à déclencher le load balancing dans le cas d'un cluster à 1 maître/ 2 esclaves. On utilisera JMeter pour fournir la charge. Et on utilisera l'utilitaire "VBoxManage": `VBoxManage modifyvm "wildfly-slave2" --nictrace1 on --nictracefile1 log-reseau-wildfly-slave-a-lire-ac-wireshark.pcap` pour constater le load balancing dans les trames réseau. 

### 1. Exécution des opérations dans les VMs

Copier dans la VM "wildfly-slave" le répertoire "./slave" , et exécutez les commandes:
 `# resp. "cd ./master"...`
 `cd +x ./slave`
 `sudo chmod +x ./operations.sh`
 `sudo ./operations.sh`
 
Copier dans la VM "wildfly-master" le répertoire "./slave" , et exécutez les commandes:
 `cd +x ./master`
 `sudo chmod +x ./operations.sh`
 `sudo ./operations.sh`


### 2. Déploiement des applications Jee dans le cluster
 
 ...TODO....
 
 https://github.com/Jean-Baptiste-Lasselle/lauriane-deployeur-test

Lorsque vous avez terrminé les opérations, 3 applications exemple peuvent être déployées dans le cluster wildfly provisionnés. 
Pour déployer ces applications web exemples, un outil a été installé: un "pseudo-pipeline" réduit à un simple conteneur docker.
Exécutez 
* `sudo docker ps -a` :  vous constaterez qu'un conteneur  nommé "pipelinetocluster" est "UP'N RUNNING". C'est notre "pseudo-pipeline".

Les applications jee exemple peuvent être déployées de la manière suivante, à l'aide de ce "pseudo-pipeline":

* `sudo docker exec -it pipeline /deployer-appli-exemple-1` :  pour déployer lapplication exemple no.1
* `sudo docker exec -it pipeline /deployer-appli-exemple-2` :  pour déployer lapplication exemple no.2
* `sudo docker exec -it pipeline /deployer-appli-exemple-3` :  pour déployer lapplication exemple no.3

Ce "pseudo-pipeline" contient l'outillage: curl, git, jdk8 et maven, aussi les applications que vous
développerez et/ou modifierez, sont déployables dans le cluster avec le plugin maven ["wildfly-maven-plugin"](https://docs.jboss.org/wildfly/plugins/maven/latest/)


 
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
* http://download.jboss.org/wildfly/11.0.0.Final/wildfly-11.0.0.Final.zip
* l'image docker du conteneur mariaDB qui sera utilisé pour exploiter la base de données.
* le driver jdbc à déployer dans le cluster jee.
* l'applicatione exemple à déployer (cf. repo [https://github.com/Jean-Baptiste-Lasselle/lauriane-deployeur-test)



