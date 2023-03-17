#!/bin/bash

## set -x	## Uncomment for debugging

## Include vars if the file exists
FILE=../vars.sh
if [ -f "$FILE" ]; then
    source ../vars.sh
else
    echo "No variable file found!"
    exit 1
fi

sudo kcli delete vm freeipa

rm -rf ../.generated/