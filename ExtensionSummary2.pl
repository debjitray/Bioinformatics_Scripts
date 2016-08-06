#! /usr/bin/perl
# USAGE: perl ExtensionSummary.pl contigfile.trimmed EXTENDED.extendedcontigs_r_0.8.fasta OUT
use strict;
my ($X, $Y, $New) = @ARGV;
open INX, $X;
open INY, $Y;
open OUT, ">$New.ExtendedOnly.fasta";
open OUT2, ">$New.ExtendMarked.fasta";
open OUT3, ">$New.ExtendedOnlyPlus1000.fasta";
my ($contig, $seq);

my $i=0;
my @ARRAY1;

while (<INX>) {
  (my $line = $_) =~ s/\r*\n//;
  if ($line  =~ /^>(\S+)/) {
    next;
  }
  else {
    $ARRAY1[$i]=$line;
    $i++;
  }   
}

print "\tPREF\tSUFF\n";
my $j=0;
my $HEAD;
while (<INY>) {
  (my $line = $_) =~ s/\r*\n//;
  if ($line  =~ /^>(\S+)/) {
    print OUT2 $line."\n";
    $HEAD=$line;
    next;
  }
  else {
    $line =~ s/($ARRAY1[$j])/*$1*/g;
    my (@ALL)=split (/\*/,$line);
    my $x=scalar(split(//,$ALL[0]));
    my $y=scalar(split(//,$ALL[2]));
    print $HEAD."\t".$x."\t".$y."\n";
    print OUT2 lc($ALL[0]).$ALL[1].lc($ALL[2])."\n";
    
    print OUT $HEAD."\|PRE\|".$x.":\n";
    print OUT $ALL[0]."\n";
    print OUT $HEAD."\|SUFF\|".$y.":\n";
    print OUT $ALL[2]."\n\n";

    my $X= substr $ALL[1], 0, 1000;
    my $Y= substr $ALL[1], -1000, 1000; 
    
    print OUT3 $HEAD."\|PRE\|".$x.":\n";
    print OUT3 $ALL[0].$X."\n";
    print OUT3 $HEAD."\|SUFF\|".$y.":\n";
    print OUT3 $Y.$ALL[2]."\n";
    
    $j++;
  }   
}
