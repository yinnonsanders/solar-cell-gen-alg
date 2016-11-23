#!/bin/bash

IFS=$', '

> freqs.txt
> emptytfluxes.txt
> emptyrfluxes.txt
> tfluxes.txt
> rfluxes.txt

grep flux1 emptyOut.txt | while read -r line; do
	linearray=($line)
	echo ${linearray[1]} >> freqs.txt
	echo ${linearray[2]} >> emptytfluxes.txt
	echo ${linearray[3]} >> emptyrfluxes.txt
done

grep flux1 $1 | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> tfluxes.txt
	echo ${linearray[3]} >> rfluxes.txt
done

python findAbsorption.py
