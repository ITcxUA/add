#!/bin/bash

# set +x

# LINK='raw.githubusercontent.com/GitKitNet/add/main/bash-scripts/sshtoolkit.sh' && bash <(curl -L -fSs $LINK)
# read LINK && bash -c "$(curl -L -fSs $LINK)"
# read LINK && bash <(wget -O - $LINK)
# read LINK && bash -c "$(curl -fsSL $LINK || wget -O - $LINK)"


function sshkeygen() {

#  - - - - - - - - - - - - - - - - -
#            COLOR
#  - - - - - - - - - - - - - - - - -
GREEN="\033[32m";
RED="\033[1;31m";
BLUE="\033[1;34m";
YELOW="\033[1;33m";
PURPLE='\033[0;4;35m';
CYAN='\033[4;36m';
BLACK="\033[40m";
NC="\033[0m";

Black="`tput setaf 0`"
Red="`tput setaf 1`"
Green="`tput setaf 2`"
Yellow="`tput setaf 3`"
Blue="`tput setaf 4`"
Cyan="`tput setaf 5`"
Purple="`tput setaf 6`"
White="`tput setaf 7`"
 
BGBlack="`tput setab 0`"
BGRed="`tput setab 1`"
BGGreen="`tput setab 2`"
BGYellow="`tput setab 3`"
BGBlue="`tput setab 4`"
BGCyan="`tput setab 5`"
BGPurple="`tput setab 6`"
BGWhite="`tput setab 7`"

RC="`tput sgr0`"

TEXTCOLOR=$White;
BGCOLOR=$BLACK;

function C2() {
  for (( i = 0; i < 16; i++ )); do
    echo -e "`tput setaf $i`(C$i=\"\`tput setaf $i\`\"`tput sgr0`; `tput setab $i`(BC$i=\"\`tput setab $i\`\")`tput sgr0`";
done;
sleep 3
for (( i = 16; i < 256; i++ )); do
    echo -e "`tput setaf $i`(C$i=\"\`tput setaf $i\`\"`tput sgr0`; `tput setab $i`(BC$i=\"\`tput setab $i\`\")`tput sgr0`";
done;

}


#  - - - - - - - - - - - - - - - - -
#      VARIABLE & function
#  - - - - - - - - - - - - - - - - -

function THIS() {
 while true; do
  echo -e "${Yellow}Do you want Run $THIS script [y/N] .? ${RC}"
  read -e syn
  case $syn in
  [Yy]* ) break ;;
  [Nn]* ) echo -e "${RED}Cancel..${NC}"; exit 0 ;;
  esac
 done
}; 
THIS




#figlet -f smslant SSH Toolkit;
function showBanner()
{
  clear;
  echo -e "${BGBlack}
  ${BLUE}_______________${NC}${GREEN}________________________________${NC}
  ${BLUE}    __ ___ __  ${NC}${GREEN}  ______          ____    _ __  ${NC}
  ${BLUE}   / //_(_) /_ ${NC}${GREEN} /_  __/__  ___  / / /__ (_) /_ ${NC}
  ${BLUE}  / ,< / / __/ ${NC}${GREEN}  / / / _ \/ _ \/ /  '_// / __/ ${NC}
  ${BLUE} /_/|_/_/\__/  ${NC}${GREEN} /_/  \___/\___/_/_/\_\/_/\__/  ${NC}
  ${BLUE}_______________${NC}${GREEN}________________________________${NC}
  ";
}


function LoockUP() {
 while true; do
  read -e -p "Do you want Look UP SSH keys [y/N] .? " syn
  case $syn in
  [Yy]* ) clear;
   echo -en "\n${GREEN}=======================\n==    INFORMATION    ==\n=======================";
   echo -en "\n${GREEN}NAME:     ${NC}${Yellow}${kName}";
   echo -en "\n${GREEN}PUBLIC:   ${NC}${Yellow}" && cat "$HOME/.ssh/${kName}.pub"
   echo -en "\n${GREEN}PRIVAT:   ${NC}${YELLOW}" && cat "$HOME/.ssh/${kName}";
   echo -en "\n${GREEN}=======================${NC}\n";
   pause && break ;;

  [Nn]* ) echo -e "${RED}Cancel..${NC}" && break ;;
  esac
 done
}

function ConvertPPK()
{
OS="$( cat /etc/*release |grep '^ID=' | awk -F= '{print $2 }' )";

 while true; do
 read -e -p "Do you want PuTTy file ${kName}.ppk [y/N] ..? " syn
 case $syn in
  [Yy]* ) echo -en "\n${YELLOW}Install PuTTy and Converted to *.PPK ${NC}";
    if [[ "$OS" == arch ]]; then pacman -S putty;
      elif [[ "$OS" == centos ]] && [[ "$OS" == rhell ]]; then yum install putty -y;
      elif [[ "$OS" == fedora ]]; then dnf install putty -y;
      elif [[ "$OS" == ubuntu ]]; then apt-get install putty-tools -y;
    fi;
   if [[ -f "$HOME/.ssh/${kName}" ]]; then echo -en "\n${GREEN}SSH Key Exist\n ${NC}"; puttygen ${kName} -o ${kName}.ppk; else echo "SSH key Not Exist"; fi ;;
  [Nn]* ) echo -e "${RED}Cancel..${NC}"; break ;;
  esac;
 done
}


function title() { clear; echo "${title} ${TKEY}"; }
function pause() { read -p "Press [Enter] key to continue..." fackEnterKey; }
function wait() { read -p "Press [ANY] key to continue..? " -s -n 1; }
function TIMER() { if [[ "$1" =~ ^[[:digit:]]+$ ]]; then T="$1"; else T="5"; fi; SE="\033[0K\r"; E="$((1 * ${T}))"; while [ $E -gt 0 ]; do echo -en " Please wait: ${RED}$E$SE${NC}" && sleep 1 && : $((E--)); done; }
function AddON() { 
  while true; do read -e -p "Do you want RUN Agent? [y/N] ?" ryn; case $ryn in [Yy]* ) clear; eval $(ssh-agent) && ssh-add -D; break ;; [Nn]* ) break;; esac; done
  while true; do  read -e -p "Do you want add key to SSH Agent? [y/N]" ayn; case $ayn in [Yy]* ) local -r kName="$1"; ssh-add "$HOME/.ssh/$kName" ;; [Nn]* ) break;; esac; done
  while true; do read -e -p "Add to authorized_key? [y/N]" uyn; case $uyn in [Yy]* ) cat "$HOME/.ssh/${kName}.pub" >> "$HOME/.ssh/authorized_keys" ;; [Nn]* ) break;; esac; done;
}

function OnRUN() {
  title;
  read -e -p "Enter NAME ssh key: " IDK && ID="$( echo ${IDK} | sed 's/ /_/g' )";
  read -e -p "Add comment: " COMENT && COM="$( echo ${COMENT} | sed 's/ /./g' )";
  read -e -p "Enter password: " PASS;

  if [ -z "${ID}" ]; then ID="${hostname}_${USER}" && echo "${ID}"; else echo "${ID}"; fi
  if [ -z "${COM}" ]; then COM="${USER}"@"$( echo ${IDK} | sed 's/ /./g' )"; else echo "${COM}"; fi;

  kName="id_${TKEY}_$( echo ${ID} | sed 's/ /_/g' ).key";
  ssh-keygen -t ${TKEY} -f $HOME/.ssh/${kName} -C "${COM}" -N "$PASS";
  ConvertPPK ;
  LoockUP ;
}





function PMAdmin() {

    curl -s --connect-timeout 30 --retry 10 --retry-delay 5 -k -L "https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz" > pma.tar.gz
    mkdir -p /var/www/html/phpmyadmin
    tar xzf pma.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
    rm pma.tar.gz
    cp /var/www/html/phpmyadmin/config{.sample,}.inc.php
    chmod 660 /var/www/html/phpmyadmin/config.inc.php
    sed -i "/blowfish_secret/s/''/'$(pwgen -s 32 1)'/" /var/www/html/phpmyadmin/config.inc.php
    chown -R www-data:www-data /var/www/html/phpmyadmin
    test -f /etc/nginx/conf.d/default.conf && rm -f /etc/nginx/conf.d/default.conf

    # Узнаём версию php
    fpmver=$(php -v | head -1 | cut -c5-7)
    cat > /etc/nginx/conf.d/phpmyadmin.conf << EOF
server {
  listen 80;
  listen [::]:80;
  server_name _;
  root /usr/share/nginx/html/;
  index index.php index.html index.htm index.nginx-debian.html;

  location / {
    try_files \$uri \$uri/ =404;
  }

  location ~ \.php$ {
    fastcgi_pass unix:/run/php/php$fpmver-fpm.sock;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    include fastcgi_params;
    include snippets/fastcgi-php.conf;
  }

  location /phpmyadmin {
    root /var/www/html/;
    index index.php index.html index.htm;
    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
            root /var/www/html/;
    }
    location ~  ^/phpmyadmin/(.+\.php)$ {
            fastcgi_pass unix:/run/php/php$fpmver-fpm.sock;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
    }
  }

  location ~ /\.ht {
      access_log off;
      log_not_found off;
      deny all;
  }
}
EOF
    systemctl restart nginx
}

#=====================================
function SQLwpLAND() {

echo "============================================
      Mysql Server Installation
============================================"

if [ ! -x /usr/bin/mysql ] ; then
apt install mysql-server -y && systemctl start mysql
fi

echo "============================================================
Please Enter root  password for authorization to mysql db
------------------------------------------------------------"

read -r -p "Do you want to generated automatically ? [y/N] If not it will provide password.  " rootpass
if [[ "$rootpass" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
 db_pass=$(date +%s|sha256sum|base64|head -c 30)
else
 echo "Enter DB ROOT PASSWORD: "
 read -e db_pass


mysql_secure_installation <<EOF
y
y
${db_pass}
${db_pass}
y
y
y
y
EOF
fi

echo -e "WordPress Install Script \n Please Enter Domain Name: "
read -e domain
authorization="mysql -uroot -p${db_pass}"
read -r -p "Do you want to generated automatically ? [y/N] If not it will provide password.  " answer
if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
 dbPassword=$(date +%s|sha256sum|base64|head -c 25)
else
 echo -en "Enter DB USER PASSWORD: " && read -e dbPassword
fi

echo "Is everything ok, run install? [y/N]"

read -e run
if [ "$run" == n ] ; then
exit
else
echo "A robot is now installing WordPress for you"
#set +e
mkdir -p /var/www/$domain
cd /var/www/$domain
#Connect to mysql docker container and create database
dbNameandUser=$(echo ${domain} | tr "." "_" | tr "-" "_")
Host=\'%\'

echo "--Reusing credentials----------------------"
$authorization -e "
CREATE USER 'root'@${Host} IDENTIFIED BY '${db_pass}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@${Host} WITH GRANT OPTION;
DROP USER 'root'@'localhost';"

$authorization -e "
DROP USER IF EXISTS ${dbNameandUser}@${Host};
DROP DATABASE IF EXISTS ${dbNameandUser};"

$authorization -e "
CREATE DATABASE ${dbNameandUser};
CREATE USER ${dbNameandUser}@${Host} IDENTIFIED BY '${dbPassword}';
GRANT ALL PRIVILEGES ON ${dbNameandUser}.* TO ${dbNameandUser}@${Host};
FLUSH PRIVILEGES;"
db_pass=${db_pass} >/dev/null 2>/dev/null
db_pass=${db_pass} > /tmp/${db_pass}
wp_admin=root
wp_pass=$(date +%s|sha256sum|base64|head -c 20)

apt-get install curl -y || apk add curl \
&& curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x /tmp/wp-cli.phar \
&& mv /tmp/wp-cli.phar /usr/local/bin/wp \
&& wp core download --path=/var/www/${domain} --locale=en_US --allow-root \
&& wp config create --path=/var/www/${domain} --dbname=${dbNameandUser} --dbuser=${dbNameandUser} --dbpass=${dbPassword} --dbhost=localhost --allow-root --skip-check \
&& wp core install --skip-email --url=${domain} --title=${domain} --admin_user=${wp_admin} --admin_password=${wp_pass} --admin_email=alina.m.giese@gmail.com --allow-root --path=/var/www/${domain}

###mkdir /var/www/$domain/wp-content/uploads
chmod 775 -R /var/www/$domain/ ###wp-content/uploads
chown www-data:www-data -R /var/www/$domain
echo "Cleaning...
-----------------------------------------------
  Credentials for Database And for Wp-admin
-----------------------------------------------
INFO
DBRootPass ${db_pass}
DBName: ${dbNameandUser}
DBUser: ${dbNameandUser}
DBPass: ${dbPassword}
Domainame:  http://${domain}/wp-admin/
WPAdmin: ${wp_admin}
WPPass: ${wp_pass}
=================================================
         Installation is complete!
=================================================
Try to connect mysql database:  mysql -h 127.0.0.1 -u root -p${db_pass}"

echo "Cleaning...
-----------------------------------------------
  Credentials for Database And for Wp-admin
-----------------------------------------------
INFO
DBRootPass ${db_pass}
DBName: ${dbNameandUser}
DBUser: ${dbNameandUser}
DBPass: ${dbPassword}
Domainame:  http://${domain}/wp-admin/
WPAdmin: ${wp_admin}
WPPass: ${wp_pass}
=================================================
         Installation is complete!
=================================================
Try to connect mysql database:  mysql -h 127.0.0.1 -u root -p${db_pass}
-----------------------------------------------------------------------------" >> /tmp/credentials.txt
fi
}


#=============================================
function AddNewWP(){

echo "============================================
      WordPress Install Script
============================================
      Please Enter Domain Name:
--------------------------------------------"
read -e domain

read -r -p "Do you want Enter root DB pass automatically from cache ? [y/N] If not it will provide password." answer
if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
  db_pass=${db_pass} < /dev/null 2>/dev/null
  db_pass=${db_pass} >/dev/null 2>/dev/null
else
  echo "Enter DB ROOT PASSWORD: "
  read -e db_pass
fi

authorization="mysql -uroot -p${db_pass}"
read -r -p "Do you want to generated automatically ? [y/N] If not it will provide password.  " answer
if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
 dbPassword=$(date +%s|sha256sum|base64|head -c 25)
else
 echo "Enter DB_PASSWORD:"
 read -e dbPassword
fi

echo "Is everything ok, run install? [y/N]"

read -e run
if [ "$run" == n ] ; then
exit
else
echo "==============================================
  A robot is now installing WordPress for you.
=============================================="
#set +e
mkdir -p /var/www/$domain
cd /var/www/$domain
#Connect to mysql docker container and create database
dbNameandUser=$(echo ${domain} | tr "." "_" | tr "-" "_")
Host=\'%\'

echo "--Reusing credentials----------------------"

$authorization -e "
DROP USER IF EXISTS ${dbNameandUser}@${Host};
DROP DATABASE IF EXISTS ${dbNameandUser};"

$authorization -e "
CREATE DATABASE ${dbNameandUser};
CREATE USER ${dbNameandUser}@${Host} IDENTIFIED BY '${dbPassword}';
GRANT ALL PRIVILEGES ON ${dbNameandUser}.* TO ${dbNameandUser}@${Host};
FLUSH PRIVILEGES;"
wp_admin=root
wp_pass=$(date +%s|sha256sum|base64|head -c 20)

apt-get install curl -y || apk add curl \
&& curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x /tmp/wp-cli.phar \
&& mv /tmp/wp-cli.phar /usr/local/bin/wp \
&& wp core download --path=/var/www/${domain} --locale=en_US --allow-root \
&& wp config create --path=/var/www/${domain} --dbname=${dbNameandUser} --dbuser=${dbNameandUser} --dbpass=${dbPassword} --dbhost=localhost --allow-root --skip-check \
&& wp core install --skip-email --url=${domain} --title=${domain} --admin_user=${wp_admin} --admin_password=${wp_pass} --admin_email=alina.m.giese@gmail.com --allow-root --path=/var/www/${domain}

###mkdir /var/www/$domain/wp-content/uploads
chmod 775 -R /var/www/$domain ###/wp-content/uploads
chown www-data:www-data -R /var/www/$domain
echo "Cleaning...
-----------------------------------------------
  Credentials for Database And for Wp-admin
-----------------------------------------------
INFO
DBRootPass: ${db_pass}
DBName: ${dbNameandUser}
DBUser: ${dbNameandUser}
DBPass: ${dbPassword}
Domainame:  http://${domain}/wp-admin/
WPAdmin: ${wp_admin}
WPPass: ${wp_pass}
=================================================
         Installation is complete!
=================================================
Try to connect mysql database:  mysql -h 127.0.0.1 -u root -p${db_pass}"

echo "Cleaning...
-----------------------------------------------
  Credentials for Database And for Wp-admin
-----------------------------------------------
INFO
DBRootPass: ${db_pass}
DBName: ${dbNameandUser}
DBUser: ${dbNameandUser}
DBPass: ${dbPassword}
Domainame:  http://${domain}/wp-admin/
WPAdmin: ${wp_admin}
WPPass: ${wp_pass}
=================================================
         Installation is complete!
=================================================
Try to connect mysql database:  mysql -h 127.0.0.1 -u root -p${db_pass}
-----------------------------------------------------------------------------" >> /tmp/credentials.txt
fi
}



#=============================================
function Preinstall(){

#set -x
clear
echo -en "\n\n\tPlease Enter Domain Name: "; read -e domain;

apt update && apt upgrade -y
apt install -y mc htop curl git wget gnupg gnupg2 nginx
apt-get -y install software-properties-common
apt-get update
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get -y install php7.4 php7.4-fpm php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline  php7.4-imap php7.4-mbstring php7.4-xml php7.4-xmlrpc php7.4-imagick php7.4-dev php7.4-opcache php7.4-soap php7.4-gd php7.4-zip php7.4-intl php7.4-curl
sed -i 's/;cgi.fix_pathinfo=0/ cgi.fix_pathinfo=1/g' /etc/php/7.4/fpm/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 300M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 300M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/7.4/fpm/php.ini
sed -i 's/max_input_time = 60/max_input_time = 600/g' /etc/php/7.4/fpm/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/7.4/fpm/php.ini

cat << 'eof' >> /etc/php/7.4/fpm/php-fpm.conf

pm = dynamic
 pm.max_children = 97
 pm.start_servers = 20
 pm.min_spare_servers = 10
 pm.max_spare_servers = 20
 pm.max_requests = 200

eof
sudo apt-get -y install certbot
apt install -y python-certbot-nginx || apt-get -y install python3-certbot-nginx

       # Проверка существования файла.
if [ ! -f "/etc/nginx/sites-available/$domain.conf" ]; then
  echo "Файл \"/etc/nginx/sites-available/$domain.conf\" не найден."
  touch /etc/nginx/sites-available/$domain.conf
fi

fpmver=$(php -v | head -1 | cut -c5-7)
cat << 'eof' >> /etc/nginx/sites-available/$domain.conf
### Configuration ###

server {
	listen 80;
	listen [::]:80;
	listen 443;
	listen [::]:443;
	server_name DMN www.DMN;
	root /var/www/DMN;
	index index.php index.html index.htm index.nginx-debian.html;

	location / {
		try_files $uri $uri/ /index.php$is_args$args;

		# allow 94.131.223.230;     # main
		# allow 185.16.228.210;     # mirror
		# allow 89.40.119.49;       # vpn
		# allow 94.177.247.152;     # vpn
		# allow 168.119.246.146;    # vpn
		# allow 159.69.210.127;     # control
		# allow 188.239.37.177;     # NN
		# deny all;                 # 
	}

	proxy_connect_timeout 3600;
	proxy_send_timeout 3600;
	proxy_read_timeout 3600;
	send_timeout 3600;
	client_max_body_size 100M;

	location ~ "^\/([a-z0-9]{{28,32}})\.html" {
		add_header Content-Type text/plain;
		return 200 $1;
	}

	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php/php$fpmver-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_param REMOTE_ADDR $remote_addr;
		fastcgi_param HTTP_X_FORWARDED_FOR $http_x_forwarded_for;
		fastcgi_param HTTP_X_REAL_IP $http_x_real_ip;
		fastcgi_param HTTP_CF_CONNECTING_IP $http_cf_connecting_ip;
		fastcgi_intercept_errors off;
		fastcgi_buffer_size 16k;
		fastcgi_buffers 4 16k;
		fastcgi_read_timeout 3600;
	}

	location ~* \.(jpg|jpeg|png|gif|ico|css|js|mp4|svg|woff|woff2|ttf)$ {
		expires 365d;
	}

	location ~* /(?:uploads|files)/.*.php$ {
		deny all;
	}

	location ~* /*.sql {
		deny all;
	}

	location ~* /.git/* {
		deny all;
	}
	location  ^~ /wp-cron.php {
		   allow 127.0.0.1;
	}

	location ~ /\.ht {
			deny all;
	}

	location = /xmlrpc.php {
		deny all;
	}

	location ~ /\. {
		deny all;
	}
}
eof




cd /etc/nginx/sites-enabled/
ln -s ../sites-available/$domain.conf

mkdir -p /var/www/$domain/
chown -R www-data:www-data /var/www/$domain/
cat << 'eof' >> /var/www/$domain/index.html
<!DOCTYPE html>
<html>
	<head>
		<title>Welcome to ${domain}!</title>
		<style>body {width: 35em; margin: 0 auto;font-family: Tahoma, Verdana, Arial, sans-serif;}</style>
	</head>
	<body style="background-color:white;">
		<h1 style="color:black;">Welcome to ${domain} </h1>
	</body>
</html>
eof

sed -i "s/DMN/$domain/g" /etc/nginx/sites-available/$domain.conf
sed -i "s/EXP/$domain/g" /var/www/$domain/index.html

sed -i "17a\\\treal_ip_header X-Forwarded-For;" /etc/nginx/nginx.conf
sed -i "18a\\\tset_real_ip_from 0.0.0.0/0;"  /etc/nginx/nginx.conf
nginx -s reload

# sed -i "4a\\\tserver_name ${domain} www.${domain};" /etc/nginx/sites-available/$domain.conf
# sed -i "5a\\\treturn 301 https://\$host\$request_uri;" /etc/nginx/sites-available/$domain.conf
# sed -i "6a\\\}" /etc/nginx/sites-available/$domain.conf
# sed -i "7a\\\server {" /etc/nginx/sites-available/$domain.conf
# sed -i "9c\\\tlisten 443 ssl;"  /etc/nginx/sites-available/$domain.conf
# sed -i "10c\\\tlisten [::]:443 ssl;" /etc/nginx/sites-available/$domain.conf
# sed -i "14i\\\tssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;" /etc/nginx/sites-available/$domain.conf
# sed -i "15i\\\tssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;" /etc/nginx/sites-available/$domain.conf
# sed -i "16i\\\tssl_protocols   TLSv1 TLSv1.1 TLSv1.2 SSLv3;" /etc/nginx/sites-available/$domain.conf
#
# certbot --nginx -d ${domain} -d www.${domain} -m brain.devops@gmail.com --non-interactive ###--agree-tos
# sleep 5
# nginx -s reload


#----------------------------------------
function PMAdmin() {
PWGEN=$(dpkg-query -W -f='${Status}' pwgen 2>/dev/null | grep -c "ok installed")
	if [ "$PWGEN" -eq 0 ]; then
		echo -e "${YELLOW}Installing pwgen${NC}" && apt-get install pwgen --yes;
	elif [ "$PWGEN" -eq 1 ]; then
		echo -e "${GREEN}pwgen	- is installed!${NC}";
	fi;



     curl -s --connect-timeout 30 --retry 10 --retry-delay 5 -k -L "https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz" > pma.tar.gz
    mkdir -p /var/www/html/phpmyadmin
    tar xzf pma.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
    rm pma.tar.gz
    cp /var/www/html/phpmyadmin/config{.sample,}.inc.php
    chmod 660 /var/www/html/phpmyadmin/config.inc.php
    sed -i "/blowfish_secret/s/''/'$(pwgen -s 32 1)'/" /var/www/html/phpmyadmin/config.inc.php
    chown -R www-data:www-data /var/www/html/phpmyadmin
    test -f /etc/nginx/conf.d/default.conf && rm -f /etc/nginx/conf.d/default.conf

    # Узнаём версию php
    fpmver=$(php -v | head -1 | cut -c5-7)
    cat > /etc/nginx/conf.d/phpmyadmin.conf << EOF
server {
  listen 80;
  listen [::]:80;
  server_name _;
  root /usr/share/nginx/html/;
  index index.php index.html index.htm index.nginx-debian.html;

  location / {
    try_files \$uri \$uri/ =404;
  }

  location ~ \.php$ {
    fastcgi_pass unix:/run/php/php$fpmver-fpm.sock;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    include fastcgi_params;
    include snippets/fastcgi-php.conf;
  }

  location /phpmyadmin {
    root /var/www/html/;
    index index.php index.html index.htm;
    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
            root /var/www/html/;
    }
    location ~  ^/phpmyadmin/(.+\.php)$ {
            fastcgi_pass unix:/run/php/php$fpmver-fpm.sock;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
    }
  }

  location ~ /\.ht {
      access_log off;
      log_not_found off;
      deny all;
  }
}
EOF
    systemctl restart nginx
};
PMAdmin


	cd /root/
	touch dm && wget https://scr.devkong.work/addomain_into_file.py && chmod +x addomain_into_file.py

}




funtion installLAMP() {
#Welcome message
clear
echo -e "Welcome to WordPress & LAMP stack installation and configuration wizard!
First of all, we going to check all required packeges..."

#Checking packages
echo -e "${YELLOW}Checking packages...${NC}"
echo -e "List of required packeges: nano, zip, unzip, mc, htop, fail2ban, apache2 & php, mysql, php curl, phpmyadmin, wget, curl"

read -r -p "Do you want to check packeges? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 


NANO=$(dpkg-query -W -f='${Status}' nano 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' nano 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing nano${NC}"
    apt-get install nano --yes;
    elif [ $(dpkg-query -W -f='${Status}' nano 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}nano is installed!${NC}"
  fi

ZIP=$(dpkg-query -W -f='${Status}' zip 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' zip 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing zip${NC}"
    apt-get install zip --yes;
    elif [ $(dpkg-query -W -f='${Status}' zip 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}zip is installed!${NC}"
  fi

MC=$(dpkg-query -W -f='${Status}' mc 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' mc 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing mc${NC}"
    apt-get install mc --yes;
    elif [ $(dpkg-query -W -f='${Status}' mc 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}mc is installed!${NC}"
  fi

HTOP=$(dpkg-query -W -f='${Status}' htop 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' htop 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing htop${NC}"
    apt-get install htop --yes;
    elif [ $(dpkg-query -W -f='${Status}' htop 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}htop is installed!${NC}"
  fi

FAIL2BAN=$(dpkg-query -W -f='${Status}' fail2ban 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' fail2ban 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing fail2ban${NC}"
    apt-get install fail2ban --yes;
    elif [ $(dpkg-query -W -f='${Status}' fail2ban 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}fail2ban is installed!${NC}"
  fi

APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing apache2${NC}"
    apt-get install apache2 php5 --yes;
    elif [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}apache2 is installed!${NC}"
  fi

MYSQL=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing mysql-server${NC}"
    apt-get install mysql-server --yes;
    elif [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}mysql-server is installed!${NC}"
  fi

PHP5CURL=$(dpkg-query -W -f='${Status}' php5-curl 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' php5-curl 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing php5-curl${NC}"
    apt-get install php5-curl --yes;
    elif [ $(dpkg-query -W -f='${Status}' php5-curl 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}php5-curl is installed!${NC}"
  fi

PHPMYADMIN=$(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing phpmyadmin${NC}"
    apt-get install phpmyadmin --yes;
    elif [ $(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}phpmyadmin is installed!${NC}"
  fi

WGET=$(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing wget${NC}"
    apt-get install wget --yes;
    elif [ $(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}wget is installed!${NC}"
  fi

CURL=$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo -e "${YELLOW}Installing curl${NC}"
    apt-get install curl --yes;
    elif [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}curl is installed!${NC}"
  fi

  ;;

    *)

  echo -e "${RED}
  Packeges check is ignored! 
  Please be aware, that apache2, mysql, phpmyadmin and other software may not be installed!
  ${NC}"

  ;;
esac


#phpmyadmin default path change
echo -e "${YELLOW}Changing phpMyAdmin default path from /phpMyAdmin to /myadminphp...${NC}"

read -r -p "Do you want to change default phpMyAdmin path to /myadminphp? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
  
cat >/etc/phpmyadmin/apache.conf <<EOL
# phpMyAdmin default Apache configuration

Alias /myadminphp /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options FollowSymLinks
    DirectoryIndex index.php

    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_flag magic_quotes_gpc Off
        php_flag track_vars On
        php_flag register_globals Off
        php_admin_flag allow_url_fopen Off
        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/
    </IfModule>

</Directory>

# Authorize for setup
<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authz_core.c>
        <IfModule mod_authn_file.c>
            AuthType Basic
            AuthName "phpMyAdmin Setup"
            AuthUserFile /etc/phpmyadmin/htpasswd.setup
        </IfModule>
        Require valid-user
    </IfModule>
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>
EOL

echo -e "${GREEN}Path was succesfully changed!
New phpMyAdmin path is: /myadminphp (i.e.: yourwebsite.com/myadminphp)${NC}"

        ;;
    *)

  echo -e "${RED}Path was not changed!${NC}"

        ;;
esac

#creating user
echo -e "${YELLOW}Adding separate user & creating website home folder for secure running of your website...${NC}"

  echo -e "${YELLOW}Please, enter new username: ${NC}"
  read username
  echo -e "${YELLOW}Please enter website name: ${NC}"
  read websitename
  groupadd $username
  adduser --home /var/www/$username/$websitename --ingroup $username $username
  mkdir /var/www/$username/$websitename/www
  chown -R $username:$username /var/www/$username/$websitename
  echo -e "${GREEN}User, group and home folder were succesfully created!
  Username: $username
  Group: $username
  Home folder: /var/www/$username/$websitename
  Website folder: /var/www/$username/$websitename/www${NC}"


#configuring apache2
echo -e "${YELLOW}Now we going to configure apache2 for your domain name & website root folder...${NC}"

read -r -p "Do you want to configure Apache2 automatically? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 

  echo -e "Please, provide us with your domain name: "
  read domain_name
  echo -e "Please, provide us with your email: "
  read domain_email
  cat >/etc/apache2/sites-available/$domain_name.conf <<EOL
  <VirtualHost *:80>
        ServerAdmin $domain_email
        ServerName $domain_name
        ServerAlias www.$domain_name
        DocumentRoot /var/www/$username/$websitename/www/
        <Directory />
                Options +FollowSymLinks
                AllowOverride All
        </Directory>
        <Directory /var/www/$username/$websitename/www>
                Options -Indexes +FollowSymLinks +MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>

        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn

        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL
	a2dissite 000-default
    a2ensite $domain_name
    service apache2 restart
    P_IP="`wget http://ipinfo.io/ip -qO -`"

    echo -e "${GREEN}Apache2 config was updated!
    New config file was created: /etc/apache2/sites-available/$domain_name.conf
    Domain was set to: $domain_name
    Admin email was set to: $domain_email
    Root folder was set to: /var/www/$username/$websitename/www
    Option Indexes was set to: -Indexes (to close directory listing)
    Your server public IP is: $P_IP (Please, set this IP into your domain name 'A' record)
    Website was activated & apache2 service reloaded!
    ${NC}"

        ;;
    *)

  echo -e "${RED}WARNING! Apache2 was not configured properly, you can do this manually or re run our script.${NC}"

        ;;
esac

#downloading WordPress, unpacking, adding basic pack of plugins, creating .htaccess with optimal & secure configuration
echo -e "${YELLOW}On this step we going to download latest version of WordPress with EN or RUS language, set optimal & secure configuration and add basic set of plugins...${NC}"

read -r -p "Do you want to install WordPress & automatically set optimal and secure configuration with basic set of plugins? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 

  echo -e "${GREEN}Please, choose WordPress language you need (set RUS or ENG): "
  read wordpress_lang

  if [ "$wordpress_lang" == 'RUS' ];
    then
    wget https://ru.wordpress.org/latest-ru_RU.zip -O /tmp/$wordpress_lang.zip
  else
    wget https://wordpress.org/latest.zip -O /tmp/$wordpress_lang.zip
  fi

  echo -e "Unpacking WordPress into website home directory..."
  sleep 5
  unzip /tmp/$wordpress_lang.zip -d /var/www/$username/$websitename/www/
  mv /var/www/$username/$websitename/www/wordpress/* /var/www/$username/$websitename/www
  rm -rf /var/www/$username/$websitename/www/wordpress
  rm /tmp/$wordpress_lang.zip
  mkdir /var/www/$username/$websitename/www/wp-content/uploads
  chmod -R 777 /var/www/$username/$websitename/www/wp-content/uploads

  echo -e "Now we going to download some useful plugins:
  1. Google XML Sitemap generator
  2. Social Networks Auto Poster
  3. Add to Any
  4. Easy Watermark"
  sleep 7
  
  SITEMAP="`curl https://wordpress.org/plugins/google-sitemap-generator/ | grep https://downloads.wordpress.org/plugin/google-sitemap-generator.*.*.*.zip | awk '{print $3}' | sed -ne 's/.*\(http[^"]*.zip\).*/\1/p'`"
  wget $SITEMAP -O /tmp/sitemap.zip
  unzip /tmp/sitemap.zip -d /tmp/sitemap
  mv /tmp/sitemap/* /var/www/$username/$websitename/www/wp-content/plugins/

  wget https://downloads.wordpress.org/plugin/social-networks-auto-poster-facebook-twitter-g.zip -O /tmp/snap.zip
  unzip /tmp/snap.zip -d /tmp/snap
  mv /tmp/snap/* /var/www/$username/$websitename/www/wp-content/plugins/

  ADDTOANY="`curl https://wordpress.org/plugins/add-to-any/ | grep https://downloads.wordpress.org/plugin/add-to-any.*.*.zip | awk '{print $3}' | sed -ne 's/.*\(http[^"]*.zip\).*/\1/p'`"
  wget $ADDTOANY -O /tmp/addtoany.zip
  unzip /tmp/addtoany.zip -d /tmp/addtoany
  mv /tmp/addtoany/* /var/www/$username/$websitename/www/wp-content/plugins/

  WATERMARK="`curl https://wordpress.org/plugins/easy-watermark/ | grep https://downloads.wordpress.org/plugin/easy-watermark.*.*.*.zip | awk '{print $3}' | sed -ne 's/.*\(http[^"]*.zip\).*/\1/p'`"
  wget $WATERMARK -O /tmp/watermark.zip
  unzip /tmp/watermark.zip -d /tmp/watermark
  mv /tmp/watermark/* /var/www/$username/$websitename/www/wp-content/plugins/

  rm /tmp/sitemap.zip /tmp/snap.zip /tmp/addtoany.zip /tmp/watermark.zip
  rm -rf /tmp/sitemap/ /tmp/snap/ /tmp/addtoany/ /tmp/watermark/


  echo -e "Downloading of plugins finished! All plugins were transfered into /wp-content/plugins directory.${NC}"

        ;;
    *)

  echo -e "${RED}WordPress and plugins were not downloaded & installed. You can do this manually or re run this script.${NC}"

        ;;
esac

#creating of swap
echo -e "On next step we going to create SWAP (it should be your RAM x2)..."

read -r -p "Do you need SWAP? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 

  RAM="`free -m | grep Mem | awk '{print $2}'`"
  swap_allowed=$(($RAM * 2))
  swap=$swap_allowed"M"
  fallocate -l $swap /var/swap.img
  chmod 600 /var/swap.img
  mkswap /var/swap.img
  swapon /var/swap.img

  echo -e "${GREEN}RAM detected: $RAM
  Swap was created: $swap${NC}"
  sleep 5

        ;;
    *)

  echo -e "${RED}You didn't create any swap for faster system working. You can do this manually or re run this script.${NC}"

        ;;
esac

#creation of secure .htaccess
echo -e "${YELLOW}Creation of secure .htaccess file...${NC}"
sleep 3
cat >/var/www/$username/$websitename/www/.htaccess <<EOL
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]

RewriteCond %{query_string} concat.*\( [NC,OR]
RewriteCond %{query_string} union.*select.*\( [NC,OR]
RewriteCond %{query_string} union.*all.*select [NC]
RewriteRule ^(.*)$ index.php [F,L]

RewriteCond %{QUERY_STRING} base64_encode[^(]*\([^)]*\) [OR]
RewriteCond %{QUERY_STRING} (<|%3C)([^s]*s)+cript.*(>|%3E) [NC,OR]
</IfModule>

<Files .htaccess>
Order Allow,Deny
Deny from all
</Files>

<Files wp-config.php>
Order Allow,Deny
Deny from all
</Files>

<Files wp-config-sample.php>
Order Allow,Deny
Deny from all
</Files>

<Files readme.html>
Order Allow,Deny
Deny from all
</Files>

<Files xmlrpc.php>
Order allow,deny
Deny from all
</files>

# Gzip
<ifModule mod_deflate.c>
AddOutputFilterByType DEFLATE text/text text/html text/plain text/xml text/css application/x-javascript application/javascript text/javascript
</ifModule>

Options +FollowSymLinks -Indexes

EOL

chmod 644 /var/www/$username/$websitename/www/.htaccess

echo -e "${GREEN}.htaccess file was succesfully created!${NC}"

#cration of robots.txt
echo -e "${YELLOW}Creation of robots.txt file...${NC}"
sleep 3
cat >/var/www/$username/$websitename/www/robots.txt <<EOL
User-agent: *
Disallow: /cgi-bin
Disallow: /wp-admin/
Disallow: /wp-includes/
Disallow: /wp-content/
Disallow: /wp-content/plugins/
Disallow: /wp-content/themes/
Disallow: /trackback
Disallow: */trackback
Disallow: */*/trackback
Disallow: */*/feed/*/
Disallow: */feed
Disallow: /*?*
Disallow: /tag
Disallow: /?author=*
EOL

echo -e "${GREEN}File robots.txt was succesfully created!
Setting correct rights on user's home directory and 755 rights on robots.txt${NC}"
sleep 3

chmod 755 /var/www/$username/$websitename/www/robots.txt

echo -e "${GREEN}Configuring fail2ban...${NC}"
sleep 3
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf-old
cat >/etc/fail2ban/jail.conf <<EOL
[DEFAULT]

ignoreip = 127.0.0.1/8
ignorecommand =
bantime  = 1200
findtime = 1200
maxretry = 3
backend = auto
usedns = warn
destemail = $domain_email
sendername = Fail2Ban
sender = fail2ban@localhost
banaction = iptables-multiport
mta = sendmail

# Default protocol
protocol = tcp
# Specify chain where jumps would need to be added in iptables-* actions
chain = INPUT
# ban & send an e-mail with whois report to the destemail.
action_mw = %(banaction)s[name=%(__name__)s, port="%(port)s", protocol="%(protocol)s", chain="%(chain)s"]
              %(mta)s-whois[name=%(__name__)s, dest="%(destemail)s", protocol="%(protocol)s", chain="%(chain)s", sendername="%(sendername)s"]
action = %(action_mw)s

[ssh]
enabled  = true
port     = ssh
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 5

[ssh-ddos]
enabled  = true
port     = ssh
filter   = sshd-ddos
logpath  = /var/log/auth.log
maxretry = 5

[apache-overflows]
enabled  = true
port     = http,https
filter   = apache-overflows
logpath  = /var/log/apache*/*error.log
maxretry = 5
EOL

service fail2ban restart

echo -e "${GREEN}fail2ban configuration finished!
fail2ban service was restarted, default confige backuped at /etc/fail2ban/jail.conf-old
Jails were set for: ssh bruteforce, ssh ddos, apache overflows${NC}"

sleep 5

echo -e "${GREEN} Configuring apache2 prefork & worker modules...${NC}"
sleep 3
cat >/etc/apache2/mods-available/mpm_prefork.conf <<EOL
<IfModule mpm_prefork_module>
	StartServers			 1
	MinSpareServers		  1
	MaxSpareServers		 3
	MaxRequestWorkers	  10
	MaxConnectionsPerChild   3000
</IfModule>
EOL

cat > /etc/apache2/mods-available/mpm_worker.conf <<EOL
<IfModule mpm_worker_module>
	StartServers			 1
	MinSpareThreads		 5
	MaxSpareThreads		 15
	ThreadLimit			 25
	ThreadsPerChild		 5
	MaxRequestWorkers	  25
	MaxConnectionsPerChild   200
</IfModule>
EOL

a2dismod status

echo -e "${GREEN}Configuration of apache mods was succesfully finished!
Restarting Apache & MySQL services...${NC}"

service apache2 restart
service mysql restart

echo -e "${GREEN}Services succesfully restarted!${NC}"
sleep 3

echo -e "${GREEN}Adding user & database for WordPress, setting wp-config.php...${NC}"
echo -e "Please, set username for database: "
read db_user
echo -e "Please, set password for database user: "
read db_pass

mysql -u root -p <<EOF
CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
CREATE DATABASE IF NOT EXISTS $db_user;
GRANT ALL PRIVILEGES ON $db_user.* TO '$db_user'@'localhost';
ALTER DATABASE $db_user CHARACTER SET utf8 COLLATE utf8_general_ci;
EOF

	cat >/var/www/$username/$websitename/www/wp-config.php <<EOL
<?php

define('DB_NAME', '$db_user');

define('DB_USER', '$db_user');

define('DB_PASSWORD', '$db_pass');

define('DB_HOST', 'localhost');

define('DB_CHARSET', 'utf8');

define('DB_COLLATE', '');

define('AUTH_KEY',         '$db_user');
define('SECURE_AUTH_KEY',  '$db_user');
define('LOGGED_IN_KEY',    '$db_user');
define('NONCE_KEY',        '$db_user');
define('AUTH_SALT',        '$db_user');
define('SECURE_AUTH_SALT', '$db_user');
define('LOGGED_IN_SALT',   '$db_user');
define('NONCE_SALT',       '$db_user');

\$table_prefix  = 'wp_';

define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
EOL

chown -R $username:$username /var/www/$username
echo -e "${GREEN}Database user, database and wp-config.php were succesfully created & configured!${NC}"
sleep 3
echo -e "Installation & configuration succesfully finished.\n Bye!"

}





#==============================
#           MENU
#==============================

function BOSSMENU()
{
echo -e -n "\n\t${GREEN}${BGBlack}==== MAIN MENU ====${NC}\n"
echo -e -n "${Yellow}
\t1. Create SSH key ${NC} ${Purple}
\t2. LEMP
\t2. LAMP      
${RED}\n\tq. Quit...       ${NC}";

}


#   subMENU 1
function SUBMENUONE()
{
M="= = = = =";
title="Generate SSH Key";
echo -e -n "\n\t${GREEN}${M} SSH KeyGen ${M}${NC}\n"
echo -e -n "
\t1. $title ${CYAN}ED25519${NC}
\t2. $title ${PURPLE}RSA${NC}
\t3. $title ${BLUE}DSA${NC}
\t4. $title ${GREEN}ECDSA${NC}
\t5. $title ${RED}EdDSA${RED} - [OFF]${NC}
${RED}\n\t0. Back ${NC}\n";
}

##   subMENU 2
function SUBMENUTWO() {
echo -e -n "\n\t ${GREEN}LEMP installation & Settings:${NC} \n"
echo -e -n "
\t1. Preinstall ${CYAN} Ngx Php7.4 Certbot ${STD}
\t2. Install MySQL ${CYAN}With WordPress land${STD}
\t3. Add one more WordPress land ${CYAN}With New DB-user DB-data WP-admin WP-pass${STD}
${RED}\n\t0. Back ${NC}\n";
} 

##   subMENU 3
function SUBMENUTHREE() {
  echo -e "\n\t ${GREEN}SubMENU 3 OPTIONS:${NC} \n"
  echo -e -n "
\t1. Install LAMP ${CYAN}With WordPress${STD}
${RED}\n\t0. Back ${NC}\n";
} 

#--------------------------
while :
do
showBanner
BOSSMENU
echo -n -e "\n\tSelection: "
read -n1 opt
a=true;
case $opt in

# 1 ----------------------------
1) echo -e "==== Create SSH key ===="
while :
do
showBanner
SUBMENUONE
echo -n -e "\n\tSelection: "
read -n1 opt;
case $opt in
      1) TKEY="ed25519" && OnRUN ;;
      2) TKEY="rsa" && OnRUN ;;
      3) TKEY="dsa" && OnRUN ;;
      4) TKEY="ecdsa" && OnRUN ;;
      5) TKEY="eddsa" && OffRUN ;;
      /q | q | 0) echo -en "${RED}Quit..${NC}"; break ;;
      *) ;;
esac
done
;;

# 2 ----------------------------
2) echo -e "# submenu: MENU 2"
while :
do
showBanner
SUBMENUTWO
echo -n -e "\n\tSelection: "
read -n1 opt;
case $opt in
      1) Preinstall ;;
      2) SQLwpLAND ;;
      3) AddNewWP ;;
      /q | q | 0)break;;
      *) ;;
esac
done
;;


# 3 ----------------------------
3) echo -e "# submenu: MEMU 3"
while :
do
showBanner
SUBMENUTHREE
echo -n -e "\n\tSelection: "
read -n1 opt;
case $opt in
      1) installLAMP ;;
      2) echo -e "MENU 3 - SUBmenu 2" ;;
      3) echo -e "MENU 3 - SUBmenu 3" ;;
      /q | q | 0) break ;;
      *) ;;
esac
done
;;
      /q | q | 0) echo; break ;;
      *) ;;
esac
done
echo "Quit...";
clear;
}; 
sshkeygen

# exit 1