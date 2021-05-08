#!/bin/bash

source ${2}/../.app.env

cd ${1}

username=$(git config user.name)

if [ "${ADMIN_GITHUB}" = "${username}" ]; then
printf "0"
else
printf "1"
fi