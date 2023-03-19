#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN(){
  SERVICES=$($PSQL "select service_id, name from services order by service_id ")
  echo "$SERVICES" | while read ID BAR NAME 
  do
    echo "$ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  
  #if service_id is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    echo -e "\nservice doesn't exist, please enter the valid choice"
    MAIN
  else
    #if service_id n'existe pas
    SERVICE_ID_SELECTED=$($PSQL "select service_id from services where service_id = $SERVICE_ID_SELECTED" )
    if [[ -z $SERVICE_ID_SELECTED ]]
    then
      echo -e "\nservice doesn't exist, please enter the valid choice"
      MAIN
    else
    echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE 

  CUSTOMER_PHONE_SELECTED=$($PSQL "select customer_id, name from customers where phone= '$CUSTOMER_PHONE' ")
  if [[ -z "$CUSTOMER_PHONE_SELECTED" ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    if [[ $INSERT_CUSTOMER == 'INSERT 0 1' ]]
    then
      echo "congratulations you are subscribed"
    fi
    echo -e "\nWhat time would you like your cut, "$CUSTOMER_NAME"?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone= '$CUSTOMER_PHONE' ")
    SERVICE_NAME=$($PSQL "select name from services where service_id= $SERVICE_ID_SELECTED")
    INSERT_TIME=$($PSQL "insert into appointments(customer_id, service_id,time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME') ")
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
    fi
  fi

  
}
MAIN
