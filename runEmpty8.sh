#!/bin/bash

IFS=$', '
 
mpirun -np 12 meep-openmpi no-struct=true no-holes=true light_mode.ctl > empty8.out

> freqs8.txt
> emptytfluxes8.txt
> emptyrfluxes8.txt

grep flux1 empty8.out | while read -r line; do
	linearray=($line)
	echo ${linearray[1]} >> freqs8.txt
	echo ${linearray[2]} >> emptytfluxes8.txt
	echo ${linearray[3]} >> emptyrfluxes8.txt
done
