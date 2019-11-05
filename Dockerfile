FROM zimniy/docker-cron:latest

MAINTAINER Dmitriy Safronov <zimniy@cyberbrain.pw>
ENV LANG C.UTF-8

########################################################################################

# Install rsync
RUN apk --update add --no-cache rsync \
    && rm -rf /var/cache/apk/*

# Certs-refresher
COPY ./scripts/ /usr/local/bin/
RUN set -x \
    && echo "#!/bin/sh" > /usr/local/bin/refresh-ssl \
    && echo "certs-refresher /run/secrets/certs-refresher. /run/ssl/" >> /usr/local/bin/refresh-ssl \
    && chown root:root /usr/local/bin/refresh-ssl /usr/local/bin/certs-refresher \
    && chmod 0755 /usr/local/bin/refresh-ssl /usr/local/bin/certs-refresher \
    && echo "@reboot /usr/local/bin/refresh-ssl" > /etc/cron.d/__certs-refresher \
    && echo "*/10 * * * * /usr/local/bin/refresh-ssl" >> /etc/cron.d/__certs-refresher

VOLUME [ "/run/ssl" ]
