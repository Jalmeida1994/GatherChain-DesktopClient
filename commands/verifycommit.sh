#!/bin/bash

source ${1}/../.admin.env

if [ "${ADMIN_GITHUB}" = "${2}" ]; then
    echo 1
else
    echo 0
fi