#!/bin/bash
NOG=$1
LOOKUPF=$2
LOOKUPD=$(dirname $LOOKUPF)
DATAUNTARD=$(dirname $LOOKUPD)/database
OUTF=$3
mkdir -p $(dirname $OUTF)

#get filelist for greping LUCA NOG members 
FILELIST=$(zgrep -hwFf <(zgrep -w $NOG $LOOKUPF | awk '{print $5}' | sed 's/,/\n/g') ${LOOKUPD}/2*_members.tsv.gz  | awk -v dir=$DATAUNTARD '{print dir"/"$1"/"$2".raw_alg.faa.gz"}' | sort -u)

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
python bin/fastaGrep.py <(zgrep $NOG ${LOOKUPF} | awk '{print $5}' | sed 's/,/\n/g') <(zcat $FILELIST) | python bin/unalignAlignment.py > ${OUTF}
seqmagick mogrify --deduplicate-taxa ${OUTF}
