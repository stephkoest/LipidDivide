#!/bin/bash

COG=COG0183
INALI=data/${COG}.round1.combined.trim.40.aln
#extract treefile location and model from log file
ROUND1LOG=results/${COG}.round2.log
INTREE=$(grep "Maximum-likelihood tree:" $ROUND1LOG | cut -d":" -f2 | awk '{print $1}')
MODEL=$(grep "Best-fit model:" $ROUND1LOG | cut -d":" -f2 | awk '{print $1}')
PREFIX=results/${COG}.round2_PMSF
CPU=25

iqtree -seed 12345 -s $INALI -m $MODEL -nt $CPU -wsl -wsr -wbt -b 100 -ft $INTREE -pre $PREFIX
