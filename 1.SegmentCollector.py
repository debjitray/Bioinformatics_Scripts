#!/usr/bin/python

#"This code takes a Genome.fasta and corresponding blasted co-ordinates and removes them from the Genome, aim is to get a rDNA free genome"

from sys import argv
import re
import string
import sys



if argv[1] == "-h" or argv[1]=="--help" :
	print "\nUsage: python 1.SegmentCollector.py Input.fasta Blasted_CoOrd.txt out.fasta\n"
	print "\nThis code takes a Genome.fasta and corresponding blasted co-ordinates and removes them from the Genome\n"
	sys.exit()

f1 = open(argv[1],'r')
f2 = open(argv[2],'r')
fdw = open(argv[3],'w')

for line in f1:
	line=line.rstrip('\n')
	if re.search(r'>',line, re.M|re.I): 
	        m = re.search(r'>Genome_(\d+)',line, re.M|re.I)
   	     	fdw.write('>Cd'+m.group(1)+'\n')
		print '>Cd'+m.group(1)
	else:
		s= line


print "Size of genome "+str(len(s))

start=[]
end=[]

for line in f2:
	line=line.rstrip('\n') # Deletes the new line character
    	a=line.split("\t") # Splits with tab

	start.append(a[6])
	end.append(a[7]) 


z=[]
for x in range(0, len(start)):
        z.append(s[int(start[x])-1:int(end[x])])
	
new = s
d="nnnnn"

for x in range (0, len(z)):
#	print z[x]
        new=re.sub(z[x], d, new, count=0)

fdw.write(new)
print "Size of new genome "+str(len(new))
