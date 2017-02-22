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

radii=(.1 .125 .15 .2 .225 .25 .275 .3)

for radius in ${radii[@]}; do
	python randomholegen.py $radius

	mpirun -np 2 meep-openmpi no-struct=false no-holes=false rodpos=\"rodpos$radius.txt\" findAbsorption.ctl > $radius.out

	> $radius/tfluxes.txt
	> $radius/rfluxes.txt
	> $radius/absorptions.txt
	> $radius/avgAbsorption.txt

	grep flux1 $radius.out | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> $radius/rfluxes.txt
		echo ${linearray[3]} >> $radius/tfluxes.txt
	done

	python findAbsorption.py "$radius"
done
