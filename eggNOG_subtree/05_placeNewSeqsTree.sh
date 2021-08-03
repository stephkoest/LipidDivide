#!/bin/bash
BACKBONEFAA=data/LUCA_NOGs/COG1064.faa
BACKBONEALI=results/COG1064.80.trim.0.4_noLong.aln
ADDFASTA=results/COG1064.80.focal_targets.80_rename.faa
FOCALCLADE=results/COG1064.80.trim.0.4.fasttree.focalclade.txt
OUTGROUPCLADE=results/COG1064.80.trim.0.4.fasttree.focaloutgroup.txt
OUTDIR=$(dirname $BACKBONEALI)
MINCONS=0.4

#add to alignment
FULLALI=${OUTDIR}/$(basename ${BACKBONEALI} .aln)_focalTargets.aln
#mafft --add $ADDFASTA --keeplength --anysymbol --thread 38 $BACKBONEALI > $FULLALI
#seqmagick mogrify --deduplicate-taxa --input-format fasta --output-format fasta $FULLALI
#
FULLALIFILTER=${OUTDIR}/$(basename $FULLALI .aln).filter.aln
#python bin/filter_shortSeqs_MSA.py $FULLALI $MINCONS > $FULLALIFILTER
FULLTREE=${OUTDIR}/$(basename $FULLALIFILTER .aln).tre
#FastTree $FULLALIFILTER > $FULLTREE
echo tree done $FULLTREE

IDFILE=${OUTDIR}/$(basename $FULLALIFILTER .aln).names.txt
#python bin/parseEggnogTaxonomy.py $FULLTREE $IDFILE
python bin/plotLargeTree.py $FULLTREE ${OUTDIR}/$(basename $FULLTREE .tre).pdf $IDFILE

#shrinking tree
SHRINKBASE=${OUTDIR}/$(basename $FULLTREE .tre).shrink
run_treeshrink.py -t $FULLTREE --mode per-gene -O $SHRINKBASE --outdir . -f -c -q 0.01
FULLALIFILTERNOLONG=${OUTDIR}/$(basename $FULLALIFILTER .aln)_noLong.aln
#filter out long branch sequences
#seqmagick convert --exclude-from-file <(sed 's/\t/\n/g' ${SHRINKBASE}.txt) --input-format fasta --output-format fasta $FULLALIFILTER $FULLALIFILTERNOLONG
echo long-branch filtered alignment in $FULLALIFILTERNOLONG

#do new tree
FULLTREENOLONG=${OUTDIR}/$(basename $FULLALIFILTERNOLONG .aln).tre
#FastTree $FULLALIFILTERNOLONG > $FULLTREENOLONG
echo tree done $FULLTREENOLONG
python bin/plotLargeTree.py $FULLTREENOLONG ${OUTDIR}/$(basename $FULLTREENOLONG .tre).pdf $IDFILE

FULLTREEROOT=${OUTDIR}/$(basename $FULLTREENOLONG .tre).root.tre
gotree reroot midpoint -i $FULLTREENOLONG -o $FULLTREEROOT

FULLTREENOLONG=$FULLTREEROOT
EXTENDEDFOCAL=${OUTDIR}/$(basename $FULLTREENOLONG .tre)_focalClade.txt
nw_clade $FULLTREENOLONG $(cat $FOCALCLADE) | nw_labels -I - > $EXTENDEDFOCAL

OUTFASTA=${OUTDIR}/$(basename $FOCALCLADE .fasttree.focalclade.txt)_extendedFocal.faa
python bin/fastaGrep.py <(cat $OUTGROUPCLADE $EXTENDEDFOCAL) <(cat $BACKBONEFAA $ADDFASTA) > $OUTFASTA
echo Extended focal clade with outgroup in $OUTFASTA
