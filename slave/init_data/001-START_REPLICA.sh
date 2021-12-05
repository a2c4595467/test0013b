#!/bin/sh

#until mysqladmin ping -h$SOURCE_MYSQL_HOST -u$SOURCE_MYSQL_USER -p$SOURCE_MYSQL_PASSWORD --silent; do
#  sleep 1
#done

# -- confirm environment variable --
# echo "MASTER_HOST = "$MYSQL_MASTER_HOST
# echo "MASTER_USER = "$MYSQL_REPLICA_USER
# echo "MASTER_PASSWORD = "$MYSQL_ROOT_PASSWORD

# mysql -uroot -p$MYSQL_ROOT_PASSWORD -e" \
#   CHANGE MASTER TO \
#     MASTER_HOST = '$MYSQL_MASTER_HOST', \
#     MASTER_PORT = 3306, \
#     MASTER_USER = '$MYSQL_REPLICA_USER', \
#     MASTER_PASSWORD = '$MYSQL_ROOT_PASSWORD', \
#     MASTER_AUTO_POSITION = 1; \
#   START SLAVE; \
# "

# mysql -uroot -p$MYSQL_ROOT_PASSWORD -e" \
#   CHANGE MASTER TO \
#     MASTER_HOST = '$MYSQL_MASTER_HOST', \
#     MASTER_PORT = 3306, \
#     MASTER_USER = '$MYSQL_REPLICA_USER', \
#     MASTER_PASSWORD = '$MYSQL_ROOT_PASSWORD', \
#     MASTER_AUTO_POSITION = 1, \
#     MASTER_SSL = 1,
#     MASTER_SSL_CA = '/var/lib/mysql/ca.pem', \
#     MASTER_SSL_CERT = '/var/lib/mysql/server-cert.pem', \
#     MASTER_SSL_KEY = '/var/lib/mysql/server-key.pem'; \
#   START SLAVE; \
# "

# mysql -uroot -p$MYSQL_ROOT_PASSWORD -e" \
#   CHANGE MASTER TO \
#     MASTER_HOST = '$MYSQL_MASTER_HOST', \
#     MASTER_PORT = 3306, \
#     MASTER_USER = '$MYSQL_REPLICA_USER', \
#     MASTER_PASSWORD = '$MYSQL_ROOT_PASSWORD', \
#     MASTER_AUTO_POSITION = 1, \
#     MASTER_SSL = 1, \
#     GET_MASTER_PUBLIC_KEY = 1; \
#   START SLAVE; \
# "

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e" \
  CHANGE MASTER TO \
    MASTER_HOST = '$MYSQL_MASTER_HOST', \
    MASTER_PORT = 3306, \
    MASTER_USER = '$MYSQL_REPLICA_USER', \
    MASTER_PASSWORD = '$MYSQL_ROOT_PASSWORD', \
    MASTER_AUTO_POSITION = 1, \
    GET_MASTER_PUBLIC_KEY = 1; \
  START SLAVE; \
"
