#!/bin/bash

source ./pantheon/env.sh > /dev/null 2>&1


# make the cinema data directory 
mkdir $PANTHEON_RUN_DIR/cinema_databases

# install cinema viewers
cp -rf inputs/cinema/* $PANTHEON_RUN_DIR/cinema_databases
    # redirect the python notebook viewer to the database
sed -i "s#CINEMA_DB_PATH#$PANTHEON_CDB#" $PANTHEON_RUN_DIR/cinema_databases/cinema.ipynb 

pushd $PANTHEON_RUN_DIR > /dev/null 2>&1
pushd cinema_databases  > /dev/null 2>&1

# convert the output from ascent HDF5 to CIS
module load python/3.7.0-anaconda3-5.3.0
./cisconvert --verbose --input ../ --output pantheon.cdb
    # clean up
rm -f  cisconvert
popd > /dev/null 2>&1

echo "----------------------------------------------------------------------"
echo "PTN: Post-processing" 
echo "     packaging up cinema database to:" 

# bundle up the results
TARNAME=cinema_databases
echo "     $PANTHEON_DATA_DIR/${TARNAME}.tar.gz" 
echo "----------------------------------------------------------------------"

tar -czvf ${TARNAME}.tar.gz $TARNAME > /dev/null 2>&1
mv ${TARNAME}.tar.gz $PANTHEON_DATA_DIR

popd > /dev/null 2>&1

