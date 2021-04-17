#!/bin/bash

#Set env variables such as GitHub TOKEN
source .app.env
source .token.env
source .number.env


#echo ${1}
#if curl --fail -X POST -H "Content-Type: application/json" -d "{\"Author\":\"${1}\",\"Group\":\"${2}\",\"Commit\":\"${3}\"}" http://localhost:8010/test; then
#printf "Created group: ${2}!"
#else
#printf "Error creating the group: ${2}!"
#fi;

echo "${STU_NUMBER}: ${@:2}"
message=${@:2}
git commit -m "${STU_NUMBER}: ${message}"
git branch -M master