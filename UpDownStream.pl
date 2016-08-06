#!/usr/bin/perl -w

if( $ARGV[0] eq '-h' || $ARGV[0] eq '-help')
{
    help();
    exit;
}


sub help { print "USAGE:: perl C1.ReadFile_Main.pl 630RRNA2000.fa out.fasta SIZE_Regions";
}

$inputfile     = $ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

$outfile     = $ARGV[1];
open(FDW,">$outfile") or die "Can't open $outfile: $!\n";

my $k = $ARGV[2];

$outfile2     = join("_",$ARGV[1],"rDNASequences.fa");
open(FDW2,">$outfile2") or die "Can't open $outfile2: $!\n";

my $x;
my $y;

foreach(<FDR>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^>/) {
    $line =~ s/(>gi\|126697566\|ref\|NC_009089.1\|\:)//;
    $line =~ s/( Peptoclostridium difficile 630, complete genome<)//;
    $x=$line;
    $y++;
  }
  else {
    $line =~ /(\w{$k})(.+)(\w{$k})/;
    print FDW ">".$x."_".$y."_Up_"."\n";
    print FDW $1."\n";
    print FDW ">".$x."_".$y."_Down_"."\n";
    print FDW $3."\n";
    print FDW2 ">".$x."_".$y."\n";
    print FDW2 $2."\n";
  }
}

