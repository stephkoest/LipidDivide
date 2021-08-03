#!/usr/bin/env python

#import PyQt5
from ete3 import *
import sys
#from ete3 import TreeStyle, NCBITaxa
import re


def open_tree(tree):
	t = Tree(tree, format=1)
	for node in t.traverse():
		if not node.is_leaf():
			if node.name != "":
				node.support = float(node.name.split("/")[0])
	t.ladderize(direction=1)
	return t

def ncbi_rename_taxid(tree):
	ncbi = NCBITaxa()
	tax_dict = {}
	for l in tree.traverse():
		if l.is_leaf():
			try:
				lin = ncbi.get_lineage(int(l.name.split('.')[0]))
				tax = []
				for t in lin:
					name = ncbi.get_taxid_translator([t])[t]
					name = re.sub(r"[\ |/|\.|'|&|(|)]|:", '_', name)
					if ncbi.get_rank([t])[t] in ['species', 'family', 'class', 'phylum', 'kingdom', 'superkingdom']:
						tax.append(name)
				sciname = "_".join(tax)
				tax_dict[l.name] =  sciname + "@" + l.name
			except ValueError:
				print("No taxonomy for: "+l.name)
			except TypeError:
				print("No taxonomy for: "+l.name)
	return tax_dict

def write_tax_tsv(tax_dict, outfile):
	with open(outfile, "w") as writer:
		for key in tax_dict.keys():
			writer.write(key + "\t" + tax_dict[key] + "\n")
	writer.close()

if __name__ == "__main__":
	t = open_tree(sys.argv[1])
	out=sys.argv[2]
	tax_dict = ncbi_rename_taxid(t)
	write_tax_tsv(tax_dict,out)
