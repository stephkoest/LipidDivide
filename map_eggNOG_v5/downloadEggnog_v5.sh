#!/bin/bash
DATAD=/local/one/data/LipidDivide/dataset/eggnog/v5
DATAUNTARD=${DATAD}/database
LOOKUPD=${DATAD}/lookup

mkdir -p $DATAD $LOOKUPD
#download LUCA NOG memberships
wget http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/1/1_members.tsv.gz -O ${LOOKUPD}/1_LUCA_members.tsv.gz
wget http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2/2_members.tsv.gz -O ${LOOKUPD}/2_Bacteria_members.tsv.gz
wget http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2759/2759_members.tsv.gz -O ${LOOKUPD}/2759_Eukaryota_members.tsv.gz
wget http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2157/2157_members.tsv.gz -O ${LOOKUPD}/2157_Archaea_members.tsv.gz
date > $LOOKUPD/eggnog5_download_date.txt

#download eggnog raw alignments for each domain
wget http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2/2_raw_algs.tar -O ${DATAD}/Bacteria_raw_algs.tar
wget http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2759/2759_raw_algs.tar -O ${DATAD}/Eukaryota_raw_algs.tar
wget http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2157/2157_raw_algs.tar -O ${DATAD}/Archaea_raw_algs.tar
date > $DATAD/eggnog5_download_date.txt

mkdir -p $DATAUNTARD

for file in ${DATAD}/Bacteria_raw_algs.tar ${DATAD}/Eukaryota_raw_algs.tar ${DATAD}/Archaea_raw_algs.tar
do
	tar -xvf $file -C $DATAUNTARD
done

date > $DATAUNTARD/unpack_date.txt

#likely unnecessary
##mape NOG locus mapping for all domains
#find $DATAUNTARD -name "*.raw_alg.faa.gz" | while read -r file; do
#    zgrep '>' $file | awk -v var=$(basename $file .raw_alg.faa.gz) '{print var"\t"$1}' | sed 's/>//'
#done > $DATAUNTARD/NOG_locus_mapping.tsv

