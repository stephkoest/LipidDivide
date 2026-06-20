awk '$2 != ""' data/allFAS_NOGs_duplicates.tsv | awk '{print NF,$0}' | sort -nr | cut -d' ' -f 2- > data/allFAS_NOGs_duplicates_sorted.tsv
awk '$2 != ""' data/allFAS_NOGs_ext_duplicates.tsv | awk '{print NF,$0}' | sort -nr | cut -d' ' -f 2- > data/allFAS_NOGs_ext_duplicates_sorted.tsv
