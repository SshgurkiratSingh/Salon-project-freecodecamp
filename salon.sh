#! /bin/bash
echo -e "\n~~~ Salon Appointment Scheduler ~~~"
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
SERVICES=$($PSQL "SELECT * from services ORDER BY service_id")

MAIN_MENU () {
  #error message
  if [[ ! -z $1 ]]
  then
    echo -e "\n$1"
  fi
    echo "$SERVICES" | while read id bar name
    do
    echo -e "$id) $name"
 done
 echo -e "Select a service "
 read SERVICE_ID_SELECTED
 if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9] ]]
 then
 MAIN_MENU "Ah shit! Here we go again"
 else
 
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME ]]
then 
 MAIN_MENU "No Shit Sherlock! Select a valid service"
fi
USER_DETAIL
 fi
}
USER_DETAIL(){
  echo -e "\nPlease Enter your phone number\n"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
 if [[ -z $CUSTOMER_ID ]]
 then
 echo -e "\nYou looks to be A New customer. Lets create a new account for you\n"
 echo "Enter Your Name"
 read CUSTOMER_NAME
INSERT=$($PSQL "INSERT INTO customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
echo -e "\nAccount created successfully"
 fi
echo -e "\nEnter a suitable time for yourself"
read SERVICE_TIME
IN_APP=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
echo $CUS
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}
MAIN_MENU