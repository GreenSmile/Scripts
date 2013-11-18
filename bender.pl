#!/usr/bin/perl
# Read inputs from <STDIN>. Write outputs to standard output.
#
# http://www.codingame.com/cg/#!page:training

use strict;
use warnings;

my $debug = 0;
use Data::Dumper;

chomp(my $map_size = <STDIN>);
my ($l, $c) = split(' ', $map_size);

my $lines = [];
for (0..$l-1) {
    chomp(my $line = <STDIN>);
    my @line = split('', $line);
    $lines->[$_] = \@line;
}

# print Dumper($lines);

my ($b_i, $b_j) = get_position($lines, '@');

my $b_direction = 'S';
my $b_inversed = 0;
my $b_breaker = 0;
my $b_die = 0;
my $b_obstacl = 0;

# print "$b_i, $b_j\n";

my $moves = {};
my $real_moves = [];

while (1) {     
    my $a = move();
    if ( $a ) {
        if ( $a eq 'LOOP' ) {
            $real_moves = [ $a ];
            last;
        } else {
            push @$real_moves, $a;
        }
    } 
} continue { last if $b_die };

print "$_\n" for @$real_moves;

# ------------
sub move {
    my ( $new_i, $new_j ) = ($b_i, $b_j);
    my $move;
    if ( $b_direction eq 'S' ) {
        $new_i++;
        $move = 'SOUTH';
    } elsif ( $b_direction eq 'E' ) {
        $new_j++;
        $move = 'EAST';
    } elsif ( $b_direction eq 'N' ) {
        $new_i--;
        $move = 'NORTH';
    } elsif ( $b_direction eq 'W' ) {
        $new_j--;
        $move = 'WEST';
    }

    if ( can_move($new_i, $new_j) ) {
        do_move($new_i, $new_j);
        if ( $moves->{$b_i}->{$b_j}->{$b_direction}->{$b_inversed} ) {
            if ( $moves->{$b_i}->{$b_j}->{$b_direction}->{$b_inversed} > 5 ) {
                $move = 'LOOP';
            } else {
                $moves->{$b_i}->{$b_j}->{$b_direction}->{$b_inversed}++;
            }
        } else {
            $moves->{$b_i}->{$b_j}->{$b_direction}->{$b_inversed} = 1;
        }
        
        return $move;
    } else {
        change_direction();
    }
    
    return undef;
}

sub change_direction {
    if ($b_inversed) { # WEST, NORTH, EAST, SOUTH
        if ( !$b_obstacl ) {
            $b_direction = 'W';
            $b_obstacl = 1;
        } elsif ( $b_direction eq 'W') {
            $b_direction = 'N';
        } elsif ( $b_direction eq 'N') {
            $b_direction = 'E';
        } else {
            $b_direction = 'S';
        }
    } else { # SOUTH, EAST, NORTH, WEST
        if ( !$b_obstacl ) {
            $b_direction = 'S';
            $b_obstacl = 1;
        } elsif ( $b_direction eq 'S') {
            $b_direction = 'E';
        } elsif ( $b_direction eq 'E') {
            $b_direction = 'N';
        } else {
            $b_direction = 'W';
        }  
    }
}

sub do_move {
    ($b_i, $b_j) = @_;
    
    my $char = $lines->[$b_i]->[$b_j];
    $b_obstacl = 0;
    if ( $char eq 'S' || $char eq 'E' || $char eq 'N' || $char eq 'W'  ) {
        $b_direction = $char; 
    } elsif ( $char eq 'X' ) {
        $lines->[$b_i]->[$b_j] = '';
        $moves = {};
    } elsif ( $char eq 'B' ) {
        $b_breaker = !$b_breaker;
    } elsif ( $char eq 'I' ) {
        $b_inversed = !$b_inversed;
    } elsif ( $char eq '$' ) {
        $b_die = 1;
    } elsif ( $char eq 'T' ) {
        ($b_i, $b_j) = get_position($lines, 'T', $b_i, $b_j);
    }

}

sub can_move {
    my ( $i, $j ) = @_;
    my $char = $lines->[$i]->[$j];
    
    if ( $char eq '#' ) {
        return 0; 
    } elsif ( $char eq 'X' ) {
        return 0 unless $b_breaker;
    } 
    
    return 1;
}


# ------------

sub get_position {
    my ($lines, $target, $ex_i, $ex_j) = @_;
    $ex_i ||= -1; 
    $ex_j ||= -1;
    for my $i (0..$#$lines) {
        my $columns = $lines->[$i];
        for my $j (0..$#$columns) {
            my $char = $columns->[$j];
            if ( $char eq $target && ($i != $ex_i || $j != $ex_j)) {
                return ($i, $j);
            }
        }
    }
}
