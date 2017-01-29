#!/bin/bash

timeTrials=( 5 15 50 150 500 1500)

for i in ${timeTrials[@]}; do
	mpirun -np 12 meep-openmpi no-struct=false no-holes=false time=$i absorption_random_2D_photonic.ctl > timeTrial$i.out &
done

wait

for i in ${timeTrials[@]}; do
	IFS=$', '

	> timeTrial$i/tfluxes.txt
	> timeTrial$i/rfluxes.txt
	> timeTrial$i/absorptions.txt
	> timeTrial$i/avgAbsorption.txt

	grep flux1 $1.out | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> timeTrial$i/rfluxes.txt
		echo ${linearray[3]} >> timeTrial$i/tfluxes.txt
	done

	python findAbsorption.py timeTrial$i
done
