# Before running this script copy the desired geometry file to your working area; for a list of geometries visit: 
# https://cdcvs.fnal.gov/redmine/attachments/61423/nd_hall_geometries_20_10_20.tar.gz
# Once you downloaded the desired geometry/gdml file, make sure you change the "GEOMETRY" and "TOPVOL" to the appropriate arguments. 
# GEOMETRY is set to nd_hall_mpd_only, by default. That corresponds to nd_hall_mpd_only.gdml file and is the geometry for only an ND-GAr in the near detector hall.
# TOPVOL volGasTPC is the gas TPC only portion of ND_GAr.


#! /usr/bin/env bash

####################

HORN=$1
NPER=$2
FIRST=$3
TEST=$4

# Test change

# GENIE gevgen_fnal app requires the user to input the neutrino running mode; FHC is forward horn current for neutrino running mode and RHC is 
# reverse horn current for anti-neutrino running mode

# To generate neutrino mode GENIE files, type "source run_nu.sh FHC" on the command line. For anti-neutrino running mode, type "source run_nu.sh RHC", instead.

if [ "${HORN}" != "FHC" ] && [ "${HORN}" != "RHC" ]; then
    echo "Invalid beam mode ${HORN}"
    echo "Must be FHC or RHC"
    kill -INT $$
fi

if [ "${NPER}" = "" ]; then
    echo "Number of events per job not specified, using 1000"
    NPER=1000
fi

if [ "${FIRST}" = "" ]; then
    echo "First run number not specified, using 0"
    FIRST=0
fi

CP="ifdh cp"
#CP="cp"
if [ "${TEST}" = "test" ]; then
    echo "In TEST mode, assuming interactive running"
    PROCESS=0
fi

MODE="neutrino"
if [ "${HORN}" = "RHC" ]; then
MODE="antineutrino"
fi

echo "Running gevgen for ${NPER} events in ${HORN} mode"
RNDSEED=$((${PROCESS}+${FIRST}))
#NEVENTS="-n ${NPER}"      # No. of events, -e XE16 for POT

#
GEOMETRY="nd_hall_only_mpd" 
TOPVOL="volTPCGas"
SPOT=10
NEVENTS="-n 200"
PROD="PROD1"

# note: change the output path to point to your working area 
OUTDIR="/pnfs/dune/persistent/users/mtanaz/"

OUTFLAG="GasTPC"

####################

## Setup UPS and required products

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh

setup genie        v2_12_10c  -q e15:prof
setup genie_xsec   v2_12_10   -q DefaultPlusValenciaMEC
setup genie_phyopt v2_12_10   -q dkcharmtau
#setup dk2nu        v01_05_01b -q e15:prof
setup ifdhc

####################

## Run GENIE 

# For more information on gevgen_fnal, visit: https://cdcvs.fnal.gov/redmine/projects/genie/wiki/Running_gevgen_fnal

export GXMLPATH=${PWD}:${GXMLPATH}
export GNUMIXML="GNuMIFlux_DUNE_ND.xml"

gevgen_fnal \
    -f /pnfs/dune/persistent/users/mtanaz/gsimple_subdetectors/${MODE}/gsimple*.root,DUNEND_ND_NEAR_FID1 \
    -g ${GEOMETRY}.gdml \
    -t ${TOPVOL} \
    -L cm -D g_cm3 \
    ${NEVENTS} \
    --seed ${RNDSEED} \
    -r ${RNDSEED} \
    -o ${MODE} \
    --message-thresholds Messenger_production.xml \
    --cross-sections ${GENIEXSECPATH}/gxspl-FNALsmall.xml \
    --event-record-print-level 0 \
    --event-generator-list Default+CCMEC

