#!/bin/bash
INFILE=$1
INDIR=$(dirname $INFILE)
RESD=$2
IDENTITY=80
MINCONS=0.4
NTHREADS=18

INFILEDEREP=${RESD}/$(basename $INFILE .faa).$IDENTITY.faa
cd-hit -i $INFILE -o ${INFILEDEREP} -c 0.$IDENTITY -T 10 -M 8000
#run alignment
INALI=${RESD}/$(basename $INFILEDEREP .faa).aln
mafft --anysymbol --thread $NTHREADS --auto $INFILEDEREP > $INALI
INALITRIM=${RESD}/$(basename $INALI .aln).trim.aln
trimal -in $INALI -out $INALITRIM -gappyout
#### remove short sequences?
INALITRIMFILTER=${RESD}/$(basename $INALITRIM .aln).${MINCONS}.aln
#python bin/filter_shortSeqs_MSA.py $INALITRIM $MINCONS > $INALITRIMFILTER
LOG=${RESD}/$(basename $INALITRIMFILTER .aln).fasttree.log
FASTTREE=${RESD}/$(basename $INALITRIMFILTER .aln).fasttree.tre
#FastTree -log $LOG $INALITRIMFILTER > $FASTTREE
#plot first tree
IDFILE=${RESD}/$(basename $INALITRIMFILTER .aln).names.txt
python bin/parseEggnogTaxonomy.py $FASTTREE $IDFILE
echo IDs pased into $IDFILE
python bin/plotLargeTree.py $FASTTREE ${RESD}/$(basename $FASTTREE .tre).pdf $IDFILE
#exclude outlier tree branches
SHRINKBASE=${RESD}/$(basename $FASTTREE .tre).shrink
run_treeshrink.py -t $FASTTREE --mode per-gene -O $SHRINKBASE --outdir . -f -c -q 0.01
INALITRIMFILTERNOLONG=${RESD}/$(basename $INALITRIMFILTER .aln)_noLong.aln
#filter out long branch sequences
seqmagick convert --exclude-from-file <(sed 's/\t/\n/g' ${SHRINKBASE}.txt) --input-format fasta --output-format fasta $INALITRIMFILTER $INALITRIMFILTERNOLONG
#redo fasttree
FASTTREE2=${RESD}/$(basename $FASTTREE .tre)_noLong.tre
FastTree -log $LOG $INALITRIMFILTERNOLONG > $FASTTREE2
python bin/plotLargeTree.py $FASTTREE2 ${RESD}/$(basename $FASTTREE2 .pdf)
