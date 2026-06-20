#!/bin/bash
SCRIPT=$1
GENOME=$2
TMPDIR=$3

while read -r line
do
	bash ${SCRIPT} $line ${TMPDIR}/${GENOME}.anno.tsv
done < ${TMPDIR}/${GENOME}.prot.txt
