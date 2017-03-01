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

for fillingfraction in ${fillingfractions[@]}; do
	python randomholegen.py $fillingfraction

	mpirun -np 2 meep-openmpi no-struct=false no-holes=false rodpos=\"$radius/rodpos.txt\" findAbsorption.ctl > $fillingfraction.out

	> $fillingfraction/tfluxes.txt
	> $fillingfraction/rfluxes.txt
	> $fillingfraction/absorptions.txt
	> $fillingfraction/avgAbsorption.txt

	grep flux1 $fillingfraction.out | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> $fillingfraction/rfluxes.txt
		echo ${linearray[3]} >> $fillingfraction/tfluxes.txt
	done

	python findAbsorption.py "$fillingfraction"
done
