#!/bin/bash

sudo yum update -y

sudo yum install httpd zip -y
sudo systemctl start httpd
sudo systemctl enable httpd

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager -y --enable remi-php72
sudo yum update -y
sudo yum -y install php php-fpm php-gd php-mysql

echo "Enter sitename:"
read SITENAME

sudo touch /etc/httpd/conf.d/$SITENAME.conf
echo "<VirtualHost *:80>" | sudo tee /etc/httpd/conf.d/$SITENAME.conf
echo "	ServerName $SITENAME" | sudo tee -a /etc/httpd/conf.d/$SITENAME.conf
echo "	ServerAdmin webmaster@host" | sudo tee -a /etc/httpd/conf.d/$SITENAME.conf
echo "	DocumentRoot /var/www/$SITENAME" | sudo tee -a /etc/httpd/conf.d/$SITENAME.conf
echo "	ErrorLog /var/www/$SITENAME/log/errors.log" | sudo tee -a /etc/httpd/conf.d/$SITENAME.conf
echo "	CustomLog /var/www/$SITENAME/log/access.log combined" | sudo tee -a /etc/httpd/conf.d/$SITENAME.conf
echo "</VirtualHost>" | sudo tee -a /etc/httpd/conf.d/$SITENAME.conf

sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

cat << EOF | sudo mysql_secure_installation

n
y
y
y
y
EOF

sudo mysql -u root -e "CREATE DATABASE wp_database;"
sudo mysql -u root -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '123456';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wp_database.* TO 'wp_user'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

sudo wget https://ru.wordpress.org/latest-ru_RU.zip
sudo unzip latest-ru_RU.zip -d /var/www/
sudo mv /var/www/wordpress/ /var/www/$SITENAME/

sudo mkdir /var/www/$SITENAME/log
sudo touch /var/www/$SITENAME/log/errors.log

sudo chown -R apache:apache /var/www/$SITENAME/
sudo service httpd restart

