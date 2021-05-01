#!/bin/bash

# If .number.env already exists the script doesn't need arguments and only exists to login 
# the user to GitHub

# Args: $1: Author's student number; 

if [[ -s "${2}/../.number.env" ]]; then
    echo "Student number already registered."
elif [ $# -eq 0 ] || [ $# -gt 2 ]; then
    echo ERROR: Incorrect number of arguments. To register number insert 1 argument representing student number
    exit 1 # terminate and indicate error
else
    echo "export STU_NUMBER=${1}" >> ${2}/../.number.env
    echo "Registered student number!"
fi

# Removes old OAuth token, if exists
if [ -f .token.env ]; then
   rm .token.env
fi

source ${2}/../.app.env

# Step 1: App requests the device and user verification codes from GitHub
RESPONSE=$(curl --fail -X POST -H "Connection: keep-alive" -H "Accept: */*"  -H "Content-Type: application/json" -H "Accept: application/vnd.github.v3+json" "https://github.com/login/device/code?client_id=${SECRET}&scope=repo%20delete_repo")

# Cuts down to the device code
resp=${RESPONSE#*device_code=}
devicecode=${resp%%&expires_in=*}
echo "export DEVICE_CODE=${devicecode}" >> ${2}/../.devicecode.env

# Cuts down to the user code
resp=${RESPONSE#*user_code=}
usercode=${resp%%&verification_uri=*}

$(> usercode.sh)
echo "echo ${usercode}" >> ${2}/../usercode.sh

# Step 2: Prompt the user to enter the user code in a browser
echo "Please enter the code  ${usercode}  in a browser at https://github.com/login/device"

# Check OS version to open url automatically and copy the user code to clipboard
osType=$(uname)
case "$osType" in
        "Darwin")
        {
            printf ${usercode} | pbcopy
            printf "${usercode} copied to clipboard."
            open https://github.com/login/device
        } ;;    
        "Linux")
        {
            printf ${usercode} | xcopy
            printf "${usercode} copied to clipboard."
            xdg-open https://github.com/login/device
        } ;;
        *)
        {
            printf "Please enter the code  ${usercode}  in a browser at https://github.com/login/device"
        } ;;
    esac