#!/bin/bash
############################################################
############################################################
# 					Compatibilité système		 		   #
############################################################
############################################################

# ----------------------------------------------------------
# [Pour Comparer votre version d'OS à
#  celles mentionnées ci-dessous]
# 
# ¤ distributions Ubuntu:
#		lsb_release -a
#
# ¤ distributions CentOS:
# 		cat /etc/redhat-release
# 
# 
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------------------------------------------------------
# ----------------------------------------------------------
# testé pour:
# 
# 
# 
# 
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [NOT-TESTED]
#
# 	[Distribution ID: 	Ubuntu]
# 	[Description: 		Ubuntu 16.04 LTS]
# 	[Release: 			16.04]
# 	[codename:			xenial]
# 
# 
# 
# 
# 
# 
# ----------------------------------------------------------
# (CentOS)
# ----------------------------------------------------------
# 
# ¤ [TEST-KO]
# 
#   [CentOS Linux release 7.4.1708 (Core)]
# 
# 
# ----------------------------------------------------------

############################################################
############################################################
# 
# Ce script:
#  => télécharge lecode source de l'application exemple 1
#  => installe maven
#  => fait le build maven de l'application
#  => et la déploie dans le cluster
#  => ... 
#  => ... 
#    
############################################################
############################################################
#    
# Ce script est appelé par le script "master/operations.sh",
# et dans "master/operations.sh" les variables
# d'environnement exportées sont:
# 
export MAISON_OPERATIONS=`pwd`
export MAISON_DEPENDANCES=$MAISON_OPERATIONS/dependances
#  => export MAISON_INSTALL_WILDFLY=/opt/serveurjee
#  => export VERSION_MARIADB=10.3
# 
# Repo applis exemple:
#
#  => export URL_REPO_APPLIS_EXEMPLE=https://github.com/Jean-Baptiste-Lasselle/lauriane-deployeur-test
#  => export GIT_TAG_APPLI1=app-ac-session-hibernate
#  => export GIT_TAG_APPLI2=app-ac-session-http-hibernate
#  => export GIT_TAG_APPLI3=app-ac-session-http-EJB-hibernate
# 
# 
# 
############################################################
############################################################    
# ENV.
######
# 
# VERSION_WILDFLY=11.0.0.Final
VERSION_MARIADB_JDBC=2.2.1
# WILDFLY_ZIP_FILENAME=wildfly-$VERSION_WILDFLY.zip
MARIADB_JDBC_DRIVER_FILENAME=mariadb-java-client-$VERSION_MARIADB_JDBC.jar
# WHERE_TO_PULL_FROM_WILDFLY_ZIP=http://download.jboss.org/wildfly/$VERSION_WILDFLY/$WILDFLY_ZIP_FILENAME
WHERE_TO_PULL_FROM_MARIADB_JDBC_DRIVER=https://downloads.mariadb.com/Connectors/java/connector-java-$VERSION_MARIADB_JDBC/$MARIADB_JDBC_DRIVER_FILENAME
# ===>> peut donenr lieu à un passage de paramètres ...
# ===>> peut aussi être remonté daans le niveau au-dessus
# 
# 
# 
############################################################
############################################################


############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################
cd $MAISON_OPERATIONS



############################################################
####	résolution des dépendances des déploiements jee
############################################################

# -- >> pkoi pas mettre tous ces utilitaires de build dans un conteneur docker qui sert juste à faire le build puis bye le conteneur et bye bye docker.

# -- git
sudo yum install -y git
# -- jdk8
sudo yum install -y java-1.8.0-openjdk
# -- maven >= 3
# src: https://tecadmin.net/install-apache-maven-on-centos/
MAVEN_VERSION=3.5.2
MAVEN_INSTARCHIVE_FILENAME=apache-maven-$MAVEN_VERSION-bin.tar.gz
MAVEN_INSTARCHIVE_URL=http://www-eu.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/$MAVEN_INSTARCHIVE_FILENAME
curl -O $MAVEN_INSTARCHIVE_URL >> ./$MAVEN_INSTARCHIVE_FILENAME
sudo mv ./$MAVEN_INSTARCHIVE_FILENAME /usr/local

cd /usr/local
sudo tar xzf $MAVEN_INSTARCHIVE_FILENAME
# la dé-compression a créée le répertoire "/usr/local/apache-maven-$MAVEN_VERSION"
# qui doit être utilisable par le user linux utilisé pour le déploiement
USR_LX_DEPLOYEUR=$USER
sudo chown $USR_LX_DEPLOYEUR /usr/local/apache-maven-$MAVEN_VERSION
# une petite option sympa d'adminstrateurs linux...:
#   le lien symbolique, permet qu'il y ait un répertoire "/usr/local/maven", et
# derrière il suffit de cahgner le lien symbolique pour gérer les versions:
sudo ln -s apache-maven-3.5.2  maven
# et on fait en sorte que la commande maven ait un raccourci pour 

echo "# jibjibl" >> /etc/profile.d/maven.sh
sudo /bin/bash -c "echo \"# ajouté par le comissioning appli-exemple 1 \" >>  /etc/profile.d/maven.sh "
sudo /bin/bash -c "echo \"export M2_HOME=/usr/local/maven\" >>  /etc/profile.d/maven.sh "
sudo /bin/bash -c "echo \"export PATH=${M2_HOME}/bin:${PATH}\" >>  /etc/profile.d/maven.sh "
echo "contenu de /etc/profile.d/maven.sh:" 
cat /etc/profile.d/maven.sh




cd $MAISON_OPERATIONS

# -- driver JDBC
# On télécharge le driver JDBC MariaDB:
# le déploiement des modules Web Jee se feront à partir du
# master, localement au master. Cette dépendance n'est donc 
# résolues que pour la VM "wildfly-master".
# c'est une dépendance au déploiemetn des applications




curl -O $WHERE_TO_PULL_FROM_MARIADB_JDBC_DRIVER >> ./$MARIADB_JDBC_DRIVER_FILENAME
mv $MARIADB_JDBC_DRIVER_FILENAME $MAISON_DEPENDANCES/exemples-deploiements-jee

# mkdir -p $MAISON_OPERATIONS/exemples-deploiements-jee/application-exemple-1
# mkdir -p $MAISON_OPERATIONS/exemples-deploiements-jee/application-exemple-2
# mkdir -p $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-3

# -- applis exemples
# installation maven et build...? ===>>>> dans les scripts de déploiements applicatifs [$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex*.sh]
# Pour résoudre les dépendances:
cd $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-1
git clone $URL_REPO_APPLIS_EXEMPLE
git checkout tags/$GIT_TAG_APPLI1
# TODO: build et déploiement avec jboss-cli -->> L'IP du master doit être demandée interactivement à l'utilisateur


# cd $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-2
# git clone $URL_REPO_APPLIS_EXEMPLE
# git checkout tags/$GIT_TAG_APPLI2
# # TODO: build et déploiement avec jboss-cli -->> L'IP du master doit être demandée interactivement à l'utilisateur
# cd $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-3
# git clone $URL_REPO_APPLIS_EXEMPLE
# git checkout tags/$GIT_TAG_APPLI3
# # TODO: build et déploiement avec jboss-cli -->> L'IP du master doit être demandée interactivement à l'utilisateur




































############################################################
####	dépendances provisionning.
############################################################

# On télécharge l'archive d'installation de wildfly
curl -O $WHERE_TO_PULL_FROM_WILDFLY_ZIP >> ./$WILDFLY_ZIP_FILENAME
mv $WILDFLY_ZIP_FILENAME $MAISON_DEPENDANCES


# Pour la BDD, mariaDB est installé dans la VM "wildfly-slave".



############################################################
####	dépendances futurs déploiements jee
############################################################

# -- driver JDBC
# On télécharge le driver JDBC MariaDB:
# le déploiement des modules Web Jee se feront à partir du
# master, localement au master. Cette dépendance n'est donc 
# résolues que pour la VM "wildfly-master".
# c'est une dépendance au déploiemetn des applications


# mkdir -p $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-1
# mkdir -p $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-2
# mkdir -p $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-3

curl -O $WHERE_TO_PULL_FROM_MARIADB_JDBC_DRIVER >> ./$MARIADB_JDBC_DRIVER_FILENAME

mv $MARIADB_JDBC_DRIVER_FILENAME $MAISON_DEPENDANCES/exemples-deploiements-jee


# -- applis exemples
# installation maven et build...? ===>>>> dans les scripts de déploiements applicatifs [$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex*.sh]
# Pour résoudre les dépendances:
cd $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-1
git clone $URL_REPO_APPLIS_EXEMPLE
git checkout tags/$GIT_TAG_APPLI1
# TODO: build et génération du fichier [$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex1.sh]
cd $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-2
git clone $URL_REPO_APPLIS_EXEMPLE
git checkout tags/$GIT_TAG_APPLI2
# TODO: build et génération du fichier [$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex2.sh]
cd $MAISON_DEPENDANCES/exemples-deploiements-jee/application-exemple-3
git clone $URL_REPO_APPLIS_EXEMPLE
git checkout tags/$GIT_TAG_APPLI3
# TODO: build et génération du fichier [$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex3.sh]






clear
echo " ------------------------------------- "
echo " -- RESOLUTION DS DEPENDANCES TERMINEE "
echo " ------------------------------------- "
echo " dépendances résolues avec succès: "
echo " => [$MAISON_DEPENDANCES/wildfly-$VERSION_WILDFLY.zip] "
echo " => [$MAISON_DEPENDANCES/exemples-deploiements-jee]: le drivers JDBC nécessaires aux déploiements des applicatiosn web exemples fournies"
echo " => [[$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex1.sh]]: un script qui permet de builder et deployer une application web jee exemple, localement depuis le master du cluster."
echo " => [[$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex2.sh]]: un script qui permet de builder et deployer une application web jee exemple, localement depuis le master du cluster."
echo " => [[$MAISON_DEPENDANCES/exemples-deploiements-jee/deploiement-appli-ex3.sh]]: un script qui permet de builder et deployer une application web jee exemple, localement depuis le master du cluster."
echo " ------------------------------------- "

rm -f $MAISON_OPERATIONS/resolution-dependances.log
echo " ------------------------------------- " >> $MAISON_OPERATIONS/resolution-dependances.log
echo " -- RESOLUTION DS DEPENDANCES TERMINEE " >> $MAISON_OPERATIONS/resolution-dependances.log
echo " ------------------------------------- " >> $MAISON_OPERATIONS/resolution-dependances.log
echo " dépendances résolues avec succès: " >> $MAISON_OPERATIONS/resolution-dependances.log
echo " => [$MAISON_DEPENDANCES/wildfly-$VERSION_WILDFLY.zip] " >> $MAISON_OPERATIONS/resolution-dependances.log
echo " => [$MAISON_DEPENDANCES/exemples-deploiements-jee]: contient notamment les drivers JDBC nécessaires aux déploiements des applicatiosn web exemples fournies" >> $MAISON_OPERATIONS/resolution-dependances.log
echo " ------------------------------------- " >> $MAISON_OPERATIONS/resolution-dependances.log
