#!/bin/bash

cd $1

git reset --hard HEAD

git clean -f

git pull


