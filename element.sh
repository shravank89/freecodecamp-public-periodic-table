#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#If no Parameter given
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # check if parameter is numeric
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    ELEMENT_DETAIL=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    ELEMENT_DETAIL=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1' or name = '$1'")
  fi
  # if no element is found
  if [[ -z $ELEMENT_DETAIL ]]
  then
    echo I could not find that element in the database.
  else
    #final message if element found
    echo "$ELEMENT_DETAIL" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_WEIGHT BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_WEIGHT amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi 
fi