FROM mysql:8.0.23

COPY ./slave/etc/mysql/mysql_slave.cnf /etc/mysql/my.cnf
RUN chmod 644 /etc/mysql/my.cnf
RUN mkdir /var/lib/mysql-files

# ENV MYSQL_USER=${DB_USER}
# ENV MYSQL_PASSWORD=${DB_PASS}
# ENV MYSQL_ROOT_PASSWORD=${DB_PASS}
# #ENV MYSQL_RANDOM_ROOT_PASSWORD=1
#ENV TZ=${TZ}


# ENV SOURCE_MYSQL_HOST=mysql_source
# ENV SOURCE_MYSQL_USER=${DB_USER}
# ENV SOURCE_MYSQL_PASSWORD=${DB_PASS}
# ENV MYSQL_ROOT_PASSWORD=${DB_PASS}
# #ENV MYSQL_RANDOM_ROOT_PASSWORD=1

#ARG SOURCE_MYSQL_HOST=mysql_master
#ARG SOURCE_MYSQL_USER=${DB_USER}
#ARG SOURCE_MYSQL_PASSWORD=${DB_PASS}
#ARG MYSQL_ROOT_PASSWORD=${DB_PASS}
#ARG MYSQL_RANDOM_ROOT_PASSWORD=1
#ARG TZ=${TZ}

RUN apt-get update && \
    apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

RUN { \
    echo '[mysqld]'; \
    echo 'character-set-server=utf8mb4'; \
    echo 'collation-server=utf8mb4_general_ci'; \
    echo '[client]'; \
    echo 'default-character-set=utf8mb4'; \
} > /etc/mysql/conf.d/charset.cnf
