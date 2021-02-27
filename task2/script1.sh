#!/bin/bash

sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum-config-manager --enable rhel-7-server-optional-rpms
sudo yum install zabbix-server-mysql zabbix-web-mysql mariadb-server -y

sudo systemctl start mariadb
sudo systemctl enable mariadb

cat << EOF | sudo mysql_secure_installation

n
y
y
y
y
EOF

sudo mysql -u root -e "create database zabbix character set utf8 collate utf8_bin;"
sudo mysql -u root -e "create user 'zabbix'@'localhost' identified by '123456';"
sudo mysql -u root -e "grant all privileges on zabbix.* to 'zabbix'@'localhost';"

sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | sudo mysql -u zabbix --password=123456 zabbix

sudo sed -i "/\# DBHost=/c DBHost=localhost" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBHost=/c DBHost=localhost" /etc/zabbix/zabbix_server.conf   #for universality
sudo sed -i "/\# DBName=/d" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBName=/c DBName=zabbix" /etc/zabbix/zabbix_server.conf
sudo sed -i "/\# DBUser=/d" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBUser=/c DBUser=zabbix" /etc/zabbix/zabbix_server.conf
sudo sed -i "/\# DBPassword=/c DBPassword=123456" /etc/zabbix/zabbix_server.conf
sudo sed -i "/DBPassword=/c DBPassword=123456" /etc/zabbix/zabbix_server.conf

sudo systemctl start zabbix-server httpd
sudo systemctl enable zabbix-server httpd
