/bin/sh -c "if [ ! -f /var/www/html/config.php ]; then
        php /var/www/html/admin/cli/install.php \
            --chmod=0777 \
            --non-interactive \
            --agree-license \
            --wwwroot=https://${HOST_NAME} \
            --dataroot=/var/www/moodledata \
            --dbtype=mariadb \
            --dbhost=database \
            --dbname=moodle \
            --dbuser=${DB_USER} \
            --dbpass=${DB_PASSWORD} \
            --fullname=${FULL_SITE_NAME} \
            --shortname=${SHORT_SITE_NAME} \
            --adminuser=admin \
            --adminpass=admin123 && \
            
        sed -i \"/$$CFG->directorypermissions = 0777;/a \\$$CFG->xsendfile = 'X-Accel-Redirect';\\n\\$$CFG->xsendfilealiases = array(\\n\\t'/dataroot/' => \\$$CFG->dataroot\\n);\" /var/www/html/config.php && \
        chmod 0644 /var/www/html/config.php; 
    fi && 
    
    grep -qe 'date.timezone = ${LOCAL_TIMEZONE}' /usr/local/etc/php/conf.d/security.ini || \
    echo 'date.timezone = ${LOCAL_TIMEZONE}' >> /usr/local/etc/php/conf.d/security.ini; 
    
    php-fpm
"