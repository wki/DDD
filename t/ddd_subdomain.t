use Test::Most;

use ok 'DDD::SubDomain';

use DDD::SubDomain;

can_ok 'main', qw(has service subdomain factory repository aggregate dep);

done_testing;
