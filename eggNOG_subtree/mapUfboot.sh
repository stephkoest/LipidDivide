#!/bin/bash
conda activate newickutils
for file in results/COG*.80.trim.1.noLong.focalclade.homologs.selected.pruned.combined.trim.40.ufboot
do
	ls $file
	BASE=$(basename $file .ufboot)
	nw_support -p results/${BASE}.treefile $file > ${BASE}.support.tre
done
