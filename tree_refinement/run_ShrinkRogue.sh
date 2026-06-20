#!bin/bash
KEEPTAX=330779.Saci
#$(ls data/Round2 | cut -d"." -f1 | sort -u)
for COG in $(echo COG1028 COG2030 COG1064)
do
	BESTTREE=data/Round2/${COG}.round2_PMSF.treefile
	BOOTTREES=data/Round2/${COG}.round2_PMSF.boottrees
	FAA=../eggNOG_subtree/results/${COG}.80.trim.1.noLong.focalclade.homologs.selected.pruned.faa
	ALI=../Trees_round2/data/${COG}.round1.combined.trim.40.aln
	OUTD=data
	mkdir -p $OUTD

	BASENAME=$(basename $BESTTREE | cut -d"." -f1 ).round2
	## run RogueNaRok
	../eggNOG_subtree/software/RogueNaRok/RogueNaRok -i $BOOTTREES -n $BASENAME  -t $BESTTREE -w $OUTD

	## run Treeshrink
	run_treeshrink.py -t $BESTTREE --mode per-gene -O treeshrink_${BASENAME} --outdir $OUTD -f -c -q 0.01 --force

	cat <(awk 'NR>1 {print $3}' ${OUTD}/RogueNaRok_droppedRogues.${BASENAME} | grep -wv NA) ${OUTD}/treeshrink_${BASENAME}.txt | sed 's/\t/\n/g' | sort -u  | grep -v "^$" | grep -v $KEEPTAX > ${OUTD}/${BASENAME}_exclude.txt

	echo excluding sequences in ${OUTD}/${BASENAME}_exclude.txt
	python bin/fastaGrep.py <(grep ">" $ALI | sed 's/>//' | grep -vwFf <(cat ${OUTD}/${BASENAME}_exclude.txt ${OUTD}/${COG}.exclude.txt | sort -u)) $FAA > ${OUTD}/${BASENAME}.faa
	#seqmagick convert --exclude-from-file ${OUTD}/${BASENAME}_exclude.txt --input-format fasta --output-format fasta $FAA ${OUTD}/${BASENAME}.faa
	COUNTS=$(grep -c ">" $ALI ${OUTD}/${BASENAME}.faa)
	IGNOREC=$(wc -l ${OUTD}/${BASENAME}_exclude.txt)
	echo should ignore $IGNOREC and original/selected dataset contains $COUNTS sequences
done
