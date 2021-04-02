#!/bin/bash

# Args: $1: Directory Path

#TODO


usernameGroup=$(curl https://gatherchain-app.azurewebsites.net/users/${STU_NUMBER} | jq -r '.Group')
repoName=$(curl https://gatherchain-app.azurewebsites.net/users/${STU_NUMBER} | jq -r '.GroupName')

cd $1

git clone https://github.com/${usernameGroup}/${repoName}
