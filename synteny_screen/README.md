# Syntenic-block / gene-neighbourhood screen

Screen for conserved gene neighbourhoods (colinear syntenic blocks, CSBs) containing the fatty-acid
metabolism genes across archaeal genomes — supporting the conservation of KT/DUF35 pairs and neighbouring
FA-synthesis genes (e.g. Fig. 5C).

## Pipeline

1. **Dataset** — predicted proteomes of representative GTDB archaeal genomes (v202).
   `createDataset.sh`, `createSaciScreenDB.sh`, `gatherTargetNOGs.sh`, `makeChunks.sh`.
2. **Orthology annotation** — eggNOG-mapper v2 (EggNOG db 5.0.1) assigns NOGs to every protein.
   `runEmapper.sh`, `runEmapperDBonly.sh`, `bin/parseEmapperNOGs.py`.
3. **Syntenic blocks** — build per-genome COG-string input and run **CSBfinder-S** with `-q 2 -s 3`.
   `prepSyntenyInput.sh`, `bin/makeCOGCSBinput.sh`, `runCSBfinderS.sh`.
4. **Parse / focus on FA genes** — `parseCSB.sh`, `extractComplexIsland.sh`, `calcComplexSubtree.sh`,
   `bin/grepCOG.sh`, `bin/grepArCOG.sh`, `bin/grepWhile.sh`, `mapKEGG.sh`, `runTaxonomy.sh`.
5. **Plots** — `plotCSBs.Rmd`, `lipidEggnog.Rmd` (R 4.2.1 + ggplot2 3.4.3).

## Included results

- `archaea_CSBfinder_q2_ins3_cs_instances_FAS_single.tsv.gz` — curated FA-synthesis syntenic-block
  instances from the published CSBfinder-S run (`-q 2 -s 3`), one row per block instance. gzip.
- `GToTree/` — GToTree species trees giving clade context for the gene trees (`Archaea.tre`,
  `Ectothiorhodospirales.tre`, `Ectothiorhodospiraceae.tre`) plus `GTDB-version-info.txt`.

## Not included (regenerable)

The eggNOG-mapper annotations of the GTDB archaeal proteomes, `seed_orthologs`, GTDB metadata tables, and
the full (all-COG) CSBfinder instance tables are bulky intermediates produced by the scripts above and are
omitted; regenerate them from GTDB v202 + EggNOG db 5.0.1.
