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

def set_far_node(t, ingrouplist):
	far_node = None
	far_node_dist = 0
	t.unroot()
	for node in t.traverse():
		dist = t.get_distance(ingrouplist[0], node, topology_only=False)
		if node not in ingrouplist and node != t and dist > far_node_dist:
			far_node = node
			far_node_dist = dist
	if far_node != None:
		t.set_outgroup(far_node)
	else:
		R = t.get_midpoint_outgroup()
		t.set_outgroup(R)
	return t

def read_ingroup_file(ingroupfile):
	ingrouplist = []
	with open(ingroupfile, "r") as reader:
		for line in reader:
			taxon = line.rstrip("\n")
			ingrouplist.append(taxon)
	reader.close()
	return ingrouplist

def get_ingroup(t, ingrouplist):
	node = t.get_common_ancestor(ingrouplist)
	focalclade = node.get_leaf_names()
	if len(focalclade) == len(t):
		t = set_far_node(t, ingrouplist)
		node = t.get_common_ancestor(ingrouplist)
		focalclade = node.get_leaf_names()
	return focalclade

def write_clade_files(leaflist, outfile):
	with open(outfile, "w") as writer:
		for leaf in leaflist:
	 		 writer.write(leaf + "\n")
	writer.close()

if __name__ == "__main__":
	treefile = sys.argv[1]
	ingroupfile = sys.argv[2]
	focalcladetxt = sys.argv[3]
	t = open_tree(treefile)
	t = root_midpoint(t)
	ingrouplist = read_ingroup_file(ingroupfile)
	focalclade = get_ingroup(t, ingrouplist)
	write_clade_files(focalclade, focalcladetxt)
