#!/bin/bash
NOG=$1
DATAD=/local/one/data/LipidDivide/dataset/eggnog/v5
DATAUNTARD=${DATAD}/database
LOOKUPD=${DATAD}/lookup
OUTD=data/LUCA_NOGs

#get filelist for greping LUCA NOG members 
FILELIST=$(zgrep -hwFf <(zgrep -w $NOG ${LOOKUPD}/1_LUCA_members.tsv.gz | awk '{print $5}' | sed 's/,/\n/g') ${LOOKUPD}/2*_members.tsv.gz  |awk -v dir=$DATAUNTARD '{print dir"/"$1"/"$2".raw_alg.faa.gz"}' | sort -u)

for file in $FILELIST
do
	if [ ! -f $file ]
	then
		echo $file does not exist
		NOG=$(basename $file .raw_alg.faa.gz)
		wget http://eggnogapi5.embl.de/nog_data/file/fasta/${NOG} -O $file
	fi
done

echo greping sequences
python bin/fastaGrep.py <(zgrep $NOG ${LOOKUPD}/1_LUCA_members.tsv.gz | awk '{print $5}' | sed 's/,/\n/g') <(zcat $FILELIST) | python bin/unalignAlignment.py > ${OUTD}/${1}.faa
seqmagick mogrify --deduplicate-taxa ${OUTD}/${1}.faa
