#!/bin/bash

date=`date '+%Y%m%d%H%M%S'`
filename=backup_$date

sudo tar -czvf $filename.tar.gz /root /home
sudo cp $filename.tar.gz /home/user/backup
sudo rm $filename.tar.gz
