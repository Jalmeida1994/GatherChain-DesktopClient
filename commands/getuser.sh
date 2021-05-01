if [[ ! -e ".token.env" ]] || [[ ! -f ".token.env" ]]; then
    echo ERROR: User not logged yet. Please try to login.
    exit 1 # terminate and indicate error
elif [[ ! -e ".number.env" ]] || [[ ! -f ".number.env" ]]; then
    echo ERROR: User not registered student number yet. Please try to register yout student number.
    exit 1 # terminate and indicate error
fi

#Set env variables such as GitHub TOKEN
source ${1}/../.app.env
source ${1}/../.token.env
source ${1}/../.number.env

# Step 1: App requests the user logged in
RESPONSE=$(curl https://gatherchain-app.azurewebsites.net/users/${STU_NUMBER} | jq -r '.GitHub')

printf $RESPONSE
