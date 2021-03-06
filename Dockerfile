# Set the base image to centos6.8
FROM centos:6.8

# File Author / Maintainer
MAINTAINER lvyalin lvyalin.yl@gmail.com

# php build
RUN cd /usr/src && yum -y install vim wget pcre-devel libxml2-devel curl-devel libpng-devel gd-devel autoconf zlib-devel gcc make openssl-devel unzip crontabs
RUN cd /usr/src && curl http://php.net/distributions/php-7.1.7.tar.gz -o php-7.1.7.tar.gz && \
 tar xvf php-7.1.7.tar.gz && cd php-7.1.7 && \
 ./configure --prefix=/usr/local/php --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gd --with-jpeg-dir=/usr/lib64/ --with-iconv --with-openssl --with-curl --enable-pcntl --with-zlib --enable-bcmath --enable-json --enable-fpm --enable-mbstring --enable-soap --enable-opcache --enable-zip && \
 make -j4 && make install && yum clean all && cd /usr/src && rm -rf php-7.1.7*

# env path
ENV PATH=$PATH:/usr/local/php/bin:/usr/local/php/sbin/

# extension
RUN cd /usr/src && \
 curl http://pecl.php.net/get/yaf-3.0.4.tgz -o yaf-3.0.4.tgz && tar zxvf yaf-3.0.4.tgz && \
 cd yaf-3.0.4 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && cd /usr/src && rm -rf yaf-3.0.4* && \

 ### yac
 cd /usr/src && \
 curl http://pecl.php.net/get/yac-2.0.1.tgz -o yac-2.0.1.tgz && tar zxvf yac-2.0.1.tgz && \
 cd yac-2.0.1 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && cd /usr/src && rm -rf yaf-3.0.4* && \

 ### redis
 cd /usr/src && \
 curl http://pecl.php.net/get/redis-3.1.1.tgz -o redis-3.1.1.tgz && tar zxvf redis-3.1.1.tgz && \
 cd redis-3.1.1 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && cd /usr/src && rm -rf redis-3.1.1*

 ### phpunit
RUN cd /usr/src && \
 curl https://phar.phpunit.de/phpunit-6.1.4.phar -o phpunit-6.1.4.phar && \
 mv phpunit-6.1.4.phar /usr/local/bin/phpunit && \
 chmod +x /usr/local/bin/phpunit && \

 #### nginx
 cd /usr/src && \
 wget http://nginx.org/download/nginx-1.12.2.tar.gz && \
 tar vxf nginx-1.12.2.tar.gz && cd nginx-1.12.2 && \
 ./configure && make -j4 && make install && mkdir /usr/local/nginx/conf/vhost && \

 #### composer
 cd /usr/src && \
 curl -sS https://getcomposer.org/installer | php && \
 mv composer.phar /usr/local/bin/composer

ENV PATH=$PATH:/usr/local/nginx/sbin/


# config
COPY conf/php-fpm.conf /usr/local/php/etc/
COPY conf/www.conf /usr/local/php/etc/php-fpm.d/
COPY conf/php.ini /usr/local/php/lib/
COPY conf/nginx.conf /usr/local/nginx/conf/
COPY conf/fastcgi_params /usr/local/nginx/conf/
COPY ./docker-entrypoint.sh /usr/local/php/bin/


ENTRYPOINT ["docker-entrypoint.sh"]