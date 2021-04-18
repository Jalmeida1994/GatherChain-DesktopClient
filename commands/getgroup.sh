#!/bin/bash

#Set env variables such as GitHub TOKEN
source .app.env
source .token.env
source .number.env

repoName=$(curl https://gatherchain-app.azurewebsites.net/users/${STU_NUMBER} | jq -r '.GroupName')

printf ${repoName}