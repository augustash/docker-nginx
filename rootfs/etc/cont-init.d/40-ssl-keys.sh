#!/usr/bin/with-contenv bash

# generate new cert if necessary
if [[ -f /config/nginx/keys/web.pem ]]; then
    echo "==> Using existing SSL keys"
else
    echo "==> Generating self-signed SSL keys"
    openssl req -newkey rsa:4096 -x509 -days 365 -nodes \
        -out /config/nginx/keys/web.crt -keyout /config/nginx/keys/web.key \
        -subj "$NGINX_SSL_SUBJECT" &>/dev/null
    openssl dhparam -out /config/nginx/keys/dh2048.pem 2048
    cat /config/nginx/keys/web.crt /config/nginx/keys/web.key > /config/nginx/keys/web.pem
fi

# reset permissions on generated certificates
chmod 0400 /config/nginx/keys/*
chmod 0644 /config/nginx/keys/web.crt
