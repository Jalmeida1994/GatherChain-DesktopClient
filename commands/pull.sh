#!/bin/bash

#Prints the argument
read -p 'Commit SHA to checkout: ' sha

#Checkout the specified commit
git checkout $sha



