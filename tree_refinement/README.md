# Manual tree refinement (rounds 2–3)

After the automated [`../eggNOG_subtree/`](../eggNOG_subtree/) workflow produces an initial per-gene tree,
each gene tree was refined manually for one or two further rounds to obtain the published phylogenies in
[`../final_trees/`](../final_trees/). These scripts document that procedure. They use machine-specific
paths (`data/…`, `results/…`, `../eggNOG_subtree/…`) and are provided as a faithful record rather than a
turnkey pipeline.

## Per round

| Script | Step |
|--------|------|
| `run_ShrinkRogue.sh` | On the previous round's PMSF tree + bootstrap trees: **TreeShrink** (per-gene, q = 0.01) for long-branch outliers and **RogueNaRok** for rogue taxa; drop flagged tips (always keeping *S. acidocaldarius*, `330779.Saci*`) → reduced sequence set for the next round. |
| `runAli.sh` | **Exhaustive MSA**: MAFFT `--localpair` (L-INS-i) + MAFFT `--genafpair` (G-INS-i) + Clustal Omega `--iter 3`, in both forward and reverse orientation, merged with **T-Coffee** (`-evaluate_mode=t_coffee_slow`); trimmed with trimAl `-gappyout` then `bin/filter_shortSeqs_MSA.py` (≥40 % occupancy). |
| `runIqtree.sh` | **IQ-TREE** model selection (`-m MFP -mset LG,LG+C10…C60,LG4M,LG4X -mrate ,G4,R4,R5,R6 -mfreq ,F`) with ultrafast bootstrap + SH-aLRT, then the PMSF step. |
| `runPMSF_Iqtree.sh` | **PMSF** approximation (`-ft <guide tree> -b 100`): the best-fit C-series model is used as a guide for a posterior-mean-site-frequency tree with 100 **non-parametric** bootstraps. |
| `runTBE.sh` | Support mapping: **RAxML-NG** `--support --bs-metric tbe` (transfer-bootstrap expectation), then IQ-TREE `--support` to write the combined NP-bootstrap support tree. |

`bin/` holds the two helper scripts used above (`filter_shortSeqs_MSA.py`, `fastaGrep.py`).

## Tools

IQ-TREE **2.1.2** (COVID-edition), RAxML-NG, TreeShrink 1.3.7, RogueNaRok, MAFFT 7.453,
Clustal Omega 1.2.3, T-Coffee 13.45.0, trimAl 1.4.1. (RogueNaRok was run from the bundled binary in the
original working directory; install from its upstream repository.)

> Best-fit models (BIC): `LG+C60+F+R6` for the gene trees, except COG1545/DUF35, for which `LG+C40+F+R5`
> was selected. The PMSF `.iqtree` reports show these as `LG+SSF+F+R6` / `LG+SSF+F+R5` (SSF = the
> site-specific frequency profile derived from the C-mixture model).
