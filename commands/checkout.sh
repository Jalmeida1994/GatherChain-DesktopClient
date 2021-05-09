#!/bin/bash

cd ${1}

git config pull.rebase false

#Checkout the specified commit
git checkout ${2}