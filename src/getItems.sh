#!/bin/bash
unset USERNAME
unset FROM_NOW
unset id
unset TITLE
unset DB

IS_DONE=0
SEARCH=""
while (( "$#" )); do
case "$1" in 
-db)
    DB="$2"
    shift
    ;;
-t|--title)
    TITLE="$2"
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
    shoft
    ;;
-o|--open)
    IS_DONE=0
    shift
    ;;
-un|--username)
    USERNAME="$2"
    shift
    ;;
esac 
done