#!/bin/bash
 
mpirun -np 2 meep-openmpi no-struct=true no-holes=true findAbsorption.ctl > empty.out

> freqs.txt
> emptytfluxes.txt
> emptyrfluxes.txt

IFS=$', '

grep flux1 empty.out | while read -r line; do
	linearray=($line)
	echo ${linearray[1]} >> freqs.txt
	echo ${linearray[2]} >> emptytfluxes.txt
	echo ${linearray[3]} >> emptyrfluxes.txt
done
