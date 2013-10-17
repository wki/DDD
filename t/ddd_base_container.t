use strict;
use warnings;
use Test::More;

use ok 'DDD::Base::Container';

# is no more correct. domain is only guessed for Domains.
# note 'instantiation';
# {
#     my $d = DDD::Base::Container->new;
#     
#     is $d->domain, $d, 'domain guessed right';
# }

done_testing;
