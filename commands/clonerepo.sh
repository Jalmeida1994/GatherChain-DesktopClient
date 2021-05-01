#!/bin/bash

# Args: $1: Directory Path

#Set env variables such as GitHub TOKEN
source ${2}/../.source .app.env
source ${2}/../.token.env
source ${2}/../.number.env

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

jsonRes=$(curl https://gatherchain-app.azurewebsites.net/users/${STU_NUMBER})# | jq -r '.Group')
usernameGroup=$(parse_json "${jsonRes}" Group)
repoName=$(parse_json "${jsonRes}" GroupName)

cd $1

git clone https://github.com/${usernameGroup}/${repoName}
