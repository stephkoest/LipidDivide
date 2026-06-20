#!/bin/bash
for file in COG*.80.trim.1.noLong.focalclade.homologs.selected.pruned.combined.trim.40.support.tre
do
	NOG=$(echo $file | cut -d"." -f1)
	NAMES=results/${NOG}*.noLong.focalclade.homologs.trim.filter.names.txt
	echo python bin/plotTree.py $file ${file}.pdf $NAMES results/${NOG}*.noLong.focalclade.homologs.selected_interpro.tsv
	COLORF=${NOG}.color.txt
	echo $NAMES
	grep "Archaea" $NAMES | awk '{print $1"\t#beaed4"}' > $COLORF
	grep "Bacteria" $NAMES | awk '{print $1"\t#7fc97f"}' >> $COLORF
	grep "Eukaryota" $NAMES | awk '{print $1"\t#fdc086"}' >> $COLORF
	python bin/color_tree.py -i $file -o ${file}.nex -t -c $COLORF
	echo
done

