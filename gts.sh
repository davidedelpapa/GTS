#!/bin/sh

usage()
{
    echo "USAGE:"
    echo "build\t(Re)builds the images."
    echo "start  \tStarts the services."
    echo "stop \tStops the running containers."
    echo "---"
    echo "-h --help \tPrints this help guide."
}

build()
{
    cp .htaccess gts.php ./images/php/
    cp gts_config.ini ./images/php/gts_config.template
    cp -r testing-tiles/ ./images/php/ 

    cd DB-Config
    cp 01_setup-databases.SQL ../images/mysql/docker-unified.sql
    cat 02_setup-tables.SQL >> ../images/mysql/docker-unified.sql
    cat init.SQL >> ../images/mysql/docker-unified.sql
    cd ..

    docker-compose build

    rm -f ./images/mysql/docker-unified.sql
    rm -f ./images/php/gts_config.ini
    rm -f ./images/php/.htaccess
    rm -f ./images/php/gts.php
    rm -rf ./images/php/testing-tiles/
}

start()
{
    docker-compose up -d
}

stop()
{
    docker-compose stop
}

while [ "$1" != "" ]; do
    case $1 in
        start )                 start
                                exit
                                ;;
        stop )                  stop
                                exit;;
        build )                 build
                                exit
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit
    esac
    shift
done
