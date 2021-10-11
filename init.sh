#!/bin/bash


read -p "name: " NAME
read -p "username: (default = <your name>) " USERNAME
read -p "email: " EMAIL
read -s -p "password:(default = <''>)  " PASSWORD

##########################
#   if email is valid    #
##########################


if [[ ! $EMAIL =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$  ]]
then
    echo "$EMAIL , is not a valid email"
    exit 128
fi

PREFIX="usr"
HASH=$(htpasswd -nbBC 10 $PREFIX $PASSWORD)

echo "
your name $NAME, 
your username: $USERNAME,
your email $EMAIL,
your password $HASH"
