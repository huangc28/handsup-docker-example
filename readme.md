# Setup Handsup project with Docker

This example docker-compose setup is explicitly for handsup corporate backend project. However, you might find it useful to setup your own local environment for whatever you are building.

This stack is composed of **PHP@7.2**, **nginx**, **MySQL** and **Redis**.

## Why?

As I came across setting up local dev environment, installing PHP on macos is really a pain in the ass. It took me 3 days to complete the environment setup. Thought it would be useful to have a consistent environment setup guide for future new comers on handsup-api project.

## Clone this project to your root project directory

git clone `git@github.com:huangc28/handsup-docker-example.git`

## docker-compose.example.yml

Move `docker-compose.example.yml` to your `handsup-api` root project directory.

## .env.example

Copy and paste the content in `.env.example` file to your `handsup-api` project root `.env` file. The following env variables are needed to spin up `docker-compose` properly.

```
APP_PORT=8888
APP_TSL_PORT=443
SYSTEM_ENV=DOCKER
PROJECT_PATH=/var/www

MYSQL_SERVER=127.0.0.1
MYSQL_PORT=3306
MYSQL_ROOT_PASSWORD=

REDIS_SERVER=127.0.0.1
REDIS_PORT=6379
```

## spin up and run!

prompt `docker-compose up` to spin up the stack. your are ready to go!
