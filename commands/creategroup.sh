#!/bin/bash

# Args: $1: Directory Path
#       $2+: Student numbers of the rest of the group;

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
jsonRes=$(curl --fail -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${ACCESS_TOKEN}" "https://api.github.com/user")  # | jq -r '.login')
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
        numbers+=${student}
        echo $numbers
        jsonResponse=$(curl ${WEB_URL}/users/${student})  # | jq -r '.GitHub'))
        usernames+=$(parse_json "${jsonRes}" GitHub)
        echo $usernames
        echo $i
    fi
done

echo "Creating the group's ${groupname} repository in the GitHub's user: ${username}."

# Creates the GitHub Repo
curl -X POST -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN}  https://api.github.com/user/repos -d '{"name":"'"${groupname}"'"}'

# Invites the Admin
curl -X PUT -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${username}/${groupname}/collaborators/${ADMIN_GITHUB}} -d '{"permission":"pull"}' 

# Invites collaborators
echo "Total colaboradores: ${#usernames[@:3]}"
for w in ${#usernames[@]:3}
do
    echo "https://api.github.com/repos/${username}/${groupname}/collaborators/${usernames[w-1]}"
    echo "Username: ${usernames[w-1]}"
    curl -X PUT -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${username}/${groupname}/collaborators/${usernames[w-1]} -d '{"permission":"admin"}' 
    # Gets the authenticated GitHub user
    if [ curl --fail -X POST -H "Content-Type: application/json" -d "{\"Author\":\"${numbers[w-1]}\",\"GitHub\":\"${usernames[w-1]}\",\"Group\":\"${username}\",\"GroupName\":\"${groupname}\"}" ${WEB_URL}/registernumber ] 
    then
        printf "Updated group for ${numbers[w-1]}!"
    else
        printf "Error updating group for the student ${numbers[w-1]}"
    fi
done

cd $2

#Inits local repo and adds ReadME.md
git init
git config author.name "${STU_NUMBER}" 
git config user.name "${ADMIN_GITHUB}"
git add -A

#echo "{\"Author\":\"${STU_NUMBER}\",\"Group\":\"${groupname}\",\"FirstCommit\":\"${FIRST_GIT_HASH}\"}" >> .gatherchain.json
#echo ".gatherchain.json" >> .gitignore

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

if [ curl --fail -X POST -H "Content-Type: application/json" -d "{\"Author\":\"${STU_NUMBER}\",\"Group\":\"${groupname}\",\"Commit\":\"${FIRST_GIT_HASH}\"}" ${WEB_URL}/creategroup ] 
then
printf "Created group: ${groupname}!"
else
printf "Error creating the group: ${groupname}!"
# TODO: remove for tests
#source ${1}/../commands/clear.sh ${1} ${2}
exit "Error creating the group: ${groupname}!"
fi

