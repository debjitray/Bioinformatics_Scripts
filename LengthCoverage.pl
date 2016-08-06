#!/usr/bin/perl
use List::Util 'max';
# USAGE: perl LengthCoverage.pl <INPUT.fa> <LENGTH_CUTOFF> <COVERAGE CUTOFF>

# Length >= 1000
# Covergae >= 100

$inputfile     = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

$outputfile     = "scaffolds_cutoff_Summary.txt";
open(FDW,">$outputfile") or die "Can't open $outputfile: $!\n";

my $i=0;
my $j=0;
my $TotalSize=0;
my @ALL;

foreach(<FDR>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^>/) {
    $line =~ />(.+)_length_(\d+)_cov_(\d+\.*\d*)/g;
    if ($2 >= $ARGV[1] && $3 >= $ARGV[2]) {
      print FDW $1."\t".$2."\t".$3."\n";
      $i++;
      $TotalSize=$TotalSize+$2;
      push(@ALL,$2);
    }
    $j++;
  }
}

my $max=max @ALL;

print "\nChosen length cut off: ".$ARGV[1]." and coverage cutoff: ".$ARGV[2]."\n" ;
print "Total contigs/scaffolds in this file: ".$j."\n";
print "Contigs above the criteria: ".$i."\n";
print "Total contig length: ".commify($TotalSize)."\n";
print "Maximum contig size: ".commify($max)."\n\n";

print FDW "\n\nChosen length cut off: ".$ARGV[1]." and coverage cutoff: ".$ARGV[2]."\n" ;
print FDW "Total contigs/scaffolds in this file: ".$j."\n";
print FDW "Contigs above the criteria: ".$i."\n";
print FDW "Total contig length: ".commify($TotalSize)."\n";
print FDW "Max contig size: ".commify($max)."\n";


sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}