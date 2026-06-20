# LipidDivide — computational resource for the archaeal fatty-acid-synthase study

Code, configuration, and key results for the comparative-genomics / phylogenetics part of:

> Schmerling, Zhou, Görs, Köstlbacher, Kessenbrock, Podlesainski, Sybers, Wang, Lindås,
> Snoep, Peeters, Kaiser, Ettema, Meckelmann, Bräsen & Siebers.
> **"De novo synthesis of fatty acids in Archaea via an archaeal fatty acid synthase complex."**

The study shows that *Sulfolobus acidocaldarius* (and *Haloferax volcanii*) synthesise fatty acids
de novo via a novel, ACP-independent pathway built around a ketothiolase (KT) / DUF35 complex, and that
homologues of these genes are widespread across Archaea — bearing on the "lipid divide" and eukaryogenesis.
This repository covers the **bioinformatic analyses** behind those conclusions; the wet-lab/biochemistry
data live with the manuscript and on FAIRDOMHub (see *Data availability* below).

> ℹ️ This is the computational resource only. The manuscript itself is **not** included here.

## Repository layout

| Directory | Analysis | Manuscript item |
|-----------|----------|-----------------|
| [`eggNOG_subtree/`](eggNOG_subtree/) | **ENT** Snakemake workflow: build per-gene trees from EggNOG NOGs enriched with NCBI nr homologues (align → trim → FastTree → TreeShrink → DIAMOND/nr → Treemmer → M-Coffee → IQ-TREE). | Fig. 5, figs. S33–S37 |
| [`map_eggNOG_v5/`](map_eggNOG_v5/) | Helper to download the EggNOG v5 per-taxon-level member lists & alignments. | (input data) |
| [`tree_refinement/`](tree_refinement/) | Manual round-2/3 refinement of the gene trees: exhaustive MSA, TreeShrink + RogueNaRok pruning, IQ-TREE PMSF, non-parametric & transfer-bootstrap (TBE) support. | Fig. 5, figs. S33–S37 |
| [`final_trees/`](final_trees/) | The **final published gene trees** (7 genes), with PMSF ML trees, combined NP-bootstrap + TBE support, outgroup definitions, tip-name maps, alignments, and iTOL annotation. | Fig. 2, Fig. 5, figs. S33–S37 |
| [`taxonomic_distribution/`](taxonomic_distribution/) | R notebook plotting the taxonomic distribution of each gene tree (domain/origin-coloured ggtree). | Fig. 5, distribution panels |
| [`synteny_screen/`](synteny_screen/) | Gene-neighbourhood / syntenic-block screen across GTDB archaea (eggNOG-mapper → CSBfinder-S `-q 2 -s 3`) + GToTree species-tree context. | KT/DUF35 conservation (Fig. 5C) |

## The seven gene trees

Each S. acidocaldarius (Saci, NCBI taxid **330779**) target protein was mapped to its LUCA-level EggNOG
non-supervised orthologous group (NOG / COG) and analysed with the ENT workflow.

| COG | Protein | Saci gene | Pathway | Figure |
|-----|---------|-----------|---------|--------|
| COG0183 | β-ketothiolase (KT) | Saci_1121 † | FA synthesis | Fig. 5, S |
| COG1545 | DUF35 | Saci_1120 | FA synthesis | Fig. 5B |
| COG1028 | 3-ketoacyl-CoA reductase (KCR) | Saci_1104 | FA synthesis | Fig. 5, S |
| COG1064 | enoyl-CoA reductase (ECR) | Saci_1115 | FA synthesis | Fig. 5, S |
| COG2030 | MaoC-like (R)-hydroxyacyl-CoA dehydratase | Saci_1085 | FA synthesis | Fig. 5, S |
| COG1250 | 3-hydroxyacyl-CoA dehydrogenase / enoyl-CoA hydratase (HCDH-ECH) | Saci_1109 | β-oxidation | Fig. 2 |
| COG1960 | acyl-CoA dehydrogenase (ACAD) | Saci_1123 | β-oxidation | Fig. 2 |

† **Note:** COG0183 (the thiolase family) contains *both* the FA-synthesis KT (Saci_1121) and the
β-oxidation KT (Saci_1114). The shipped `NOGtarget.tsv` and `final_trees/COG0183_KT/` use **Saci_1121**
as the focal seed (the FA-synthesis KT central to the study, and the seed of the most recent run); an
earlier working input used Saci_1114. Adjust the seed in `eggNOG_subtree/NOGtarget.tsv` to reproduce the
Saci_1114-focused variant.

## Software versions

Versions as used for the study (from the manuscript, reporting summary, and verified against run logs in
the working directory):

| Tool | Version | Step |
|------|---------|------|
| Snakemake | 6.4.1 | workflow management |
| EggNOG database | 5.0.1 | orthologous groups (NOGs) |
| eggNOG-mapper | v2 (`emapper-97dad3b`) | GTDB proteome annotation (synteny) |
| CD-HIT | 4.8.1 | dereplication (80 % identity) |
| Clustal Omega | 1.2.3 | multiple sequence alignment |
| MAFFT | 7.453 | MSA (`--localpair`, `--genafpair`) |
| T-Coffee | 13.45.0 | MSA combination (M-Coffee / `t_coffee_slow`) |
| trimAl | 1.4.1 | alignment trimming (`-gappyout`) |
| DIAMOND | 2.x | nr profile search (`blastp --more-sensitive`; NCBI nr v5, 2021-04-09) |
| BLAST+ | (`blastdbcmd`) | nr taxonomy lookup |
| FastTree | 2.1.11 | preliminary trees |
| **IQ-TREE** | **1.6.9** (initial ML, Snakemake) / **2.1.2 COVID-edition** (PMSF + NP-bootstrap, refinement) | ML phylogenies |
| ModelFinder | (in IQ-TREE) | substitution-model selection (best fit `LG+C60+F+R…`) |
| TreeShrink | 1.3.7 | long-branch outlier removal (q = 0.01) |
| RogueNaRok | (bundled) | rogue-taxon removal |
| RAxML-NG | (TBE) | transfer-bootstrap expectation support |
| Treemmer | 0.3 (bundled, adapted) | diversity reduction (RTL 0.8) |
| seqmagick | 0.8.0 | FASTA utilities |
| InterProScan | (Pfam) | domain annotation |
| ETE3 | 3.1.2 | tree plotting |
| CSBfinder-S | (`-q 2 -s 3`) | colinear syntenic blocks |
| GToTree | — | species-tree context |
| ColabFold / CombFold | 2.3.4 | multimer modelling |
| R / ggplot2 | 4.2.1 / 3.4.3 | plotting |
| FigTree | 1.4.4 | tree visualisation |

> ⚠️ **Version note:** the manuscript/reporting summary list **IQ-TREE 1.6.9**, but the final PMSF +
> non-parametric-bootstrap trees in `final_trees/` were produced with **IQ-TREE 2.1.2 (COVID-edition)**
> (`.iqtree` reports give model `LG+SSF+F+R5/R6`). Both are documented here for accuracy.

## Reproducing the analyses (overview)

1. **Databases** — download NCBI nr (v5) + taxonomy and the EggNOG v5 data
   (`eggNOG_subtree/README.md`, `map_eggNOG_v5/downloadEggnog_v5.sh`), and update the absolute paths in
   `eggNOG_subtree/config/config.yaml` to your machine.
2. **Per-gene trees** — list the target COG→Saci pairs in `eggNOG_subtree/NOGtarget.tsv` and run the
   Snakemake workflow (`eggNOG_subtree/slitherSnake.sh`). Conda envs are in `eggNOG_subtree/envs/`.
3. **Refinement** — apply the `tree_refinement/` scripts (exhaustive MSA → TreeShrink + RogueNaRok →
   IQ-TREE PMSF → NP-bootstrap → RAxML-NG TBE) for one or more rounds; the published final trees are in
   `final_trees/`.
4. **Taxonomic distribution** — `taxonomic_distribution/Taxonomic_distribution.Rmd`.
5. **Synteny screen** — `synteny_screen/` (eggNOG-mapper over GTDB archaea → CSBfinder-S).

## Data availability

- **Included here:** all analysis code/config, the final gene trees + alignments + support, the curated
  syntenic-block result, and GToTree species trees.
- **Not included (size / public sources):** NCBI nr & EggNOG/GTDB databases, conda environments, software
  binaries, and bulk intermediates (eggNOG-mapper annotations, per-aligner alignments, bootstrap-tree
  collections). These are regenerable with the scripts above or available from the public databases.
- Kinetic data and metabolic-model simulations are on **FAIRDOMHub**:
  <https://fairdomhub.org/investigations/749>.
- Sequence tip labels are `taxid.seqid`; full taxonomic names are in the per-gene `*_names.tsv.gz` maps.

Questions about the bioinformatics: Stephan Köstlbacher. Corresponding author: Christopher Bräsen.
