FROM resin/rpi-raspbian

MAINTAINER info@jeedom.com

ENV SHELL_ROOT_PASSWORD Mjeedom96

RUN echo "deb http://repozytorium.mati75.eu/raspbian jessie-backports main contrib non-free" > /etc/apt/sources.list.d/php.list

RUN gpg --keyserver pgpkeys.mit.edu --recv-key CCD91D6111A06851
RUN gpg --armor --export CCD91D6111A06851 | apt-key add -

RUN apt-get update && apt-get install -y \
wget \
libssh2-php \
ntp \
unzip \
curl \
openssh-server \
supervisor \
cron \
usb-modeswitch \
python-serial \
nodejs \
npm \
tar \
nano \
libmcrypt-dev \
libcurl4-gnutls-dev \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng12-dev \
libxml2-dev \
sudo \
htop \
net-tools \
python \
ca-certificates \
vim \
git \
g++ \
locate \
mysql-client \
telnet \
man \
usbutils \
libtinyxml-dev \
libjsoncpp-dev \
snmp \
libsnmp-dev \
iputils-ping \
php7.0 \
apache2 \
libapache2-mod-php7.0 \
php7.0-curl \
php7.0-gd \
php7.0-imap \
php7.0-json \
php7.0-mcrypt \
php7.0-mysql \
php7.0-opcache \
php7.0-xmlrpc \
php7.0-pdo \
php7.0-posix \
php7.0-simplexml \
php7.0-sockets \
php7.0-zip \
php7.0-iconv \
php7.0-mbstring \
php7.0-mysqli \
php7.0-soap \
php7.0-snmp \
php7.0-sockets \
php7.0-gd \
php7.0-calendar 

####################################################################PHP7 EXTENSION#######################################################################################


#RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN rm /usr/bin/php
RUN ln -s /usr/bin/php7.0 /usr/bin/php

####################################################################SYSTEM#######################################################################################

RUN echo "root:${SHELL_ROOT_PASSWORD}" | chpasswd && \
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

RUN mkdir -p /var/run/sshd /var/log/supervisor
RUN rm /etc/motd
ADD install/motd /etc/motd
RUN rm /root/.bashrc
ADD install/bashrc /root/.bashrc
ADD install/OS_specific/Docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD install/OS_specific/Docker/init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]

EXPOSE 22 80 162 1886 4025 17100 10000 

#17100 : zibasdom
#10000 : orvibo
#1886 : MQTT
#162 : SNMP
#4025 : DSC