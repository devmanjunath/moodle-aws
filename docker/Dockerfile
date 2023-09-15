FROM ubuntu:22.04

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt update

RUN apt install -y software-properties-common

RUN add-apt-repository ppa:ondrej/php

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt install -y apache2 libapache2-mod-php supervisor nano git

RUN apt install -y graphviz aspell ghostscript clamav php8.2 php8.2-pspell php8.2-curl php8.2-gd php8.2-intl php8.2-mysql php8.2-xml php8.2-xmlrpc php8.2-ldap php8.2-zip php8.2-soap php8.2-mbstring

COPY php.ini /etc/php/8.2/apache2/php.ini

RUN mkdir /var/moodledata

RUN chown -R www-data /var/moodledata

RUN chmod -R 777 /var/moodledata

RUN chmod -R 777 /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]