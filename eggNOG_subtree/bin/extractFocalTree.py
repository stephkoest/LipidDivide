#!/usr/bin/env python

import sys
from ete3 import *

def open_tree(tree):
	t = Tree(tree)
	t.ladderize(direction=1)
	return t

def root_midpoint(t):
	t.unroot()
	R = t.get_midpoint_outgroup()
	t.set_outgroup(R)
	return t

def get_focal_clade(t, focalnode, minsupport = 0.7, mintaxa = 200, maxtaxa = 400):
	ntaxa = 0
	node = t.search_nodes(name=focalnode)[0]
	while ntaxa <= maxtaxa:
		prevnode = node
		node = node.up
		leaves = node.get_leaves()
		prevleaves = prevnode.get_leaves()
		ntaxa = len(leaves)
		prevntaxa = len(prevleaves)
		nodesupport = node.support
		prevnodesupport = prevnode.support
		focalclade = prevnode.get_leaf_names()
		print(str(ntaxa) + " " + str(nodesupport) + " " + str(prevntaxa) + " " + str(prevnodesupport))
		print("Focalclade n = " + str(len(focalclade)))
		outgroup = [leaf for leaf in node.get_leaf_names() if leaf not in  focalclade]
		print("Outgroup n = " + str(len(outgroup)))
		if ntaxa >= mintaxa and nodesupport >= minsupport:
			break
	if ntaxa > maxtaxa:
		print("Selection not successfull with current settings...")
	else:
		return focalclade, outgroup

def write_clade_files(leaflist, outfile):
	with open(outfile, "w") as writer:
		for leaf in leaflist:
	 		 writer.write(leaf + "\n")
	writer.close()
	

if __name__ == "__main__":
	treefile = sys.argv[1]
	focalnode = sys.argv[2]
	focalcladetxt = sys.argv[3]
	focaloutgrouptxt = sys.argv[4]
	minsupport = float(sys.argv[5])
	mintaxa = int(sys.argv[6])
	maxtaxa = int(sys.argv[7])
	t = open_tree(treefile)
	t = root_midpoint(t)
	focalclade, outgroup = get_focal_clade(t, focalnode, minsupport, mintaxa, maxtaxa)
	write_clade_files(focalclade, focalcladetxt)
	write_clade_files(outgroup, focaloutgrouptxt)
