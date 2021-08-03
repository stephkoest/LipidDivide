#!/usr/bin/bash
INFILE=$1
INDIR=$(dirname $INFILE)
OUTFILE=${INDIR}/$(basename $INFILE .faa)_interpro.tsv

interproscan.sh -dp -cpu 8 -appl Pfam -f tsv -iprlookup --pathways -i $INFILE -o $OUTFILE --tempdir /tmp/interpro

