# EggNOG and NR make trees - workflow

## Introduction

This workflow is designed to take EggNOG non-supervised orthologous
groups (NOGs) and a sequence name of a NOG member to make high quality
trees of focal clades in NOGs, including sequences from
the NCBI non-redundant (nr) database.
Originaly this workflow was established for the investigation of
a novel fatty acid synthesis pathway in Archaea.

![image](https://user-images.githubusercontent.com/6470185/128010919-61c60bbf-5353-4169-957e-39252b130254.png)


## Installation

### The conda way - aka. the way

```
git clone https://github.com/stephkoest/LipidDivide.git
cd LipidDivide/eggNOG_subtree
``` 
## Download databases

```
mkdir workflow/databases
```

Place the following files where you'd like on your machine and add a soft link to the database folder

### taxonomy - only "fullnamelineage.dmp" needed, other files can be removed

```
wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz
tar -zxvf new_taxdump.tar.gz
```

### all nr proteins AND diamond nr blast database

```
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
diamond makedb --in nr.gz --db nr.dmnd
```

### NCBI nr database

```
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/v5/nr.*.tar.gz
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/v5/nr.*.tar.gz.md5
for i in *.md5 ; do md5sum -c $i ; done
for i in *.tar.gz ; do tar -zxvf $i ; done
```
