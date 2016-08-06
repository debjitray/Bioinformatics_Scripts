#!/usr/bin/perl -w
# perl /data1/users/debray/scripts/ImproperProper.pl MP.contigs.bridges MP_ProperImProper_Sumary.txt 12
# perl ImproperProper.pl StatusSummary MP_ImproperProper_Sumary.txt 17(NumberofContigs)

use strict;

my $inputfile     = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

my $outputfile     = $ARGV[1];
open(FDW,">$outputfile") or die "Can't open $outputfile: $!\n";

my %hashIMP;
my %hashPROP;

for (my $i=1; $i <=$ARGV[2]; $i++) {
  for (my $j=1; $j <=$ARGV[2] ; $j++) {
    $hashPROP{$i}{$j}=0;
    $hashIMP{$i}{$j}=0;
  }
}

my $count=0;

foreach(<FDR>){
  (my $line = $_) =~ s/\r*\n//;
  next if ($line =~ /^Read_ID/);
  my (@array) = split (/\t/,$line);
  if ($array[3] =~ /^1$/ or $array[3] =~ /^\-1$/ ) {
    if ($array[5] =~ /PROPER/) {
      $hashPROP{$array[1]}{$array[1]}++;
      $count++;
    }
    else {
      $hashIMP{$array[1]}{$array[1]}++;
      $count++;
    }
  }
  else {
    my %temp;
    $array[1] =~ s/[LR]//;
    $array[3] =~ s/[LR]//;
    if ($array[5] =~ /BRIDGE/) {
	if ($array[1] == $array[3]) {
	 	$hashPROP{$array[1]}{$array[3]}++;
	}
      	else {
      		$hashPROP{$array[1]}{$array[3]}++;
      		$hashPROP{$array[3]}{$array[1]}++;
	}
      $count++;
    }
    else {
      $hashIMP{$array[1]}{$array[3]}++;
      $hashIMP{$array[3]}{$array[1]}++;
      $count++;
    }
  }
 
}
print FDW "Proper/Improper\n";
foreach my $i(sort {$a<=>$b} keys %hashPROP){
    foreach my $j(sort {$a<=>$b} keys %{$hashPROP{$i}}){
      print FDW $hashPROP{$i}{$j}."\/".$hashIMP{$i}{$j}."\t";
      print $i."\.".$j."\n";
    }
    print FDW "\n";
}


print $count."\n";
