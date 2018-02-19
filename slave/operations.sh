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
#  => dézipppe l'archive d'installation de wildfly
#  => ... 
#    
############################################################
############################################################
#    
# Ce script est appelé par l'opérateur.
# 
export MAISON_OPERATIONS=`pwd`
export MAISON_DEPENDANCES=$MAISON_OPERATIONS/dependances
export MAISON_INSTALL_WILDFLY=/opt/serveurjee
export VERSION_MARIADB=10.3


############################################################
# TODO:
# faire un nouveau repo github pour les applis exemples.
# Je clonerai, builderai  à la volée, sans usine classique.

# l'URL du repo 
export URL_REPO_APPLIS_EXEMPLE=https://github.com/Jean-Baptiste-Lasselle/lauriane-deployeur-test
#
# Un repo et un tag par appli exemple
#
export GIT_TAG_APPLI1=app-ac-session-hibernate
export GIT_TAG_APPLI2=app-ac-session-http-hibernate
export GIT_TAG_APPLI3=app-ac-session-http-EJB-hibernate

# Pour résoudre les dépendances:
# git clone $URL_REPO_APPLIS_EXEMPLE
# git checkout tags/$GIT_TAG_APPLI1
# git checkout tags/$GIT_TAG_APPLI2
# git checkout tags/$GIT_TAG_APPLI3

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
sudo chmod +x ./*.sh
############################################################
############################################################


############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################




# 1./ résolution des dépendances (docker y est installé)
./resolution-dependances.sh




# 2./  On fait le setup de l'instance eslcave wildfly
# On dézippe  l'archive d'installation de wildfly, dans le répertoire destiné
unzip $MAISON_DEPENDANCES/wildfly-$VERSION_WILDFLY.zip -d $MAISON_INSTALL_WILDFLY

# TODO...: la suite et fin des opérations install / setup "slave"

# 3./ On provisionne le conteneur docker qui contient la BDD mariadDB
#     (le docker pull de l'image [mariadb:$VERSION_MARIADB] a déjà
#      été fait au cours de la résolution de dépendances)
#
# TODO: .... sudo docker run -it ....
# TODO: exécuter le provisionning:
#    => d'une BDD "$NOMBDD", pour être utilisée par les applis web jee qui seront déployées
export NOMBDD=frenchontopbdd
#    => d'une table "$TABLE1", et y insérer des données, pour être utilisée par la première appli web déployée
export TABLE1=employes
#    => d'une table "$TABLE2", et ne pas y insérer de données, pour être utilisée par les autres applis web déployée, pour les tests 
export TABLE2=clients
# 
# => le modèle habituel pour réaliser uen opération BDD:
# 
# # création d'un répertoire "mkdir nos-operationsbdd", pour les opérations dans le conteneur
# docker exec -it $NOM_ONTENEUR_MARIADB /bin/bash -c "mkdir nos-operationsbdd"
# # copie du fichier SQL et sh à exécuter dans le conteneur:
# docker cp /chemin/vers/mon/operationbddexemple.sh $NOM_ONTENEUR_MARIADB:/nos-operationsbdd
# docker cp /chemin/vers/mon/operationbddexemple.sql $NOM_ONTENEUR_MARIADB:/nos-operationsbdd
# # exécution:
# docker exec -it $NOM_ONTENEUR_MARIADB /bin/bash -c "chmod +x nos-operationsbdd/operationbddexemple.sh"
# docker exec -it $NOM_ONTENEUR_MARIADB /bin/bash -c "nos-operationsbdd/operationbddexemple.sh"


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
echo " Ont été provisionnés: "
echo " => L'instance esclave du cluster Wildfly. "
echo " => Un conteneur docker MariaDB, l'instance MariaDB tournatn dans le conteneur: "
echo " ==============> contient une base de données $NOMBDD "
echo " ==============> la base de données $NOMBDD contient une table $TABLE1, contenant des données utilisées par la première appli web exemple [git clone $URL_REPO_APPLI_EXEMPLE1] "
echo " ==============> la base de données $NOMBDD contient une table $TABLE2, utilisée par les deux autres applications exemples."
echo " ==============> le code source des applications exemples peut être obtenu en exécutant les comamndes:"
echo " ==============>    git clone $URL_REPO_APPLIS_EXEMPLE"
echo " ==============>    git checkout tags/$GIT_TAG_APPLI1"
echo " ==============>    git checkout tags/$GIT_TAG_APPLI2"
echo " ==============>    git checkout tags/$GIT_TAG_APPLI3"
echo " => "
echo " ------------------------------------- "
