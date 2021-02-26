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

sudo mysql -u root -e "CREATE DATABASE zabbix character set utf8 collate utf8_bin;"
sudo mysql -u root -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '123456';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | sudo mysql -u zabbix -p=123456 -D=zabbix
