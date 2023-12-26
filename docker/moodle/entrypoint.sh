#!/bin/bash

set -e

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --host-name) 
      host_name="$2" 
      shift 2
      ;;
    --db-type) 
      db_type="$2" 
      shift 2
      ;;
    --db-host) 
      db_host="$2" 
      shift 2
      ;;
    --db-user) 
      db_user="$2" 
      shift 2
      ;;
    --db-pass) 
      db_pass="$2" 
      shift 2
      ;;
    --site-name) 
      site_name="$2" 
      shift 2
      ;;
    --admin-user) 
      admin_user="$2" 
      shift 2
      ;;
    --admin-pass) 
      admin_pass="$2" 
      shift 2
      ;;
    --cache-host) 
      cache_host="$2" 
      shift 2
      ;;
    --skip-bootstrap) 
      skip_bootstrap=true 
      shift
      ;;
    --development)
      development=true
      shift
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
done

if [ ! "$skip_bootstrap" ]; then
  php /var/www/html/moodle/admin/cli/install.php \
  --chmod=0777 \
  --non-interactive \
  --agree-license \
  --wwwroot="https://$host_name" \
  --dataroot='/var/moodledata' \
  --dbtype="$db_type" \
  --dbhost="$db_host" \
  --dbname="moodle" \
  --dbuser="$db_user" \
  --dbpass="$db_pass" \
  --fullname="$site_name" \
  --shortname="${site_name,,}" \
  --adminuser=$admin_user \
  --adminpass=$admin_pass; \
else
  echo "Not Bootstrapping at the moment";\
  mv /var/www/html/moodle/config_bak.php /var/www/html/moodle/config.php;\
  echo "\$CFG->dbhost    = '$db_host';" >> /var/www/html/moodle/config.php;\
  echo "\$CFG->dbuser    = '$db_user';" >> /var/www/html/moodle/config.php;\
  echo "\$CFG->dbpass    = '$db_pass'" >> /var/www/html/moodle/config.php;\
  echo "\$CFG->wwwroot   = 'https://$host_name';" >> /var/www/html/moodle/config.php;\
fi
echo "\$CFG->directorypermissions = 0777;" >> /var/www/html/moodle/config.php; \
echo "\$CFG->xsendfile = 'X-Accel-Redirect';" >> /var/www/html/moodle/config.php; \
echo -e "\$CFG->xsendfilealiases = array(\n\t'/dataroot/' => \$CFG->dataroot\n);" >> /var/www/html/moodle/config.php; \
if [ "$cache_host" ]; then
  echo "\$CFG->session_handler_class = '\core\session\redis';" >> /var/www/html/moodle/config.php; \
  echo "\$CFG->session_redis_encrypt = ['verify_peer' => false, 'verify_peer_name' => false];" >> /var/www/html/moodle/config.php; \
  echo "\$CFG->session_redis_host = '$cache_host';" >> /var/www/html/moodle/config.php; \
fi
if [ "$development" ]; then
  echo "\$CFG->tool_generator_users_password = 'moodle';" >> /var/www/html/moodle/config.php; \
fi

grep -qe "date.timezone = local_timezone" /usr/local/etc/php/conf.d/security.ini || echo "date.timezone = local_timezone" >> /usr/local/etc/php/conf.d/security.ini;

chown -R www-data:www-data /var/moodledata && chmod -R 777 /var/moodledata && chmod -R 0755 /var/www/html/moodle && \
php-fpm -D
nginx -g 'daemon off;'