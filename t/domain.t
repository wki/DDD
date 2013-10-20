use Test::Most;
use Test::Output;
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

note 'debugging';
{
    stdout_is
        sub { $domain->log_debug(foo => 'bar') },
        '',
        'no output when debugging is disabled';

    stdout_is
        sub { $domain->log_debug('' => 'bar') },
        '',
        'no output when no area is given';

    $domain->_debug->{foo} = 1;
    stdout_is
        sub { $domain->log_debug(xxfoo => 'bar') },
        '',
        'no output for not wanted debug area';
    stdout_is
        sub { $domain->log_debug(foo => 'bar') },
        "DEBUG [foo]: bar\n",
        'output for wanted debug area';
    
    delete $domain->_debug->{foo};
    stdout_is
        sub { $domain->log_debug(foo => 'bar') },
        '',
        'no output after diabling debugging';
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

note 'lifecycle';
{
    # prepare sets _request_values
    is_deeply $domain->_request_values, {}, 'empty request values';
    $domain->prepare( { foo => 'bar42' } );
    is_deeply $domain->_request_values, { foo => 'bar42' }, 'set request values';
    
    # simulate first request, remember service object for comparison
    my $short_lived1 = $domain->short_lived;
    isa_ok $short_lived1, 'Demo::Domain::ShortLived';
    is $short_lived1, $domain->short_lived, 'same instance during request 1';
    
    # simulate end of request
    $domain->cleanup;
    is_deeply $domain->_request_values, {}, 'cleaned request values';
    
    # we must receive an new instance
    my $short_lived2 = $domain->short_lived;
    isa_ok $short_lived2, 'Demo::Domain::ShortLived';

    isnt $short_lived1, $short_lived2, 'new instance generated';
    is $short_lived2, $domain->short_lived, 'same instance during request 2';
}

done_testing;
