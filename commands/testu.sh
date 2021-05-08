#!/bin/bash

usernames=()
usernames+=( joao )
usernames+=( catia )
usernames+=( misha )
usernames+=( gaston )

echo ${#usernames[@]}

for w in ${!usernames[@]}
do
    echo "Username: ${usernames[w]}"
done