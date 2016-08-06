#! /usr/bin/perl -w
use strict ;

unless (scalar @ARGV == 2) {die "Usage: $0 maffile mintaxa\n"}
my ($file, $min) = (@ARGV) ;
my ( @align , %ct , %acclens , %taxa , %lens , %uniques , %missing , $collect, @taxorder ) ;
open IN , $file ;
while ( <IN> ) {
 if ( /^a +score=(\d+) +label=(\S+) +mult=(\d+)/ ) { 
  $ct{origaligns} ++ ;
  if ( $3 < $min ) { $collect = 0 ; next }
  $ct{aligns} ++ ;
  push @align , { sco => $1 , lab => $2 , mul => $3 } ;
  $lens{align} += $1 ;
  $collect = 1 ;
  next 
 }
 unless ( $collect ) { next }
 if ( /^s +([^\s\.]+)\.(\S+)[\t ]+(\d+) +(\d+) +([\+\-]) +(\d+) +(\S+)/ ) {
  my ( $gnm , $acc , $start , $len , $or , $full , $seq ) = ( $1 , $2 , $3 , $4 , $5 , $6 , $7 ) ;
  my ( $fwdstart , $fwdend ) = ( $start , $start + $len ) ;
  if ( $or eq '-' ) { ( $fwdstart , $fwdend ) = ( $full - $fwdend , $full - $start ) }
  %{$align[-1]{members}{$gnm}} = ( acc => $acc , len => $len , fwdstart => $fwdstart , fwdend => $fwdend , or => $or , seq => $seq ) ;
  $ct{totlen} += $len ;
  $acclens{$2} = $full ;
  $taxa{$gnm} += $len ;
 }
}
close IN ;

@taxorder = sort { $taxa{$b} <=> $taxa{$a} } keys %taxa ;
$ct{taxa} = scalar keys %taxa;
print "alignments with >= $min members, of $ct{origaligns} aligns and $ct{taxa} taxa: n=$ct{aligns}; alignlen=$lens{align}; total length=$ct{totlen}; maxlen=$taxa{$taxorder[1]}($taxorder[1]); minlen=$taxa{$taxorder[-1]}($taxorder[-1])\n" ;

for my $align ( @align ) {
 open OUT , ">gbin" ;
 for my $tax ( @taxorder ) {
  print OUT ">$tax\n" ;
  unless ( $$align{members}{$tax} ) { print OUT '-' x $$align{sco} , "\n" }
  else { print OUT "$$align{members}{$tax}{seq}\n" }
 }
 close OUT ;
 system "Gblocks gbin -b5=h &> /dev/null" ;
 unless ( -f "gbin-gb" ) { print "Gblocks failed for $ct{align}.fa\n" ; next }
 open IN , "gbin-gb" ;
 my ( $tax , %seqs ) ;
 my $length = 0 ;
 while ( <IN> ) {
  chomp ;
  if ( />(\S+)/ ) { $tax = $1 ; next } 
  s/ //g ;
  $$align{members}{$tax}{gb} .= $_ ;
 }
 close IN ;
 unless ( $$align{members}{$taxorder[0]}{gb} ) { next }
 $lens{gb} += length $$align{members}{$taxorder[0]}{gb} ;
}
unlink 'gbin-gb' ; unlink 'gbin-gb.htm' ;

$file =~ s/\.maf$// ; 
open OUT , ">$file.phy" ;
print OUT " " , scalar ( @taxorder ) , " $lens{gb}\n" ;
for my $align ( @align ) {
 unless ( $$align{members}{$taxorder[0]}{gb} ) { next }
 $ct{align} ++ ;
 for my $tax ( @taxorder ) {
  if ( $ct{align} > 1 ) { print OUT " " } else { print OUT "$tax " }
  unless ( $$align{members}{$tax} ) { print OUT '-' x $$align{sco} , "\n" }
  else { 
   print OUT "$$align{members}{$tax}{gb}\n";
   $$align{members}{$tax}{gb} =~ s/-//g;
   $ct{occ} += length $$align{members}{$tax}{gb};
  }
 }
 print OUT "\n" ;
}
close OUT ;
$ct{occ} = sprintf "%.2f", 100 * $ct{occ} / $lens{gb} / $ct{taxa};
print "$ct{align} alignments with $lens{gb} bp after Gblocks; $ct{occ}\% occupancy; wrote .phy\n"

