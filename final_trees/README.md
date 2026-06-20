# Final gene trees

The published maximum-likelihood phylogenies for the seven target genes (Fig. 2, Fig. 5, figs. S33–S37).
One sub-directory per gene, named `<COG>_<protein>`:

| Directory | Gene | Pathway | Final round |
|-----------|------|---------|-------------|
| `COG0183_KT/` | β-ketothiolase, Saci_1121 | FA synthesis | round 2 |
| `COG1545_DUF35/` | DUF35, Saci_1120 | FA synthesis | round 2 |
| `COG1028_KR/` | 3-ketoacyl-CoA reductase, Saci_1104 | FA synthesis | round 3 |
| `COG1064_ER/` | enoyl-CoA reductase, Saci_1115 | FA synthesis | round 3 |
| `COG2030_HCD/` | MaoC (R)-hydroxyacyl-CoA dehydratase, Saci_1085 | FA synthesis | round 3 |
| `COG1250_ECH_HCDH/` | HCDH-ECH, Saci_1109 | β-oxidation | round 2 |
| `COG1960_ACDH/` | acyl-CoA dehydrogenase, Saci_1123 | β-oxidation | round 2 |

The "round" is how many manual refinement passes were applied (see [`../tree_refinement/`](../tree_refinement/)).
COG1028/COG1064/COG2030 received one extra pass (round 3), as noted in the Methods.

## Files in each gene directory

| File | Description |
|------|-------------|
| `*_PMSF_combined.suptree` | **Final tree shown in the paper** — PMSF ML topology with **non-parametric bootstrap** support (IQ-TREE 2.1.2, 100 replicates). |
| `*_PMSF_TBE.raxml.support` | Same topology with **transfer-bootstrap expectation (TBE)** support (RAxML-NG). Fig. 5 reports both TBE and NP bootstrap. |
| `*.final_alignment.aln` | Trimmed MSA used for the PMSF tree (FASTA). |
| `*_outgroup.tsv` | Tip IDs used to root the tree. |
| `*_names.tsv.gz` | Map from tip ID (`taxid.seqid`) to full taxonomy (`Domain_Phylum_Class_Family_Genus_Species@id`). gzip. |

Tip labels are `taxid.seqid`; `NCBI|` marks sequences recruited from the NCBI nr database (vs. EggNOG members).

## iTOL annotation (`itol/`)

Templates and the driver script used to style the trees in iTOL for the figures:
`annotate_tree_Itol.sh`, `color_styles_template.txt`, `labels_template.txt`. The per-tip colour and
relabelling tables are derivable from each gene's `_names.tsv.gz` and `_outgroup.tsv`.

> See the top-level [`README.md`](../README.md) for the COG0183 seed caveat (Saci_1121 vs Saci_1114).
