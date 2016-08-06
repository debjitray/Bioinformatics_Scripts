#!/usr/bin/python

# This code can be used to cut DNA at specific locations, by providing the DNA co-ordinates
# No need to enter the start(0) and end(length) of the Genome
# For cuts put the cordinates twice

# USAGE:: python test2.py ../Cd27.fasta Cd27_INV.fa 854036 1278226 4199781

from sys import *
import os
import re


#script, input, output, @t = argv

argv.insert(3,0)

inputfile=open(argv[1],'r')
outfile = open(argv[2],'w')

count=0

for line in inputfile.readlines():
        line=line.replace('\n','')
        line=line.upper()
        if (re.search(">",line)):
                tmp=line.split(" ")
                print (tmp[0])
                #outfile.write(line+"\n")
	else:
		DNA_length=len(line)		
	  	L = list(line)
		s=""
		argv.append(DNA_length)
		print len(argv)
		for x in range(0+3, len(argv)-1):
			
			k = L[int(argv[x]):int(argv[x+1])]	
			if len(k)!=0:
				count=count+1
				outfile.write( ">NODE_"+ str(count)+"_length_"+str(len(k))+"_cov_192.971_ID_1\n")
				outfile.write(s.join(k)+"\n")

#_length_1885082_cov_192.971_ID_1
# python test.py ../Cd27.fasta Cd27_INV.fa 854036 1278226 4199781
