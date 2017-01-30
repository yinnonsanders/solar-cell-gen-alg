#!/bin/bash

timeTrials=( 1500)

for i in ${timeTrials[@]}; do
	mpirun -np 12 meep-openmpi no-struct=false no-holes=false time=$i light_mode.ctl > timeTrialHoles$i.out

	IFS=$', '

	> timeTrialHoles$i/tfluxes.txt
	> timeTrialHoles$i/rfluxes.txt
	> timeTrialHoles$i/absorptions.txt
	> timeTrialHoles$i/avgAbsorption.txt

	grep flux1 timeTrialHoles$i.out | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> timeTrialHoles$i/rfluxes.txt
		echo ${linearray[3]} >> timeTrialHoles$i/tfluxes.txt
	done

	python findAbsorption8.py timeTrialHoles$i
done
