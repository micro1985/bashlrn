#!/bin/bash

###Checking for installed Zabbix

cheeck=`sudo yum list installed | grep zabbix`

if [ "${cheeck}" != "" ]; then
	echo "Zabbix is already installed"
	exit
fi

###Installing packages

sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum-config-manager --enable rhel-7-server-optional-rpms
sudo yum install zabbix-server-mysql zabbix-web-mysql mariadb-server httpd httpd-devel php php-devel php-bcmath php-pear php-gd php-mbstring php-mysql php-xml  -y

echo "Packages installed"

###Configurinf DB

sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "DB started and autorunned"

cat << EOF | sudo mysql_secure_installation

n
y
y
y
y
EOF

###Generating temp pass for DB

python $PWD/pass.py
passdb=`cat $PWD/psswd`

sudo mysql -u root -e "create database zabbix character set utf8 collate utf8_bin;"
sudo mysql -u root -e "create user 'zabbix'@'localhost' identified by '$passdb';"
sudo mysql -u root -e "grant all privileges on zabbix.* to 'zabbix'@'localhost';"

echo "DB configured"

###Importing data

sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | sudo mysql -u zabbix --password=123456 zabbix

echo "Zabbix server config imported to DB"

###Disabling SELinux

sudo sed -i "/SELINUX=enforcing/c SELINUX=disabled" /etc/selinux/config
sudo setenforce 0

echo "SELinux disabled"

###Configuring zabbix config file

sudo sed -i "/\# DBHost=/c DBHost=localhost" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBHost=/c DBHost=localhost" /etc/zabbix/zabbix_server.conf   #for universality
sudo sed -i "/\# DBName=/d" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBName=/c DBName=zabbix" /etc/zabbix/zabbix_server.conf
sudo sed -i "/\# DBUser=/d" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBUser=/c DBUser=zabbix" /etc/zabbix/zabbix_server.conf
sudo sed -i "/\# DBPassword=/c DBPassword=$passdb" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBPassword=/c DBPassword=$passdb" /etc/zabbix/zabbix_server.conf

echo "Zabbix configured"

###Configuring Zabbix conf for Apache

sudo sed -i "/\# php_value date.timezone/c \ \ \ \ \ \ \ \ php_value date.timezone Europe/Minsk" /etc/httpd/conf.d/zabbix.conf

echo "Apache configured for Zabbix"

###Starting zabbix

sudo systemctl start zabbix-server httpd
sudo systemctl enable zabbix-server httpd

echo "Zabbix started and autorunned"

echo "Temp pass for DB is $passdb"
rm $PWD/psswd
