FROM node:alpine
COPY conf/supervisord.conf /etc/supervisord.conf
COPY start.sh /start.sh
WORKDIR /var/www/html
RUN set -ex \
    && apk update \
    && apk add --no-cache linux-headers openssl-dev pcre2-dev zlib-dev openssl abuild musl-dev libxslt libxml2-utils make mercurial gcc unzip git xz g++ coreutils vim bash-completion shadow bat \
    && rm -rf /tmp/packages \
        && apk add --no-cache tzdata \
        && apk add --no-cache curl ca-certificates \
        && apk add --no-cache supervisor \
    && mkdir -p /var/log/supervisor \
    && chmod +x /start.sh
EXPOSE 5173
CMD ["/start.sh"]
