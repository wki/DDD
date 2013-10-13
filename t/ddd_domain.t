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
my $domain  = Demo::Domain->instance(
    schema  => $schema,
    storage => $storage,
);

note 'basic behavior';
{
    isa_ok $domain, 'DDD::Base::Domain';

    is $domain, Demo::Domain->instance, 'singleton';

    is $domain->domain,
        $domain,
        'domain reflects to itself';

    is $domain->schema,
        $schema,
        'schema can get retrieved';

    is $domain->storage,
        $storage,
        'storage can get retrieved';
}

note 'repository';
{
    isa_ok $domain->test_repository, 'Demo::Domain::TestRepository';
    isa_ok $domain->test_repository, 'DDD::Repository';

    is $domain->test_repository, 
        $domain->test_repository,
        '->test_respository always returns the same repository';
    
    is $domain->test_repository->domain,
        $domain,
        '->test_repository->domain reflects domain';
}

# done_testing; exit;

note 'factory';
{
    isa_ok $domain->test_factory, 'Demo::Domain::TestFactory';
    isa_ok $domain->test_factory, 'DDD::Factory';

    is $domain->test_factory, 
        $domain->test_factory,
        '->test_factory always returns the same factory';
    
    is $domain->test_factory->domain,
        $domain,
        '->factory->domain reflects domain';
}

note 'service';
{
    isa_ok $domain->test_service, 'Demo::Domain::TestService';
    isa_ok $domain->test_service, 'DDD::Base::Service';

    is $domain->test_service,
        $domain->test_service,
        '->test_service always returns the same object';

    is $domain->test_service->domain,
        $domain,
        '->test_service->domain reflects domain';

    is $domain->test_service->schema,
        $schema,
        'test_service knows schema';

    is $domain->test_service->storage,
        $storage,
        'test_service knows storage';
}

note 'subdomain';
{
    isa_ok $domain->part, 'Demo::Domain::Part';

    is $domain->part->domain, $domain, '->domain reflects domain';
}

done_testing;
