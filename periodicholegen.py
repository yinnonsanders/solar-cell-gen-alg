#!/usr/bin/env python

"""randomholegen.py: modifies rodpos.txt to contain a list of random locations of holes"""

__author__ = "Yinnon Sanders"

import sys

holeRadius = float(sys.argv[1])
separation = .6 # Separation between adjacent holes
length = 4 # Lateral size of sample
holeList = [] # List of holes

class Hole(object):
	"""Hole with x and y coordinates"""

	def __init__(self, x, y):
		self.x = x
		self.y = y

x = separation / 2
while x < length:

	y = separation / 2
	while y < length:

		holeList.append(Hole(x,y))
		y += separation

	x += separation

rodpos = open("rodpos.txt", "w")

for hole in holeList:
	rodpos.write("%.3f" % hole.x)
	rodpos.write("\t")
	rodpos.write("%.3f" % hole.y)
	rodpos.write("\t")
	rodpos.write("%.3f" % holeRadius)
	rodpos.write("\n")

rodpos.close()
