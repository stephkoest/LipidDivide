#!/bin/bash
OUTD=results/emapper
mkdir -p results $OUTD

#for file in /local/one/data/LipidDivide/dataset/gtdb/v202/protein_faa_reps/archaea/*.faa
#do
#        GNAME=$(basename $file _protein.faa)
#	echo working on $GNAME
#	OUTFILE=${OUTD}/${GNAME}
#        /webapp/tools/micevo/bin/emapper.py -m mmseqs --mmseqs_db ../dataset/eggnog/v5/mmseq2/mmseqs/mmseqs.db --cpu 12 --no_annot -o ${OUTFILE} -i $file --no_file_comments
#done
mmseqs touchdb ../dataset/eggnog/v5/mmseq2/mmseqs/mmseqs.db

for file in archaea_sprep_proteome_chunk*
do
	echo
	echo working on $file
	echo
	emapper.py  -m mmseqs --mmseqs_db ../dataset/eggnog/v5/mmseq2/mmseqs/mmseqs.db --cpu 38 --no_annot -o results/emapper/${file} -i $file --no_file_comments
done

cat results/emapper/archaea_sprep_proteome_chunk0* > results/archaea_sprep_proteome.seed_orthologs

emapper.py -m no_search --annotate_hits_table results/archaea_sprep_proteome.seed_orthologs --no_file_comments --cpu 10 --dbmem --tax_scope 1 --data_dir ../dataset/eggnog/v5/mmseq2 -o results/archaea_sprep_proteome_emapper

python bin/parseEmapperNOGs.py results/archaea_sprep_proteome_emapper.emapper.annotations | sed 's/|/\t/' | awk '{print $1"\t"$2"\t"$1"|"$2"\t"$3}' > results/archaea_sprep_proteome_emapper.LUCA.NOG.tsv
