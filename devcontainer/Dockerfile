FROM --platform=linux/amd64 ubuntu:jammy-20240911.1

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zagreb

RUN apt update && \
    apt install -y --no-install-recommends \
    software-properties-common \
    imagemagick \
    gpg-agent \
    bash-completion \
    npm \
    git \
    wget \
    rsync \
    less \
    vim \
    zip \
    ssh \
    unzip \
    socat \
    libfcgi \
    build-essential \
    python2 \
    python3-pip \
    curl \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    xdg-utils && \
    add-apt-repository -y ppa:ondrej/php && \
    add-apt-repository -y ppa:ondrej/nginx && \
    bash -c "apt install -y --no-install-recommends php{5.6,7.0,7.1,7.2,7.3,7.4,8.0,8.1,8.2}-{bcmath,curl,exif,fpm,gd,iconv,imagick,intl,mbstring,memcached,mysqli,opcache,redis,sockets,sqlite3,xml,xsl,zip} php-sodium"
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
    s/^;date\.tcimezone =$/date.timezone = Europe\/Zagreb/;\
    s/^session\.gc_maxlifetime .*$/session.gc_maxlifetime = 86400/;\
    s/^memory_limit = .*$/memory_limit = 256M/;\
    /^;error_log = syslog$/a error_log = /var/log/php$(echo $v | tr -d .).error.log" "/etc/php/$v/fpm/php.ini"; done && mkdir /run/php
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --version=1.10.26 --filename=composer1 --install-dir=/usr/local/bin && \
    php composer-setup.php --version=2.2.25 --filename=composer2 --install-dir=/usr/local/bin && \
    rm composer-setup.php
RUN /usr/bin/env php7.4 /usr/local/bin/composer2 global require deployer/deployer:6.8.0
ENV PATH="/root/.config/composer/vendor/bin:$PATH"
RUN apt install -y --no-install-recommends nginx && rm -rf /etc/nginx/sites-enabled/default && rm -rf /etc/nginx/sites-available/default
RUN pip install supervisor
RUN wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh && bash install.sh && rm install.sh
COPY nvm/default-packages /root/.nvm/default-packages
RUN wget https://cs.symfony.com/download/php-cs-fixer-v3.phar -O php-cs-fixer && chmod a+x php-cs-fixer && mv php-cs-fixer /usr/local/bin/php-cs-fixer
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony
