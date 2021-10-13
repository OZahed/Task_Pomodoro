#! /bin/bash


PIVOT=0  # Pivot table
SINCE=0
TODAY=1

PARAMS=""
while (( "$#" )); do
case "$1" in 
-db)
    DB="$2"
    shift
    ;;
-a|--analyze)
    PIVOT=1
    TODAY=0
    shift
    ;;
-s|--since)
    SINCE="$2"
    TODAY=0
    shift
    ;;
*)
    PARAMS="$PARAMS $1"
    shift
    ;;
esac 
done
eval set -- "$PARAMS"

echo $SINCE
echo $TODAY


if [[ -z $DB ]]
then 
    echo "No data base provided"
    exit 127
fi

if [[ $TODAY -eq 1 ]]
then
    DATE="$( date "+%F" )"
    CRT="="
fi


if [[ $SINCE -gt 0 ]]
then
    DATE="$( date  --date "-$SINCE day" "+%F" )"
    echo "$( date  --date "-$SINCE day" "+%F" )"
    echo $DATE
    CRT=">="
fi



if [[ -z $DATE ]]
then 
    echo "you did not provide time duration"
    exit 127
fi

QUERY="SELECT
COUNT(tasks_id) FILTER (WHERE done=FALSE) AS OPEN,
group_concat (  tasks_id || ']:' || title || '::' || due_time || ' - ') FILTER(WHERE done=FALSE) AS open_list,
COUNT(tasks_id) FILTER (WHERE done=TRUE) AS DONE, 
group_concat (  tasks_id || ']:' || title || '::' || due_time || ' - ') FILTER(WHERE done=TRUE) AS closed_list
FROM tasks
WHERE
due_time $CRT '$DATE' OR done_at $CRT '$DATE';"



function pretty_csv {
    column -t -s, -n "$@" | less -F -S -X -K
}

sqlite3  --header -csv $DB "$QUERY"  | pretty_csv
