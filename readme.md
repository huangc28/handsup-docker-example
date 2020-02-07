# Setup Handsup project with Docker

This example docker-compose setup is explicitly for handsup corporate backend project. However, you might find it useful to setup your own local environment for whatever you are building.

This stack is composed of **PHP@7.2**, **nginx**, **MySQL** and **Redis**.

## Why?

As I came across setting up local dev environment, installing PHP on macos is really a pain in the ass. It took me 3 days to complete the environment setup. Thought it would be useful to have a consistent environment setup guide for future new comers on handsup-api project.

## Clone this project to your root project directory

git clone `git@github.com:huangc28/handsup-docker-example.git`

## Setup environment variables

Paste the following config in your project `.env` spin up docker stack properly:

```
APP_KEY={{ YOUR_KEY }}
DB_HOST=mysql
DB_PORT=3306
DB_PASSWORD={{ YOUR_DB_PASSWORD }}

PERSISTENT_REDIS_HOST=redis
QUEUE_REDIS_HOST=redis
CACHE_REDIS_HOST=redis
```

Note that you also have to paste [application config](https://github.com/huangc28/handsup-docker-example/wiki/handsup-api-application-environment-variables) in your `.env` file. Missing some of the application configs might cause handsup project fail to start. **GCP project ID** and **facebook relative credentails** are known keys that are needed.


Try `php artisan optimize:clear` if ENV doesn't update.

It is mandatory to specify `APP_KEY` for laravel project. Please prompt `php artisan key:g` to generate a new application key and put that in `APP_KEY`.

## docker-compose.example.yml

Move `docker-compose.example.yml` to your `handsup-api` root project directory.

## [REQUIRED] Move your public / private key to docker/php

Move your `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` to `docker/php`. The reason being that we need ssh key to pull dependencies from handsup private registry.

## [OPTIONAL] Handling HTTPS

There are two way to handle https request: 
- Mount the SSL key pair into docker container. Setup SSL key pair path in `docker/nginx/nginx.conf` 

- Handles SSL traffic before proxying the traffic to docker

If you already have a webserver (like caddy) setup on host to handle https traffic, you can bypass this part as you can simply proxy decrypted traffic to nginx container.

The following demonstrates how to handle SSL traffic in nginx docker container

### Handle HTTPS traffic in nginx container

Generate a local SSL certificate using [mkcert](https://github.com/FiloSottile/mkcert). you will get two files

  - `{{ YOUR_DOMAIN }}.key.pem`
  - `{{ YOUR_DOMAIN }}.pem`

Rename `{{ YOUR_DOMAIN }}.key.pem` to `{{ YOUR_DOMAIN }}.key` and place it in `docker/nginx`.
Rename `{{ YOUR_DOMAIN }}.pem` to `{{ YOUR_DOMAIN }}.crt` and place it in `docker/nginx`.

**nginx/nginx.conf**

```
server {
  listen 443 ssl;
  server_name _;
  charset utf-8;
  index index.html index.php;
  root /var/www/public;

  ssl_certificate /var/www/docker/nginx/handsup.test.crt;
  ssl_certificate_key /var/www/docker/nginx/handsup.test.key;

  ...
}
```

Don't forget to expose `:443` to host to handle SSL traffic from host. This can be setup in `docker-composer.yml` file.

```
nginx:
  restart: always
  container_name: handsupapi_nginx_1
  build:
    context: ./docker/nginx
  ports:
    - "${APP_PORT}:80"
    - "444:443" # https traffic from host https://localhost:444 will be proxied to 443 port of the nginx container.
  volumes:
    - .:${PROJECT_PATH}
  networks:
    - handsup-net
  depends_on:
    - php
```

## spin up and run!

prompt `docker-compose up` to spin up the stack. prompt `http://localhost:8888` in the browser, you should see laravel index page. you are ready to go!

## setup Laravel

Move `develper.example.sh` to your `handsup-api` root project directory.
prompt `./develper.sh composer install` to install the framework's dependencies.


