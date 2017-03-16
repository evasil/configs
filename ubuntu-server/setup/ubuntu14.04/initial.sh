#!/bin/bash

apt-get update -y
apt-get upgrade -y


#System
apt-get install haveged prelink preload aptitude htop mc iptraf iotop tcpdump iptables-persistent mtr-tiny software-properties-common git unzip dos2unix -y


#PHP-FPM

apt-get install php5-fpm php5-gd php5-curl php5-xmlrpc -y


# Percona

cd /root
wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb

apt-get update

apt-get install percona-server-server-5.7


# MysqlTuner

cd /root
wget http://mysqltuner.pl/ -O mysqltuner.pl
wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt
wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv



