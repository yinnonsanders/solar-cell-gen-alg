#!/bin/bash

timeTrials=( 50 150 1500)

for i in ${timeTrials[@]}; do
	meep no-struct=false no-holes=false time=$i absorption_random_2D_photonic.ctl > timeTrialHoles$i.out

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

	python findAbsorption.py timeTrialHoles$i
done
