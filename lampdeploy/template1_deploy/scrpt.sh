#!/bin/bash

sudo apt update

sudo apt install m4 -y
sudo apt install apache2 -y
sudo apt install mariadb-server mariadb-client -y
sudo apt install php php-mysql libapache2-mod-php php-cli php-cgi php-gd -y

echo "Enter your site name:"
read SITENAME
configfile=./$SITENAME.conf
echo "include(\`./mysiteby.m4') AppConnInfo(\`$SITENAME')" | m4 >> ${configfile}

sudo mysql_secure_installation

sudo mysql -u root -e "CREATE DATABASE wp_database;"
sudo mysql -u root -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '123456';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wp_database.* TO 'wp_user'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

sudo wget https://ru.wordpress.org/latest-ru_RU.zip
sudo unzip latest-ru_RU.zip -d /var/www/
sudo mv /var/www/wordpress/ /var/www/$SITENAME/

sudo cp $PWD/$SITENAME.conf /etc/apache2/sites-available/
sudo chown -R www-data:www-data /var/www/$SITENAME/
sudo a2ensite $SITENAME.conf
sudo service apache2 restart
