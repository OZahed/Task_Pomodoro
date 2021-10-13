#!/bin/bash

PARAMS=""
DONE=0
PRIORITY=1
while (( "$#" )); do
    case "$1" in 
        -db)
            DB="$2"
            shift
        ;;
        -r|--remove)
            REMOVE=1
            shift
        ;;
        -b|--board)
            BOAERD_ID="$2"
            shift
        ;;
        -i|--id)
            ID="$2"
            shift
        ;;
        -t|--title)
            TITLE="$2"
            shift
        ;;
        -de|--description)
            DESCRIPTION="$2"
            shift
        ;;
        -du|--due-time)
            FROM_NOW="$2"
            shift
        ;;
        -p|--prioroty)
            case "$2" in 
                -m|--normal)
                    PRIORITY=1
                ;;
                -h|--high)
                    PRIORITY=2
                ;;
                -u|--urgent)
                    PRIORITY=3
                ;;
                -l|--low)
                    PRIORITY=4                   
            esac
            shift
        ;;
        -un| --username) 
            USERNAME="$2"
            shift
        ;;
        -d)
            DONE=1
            shift
        ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
        ;;
    esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"


######
#  Data validation
######

if [[ -z "$DB" ]]
then
    echo "No DB Provicded"
    exit 1
fi

###########################
#  check if task is done  #
###########################
if [[ $DONE -eq 1  ]]
then 
    if [[ -z $ID  ]] && [[ -z $TITLE ]]
    then 
        echo "you should provide id'-i' or title '-t' to mark task as Done '-d | --done' "
        exit 127
    fi

    if [[ -z $TITLE  ]]
    then
        sqlite3 $DB "UPDATE tasks SET done=TRUE WHERE tasks_id=$ID"
        echo "Task id=$ID,  Marked  as Done"
    fi
    if [[ -z $ID ]]
    then
        sqlite3 $DB "UPDATE tasks SET done=TRUE WHERE title='$TITLE'"
        echo "Task(s) title=$TITLE Marked Done"
    fi
    exit 0
fi


if [[ $REMOVE -eq 1 ]]
then
    if [[ -z $ID ]] && [[ -z $TITLE ]]
    then 
        echo "you should provide id'-i' or title '-t' to mark task as Done '-r | --remove' "
        exit 127
    fi
    if [[ -z $ID ]]
    then 
        sqlite3 $DB "DELETE FROM tasks WHERE title='$TITLE'"
        echo "Task(s) title=$TITLE Deleted"
    fi
    if [[ -z $TITLE ]]
    then
        sqlite3 $DB "DELETE FROM tasks WHERE tasks_id='$ID'"
        echo "Task id=$ID, Deleted"
    fi
    exit 0
fi



if [[ -z "$USERNAME" ]]
then 
    USERID="$(sqlite3 $DB 'SELECT users_id FROM users LIMIT 1')"
else
    USERID=$(sqlite3 $DB "SELECT users_id FROM users WHERE username='$USERNAME'")
fi

if [[ -z "$USERID" ]]
then 
    echo "User name is invalid"
    exit 1
fi

if [[ -z "$TITLE" ]]
then 
    echo "Title is required
use -t or --title <title>
"
    exit 1
fi

DAY_RE='^[0-9]+$'
if [[ ! $FROM_NOW =~ $DAY_RE ]]
then
    if [[ ! -z $FROM_NOW ]]
    then 
        echo "-du should be an integer From today "
        exit 1
    fi
fi



if [[ -z $BOAER_ID ]]
then 
    echo "Task added to the default board"
    BOAER_ID=1
fi

DUE_DATE="$(date --date "$FROM_NOW day " "+%F")"

sqlite3 $DB "INSERT INTO tasks  (
    users_id,
    priority_id,
    board_id,
    title,
    description,
    due_time
    )  VALUES (
    $USERID,
    $PRIORITY,
    $BOAER_ID,
    '$TITLE',
    '$DESCRIPTION',
    '$DUE_DATE');"
