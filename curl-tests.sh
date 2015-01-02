#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

assert_equal(){
    if [ $1 != $2 ]
        then
            echo ${RED}[NOT OK] - Expected to get \"$1\" . Got: \"$2\" ${NC}
        else
            echo ${GREEN}[OK] - $3${NC}
    fi
}

base_address=http://localhost:8000

if [ ! -z "$1" ]
    then
     base_address=$1
fi

#ping
ping=`curl -sS ${base_address}/ping 2>&1`

if [ $? -ne 0 ]
    then
        echo curl failed with message: \"$ping\"
        exit 1
fi

assert_equal "pong" ${ping} "ping"

#unknown resource
unknown_resource=`curl -s -o /dev/null -w "%{http_code}" ${base_address}/unknown_resource -X POST`

assert_equal 404 ${unknown_resource} "unknown resuorce"
