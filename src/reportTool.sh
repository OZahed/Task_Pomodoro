#! /bin/bash


OVER=0
UNDER=0
PIVOT=0  # Pivot table
DAY=0
WEEK=0
SINCE=0

PARAMS=""
while (( "$#" )); do
case "$1" in 
-db)
    DB="$2"
    shift
    ;;
-l|--late)
    OVER=1
    shift
    ;;
-e|--early)
    UNDER=1
    shift
    ;;
-a|--analyze)
    PIVOT=1
    shift
    ;;
-t|--today)
    DAY=1
    shift
    ;;
-w|--week)
    WEEK=1
    shift
    ;;
-s|--since)
    SINCE="$2"
    shift
    ;;
*)
    PARAMS="$PARAMS $1"
    shift
    ;;
esac 
done
eval set -- "$PARAMS"

