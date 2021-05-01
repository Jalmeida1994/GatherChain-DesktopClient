#!/bin/bash

#Set env variables such as GitHub TOKEN
source ${1}/../.app.env
source ${1}/../.token.env
source ${1}/../.number.env

repoName=$(curl https://gatherchain-app.azurewebsites.net/users/${STU_NUMBER} | jq -r '.GroupName')

printf ${repoName}