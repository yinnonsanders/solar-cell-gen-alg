#!/bin/bash

IFS=$', '

> tfluxes.txt
> rfluxes.txt
> absorptions.txt
> avgAbsorption.txt

grep flux1 $1 | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> tfluxes.txt
	echo ${linearray[3]} >> rfluxes.txt
done

python findAbsorption.py "."
