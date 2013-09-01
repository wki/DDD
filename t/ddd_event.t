use strict;
use warnings;
use DateTime;
use Test::More;

use ok 'DDD::Event';

my $fake_date_time = DateTime->new(
    year => 2010,
    month => 12,
    day => 11,
    hour => 14,
    time_zone => 'local',
);
no warnings 'redefine';
local *DateTime::now = sub { $fake_date_time->clone };

{
    package E;
    use Moose;
    extends 'DDD::Event';
}

my $e = E->new;

is DateTime::compare($e->occured_on, $fake_date_time), 
    0,
    'occured_on is set';

done_testing;
