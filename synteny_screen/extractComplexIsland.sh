#!/bin/bash
awk -F"\t" 'NR>1{print $1"#"$3}' results/ComplexIslands.txt \
	| sed 's/|\[/#/' \
	| sed 's/,/#/' \
	| sed 's/\]//' > results/ComplexIslands_split.txt 
	
while read -r line
do
	GENOME=$(echo $line | awk -F"#" '{print $1}')
	CONTIG=$(echo $line | awk -F"#" '{print $2}')
	START=$(echo $line | awk -F"#" '{print $3}')
	STOP=$(echo $line | awk -F"#" '{print $4}')
	for i in $(seq $START $STOP)
	do
		echo -e "${GENOME}#${CONTIG}#${i}"
	done
done < results/ComplexIslands_split.txt | sort -h | uniq > results/ComplexIslands_members.txt
