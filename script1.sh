#!/bin/bash

osname=`hostname`

f_server_install()
{
	sudo yum install nfs-utils nfs-utils-lib -y
	sudo systemctl enable rpcbind
	sudo systemctl enable nfs-server
	systemctl start rpcbind
	systemctl start nfs-server

	sudo mkdir /home/user/nfsbckp
	sudo chown -R nfsnobody:nfsnobody /home/user/nfsbckp
	sudo chmod -R 777 /home/user/nfsbckp

	echo "/home/user/nfsbckp 192.168.40.0/24 (rw,sync,no_root_squash,all_squash)" | sudo tee /etc/exports

	sudo exportfs -a
	sudo systemctl restart nfs-server
}

f_client_install()
{
	sudo yum install nfs-utils -y
        sudo systemctl enable rpcbind
        sudo systemctl enable nfs-server
        systemctl start rpcbind
        systemctl start nfs-server

	sudo mkdir /home/user/backup
	sudomount -t nfs 192.168.40.161:/home/user/nfsbckp/ /home/user/backup
}

if [ "${osname}" == "server" ]; then
	echo ${osname}
	f_server_install
elif [ "${osname}" == "client" ]; then
	echo ${osname}
	f_client_install
fi

