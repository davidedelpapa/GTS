#!/bin/bash

# This script gives me the possibility to add hooks for 
# any docker-compose command and process.
# Not implemented docker-compose commands can be run from docker-compose itself.
#
# Added also a useful shorthand for getting any container's prompt
# and to get a mysql shell from the respective container while running.
#
# Note: very simplistic approach. No test, no exeception handled, 
# very open to hacks of whatever kind. 
# It does not even test if docker-compose is running at all.

# Routines for .ini files. !DANGER! Use at your own risk!
get_conf_()
{
    result=($(grep -n "$2" $1 | while read -r line; do echo $line | tr ' ' '\n' | tail -1; done))
}
get_conf()
{
    get_conf_ $1 $3
    echo ${result[${2:-0}]}
}
INI=gts_config.ini
INI_MYSQL=0
#MYSQL_HOST=$(get_conf $INI $INI_MYSQL host)
#Override gts_config.ini, in order to use outside containers...
MYSQL_HOST="127.0.0.1"
MYSQL_PORT=$(get_conf $INI $INI_MYSQL port)
MYSQL_DATABASE=$(get_conf $INI $INI_MYSQL database)
MYSQL_USER=$(get_conf $INI $INI_MYSQL user)
MYSQL_PASSWD=$(get_conf $INI $INI_MYSQL password)

usage()
{
    echo -e "\nUsage:\n"
    echo -e "build\t(Re)builds the images."
    echo -e "start\tStarts the services."
    echo -e "stop \tStops the running containers."
    echo -e "\n--------- Stats -----------"
    echo -e "ps \t\t\tShows running containers and some stats."
    echo -e "stats [container-name]\tShows running container(s) and some stats."
    echo -e "\t\t\tNote: Stats in real time; <Ctrl+C> to stop visualizing."
    echo -e "\n------- Get Shells --------"
    echo -e "sh           <image-name>    \tGet a shell from a container image."
    echo -e "hot-sh | hsh <container-name>\tGet a shell from a running image."
    echo -e "\n--- Get Services Shells ---"
    echo -e "mysql \tGet a mysql shell from the mysql container."
    echo -e "\n--------- Other -----------"
    echo -e "-h --help \tPrints this help guide."
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

get_running_containers_()
{
    result=($(docker-compose ps -q | while read -r line; do echo $line; done))
}
get_running_containers()
{
    get_running_containers_
    echo ${result[*]}
}

stats()
{
    containers=$(get_running_containers)
    docker stats --format "table {{.Name}}\t{{.CPUPerc}}  {{.MemPerc}}  {{.MemUsage}}\t{{.NetIO}}" ${1:-$containers}
}

sh()
{
    docker run -it $1 /bin/bash
}

hsh()
{
    docker exec -it $1 bash
}

mysql()
{
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE
}

adduserp()
{
    A_USER=$1
    A_PKEY=$2
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "insert into Users(username) values('%s'); insert into pkeys(pkey, userid) values('%s', (select Users.userid from Users where username = '%s')); select Users.userid as user, username, pkey as pkeys from Users join pkeys on Users.userid = pkeys.userid where username = '%s';" "$A_USER" "$A_PKEY" "$A_USER" "$A_USER")"
}

adduser()
{
    A_USER=$1
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "insert into Users(username) values('%s'); select userid as user, username  from Users where username = '%s';" "$A_USER" "$A_USER")"
}

deluser()
{
    D_USER=$1
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "select Users.userid as user, username from Users where username = '%s'; delete from pkeys where pkeys.userid = (select Users.userid from Users where username = '%s'); delete from Users where username = '%s';" "$D_USER" "$D_USER" "$D_USER")"
}

deluserid()
{
    D_USERID=$1
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "select username, pkey as 'pkeys connected' from Users join pkeys on Users.userid = pkeys.userid where Users.userid = '%s'; select Users.userid as user, username, count(pkey) as pkeys from Users join pkeys on Users.userid = pkeys.userid where Users.userid = '%s'; delete from pkeys where pkeys.userid = '%s'; delete from Users where userid = '%s'; select concat ('Updated ', row_count(), ' rows') as 'Success!'; " "$D_USERID" "$D_USERID" "$D_USERID")"
}

addpkey()
{
    A_USER=$1
    A_PKEY=$2
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "insert into pkeys(pkey, userid) values('%s', (select Users.userid from Users where username = '%s')); select Users.userid as user, username, pkey as pkeys from Users join pkeys on Users.userid = pkeys.userid where username = '%s';" "$A_PKEY" "$A_USER" "$A_USER")"
}

addpkeyuserid()
{
    A_USERID=$1
    A_PKEY=$2
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "insert into pkeys(pkey, userid) values('%s', (select Users.userid from Users where Users.userid = '%s')); select Users.userid as user, username, pkey as pkeys from Users join pkeys on Users.userid = pkeys.userid where Users.userid = '%s';" "$A_PKEY" "$A_USERID" "$A_USERID")"
}

delpkey()
{
    D_PKEY=$1
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "delete from pkeys where pkey = '%s';" "$D_PKEY")"
}

showuserid()
{
    S_USERID=$1
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "select Users.userid as user, username, pkey as pkeys from Users join pkeys on Users.userid = pkeys.userid where Users.userid = '%s';" "$S_USERID")"
}

showuser()
{
    S_USER=$1
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "select Users.userid as user, username, pkey as pkeys from Users join pkeys on Users.userid = pkeys.userid where username = '%s';" "$S_USER")"
}

showpkey()
{
    S_PKEY=$1
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "$MYSQL_USER" "$MYSQL_PASSWD") -h$MYSQL_HOST --port $MYSQL_PORT -D$MYSQL_DATABASE -e "$(printf "select Users.userid as user, username, pkey as pkey from Users join pkeys on Users.userid = pkeys.userid where pkeys.pkey = '%s';" "$S_PKEY")"
}

test_install()
{
    cd DB-Config
    cat 01_setup-databases.SQL 02_setup-tables.SQL init.SQL > merged.sql
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "root" "test") -h$MYSQL_HOST --port $MYSQL_PORT -e "source merged.sql"
}

test_uninstall()
{
    exec mysql --defaults-extra-file=<(printf "[client]\nuser = %s\npassword = %s" "root" "test") -h$MYSQL_HOST --port $MYSQL_PORT -e "source DB-Config/uninstall.SQL"
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
        stats )                 stats ${2:-""}
                                exit
                                ;;
        sh )                    sh $2
                                exit
                                ;;
        hot-sh | hsh )          hsh $2
                                exit
                                ;;
        mysql )                 mysql
                                exit
                                ;;
        aup | adduserp )        adduserp $2 $3
                                exit
                                ;;
        au | adduser )          adduser $2
                                exit
                                ;;
        addpkey )               addpkey $2 $3
                                exit
                                ;;                
        deluser )               deluser $2
                                exit
                                ;;
        du )                    deluserid $2
                                exit
                                ;;
        dk | delpkey )          delpkey $2
                                exit
                                ;;
        showuser )              showuser $2
                                exit
                                ;;
        shu )                   showuserid $2
                                exit
                                ;;
        ak )                    addpkeyuserid $2 $3
                                exit
                                ;;
        shk | showpkey )        showpkey $2
                                exit
                                ;;
        test-install )          test_install
                                exit
                                ;;
        test-uninstall )        test_uninstall
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
