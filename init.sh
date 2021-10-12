#!/bin/bash


read -p "name: " NAME
read -p "username: (default = <your name>) " USERNAME
read -p "email: " EMAIL
read -s -p "password:(default = <''>)  " PASSWORD

echo $PASSWORD
##########################
#   if email is valid    #
##########################


if [[ ! $EMAIL =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$  ]]
then
    echo "$EMAIL , is not a valid email"
    exit 128
fi

if [[ -z ${#PASSWORD} ]]
then 
    echo "you provided no password"
fi


PREFIX="usr"
HASH="$(htpasswd -nbBC 10 $PREFIX $PASSWORD)"

########################
#      create DB       #
########################
DIR="./DATA"
DB="./DATA/Task.db"

if [[ ! -d $DIR ]]
then 
    mkdir $DIR 
fi

if [[ ! -f $DB  ]]
then
    sqlite3 $DB < create_data.sql
fi

# insert user inputs
sqlite3 $DB "INSERT INTO users (name, email, username, password) VALUES ('$NAME', '$EMAIL', '$USERNAME', '$HASH');"

if [[ $? != 0 ]]
then 
    echo "exited with $?"
    # sqlite3 does not exists 
    echo 'could not create sqlite instance 
Check if you have the "sqlite3" package installed'
    exit 127
fi

echo "Your account created"