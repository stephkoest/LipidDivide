#!/bin/python
from Bio import SeqIO
import sys
from re import sub

def unalignMSA(msaf):
    align = SeqIO.parse(msaf, 'fasta')
    for record in align:
        print(">" + record.id)
        print(sub('[-]', '', str(record.seq)))

if __name__ == '__main__':
    unalignMSA(sys.stdin)
