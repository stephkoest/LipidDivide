#!/bin/bash
CPU=10
for FAA in $(echo data/COG2030.round2.faa)
do
	REVFAA=data/$(basename $FAA .faa).rev.faa
	seqmagick convert --reverse --input-format fasta --output-format fasta $FAA $REVFAA
	####
	#fwd
	####
	#t_coffee -in $FAA Mmafftlinsi_msa Mmafftginsi_msa Mclustalo_msa Mmuscle_msa -outfile $FWDALI -output=fasta_aln -thread=$CPU
	FWDBASE=data/$(basename $FAA .faa)
	FWDLINSI=${FWDBASE}.mlinsi.aln
	FWDGINSI=${FWDBASE}.mginsi.aln
	FWDCLUSTALO=${FWDBASE}.clustalo.aln
	#MAFFT linsi
	mafft --localpair --anysymbol --maxiterate 1000 --thread $CPU $FAA > $FWDLINSI
	#MAFFT ginsi
	mafft --genafpair --anysymbol --maxiterate 1000 --thread $CPU $FAA > $FWDGINSI
	#CLUSTALO
	clustalo -i $FAA --threads=$CPU --iter=3 -o $FWDCLUSTALO -v
	####
	#rev
	####
	REVBASE=data/$(basename $REVFAA .faa)
	REVLINSI=${REVBASE}.mlinsi.aln
	REVGINSI=${REVBASE}.mginsi.aln
	REVCLUSTALO=${REVBASE}.clustalo.aln
	#t_coffee -in $REVFAA Mmafftlinsi_msa Mmafftginsi_msa Mclustalo_msa Mmuscle_msa -outfile $REVALI -output=fasta_aln -thread=$CPU
	#MAFFT linsi
	mafft --localpair --anysymbol --maxiterate 1000 --thread $CPU $REVFAA > $REVLINSI
	#MAFFT ginsi
	mafft --genafpair --anysymbol --maxiterate 1000 --thread $CPU $REVFAA > $REVGINSI
	#CLUSTALO
	clustalo -i $REVFAA --threads=$CPU --iter=3 -o $REVCLUSTALO -v

	FWDREVLINSI=${REVBASE}.mlinsi.fwd.aln
	FWDREVGINSI=${REVBASE}.mginsi.fwd.aln
	FWDREVCLUSTALO=${REVBASE}.clustalo.fwd.aln
	for file in $(echo $REVLINSI $REVGINSI $REVCLUSTALO)
	do
		out=$(dirname $file)/$(basename $file .aln).fwd.aln
		seqmagick convert --reverse --input-format fasta --output-format fasta $file $out 
	done
	#combine alignments
	MERGEALI=data/$(basename $FAA .faa).combined.aln
	t_coffee -in=$FWDLINSI -in=$FWDGINSI -in=$FWDCLUSTALO -in=$FWDREVLINSI -in=$FWDREVGINSI -in=$FWDREVCLUSTALO -evaluate_mode=t_coffee_slow -thread=$CPU -outfile=$MERGEALI -output=fasta_aln
	TRIM=data/$(basename $MERGEALI .aln).trim.aln
	#trim alignment
	trimal -in $MERGEALI -out $TRIM -gappyout
	TRIMGAP=data/$(basename $TRIM .aln).40.aln
	python bin/filter_shortSeqs_MSA.py $TRIM 0.4 > $TRIMGAP
done
