#! /bin/bash

while (( "$# ))
do
case "$1" in
    -db)
        DB="$2"
        shift
    ;;
esac
done