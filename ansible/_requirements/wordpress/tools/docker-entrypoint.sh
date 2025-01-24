#!/bin/bash

cd /var/www/html

wp core download --allow-root 2> /dev/null

# check wordpress config file
if [ ! -e "wp-config.php" ]; then
  wp config create \
    --allow-root \
    --dbname="$DATABASE_NAME" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="${DB_PRIVATE_IP}:3306"
fi

# check wordpress installed
wp core is-installed --allow-root 2> /dev/null
if [ $? -ne 0 ]; then
  wp core install \
    --allow-root \
    --url="$DOMAIN_NAME" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_NAME" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL" \
    --skip-email \
    --locale="ko_KR"
  wp user create "$USER_NAME" "$USER_EMAIL" \
    --allow-root \
    --user="$ADMIN_NAME" \
    --role="author" \
    --user_pass="$USER_PASSWORD"
fi

# update wordpress
wp core update --allow-root 2> /dev/null

# change owner
chown -R www-data:www-data .

# execute cmd
exec $@
