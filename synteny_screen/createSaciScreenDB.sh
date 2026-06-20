#!/bin/bash
DATAD=/local/one/data/LipidDivide/eggNOG_subtree
WORKD=data/SaciScreen
ANNOF=results/archaea_sprep_proteome_emapper.LUCA.NOG.tsv
GTDBPROTF=data/GTDB_reps/v202/archaea_sprep_proteome.faa
RESD=results/SaciScreen
CPU=8

mkdir -p $WORKD $RESD
ln -s ${DATAD}/results/*.80.trim.1.noLong.focalclade.homologs.ingroup.txt ${DATAD}/results/*.80.trim.1.noLong.focalclade.homologs.faa $WORKD

for COG in $(ls $WORKD | cut -d"." -f1 | sort -u )
do
        echo Working on $COG
	if [ ! -f "${WORKD}/${COG}.GTDB.faa" ]; then
		echo Grabbing mapped GTDB prots
        	seqtk subseq $GTDBPROTF <(grep -w $COG $ANNOF | awk '{print $3}')  > ${WORKD}/${COG}.GTDB.faa
	fi
	if [ ! -f "${WORKD}/${COG}.GTDB_db" ]; then
		echo Creating GTDB prots database
        	mmseqs createdb ${WORKD}/${COG}.GTDB.faa ${WORKD}/${COG}.GTDB_db
	fi
	if [ ! -f "${WORKD}/${COG}.EggNOG_db" ]; then
		echo Creating GTDB prots database
        	mmseqs createdb ${WORKD}/${COG}.80.trim.1.noLong.focalclade.homologs.faa ${WORKD}/${COG}.EggNOG_db
	fi
	if [ ! -f "${WORKD}/${COG}.GTDB_EggNOG_res" ]; then
		echo Running search
		mmseqs search ${WORKD}/${COG}.GTDB_db ${WORKD}/${COG}.EggNOG_db ${WORKD}/${COG}.GTDB_EggNOG_res tmp --threads $CPU --remove-tmp-files 1 -a
	fi
	if [ ! -f "${WORKD}/${COG}.GTDB_EggNOG_res_topHit" ]; then
		echo Filtering top hits
		mmseqs filterdb ${WORKD}/${COG}.GTDB_EggNOG_res ${WORKD}/${COG}.GTDB_EggNOG_res_topHit --extract-lines 1 --threads $CPU
	fi
	if [ ! -f "${RESD}/${COG}.GTDB_EggNOG_res_topHit.tsv" ]; then
		mmseqs createtsv ${WORKD}/${COG}.GTDB_db ${WORKD}/${COG}.EggNOG_db ${WORKD}/${COG}.GTDB_EggNOG_res_topHit ${RESD}/${COG}.GTDB_EggNOG_res_topHit.tsv
	fi
done

echo "Collecting results in ${RESD}/*.GTDB_EggNOG_res_topHit.tsv and saving to results/GTDB_EggNOG_res_topHit.tsv"
cat ${RESD}/*.GTDB_EggNOG_res_topHit.tsv | awk -F"\t" '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' > results/GTDB_EggNOG_res_topHit.tsv
echo "Creating mapping file"
for file in ${WORKD}/*.80.trim.1.noLong.focalclade.homologs.ingroup.txt
do
	COG=$(basename $file | cut -d"." -f1)
	awk -v COG=$COG '{print COG"\t"$1}' $file 
done > results/GTDB_EggNOG_ingroups.tsv
