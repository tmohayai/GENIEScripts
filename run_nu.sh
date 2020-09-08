#!/bin/bash
VOLUME="volMPD"
#change gdml file name as needed
GDML_SHORT="nd_hall_only_lar"
#change the path of the gdml file as needed
GEO="${GDML_SHORT}.gdml"
MODE="neutrino"
POT=7.5e13
NEVENTS=100
ProcId=$1
LOC="DUNE_ND_HALL"
FLUXFILES="/pnfs/dune/persistent/users/mtanaz/gsimple_subdetectors/neutrino/gsimple*.root"
#change the final destination as needed
FINAL_DEST="/pnfs/dune/persistent/users/mtanaz/production"

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh

setup genie        v2_12_10c  -q e15:prof
setup genie_xsec   v2_12_10   -q DefaultPlusValenciaMEC
setup genie_phyopt v2_12_10   -q dkcharmtau
setup dk2nu        v01_05_01b -q e15:prof
setup ifdhc

#########=========================================
seed=${RANDOM}

#echo the path to the directory where your job runs, in case
#you want to recover files
echo "========================================================================="
echo "HOST=${HOST}, seed=${seed}"
echo "Running genie generation for volume ${VOLUME} with geometry ${GEO} in mode ${MODE}"
echo "Location ${LOC}, POT=${POT} or NEVENTS=${NEVENTS}"
echo "Flux files: ${FLUXFILES}"
echo "========================================================================="
echo " "
echo " "

# Create the ray flux file ${GDML_SHORT}.${VOLUME}.maxpl.xml

echo "Generation of the ray flux file ${GDML_SHORT}.${VOLUME}.maxpl.xml"

gevgen_fnal \
-f ${FLUXFILES},${LOC} \
-g ${GEO} \
-t ${VOLUME} \
-m "+${GDML_SHORT}.${VOLUME}.maxpl.xml" \
-S "+25000" \
-L "cm" -D "g_cm3" \
-n ${NEVENTS} \
--seed ${seed} \
-r 9999 \
-o ${MODE} \
--message-thresholds Messenger_production.xml \
--cross-sections ${GENIEXSECPATH}/gxspl-FNALsmall.xml \
--event-generator-list Default+CCMEC

