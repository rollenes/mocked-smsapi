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

#send sms
send_sms=`curl -s ${base_address}/sms.do \
    --data format=json \
    --data username=registered \
    --data password=200f200f200f200f200f200f200f200f \
    --data to=600000000 \
    --data-urlencode message='Zażółć gęślą jaźń' \
    --data encoding=utf-8 \
    2>&1`

assert_equal '{"count":1,"list":[{"id":"1430960475929952160","points":0.065,"number":"48600000000","submitted_number":"600000000","status":"QUEUE","error":null,"idx":null}]}' ${send_sms} "send_sms"
