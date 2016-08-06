#! /usr/bin/perl -w
# This code trim BASES from the beginning and end of a fasta file
# USAGE: perl trimmer.pl TEST.scaffolds 10
use strict;
my ($contigfile, $trimlength) = @ARGV;
open IN, $contigfile;
open OUT, ">contigfile.trimmed";
my ($contig, $seq);
while (<IN>) {
  if (/^>(\S+)/) {
    Trim();
    $contig = $1;
    $contig = $1
      if $_ =~ /^>NODE_(\d+)/; $seq = ''; print OUT $_; next
    }
  chomp;
  $seq .= uc $_;    
}
close IN;
Trim();
close OUT;

sub Trim {
 return unless $seq;
 my $query = substr $seq, 0, $trimlength, '';
 $query = substr $seq, -1*$trimlength, $trimlength, '';
 print OUT $seq."\n";
}
