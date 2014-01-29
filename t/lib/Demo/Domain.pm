package Demo::Domain;
use DDD::Domain;

has schema   => (is => 'ro', isa => 'Object');
has storage  => (is => 'ro', isa => 'Object');
has security => (is => 'ro', isa => 'Str', lifecycle => '+DDD::LifeCycle::Request');

repository 'test_repository';

factory 'test_factory';

aggregate 'something';

service test_service => (
    isa          => 'TestService',
    dependencies => {
        schema  => dep('/schema'),
        storage => dep('/storage'),
    },
);

# FIXME: does it make sense to have Request-based services???
# service short_lived => (
#     # lifecycle => '+DDD::LifeCycle::Request',
# );

subdomain part => (
    isa => 'Part',
    dependencies => {
        foo => dep('/storage'),
    },
);

application;

1;
