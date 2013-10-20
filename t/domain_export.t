use Test::Most;

use ok 'DDD::Domain';

use DDD::Domain;

can_ok 'main', qw(has service subdomain factory repository aggregate application dep);

done_testing;
