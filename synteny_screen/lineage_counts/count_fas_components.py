#!/usr/bin/env python3
"""Per-lineage occurrence of the S. acidocaldarius fatty acid synthesis components in GTDB r202 archaea.

Each component is defined by the archaea-level eggNOG v5 OG (arCOG@2157) that eggNOG-mapper assigns to the
S. acidocaldarius protein. The KT is counted only as a KT/DUF35 pair: an arCOG01278 KT within two genes of an
arCOG01283 DUF35 on the same contig (the Saci_1121/Saci_1120 module; the isoprenoid KT/DUF35 module uses a
different DUF35 OG, arCOG01285). KCR, MaoC-HCD and ECR are large families, so their presence is a loose bound.

Usage:
  count_fas_components.py <emapper.annotations> <GTDB metadata.tsv> <outdir>
Inputs are the eggNOG-mapper annotations of the 2,339 GTDB r202 archaeal species representatives
(runEmapper.sh) and the GTDB r202 metadata table (accession, checkm_completeness, checkm_contamination,
gtdb_taxonomy).
"""
import collections
import csv
import gzip
import os
import sys

OGS = {'arCOG01278': 'KT', 'arCOG01283': 'DUF35', 'arCOG01259': 'KCR',
       'arCOG00774': 'MaoC-HCD', 'arCOG01455': 'ECR'}
QUALITY = {'hq': (90, 5), 'mq': (50, 10)}  # min completeness, max contamination (CheckM, %)
COLS = ['KT/DUF35 pair', 'KCR', 'MaoC-HCD', 'ECR', 'complete set']


def read_hits(annotations):
    hits = collections.defaultdict(lambda: collections.defaultdict(list))
    with open(annotations) as fh:
        for line in fh:
            if line.startswith('#'):
                continue
            f = line.rstrip('\n').split('\t')
            genome, prot = f[0].split('|', 1)
            contig, idx = prot.rsplit('_', 1)
            hits[genome]  # register every annotated genome
            for og in f[4].split(','):
                name = og.split('@')[0]
                if name in OGS and og.split('@')[1].startswith('2157'):
                    hits[genome][OGS[name]].append((contig, int(idx)))
    return hits


def read_meta(path, genomes):
    meta = {}
    with open(path) as fh:
        for row in csv.DictReader(fh, delimiter='\t'):
            if row['accession'] in genomes:
                tax = dict(r.split('__', 1) for r in row['gtdb_taxonomy'].split(';'))
                meta[row['accession']] = (float(row['checkm_completeness']),
                                          float(row['checkm_contamination']), tax)
    return meta


def components(h):
    pair = any(c1 == c2 and abs(i1 - i2) <= 2 for c1, i1 in h['KT'] for c2, i2 in h['DUF35'])
    present = {'KT/DUF35 pair': pair, 'KCR': bool(h['KCR']),
               'MaoC-HCD': bool(h['MaoC-HCD']), 'ECR': bool(h['ECR'])}
    present['complete set'] = all(present.values())
    return present


def lineage(tax):
    if tax['p'] == 'Thermoproteota' and tax['c'] == 'Thermoproteia':
        return ('Thermoproteota', 'Thermoproteia', tax['o'])
    return (tax['p'], tax['c'], '')


def main(annotations, metadata, outdir):
    os.makedirs(outdir, exist_ok=True)
    hits = read_hits(annotations)
    meta = read_meta(metadata, set(hits))
    per_genome = {g: components(hits[g]) for g in meta}

    with gzip.open(os.path.join(outdir, 'fas_components_per_genome.tsv.gz'), 'wt') as out:
        out.write('genome\tcheckm_completeness\tcheckm_contamination\tgtdb_taxonomy\t' + '\t'.join(COLS) + '\n')
        for g in sorted(meta):
            comp, cont, tax = meta[g]
            taxstr = ';'.join(f'{k}__{v}' for k, v in tax.items())
            out.write(f'{g}\t{comp}\t{cont}\t{taxstr}\t' + '\t'.join(str(int(per_genome[g][c])) for c in COLS) + '\n')

    for q, (min_comp, max_cont) in QUALITY.items():
        rows = collections.defaultdict(collections.Counter)
        for g, (comp, cont, tax) in meta.items():
            if comp < min_comp or cont > max_cont:
                continue
            r = rows[lineage(tax)]
            r['n'] += 1
            r.update(c for c in COLS if per_genome[g][c])
        with open(os.path.join(outdir, f'fas_components_by_lineage_{q}.tsv'), 'w') as out:
            out.write('phylum\tclass\torder\tn_genomes\t' + '\t'.join(f'% {c}' for c in COLS) + '\n')
            for k in sorted(rows, key=lambda k: -rows[k]['n']):
                r = rows[k]
                out.write('\t'.join(k) + f"\t{r['n']}\t" + '\t'.join(f"{100 * r[c] / r['n']:.0f}" for c in COLS) + '\n')


if __name__ == '__main__':
    main(*sys.argv[1:4])
