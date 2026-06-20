#!/bin/bash
#data/COG0183.round1.combined.trim.aln
COG=COG2030
INALI=data/${COG}.round2.combined.trim.40.aln
PREFIX=results/${COG}.round3
CPU=18

iqtree -s $INALI -m MFP -mset LG,LG+C10,LG+C20,LG+C30,LG+C40,LG+C50,LG+C60,LG4M,LG4X -mrate ,G4,R4,R5,R6 -mfreq ,F -nt $CPU -wsr -wsl -wbt -alrt 1000 -bb 1000 -seed 12345 -pre $PREFIX

ROUND1LOG=${PREFIX}.log
INTREE=$(grep "Maximum-likelihood tree:" $ROUND1LOG | sort -u | cut -d":" -f2 | awk '{print $1}')
MODEL=$(grep "Best-fit model:" $ROUND1LOG | sort -u | cut -d":" -f2 | awk '{print $1}')
PREFIX=results/${COG}.round3_PMSF

iqtree -seed 12345 -s $INALI -m $MODEL -nt $CPU -wsl -wsr -wbt -b 100 -ft $INTREE -pre $PREFIX
