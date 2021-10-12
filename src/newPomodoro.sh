#! /bin/bash

unset NAME
unset MIN

CYAN='\033[0;36m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

MIN=25
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
*)  
    PARAMS="$PARAMS $1"
    shift
    ;;
esac 
done

if [[ -z "$NAME" ]]
then
    echo "Title can't be empty"
    exit 1
fi 

SECOND=$((60 * MIN))
printf "\n\n"
while [  $SECOND -gt 0 ]
do
    MIN=$(( SECOND / 60 ))
    SEC=$(( SECOND - MIN*60 ))
    printf "\r\t$NAME: ${ORANGE}$MIN : $SEC ${NC}."  $((SECOND--))
    sleep 1s
done

