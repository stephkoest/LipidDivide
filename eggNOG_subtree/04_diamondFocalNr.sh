#!/bin/bash
NCPU=38
DIAMONDDB=/local/one/data/databases/nr/v5/nr.dmnd
BLASTDB=/server_databases/nr/v5/nr
DBFASTA=/local/one/data/databases/nr/v5/nr.gz
INFILE=$1
IDENTITY=80
NTARGETS=2000
OUTDIR=$2

echo running blast
BLASTOUT=${OUTDIR}/$(basename $INFILE .faa).blastp
#c1 for high memory useage

#diamond blastp \
#        --threads $NCPU \
#        --db $DIAMONDDB \
#        --out $BLASTOUT \
#        --outfmt 6 qseqid qlen sseqid slen stitle length qcovhsp pident evalue bitscore \
#        --query $INFILE \
#        --max-target-seqs $NTARGETS \
#	--evalue 0.00001 \
#	--index-chunks 1 \
#        --more-sensitive > ${BLASTOUT}.log

echo extracting sequences
TARGETSEQF=${OUTDIR}/$(basename $INFILE .faa)_targets.txt
#awk -F "\t" '{print $3}' $BLASTOUT | sort -u > $TARGETSEQF

TARGETSEQFAA=${OUTDIR}/$(basename $INFILE .faa)_targets.faa
echo "writing sequences to $TARGETSEQFAA"
#seqtk subseq <(pigz -dc -p 10 $DBFASTA) $TARGETSEQF > $TARGETSEQFAA

echo dereplicating
TARGETDEREP=${OUTDIR}/$(basename $TARGETSEQFAA .faa).${IDENTITY}.faa
#cd-hit -i $TARGETSEQFAA -o ${TARGETDEREP} -c 0.${IDENTITY} -M 8000
TARGETSTAX=${OUTDIR}/$(basename $TARGETDEREP .faa)_taxonomy.txt
TARGETSNOTAX=${OUTDIR}/$(basename $TARGETDEREP .faa)_notaxonomy.txt
echo parsing taxonomy
blastdbcmd -db $BLASTDB -dbtype prot -target_only -outfmt '%a %T.NCBI|%a' -entry_batch <(grep ">" $TARGETDEREP | sed 's/>//' | sed 's/ .*//') 2> $TARGETSNOTAX > $TARGETSTAX
RENAMEF=${OUTDIR}/$(basename $TARGETDEREP .faa)_rename.txt
sed 's/ /\t/' $TARGETSTAX > $RENAMEF
rev $TARGETSNOTAX | sed 's/ .*//' | rev | awk '{print $1"\tNCBI|"$1}' >>  $RENAMEF
TARGETRENAME=${OUTDIR}/$(basename $TARGETDEREP .faa)_rename.faa
python bin/renameFasta.py $RENAMEF <(sed '/^>/ s/ .*//' $TARGETDEREP) > $TARGETRENAME
