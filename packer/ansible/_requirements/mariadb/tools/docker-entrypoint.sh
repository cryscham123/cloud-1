#!/bin/sh

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

MRPW="-u root -p$MYSQL_ROOT_PASSWORD"
DATA_PATH="/var/lib/mysql"

/etc/init.d/mariadb start
if [ ! -d "${DATA_PATH}/mysql" ]; then
	chown mysql:mysql $DATA_PATH
	mysql_install_db \
	--skip-test-db \
	--datadir=$DATA_PATH
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
fi

mysql $MRPW -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"
is_user=$(mysql $MRPW -e "SELECT 1 FROM mysql.user WHERE user='$MYSQL_USER' AND host='%'")
if [ -z "$is_user" ]; then
	mysql $MRPW -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED by '$MYSQL_PASSWORD';"
fi
mysql $MRPW -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'%';"
mysql $MRPW -e "FLUSH PRIVILEGES;"
mysqladmin $MRPW shutdown

exec $@
