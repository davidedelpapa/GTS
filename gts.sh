#!/bin/sh

# This script gives me the possibility to add hooks for 
# any docker-compose command and process.
# Not implemented docker-compose commands can be run from docker-compose itself.
#
# Added also a useful shorthand for getting any container's prompt.

usage()
{
    echo "USAGE:"
    echo "build\t(Re)builds the images."
    echo "start\tStarts the services."
    echo "stop \tStops the running containers."
    echo "ps   \tShows running containers."
    echo "---"
    echo "sh     <image-name>    \tGet a shell from a container image."
    echo "hot-sh <container-name>\tGet a shell from a running image."
    echo "---"
    echo "-h --help \tPrints this help guide."
}

build()
{
    docker-compose build
}

start()
{
    docker-compose up -d
}

stop()
{
    docker-compose stop
}

ps()
{
    docker-compose ps
}

sh()
{
    docker run -it $1 /bin/bash
}

hsh()
{
    docker exec -it $1 bash
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
        ps )                    ps
                                exit
                                ;;
        sh )                    sh $2
                                exit
                                ;;
        hot-sh )                hsh $2
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
usage
