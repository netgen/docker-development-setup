FROM ubuntu:jammy-20230126

ARG UID
ARG GID

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zagreb

RUN apt update && \
    apt install -y --no-install-recommends \
        software-properties-common \
        imagemagick \
        gpg-agent \
        npm \
        git \
        wget \
        less \
        vim \
        libfcgi \
        python3-pip \
        curl && \
    add-apt-repository -y ppa:ondrej/php && \
    add-apt-repository -y ppa:ondrej/nginx && \
    bash -c "apt install -y --no-install-recommends php{5.6,7.0,7.1,7.2,7.3,7.4,8.0,8.1,8.2}-{bcmath,curl,exif,fpm,gd,iconv,imagick,intl,mbstring,memcached,mysqli,opcache,redis,sockets,sqlite3,xdebug,xml,xsl,zip} php-sodium"
RUN for v in '5.6' '7.0' '7.1' '7.2' '7.3' '7.4' '8.0' '8.1' '8.2'; do \
sed -E -i '\
s/^pm = dynamic$/pm = ondemand/;\
s/^pm\.max_children = 5$/pm.max_children = 6/;\
s/^;pm\.process_idle_timeout = 10s;$/pm.process_idle_timeout = 15m/;\
s/^;pm\.max_requests = 500/pm.max_requests = 128/;\
s/^;pm\.status_path = \/status$/pm.status_path = \/status/;\
s/^;ping\.path = \/ping$/ping.path = \/ping/;\
s/^;ping\.response = pong$/ping.response = pong/;\
s/php([[:digit:]])\.([[:digit:]])-fpm/php\1\2-fpm/' "/etc/php/$v/fpm/pool.d/www.conf" && \
sed -E -i '\
s/php([[:digit:]])\.([[:digit:]])-fpm/php\1\2-fpm/;\
s/^;daemonize = yes$/daemonize = no/' "/etc/php/$v/fpm/php-fpm.conf" && \
sed -E -i "\
s/^;date\.timezone =$/date.timezone = Europe\/Zagreb/;\
s/^session\.gc_maxlifetime .*$/session.gc_maxlifetime = 86400/;\
s/^memory_limit = .*$/memory_limit = 256M/;\
/^;error_log = syslog$/a error_log = /var/log/php$(echo $v | tr -d .).error.log" "/etc/php/$v/fpm/php.ini"; done && mkdir /run/php
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --version=1.10.26 --filename=composer1 --install-dir=/usr/local/bin && \
    php composer-setup.php --version=2.5.4 --filename=composer2 --install-dir=/usr/local/bin && \
    rm composer-setup.php
RUN apt install -y --no-install-recommends nginx && rm -rf /etc/nginx/sites-enabled/default && rm -rf /etc/nginx/sites-available/default
RUN npm install -g yarn n
RUN pip install supervisor
RUN usermod -u $UID www-data --home /home/www-data && groupmod -g $GID www-data
