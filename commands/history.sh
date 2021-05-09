#!/bin/bash

cd $1

git log --pretty=format:'%H %cN %h by %an, %ar, message: %s'
