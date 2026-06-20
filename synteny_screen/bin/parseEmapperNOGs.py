#!/bin/bash
import sys
def readFile(infile):
	tax_scope= "@1|root"
	EggDict = {}
	IN = open(infile, "r")
	while IN:
		line  = IN.readline()
		if line == "":
        		break
		linelist = line.split("\t")
		noglist = linelist[4].split(",")
		locus = linelist[0]
		for nog in noglist:
			if "#query_name" in locus:
				pass
			elif tax_scope in nog:
				print(locus + "\t" + nog.split("@")[0])
	IN.close()
	return EggDict

if __name__ == '__main__':
	infile = sys.argv[1]	
	readFile(infile)
