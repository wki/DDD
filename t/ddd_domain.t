use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";

use ok 'Demo::Domain';

{
    package My::Schema;
    use Moose;
    
    package My::Storage;
    use Moose;
}

my $schema  = My::Schema->new;
my $storage = My::Storage->new;
my $domain  = Demo::Domain->new(schema => $schema, storage => $storage);

# base class assigned by DSL.
isa_ok $domain, 'DDD::Base::Domain';

is $domain->domain,  $domain,  'domain reflects to itself';
is $domain->schema,  $schema,  'schema can get retrieved';
is $domain->storage, $storage, 'storage can get retrieved';

isa_ok $domain->test_service, 'Demo::Domain::TestService';
isa_ok $domain->test_service, 'DDD::Base::Service';

is $domain->test_service, $domain->test_service, 'test_service service always returns the same object';
is $domain->test_service->domain,  $domain,  'domain can get retrieved';
is $domain->test_service->schema,  $schema,  'test_service knows schema';
is $domain->test_service->storage, $storage, 'test_service knows storage';

done_testing;
