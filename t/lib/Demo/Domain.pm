package Demo::Domain;
use DDD::Domain;

has schema   => (is => 'ro', isa => 'Object');
has storage  => (is => 'ro', isa => 'Object');
has security => (is => 'ro', isa => 'Str', lifecycle => 'Request');

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

service short_lived => (
    lifecycle => 'Request',
);

subdomain part => (
    isa => 'Part',
    dependencies => {
        foo => dep('/storage'),
    },
);

application;

1;
