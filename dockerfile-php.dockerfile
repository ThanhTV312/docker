FROM php:7.3-fdm
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

WORKDIR /home/site
