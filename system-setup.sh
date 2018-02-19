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
# 
# 
# ...
# ----------------------------------------------------------

############################################################
############################################################
# 
# Ce script:
#  => fait la configuration réseau,
#  => installe OPENSSH-SERVER et fait les
#     mises à jour système 
#      
############################################################
############################################################

############################################################
############################################################
#														   #
#					exécution des opérations			   #
#														   #
############################################################
############################################################

############################################################
# à l'issue de l'installation de centos7, j'ai, pour ma
# part, avec une VM virtualbox dont la carte réseau est
# en "Accès par pont" ("Bridged Network"), un fichier
# d'interface réseau linux dont le paramètre :
# 
# ONBOOT=no
# 
# a la valeur "no". Il faut passer cette valeur à "yes", pour
# obtenir uen réponse DHCP de ma box, à la maison....
#
# Si dans votre cas, cette valeur est à "yes" dès l'issue de
# l'installation, cette opération n'impactera pas votre système.
# 
# 
# 
# 
# 
# On remplace la chaîne de caractères "ONBOOT=no" par la chaîne de
# caractères  "ONBOOT=yes"
sudo sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3
# for i in {1..255}
# do
   # echo " reconfig enp0s$i ..." >> system-setup.log
   # sudo sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-enp0s$i
# done

# Puis on re-démarre le service réseau 
sudo systemctl restart network

# updates/upgrades
sudo yum update -y && sudo yum upgrade -y && sudo yum update -y && sudo yum clean all

# installation openssh-server
sudo yum install -y openssh-server

