#! /usr/bin/perl -w
# USAGE: perl CX.Final_Arranger.pl contigs.fa S7
use strict;

my $contigfile = $ARGV[0];
my $Mummer = join("",$ARGV[1],"_Mummer.txt");

open OUT, join("",">",$ARGV[1],"_Finale.fasta");


open IN2, $Mummer;

my @mat=();
my $i=0;
while (<IN2>) {
    chomp;
    $mat[$i] = $_;
    $i++;
}

for (my $j=0 ; $j < $i ; $j++) {
    my (@Emni) = split (/\,/,$mat[$j]);
    my $Name = $Emni[0];
    my $REVCOMP = $Emni[1];
    print $Name."\t".$REVCOMP."\n";
    
    my $Header = `grep -ow $Name $contigfile`;
    $Header =~ s/\n//;
    my $k = `grep -A 1 -ow $Name $contigfile | awk '!/$Name/'`;
    $k =~ s/\n//;
    if ($REVCOMP =~ /YES/) {
        print OUT ">".$Header."_RevComp\n".reverse_complement($k)."\n";
    }
    else {
        print OUT ">".$Header."\n".$k."\n";
    }
}




sub reverse_complement {
  my $dna = shift;

  # reverse the DNA sequence
  my $revcomp = reverse($dna);

  # complement the reversed DNA sequence
  $revcomp =~ tr/ACGTacgt/TGCAtgca/;
  return $revcomp;
}

