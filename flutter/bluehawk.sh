#! /bin/bash

# make sure argument provided
if [ -z "$1" ]
  then
    echo "No argument supplied. Please provide an argument."
    echo "Terminating script."
    exit 1
fi

DIR_OUT=$1

# make DIR_OUT if it doesn't exist
[ ! -d $DIR_OUT ] && mkdir -p $DIR_OUT

# create bluehawk snippets
bluehawk snip ./lib -o $DIR_OUT --format rst
