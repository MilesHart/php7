FROM php:7.1-apache

#ENV APACHE_DOCUMENT_ROOT /path/to/new/root
ENV APACHE_DOCUMENT_ROOT=/public
ENV PHP_INI_DIR=/usr/local/etc/php

#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
#RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN mkdir /var/www/html${APACHE_DOCUMENT_ROOT}

COPY phpinfo.php /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN mv "${PHP_INI_DIR}/php.ini-development" "${PHP_INI_DIR}/php.ini"
RUN apt-get update
# Use the default production configuration
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Override with custom opcache settings
#COPY config/opcache.ini /usr/local/etc/php/conf.d/

#RUN apt-get -y install unixodbc-dev
RUN apt-get update
RUN apt-get install -y unixodbc-dev
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN echo "extension= sqlsrv.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` 
RUN echo "extension= pdo_sqlsrv.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`