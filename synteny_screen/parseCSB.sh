#!/bin/bash
IN=output/21_06_2023_02_19_40_PM/archaea_CSBfinder_q2_ins3_cs_instances.fasta
ININST=$(echo $IN | sed 's/_instances.fasta//').txt
OUT=results/$(basename $IN .fasta)_FAS.tsv
OUTFIX=results/$(basename $IN .fasta)_FAS_single.tsv

while read -r line
do
	if [[ $(echo $line | grep ">") ]]
	then
		CSB=$(echo ${line} | sed 's/>//')
	else
		echo -e "$CSB\t$line"
	fi
done < <(python bin/fastaGrep.py <(grep -wFf data/SaciNOGs.txt ${ININST} ) $IN ) | sed 's/ /\t/g' | tee $OUT


#Fix multiple loci per line
awk -F"\t" '$9== ""' $OUT > $OUTFIX

while read -r line
do
	NCOLS=$(echo $line | wc -w)
	for col in $(seq 9 $NCOLS)
	do echo -e $line | cut -d" " --output-delimiter="#" -f1,2,3,4,5,6,7,${col} | sed 's/#/\t/g'
	done
done < <(awk -F"\t" '$9!= ""' $OUT) | tee -a $OUTFIX
