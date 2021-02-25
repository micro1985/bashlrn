#!/bin/bash

osname=`hostname`

f_server_install()
{
	sudo yum install nfs-utils nfs-utils-lib
	sudo systemctl enable rpcbind
	sudo systemctl enable nfs-server
	systemctl start rpcbind
	systemctl start nfs-server

	sudo mkdir /home/user/nfsbckp
	sudo chmod -R 777 /home/user/nfsbckp

	echo "/home/user/nfsbckp 192.168.40.0/24 (rw,sync,no_root_squash,no_all_squash)" | sudo tee -a /etc/exports

	sudo exports -a
	sudo systemctl restart nfs-server
}


if [ "${osname}" == "server" ]; then
	echo ${osname}
	f_server_install
elif [ "${osname}" == "client" ]; then
	echo ${osname}
fi

