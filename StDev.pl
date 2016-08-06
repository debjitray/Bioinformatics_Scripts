#!/usr/bin/perl -w
use Statistics::Basic qw(:all);

$inputfile     = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

$file     = "temp.txt";
open(FDW,">$file") or die "Can't open $file: $!\n";

my @array;
my $z=0;

foreach(<FDR>){
  (my $line = $_) =~ s/\r*\n//;
  next if ($line =~ /times/g);
  my ($num,$times) = split (/\t/,$line);
  for (my $x=0;$x<$times;$x++) {
    push (@array,$num);
  }
  $z=$z+$times;

}



my $median = median(@array);
my $stddev   = stddev(@array);


print "Median\t".$median."\n";
print "STDDEV\t".$stddev."\n";