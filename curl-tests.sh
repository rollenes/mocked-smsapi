#!/bin/sh

base_address=http://localhost:8000

if [ ! -z "$1" ]
    then
     base_address=$1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

#ping
ping=`curl -sS $base_address/ping 2>&1`

if [ $? -ne 0 ]
    then
        echo curl failed with message: \"$ping\"
        exit 1
fi

if [ "pong" != "$ping" ]
    then
        echo ${RED}[NOT OK] - Expected to get \"pong\" . Got: \"$ping\"${NC}
    else
        echo ${GREEN}[OK] - ping${NC}
fi

#unknown resource
unknown_resource=`curl -s -o /dev/null -w "%{http_code}" $base_address/unknown_resource -X POST`
if [ 404 != $unknown_resource ]
    then
        echo ${RED}[NOT OK] - Expected to get \"Unknown resource\" . Got: \"$unknown_resource\" ${NC}
    else
        echo ${GREEN}[OK] - unknown resource${NC}
fi
