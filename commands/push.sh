#!/bin/bash

#Set env variables such as GitHub TOKEN
source .app.env
source .token.env
source .number.env

username=$(curl --fail -X GET -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN} https://api.github.com/user | jq -r '.login')

echo "Pushing as student number: ${STU_NUMBER}"
git config user.name "${STU_NUMBER}" 

#Adds changes
git add .

#First commit to master branch
git commit -m "Commit by student nr: ${STU_NUMBER}"
git branch -M master

#Saves Commit id and prints to console
GIT_HASH=$(git log --pretty=format:'%h' -n 1)
echo "Git Hash: ${GIT_HASH}"

#Gets the name of the repo by getting the URL of the remote
URL=$(git remote get-url origin)
GRP_NAME=$(basename $URL .git)

# Checks if user trying to push is part of the group TODO
members=$(echo $GRP_NAME | tr "-" "\n")

#Requests to create the network with the first group 
echo "Pushing the commit hash to the blockchain network in group ${GRP_NAME}..."

if curl --fail -X POST -H "Content-Type: application/json" -d "{\"Author\":\"${STU_NUMBER}\",\"Group\":\"${GRP_NAME}\",\"Commit\":\"${GIT_HASH}\"}" https://gatherchain-app.azurewebsites.net/push; then
printf "Hash ${GIT_HASH} commited to the Network! Pushing to remote repo."
#Add the remote repo to the .git and pushes
git pull
git push -u origin master
else
printf "Error pushing the latest commit to the network: ${GIT_HASH}!"
git reset --soft HEAD~1
fi;

