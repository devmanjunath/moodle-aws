#!/bin/bash

sudo apt update
sudo apt install -y nginx-full
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt install -y php8.0 php8.0-{fpm,common,mbstring,xmlrpc,soap,gd,xml,intl,mysql,cli,mcrypt,ldap,zip,curl}

upload_max_filesize=256M
post_max_size=64M
max_execution_time=360
max_input_vars=5000

for key in upload_max_filesize post_max_size max_execution_time max_input_vars
do
 sed -i "s/^\($key\).*/\1 $(eval echo = \${$key})/" php.ini
done