#!/usr/bin/perl -w

my $inputfile = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

my $outputfile1 = $ARGV[1];
open(FDW1, ">$outputfile1") or die "Can't open $outputfile1: $!\n";

my $count=0;


while(( my @lines = map $_ = <FDR>, 1 .. 4 )[0]) {
	$count++;
	chomp($lines[0]);
 	chomp($lines[1]);
# 	chomp($lines[2]);
#  	chomp($lines[3]);
	print FDW1 "\>".$count."\n";
	print FDW1 $lines[1]."\n";
}

print $count."\n";
