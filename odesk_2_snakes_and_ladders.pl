#!/usr/bin/perl
# Read inputs from <STDIN>. Write outputs to standard output.
#
# http://www.codingame.com/cg/#!page:training
# http://www.codingame.com/cg/#!report:16488969ed503b5ed35b26650ea52582fa4354

use strict;
use warnings;

my $debug = 1;
use Data::Dumper;

# GET
chomp(my $map_len = <STDIN>);

my $map = [];
for (0..$map_len-1) {
    chomp(my $sq = <STDIN>);
    $map->[$_] = $sq;
}

print Dumper($map) if $debug;

my $start = get_position($map, 'S');
my $end   = get_position($map, 'E');

print "$start, $end\n" if $debug;

unless ( defined $start && defined $end ) {
    print "impossible";
    exit(0);
}

# END GET

my $dice = [6,5,4,3,2,1];
my $thrown_dices = {};
my $visited = {};
my $calculated = {};

my $count = calc_move($start);
if ( defined $count ) {
    print "$count";
} else {
    print "impossible";
}

# -----

sub calc_move {
    my ($i) = @_;

    my $char = $map->[$i];

    print "calc_move: $i, '$char'\n" if $debug;
    print join(' ', @$map) . "\n\n" if $debug;
    
    return undef unless defined $char;
    return 0         if $char eq 'E';
    return undef     if $visited->{$i};
    return $calculated->{$i} if exists $calculated->{$i};

    $visited->{$i} = 1;
    my $count;
    if ( $char eq "R" || $char eq "S" ) {
        $count = calc_with_dice( $i );
    } else {
        $count = calc_move( $i + $char );
    }
    delete $visited->{$i};
    
    $count++ if defined $count;
    $calculated->{$i} = $count;

    return $count;
}

sub calc_with_dice {
    my ($i) = @_;

    print "calc_with_dice( $i )\n" if $debug;
    print join(' ', @$map) . "\n" if $debug;

    my $low;
    foreach (@$dice) {
        print "check dice: $_\n" if $debug;
        my $count = calc_move($i+$_);
        if ( defined $count ) {
            $low = $count if (! defined $low or $low > $count);
        }
    }

    return $low;
}


#------

sub get_position {
    my ($map, $target) = @_;
    for my $i (0..$#$map) {
        my $char = $map->[$i];
        if ( $char eq $target ) {
            return $i;
        }
    }
    return undef;
}
