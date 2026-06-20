#!/bin/bash
CPU=8
parallel -j $CPU "
	OUTF=\$(echo {} | sed 's/\.tre/\.names/');
	echo {};
	python ../eggNOG_subtree/bin/parseEggnogTaxonomy.py {}  \$OUTF
	" ::: results/trees/*.80_merge.trim.tre
