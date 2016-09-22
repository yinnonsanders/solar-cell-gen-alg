#!/bin/bash

g++ `pkg-config --cflags meep` $1.cpp -o $1 `pkg-config --libs meep`
./$1
