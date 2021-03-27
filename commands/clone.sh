#!/bin/bash

# Args: $1: Group creator GitHub Account
#       $2: Repository name

if [[ ! -e ".token.env" ]] || [[ ! -f ".token.env" ]]; then
    echo ERROR: User not logged yet. Please try to login.
    exit 1 # terminate and indicate error
elif [[ ! -e ".number.env" ]] || [[ ! -f ".number.env" ]]; then
    echo ERROR: User not registered student number yet. Please try to register yout student number.
    exit 1 # terminate and indicate error
fi

#Set env variables such as GitHub TOKEN
source .app.env
source .token.env
source .number.env

git clone https://github.com/${1}/${2} /Project/
