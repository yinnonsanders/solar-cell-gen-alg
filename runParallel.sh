#!/bin/bash

SCDIR=~/solar-cell-gen-alg # change depending on file structure
FOLDER=$SCDIR/C++/files/$1
OUT=$FOLDER/meep.out
TFLUXES=$FOLDER/tfluxes.txt
RFLUXES=$FOLDER/rfluxes.txt
ABSORPTIONS=$FOLDER/absorptions.txt
AVGABSORPTION=$FOLDER/avgAbsorption.txt
IFS=$', '
NOSTRUCT=true
NOHOLES=true

mpirun -np 12 meep-openmpi no-struct=false no-holes=false rodpos=\"$FOLDER/rodpos.txt\" $SCDIR/absorption_random_2D_photonic.ctl > $OUT


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
