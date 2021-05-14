#!/bin/bash

# Continuation of login.sh
source ${1}/../.app.env
source ${1}/../.devicecode.env
source ${1}/../.number.env
source ${1}/../.weburl.env

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

registerStudentNumber () {
    # Gets the authenticated GitHub user
    jsonRes=$(curl --fail -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${1}" "https://api.github.com/user")
    username=$(parse_json "${jsonRes}" login)
    if curl --fail -X POST -H "Content-Type: application/json" -d "{\"Author\":\"${STU_NUMBER}\",\"GitHub\":\"${username}\",\"Group\":\"0\",\"GroupName\":\"0\"}" ${WEB_URL}/registernumber; then
        #printf "Registered student number!"
        sleep 1
    else
        printf "Error registering the student number"
        exit 1 # terminate and indicate error
    fi;
}


# Aux function to cut the access token and put it in the .token.env file
takes_accesstoken () {
        # Cuts down to the acess token
        resp=${RESPAUTH#*access_token=}
        accesstoken=${resp%%&scope=*}
        echo "export ACCESS_TOKEN=${accesstoken}"
        if curl --fail -X GET curl ${WEB_URL}/users/${STU_NUMBER}; then
            printf "Student number already registered!"
            exit 1 # terminate and indicate error
        else
            registerStudentNumber ${accesstoken}
        fi;
}

# Aux func to check if user already authorized the device: it waits 5s and if error tries again...
i=0;
check_auth () {
    if [ $i -gt 10 ];then
        echo ERROR: Tried to connect to many times. Please try to login again.
        exit 1 # terminate and indicate error
    fi
    sleep 5s # Waits 5 seconds.
    RESPAUTH=$(curl --fail -X POST -H "Connection: keep-alive" -H "Accept: */*" "https://github.com/login/oauth/access_token?client_id=${SECRET}&device_code=${DEVICE_CODE}&grant_type=urn:ietf:params:oauth:grant-type:device_code")
    if [[ $RESPAUTH == *"error"* ]]; then
        i=$((i + 1));
        check_auth
    elif [[ $RESPAUTH == *"access_token"* ]]; then
        #echo "User authorized the device."
        takes_accesstoken  
    else
        echo ERROR: Failed to check user authentication. Please try to login again.
        exit 1 # terminate and indicate error
    fi
}


# Step 3: App polls GitHub to check if the user authorized the device
check_auth

# Removes file with device code
rm ${1}/../.devicecode.env
rm ${1}/../usercode.sh

# echo "Thank you. You can proceed using the app."