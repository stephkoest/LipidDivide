#!/bin/bash
ANNOF=results/archaea_sprep_proteome_emapper.emapper.annotations
ARANNOF=results/archaea_sprep_proteome_emapper_fine.tsv
PROTMAP=data/archaea_cont2protein_map.txt
PROTCOGMAP=data/archaea_cont2protein_COG_map.txt
PROTARCOGMAP=data/archaea_cont2protein_arCOG_map.txt
TMPDIR=$(mktemp -d)

##### GREP PROTEIN IDS AND POSITIONS #####
grep ">" ../dataset/gtdb/v202/protein_faa_reps/archaea/*.faa | cut -d "/" -f7 | sed 's/_protein.faa:>/#/' | sed 's/ //g' | cut -d"#" -f1,2,2,5 | sed 's/#1$/#+/' | sed 's/1$//' | awk -F"#" '{contig=$2;gsub(/_.*/,"", $2); print $1"#"$2"#"contig"#"$3}' > $PROTMAP

##### GREP extract COG annotation with parallel #####
#make genome list
cut -d "#" -f1  $PROTMAP | sort -u > ${TMPDIR}/genomelist.txt
#split files into genomes
cat ${TMPDIR}/genomelist.txt | parallel -j 38 "grep {} ${ANNOF} > ${TMPDIR}/{}.anno.tsv"
cat ${TMPDIR}/genomelist.txt | parallel -j 38 "grep {} ${PROTMAP} > ${TMPDIR}/{}.prot.txt"

#assign COGs
cat ${TMPDIR}/genomelist.txt | parallel -j 38 "bash bin/grepWhile.sh bin/grepCOG.sh {} ${TMPDIR}  | sed 's/#$/#X/' > ${TMPDIR}/{}.COGmap.txt"
cat ${TMPDIR}/*.COGmap.txt >  $PROTCOGMAP

#assign asCOGs
rm ${TMPDIR}/*.anno.tsv
cat ${TMPDIR}/genomelist.txt | parallel -j 38 "grep {} ${ARANNOF} > ${TMPDIR}/{}.anno.tsv"
cat ${TMPDIR}/genomelist.txt | parallel -j 38 "bash bin/grepWhile.sh bin/grepArCOG.sh {} ${TMPDIR}  | sed 's/#$/#X/' > ${TMPDIR}/{}.arCOGmap.txt" 
cat ${TMPDIR}/*.arCOGmap.txt >  $PROTARCOGMAP


##### make COG CSB input file #####
cat ${TMPDIR}/genomelist.txt | parallel -j 38 "bash bin/makeCOGCSBinput.sh {} COGmap.txt CSB.tsv $TMPDIR"
cat ${TMPDIR}/*.CSB.tsv > data/archaea_CSBfinder_input.fasta

rm -r $TMPDIR
