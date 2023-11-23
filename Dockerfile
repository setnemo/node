FROM node:alpine
WORKDIR /var/www/html
COPY ./start.sh /start.sh
RUN set -ex \
    && apk update \
    && apk add linux-headers openssl-dev pcre2-dev zlib-dev openssl abuild \
               musl-dev libxslt libxml2-utils make mercurial gcc unzip git \
               xz g++ coreutils vim bash bat \
    && rm -rf /tmp/packages \
        && apk add --no-cache tzdata \
        && apk add --no-cache curl ca-certificates \
        && apk add --no-cache supervisor \
    && mkdir -p /var/log/supervisor \
    && chmod +x /start.sh
CMD ["/start.sh"]
