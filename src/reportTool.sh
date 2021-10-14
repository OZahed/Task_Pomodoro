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
-csv)
    CSV_PATH="$2"
    shift
    ;;
*)
    PARAMS="$PARAMS $1"
    shift
    ;;
esac 
done
eval set -- "$PARAMS"


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
    CRT=">="
fi



if [[ -z $DATE ]]
then 
    echo "you did not provide time duration"
    exit 127
fi

if [[ $PIVOT -eq 0 ]]
then 

    QUERY="SELECT
        COUNT(tasks_id) FILTER (WHERE done=FALSE) AS open_count,
        group_concat (tasks_id || '_' || title || '_' || due_time || ' ') 
            FILTER(WHERE done=FALSE) AS \"open_list ( id_title_due time )\",
        COUNT(tasks_id) FILTER (WHERE done=TRUE) AS close_count, 
        group_concat (tasks_id || '_' || title || '_' || due_time || ' ')
            FILTER(WHERE done=TRUE) AS \"close_list (id_title_due time)\"
    FROM tasks
    WHERE
    due_time $CRT '$DATE' OR done_at $CRT '$DATE';"
fi


function pretty_csv {
    column -t  -s '|' 
}


if [[ ! -z "$CSV_PATH" ]]
then
    sqlite3  --header -csv $DB "$QUERY" > $CSV_PATH 
else
    sqlite3  --header  $DB "$QUERY" | pretty_csv | less
fi
