package RangeQuery;

use strict;
use warnings;
use Carp;

our $VERSION = '0.03';

=head1 NAME

RangeQuery - retrieves the minimum/maximum value from a sequence within a given range.

=head1 SYNOPSIS

    use RangeQuery qw(min_value max_value);

    my @sequence = (4,2,8,6,1,2);
    my $range = RangeQuery->new(@sequence);
    my $min = $range->min_value(1,3);   # 2
    my $max = $range->max_value (4, 6); # 6


=head1 DESCRIPTION

Retrieves the minimum/maximum value from a sequence within a given range. The range is represented with two 1-based indexes.
It takes O(n log n) to build the object and O(1) to retrieve a min/max value.


=head1 METHODS

=head2 new

Creates a new RangeQuery object. 
This builds the appropriate data structure in order to retrieve values efficiently.

=cut

sub new {
    my ($self, @sequence) = @_;

    croak "Set is empty." if !$#sequence;

    my @new_sequence = @sequence;
    my (@max, @min);

    my $obj = [\@new_sequence, \@max, \@min];
    bless $obj, $self;
    _build $obj;

    return $obj;
}

sub _max ($$) { $_[$_[0] < $_[1]] }
sub _min ($$) { $_[$_[0] > $_[1]] }

=head2 max_value

Retrieves the maximum value within a given range.
This receives two 1-based indexes.

=cut

sub max_value {
    croak "Wrong number of parameters." if @_ != 3;

    my ($self, $left, $right) = @_;
    my ($sequence, $max, $min) = ($self->[0], $self->[1], $self->[2]);

    croak "Invalid range." if $left > $right || $left < 1 || $right > $#{$sequence} + 1;

    $left--, $right--;
    my $t = log ($right - $left + 1) / (log 2);
    my $p = (1 << $t);

    return _max($max->[$left][$t], $max->[$right - $p + 1][$t]);
}

=head2 min_value

Retrieves the minimum value within a given range.
This receives two 1-based indexes.

=cut

sub min_value {
    croak "Wrong number of parameters." if @_ != 3;

    my ($self, $left, $right) = @_;
    my ($sequence, $max, $min) = ($self->[0], $self->[1], $self->[2]);

    croak "Invalid range." if $left > $right || $left < 1 || $right > $#{$sequence} + 1;

    $left--, $right--;
    my $t = log ($right - $left + 1) / (log 2);
    my $p = (1 << $t);

    return _min($min->[$left][$t], $min->[$right - $p + 1][$t]);
}

sub _build {
    my ($self) = @_;
    my ($sequence, $max, $min) = @{$self};
    my $size = $#{$sequence};

    for my $i (0..$size) {
	$min->[$i][0] = $max->[$i][0] = $sequence->[$i];
    }

    my $s = (log $size + 1) / log 2;
    for my $i (1 .. (log ($size + 1)) / (log 2)) {
	for (my $j = 0; $j + (1 << $i) - 1 <= $size; $j++) {
	    $min->[$j][$i] = _min($min->[$j][$i - 1], $min->[$j + (1 << ($i - 1))][$i - 1]);
	    $max->[$j][$i] = _max($max->[$j][$i - 1], $max->[$j + (1 << ($i - 1))][$i - 1]);
	}
    }
}

1;
__END__

=head1 ToDo

Implement the same funcionality with segment trees.

=head1 SEE ALSO

You can check a tutorial from TopCoder, L<http://www.topcoder.com/tc?module=Static&d1=tutorials&d2=lowestCommonAncestor>

You can check an implementation in C here L<http://web.ist.utl.pt/joao.carreira/rmq.html>

=head1 AUTHOR

JoE<atilde>o Carreira, C<< joao.carreira@ist.utl.pt >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by JoE<atilde>o Carreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
