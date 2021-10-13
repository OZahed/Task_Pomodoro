#!/bin/bash
PARAMS=""
DB_PATH="./DATA/Task.db"
DONE_FLAG=0
while (( "$#" )); do
  case "$1" in
    --init)
      source ./init.sh -db "$DB_PATH";
      exit 0;
      shift 
    ;;
    task)
        source ./newTask.sh "$@" -db $DB_PATH;
        exit 0;
    ;;
    pomo | pomodoro)
        source ./newPomodoro.sh "$@" -db $DB_PATH;
        exit 0;
    ;;
    get)
      source ./getItem.sh "$@" -db $DB_PATH;
      exit 0;
    ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
    ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

echo "My flag arg is:  $NAME"
echo "Done flag is : $DONE_FLAG"

if [[ $DINE_FLAG -eq 0 ]] 
then 
    echo "there is no DONE_FLAG"
fi

