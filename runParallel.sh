#!/bin/bash

# Input: number 1-11

FOLDER=C++/files/$1
OUT=$FOLDER/meep.out
TFLUXES=$FOLDER/tfluxes.txt
RFLUXES=$FOLDER/rfluxes.txt
ABSORPTIONS=$FOLDER/absorptions.txt
AVGABSORPTIONS=$FOLDER/avgAbsorptions.txt
IFS=$', '
RODPOS=$FOLDER/rodpos.txt
NOSTRUCT=true
NOHOLES=true

meep absorption_random_2D_photonic.ctl no-struct=$NOSTRUCT no-holes=$NOHOLES rodpos=$RODPOS > $OUT

> $TFLUXES
> $RFLUXES
> $ABSORPTIONS
> $AVGABSORPTIONS

grep flux1 $OUT | while read -r line; do
	linearray=($line)
	echo ${linearray[2]} >> $TFLUXES
	echo ${linearray[3]} >> $RFLUXES
done

python findAbsorption.py $PATH
