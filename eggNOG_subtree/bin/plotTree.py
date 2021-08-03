#!/usr/bin/env python

import PyQt5
from ete3 import *
import sys
from ete3 import TreeStyle, NCBITaxa
import re

def open_tree(tree):
	t = Tree(tree, format=1)
	for node in t.traverse():
		if not node.is_leaf():
			if node.name != "":
				node.support = float(node.name.split("/")[0])
	t.ladderize(direction=1)
	return t

def readOutgroup(outgroupfile):
	out_list = []
	with open(outgroupfile, 'r') as f:
		for line in f:
			out_list.append(line.rstrip("\n"))
	return out_list

def root_midpoint(t):
	R = t.get_midpoint_outgroup()
	t.set_outgroup(R)
	t.ladderize(direction=1)
	return t

def read_tax_dict(idfile):
	tax_dict = {}
	with open(idfile, 'r') as f:
		for line in f:
			linelist = line.split("\t")
			tax_dict[linelist[0]] = linelist[1].rstrip("\n")
	f.close()
	return tax_dict
			
def root_out(t, outgroup):
	R = t.get_common_ancestor(outgroup)
	t.set_outgroup(R)
	t.ladderize(direction=1)
	return t

def rename_taxid(tree, tax_dict):
	for l in tree.traverse():
		if l.is_leaf():
			if l.name in tax_dict.keys():				
				l.sci_name = tax_dict[l.name]
			else:
				l.sci_name = l.name
	return tree

def my_layout(node):
	style = NodeStyle()
	style["size"] = 0
	style["hz_line_color"] = "black"
	if node.is_leaf():
		new_name = node.sci_name 
		if "Archaea" in node.sci_name:
			F = TextFace(new_name, ftype='helveticae', fsize=9, fgcolor="#beaed4", bold=True)
			#style["hz_line_color"] = "#beaed4"
		elif "Bacteria" in node.sci_name:
			F = TextFace(new_name, ftype='helveticae', fsize=9, fgcolor="#7fc97f", bold=True)
			#style["hz_line_color"] = "#7fc97f"
		elif "Eukaryota" in node.sci_name:
			F = TextFace(new_name, ftype='helveticae', fsize=9, fgcolor="#fdc086", bold=True)
			#style["hz_line_color"] = "#fdc086"
		else:
			F = TextFace(new_name, ftype='helveticae', fsize=9, fgcolor="black", bold=True)
		if "|" not in new_name:
			style["size"] = 1
		add_face_to_node(F, node, column=0, position="branch-right")	
	else:
		try:
			bs = float(node.name)
			if bs < 1:
				rounded_bs = str(int(round(bs,2) * 100))
			else:
				rounded_bs = str(int(bs))
		except ValueError:
			rounded_bs = node.name
		F = TextFace(rounded_bs, ftype='helveticae', fsize=9, fgcolor="black", bold=False)
		add_face_to_node(F, node, column=0, position="branch-bottom")
	node.img_style = style

def readInterpro(interprofile):
	domain_dict = {}
	with open(interprofile, 'r') as f:
		for line in f:
			linelist = line.split("\t")
			database = linelist[3]
			sequence = linelist[0]
			length = linelist[2]
			domain = linelist[4]
			domain_desc = linelist[5]
			start = linelist[6]
			stop = linelist[7]
			if database == "Pfam":
				if sequence not in domain_dict.keys():
					domain_dict[sequence] = []
					domain_dict[sequence].append((domain, start, stop, length))
				else:
					domain_dict[sequence].append((domain, start, stop, length))
	f.close()
	return domain_dict

def domain_map_tree(t, domain_dict):
	for sequence in domain_dict.keys():
		domains = sorted(domain_dict[sequence], key=lambda x: x[1])
		#print(domains)
		motifs = []
		for domain in domains:
			label = "arial|10|black|" + domain[0]
			motif = [int(domain[1]), int(domain[2]), "[]", None, 10, "black", "#ffffff", label]
			motifs.append(motif)
			mock_seq=''.join([char*int(domain[3]) for char in "A"])
		try:
			seqFace = SeqMotifFace(mock_seq, motifs=motifs, seq_format="-")
			(t & sequence).add_face(seqFace, 0, "aligned")
		except:
			pass
	return t

def output_tree_pdf(t, outfile):
	ts = TreeStyle()
	ts.layout_fn = my_layout
	ts.show_leaf_name = False
	ts.show_branch_support = False
	farthest, dist = t.get_farthest_node()
	print("The farthest node from root is", farthest.name, "with dist=", dist)
	ts.scale = 600
	#ts.mode = "c"
	t.render(outfile,tree_style=ts, units="mm", h=1000)

if __name__ == "__main__":
	t = open_tree(sys.argv[1])
	out=sys.argv[2]
	if len(sys.argv) > 3:
		idfile = sys.argv[3]
		tax_dict = read_tax_dict(idfile)
		t = rename_taxid(t,tax_dict)
	if len(sys.argv) >4:
		domain_dict = readInterpro(sys.argv[4])
		t = domain_map_tree(t, domain_dict)
	if len(sys.argv) > 5:
		Outgrouplist = readOutgroup(sys.argv[5])
		t = root_out(t, Outgrouplist)
	else:
		t = root_midpoint(t)
	output_tree_pdf(t, out)
