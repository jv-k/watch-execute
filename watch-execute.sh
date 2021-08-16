#!/bin/bash

source lib/bash-helper.sh  

function eval_command() {
  "$@";
}

function show_help() {
    echo -e "\n${S_NORM}${BOLD}Usage:${RESET}"\
            "\nwatch-execute <file to watch> <bash command to execute on change>\n"; 

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
