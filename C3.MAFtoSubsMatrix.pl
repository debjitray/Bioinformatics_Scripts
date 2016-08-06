#! /usr/bin/perl -w

# USAGE: perl C3.MAFtoSubsMatrix.pl CDiff.maf SubsMatrix.txt

# Takes the .maf file, selects the mult=7 and then creates a base substituion matrix

my $k = $ARGV[0];

system ("grep -A 7 'mult=7' $k| grep -v 'mult=7'| grep -v '^--' > temp.txt");

my $inputfile     = "temp.txt";
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

my $outputfile1     = $ARGV[1];
open(FDW1,">$outputfile1") or die "Can't open $outputfile1: $!\n";

my @A0;
my @A1;
my @A2;
my @A3;
my @A4;
my @A5;
my @A6;

my $count=0;
while(( my @lines = map $_ = <FDR>, 1 .. 7 )[0]) {

  my(@array0)=split(/\s+/,$lines[0]);
  push(@A0,$array0[6]);

  my(@array1)=split(/\s+/,$lines[1]);
  push(@A1,$array1[6]);

  my(@array2)=split(/\s+/,$lines[2]);
  push(@A2,$array2[6]);

  my(@array3)=split(/\s+/,$lines[3]);
  push(@A3,$array3[6]);

  my(@array4)=split(/\s+/,$lines[4]);
  push(@A4,$array4[6]);

  my(@array5)=split(/\s+/,$lines[5]);
  push(@A5,$array5[6]);

  my(@array6)=split(/\s+/,$lines[6]);
  push(@A6,$array6[6]);
  $count++;
}

my $X0=join("",@A0);
my (@Diff0)=split(//,$X0);

my $X1=join("",@A1);
my (@Diff1)=split(//,$X1);

my $X2=join("",@A2);
my (@Diff2)=split(//,$X2);

my $X3=join("",@A3);
my (@Diff3)=split(//,$X3);

my $X4=join("",@A4);
my (@Diff4)=split(//,$X4);

my $X5=join("",@A5);
my (@Diff5)=split(//,$X5);

my $X6=join("",@A6);
my (@Diff6)=split(//,$X6);

print "Length of blocks in each strain: ".scalar(@Diff2)."\t".scalar(@Diff0)."\t".scalar(@Diff6)."\t".scalar(@Diff4)."\t".scalar(@Diff5)."\t".scalar(@Diff1)."\t".scalar(@Diff3)."\n";
print "Number of blocks with mult=7: ".$count."\n";


my @NAMES=qw(\@Diff2 \@Diff0 \@Diff6 \@Diff4 \@Diff5 \@Diff1 \@Diff3);

for (my $j=0;$j<scalar(@NAMES);$j++) {
  for (my $k=0;$k<scalar(@NAMES);$k++) {
    print FDW1 compare(eval($NAMES[$j]),eval($NAMES[$k]))."\t";
  }
  print FDW1 "\n";
}


sub compare {
  my @first = @{ $_[0] }; 
  my @second = @{ $_[1] };
  my $z=0;
  for (my $i=0;$i<scalar(@first);$i++) {
    if ($first[$i] ne $second[$i]) {
      $z++;
    }
  }
  return commify($z);
}




sub commify {
    local $_  = shift;
    s{(?<!\d|\.)(\d{4,})}
    {my $n = $1;
        $n=~s/(?<=.)(?=(?:.{3})+$)/,/g;
        $n;
    }eg;
    return $_;
}

system ("rm -r temp.txt");
