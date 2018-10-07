#!/bin/bash
#
# Ubuntu drupal install script
# Change the mysql password as desired
#
[[ $(whoami) != root ]] && echo You must be root to run this script && exit 1

# Database settings
mysql_pass=CHANGE_THIS_password
mysql_user=drupaluser
drupal_db=drupal

# Update ubuntu
apt -y update && apt -y dist-upgrade && apt -y autoremove

# Install apache, mysql, php
apt -y install apache2 mysql-server mysql-client php libapache2-mod-php php-mysql php-xml php-mysql php-curl php-gd php-imagick php-imap  php-recode php-tidy php-xmlrpc

# Configure MySQL
mysql -e "CREATE DATABASE $drupal_db;
          CREATE USER $mysql_user@localhost IDENTIFIED BY '$mysql_pass';
          GRANT ALL ON drupal.* TO $mysql_user@localhost;"

# Install drupal 8.6.0
cd /tmp && wget https://ftp.drupal.org/files/projects/drupal-8.6.0.tar.gz
tar xzvf drupal-8.6.0.tar.gz
mv drupal-8.6.0/*  /var/www/html
cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php
rm /var/www/html/index.html
mkdir /var/www/html/sites/default/files

# Configure apache
chmod -R 755 /var/www/html/*
chown -R www-data:www-data /var/www/html/*
a2enmod rewrite env dir mime

cat > /etc/apache2/sites-enabled/000-default.conf << EOF
<VirtualHost *:80>

     ServerAdmin admin@example.com
     DocumentRoot /var/www/html/
     ServerName example.com
     ServerAlias www.example.com
     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined

      <Directory /var/www/html/>
           Options FollowSymlinks
           AllowOverride All
           Require all granted
      </Directory>
      <Directory /var/www/html/>
           RewriteEngine on
           RewriteBase /
           RewriteCond %{REQUEST_FILENAME} !-f
           RewriteCond %{REQUEST_FILENAME} !-d
           RewriteRule ^(.*)$ index.php?q=$1 [L,QSA]
      </Directory>

</VirtualHost>
EOF
