#!/usr/bin/with-contenv bash

# if the web root is empty, activate sample index page
if [[ $(find /src/ -maxdepth 0 -empty | wc -l) -eq 1 ]]; then
    echo "==> Generating sample index page"
    cp /defaults/index.html /src
fi

# enable Nginx modules
if [[ $(find /config/nginx/modules/ -maxdepth 0 -empty | wc -l) -eq 1 ]]; then
    echo "==> Moving Nginx modules"
    mv /usr/lib/nginx/modules/* /config/nginx/modules/
fi

# copy fastcgi parameters
if [[ ! -f /config/nginx/fastcgi_params ]]; then
    echo "==> Copying Nginx FastCGI Parameters"
    cp /etc/nginx/fastcgi_params /config/nginx/
fi
