#!/bin/bash

for i in `seq 1 10`;
	do
                j=$((${i}+7))
		echo $j
		cp Nextera-Cd${j}_S${i}_R1.fq.gz TEMP/S${j}_R1.fq.gz
        	cp Nextera-Cd${j}_S${i}_R2.fq.gz TEMP/S${j}_R2.fq.gz
	done 
