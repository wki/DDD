use strict;
use warnings;
use DateTime;
use Test::More;
use Test::MockDateTime;

use ok 'DDD::Event';

{
    package E;
    use Moose;
    extends 'DDD::Event';
}

on '2010-12-11 14:02:04' => sub {
    my $e = E->new;
    
    is $e->occured_on->ymd, 
        '2010-12-11',
        'occured on date';

    is $e->occured_on->hms, 
        '14:02:04',
        'occured on time';
};

done_testing;
