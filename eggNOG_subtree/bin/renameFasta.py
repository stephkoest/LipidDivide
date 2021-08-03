#!/usr/bin/python

def parseIDdict(IDFILE):
	IDdict = {}
	with open(IDFILE,'r') as IN:
		for line in IN:
			linelist = line.rstrip('\n').split('\t')
			IDdict[linelist[0]] = linelist[1]
	return IDdict

def renameFasta(IDdict,FASTA):
	WANTED = False
	with open(FASTA,'r') as IN:
		for line in IN:
			linestr = line.rstrip('\n')
			if not linestr.startswith('>'):
				print(linestr)
			else:
				if linestr.lstrip('>') in IDdict.keys():
					print(">" + IDdict[linestr.lstrip('>')])
				else:
					print(linestr)

if __name__ == '__main__':
        import sys
        IDFILE = sys.argv[1]
        FASTA = sys.argv[2]
        IDdict = parseIDdict(IDFILE)
        renameFasta(IDdict, FASTA)
