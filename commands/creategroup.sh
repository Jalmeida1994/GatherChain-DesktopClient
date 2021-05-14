#!/bin/bash

# Args: $1: Command path
#       $2: Git Directory Path
#       $3+: Student numbers of the rest of the group;

cwd=${1}

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

#Set env variables such as GitHub TOKEN
source ${1}/../.app.env
source ${1}/../.token.env
source ${1}/../.number.env
source ${1}/../.admin.env
source ${1}/../.weburl.env


# Getting the authenticated user's username
jsonRes=$(curl -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/user)
username=$(parse_json "${jsonRes}" login)

# Parsing the script's input
i=2;
echo $@
for student in "${@:$i}" 
do
    if [ $i -eq 2 ]
    then
        author=${STU_NUMBER};
        groupname="${STU_NUMBER}"
        echo $groupname
        i=$((i + 1));
        usernames=()
        numbers=()
        echo $i

    else
        groupname="${groupname}-${student}"
        echo $groupname
        i=$((i + 1));
        numbers+=( ${student} )
        echo $numbers
        jsonResponse=$(curl ${WEB_URL}/users/${student})
        usernames+=( $(parse_json "${jsonRes}" GitHub) )
        echo $usernames
        echo $i
    fi
done

echo "Creating the group's ${groupname} repository in the GitHub's user: ${username}."

# Creates the GitHub Repo
curl -X POST -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN}  https://api.github.com/user/repos -d '{"name":"'"${groupname}"'","private":"true"}'

# Invites the Admin
curl -X PUT -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${username}/${groupname}/collaborators/${ADMIN_GITHUB} -d '{"permission":"pull"}' 

# Updates group in redis
url="${WEB_URL}/registernumber"
body="{\"Author\":\"${STU_NUMBER}\",\"GitHub\":\"${username}\",\"Group\":\"${username}\",\"GroupName\":\"${groupname}\"}"
if curl --fail -X POST -H "Content-Type: application/json" -d "${body}" "${url}"; then
    printf "Updated group for ${STU_NUMBER}!"
else
    printf "Error updating group for the student ${STU_NUMBER}"
fi

# Invites collaborators
echo "Total colaborators: ${#usernames[@]}"
for w in ${!usernames[@]}
do
    echo "https://api.github.com/repos/${username}/${groupname}/collaborators/${usernames[w]}"
    echo "Username: ${usernames[w]}"
    curl -X PUT -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${username}/${groupname}/collaborators/${usernames[w]} -d '{"permission":"admin"}' 
    # Updates group in redis
    body="{\"Author\":\"${numbers[w]}\",\"GitHub\":\"${usernames[w]}\",\"Group\":\"${username}\",\"GroupName\":\"${groupname}\"}"
    if curl --fail -X POST -H "Content-Type: application/json" -d "${body}" "${url}"; then
        printf "Updated group for ${numbers[w]}!"
    else
        printf "Error updating group for the student ${numbers[w]}"
    fi
done

cd $2

#Inits local repo and adds ReadME.md
git init
git config author.name "${STU_NUMBER}" 
git config user.name "${ADMIN_GITHUB}"
git config --unset user.signingkey
git config commit.gpgsign false
git add -A

#First commit to master branch
git commit -m "Creating group"
git branch -M master

#Add the remote repo to the .git and pushes
git remote add origin https://github.com/${username}/${groupname}.git
git pull
git push -u origin master

#Saves Commit id and prints to console
FIRST_GIT_HASH=$(git log --pretty=format:'%h' -n 1)
echo "First hash: ${FIRST_GIT_HASH}"

git config author.name "${username}" 
git config user.name "${username}"

cd ${cwd}
#Requests to create the network with the first group 
echo "Creating a new channel in the Blockchain Network. This may take a minute... or two..."

url="${WEB_URL}/creategroup"
body="{\"Author\":\"${STU_NUMBER}\",\"Group\":\"${groupname}\",\"Commit\":\"${FIRST_GIT_HASH}\"}"
if curl --fail -X POST -H "Content-Type: application/json" -d "${body}" "${url}"; then
printf "Created group: ${groupname}!"
else
source ${1}/../commands/clear.sh "${1}" "${2}"
printf "Error creating the group: ${groupname}"
exit 1 
fi

