#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n\e[4mX~X~~X  Wild Card Salon  X~~X~X\e[0m"

echo -e "\nHello and welcome,\n these are our services:"


GET_SERVICE_ID(){
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi
  LIST_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR SERVICE
  do
  ID=$(echo $SERVICE_ID | sed 's/ //g')
  NAME=$(echo $SERVICE | sed 's/ //g')
  echo "$ID) $NAME"
  done
echo -e "\nChoose one to rule them all..."
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
  [1-6]) GO_NEXT ;;
  *) GET_SERVICE_ID "Sorry, we do not have that service. Please select one of the services available:" ;;
  esac
  }
GO_NEXT(){
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$(echo $NAME | sed 's/ //g')

  if [[ -z $NAME ]]
  then
  echo -e "\nWe don't have a record of that phone number. What is your name?"
  read CUSTOMER_NAME
  NAME=$(echo $CUSTOMER_NAME | sed 's/ //g')
  ADD_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$NAME', '$CUSTOMER_PHONE')")
  fi
  GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  SERVICE_NAME=$(echo $GET_SERVICE_NAME | sed 's/ //g')
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhen would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  ADD_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  if [[ $ADD_NEW_APPOINTMENT == "INSERT 0 1" ]]
  then
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

GET_SERVICE_ID