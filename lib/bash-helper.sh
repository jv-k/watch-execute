# ANSI/VT100 colours
YELLOW='\033[1;33m'
LIGHTYELLOW='\033[0;33m'
RED='\033[0;31m'
LIGHTRED='\033[1;31m'
GREEN='\033[0;32m'
LIGHTGREEN='\033[1;32m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
PURPLE='\033[0;35m'
LIGHTPURPLE='\033[1;35m'
CYAN='\033[0;36m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
BOLD="\033[1m"
INVERT="\033[7m"
RESET='\033[0m'

# Some preset styles
S_NORM="${WHITE}"
S_LIGHT="${LIGHTGRAY}"
S_NOTICE="${GREEN}"
S_QUESTION="${YELLOW}"
S_WARN="${LIGHTRED}"
S_ERROR="${RED}"

# Notification icons
I_OK="✅"; 
I_TIME="⏳"; 
I_STOP="🚫"; 
I_ERROR="❌"; 
I_END="👋🏻"

# NPM environment variables are fetched with cross-platform tool cross-env 
SCRIPT_VER=`npm run get-script-ver -s`
SCRIPT_AUTH_NAME=`npm run get-script-auth -s` 
SCRIPT_AUTH_EMAIL=`npm run get-script-email -s`
SCRIPT_HOME=`npm run get-script-page -s`