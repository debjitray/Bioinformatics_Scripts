#!/usr/bin/perl -w
# This code filters the important NODES from a .fastg files based on the scaffolds selected earlier with their length and covergae information

# USGAE:: perl fastg_filter_Bandage.pl scaffolds_Selected.fasta scaffolds.fastg S8.txt

use strict;

my ($inputfile1, $inputfile2, $outputfile)     = @ARGV;
open(FDR1,"<$inputfile1") or die "Can't open $inputfile1: $!\n";

my @ALL;

foreach(<FDR1>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^>/) {
    my (@ARR) = split (/length/,$line);
    $ARR[0] =~ s/\>//;
    push (@ALL,$ARR[0]);
  }
}

my $string = join("\|",@ALL);

print $string."\n";

system("egrep '$string' $inputfile2 > $outputfile");
