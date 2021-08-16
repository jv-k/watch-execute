#!/bin/bash

function eval_command() {
  "$@";
}

function daemon() {
    chsum1=""

    while [[ true ]]
    do
        chsum2=`find $1 -type f -exec md5 {} \;`
        if [ "$chsum1" != "$chsum2" ]; then           
            if [ -n "$chsum1" ]; then
                eval_command "$2"
            fi
            chsum1=$chsum2
        fi
        sleep 1
    done
}

WATCH_FILE=$1
EXEC_CMD=$2

daemon $WATCH_FILE $EXEC_CMD
