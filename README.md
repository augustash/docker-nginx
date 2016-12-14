![https://www.augustash.com](http://augustash.s3.amazonaws.com/logos/ash-inline-color-500.png)

**This container is not currently aimed at public consumption. It exists as an internal tool for August Ash containers.**

## About

Nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

## TL;DR

```bash
docker-compose up -d
```

## Usage

Launch a single-use Nginx container serving the current directory:

```bash
docker run --rm -it \
    -p 8080:80 \
    -p 8443:443 \
    -v $(pwd):/src \
    augustash/nginx:1.10
```

This container works best with a PHP-FPM container so PHP pages can be served.

**Note:** If your PHP container was started with `docker-compose` and has a network, you'll need to link it differently:

```bash
docker run --rm -it \
    -p 8080:80 \
    -p 8443:443 \
    --link <PHP CONTAINER>:phpfpm \
    --net <NETWORK NAME> \
    -v $(pwd)/site.template:/config/nginx/hosts.d/php_site.conf \
    -v $(pwd):/src \
    augustash/nginx:1.10
```

### Accessing Served Content

The ports `80` and `443` are exposed via this image. To access the Nginx web server from outside the container, you'll need to map ports on your host to the container.

## Configuration

### Mount Custom Configuration

If you need to change configuration values, the best option is to mount your own custom configuration:

```bash
docker run --rm -it \
    -p 8080:80 \
    -p 8443:443 \
    --link <PHP CONTAINER>:phpfpm \
    -v $(pwd):/src \
    -v $(pwd)/site.template:/config/nginx/hosts.d/php_site.conf \
    augustash/nginx:1.10
```

### User/Group Identifiers

To help avoid nasty permissions errors, the container allows you to specify your own `PUID` and `PGID`. This can be a user you've created or even root (not recommended).

### Environment Variables

The following variables can be set and will change how the container behaves. You can use the `-e` flag, an environment file, or your Docker Compose file to set your preferred values. The default values are shown:

- `PUID`=501
- `PGID`=20
- `NGINX_SSL_SUBJECT`=/C=US/ST=MN/L=Minneapolis/O=August Ash/OU=Local Server/CN=*
- `NGINX_VIRTUAL_HOST`=_
- `NGINX_WORKER_PROCESSES`=4
- `NGINX_WORKER_CONNECTIONS`=128

### Custom Nginx/Virtual Host Configuration

The image is prepared in a way to make it relatively easy to customize both Nginx itself and the virtual hosts.

Custom Nginx configuration should be added to `/config/nginx/conf.d/` and custom virtual host files should be added to `/config/nginx/hosts.d/`.

The structure of the directory should look like:

```
/config/nginx
├── conf.d
│   ├── 10-mime.conf
│   ├── 20-logs.conf
│   ├── 30-gzip.conf
│   ├── 40-general.conf
│   └── 50-ssl.conf
├── hosts.d
│   └── default.conf
├── modules
│   ├── ngx_http_geoip_module-debug.so
│   ├── ngx_http_geoip_module.so
│   ├── ngx_http_image_filter_module-debug.so
│   ├── ngx_http_image_filter_module.so
│   ├── ngx_http_js_module-debug.so
│   ├── ngx_http_js_module.so
│   ├── ngx_http_perl_module-debug.so
│   ├── ngx_http_perl_module.so
│   ├── ngx_http_xslt_filter_module-debug.so
│   └── ngx_http_xslt_filter_module.so
└── nginx.conf
```
