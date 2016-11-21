#!/usr/bin/env python

"""findAbsorptions.py: finds absorption of structure and saves to absorptions.txt"""

__author__ = "Yinnon Sanders"

freqs = open("freqs.txt", "r")
emptytfluxes = open("emptytfluxes.txt", "r")
emptyrfluxes = open("emptyrfluxes.txt", "r")
tfluxes = open("tfluxes.txt", "r")
rfluxes = open("rfluxes.txt", "r")
absorptions = open("absorptions.txt", "w")

for i in xrange(1,300):
	freq = freqs.readline()
	emptytflux = emptytfluxes.readline()
	emptyrflux = emptyrfluxes.readline()
	tflux = tfluxes.readline()
	rflux = rfluxes.readline()
	t = float(tflux) / float(emptytflux)
	r = float(rflux) / float(emptyrflux)
	a = 1 + t - r
	f = float(freq)
	absorptions.write("%.10f" % f)
	absorptions.write("\t")
	absorptions.write("%.10f" % a)
	absorptions.write("\n")
