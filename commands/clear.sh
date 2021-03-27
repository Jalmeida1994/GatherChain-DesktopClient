#!/bin/bash

source .app.env 
source .number.env 
source .token.env 

cd $1
#Gets the name of the repo by getting the URL of the remote
URL=$(git remote get-url origin)
GRP_NAME=$(basename $URL .git)

#Removes git folder and stuff
rm -fr .gitignore
rm -fr .git
rm -fr .DS_Store
rm -fr .gatherchain.json

# Gets the authenticated GitHub user
username=$(curl --fail -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${ACCESS_TOKEN}" "https://api.github.com/user" | jq -r '.login')

#Deletes Remote GitHub repo
#curl -X DELETE -H "Authorization: token ${TOKEN}" https://api.github.com/repos/${username}/${GRP_NAME}

# curl -X DELETE -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN}  https://api.github.com/user/repos -d '{"name":"'"${GRP_NAME}"'"}'

curl -X DELETE -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN} https://api.github.com/repos/${username}/${GRP_NAME}


