#!/bin/bash -l

# adding comment

source ./pantheon/env.sh

echo "PTN: Establishing Pantheon workflow directory:"
echo "     $PANTHEON_WORKFLOW_DIR"

PANTHEON_SOURCE_ROOT=$PWD

# these settings allow you to control what gets built ... 
BUILD_CLEAN=true
INSTALL_SPACK=true
USE_SPACK_CACHE=true
INSTALL_ASCENT=true
INSTALL_APP=false

# spack data 
SPACK_COMMIT=3d7069e03954e5a4042d41c27a75dacd33e52696
SPACK_NAME=e4s_pantheon
SPACK_CACHE_URL=https://cache.e4s.io 
SPACK_E4S_PUB_URL=https://oaciss.uoregon.edu/e4s/e4s.pub

# ---------------------------------------------------------------------------
#
# Build things, based on flags set above
#
# ---------------------------------------------------------------------------

START_TIME=$(date +"%r %Z")
echo ----------------------------------------------------------------------
echo "PTN: Start time: $START_TIME" 
echo ----------------------------------------------------------------------

# if a clean build, remove everything
if $BUILD_CLEAN; then
    echo ----------------------------------------------------------------------
    echo "PTN: clean build ..."
    echo ----------------------------------------------------------------------

    if [ -d $PANTHEON_WORKFLOW_DIR ]; then
        rm -rf $PANTHEON_WORKFLOW_DIR
    fi
    if [ ! -d $PANTHEON_PATH ]; then
        mkdir $PANTHEON_PATH
    fi
    if [ ! -d $PANTHEON_PROJECT_DIR ]; then
        mkdir $PANTHEON_PROJECT_DIR
    fi
    mkdir $PANTHEON_WORKFLOW_DIR
    mkdir $PANTHEON_DATA_DIR
    mkdir $PANTHEON_RUN_DIR
fi

if $INSTALL_SPACK; then
    echo ----------------------------------------------------------------------
    echo "PTN: installing Spack ..."
    echo ----------------------------------------------------------------------

    pushd $PANTHEON_WORKFLOW_DIR > /dev/null 2>&1
    git clone https://github.com/spack/spack 
    pushd spack > /dev/null 2>&1
    git checkout $SPACK_COMMIT 
    popd > /dev/null 2>&1
    popd > /dev/null 2>&1
fi

if $INSTALL_ASCENT; then
    echo ----------------------------------------------------------------------
    echo "PTN: building gcc@6.4.0 ..."
    echo ----------------------------------------------------------------------
    . spack/share/spack/setup-env.sh
    spack install gcc@6.4.0

    echo ----------------------------------------------------------------------
    echo "PTN: building ASCENT ..."
    echo ----------------------------------------------------------------------

    # copy spack settings
    #module load gcc/6.4.0
    cp inputs/spack/spack.yaml $PANTHEON_WORKFLOW_DIR

    pushd $PANTHEON_WORKFLOW_DIR > /dev/null 2>&1
    # set compiler paths for spac
    # this is done to remove system-specific information from the spack.yaml file
    # which can be easily pulled from the environment during runtime
    COMPILER_LOC=`which gcc`
    sed -i "s#<system_gcc>#$COMPILER_LOC#" spack.yaml
    COMPILER_LOC=`which g++`
    sed -i "s#<system_gpp>#$COMPILER_LOC#" spack.yaml
    COMPILER_LOC=`which gfortran`
    sed -i "s#<system_gfortran>#$COMPILER_LOC#" spack.yaml
    PANTHEON_SYSTEM=`spack arch`
    PANTHEON_ARCH=${PANTHEON_SYSTEM##*-}
    PANTHEON_OS=`echo ${PANTHEON_SYSTEM} | sed 's/.*-\(.*\)-.*/\1/g'`
    sed -i "s#<system_os>#$PANTHEON_OS#" spack.yaml
    sed -i "s#<system_arch>#$PANTHEON_ARCH#" spack.yaml

    exit 0

    # activate spack and install Ascent
    . spack/share/spack/setup-env.sh
    spack -e . concretize -f 2>&1 | tee concretize.log
    spack mirror add $SPACK_NAME $SPACK_CACHE_URL
    wget $SPACK_E4S_PUB_URL
    spack gpg trust e4s.pub
    module load patchelf

    if $USE_SPACK_CACHE; then
        echo ----------------------------------------------------------------------
        echo "PTN: using Spack E4S cache ..."
        echo ----------------------------------------------------------------------

        time spack -e . install 
    else
        echo ----------------------------------------------------------------------
        echo "PTN: not using Spack E4S cache for Ascent..."
        echo ----------------------------------------------------------------------

        time spack -e . install --no-cache
    fi

    popd
fi

# build the application and parts as needed
if $INSTALL_APP; then
    echo ----------------------------------------------------------------------
    echo "PTN: installing app ..."
    echo ----------------------------------------------------------------------

    source $PANTHEON_SOURCE_ROOT/setup/install-app.sh
fi

END_TIME=$(date +"%r %Z")
echo ----------------------------------------------------------------------
echo "PTN: statistics" 
echo "PTN: start: $START_TIME"
echo "PTN: end  : $END_TIME"
echo ----------------------------------------------------------------------

