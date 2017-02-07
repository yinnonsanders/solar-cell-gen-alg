#!/bin/bash

resolutions=( 50)

for i in ${resolutions[@]}; do
	meep no-struct=true no-holes=true time=150 resolution$i.ctl > /dev/null
	meep no-struct=false no-holes=false time=150 resolution$i.ctl > resolutionTrialHoles$i.out

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

	python findAbsorption.py resolutionTrialHoles$i
done
