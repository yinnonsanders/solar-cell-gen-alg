#!/usr/bin/env python

"""randomholesizegen.py: modifies rodpos.txt to contain a list of random locations of holes with random radii"""

import math
import random

__author__ = "Yinnon Sanders"

length = 4 # Lateral size of sample
area = length**2 # Area of sample
holeRadiusMu = .200 # Center of distribution of radii of holes
holeRadiusSigma = .050 # Standard deviation of distribution of radii of holes
totalHoleArea = 0
fillingFraction = .3 # Filling fraction of holes
holeList = [] # List of holes

class Hole(object):
	"""Hole with x and y coordinates"""

	def __init__(self, x, y, r):
		self.x = x
		self.y = y
		self.r = r
		self.area = math.pi * r**2

def overlap(newHole, holeList): # check if newHole overlaps with any holes in holeList
	for hole in holeList:
		if (hole.x - newHole.x)**2 + (hole.y - newHole.y)**2 < (hole.r + newHole.r)**2:
			return True
	return False

while(totalHoleArea/area < fillingFraction):
	# create a new hole with random coordinates
	x = random.random() * length
	y = random.random() * length
	r = random.gauss(holeRadiusMu, holeRadiusSigma)
	newHole = Hole(x,y,r)
	if not overlap(newHole, holeList):
		# new hole does not overlap with any existing holes
		holeList.append(newHole)
		totalHoleArea += newHole.area

# filling fraction reached

rodpos = open("rodpos.txt", "w")

for hole in holeList:
	rodpos.write("%.3f" % hole.x)
	rodpos.write("\t")
	rodpos.write("%.3f" % hole.y)
	rodpos.write("\t")
	rodpos.write("%.3f" % hole.r)
	rodpos.write("\n")

rodpos.close()
