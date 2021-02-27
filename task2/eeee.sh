#!/bin/bash

cheeck=`sudo yum list installed | grep zabbix`

echo ${cheeck}

if [ "${cheeck}" != "" ]; then
        echo "Zabbix is already installed"
        exit
elif [ "${cheeck}" == "" ]; then
	echo "22222222222222222222222222"
fi
