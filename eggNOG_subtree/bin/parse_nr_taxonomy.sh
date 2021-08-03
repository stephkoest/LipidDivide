#!/bin/bash
blastdbcmd -db $1 -dbtype prot -target_only -outfmt '%a	%T.NCBI|%a' -entry_batch $2 2> $3 > $4
