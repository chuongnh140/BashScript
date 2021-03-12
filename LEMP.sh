#!/bin/bash

yum install yum-utils -y
yum install epel-release -y

#Cai dat php-fpm
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
yum install http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum module enable php:remi-7.2 -y
yum install php php-fpm php-opcache  php-mysqlnd php-mysql php-dom php-mbstring php-gd php-pdo php-json php-xml php-zip php-curl php-mcrypt php-pear php-intl setroubleshoot-server -y

#Cai dat mariadb-client ketnoi toi database
cat <<EOF >> /etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos8-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

yum install -y boost-program-options
yum --disablerepo=AppStream install -y  mariadb-server

systemctl start mariadb
systemctl enable mariadb

yum install nginx -y

echo -n "Domain: "
read _domain
echo -n "Alias of domain: "
read _aliasDomain
echo -n "User want to manage: "
read _user

mkdir -p /home/$_user/web

chmod -R 775 /home/$_user

#FILE nginx.conf
cat  <<EOF > /etc/nginx/conf.d/web.conf
server {
   listen 80;
   server_name $_domain $_aliasDomain;

   # note that these lines are originally from the "location /" block
   root /home/$_user/web;
   index index.php index.html index.htm;

   location / {
      try_files \$uri \$uri/ =404;
   }
   error_page 404 /404.html;
   error_page 500 502 503 504 /50x.html;
   location = /50x.html {
      root /usr/share/nginx/html;
   }

   location ~ \.php$ {
      try_files \$uri =404;
      fastcgi_pass unix:/var/run/php-fpm/www.sock;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
      include fastcgi_params;
   }
}
EOF



#/etc/php-fpm.d/web.conf
cat  <<EOF > /etc/php-fpm.d/web.conf
[$_aliasDomain]
prefix = /home/$_user/web
user = $_user
group = $_user
listen = /run/php-fpm/www.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
slowlog = /var/log/php-fpm/web-slow.log
php_admin_value[error_log] = /var/log/php-fpm/web-error.log
php_admin_flag[log_errors] = on
php_value[session.save_handler] = files
php_value[session.save_path]    = /var/lib/php/session
php_value[soap.wsdl_cache_dir]  = /var/lib/php/wsdlcache
EOF

echo "Hello World" > /home/$_user/web/index.php

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak

systemctl enable --now nginx php-fpm.service 2>&1 >/dev/null
systemctl status nginx php-fpm.service




