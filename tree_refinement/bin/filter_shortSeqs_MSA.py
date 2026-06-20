#!/bin/python
from Bio import AlignIO
from sys import argv
def filterMSA(msaf, cutoff):
    align = AlignIO.read(msaf, 'fasta')
    for record in align:
        conservation = 1 - (float(record.seq.count('-')) / len(record.seq))
        if conservation >= cutoff:
            print(">" + record.id)
            print(record.seq)

if __name__ == '__main__':
    msaf = argv[1]
    cutoff = float(argv[2]) #[0-1]
    filterMSA(msaf, cutoff)
