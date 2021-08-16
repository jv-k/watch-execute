#!/bin/bash

MODULE_DIR="$(dirname "$(realpath "$0")")"

source $MODULE_DIR/lib/helper.sh

function eval_command() {
  "$@";
}

function show_help() {
    local SCRIPT_VER SCRIPT_AUTH_EMAIL SCRIPT_AUTH_NAME SCRIPT_HOME
    # NPM environment variables are fetched with cross-platform tool cross-env 
    SCRIPT_VER=`cd $MODULE_DIR && npm run get-pkg-ver -s`
    SCRIPT_AUTH_NAME=`cd $MODULE_DIR && npm run get-pkg-auth -s` 
    SCRIPT_AUTH_EMAIL=`cd $MODULE_DIR && npm run get-pkg-email -s`
    SCRIPT_NAME=`cd $MODULE_DIR && npm run get-pkg-name -s`
    SCRIPT_HOME=`cd $MODULE_DIR && npm run get-pkg-page -s`

    echo -e "\n${S_NORM}${BOLD}Usage:${RESET}"\
            "\n${SCRIPT_NAME} <file to watch> <bash command to execute on change>\n"; 

    echo -e "${S_NORM}${BOLD}Credits:${S_LIGHT}"\
            "\n${SCRIPT_AUTH_NAME} <${SCRIPT_AUTH_EMAIL}> ${RESET}"\
            "\n${SCRIPT_HOME}\n"

}

# Process script options
process_args() {
    local OPTIONS    
    
    # Show help on -h switch
    while getopts ":h" OPTIONS; do
        case $OPTIONS in
            h ) # display Help
                show_help
                exit;;
            \? ) # Invalid option
                echo -e "\n${I_ERROR}${S_ERROR} Invalid option: ${S_WARN}-$OPTARG" >&2
                show_help
                exit;;
        esac
    done

    WATCH_FILE=$1
    EXEC_CMD=$2

    # Ensure file and command arguments are proper.
    if [ -z "$WATCH_FILE" ] && [ -z "$EXEC_CMD" ]; then
        show_help
        exit 1
    fi

    if [ -z "$WATCH_FILE" ] || [ -z "$EXEC_CMD" ]; then
        echo -e "\n${I_ERROR} ${S_ERROR} Invalid options supplied."
        show_help
        exit 1
    fi

    if [ ! -f $WATCH_FILE ]; then
        echo -e "\n${I_ERROR}${S_ERROR} File ${BOLD}<$WATCH_FILE>${S_ERROR} does not exist."
        show_help
        exit 1
    fi
}

function run_daemon() {
    echo -e "\n${I_TIME} $S_LIGHT Watching <${S_NORM}${WATCH_FILE}${S_LIGHT}> + executing command \`${S_NORM}${EXEC_CMD}\` ${S_LIGHT}on changes..."
    echo -e "\n${S_QUESTION}Press Ctrl-C to exit"
    echo -e "${RESET}"

    chsum1=""
    while [[ true ]]
    do
        chsum2=`find $WATCH_FILE -type f -exec md5 {} \;`
        if [ "$chsum1" != "$chsum2" ]; then           
            if [ -n "$chsum1" ]; then
                eval_command "$EXEC_CMD"
            fi
            chsum1=$chsum2
        fi
        sleep 1
    done
}

process_args "$@"
run_daemon
