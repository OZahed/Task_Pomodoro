#! /bin/bash

unset NAME
unset MIN

CYAN='\033[0;36m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

DAY=0
LOG=0
MIN=30
PARAMS=""
while (( "$#" )); do
case "$1" in 
-t|--time)
    MIN="$2"
    shift
    ;;
-n|--name)
    NAME="$2"
    shift
    ;;
-db)
    DB="$2"
    shift
    ;;
-l|--log)
    LOG=1
    shift
    ;;
-s|--since)
    DAY="$2"
    shift
    ;;
*)  
    PARAMS="$PARAMS $1"
    shift
    ;;
esac 
done
eval set -- "$PARAMS"

function pretty_csv {
    column -t  -s '|' 
}

if [[ $LOG -eq 1 ]]
then
    DATE="$(date --date "-$DAY day" "+%F")"
    QUERY="SELECT 
        date (created_at) AS day, 
        title, 
        sum(Duartion) AS total_minuts
    FROM 
        pomodoro
    WHERE day <= '$DATE' GROUP BY 1,2 ORDER BY 1,3 DESC;"
     sqlite3  --header  $DB "$QUERY" | pretty_csv | less
    exit 0
fi


if [[ -z "$NAME" ]]
then
    echo "Title can't be empty"
    exit 1
fi 

SECOND=$((60 * MIN))
printf "\n\n"
while [  $SECOND -gt 0 ]
do
    MINS=$(( SECOND / 60 ))
    SEC=$(( SECOND - MINS*60 ))
    printf "\r\t$NAME: ${ORANGE}$MINS : $SEC ${NC}."  $((SECOND--))
    sleep 1s
done




sqlite3 $DB "INSERT INTO pomodoro (title, Duartion) VALUES ('$NAME','$MIN');"


