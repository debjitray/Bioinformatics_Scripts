#!/usr/bin/sh

# Usage: sh MummerPlot.sh <REF> <QUERY> <OUTPUT>


ref="$1"

/data1/users/debray/CdBk/X.BLASTN/MUMmer3.23/nucmer --maxmatch -c 500 -p P1.MummerPlot $ref $2 
        
/data1/users/debray/CdBk/X.BLASTN/MUMmer3.23/mummerplot -postscript -p $3 P1.MummerPlot.delta

rm -r P1.*
rm -r *plot
rm -r *.gp
