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
# Ce script est appelé par le script "slave/operations.sh"
# 


############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################

# -----------------------------------------------------------------------------------------------------------------------
# installations bare-metal
# -----------------------------------------------------------------------------------------------------------------------
#
# sudo yum clean all -y && sudo yum update -y
sudo yum install -y wget
sudo rm -f index.html
sudo rm -f installation-docker-ce-not-production-env.sh
sudo wget https://get.docker.com/
sudo cp index.html installation-docker-ce-not-production-env.sh
sudo rm -f index.html
sudo yum --enablerepo=extras install -y epel-release
sudo yum update -y && sudo yum clean all -y && sudo yum update -y
sudo chmod +x installation-docker-ce-not-production-env.sh
sudo ./installation-docker-ce-not-production-env.sh
sudo usermod -aG docker $USER
# 
sudo systemctl enable docker
sudo systemctl start docker

# TODO : La clé publique pour docker-ce-17.11.0.ce-1.el7.centos.x86_64.rpm est à vérifier...
# nettoyage
sudo rm -f ./nettoyage.sh
echo "sudo yum remove -y wget" >> ./nettoyage.sh
echo "sudo yum clean all" >> ./nettoyage.sh
sudo chmod +x ./nettoyage.sh
./nettoyage.sh
sudo rm -f ./nettoyage.sh

echo " ------------------------------------- "
echo " -- PROVISIONNING DOCKER1:     "
echo " -- TERMINEE "
echo " ------------------------------------- "
echo " ccc: "
echo " => cccc "
echo " => cccc "
echo " => cccc "
echo " => cccc "
echo " ------------------------------------- "
