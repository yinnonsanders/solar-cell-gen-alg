#!/bin/bash

# Input: number 1-11

SCDIR=~/solar-cell-gen-alg # change depending on file structure
FOLDER=$SCDIR/C++/files/$1
OUT=$FOLDER/meep.out
TFLUXES=$FOLDER/tfluxes.txt
RFLUXES=$FOLDER/rfluxes.txt
ABSORPTIONS=$FOLDER/absorptions.txt
AVGABSORPTIONS=$FOLDER/avgAbsorptions.txt
IFS=$', '
NOSTRUCT=true
NOHOLES=true

meep no-struct=false no-holes=false rodpos=\"$FOLDER/rodpos.txt\" $SCDIR/absorption_random_2D_photonic.ctl > $OUT


> $TFLUXES
> $RFLUXES
> $ABSORPTIONS
> $AVGABSORPTIONS

grep flux1 $OUT | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> $TFLUXES
	echo ${linearray[3]} >> $RFLUXES
done

python $SCDIR/findAbsorption.py $FOLDER
