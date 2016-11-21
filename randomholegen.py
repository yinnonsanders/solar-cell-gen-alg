#!/usr/bin/env python

"""randomholegen.py: modifies rodpos.txt to contain a list of random locations of holes"""

import math
import random

__author__ = "Yinnon Sanders"

length = 8 # Lateral size of sample
area = length**2 # Area of sample
holeRadius = .200 # Radius of holes
holeArea = math.pi * holeRadius**2
totalHoleArea = 0
fillingFraction = .3 # Filling fraction of holes
holeList = [] # List of holes

class Hole(object):
	"""Hole with x and y coordinates"""

	def __init__(self, x, y):
		self.x = x
		self.y = y

def overlap(newHole, holeList): # check if newHole overlaps with any holes in holeList
	for hole in holeList:
		if (hole.x - newHole.x)**2 + (hole.y - newHole.y)**2 < 4*holeRadius**2:
			return True
	return False

while(totalHoleArea/area < fillingFraction):
	# create a new hole with random coordinates
	x = random.random() * length
	y = random.random() * length
	newHole = Hole(x,y)
	if not overlap(newHole, holeList):
		# new hole does not overlap with any existing holes
		holeList.append(newHole)
		totalHoleArea += holeArea

# filling fraction reached

rodpos = open("rodpos.txt", "w")

for hole in holeList:
	rodpos.write("%.3f" % hole.x)
	rodpos.write("\t")
	rodpos.write("%.3f" % hole.y)
	rodpos.write("\n")

rodpos.close()