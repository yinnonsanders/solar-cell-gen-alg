#!/bin/bash

timeTrials=( 5 15 50 150 500)

for i in ${timeTrials[@]}; do
	mpirun -np 12 meep-openmpi no-struct=false no-holes=false time=$i light_mode.ctl > timeTrial$i.out

	IFS=$', '

	> timeTrial$i/tfluxes.txt
	> timeTrial$i/rfluxes.txt
	> timeTrial$i/absorptions.txt
	> timeTrial$i/avgAbsorption.txt

	grep flux1 timeTrial$i.out | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> timeTrial$i/rfluxes.txt
		echo ${linearray[3]} >> timeTrial$i/tfluxes.txt
	done

	python findAbsorption8.py timeTrial$i
done
