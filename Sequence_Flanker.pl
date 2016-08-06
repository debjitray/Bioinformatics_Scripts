#!/usr/bin/perl -w

if (scalar(@ARGV) != 2) {
	print "\n******  Retrieves L and R flank from the contigs ******\n\n";
	print "\nUSAGE: perl Sequence_Flanker.pl SizeofRegion\n\n";
	exit;
}

my $Size = $ARGV[1];
open IN, $ARGV[0];

my @Name = split (/\//,$ARGV[0]);

my @MX;
while(<IN>) {
	chomp;
	if ($_ =~ />/) {
		push(@MX,">");
		next;
	}
	else {	
		my $entry = $_;
		my @Y = split(//,$entry);
		if (scalar(@Y) >= 2*$Size ) {
			push (@MX, $entry);
		}
		else {
		     pop(@MX);
		}	
	}
}
my $input = join ("",@MX);
my @In_array = split(/>/,$input);

for (my $i=1 ; $i <=scalar(@In_array)-1; $i++) {
	my(@YOLO) = split(//,$In_array[$i]);
	my @X  = splice (@YOLO,0,$Size);
	my $l = scalar(@YOLO);
	my $start = $l-$Size;
	my @Y  = splice (@YOLO,$start,$Size);
	print ">".$Name[-1]."_Contig".$i."_L\n";
	print join("",@X)."\n";
	print ">".$Name[-1]."_Contig".$i."_R\n";
	print join("",@Y)."\n";
}

#print join("",">RetSequence_",$ARGV[1],"_",$ARGV[2],"\n");
#print join("",@X)."\n";
