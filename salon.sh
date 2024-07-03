#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo $($PSQL "truncate customers, appointments")

echo -e "\n~~~~~~ Salon Appointment Scheduler ~~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
    then
      echo -e "\n$1"
  fi

  echo "What service are you looking to schedule?"
  echo -e "\n1) cut\n2) color\n3) blowout\n4) exit\n"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) SCHEDULER ;;
  2) SCHEDULER ;;
  3) SCHEDULER ;;
  4) EXIT ;;
  *) MAIN_MENU "Please enter a valid service option." ;;
  esac
}

SCHEDULER() {
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$(echo $($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED") | sed -r 's/^ *| *$//g')

  echo -e "\nWhat time would you like to schedule your $SERVICE_NAME?"
  read SERVICE_TIME

  INSERT_APPT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e"\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT() {
  echo -e "\nThank you for stopping in!"
}

MAIN_MENU
