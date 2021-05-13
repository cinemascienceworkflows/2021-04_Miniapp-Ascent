#!/bin/bash

source ./pantheon/env.sh > /dev/null 2>&1

echo "----------------------------------------------------------------------"
echo "PTN: validating" 

OUTPUT=$PANTHEON_RUN_DIR/cinema_databases/$PANTHEON_CDB

echo "     $OUTPUT"

images="000010.npz 000100.npz"

PASS=true
if [ -d $OUTPUT ]; then
    for val in $images; do
        echo "     $OUTPUT/$val"
        if [ -f $OUTPUT/$val ]; then
            PASS=true
        else
            PASS=false
        fi
    done
else
    echo "Cinema Database: $OUTPUT does not exist"
    PASS=false
fi

if $PASS; then
    echo "PTN: PASS"
    echo "----------------------------------------------------------------------"
else
    echo "PTN: FAIL"
    echo "----------------------------------------------------------------------"
    exit 1
fi

