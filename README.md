# Node

Based on node:alpine + supervisor ```/etc/supervisor/conf.d/*.conf```

## Environment
```dotenv
RUN_SCRIPTS #/var/www/html/scripts/
```

```yaml
version: '3'
services:
  nginx:
    image: ghcr.io/setnemo/nginx:latest
    environment:
      WEBROOT: '/var/www/html/public'
      CREATE_LARAVEL_STORAGE: '1'
      PHPFPMHOST: 'laravel'
      REAL_IP_HEADER: '1'
      REAL_IP_FROM: '1'
    ports:
      - '${APP_PORT:-80}:80'
    volumes:
      - '.:/var/www/html'
    networks:
      - sail
    depends_on:
      - laravel
  laravel:
    image: ghcr.io/setnemo/php:latest
    environment:
      WEBROOT: '/var/www/html/public'
      PHP_REDIS_SESSION_HOST: 'redis'
      CREATE_LARAVEL_STORAGE: '1'
      ENABLE_XDEBUG: '1'
      PHP_ERRORS_STDERR: '1'
      TZ: 'Europe/Kyiv'
    volumes:
      - '.:/var/www/html'
    networks:
      - sail
    depends_on:
      - postgres
      - redis
  node:
    image: node:alpine
    working_dir: /var/www/html
    tty: true
    ports:
      - '${VITE_PORT:-5173}:5173'
    volumes:
      - ./:/var/www/html
  postgres:
    image: postgres:9.5-alpine
    volumes:
      - "sail-postgres:/var/lib/postgresql/data"
    environment:
      - POSTGRES_USER=${DB_USERNAME}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=${DB_DATABASE}
    ports:
      - "${DB_PORT:-5432}:5432"
    networks:
      - sail
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 10s
      timeout: 5s
      retries: 5
  redis:
    image: 'redis:alpine'
    ports:
      - '${REDIS_PORT:-6379}:6379'
    volumes:
      - 'sail-redis:/data'
    networks:
      - sail
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      retries: 3
      timeout: 5s
networks:
  sail:
    driver: bridge
volumes:
  sail-postgres:
    driver: local
  sail-redis:
    driver: local
```
