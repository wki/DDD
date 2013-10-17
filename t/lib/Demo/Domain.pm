package Demo::Domain;
use DDD::Domain;

has schema  => (is => 'ro', isa => 'Object');
has storage => (is => 'ro', isa => 'Object');

repository test_repository => (
    isa => 'TestRepository',
);

factory test_factory => (
    isa => 'TestFactory',
);

service test_service => (
    isa          => 'TestService',
    dependencies => {
        schema  => dep('/schema'),
        storage => dep('/storage'),
    },
);

subdomain part => (
    isa => 'Part',
    dependencies => {
        foo => dep('/storage'),
    },
);

application;

1;
