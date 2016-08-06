#!/usr/bin/perl -w

#USAGE = perl MPsplit_DR.pl TEMP.fastq
# Creates 2 files containing the left the right overhangs considering the known overlap region /CTGTCTCTTATACACATCTAGATGTGTATAAGAGACAG/

$inputfile     = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

# OUTPUT FOR FORWARD READS
my ($TEMP1,$TEMP2)= split(/\./,$ARGV[0]);

$outputfile1     = join ("_",$TEMP1,"1.fastq");
open(FDW1,">$outputfile1") or die "Can't open $outputfile1: $!\n";

$outputfile2     = join ("_",$TEMP1,"2.fastq");
open(FDW2,">$outputfile2") or die "Can't open $outputfile2: $!\n";

my $count=0;
my $count1=0;

while(( my @lines = map $_ = <FDR>, 1 .. 4 )[0]) {
  chomp($lines[0]);
  chomp($lines[1]);
  chomp($lines[2]);
  chomp($lines[3]);
  
  if ($lines[1] =~ /([ACGT]{21,})CTGTCTCTTATACACATCTAGATGTGTATAAGAGACAG([ACGT]{21,})/) {
    $count1++; 
    print FDW1 $lines[0]."\n";
    print FDW1 $1."\n";
    print FDW1 $lines[2]."\n";
    my @ARRAY1 = split(//,$1);
    my (@scores1) = split (//,$lines[3]);
    my $final1 = join("",@scores1[0 .. $#ARRAY1]);
    print FDW1 $final1."\n";

    print FDW2 $lines[0]."\n";
    print FDW2 $2."\n";
    print FDW2 $lines[2]."\n";
    my @ARRAY2 = split(//,$2);
    my (@scores2) = split (//,$lines[3]);
    my $final2 = join("",@scores2[(-($#ARRAY2)-1) .. -1]);
    print FDW2 $final2."\n";

  }
  $count++;
  print $count."\n";
}


print "\nTotal number of lines in the main file ".$count."\n";
print "Total number of lines after filtering ".$count1."\n";
