#!/bin/bash
for file in /local/one/data/LipidDivide/dataset/gtdb/v202/protein_faa_reps/archaea/*.faa
do
	GNAME=$(basename $file _protein.faa)
	cat $file | sed "s/>/>${GNAME}|/"
done | seqtk seq -l 0 - > data/GTDB_reps/v202/archaea_sprep_proteome.faa
grep ">" data/GTDB_reps/v202/archaea_sprep_proteome.faa | sed 's/>//' | sed 's/ # /\t/g' > data/GTDB_reps/v202/archaea_sprep_proteome_localization.tsv
