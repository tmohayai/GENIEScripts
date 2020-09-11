#!/bin/bash
#source /grid/fermiapp/products/dune/setup_dune.sh
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup cmake v3_9_0

setup gcc v6_4_0

setup genie        v2_12_10c  -q e15:prof
setup genie_xsec   v2_12_10   -q DefaultPlusValenciaMEC
setup genie_phyopt v2_12_10   -q dkcharmtau
setup geant4 v4_10_3_p01b -q e15:prof



G4_cmake_file=`find ${GEANT4_FQ_DIR}/lib64 -name 'Geant4Config.cmake'`
echo $G4_cmake_file
export TBB_DIR=/cvmfs/larsoft.opensciencegrid.org/products/tbb/v2018_1
export TBB_LIB=/cvmfs/larsoft.opensciencegrid.org/products/tbb/v2018_1/Linux64bit+2.6-2.12-e15-prof/lib
export TBB_INC=/cvmfs/larsoft.opensciencegrid.org/products/tbb/v2018_1/Linux64bit+2.6-2.12-e15-prof/include

export Geant4_DIR=`dirname $G4_cmake_file`

export PATH=$PATH:$GEANT4_FQ_DIR/bin
export G4_data=$G4_data:/cvmfs/larsoft.opensciencegrid.org/products
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PWD}/edep-sim/lib

export Geant4_DIR=$PATH:/cvmfs/larsoft.opensciencegrid.org/products/g4nuclide/v2_1/G4ENSDFSTATE2.1/ENSDFSTATE.dat

cd /dune/app/users/mtanaz/edep-sim
source setup.sh
cd ../
