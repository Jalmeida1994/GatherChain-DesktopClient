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
group=$(parse_json "${jsonRes}" Group)

printf $group