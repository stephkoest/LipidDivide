#!/usr/bin/env python

#import PyQt5
from ete3 import *
import sys
from ete3 import TreeStyle
import re

def open_tree(tree):
	t = Tree(tree, format=1)
	for node in t.traverse():
		if not node.is_leaf():
			if node.name != "":
				node.support = float(node.name.split("/")[0])
	t.ladderize(direction=1)
	return t

def readFocalFile(infile):
	focal_list = []
	with open(infile, 'r') as f:
		for line in f:
			taxon = line.rstrip("\n")
			focal_list.append(taxon)
	f.close()
	return focal_list

def root_midpoint(t):
	R = t.get_midpoint_outgroup()
	t.set_outgroup(R)
	return t

def read_tax_dict(idfile):
	tax_dict = {}
	with open(idfile, 'r') as f:
		for line in f:
			linelist = line.split("\t")
			tax_dict[linelist[0]] = linelist[1].rstrip("\n")
	f.close()
	return tax_dict
			

def rename_taxid(tree, tax_dict):
	for l in tree.traverse():
		if l.is_leaf():
			if l.name in tax_dict.keys():				
				l.sci_name = tax_dict[l.name]
			else:
				l.sci_name = l.name
	return tree

def general_tree_settings(t):
	t.ladderize(direction=1)
	style = NodeStyle()
	style["size"] = 0
	style["vt_line_width"] = 1
	style["hz_line_width"] = 1
	for node in t.traverse():
		node.img_style = style
	return t

def my_layout(node):
	style = NodeStyle()
	style["size"] = 0
	style["hz_line_color"] = "black"
	if node.is_leaf():
		new_name = node.sci_name + "@" + node.name
		if "Archaea" in node.sci_name:
			style["hz_line_color"] = "#beaed4"
		elif "Bacteria" in node.sci_name:
			style["hz_line_color"] = "#7fc97f"
		elif "Eukaryota" in node.sci_name:
			style["hz_line_color"] = "#fdc086"
		if "|" not in new_name:
			style["size"] = 1
		node.img_style = style

def output_tree_pdf(t, outfile, focal = None):
	ts = TreeStyle()
	ts.allow_face_overlap = True
	t = general_tree_settings(t)
	ts.layout_fn = my_layout
	ts.show_leaf_name = False
	ts.show_branch_support = False
	ts.guiding_lines_color = "white"
	ts.extra_branch_line_color ="white"
	ts.optimal_scale_level = "full"
	if focal is not None:
		focallca = t.get_common_ancestor(focal)
		nst1 = NodeStyle()
		nst1["bgcolor"] = "LightSteelBlue"
		focallca.set_style(nst1)
	farthest, dist = t.get_farthest_node()
	print("The farthest node from root is", farthest.name, "with dist=", dist)
	ts.mode = "c"
	ts.scale = 500
	t.render(outfile,tree_style=ts, units="mm", h=400)

if __name__ == "__main__":
	t = open_tree(sys.argv[1])
	out=sys.argv[2]
	t = root_midpoint(t)
	if len(sys.argv) > 3:
		idfile = sys.argv[3]
		tax_dict = read_tax_dict(idfile)
		t = rename_taxid(t,tax_dict)
	if len(sys.argv) > 4:
		cladefile = sys.argv[4]
		focal = readFocalFile(cladefile)
		output_tree_pdf(t, out, focal = focal)
	else:
		output_tree_pdf(t, out)
	
