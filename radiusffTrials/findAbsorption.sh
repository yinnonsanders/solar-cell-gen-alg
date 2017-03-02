#!/bin/bash

mpirun -np 2 meep-openmpi no-struct=true no-holes=true findAbsorption.ctl > empty.out

IFS=$', '

> freqs.txt
> emptytfluxes.txt
> emptyrfluxes.txt

grep flux1 empty.out | while read -r line; do
	linearray=($line)
	echo ${linearray[1]} >> freqs.txt
	echo ${linearray[2]} >> emptytfluxes.txt
	echo ${linearray[3]} >> emptyrfluxes.txt
done

fillingfractions=(.1 .2 .3 .4 .5 .6)

radii=(.1 .125 .15 .175 .2 .225 .25 .275 .3)

for fillingfraction in ${fillingfractions[@]}; do
	for radius in ${radii[@]}; do
		trial=rad${radius}ff${fillingfraction}

		python randomholegen.py $radius $fillingfraction

		mpirun -np 2 meep-openmpi no-struct=false no-holes=false rodpos=\"${trial}/rodpos.txt\" findAbsorption.ctl > ${trial}.out

		mkdir -p $trial

		> ${trial}/tfluxes.txt
		> ${trial}/rfluxes.txt
		> ${trial}/absorptions.txt
		> ${trial}/avgAbsorption.txt

		grep flux1 ${trial}.out | while read -r line; do
			linearray=($line)
			echo ${linearray[2]} >> ${trial}/rfluxes.txt
			echo ${linearray[3]} >> ${trial}/tfluxes.txt
		done

		python findAbsorption.py "${trial}"
	done
done
