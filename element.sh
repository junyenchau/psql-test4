#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]
then
  echo "Please provide an element as an argument."
else 
  INPUT=$1
  if [[ "$INPUT" =~ ^-?[0-9]+$ ]] 
  then
    RETURNRES=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT")
  else 
    RETURNRES=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT' OR symbol = '$INPUT'")
  fi
  if [[ -z $RETURNRES ]]
  then
    echo I could not find that element in the database.
  else 
    if [[ "$INPUT" =~ ^-?[0-9]+$ ]] 
    then
      IFS='|' read NUM SYMBOL NAME TYPE MASS MP BP <<< $($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $INPUT;")
      echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    else
      IFS='|' read NUM SYMBOL NAME TYPE MASS MP BP <<< $($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$INPUT' OR symbol = '$INPUT';")
      echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    fi
  fi
fi