FROM ubuntu:xenial

MAINTAINER Maciej Miara <mkowalski8@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
	  vim \
      curl \
      sqlite3 \
      php7.0 \
	  php7.0-fpm \
      php7.0-cli \
	  php7.0-bcmath \
	  php7.0-curl \
	  php7.0-intl \
	  php7.0-mcrypt \
	  php7.0-pgsql \
	  php7.0-sqlite3 \
	  php7.0-mbstring \
	  php7.0-zip \
	  php7.0-xml \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php/7.0/fpm/php-fpm.conf \
    && sed -e 's/;listen\.owner/listen.owner/' -i /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -e 's/;listen\.group/listen.group/' -i /etc/php/7.0/fpm/pool.d/www.conf \
    && echo "opcache.enable=1" >> /etc/php/7.0/mods-available/opcache.ini \
    && echo "opcache.enable_cli=1" >> /etc/php/7.0/mods-available/opcache.ini
	&& echo "date.timezone = UTC" >> /etc/php/7.0/cli/php.ini
	&& echo "date.timezone = UTC" >> /etc/php/7.0/fpm/php.ini

RUN sed -i  -e "s/\(post_max_size =\).*/\1 50M/g" /etc/php/7.0/cli/php.ini
RUN sed -i  -e "s/\(upload_max_filesize =\).*/\1 50M/g" /etc/php/7.0/cli/php.ini
RUN sed -i  -e "s/\(max_execution_time =\).*/\1 300/g" /etc/php/7.0/cli/php.ini
RUN sed -i  -e "s/\(post_max_size =\).*/\1 50M/g" /etc/php/7.0/fpm/php.ini
RUN sed -i  -e "s/\(upload_max_filesize =\).*/\1 50M/g" /etc/php/7.0/fpm/php.ini
RUN sed -i  -e "s/\(max_execution_time =\).*/\1 300/g" /etc/php/7.0/fpm/php.ini

EXPOSE 9000

CMD ["service start php7.0-fpm"]
