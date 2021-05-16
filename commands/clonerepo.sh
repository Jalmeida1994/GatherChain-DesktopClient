#!/bin/bash

# Args: $1: Directory Path

#Set env variables such as GitHub TOKEN
source ${2}/../.app.env
source ${2}/../.token.env
source ${2}/../.number.env
source ${2}/../.weburl.env


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

jsonRes=$(curl ${WEB_URL}/users/${STU_NUMBER})
usernameGroup=$(parse_json "${jsonRes}" Group)
repoName=$(parse_json "${jsonRes}" GroupName)
userName=$(parse_json "${jsonRes}" GitHub)

cd $1
printf $1
git clone https://${userName}:${ACCESS_TOKEN}@github.com/${usernameGroup}/${repoName} $1
