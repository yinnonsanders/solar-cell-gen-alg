#!/bin/bash

IFS=$', '
 
mpirun -np 2 meep-openmpi no-struct=true no-holes=true findAbsorption.ctl > empty.out

> freqs.txt
> emptytfluxes.txt
> emptyrfluxes.txt

grep flux1 empty.out | while read -r line; do
	linearray=($line)
	echo ${linearray[1]} >> freqs.txt
	echo ${linearray[2]} >> emptytfluxes.txt
	echo ${linearray[3]} >> emptyrfluxes.txt
done

mpirun -np 2 meep-openmpi no-struct=false no-holes=true findAbsorption.ctl > flat.out

> flat/tfluxes.txt
> flat/rfluxes.txt
> flat/absorptions.txt
> flat/avgAbsorption.txt

grep flux1 flat.out | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> flat/rfluxes.txt
	echo ${linearray[3]} >> flat/tfluxes.txt
done

python findAbsorption.py flat

mpirun -np 2 meep-openmpi no-struct=false no-holes=false findAbsorption.ctl > holes.out

> holes/tfluxes.txt
> holes/rfluxes.txt
> holes/absorptions.txt
> holes/avgAbsorption.txt

grep flux1 holes.out | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> holes/rfluxes.txt
	echo ${linearray[3]} >> holes/tfluxes.txt
done

python findAbsorption.py holes
