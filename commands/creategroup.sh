#!/bin/bash

# Args: $1: Directory Path
#       $2+: Student numbers of the rest of the group;

cwd=$(pwd)

if [[ ! -e ".token.env" ]] || [[ ! -f ".token.env" ]]; then
    echo ERROR: User not logged yet. Please try to login.
    exit 1 # terminate and indicate error
elif [[ ! -e ".number.env" ]] || [[ ! -f ".number.env" ]]; then
    echo ERROR: User not registered student number yet. Please try to register yout student number.
    exit 1 # terminate and indicate error
fi

#Set env variables such as GitHub TOKEN
source .app.env
source .token.env
source .number.env

# Getting the authenticated user's username
username=$(curl --fail -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${ACCESS_TOKEN}" "https://api.github.com/user" | jq -r '.login')

# Parsing the script's input
i=1;
echo $@
for student in "$@" 
do
    if [ $i -eq 1 ]
    then
        author=${STU_NUMBER};
        groupname="${STU_NUMBER}"
        echo $groupname
        i=$((i + 1));
        echo $i

    else
        groupname="${groupname}-${student}"
        echo $groupname
        i=$((i + 1));
        echo $i
    fi
done
echo 'im here'

if [ ${author} != ${STU_NUMBER} ]; then
    echo ERROR: That is not the registered student number.
    exit 1 # terminate and indicate error
fi

echo "Creating the group's ${groupname} repository in the GitHub's user: ${username}."

# Creates the GitHub Repo
curl -X POST -H "Accept: application/vnd.github.v3+json" -u ${username}:${ACCESS_TOKEN}  https://api.github.com/user/repos -d '{"name":"'"${groupname}"'"}'

# Invites collaborators
# curl -X PUT -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/octocat/hello-world/collaborators/USERNAME -d '{"permission":"permission"}'

#echo ".app.env" >> .gitignore
#echo ".token.env" >> .gitignore
#echo ".number.env" >> .gitignore
#echo "commands/" >> .gitignore

cd $1
#Inits local repo and adds ReadME.md
git init
git config user.name "${STU_NUMBER}"
git add .

echo "{\"Author\":\"${STU_NUMBER}\",\"Group\":\"${groupname}\",\"FirstCommit\":\"${FIRST_GIT_HASH}\"}" >> .gatherchain.json
echo ".gatherchain.json" >> .gitignore

#First commit to master branch
git commit -m "first commit"
git branch -M master

#Add the remote repo to the .git and pushes
git remote add origin https://github.com/${username}/${groupname}.git
git pull
git push -u origin master

#Saves Commit id and prints to console
FIRST_GIT_HASH=$(git log --pretty=format:'%h' -n 1)
echo "First hash: ${FIRST_GIT_HASH}"

cd ${cwd}
#Requests to create the network with the first group 
echo "Creating a new channel in the Blockchain Network. This may take a minute... or two..."

if curl --fail -X POST -H "Content-Type: application/json" -d "{\"Author\":\"${STU_NUMBER}\",\"Group\":\"${groupname}\",\"Commit\":\"${FIRST_GIT_HASH}\"}" https://gatherchain-app.azurewebsites.net/creategroup; then
printf "Created group: ${groupname}!"
else
printf "Error creating the group: ${groupname}!"
source commands/clear.sh ${1}
fi;