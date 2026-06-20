#!/bin/bash
GENOME=$1
INEXT=$2
OUTEXT=$3
TMPDIR=$4

for contig in $(cut -d'#' -f1 ${TMPDIR}/${GENOME}.${INEXT} | sort -u)
do
	echo ">${contig}"
	grep $contig ${TMPDIR}/${GENOME}.${INEXT} | awk -F'#' '{print $4"\t"$3}' 
done > ${TMPDIR}/${GENOME}.${OUTEXT}
