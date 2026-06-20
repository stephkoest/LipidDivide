#!/bin/bash
TMPD=/tmp
grep -h ">" results/trees/*.80_merge.trim.aln | grep -v "|" | sed 's/>//' | awk '{print $1"\t"$1"\t"0"\t"10000}' | sort -u > $TMPD/toanno.seed_orthologs
emapper.py -m no_search --annotate_hits_table $TMPD/toanno.seed_orthologs --no_file_comments --cpu 8 --dbmem --tax_scope 1 --data_dir ../dataset/eggnog/v5/mmseq2 -o results/NOG_member_emapper
