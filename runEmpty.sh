#!/bin/bash

NOSTRUCT=true
NOHOLES=true
IFS=$', '

mpirun -np 12 meep-openmpi absorption_random_2D_photonic.ctl > empty.out

> freqs.txt
> emptytfluxes.txt
> emptyrfluxes.txt

grep flux1 empty.out | while read -r line; do
	linearray=($line)
	echo ${linearray[1]} >> freqs.txt
	echo ${linearray[2]} >> emptytfluxes.txt
	echo ${linearray[3]} >> emptyrfluxes.txt
done
