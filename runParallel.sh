#!/bin/bash

SCDIR=~/solar-cell-gen-alg # change depending on file structure

for (( i = 0; i < 7; i++ )); do

	FOLDER=$SCDIR/parallelTrials/$i
	OUT=$FOLDER/meep.out

	mpirun -np 4 meep-openmpi no-struct=false no-holes=false time=250 rodpos=\"$FOLDER/rodpos.txt\" $SCDIR/absorption_random_2D_photonic.ctl > $OUT

done

for (( i = 0; i < 7; i++ )); do

	FOLDER=$SCDIR/parallelTrials/$i
	OUT=$FOLDER/meep.out
	TFLUXES=$FOLDER/tfluxes.txt
	RFLUXES=$FOLDER/rfluxes.txt
	ABSORPTIONS=$FOLDER/absorptions.txt
	AVGABSORPTION=$FOLDER/avgAbsorption.txt
	IFS=$', '

	> $TFLUXES
	> $RFLUXES
	> $ABSORPTIONS
	> $AVGABSORPTION

	grep flux1 $OUT | while read -r line; do
		linearray=($line)
		echo ${linearray[2]} >> $RFLUXES
		echo ${linearray[3]} >> $TFLUXES
	done

	python $SCDIR/findAbsorption.py $FOLDER

done
