#!/usr/bin/env bash

# Set environment variables for dev
export APP_PORT=${APP_PORT:-8888}
export COMPOSE_API_VERSION=${COMPOSE_API_VERSION:-1.35}

COMPOSE="docker-compose"
PROJECT_DOCKER_DIR_LINK="/var/www/docker"

# Check if soft link /var/www has been created in host file system.
# It is too slow to run tests of handsup-api in docker container since
# there are too many of them. Thus, we will run them via "make test"
# in host machine. However, in order to run tests successfully,
# the host and docker has to use the same filesystem structure
# so tests in the host can find files properly.
# for example, path stored in GOOGLE_CLOUD_KEY_FILE in .env.test has to
# be the same for both docker and host.
if [ ! -L $PROJECT_DOCKER_DIR_LINK ]; then
    echo "soft link to project docker directory not found, creating..."
    sudo ln -s "$(pwd)/docker" $PROJECT_DOCKER_DIR_LINK
    echo "soft link created in $PROJECT_DOCKER_DIR_LINK"
fi

if [ $# -gt 0 ];then
    # if composer is used, pass the rest of the arguments to composer command
    if [ "$1" == "composer" ]; then
        shift 1
        $COMPOSE run --rm \
            -w /var/www \
            php \
            composer "$@"

    # If "art" is used, pass-thru to "artisan"
    # inside a new container
    elif [ "$1" == "art" ]; then
        shift 1
        $COMPOSE run --rm \
            -w /var/www \
            php \
            php artisan "$@"

    # If "test" is used, run unit tests,
    # pass any extra arguments to php-unit

    # @todo the reason why specifying APP_ENV=testing on the command line
    # is because failure in setting APP_ENV environment variable in phpunit.xml.
    # ref: https://github.com/sebastianbergmann/phpunit/issues/2353
    elif [ "$1" == "test" ]; then
        shift 1
            $COMPOSE exec -e APP_ENV=testing \
                -w /var/www \
                php ./vendor/bin/phpunit "$@"
    else
        # If user is not calling 'composer' or 'artisan', simply invoke command
        # the user has intended to.
        $COMPOSE exec php "$@"
    fi

else
    $COMPOSE ps
fi
