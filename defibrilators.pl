#!/usr/bin/perl
# Read inputs from <STDIN>. Write outputs to standard output.
#
# http://www.codingame.com/cg/#!page:training

use strict;
use warnings;

my $debug = 0;
use Data::Dumper;

chomp(my $long = <STDIN>);
chomp(my $lat  = <STDIN>);

chomp(my $n  = <STDIN>);

my $defibrillators = [];
for (0..$n-1) {
    chomp(my $m = <STDIN>);
    my @m = split(';', $m);
    push @$defibrillators, { name => $m[1], long => $m[4], lat => $m[5] };
}

print Dumper($defibrillators) if $debug;

my $min_d;
my $name;
foreach ( @$defibrillators ) {
    my $df_name = $_->{name};
    my $df_long = $_->{long};
    my $df_lat  = $_->{lat};
    
    $df_long =~ s/,/\./;
    $df_lat  =~ s/,/\./;
    $long =~ s/,/\./;
    $lat  =~ s/,/\./;
    
    my $x = ($long - $df_long) * cos( ($long + $df_long) / 2 );
    my $y = ($lat - $df_lat );
    my $d = sqrt( $x*$x + $y*$y ) * 6371;
    
    if ( !defined $min_d || $d < $min_d ) {
        ($min_d, $name ) = ( $d, $df_name );
    }
}

print $name;
