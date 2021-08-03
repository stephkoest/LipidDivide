#!/bin/bash
conda init bash
conda activate snakemake
snakemake --cores 30 --use-conda -p
