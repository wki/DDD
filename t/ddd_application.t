use Test::Most;

use ok 'DDD::Application';

use DDD::Application;

# checking only the required keywords. actually we export more.
can_ok 'main', qw(has service dep);

done_testing;
