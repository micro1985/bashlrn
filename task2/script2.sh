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

#sudo sed -i "/\# Server=/d" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/# Server=/c Server=192.168.40.161" /etc/zabbix/zabbix_agentd.conf
#sudo sed -i "/\# ServerActive=/d" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/# ServerActive=/c ServerActive=192.168.40.161" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/\# Hostname=/d" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/Hostname=/c Hostname=Client" /etc/zabbix/zabbix_agentd.conf

sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent
