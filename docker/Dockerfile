FROM ubuntu:22.04

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt update

RUN apt install -y software-properties-common

RUN add-apt-repository ppa:ondrej/php

ENV MOODLE_DATABASE_SERVER NONE
ENV MOODLE_DATABASE_NAME NONE
ENV MOODLE_DATABASE_USERNAME NONE
ENV MOODLE_DATABASE_PASSWORD NONE
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt install -y apache2 libapache2-mod-php supervisor nano git

RUN apt install -y graphviz aspell ghostscript clamav php8.2 php8.2-pspell php8.2-curl php8.2-gd php8.2-intl php8.2-mysql php8.2-xml php8.2-xmlrpc php8.2-ldap php8.2-zip php8.2-soap php8.2-mbstring

RUN mkdir -p /etc/apache2/ssl

COPY php.ini /etc/php/8.2/apache2/php.ini

COPY *.pem /etc/apache2/ssl/

COPY moodle.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

RUN rm -R *

RUN git clone git://git.moodle.org/moodle.git .

RUN git branch --track MOODLE_402_STABLE origin/MOODLE_402_STABLE

RUN git checkout MOODLE_402_STABLE

RUN mkdir /var/www/html/moodledata

RUN chown -R www-data /var/www/html/moodledata

RUN chmod -R 777 /var/www/html/moodledata

RUN chmod -R 777 /var/www/html

COPY config_bak.php config.php

RUN a2enmod rewrite && a2enmod ssl

EXPOSE 80

EXPOSE 443

CMD ["/usr/bin/supervisord", "-n"]