#!/usr/bin/env python -w
# USAGE: python Count_Ns_scaffolds.py fastafile

from sys import argv
import re
import string

FDR = open (argv[1],'r')
#FDW = open (argv[2],'w')


N=0
other=0

for line in FDR:
	line=line.strip('\n')
	if re.search(r'>',line, re.M|re.I):
		continue
	else:
		N+=re.subn(r'N','N',line)[1]
		other+=re.subn(r'A','A',line)[1]
		other+=re.subn(r'T','T',line)[1]
		other+=re.subn(r'G','G',line)[1]
		other+=re.subn(r'C','C',line)[1]

print ('Count of the ATGC,Ns::'+str(other)+","+str(N))
