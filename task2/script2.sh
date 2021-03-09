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

sudo yum install zabbix-agent -y

echo "Packages installed"

###Configuring zabbix agent config file

sudo sed -i "/Server=127.0.0.1/d" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/\# Server=/c Server=172.16.123.10" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/ServerActive=127.0.0.1/d" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/\# ServerActive=/c ServerActive=172.16.123.10" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/\# Hostname=/d" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "/Hostname=/c Hostname=Client" /etc/zabbix/zabbix_agentd.conf

echo "Zabbix agent configured"

###Disabling SELinux

sudo sed -i "/SELINUX=enforcing/c SELINUX=disabled" /etc/selinux/config
sudo setenforce 0

echo "SELinux disabled"

###Starting zabbix

sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent
