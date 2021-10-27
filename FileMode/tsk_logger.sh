#! /bin/bash
# TODO: [X] add report 
# TODO: [X] calculate once 
# TODO: [X] add category log
# TODO: [ ] add priority log 
TITLE=""
FROM_NOW=""
NUMBER=0
LOG=0
PRIOROTY="Normal"
CAT="none"
IS_DONE=0
BASE_DIR="$HOME/.my_tasks"
RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PARAMS=""
while (( "$#" )); do
case "$1" in 
-t|title)
    TITLE="$2"
    shift
    ;;
-du|--due-time)
    FROM_NOW="$2"
    shift
    ;;
-d|done)
    IS_DONE=1
    NUMBER="$2"
    shift
    ;;
-l|log)
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

if  [[ $IS_DONE -eq 0 && $LOG -eq 0 && "$TITLE" = "" ]]
then
    echo "basic usage:
add new task:
    tsk_logger -t or title <title> [options]
        options:
            -c  or --category <category> : String
            -p or --priority <priority value> : String 
            -du or --due-time <N> : number of days from now

see tasks: 
    tsk_logger -l or log <optional number>
    without options it shows todays log
    options:
        if no number is provided It will show today's log
        n : Number of days from now. example: tsk_logger log 7 shows all open \
            tasks within 7 days

        -c or --category <category> : returns categories log
        * -c should be used without from now \
        optin *
set a task to done:
    tsk_logger -d  or done <ID>
        ID: Number of task that will be shown with logs

How it works: 
    All tasks are stored into ~/.my_tasks/<YEAR>/Open.log and Done.log
    to search through tasks it uses awk and sed
    to set done or count tasks it uses sed
"
exit 1
fi

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
    OVER="" 

    if [[ "$CAT" != "none" ]]
    then
        CAT_DONE="$(sed -n -e "/CAT: $CAT/p" $DONE_FILE)"
        CAT_OPEN="$(sed -n -e "/CAT: $CAT/p" $OPEN_FILE)"
        if [[ "$CAT_DOEN" != "" ]]
        then 
            printf "${GREEN} Done With CAT: $CAT: $( wc -l <<< $CAT_DONE) task(s):${NC} \n"
            printf "$CAT_DONE" | sort -t '-' -k 3 -r
            echo ""
        else
            printf "${GREEN} Done With CAT: $CAT: 0 task:${NC} \n"
        fi
        if [[ "$CAT_OPEN" != "" ]]
        then
            printf "${YELLOW} Open With CAT: $CAT: $( wc -l <<< $CAT_OPEN) task(s):${NC} \n"
            printf "$CAT_OPEN" | sort -t '-' -k 3 -r
            echo""
        else 
            printf "${YELLOW} Open With CAT: $CAT: 0 task(s):${NC} \n"
        fi
        exit 0
    fi
    if [[ "$FROM_NOW" = ""  ]]
    then
        DATE="$TODAY"
    else
        if [[ ! $FROM_NOW =~ ^[0-9]+$ ]]
        then 
            echo "N days for log, be a number"
            exit 1
        fi
        DATE="$(date --date "$FROM_NOW day" "+%F")"
    fi
    echo ""
    DATE_DONE="$(sed -n -e "/DONE: $DATE/p" $DONE_FILE)" 
    DATE_OPEN="$(sed -n -e "/DUE: $DATE/p" $OPEN_FILE)"
    printf "${YELLOW}Due To $DATE: $( wc -l <<< $DATE_OPEN) task(s): ${NC}\n"
    #sed -n -e "/DUE: $DATE/p" #OPEN_FILE
    printf "$DATE_OPEN\n"

    printf "${GREEN}Done At $DATE: $(wc -l <<< $DATE_DONE) task(s): ${NC}\n"
    sed -n -e "/DONE: $DATE/p" $DONE_FILE
    
    DUE_TIME="DUE: $DATE"
    OVER="$(awk -v time="$DUE_TIME" -F ' - ' '{ if ($3 < time) print $0}' $OPEN_FILE )"
    if [[ "$OVER" != "" ]]
    then
        printf "${RED}Open tasks with Due Time before $DATE: $( wc -l <<< $OVER ) task(s): ${NC}\n"
        printf "$OVER\n" | sort -t '-' -k 3 -r 
    fi 
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
    if [[ ! $FROM_NOW =~ ^[0-9]+$ ]]
    then
        echo "-du N: N should be a number"
        exit 1
    fi
    DUE_TIME="$(date --date "$FROM_NOW day" "+%F" )"
fi

# Finding the last Id and incrementing it by one
ID="$(tail -1 $OPEN_FILE | cut -d "$SEP" -f 1 )"
((ID++))
echo "$ID )  $TITLE - CAT: $CAT - DUE: $DUE_TIME - PRIORITY: $PRIOROTY" >> $OPEN_FILE
