#!/bin/bash
LOOKUPF=/local/one/data/LipidDivide/dataset/eggnog/v5/lookup/1_LUCA_members.tsv.gz
ANNOF=results/archaea_sprep_proteome_emapper.LUCA.NOG.tsv
GTDBPROTF=data/GTDB_reps/v202/archaea_sprep_proteome.faa
OUTD=data/NOGs
RESD=results/trees
CPU=8

source  /local/one/software/miniconda3/bin/activate

mkdir -p $OUTD $RESD

for COG in $(awk '{print $1}' data/targetCOGs_BOx.txt)
do
	echo Working on $COG
	#echo Grabbing EggNOG db
	#bash bin/getNOG.sh $COG $LOOKUPF ${OUTD}/${COG}.faa
	echo Grabbing mapped GTDB prots
	seqtk subseq $GTDBPROTF <(grep -w $COG $ANNOF | awk '{print $3}')  > ${OUTD}/${COG}_GTDB.faa
	#echo clustering NOG
	#cd-hit -i ${OUTD}/${COG}.faa  -o ${OUTD}/${COG}.80.faa -c 0.8 -M 8000
	
	#awk '{print $1}' ${OUTD}/${COG}.80.faa ${OUTD}/${COG}_GTDB.80.faa > ${RESD}/${COG}.80_merge.faa
	conda activate famsa2
	famsa -refine_mode on ${OUTD}/${COG}_GTDB.faa ${OUTD}/${COG}_GTDB.aln
	trimal -in ${OUTD}/${COG}_GTDB.aln -out ${OUTD}/${COG}_GTDB.trim.aln -gt 0.1
	FastTreeMP ${OUTD}/${COG}_GTDB.trim.aln > ${RESD}/${COG}_GTDB.trim.tre
	#echo clustering GTDB sequences
	#cd-hit -i ${OUTD}/${COG}_GTDB.faa  -o ${OUTD}/${COG}_GTDB.80.faa -c 0.8 -M 8000
	#awk '{print $1}' ${OUTD}/${COG}.80.faa ${OUTD}/${COG}_GTDB.80.faa > ${RESD}/${COG}.80_merge.faa
	#mafft --anysymbol --thread $CPU --auto ${RESD}/${COG}.80_merge.faa > ${RESD}/${COG}.80_merge.aln
	#trimal -in ${RESD}/${COG}.80_merge.aln -out ${RESD}/${COG}.80_merge.trim.aln -gappyout
	#FastTree ${RESD}/${COG}.80_merge.trim.aln > ${RESD}/${COG}.80_merge.trim.tre
done
