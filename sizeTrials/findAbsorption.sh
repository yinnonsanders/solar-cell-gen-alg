#!/bin/bash

radii=(.1 .125 .15 .175 .2 .225 .25 .275 .3)

for radius in ${radii[@]}; do
	python randomholegen.py $radius

	mpirun -np 2 meep-openmpi no-struct=false no-holes=false rodpos=\"$radius/rodpos.txt\" findAbsorption.ctl > $radius.out

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
