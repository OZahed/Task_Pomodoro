#!/bin/bash
PARAMS=""
DONE_FLAG=0
while (( "$#" )); do
  case "$1" in
    -d|--done)
      DONE_FLAG=1
      shift
      ;;
    --init)
     source ./init.sh 
      exit 0;
      shift 
      ;;
    -n|--name)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        NAME=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit $?
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
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

