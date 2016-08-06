#!/bin/bash

mkdir FINSIHED

# Running GAPfiller
nohup perl /data1/users/debray/SOFTWARES/GapFiller_v1-10_linux-x86_64/GapFiller.pl -l libraries_MP.txt -s ../MP.contigs.scaffolds -m 20 -o 10 -r 0.7 -n 10 -d 50 -t 10 -T 10 -i 10 -b GAPFILLED &

# Running the trimmer (Removes 10 bases from end and beginning of the contigs)
perl /data1/users/debray/scripts/trimmer.pl GAPFILLED/GAPFILLED.gapfilled.final.fa 10

# Run the contig extender
nohup perl /data1/users/debray/SOFTWARES/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl -l libraries_MP.txt -s contigfile.trimmed -x 1 -m 50 -o 30 -r 0.8 -T 10 -p 1 -S 0 -b EXTENDED &
#nohup perl /data1/users/debray/SOFTWARES/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl -l libraries_MP_bwa.txt -s contigfile.trimmed -x 1 -m 50 -o 30 -r 0.8 -T 10 -p 1 -S 0 -b EXTENDED &
#
mv EXTENDED/intermediate_results/EXTENDED.extendedcontigs.fasta .
mv EXTENDED/intermediate_results/EXTENDED.extension_evidence.txt .

# 
grep ">" EXTENDED.extendedcontigs.fasta > EXTENDED_r0.8.txt

perl /data1/users/debray/scripts/ExtensionSummary.pl contigfile.trimmed EXTENDED.extendedcontigs_r_0.8.fasta EXTENDED.extendedcontigs_r_0.8