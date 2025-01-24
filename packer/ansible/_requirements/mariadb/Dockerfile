FROM debian:bullseye-slim

RUN \
apt-get update; \
apt-get upgrade -y; \
apt-get install -y --no-install-recommends \
mariadb-server; \
apt-get clean

RUN \
   sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" "/etc/mysql/mariadb.conf.d/50-server.cnf"; \
   printf "[mariadb]\nhost-cache-size=0\nskip-name-resolve\n" > /etc/mysql/mariadb.conf.d/05-skipcache.cnf;

COPY tools/* /

ENTRYPOINT /docker-entrypoint.sh mysqld_safe
