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
	grep ">" ${OUTD}/${COG}_GTDB.faa \
		| sed 's/ #.*//' \
		| grep -wEf <(sed 's/#/\.\*/' results/ComplexIslands_members.txt \
		| sed 's/#/\.\*_/') \
		| sed 's/>//' \
		> ${OUTD}/${COG}_GTDB_grep.txt
	seqtk subseq ${OUTD}/${COG}_GTDB.faa ${OUTD}/${COG}_GTDB_grep.txt > ${OUTD}/${COG}_GTDB_grep.faa
	conda activate famsa2
	famsa -refine_mode on ${OUTD}/${COG}_GTDB_grep.faa ${OUTD}/${COG}_GTDB_grep.aln
	trimal -in ${OUTD}/${COG}_GTDB_grep.aln -out ${OUTD}/${COG}_GTDB_grep.trim.aln -gt 0.1
	FastTreeMP ${OUTD}/${COG}_GTDB_grep.trim.aln > ${RESD}/${COG}_GTDB_grep.trim.tre
done
