#!/usr/bin/perl -w

open IN, "$ARGV[0]";
open OUT, ">$ARGV[1]";

my %mers;

my $e = 10;
my $m = 30;
my $cutoff = 0.8;

my $GC_avg=0;
my $AT_avg=0;

my $k=$e+$m+$e;


while (<IN>) {
	chomp($_);
	if ($_ =~ /^\>/) {
		next;
	}
	else {
		my $seq = $_;
		my @total  = ($seq =~ /[ATGC]/g);
        	my @tot_GC = ($seq =~ /[GC]/g);
		my @tot_AT = ($seq =~ /[AT]/g);	
	
		$GC_avg= scalar(@tot_GC)/scalar(@total);
		$AT_avg= scalar(@tot_AT)/scalar(@total);
		for ($seq =~ /(?=(.{$k}))/g) {
			$mers{$_} ++; 
		}

	}
}

print $AT_avg."\t".$GC_avg."\n";

foreach (keys %mers) {
#	print $_."\t";
	my $temp = $_;
	my $Sequence = $_;

	$temp =~ /(\w{$e})(\w{$m})(\w{$e})/g;
#	print $1."\t".$2."\t".$3."\t";
	my $x1 = $1;
	my $x2 = $2;
	my $x3 = $3;
	
	my @AT1 = ($x1 =~ /[AT]/g);
	my @GC = ($x2 =~ /[GC]/g);
	my @AT2 = ($x3 =~ /[AT]/g);
#	print scalar(@AT1)/$e."\t".scalar(@GC)/$m."\t".scalar(@AT2)/$e."\n"; 
	
	#if (scalar(@AT1)/$e > $AT_avg && scalar(@GC)/$m > $GC_avg && scalar(@AT2)/$e > $AT_avg) {
	if (scalar(@AT1)/$e > $cutoff  && scalar(@GC)/$m > $cutoff && scalar(@AT2)/$e > $cutoff ) {
		print OUT $Sequence."\n";
		print OUT scalar(@AT1)/$e."\t".scalar(@GC)/$m."\t".scalar(@AT2)/$e."\n";
	}

}

