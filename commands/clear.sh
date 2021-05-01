#!/bin/bash

source ${1}/../.app.env 
source ${1}/../.number.env 
source ${1}/../.token.env 

parse_json()
{
    echo $1 | \
    sed -e 's/[{}]/''/g' | \
    sed -e 's/", "/'\",\"'/g' | \
    sed -e 's/" ,"/'\",\"'/g' | \
    sed -e 's/" , "/'\",\"'/g' | \
    sed -e 's/","/'\"---SEPERATOR---\"'/g' | \
    awk -F=':' -v RS='---SEPERATOR---' "\$1~/\"$2\"/ {print}" | \
    sed -e "s/\"$2\"://" | \
    tr -d "\n\t" | \
    sed -e 's/\\"/"/g' | \
    sed -e 's/\\\\/\\/g' | \
    sed -e 's/^[ \t]*//g' | \
    sed -e 's/^"//'  -e 's/"$//'
}

cd $2
#Gets the name of the repo by getting the URL of the remote
URL=$(git remote get-url origin)
GRP_NAME=$(basename $URL .git)

#Removes git folder and stuff
rm -fr .gitignore
rm -fr .git
rm -fr .DS_Store
rm -fr .gatherchain.json

# Gets the authenticated GitHub user
jsonRes=$(curl --fail -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${ACCESS_TOKEN}" "https://api.github.com/user")# | jq -r '.login')
username=$(parse_json "${jsonRes}" login)

#Deletes Remote GitHub repo
#curl -X DELETE -H "Authorization: token ${TOKEN}" https://api.github.com/repos/${username}/${GRP_NAME}

# curl -X DELETE -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN}  https://api.github.com/user/repos -d '{"name":"'"${GRP_NAME}"'"}'

curl -X DELETE -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN} https://api.github.com/repos/${username}/${GRP_NAME}


