#!/usr/bin/python
"""
Author: Stephan Koestlbacher
Date: 24.06.2016
Usage: python <scriptname> IDlist-file Fasta-file
Purpose: Filter Fasta-file by IDlist file (no '>')!
"""
def parseIDList(IDFILE):
	IDlist = []
	with open(IDFILE,'r') as IN:
		for line in IN:
			IDlist.append(line.rstrip('\n'))
	return IDlist

def filterFasta(IDLIST,FASTA):
	WANTED = False
	with open(FASTA,'r') as IN:
		for line in IN:
			linestr = line.rstrip('\n')
			if not linestr.startswith('>'):
				if WANTED:
					print(linestr)
			else:
				if linestr.lstrip('>') in IDLIST:
					print(linestr)
					WANTED = True
				else:
					WANTED = False




if __name__ == '__main__':
	import sys
	IDFILE = sys.argv[1]
	FASTA = sys.argv[2]
	IDlist = parseIDList(IDFILE)
	filterFasta(IDlist, FASTA)
