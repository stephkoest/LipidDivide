#!bin/bash
KEEPTAX=330779.Saci
OUTD=../Trees_round2_addJan/data
mkdir -p $OUTD

for COG in $(echo COG1545 COG0183) #$(ls results | cut -d"." -f1 | sort -u)
do
	BESTTREE=results/${COG}.80.trim.1.noLong.focalclade.homologs.selected.pruned.combined.trim.40.treefile
	BOOTTREES=results/${COG}.80.trim.1.noLong.focalclade.homologs.selected.pruned.combined.trim.40.ufboot
	FAA=results/${COG}.80.trim.1.noLong.focalclade.homologs.selected.pruned.faa
	ALI=results/${COG}.80.trim.1.noLong.focalclade.homologs.selected.pruned.combined.trim.40.aln

	BASENAME=$(basename $BESTTREE | cut -d"." -f1 ).round1
	## run RogueNaRok
	./software/RogueNaRok/RogueNaRok -i $BOOTTREES -n $BASENAME  -t $BESTTREE -w $OUTD

	## run Treeshrink
	run_treeshrink.py -t $BESTTREE --mode per-gene -O treeshrink_${BASENAME} --outdir $OUTD -f -c -q 0.01 --force

	cat <(awk 'NR>1 {print $3}' ${OUTD}/RogueNaRok_droppedRogues.${BASENAME} | grep -wv NA) ${OUTD}/treeshrink_${BASENAME}.txt | sed 's/\t/\n/g' | sort -u  | grep -v "^$" | grep -v $KEEPTAX > ${OUTD}/${BASENAME}_exclude.txt

	echo excluding sequences in ${OUTD}/${BASENAME}_exclude.txt
	python bin/fastaGrep.py <(grep ">" $ALI | sed 's/>//' | grep -vwFf ${OUTD}/${BASENAME}_exclude.txt) $FAA > ${OUTD}/${BASENAME}.faa
	#seqmagick convert --exclude-from-file ${OUTD}/${BASENAME}_exclude.txt --input-format fasta --output-format fasta $FAA ${OUTD}/${BASENAME}.faa
	COUNTS=$(grep -c ">" $ALI ${OUTD}/${BASENAME}.faa)
	IGNOREC=$(wc -l ${OUTD}/${BASENAME}_exclude.txt)
	echo should ignore $IGNOREC and original/selected dataset contains $COUNTS sequences
done
