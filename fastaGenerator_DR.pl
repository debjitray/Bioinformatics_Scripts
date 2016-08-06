#!/usr/bin/perl
# Creates fasta file from prevous fasta files with Length and Coverage Cutoff
# USAGE: perl fastaGeenerator.pl INFILE <LengthCutOff> <CoverageCutOff> OUTFILE
# AUTHOR: DEBJIT RAY

use warnings;
use strict;
use IO::File;
my $inseq = 0;
my $total = 0;
my $count = 0;
my $inFh = IO::File->new( $ARGV[0] ) || die "can't open file\n";

my $outputfile     = $ARGV[3];
open(FDW,">$outputfile") or die "Can't open $outputfile: $!\n";

while( my $line = $inFh->getline )
{
  chomp($line);
  if($inseq){
    if($line =~ /^>/) {
      $inseq = 0;
    } else {
      print FDW $line . "\n";
      next;
    }
  }
  if($line =~ /^>/){
    $line =~ />(.+)_length_(\d+)_cov_(\d+\.*\d*)/g;
    if ($2 >= $ARGV[1] && $3 >= $ARGV[2]) {
      $inseq = 1;
      print FDW $line . "\n";
      $count++;
    }
    $total++;
  } 
}
close($inFh);
print "Selected contigs: ".$count."\n";
print "Total contigs: ".$total."\n";
