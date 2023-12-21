#!/bin/bash

set -e

while getopts s:h:t:d:a:f:p:y:q:e: flag
do
    case "${flag}" in
        s) SKIP_BOOTSTRAP=${OPTARG};;
        h) HOST=${OPTARG};;
        t) DB_TYPE=${OPTARG};;
        d) DB_HOST=${OPTARG};;
        a) DB_NAME=${OPTARG};;
        f) DB_USER=${OPTARG};;
        p) DB_PASS=${OPTARG};;
        y) SITE_NAME=${OPTARG};;
        q) ADMIN_USER=${OPTARG};;
        e) ADMIN_PASS=${OPTARG};;
    esac
done

if [ "$SKIP_BOOTSTRAP" = "false" ]; then
  php /var/www/html/moodle/admin/cli/install.php \
  --chmod=0777 \
  --non-interactive \
  --agree-license \
  --wwwroot="https://$HOST" \
  --dataroot='/var/www/moodledata' \
  --dbtype="$DB_TYPE" \
  --dbhost="$DB_HOST" \
  --dbname="$DB_NAME" \
  --dbuser="$DB_USER" \
  --dbpass="$DB_PASS" \
  --fullname="$SITE_NAME" \
  --shortname="${SITE_NAME,,}" \
  --adminuser="$ADMIN_USER" \
  --adminpass="$ADMIN_PASS" && \
  echo "\$CFG->directorypermissions = 0777;" >> /var/www/html/moodle/config.php; \
  echo "\$CFG->xsendfile = 'X-Accel-Redirect';" >> /var/www/html/moodle/config.php; \
  echo -e "\$CFG->xsendfilealiases = array(\n\t'/dataroot/' => \$CFG->dataroot\n);" >> /var/www/html/moodle/config.php; \
  && chmod 0644 /var/www/html/moodle/config.php;
else
  echo "Not Bootstrapping at the moment";
  mv /var/www/html/moodle/config_bak.php /var/www/html/moodle/config.php;
fi

grep -qe "date.timezone = \${LOCAL_TIMEZONE}" /usr/local/etc/php/conf.d/security.ini || echo "date.timezone = \${LOCAL_TIMEZONE}" >> /usr/local/etc/php/conf.d/security.ini;

php-fpm -D
nginx -g 'daemon off;'

