# Taxonomic distribution of the gene trees

`Taxonomic_distribution.Rmd` plots, for each target gene, the
taxonomic make-up of its EggNOG tree, its EggNOG+nr tree, and the focal-clade tree — colouring tips by
**domain** (Archaea / Bacteria / Eukaryota) and by **origin** (EggNOG member vs. NCBI nr hit), and
highlighting the *S. acidocaldarius* target. These panels accompany the Fig. 5 / supplementary
distribution figures.

- **Tools:** R 4.2.1 with `data.table`, `stringr`, `ggplot2`, `ggtree`, `ggpubr`, `ggmosaic`, `dplyr`.
- **Inputs:** the per-gene FastTree trees and nr taxonomy name maps produced by the
  [`../eggNOG_subtree/`](../eggNOG_subtree/) workflow (e.g. `*.fasttree.noLong.tre`,
  `*.trim.filter.names.txt`). These are large, regenerable intermediates and are not committed; point the
  paths at the top of the notebook to your `eggNOG_subtree/results/` (and the tip-name maps in
  [`../final_trees/`](../final_trees/)).
- **Outputs:** per-COG distribution plots and word-clouds (the high-resolution PDFs are large and omitted).
