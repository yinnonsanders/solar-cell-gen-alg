#!/bin/bash

resolutions=( 5 10 20 30 40)

for i in ${resolutions[@]}; do
	mpirun -np 12 meep-openmpi no-struct=false no-holes=true time=1500 res=$i light_mode.ctl > resolutionTrial$i.out

	IFS=$', '

	> resolutionTrial$i/tfluxes.txt
	> resolutionTrial$i/rfluxes.txt
	> resolutionTrial$i/absorptions.txt
	> resolutionTrial$i/avgAbsorption.txt

	grep flux1 resolutionTrial$i.out | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> resolutionTrial$i/rfluxes.txt
		echo ${linearray[3]} >> resolutionTrial$i/tfluxes.txt
	done

	python findAbsorption.py resolutionTrial$i
done
