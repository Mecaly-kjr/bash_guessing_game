#!/bin/bash 
name=$1

if [[ -z "$name" ]]; then
    echo -e "Usage: ./guess.sh <name> \n wherer is the name of the user, please." name
    exit 1
fi

echo "========================================"
echo "  Hi $name, Welcome to our guessing game, $name!   "
echo "========================================"

number=$(( RANDOM % 100 + 1 ))
guess=-1

while [[ "$guess" -ne $number ]]; do
    read -p "Please guess a number between 1 and 100: " guess
    
    if [[ -z "$guess" ]] || ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "Please enter a valid number."
        continue 
    fi

    if (( guess > number )); then
        echo "Your guess is too high."
    elif (( guess < number )); then
        echo "Your guess is too low."
    fi
done 

echo "You nailed it, good job, $name!"
