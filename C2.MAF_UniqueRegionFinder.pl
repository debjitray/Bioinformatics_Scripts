#! /usr/bin/perl -w
use strict ;
# This code selects the non reference regions that are unique to each strains for "mult=1"
# USAGE: perl MAF_UniqueRegionFinder.pl input.maf output.fasta

my $k = $ARGV[0];
system ("grep -A 1 'mult=1' $k > temp.txt");

my $inputfile     = "temp.txt";
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

my $outputfile1     = $ARGV[1];
open(FDW1,">$outputfile1") or die "Can't open $outputfile1: $!\n";

my $count=0;
my $final=0;
foreach(<FDR>) {
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^s/) {
    my (@array) = split (/\s+/,$line);
    if ($array[1] !~ /Reference/ and $array[3] >= 100 and $array[6] !~ /N{100}/g) {
      print FDW1 ">".$array[1]."_".$array[2]."_".$array[3]."_".$array[4]."_".$array[5]."\n";
      print FDW1 $array[6]."\n";
      $final++;
    }
  }
  
  $count++;
}

print "Total with mult=1:".$count."\n";
print "Selected: ".$final."\n";

system ("rm -r temp.txt");
