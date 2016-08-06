#!/usr/bin/perl -w

if( $ARGV[0] eq '-h' || $ARGV[0] eq '-help')
{
help();
exit;
}


sub help { print "USAGE:: nohup perl C1.ReadFile_Main.pl S1_R1_qFiltered.fq S1_R2_qFiltered.fq S1_R1.fq S1_R2.fq S1\n";
}

$inputfile     = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

$inputfile2     = $ARGV[1];
open(FDR2,"<$inputfile2") or die "Can't open $inputfile2: $!\n";

$inputfile3     = $ARGV[2];
open(FDR3,"<$inputfile3") or die "Can't open $inputfile3: $!\n";

$inputfile4     = $ARGV[3];
open(FDR4,"<$inputfile4") or die "Can't open $inputfile4: $!\n";

$outputfile     = join("",$ARGV[4],"_R1_Common.fq");
open(FDW,">$outputfile") or die "Can't open $outputfile: $!\n";

$outputfile2     = join("",$ARGV[4],"_R2_Common.fq");
open(FDW2,">$outputfile2") or die "Can't open $outputfile2: $!\n";


$outputfile3     = join("",$ARGV[4],"_R1_UnCommon.fq");
open(FDW3,">$outputfile3") or die "Can't open $outputfile3: $!\n";

$outputfile4     = join("",$ARGV[4],"_R2_UnCommon.fq");
open(FDW4,">$outputfile4") or die "Can't open $outputfile4: $!\n";

$outputfile5     = "0.Summary.txt";
open(FDW5,">$outputfile5") or die "Can't open $outputfile5: $!\n";

my %hash1;
my %hash2;
my $count1=0;
my $count2=0;

foreach(<FDR>){
  (my $line = $_) =~ s/\r*\n//;
    if ($line =~ /^\@\d+/) {
    $hash1{$line}++;
  }
}

foreach(<FDR2>){
  (my $line = $_) =~ s/\r*\n//;
    if ($line =~ /^\@\d+/) {
      $hash2{$line}++;
  }
}

my @array1;
my $i=0;
foreach(<FDR3>){
  (my $line = $_) =~ s/\r*\n//;
  $array1[$i]=$line;
  $i++;
}

my @array2;
my $j=0;
foreach(<FDR4>){
  (my $line = $_) =~ s/\r*\n//;
  $array2[$j]=$line;
  $j++;
}

close FDR;
close FDR2;
close FDR3;
close FDR4;


open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";
while(( my @lines = map $_ = <FDR>, 1 .. 4 )[0]) {
  chomp($lines[0]);
  chomp($lines[1]);
  chomp($lines[2]);
  chomp($lines[3]);
  if (exists $hash1{$lines[0]} and exists $hash2{$lines[0]}) {
    print FDW $lines[0]."\n";
    print FDW $lines[1]."\n";
    print FDW $lines[2]."\n";
    print FDW $lines[3]."\n";
    $count1++;
  }
}

open(FDR2,"<$inputfile2") or die "Can't open $inputfile2: $!\n";
while(( my @lines = map $_ = <FDR2>, 1 .. 4 )[0]) {
  chomp($lines[0]);
  chomp($lines[1]);
  chomp($lines[2]);
  chomp($lines[3]);
  if (exists $hash1{$lines[0]} and exists $hash2{$lines[0]}) {
    print FDW2 $lines[0]."\n";
    print FDW2 $lines[1]."\n";
    print FDW2 $lines[2]."\n";
    print FDW2 $lines[3]."\n";
    $count2++;
  }
}

close FDR;
close FDR2;


open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";
while(( my @lines = map $_ = <FDR>, 1 .. 4 )[0]) {
  chomp($lines[0]);
  chomp($lines[1]);
  chomp($lines[2]);
  chomp($lines[3]);
  if (exists $hash1{$lines[0]} and !exists $hash2{$lines[0]}) {
    print FDW3 $lines[0]."\n";
    print FDW3 $lines[1]."\n";
    print FDW3 $lines[2]."\n";
    print FDW3 $lines[3]."\n";

    $lines[0] =~ s/\@//;
    my $INDEX=($lines[0]*4)-4;
    print $INDEX."\n";
    #print FDW4 $array2[$INDEX]."\n";
    print FDW4 "@".$lines[0]."\n";
    print FDW4 $array2[$INDEX+1]."\n";
    print FDW4 $array2[$INDEX+2]."\n";
    print FDW4 $array2[$INDEX+3]."\n";

    print FDW5 $lines[0]."\t".$array2[$INDEX]."\n";
  }
}



open(FDR2,"<$inputfile2") or die "Can't open $inputfile2: $!\n";
while(( my @lines = map $_ = <FDR2>, 1 .. 4 )[0]) {
  chomp($lines[0]);
  chomp($lines[1]);
  chomp($lines[2]);
  chomp($lines[3]);
  if (!exists $hash1{$lines[0]} and exists $hash2{$lines[0]}) {
    print FDW4 $lines[0]."\n";
    print FDW4 $lines[1]."\n";
    print FDW4 $lines[2]."\n";
    print FDW4 $lines[3]."\n";

    $lines[0] =~ s/\@//;
    my $INDEX2=($lines[0]*4)-4;
    #print FDW3 $array1[$INDEX2]."\n";
    print FDW3 "@".$lines[0]."\n";
    print FDW3 $array1[$INDEX2+1]."\n";
    print FDW3 $array1[$INDEX2+2]."\n";
    print FDW3 $array1[$INDEX2+3]."\n";

    print FDW5 $array1[$INDEX2]."\t".$lines[0]."\n";
  }
}

print "Common counts ".$count1."\t".$count2."\n";
