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
#  => télécharge le zip d'installation de wildfly
#     du site oficiel
#  => ... 
#    
############################################################
############################################################
#    
# Ce script est appelé par le script "master/operations.sh",
# et dans "master/operations.sh" les variables
# d'environnement exportées sont:
# 
#  => export MAISON_OPERATIONS=`pwd`
#  => export MAISON_DEPENDANCES=$MAISON_OPERATIONS/dependances
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
VERSION_WILDFLY=11.0.0.Final
VERSION_MARIADB_JDBC=2.2.1
WILDFLY_ZIP_FILENAME=wildfly-$VERSION_WILDFLY.zip
MARIADB_JDBC_DRIVER_FILENAME=mariadb-java-client-$VERSION_MARIADB_JDBC.jar
WHERE_TO_PULL_FROM_WILDFLY_ZIP=http://download.jboss.org/wildfly/$VERSION_WILDFLY/$WILDFLY_ZIP_FILENAME
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
####	dépendances provisionning.
############################################################

# On télécharge l'archive d'installation de wildfly
curl -O $WHERE_TO_PULL_FROM_WILDFLY_ZIP >> ./$WILDFLY_ZIP_FILENAME
mv $WILDFLY_ZIP_FILENAME $MAISON_DEPENDANCES


# Pour la BDD, mariaDB est installé dans la VM "wildfly-slave".










clear
echo " ------------------------------------- "
echo " -- RESOLUTION DS DEPENDANCES TERMINEE "
echo " ------------------------------------- "
echo " dépendances résolues avec succès: "
echo " => [$MAISON_DEPENDANCES/wildfly-$VERSION_WILDFLY.zip] "
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
