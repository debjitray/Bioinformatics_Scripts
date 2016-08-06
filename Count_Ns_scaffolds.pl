#! /usr/bin/perl
# USAGE: perl Count_Ns_scaffolds.pl fastafile
use strict;
my ($X) = @ARGV;
open INX, $X;
my $d = 0;
my $Other = 0;

while (<INX>) {
  (my $line = $_) =~ s/\r*\n//;
   if ($line =~ /\>/) {
#		print $line."\n";
    }
	$d += $line =~ tr/N/n/;
	$Other += $line =~ tr/[ATGC]/[atgc]/;
}

print "Count of the ATGC,Ns::".$Other;
print ",".$d."\n";
