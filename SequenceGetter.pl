#! /usr/bin/perl -w

# Usage : perl SequenceGetter.pl contigfile corordfile

# Removes the region that match the rDNA sequences from the blast file (CoOrd)
use strict;

my $contigfile = $ARGV[0];
my $coord = $ARGV[1];

open IN2, $coord;
open OUT, ">contigs.fa";

my @mat=();
my $i=0;
my %NAMESAKE=();
while (<IN2>) {
  chomp;
  $mat[$i] = $_;
  my (@OWE) = split (/\t/,$mat[$i]);
  $NAMESAKE{$OWE[0]}++;
  $i++;
}
close IN2;
my $k;
my %hash;
my @array=();
my $counter=0;
my $OVERALL=0;

for (my $j=0 ; $j < $i ; $j++) {
  my (@Emni) = split (/\t/,$mat[$j]);
  my $Name = $Emni[0];
  my @start = $Emni[1];
  my @end = $Emni[2];
  $hash{$Name}++;
  if ($hash{$Name} == 1) {
    $k = `grep -A 1  $Name $contigfile | awk '!/$Name/'`;
    $k =~ s/\n//;
    $counter=0;
  }
  @array = split(//,$k);
  my $len = $end[0]-$start[0];
  my @removedItems = splice (@array,$start[0],$len, "X");
  $k=join("",@array);
  $counter++;
  if ($NAMESAKE{$Name} == $counter) {
    my @SPLITTED = split (/X/,$k);
    foreach (@SPLITTED) {
      my $SIZE=scalar(split(//,$_));
      if ($SIZE > 10) {
	$OVERALL++;
	print $Name."\t"."Trimmed size::".$SIZE."\n";
	print OUT ">NODE_".$OVERALL."_length_".$SIZE."_cov_253.843_ID_".$Name."\n";
	print OUT $_."\n";
      }
    }
  }
  
}
