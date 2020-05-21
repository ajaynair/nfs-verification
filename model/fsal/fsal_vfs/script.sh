#!/bin/bash 

spin -a file.pml 
cc -o pan pan.c 
rm file.pml.trail
./pan -E -A 