#!/usr/bin/env python

"""findAbsorptions.py: finds absorption of structure and saves to absorptions.txt"""

__author__ = "Yinnon Sanders"

import sys
import csv

path=sys.argv[1]
freqs = open("freqs.txt", "r")
emptytfluxes = open("emptytfluxes.txt", "r")
emptyrfluxes = open("emptyrfluxes.txt", "r")
tfluxes = open(path + "/tfluxes.txt", "r")
rfluxes = open(path + "/rfluxes.txt", "r")
absorptions = open(path + "/absorptions.txt", "w")
avgAbsorption = open(path + "/avgAbsorption.txt", "w")
AM15 = open("AM15.txt", "rbU")
AM15reader = csv.reader(AM15, delimiter = '\t', quoting=csv.QUOTE_NONNUMERIC)
absorptionSum = 0.0
absorptionCount = 0.0

for i in xrange(1,300):
	freq = freqs.readline()
	emptytflux = emptytfluxes.readline()
	emptyrflux = emptyrfluxes.readline()
	tflux = tfluxes.readline()
	rflux = rfluxes.readline()
	t = float(tflux) / float(emptytflux)
	r = float(rflux) / float(emptyrflux)
	a = 1.0 + t - r
	f = .15 * float(freq)
	absorptions.write("%.10f" % f)
	absorptions.write("\t")
	absorptions.write("%.10f" % a)
	absorptions.write("\n")
	wavelength = int(100 / float(f))
	for row in AM15reader:
		if int(row[0]) == wavelength:
			absorptionSum += a * float(row[1])
	absorptionCount += 1

aa = absorptionSum / absorptionCount
avgAbsorption.write("%.10f" % aa)
avgAbsorption.write("\n")
