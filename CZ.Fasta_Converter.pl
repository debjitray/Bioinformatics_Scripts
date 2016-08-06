#! /usr/bin/perl -w
# Converts the format of the fasta from SPADES to the usual one, needed for conversion 

# USAGE: perl CZ.Fasta_Converter.pl scaffolds_Selected.fasta 
use strict;

my $contigfile = $ARGV[0];

open OUT, join("",">",$ARGV[0],"_1.fasta");
open IN2, $contigfile;
my $i=0;

while (<IN2>) {
    chomp;
    $i++;
    if ($_ =~ /^>/) {
	if ($i == 1) {
		print OUT $_."\n";
	}
	else {	
		print OUT "\n".$_."\n";
	}
    }
    else {
	print OUT $_; 
    }
}
