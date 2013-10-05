use strict;
use warnings;
use Test::More;

use ok 'DDD::Base::Container';

note 'instantiation';
{
    my $d = DDD::Base::Container->new;
    
    is $d->domain, $d, 'domain guessed right';
}

done_testing;
