#!/bin/bash
THREADS=38
MODELADD="LG+C10,LG+C10+G,LG+C10+F,LG+C10+G+F,LG+C20,LG+C20+G,LG+C20+F,LG+C20+G+F,LG+C30,LG+C30+G,LG+C30+F,LG+C30+G+F,LG+C40,LG+C40+G,LG+C40+F,LG+C40+G+F,LG+C50,LG+C50+G,LG+C50+F,LG+C50+G+F,LG+C60,LG+C60+G,LG+C60+F,LG+C60+G+F"
#FOCALFAA=$1
FOCALFAA=results/COG1064.80.trim.0.4_extendedFocal.faa
INDIR=$(dirname $FOCALFAA)
#OUTGROUPCLADE=$2
OUTGROUPCLADE=results/COG1064.80.trim.0.4.fasttree.focaloutgroup.txt
NAMES=results/COG1064.80.trim.0.4_noLong_focalTargets.filter.names.txt

ALI=${INDIR}/$(basename $FOCALFAA .faa).aln
echo
echo "Aligning ${ALI}"
echo
#mafft --maxiterate 100 --genafpair --thread $THREADS $FOCALFAA > $ALI
#mafft --anysymbol --maxiterate 100 --auto --thread $THREADS $FOCALFAA > $ALI
echo Alignment in $ALI
echo
echo Trimming
echo
TRIM=${INDIR}/$(basename $ALI .aln).trim.aln
#trimal -in $ALI -out $TRIM -gappyout

echo
echo running interpro
echo
#bash bin/runInterpro.sh $FOCALFAA

#iqtree -s $TRIM -pre ${INDIR}/$(basename $TRIM) -T AUTO -m MFP --mset LG,LG+C10,LG+C20,LG+C30,LG+C40,LG+C50,LG+C60 -mrate ,G4,R4,R5,R6,R7,R8,R9,R10 -mfreq ,F -bb 1000 -alrt 1000 --redo -seed 12345 

#iqtree -s $TRIM -pre ${INDIR}/$(basename $TRIM) -T 3 -m MFP -mset LG -mrate ,R4,G4 -mfreq ,R -bb 1000 --redo -seed 12345
OUTTREE=${INDIR}/$(basename $TRIM).fasttree.tre
#FastTree $TRIM > $OUTTREE
echo $OUTTREE
python bin/plotTree.py $OUTTREE ${INDIR}/$(basename $OUTTREE .tre).pdf $NAMES  ${INDIR}/$(basename $FOCALFAA .faa)_interpro.tsv $OUTGROUPCLADE
