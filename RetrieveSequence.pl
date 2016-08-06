#!/usr/bin/perl -w

if (scalar(@ARGV) != 3) {
	print "\n*****  Retrieves regions of interest from a sequence fasta file  *****\n\n";
	print "\nUSAGE: perl RetrieveSequence.pl FASTA Start End\n\n";
	exit;
}

my $len = $ARGV[2]-$ARGV[1]+1;

open IN, $ARGV[0];

my $input; 
my @MX;
while(<IN>) {
	chomp;
	next if ($_ =~ />/);
	push (@MX, $_);	
}
$input = join ("",@MX);
my @In_array = split(//,$input);
my @X  = splice (@In_array,$ARGV[1],$len);

print join("",">RetSequence_",$ARGV[1],"_",$ARGV[2],"\n");
print join("",@X)."\n";
