#!/bin/bash
unset USERNAME
unset FROM_NOW
unset id
unset TEXT
unset DB

IS_DONE=0
OPEN=0
SEARCH=""

PARAMS=""
while (( "$#" )); do
case "$1" in 
-db)
    DB="$2"
    shift
    ;;
-t|--text)
    TEXT="$2"
    shift
    ;;
-i|--id)
    ID="$2"
    shift
    ;;
-du|--due-time)
    FROM_NOW="$2"
    shift
    ;;
-d|--done)
    IS_DONE=1
    shift
    ;;
-o|--open)
    OPEN=1
    shift
    ;;
-un|--username)
    USERNAME="$2"
    shift
    ;;

*)
    PARAMS="$PARAMS $1"
    shift
    ;;
esac 
done
eval set -- "$PARAMS"

if [[ -z "$DB" ]]
then 
    echo "No data base provided."
    exit 127
fi


if [[ ! -z "$TEXT" ]]
then
    if [[ $SEARCH == "" ]]
    then    
        SEARCH="WHERE "
    else
       SEARCH=$SEARCH " AND "
    fi
    SEARCH=$SEARCH" t.title LIKE '%$TEXT%' OR t.description LIKE '%$TEXT%' "
fi

if [[ ! -z "$ID" ]]
then
    if [[ $SEARCH == "" ]]
    then    
        SEARCH="WHERE  "
    else
       SEARCH="$SEARCH AND "
    fi
    SEARCH=$SEARCH"t.tasks_id = $ID"
fi


if [[ ! -z "$FROM_NOW" ]]
then
    DUE_DATE="$(date --date "$FRON_NOW day" "+%F")"
    if [[ $SEARCH == "" ]]
    then    
        SEARCH="WHERE t.due_time >= '$DUE_DATE'"
    else
       SEARCH=$SEARCH" AND t.due_time >= '$DUE_DATE'"
    fi
fi

if [[ ! -z "$USERNAME" ]]
then
    if [[ $SEARCH == "" ]]
    then    
        SEARCH="WHERE "
    else
       SEARCH="$SEARCH AND "
    fi
    SEARCH=$SEARCH" u.username = $USERNAME "
fi


#################################
#      last SEARCHs for user     #
#################################

if [[ $OPEN -ne 0 ]]
then
    if [[ $SEARCH == "" ]]
    then    
        SEARCH="WHERE  "
    else
       SEARCH="$SEARCH AND "
    fi
    SEARCH=$SEARCH"t.done = FALSE"
fi

if [[ $IS_DONE -ne 0 ]]
then
    if [[ $SEARCH == "" ]]
    then    
        SEARCH="WHERE  "
    else
       SEARCH="$SEARCH AND "
    fi
    SEARCH=$SEARCH"t.done = TRUE"
fi

QUERY="select 
    t.tasks_id, 
    u.email, 
    u.username,
    t.title, 
    t.description, 
    p.name,
    b.title,
    t.due_time,
    t.done,
    t.done_at

FROM tasks t 
JOIN users u 
USING (users_id)
JOIN board b
ON (t.board_id = b.board_id)
JOIN priority p
ON (t.priority_id = p.priority_id)
$SEARCH;"


STRING="$(sqlite3 $DB "$QUERY")"

echo $STRING