#!/usr/bin/env bash

# Set environment variables for dev
export APP_PORT=${APP_PORT:-8888}
export COMPOSE_API_VERSION=${COMPOSE_API_VERSION:-1.35}

COMPOSE="docker-compose"

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
