#! /bin/bash
# TODO: [ ] add weeks Log and month log
# TODO: [ ] add Done / Close percentage
# TODO: [ ] add report 


TITLE=""
FROM_NOW=""
NUMBER=0
LOG=0
PRIOROTY="Normal"
CAT="no cat"
IS_DONE=0
BASE_DIR="$HOME/.my_tasks"
RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PARAMS=""
while (( "$#" )); do
case "$1" in 
-t|--title)
    TITLE="$2"
    shift
    ;;
-du|--due-time)
    FROM_NOW="$2"
    shift
    ;;
-d|--done)
    IS_DONE=1
    NUMBER="$2"
    shift
    ;;
-l|--log)
    LOG=1
    FROM_NOW="$2"
    shift
    ;;
-p|--priority)
    PRIOROTY="$2"
    shift
    ;;
-c|--category)
    CAT="$2"
    shift
    ;;
*)
    PARAMS="$PARAMS $1"
    shift
    ;;
esac 
done
eval set -- "$PARAMS"


###
# We are going to keep data from Monday to monday in each Dir
TODAY="$(date "+%F")"
YEAR="$(date "+%Y")"
YEAR_DIR="$BASE_DIR/$YEAR"
DONE_FILE="$YEAR_DIR/Done.log"
OPEN_FILE="$YEAR_DIR/Open.log"
SEP=")"

#####################
# Set Done 
#####################
if [[ $IS_DONE -ne 0 ]]
then
    if [[ $NUMBER -eq 0  ]]
    then 
        echo "Please specify task number to set done"
    fi
    if [[ ! -f $DONE_FILE ]]
    then 
        touch $DONE_FILE
    fi

    TASK=""
    TASK="$(sed -n -e "/^$NUMBER )/p" $OPEN_FILE)"
    if [[ $TASK = "" ]]
    then
        echo "No such task is Open"
        echo "TASK: number: $NUMBER, task found: $TASK"
        exit 1
    fi
    echo "TASK: $TASK, set to done."
    sed -i "/$TASK/d" $OPEN_FILE
    echo "$TASK DONE: $TODAY" >> $DONE_FILE
    exit 0 
fi


if [[ $LOG -eq 1 ]]
then
    DATE_DONE=0
    DATE_OPEN=0
    OVER_DUE=0 
    if [[ "$FROM_NOW" = ""  ]]
    then
        DATE="$TODAY"
    else
        DATE="$(date --date "$FROM_NOW day" "+%F")"
    fi
    echo ""
    DATE_DONE="$(sed -n -e "/DONE: $DATE/p" $DONE_FILE | wc -l)" 
    DATE_OPEN="$(sed -n -e "/DUE: $DATE/p" $OPEN_FILE | wc -l )"
    printf "${YELLOW}Due To $DATE: $DATE_OPEN task(s): ${NC}\n"
    sed -n -e "/DUE: $DATE/p" $OPEN_FILE
   
    printf "${GREEN}Done At $DATE: $DATE_DONE task(s): ${NC}\n"
    sed -n -e "/DONE: $DATE/p" $DONE_FILE
    
    DUE_TIME="DUE: $DATE"
    OVER="$(awk -v time="$DUE_TIME" -F ' -- ' '{ if ($3 < time) print $0}' $OPEN_FILE | wc -l)"
    printf "${RED}Due Time before $DATE: $OVER task(s): ${NC}\n"
    awk -v time="$DUE_TIME" -F ' -- ' '{ if ($3 < time) print $0 }' $OPEN_FILE
    
    exit 0
fi
##############
# check for the directory in $BASE_DIR
# In later versions I must add Config 
##############
if [[ ! -d "$BASE_DIR" ]]
then
    mkdir $BASE_DIR
fi

if [[ ! -d "$YEAR_DIR" ]]
then 
    mkdir $YEAR_DIR
    touch $OPEN_FILE
    touch $DONE_FILE
fi

if [[ $TITLE = "" ]]
then 
    echo "Can not add an empty task" 
    exit 1
fi

if [[ $FROM_NOW = "" ]]
then
    DUE_TIME="$TODAY"
else
    DUE_TIME="$(date --date "$FROM_NOW day" "+%F" )"
fi

# random UUID
ID="$(tail -1 $OPEN_FILE | cut -d "$SEP" -f 1 )"
ID="$(( ID + 1 ))"
LINE="$ID ) $TITLE -- CAT: $CAT -- DUE: $DUE_TIME -- PRIOR: $PRIOROTY"

echo $LINE >> $OPEN_FILE


