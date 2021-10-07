#!/bin/bash
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!Boss, maginstall ne ing HTTPD!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
yum install -y httpd
echo ""
echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!Start ku ne ing HTTD mu boss!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
systemctl restart httpd
echo ""
echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!Add ke pa ing Firewall Rules!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
firewall-cmd --permanent --add-port 80/tcp --permanent
firewall-cmd --permanent --add-port 443/tcp --permanent
firewall-cmd --reload
echo ""
echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!Installing PHP MySQL!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!"
yum install -y php php-mysql
systemctl restart httpd.service
yum info-php-fpm
yum install -y phpfpm
cd /var/www/html
cat > info.php <<- EOF
<?php phpinfo(); ?>
EOF
echo ""
echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!"
echo "!!Installing MariaDB!!"
echo "!!!!!!!!!!!!!!!!!!!!!!"
yum install -y mariadb-server mariadb
systemctl start mariadb
echo ""
echo ""
echo "!!!!!!!!!!!!!!!!!!!"
echo "!!Security Script!!"
echo "!!!!!!!!!!!!!!!!!!!"
mysql_secure_installation <<EOF

y
root
root
y
y
y
y
EOF

psswd=root

systemctl enable mariadb 
mysqladmin -u root -p$psswd version
echo "CREATE DATABASE wordpress; CREATE USER 
wordpressuser@localhost IDENTIFIED by 'root'; GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED by 'root'; FLUSH PRIVILEGES; "| mysql -u root -p$psswd
echo ""
echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!Installing WordPress!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!"
yum install -y php-gd
yum install -y tar
yum install -y wgetls -la
systemctl restart httpd 
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
yum install -y rsync
rsync -avP wordpress/ /var/www/html/
cd /var/www/html/
mkdir /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/*
cp wp-config-sample.php wp-config.php
cd /var/www/html/
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/wordpressuser/g' wp-config.php
sed -i 's/password_here/root/g' wp-config.php
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php56 
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
systemctl restart httpd
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!yari ne boss, bukas namu!!"
echo "!!HTTPD INSTALLLED!!!!!!!!"
echo "!!HTTPD STARTED!!!!!!!!!!!"
echo "!!FIREWALLS ADDED!!!!!!!!!!!"
echo "!!PHP MYSQL INSTALLED!!!!!!!"
echo "!!WORDPRESS INSTALLED!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
