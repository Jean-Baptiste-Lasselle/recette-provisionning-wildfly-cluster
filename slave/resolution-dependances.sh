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
# Ce script est appelé par le script "slave/operations.sh",
# et dans "slave/operations.sh" les variables
# d'environnement exportées sont:
# 
#  => export MAISON_OPERATIONS=`pwd`
#  => export MAISON_DEPENDANCES=$MAISON_OPERATIONS/dependances
#  => export MAISON_INSTALL_WILDFLY=/opt/serveurjee
#  => export VERSION_MARIADB=10.3
# 
# 
# 
# 
############################################################
############################################################    
# ENV.
######
# 
VERSION_WILDFLY=11.0.0.Final
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

# On télécharge l'archive d'installation de wildfly

cd $MAISON_OPERATIONS
curl -O http://download.jboss.org/wildfly/$VERSION_WILDFLY/wildfly-$VERSION_WILDFLY.zip
mv wildfly-$VERSION_WILDFLY.zip $MAISON_DEPENDANCES


# Pour installer mariaDB: on fera un conteneur docker, pour le gérer vraiment plus souplement cf."./provisionning-bdd.sh"
# 1./ installation docker
./installation docker.sh
# 2./ on télécharge l'umage mariaDB voulue, localement
docker pull mariadb:$VERSION_MARIADB


echo " ------------------------------------- "
echo " -- RESOLUTION DS DEPENDANCES TERMINEE "
echo " ------------------------------------- "
echo " dépendances résolues avec succès: "
echo " => [$MAISON_DEPENDANCES/wildfly-$VERSION_WILDFLY.zip] "
echo " => [$MAISON_DEPENDANCES/cc] "
echo " ------------------------------------- "
