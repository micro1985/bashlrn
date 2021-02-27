#!/bin/bash

###Checking for installed Zabbix

cheeck=`sudo yum list installed | grep zabbix`

if [ "${cheeck}" != "" ]; then
        echo "Zabbix is already installed"
        exit
fi

sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum-config-manager --enable rhel-7-server-optional-rpms

sudo yum install zabbix-agent -y
sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent
