FROM debian:10-slim 


RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    debconf-utils && \
    echo mariadb-server mysql-server/root_password password vulnerables | debconf-set-selections && \
    echo mariadb-server mysql-server/root_password_again password vulnerables | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    mariadb-server \
    php \
    php-mysql \
    php-pear \
    php-gd \
#additional utils for debug and test
    iputils-ping \
    strace \
    curl \
    net-tools \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#COPY php.ini /etc/php5/apache2/php.ini
#COPY php.ini /etc/php/7.0/apache2/php.ini
RUN sed -i 's/allow_url_include = Off/allow_url_include = On/g' /etc/php/7.3/apache2/php.ini

COPY . /var/www/html

COPY config/config.inc.php.dist /var/www/html/config/config.inc.php

RUN chown www-data:www-data -R /var/www/html && \
    rm /var/www/html/index.html


#Remplace mysql conf
COPY config/my.cnf /etc/mysql/

EXPOSE 80
#exposing mariadb for debug purpose
EXPOSE 3306

COPY main.sh /
RUN chmod +x /main.sh
ENTRYPOINT ["/main.sh"]
