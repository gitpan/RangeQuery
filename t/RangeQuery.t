# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl RangeQuery.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 24;
BEGIN { use_ok('RangeQuery') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my @sequence = (9,4,1,6,3,1,8,-2,54,2,9,-5,6,2,3,597,3,6);
my $range = RangeQuery->new(@sequence);
is($range->max_value(1,1), 9);
is($range->max_value(1,2), 9);
is($range->max_value(1,3), 9);
is($range->max_value(8,8), -2);
is($range->max_value(1,$#sequence), 597);
is($range->max_value(7,15), 54);
is($range->max_value(16,17), 597);
is($range->max_value($#sequence+1,$#sequence+1), 6);

is($range->min_value(1,2), 4);
is($range->min_value(1,3), 1);
is($range->min_value(8,8), -2);
is($range->min_value(1,$#sequence), -5);
is($range->min_value(7,15), -5);
is($range->min_value(16,17), 3);
is($range->min_value($#sequence+1,$#sequence+1), 6);

my @sequence2 = (-1,-2,-3,-4);
$range = RangeQuery->new(@sequence2);
is($range->max_value(1,1), -1);
is($range->max_value(1,2), -1);
is($range->max_value(1,3), -1);
is($range->max_value(1,4), -1);


is($range->min_value(1,1), -1);
is($range->min_value(1,2), -2);
is($range->min_value(1,3), -3);
is($range->min_value(1,4), -4);
