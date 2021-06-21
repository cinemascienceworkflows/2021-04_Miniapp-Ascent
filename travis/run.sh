#!/bin/bash

# exit on any failure
set -e

# cd into repo
cd ${TRAVIS_BUILD_DIR}

# set PANTHOEN_BASE_PATH to travis directory and mkdir that directory
mkdir -p ${HOME}/pantheon_work
sed -i '' "s/PANTHEON_BASE_PATH=WarningNotSet/PANTHEON_BASE_PATH=\${HOME}\/pantheon_work/g" ./bootstrap.env

# placeholder set compute allocation to NONE, will not be used on travis
sed -i '' "s/COMPUTE_ALLOCATION=WarningNotSet/COMPUTE_ALLOCATION=NONE/g" ./bootstrap.env

# execute
./execute
