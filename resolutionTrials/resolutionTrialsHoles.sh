#!/bin/bash

resolutions=( 5 10 20 30 40)

for i in ${resolutions[@]}; do
	mpirun -np 12 meep-openmpi no-struct=false no-holes=false time=1500 resolution$i.ctl > resolutionTrialHoles$i.out

	IFS=$', '

	> resolutionTrialHoles$i/tfluxes.txt
	> resolutionTrialHoles$i/rfluxes.txt
	> resolutionTrialHoles$i/absorptions.txt
	> resolutionTrialHoles$i/avgAbsorption.txt

	grep flux1 resolutionTrialHoles$i.out | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> resolutionTrialHoles$i/rfluxes.txt
		echo ${linearray[3]} >> resolutionTrialHoles$i/tfluxes.txt
	done

	python findAbsorption8.py resolutionTrialHoles$i
done
