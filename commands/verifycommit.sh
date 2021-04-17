#!/bin/bash

source .admin.env

if [ "${ADMIN_GITHUB}" = "${1}" ]; then
    echo 1
else
    echo 0
fi