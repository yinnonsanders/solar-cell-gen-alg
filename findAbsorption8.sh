#!/bin/bash

mpirun -np 12 meep-openmpi no-struct=false no-holes=false light_mode.ctl > $1.out
IFS=$', '

> $1/tfluxes.txt
> $1/rfluxes.txt
> $1/absorptions.txt
> $1/avgAbsorption.txt

grep flux1 $1.out | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> $1/rfluxes.txt
	echo ${linearray[3]} >> $1/tfluxes.txt
done

python findAbsorption.py "$1"
