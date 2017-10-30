#!/bin/bash
# 开发模式下启用crontab
if [ "php-fpm" = "$1" ]; then
    service crond start
    nginx -g "daemon off;"
    exec "$@"
else
    exec "$@"
fi