use strict;
use warnings;
use Test::More;

use ok 'DDD::Base::Domain';

{
    package D;
    use Moose;
    extends 'DDD::Base::Domain';
}

note 'singleton';
{
    my $d1 = D->instance;
    my $d2 = D->instance;
    
    is $d1, $d2, 'instances are identical';
}

done_testing;
