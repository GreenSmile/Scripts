#!/usr/bin/perl
# Read inputs from <STDIN>. Write outputs to standard output.
#
# http://www.codingame.com/cg/#!page:training
# http://www.codingame.com/cg/#!report:16488969ed503b5ed35b26650ea52582fa4354

use strict;
use warnings;

my $debug = 0;
use Data::Dumper;

my $price = {};

my $temp = { 'eaionrtlsu' => 1, 'dg' => 2, 'bcmp' => 3, 'fhvwy' => 4, 'k' => 5, 'jx' => 8, 'qz' => 10 };

for my $k ( keys %$temp ) {
    my $p = $temp->{$k};
    $price->{$_} = $p for split('', $k);
}

print Dumper($price) if $debug;

chomp(my $count = <STDIN>);

my $dictionary = [];
for (0..$count-1) {
    chomp(my $word = <STDIN>);
    # my @m = split(';', $m);
    push @$dictionary, $word;
}

chomp(my $letters = <STDIN>);

print Dumper($dictionary)   if $debug;
print "letters: $letters\n" if $debug;

my $letters_len = length($letters);

my ($max, $max_word) = (0, '');

WORD: for (my $i = $#$dictionary; $i>=0; --$i) {
    my $str = $dictionary->[$i];
    my $str_len = length($str);
    print "check word: $str, ($str_len)\n" if $debug;
    next WORD if $str_len > $letters_len;
    my $tmp_letters = {};
    add_letter($tmp_letters, $_) for split('', $letters);
    print Dumper($tmp_letters) if $debug;
    for my $l (split('', $str)) {
        print "check letter: $l\n" if $debug;
        unless ( delete_letter($tmp_letters, $l) ) {
            print "no letter $l. Skip word\n" if $debug;
            next WORD;
        }
    }
    
    my $p = price_word($str);
    ($max, $max_word) = ($p, $str) if $max <= $p;
    print "MAX: $max_word\n" if $debug;
}

print "$max_word";

sub add_letter {
    my ($tmp_letters, $l) = @_;
    $tmp_letters->{$l} = 0 unless defined $tmp_letters->{$l};
    $tmp_letters->{$l}++;
}

sub delete_letter {
    my ($tmp_letters, $l) = @_;
    return 0 unless $tmp_letters->{$l};
    $tmp_letters->{$l}--;
    delete $tmp_letters->{$l} unless $tmp_letters->{$l};
    return 1;
}

sub price_word {
    my ($word) = @_;
    my $sum = 0;
    $sum += $price->{$_} for split('', $word);
    return $sum;
}
