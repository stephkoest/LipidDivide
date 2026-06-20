#!/bin/bash
#OUTGROUP coloring
cat templates/color_styles_template.txt > tree_annotation/Outgroup_color_Itol.txt
cat ../eggNOG_subtree/results/*.80.trim.1.noLong.focalclade.homologs.outgroup.txt | sort -u | awk '{print $1"\tlabel\t#00ff00\tnormal\t1"}' >> tree_annotation/Outgroup_color_Itol.txt
#RENAME leaves
cat templates/labels_template.txt > tree_annotation/Rename_Itol.txt 
cat ../eggNOG_subtree/results/*.80.trim.1.noLong.focalclade.homologs.trim.filter.names.txt | sort -u | awk '{print $1","$2}' >> tree_annotation/Rename_Itol.txt 
