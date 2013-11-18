#!/usr/bin/perl
# Read inputs from <STDIN>. Write outputs to standard output.
#
# http://www.codingame.com/cg/#!page:training

use strict;
use warnings;

my $debug = 0;
use Data::Dumper;

chomp(my $n = <STDIN>);
chomp(my $f = <STDIN>);

use File::Basename;

my $mimes = {};
for (0..$n-1) {
    chomp(my $m = <STDIN>);
    my @m = split(' ', $m);
    $mimes->{lc $m[0]} = $m[1];
}

my $files = [];
for (0..$f-1) {
    chomp($files->[$_] = <STDIN>);
}

print Dumper($mimes) if $debug;
print Dumper($files) if $debug;

foreach my $f (@$files) {
    print "$f\n" if $debug;
    my $ext = (fileparse($f, qr/\.[^.]*/))[2];
    $ext =~ s/\.//g;
    print "$ext\n" if $debug;
    if ( $mimes->{lc $ext} ) {
        print $mimes->{lc $ext} . "\n";
    } else {
        print "UNKNOWN\n";
    }
}