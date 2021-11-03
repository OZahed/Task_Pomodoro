#!/bin/bash
PARAMS=""
DB_PATH="$HOME/.my_tasks/DATA/Task.db"
DONE_FLAG=0
while (( "$#" )); do
  case "$1" in
    --init)
      source ./init.sh -db $DB_PATH;
      exit 0;
      shift 
    ;;
    add|task)
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
    log|report)
      source ./reportTool.sh "$@" -db $DB_PATH;
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

printf "commands are pomo -n 'name' -t 'time'
task -t 'title' .... 
"
