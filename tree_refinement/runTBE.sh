#!/bin/bash
source /local/one/software/miniconda3/bin/activate
conda activate raxml-ng
REFTREE=$1
BOOTTREES=$2
PREFIX=${3}/$(basename $REFTREE .treefile )_TBE
PREFIX2=${3}/$(basename $REFTREE .treefile )_combined

raxml-ng --support --tree $REFTREE --bs-trees $BOOTTREES --bs-metric tbe --prefix $PREFIX --precision 2 --redo
iqtree --support ${PREFIX}.raxml.support -t $BOOTTREES -pre $PREFIX2 --redo
