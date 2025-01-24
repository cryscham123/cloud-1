#!/bin/bash

# if no conf file, create
if [ ! -e /etc/nginx/conf.d/custom.conf ]; then
	cd /etc/nginx/conf.d
	envsubst '$DOMAIN_NAME' < custom.conf.template > custom.conf;
fi

# if certificate is not valid, create new one.
openssl x509 -in /etc/ssl/certs/${DOMAIN_NAME}_cert.pem -text -noout -dates 2> /dev/null
if [ $? -ne 0 ]; then
	cd /etc/ssl/certs;
	openssl req -x509 -newkey rsa:2048 -keyout "${DOMAIN_NAME}_key.pem" -out "${DOMAIN_NAME}_cert.pem" -sha256 -days 3650 -nodes -subj "/C=KR/ST=Seoul/L=Gangnam/O=MyCompany/OU=DevOps/CN=${DOMAIN_NAME}";
fi

exec $1 $2 "$3"
