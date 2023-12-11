sh /tmp/packagecheck.sh 'git zip unzip libpcre3-dev' && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s gd mysqli intl zip xmlrpc soap exif opcache && if pecl install -p -- redis; then pecl install -o -f redis && rm -rf /tmp/pear && docker-php-ext-enable redis; fi; 
if [ -z \"$$(ls -A /var/www/html/config.php)\" ]; then php /var/www/html/moodle/admin/cli/install.php --chmod=0777 --non-interactive --agree-license --wwwroot=https://${HOST_NAME} --dataroot=/var/www/moodle-data --dbtype=${DB_TYPE} --dbhost=${DB_HOST} --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --fullname=${FULL_SITE_NAME} --shortname=${SHORT_SITE_NAME} --adminuser=admin --adminpass=admin123 && sed -i \"/$$CFG->directorypermissions = 0777;/a \\$$CFG->xsendfile = 'X-Accel-Redirect';\\n\\$$CFG->xsendfilealiases = array(\\n\\t'/dataroot/' => \\$$CFG->dataroot\\n);\" /var/www/html/config.php && chmod 0644 /var/www/html/config.php; fi && grep -qe 'date.timezone = ${LOCAL_TIMEZONE}' ${PHP_INI_DIR_PREFIX}/php/conf.d/security.ini || echo 'date.timezone = ${LOCAL_TIMEZONE}' >> /usr/local/etc/php/conf.d/security.ini; php-fpm"