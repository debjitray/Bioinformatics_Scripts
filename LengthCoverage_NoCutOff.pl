#!/usr/bin/perl
use Cwd;
# USAGE: perl LengthCoverage.pl <INPUT.fa>
$inputfile     = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

$outputfile     = "scaffolds_Summary_NoCutOff.txt";
open(FDW,">$outputfile") or die "Can't open $outputfile: $!\n";

my $i=0;
my $j=0;

foreach(<FDR>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^>/) {
    $line =~ />(.+)_length_(\d+)_cov_(\d+\.*\d*)/g;
    if ($2 >= $ARGV[1] && $3 >= $ARGV[2]) {
      print FDW $1."\t".$2."\t".$3."\n";
      $i++;
    }
    $j++;
  }
}

print "Above criteria: ".$i."\n";
print "Total: ".$j."\n";

system ("Rscript /usr/bin/LengthCoverage_NoCutOff.R");
#print "Above criteria: ".$i."\n";
#print "Total: ".$j."\n";

#print FDW "\n\nChosen length cut off: ".$ARGV[1]." and coverage cutoff: ".$ARGV[2]."\n" ;
#print FDW "Total contigs/scaffolds in this file: ".$j."\n";
#print FDW "Contigs above the criteria: ".$i."\n";
