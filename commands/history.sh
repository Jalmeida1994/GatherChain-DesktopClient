#!/bin/bash

if [ "$1" == "-diff" ]; then
git log -p
else
git log --pretty=format:'%h was %an, %ar, message: %s'
