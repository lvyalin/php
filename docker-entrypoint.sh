#!/bin/bash
# 开发模式下启用crontab
if [ "php-fpm" = "$1" ]; then
    service crond start
    exec "$@"
elif [ "php" = "$1" ];then
    exec "$@"
elif [ "phpunit" = "$1" ];then
    exec "$@"
else
    echo "error : run mode not in php-fpm,php,phpunit"
fi