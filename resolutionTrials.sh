#!/bin/bash

resolutions=( 5 10 20 30 40)

for i in ${resolutions[@]}; do
	mpirun -np 12 meep-openmpi no-struct=false no-holes=true time=1500 res=$i absorption_random_2D_photonic.ctl > timeTrial$i.out

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
