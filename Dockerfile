FROM augustash/baseimage:1.0.0
MAINTAINER Pete McWilliams <pmcwilliams@augustash.com>

ARG DEBIAN_FRONTEND="noninteractive"
ARG NGINX_VERSION="1.10.3-1~xenial"

# environment
ENV NGINX_SSL_SUBJECT /C=US/ST=MN/L=Minneapolis/O=August Ash/OU=Local Server/CN=*
ENV NGINX_VIRTUAL_HOST _
ENV NGINX_WORKER_PROCESSES 4
ENV NGINX_WORKER_CONNECTIONS 128
ENV APTLIST \
    gettext-base \
    nginx=$NGINX_VERSION \
    nginx-module-geoip \
    nginx-module-image-filter \
    nginx-module-njs \
    nginx-module-perl \
    nginx-module-xslt \
    openssl

# packages & configure
RUN \
    apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    echo "deb http://nginx.org/packages/ubuntu/ xenial nginx" >> /etc/apt/sources.list && \

    apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends --no-install-suggests $APTLIST $BUILD_DEPS && \

    mkdir -p \
      /config/nginx/conf.d \
      /config/nginx/hosts.d \
      /config/nginx/keys \
      /config/nginx/modules && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stdout /var/log/nginx/error.log && \

    apt-get -yqq purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# root filesystem
COPY rootfs /

# run s6 supervisor
ENTRYPOINT ["/init"]
EXPOSE 80 443
