#!/bin/bash

# Args: $1: Directory Path

#TODO


usernameGroup=$(curl https://gatherchain-app.azurewebsites.net/users/${STU_NUMBER} | jq -r '.Group')

cd $1

git clone 