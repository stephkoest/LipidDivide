#!/bin/bash
mkidr -p chunks
split -l 200000 -a 3 -d data/GTDB_reps/v202/archaea_sprep_proteome.faa chunks/archaea_sprep_proteome_chunk
