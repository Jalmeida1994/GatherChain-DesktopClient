#!/bin/bash

# Args: $1: Directory Path

cd $1

#$remoteURL=git config --get remote.origin.url

remoteURL=$(git config --get remote.origin.url)

url=${remoteURL%.git}

printf $url