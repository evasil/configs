##First steps after install

`apt-get update -y`
`apt-get upgrade -y`


#System utilities

`apt-get install haveged prelink preload aptitude htop mc iptraf iotop tcpdump iptables-persistent mtr-tiny software-properties-common git unzip dos2unix ncdu -y`

#Some building stuff if you need to compile your software

`apt-get install build-essential checkinstall`

#PHP-FPM

Add more modules if needed

`apt-get install php5-fpm php5-gd php5-curl php5-xmlrpc -y`


#Percona

```
cd /root
wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
```

`apt-get update`

`apt-get install percona-server-server-5.7`


#MysqlTuner

```
cd /root
wget http://mysqltuner.pl/ -O mysqltuner.pl
wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt
wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv
```

#Nginx

First check the latest stable version

```
cd /somedir/installs
wget http://nginx.org/download/nginx-1.10.3.tar.gz
tar -xf nginx-1.10.3.tar.gz
```
Then use build scripts from the file 


