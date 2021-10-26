#! /bin/bash
# TODO: [ ] add weeks Log and month log
# TODO: [ ] add Done / Close percentage
# TODO: [ ] add report 


TITLE=""
FROM_NOW=""
NUMBER=0
LIST=0
PRIOROTY="Normal"
CAT="N/A"
BASE_DIR="$HOME/.my_tasks"


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
-l|--lsit)
    LIST=1
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


