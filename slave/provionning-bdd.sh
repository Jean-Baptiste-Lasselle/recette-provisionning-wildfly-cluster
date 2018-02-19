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
#  => installe docker
#    
############################################################
############################################################
#    
# Ce script est appelé par l'opérateur.
# 
export MAISON_OPERATIONS=`pwd`
export MAISON_DEPENDANCES=$MAISON_OPERATIONS/dependances
export MAISON_INSTALL_WILDFLY=/opt/serveurjee
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
# ===>> peut donner lieu à un passage de paramètres ...
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

# résolution des dépendances
./resolution-dependances.sh
# On dézippe  l'archive d'installation de wildfly, dans le répertoire destiné
unzip $MAISON_DEPENDANCES/wildfly-$VERSION_WILDFLY.zip -d $MAISON_INSTALL_WILDFLY

# TODO...: la suite des opérations
# nettoyage
sudo rm -f ./nettoyage.sh
echo "sudo yum remove -y unzip" >> ./nettoyage.sh
echo "sudo yum clean all" >> ./nettoyage.sh
sudo chmod +x ./nettoyage.sh
./nettoyage.sh

echo " ------------------------------------- "
echo " -- PROVISIONNING WILDFLY SLAVE 1:     "
echo " -- TERMINEE "
echo " ------------------------------------- "
echo " ccc: "
echo " => cccc "
echo " => cccc "
echo " => cccc "
echo " => cccc "
echo " ------------------------------------- "
