#!/bin/bash

#cd $1
#if [ "$1" == "-diff" ]; then
#git log -p
#else
git log --pretty=format:'%h by %an, %ar, message: %s'
