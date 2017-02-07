#!/bin/bash

timeTrials=( 5 150 1500)

for i in ${timeTrials[@]}; do
	meep no-struct=false no-holes=true time=$i absorption_random_2D_photonic.ctl > timeTrial$i.out

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

	python findAbsorption.py timeTrial$i
done
