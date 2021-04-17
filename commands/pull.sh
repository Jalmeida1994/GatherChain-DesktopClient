#!/bin/bash

cd $1

#Prints the argument
read -p 'Commit SHA to checkout: ' sha

git config pull.rebase false

#Checkout the specified commit
git checkout $sha



