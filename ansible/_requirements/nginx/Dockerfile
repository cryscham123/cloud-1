FROM debian:bullseye-slim

RUN \
apt-get update -y \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
nginx \
openssl \
gettext \
curl \
&& apt-get clean

COPY conf/custom.conf.template /etc/nginx/conf.d/
COPY tools/* /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
