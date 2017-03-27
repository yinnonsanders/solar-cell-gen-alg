#!/bin/bash

mpirun -np 2 meep-openmpi no-struct=false no-holes=false findAbsorption.ctl > cell.out

> tfluxes.txt
> rfluxes.txt

IFS=$', '

grep flux1 cell.out | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> rfluxes.txt
	echo ${linearray[3]} >> tfluxes.txt
done
